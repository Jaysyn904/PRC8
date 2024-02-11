//::///////////////////////////////////////////////
//:: Name      Rapture of Rupture
//:: FileName  sp_rapt_rupt.nss
//:://////////////////////////////////////////////
/** @file
Rapture of Rupture
Transmutation [Evil]
Level: Corrupt 7
Components: V, S, Corrupt
Casting Time: 1 action
Range: Touch
Target: One living creature touched per level
Duration: Instantaneous
Saving Throw: Fortitude half
Spell Resistance: Yes

With this spell, the caster's touch deals grievous
wounds to multiple targets. After rapture of rupture
is cast, the caster can touch one target per round
until she has touched a number of targets equal to
her caster level. The same creature cannot be
affected twice by the same rapture of rupture. A
creature with no discernible anatomy is unaffected by
this spell.

When the caster touches a subject, his flesh bursts
open suddenly in multiple places. Each subject takes
6d6 points of damage and is stunned for 1 round; a
successful Fortitude save reduces damage by half and
negates the stun effect. Subjects who fail their
Fortitude save continue to take 1d6 points of damage
per round until they receive magical healing, succeed
at a Heal check (DC 20), or die. If a subject takes 6
points of damage from rapture of rupture in a single
round, he is stunned in the following round.

Corruption Cost: 1 point of Strength damage per target
touched.

*/
//  Author:   Tenjac
//  Created:  5/31/2006
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_sp_tch"
#include "prc_sp_func"
#include "prc_add_spell_dc"

int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent, string sScript);
void WoundLoop(object oTarget, object oCaster, int nDamage = 0);


void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);

    object oCaster = OBJECT_SELF;
    int nCasterLevel = PRCGetCasterLevel(oCaster);

    /*if(GetRunningEvent() == EVENT_VIRTUAL_ONDAMAGED)
    {
        ConcentrationLossCode(oCaster, GetLocalObject(oCaster, PRC_SPELL_CONC_TARGET), nCasterLevel);
        return;
    }*/

    object oTarget = PRCGetSpellTargetObject();
    int nSpellID = GetSpellId();
    string sScript = Get2DACache("spells", "ImpactScript", nSpellID);

    int nEvent = GetLocalInt(oCaster, PRC_SPELL_EVENT); //use bitwise & to extract flags
    if(!nEvent) //normal cast
    {
        if(GetLocalInt(oCaster, PRC_SPELL_HOLD) && oCaster == oTarget)
        {   //holding the charge, casting spell on self
            SetLocalSpellVariables(oCaster, PRCGetCasterLevel(oCaster));

            // Setup target tracking set. If one remains from a previous casting, delete it first
            if(set_exists(oCaster, "PRC_Spell_RoRTargets"))
                set_delete(oCaster, "PRC_Spell_RoRTargets");
            set_create(oCaster, "PRC_Spell_RoRTargets");

            return;
        }
        DoSpell(oCaster, oTarget, nCasterLevel, nEvent, sScript);
    }
    else
    {
        if(nEvent & PRC_SPELL_EVENT_ATTACK)
        {
            if(DoSpell(oCaster, oTarget, nCasterLevel, nEvent, sScript))
                DecrementSpellCharges(oCaster);
        }
    }
    
   //SPEvilShift(oCaster);
   
   //Corrupt spells get mandatory 10 pt evil adjustment, regardless of switch
   AdjustAlignment(oCaster, ALIGNMENT_EVIL, 10, FALSE);

   PRCSetSchool();
}

//Implements the spell impact, put code here
//  if called in many places, return TRUE if
//  stored charges should be decreased
//  eg. touch attack hits
//
//  Variables passed may be changed if necessary
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent, string sScript)
{
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nSaveDC    = PRCGetSaveDC(oTarget, oCaster);
    int nPenetr    = nCasterLevel + SPGetPenetr();
    string sCaster = GetLocalString(oCaster, "PRCRuptureID");
    string sTest   = GetLocalString(oTarget, "PRCRuptureTargetID");

    // Roll to hit
    int iAttackRoll = PRCDoMeleeTouchAttack(oTarget);
    if (iAttackRoll > 0)
    {
        // Target validity check - should not have been targeted before
        // and should have discernible anatomy (excludes constructs, elementals, oozes, plants, undead)
        int nRace = MyPRCGetRacialType(oTarget);
        if(!set_contains_object(oCaster, "PRC_Spell_RoRTargets", oTarget) &&
           nRace != RACIAL_TYPE_CONSTRUCT                                 &&
           nRace != RACIAL_TYPE_ELEMENTAL                                 &&
           nRace != RACIAL_TYPE_OOZE                                      &&
           //nRace != RACIAL_TYPE_PLANT                                     &&
           nRace != RACIAL_TYPE_UNDEAD
           )
        {
            if(!PRCDoResistSpell(oCaster, oTarget, nPenetr))
            {
                // Roll damage and apply metamagic
                int nDam = d6(6);
                if(nMetaMagic & METAMAGIC_MAXIMIZE)
                    nDam = 36;
                if(nMetaMagic & METAMAGIC_EMPOWER)
                    nDam += nDam / 2;
				nDam += SpellDamagePerDice(oCaster, 6);
                // Save for half damage
                if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nSaveDC, SAVING_THROW_TYPE_EVIL))
                {
                    nDam /=  2;

                    // If the target has Mettle, do no damage. However, the target will still count as having been affected by the spell
    		        if (GetHasMettle(oTarget, SAVING_THROW_FORT))
    			        nDam = 0;
                }
                // On failed save, stun for a round and start bleeding
                else
                {
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectStunned(), oTarget, 6.0f);
                    WoundLoop(oTarget, oCaster); // Init the wound loop. This will deal d6 damage, which in turn determines whether the target will be stunned again next round
                }

                // Apply Damage
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_MAGICAL), oTarget);

                // If this spell was a held charge, it can have multiple targets. So we need to keep track of who has been already affected
                if(nEvent)
                    set_add_object(oCaster, "PRC_Spell_RoRTargets", oTarget);
            }
        }

        // Corruption cost is paid whenever something is hit
        DoCorruptionCost(oCaster, ABILITY_STRENGTH, 1, 0);
    }

    // Return the result of the touch attack, will be used to determine whether to reduce number of touch attacks remaining
    return iAttackRoll;
}

void WoundLoop(object oTarget, object oCaster, int nDamage = 0)
{
    // If previous round's damage roll was 6, stun this round
    if(nDamage == 6)
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectStunned(), oTarget, 6.0f);

    // Roll and apply new damage
    nDamage = d6();
    nDamage += SpellDamagePerDice(oCaster, 1);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDamage, DAMAGE_TYPE_MAGICAL), oTarget);

    DelayCommand(6.0f, WoundLoop(oTarget, oCaster, nDamage));
}
