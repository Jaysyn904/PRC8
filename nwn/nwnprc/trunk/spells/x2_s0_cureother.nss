//::///////////////////////////////////////////////
//:: x2_s0_cureother
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Cure Critical Wounds on Others - causes 5 points
    of damage to the spell caster as well.
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: Jan 2/03
//:://////////////////////////////////////////////

//:: modified by mr_bumpkin Dec 4, 2003 for prc stuff

#include "prc_inc_sp_tch"
#include "prc_inc_function"
#include "prc_add_spell_dc"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);

    /*
      Spellcast Hook Code
      Added 2003-07-07 by Georg Zoeller
      If you want to make changes to all spells,
      check x2_inc_spellhook.nss to find out more

    */

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    // End of Spell Cast Hook


    //Declare major variables
    object oTarget = PRCGetSpellTargetObject();
    int nHeal;
    int nDamage = d8(4);
    int nMetaMagic = PRCGetMetaMagicFeat();
    effect eVis = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
    effect eVis2 = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);
    effect eHeal, eDam;
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);

    int nExtraDamage = CasterLvl; // * figure out the bonus damage
    if (nExtraDamage > 20)
    {
        nExtraDamage = 20;
    }
    // * if low or normal difficulty is treated as MAXIMIZED
    if(GetIsPC(oTarget) && GetGameDifficulty() < GAME_DIFFICULTY_CORE_RULES)
    {
        nDamage = 32 + nExtraDamage;
    }
    else
    {
        nDamage = nDamage + nExtraDamage;
    }

    CasterLvl +=SPGetPenetr();
    //Make metamagic checks
    int iBlastFaith = BlastInfidelOrFaithHeal(OBJECT_SELF, oTarget, DAMAGE_TYPE_POSITIVE, TRUE);
    if ((nMetaMagic & METAMAGIC_MAXIMIZE) || iBlastFaith)
    {
        nDamage = 32 + nExtraDamage;
        // * if low or normal difficulty then MAXMIZED is doubled.
        if(GetIsPC(OBJECT_SELF) && GetGameDifficulty() < GAME_DIFFICULTY_CORE_RULES)
        {
            nDamage = nDamage + nExtraDamage;
        }
    }
    if (nMetaMagic & METAMAGIC_EMPOWER)
    {
        nDamage = nDamage + (nDamage/2);
    }


    if (MyPRCGetRacialType(oTarget) != RACIAL_TYPE_UNDEAD
    && !(GetHasFeat(FEAT_TOMB_TAINTED_SOUL, oTarget) && GetAlignmentGoodEvil(oTarget) != ALIGNMENT_GOOD))
    {
        if (oTarget != OBJECT_SELF)
        {
            //Figure out the amount of damage to heal
            nHeal = nDamage;
            //Set the heal effect
            eHeal = PRCEffectHeal(nHeal, oTarget);
            //Apply heal effect and VFX impact
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);

            //Apply Damage Effect to the Caster
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, 5), OBJECT_SELF);
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 31, FALSE));
        }

    }
    //Check that the target is undead
    else
    {
        int nTouch = PRCDoMeleeTouchAttack(oTarget);;
        if (nTouch > 0)
        {
            if(!GetIsReactionTypeFriendly(oTarget))
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 31));
                if (!PRCDoResistSpell(OBJECT_SELF, oTarget,CasterLvl))
                {
                	nDamage += SpellDamagePerDice(OBJECT_SELF, 4);
                    eDam = PRCEffectDamage(oTarget, nDamage,DAMAGE_TYPE_NEGATIVE);
                    //Apply the VFX impact and effects
                    DelayCommand(1.0, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                }
            }
            //Apply Damage Effect to the Caster
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, 5), OBJECT_SELF);
        }
    }


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school
}




