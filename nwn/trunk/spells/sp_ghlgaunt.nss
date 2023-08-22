/*
    sp_ghlgaunt

    Ghoul Gauntlet
    Necromancy [Death, Evil]
    Level: Sorcerer/Wizard 6
    Components: V,S
    Casting Time: 1 Standard Action
    Range: Touch
    Target: 1 Living Creature
    Duration: Instantaneous
    Saving Throw: Fortitude Negates
    Spell Resistance: Yes


    Your touch gradually transforms a living victim into
    a ravening, flesh-eating ghoul. The transformation
    process begins at the limb or extremity (usually the
    hand or arm) touched. The victim takes 3d6 points of
    damage per round while the body slowly dies as it is
    transformed into a ghoul’s cold undying flesh. When
    the victim reaches 0 hit points, she becomes a ghoul,
    body and mind.

    If the victim fails her initial saving throw, cure
    disease, dispel magic, heal, limited wish, miracle,
    mordenkainen's disjunction, remove curse, wish, or
    greater restoration negates the gradual change.
    Healing spells may temporarily prolong the process
    by increasing the victims HP, but the transformation
    continues unabated.

    The ghoul that you create remains under your control
    indefinitely. No matter how many ghouls you generate
    with this spell, however, you can control only 2 HD
    worth of undead creatures per caster level (this
    includes undead from all sources under your control).
    If you exceed this number, all the newly created
    creatures fall under your control, and any excess
    undead from previous castings become uncontrolled
    (you choose which creatures are released). If you are
    a cleric, any undead you might command by virtue of
    your power to command or rebuke undead do not count
    towards the limit.

    By: Tenjac
    Created: 11/07/05 (Nov 7, 2005?)
    Modified: Jul 2, 2006

    Cleaned up a bit

    To Tenjac:
        converted to holding the charge
        eliminated a lot of white space
        made SummonGhoul() *slightly* more efficient
            (won't set string sGhoul multiple times any more)
        eliminated nHP argument for Gauntlet()
            (GetCurrentHitPoints() is called anyway, makes no difference)
        moved HAS_GAUNTLET local int setting
            (only needs to be set once, right?)
        HAS_GAUNTLET local int is deleted when ghoul is summoned
            (in case you cast this spell on something ressable, eg. PC
                sounds silly, but there it is)
        eliminated excess variables, put some code inline
*/

#include "prc_sp_func"
#include "prc_inc_sp_tch"
#include "prc_add_spell_dc"

void SummonGhoul(int nHD, object oTarget, object oPC, location lCorpse, int nCasterLevel)
{
    string sGhoul;
    int nGhoulHD;
    if(nHD > 14)//Ghoul King if 15 or better
    {
        sGhoul = "X2_S_GHOUL_16";
        nGhoulHD = 16;
    }    
    else if(nHD > 11)//Ghoul Ravager if 12 - 14
    {    
        sGhoul = "S_GHOULRAVAGER";
        nGhoulHD = 9;
    }    
    else if(nHD > 8)//Ghoul Lord if levels 9 - 11
    {
        sGhoul = "S_GHOULLORD";
        nGhoulHD = 6;
    }
    else if(nHD > 5)//Ghast if levels 6 - 8
    {
        sGhoul = "NW_S_GHAST";
        nGhoulHD = 4;
    }    
    else
    {
        sGhoul = "NW_S_GHOUL";
        nGhoulHD = 2;
    }    


    MultisummonPreSummon();
    effect eSummon = EffectSummonCreature(sGhoul, VFX_FNF_SUMMON_UNDEAD);
    //Check for controlled undead and limit
    if(GetPRCSwitch(PRC_PNP_ANIMATE_DEAD))
    {
        int nMaxHD = nCasterLevel*4;
        //note GG says 2, animate dead is 4
        //not sure what the "correct" solution is
        //using 4x here otherwise casting order starts to matter
        int nTotalHD = GetControlledUndeadTotalHD();
        if((nTotalHD+nHD)<=nMaxHD)
        {        
            //eSummon = ExtraordinaryEffect(eSummon); //still goes away on rest, use supernatural instead
            eSummon = SupernaturalEffect(eSummon);    
            ApplyEffectAtLocation(DURATION_TYPE_PERMANENT, eSummon, PRCGetSpellTargetLocation());
        }
        else
        {
            FloatingTextStringOnCreature("You cannot create more undead at this time.", OBJECT_SELF);
        }
        FloatingTextStringOnCreature("Currently have "+IntToString(nTotalHD+nHD)+"HD out of "+IntToString(nMaxHD)+"HD.", OBJECT_SELF);    
    }
    //else if(!GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC))) Not sure why this is here.
    else
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, PRCGetSpellTargetLocation(), HoursToSeconds(24));
}

void Gauntlet(object oTarget, object oPC, int nHD, int nCasterLevel)
{
    //deal damage
    int nDam = SpellDamagePerDice(oPC, 3) + d6(3);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_MAGICAL), oTarget);
    //if target still has HP, run again on next round.  Avoids use of loop.
    if(GetCurrentHitPoints(oTarget) > 1)
        DelayCommand(6.0f, Gauntlet(oTarget, oPC, nHD, nCasterLevel));
    else
    {
        DeleteLocalInt(oTarget, "HAS_GAUNTLET");
        //Get location of corpse
        location lCorpse = GetLocation(oTarget);
        //Apply VFX
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_DUR_SMOKE), lCorpse);
        //Summon a ghoul henchman
        SummonGhoul(nHD, oTarget, oPC, lCorpse, nCasterLevel);
    }
}

//Implements the spell impact, put code here
//  if called in many places, return TRUE if
//  stored charges should be decreased
//  eg. touch attack hits
//
//  Variables passed may be changed if necessary
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)
{
    PRCSignalSpellEvent(oTarget, TRUE, SPELL_GHOUL_GAUNTLET, oCaster);
    if(GetLocalInt(oTarget, "HAS_GAUNTLET"))
    {
        return TRUE;
    }
    // Gotta be a living critter
    if (!PRCGetIsAliveCreature(oTarget))
    {
        return TRUE;
    }
    int iAttackRoll = PRCDoMeleeTouchAttack(oTarget);
    if(iAttackRoll)
    {
        //Spell Resistance
        if (!PRCDoResistSpell(oCaster, oTarget, nCasterLevel + SPGetPenetr()))
        {
            int nDC = PRCGetSaveDC(oTarget, oCaster);
            //Saving Throw
            if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_EVIL))
            {
                if(!GetPlotFlag(oTarget))
                {
                    SetLocalInt(oTarget, "HAS_GAUNTLET", 1);
                    ApplyTouchAttackDamage(oCaster, oTarget, iAttackRoll, 0, DAMAGE_TYPE_NEGATIVE);
                    Gauntlet(oTarget, oCaster, GetHitDice(oTarget), nCasterLevel);
                }
            }
        }
    }

    return iAttackRoll;    //return TRUE if spell charges should be decremented
}

void main()
{
    object oCaster = OBJECT_SELF;
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    PRCSetSchool(GetSpellSchool(PRCGetSpellId()));
    if (!X2PreSpellCastCode()) return;
    object oTarget = PRCGetSpellTargetObject();
    int nEvent = GetLocalInt(oCaster, PRC_SPELL_EVENT); //use bitwise & to extract flags
    if(!nEvent) //normal cast
    {
        //SPEvilShift(oCaster);
        if(GetLocalInt(oCaster, PRC_SPELL_HOLD) && oCaster == oTarget)
        {   //holding the charge, casting spell on self
            SetLocalSpellVariables(oCaster, 1);   //change 1 to number of charges
            return;
        }
        DoSpell(oCaster, oTarget, nCasterLevel, nEvent);
    }
    else
    {
        if(nEvent & PRC_SPELL_EVENT_ATTACK)
        {
            if(DoSpell(oCaster, oTarget, nCasterLevel, nEvent))
                DecrementSpellCharges(oCaster);
        }
    }
    PRCSetSchool();
}