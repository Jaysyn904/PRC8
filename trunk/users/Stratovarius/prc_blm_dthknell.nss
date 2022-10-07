//::///////////////////////////////////////////////
//:: Death Knell
//:: prc_blm_dthknell.nss
//:://////////////////////////////////////////////
/*
    If target creature with less than 10 HP fails save 
    caster gains 1d8 temp HP, +2 Str, and +1 Caster level
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: Sept 3, 2005
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_inc_spells"
#include "prc_alterations"

#include "prc_alterations"

void DeathKnellCheck(object oPC)
{
     if (!GetHasSpellEffect(2086, oPC)) // Death Knell
     {
         DeleteLocalInt(oPC, "DeathKnell");
     }
     else
     {
         DelayCommand(6.0, DeathKnellCheck(oPC));
     }
}

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_NECROMANCY);

    //Declare major variables
    object oTarget = PRCGetSpellTargetObject();
    int iHP = GetCurrentHitPoints(oTarget);
    int nCaster = PRCGetCasterLevel(OBJECT_SELF);
    int nDuration = nCaster;
    int nBonus = d8(1);
    int nPenetr = nCaster + SPGetPenetr();
    
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, 2);
    effect eHP = EffectTemporaryHitpoints(nBonus);

    effect eVis2 = EffectVisualEffect(VFX_IMP_DEATH_L);
    effect eVis = EffectVisualEffect(VFX_IMP_HOLY_AID);
    

    effect eLink = EffectLinkEffects(eStr, eDur);

       
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
    //Resist magic check
    
if (iHP < 10)
{    
    if(!PRCDoResistSpell(OBJECT_SELF, oTarget,nPenetr))
    {
        if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, PRCGetSaveDC(oTarget, OBJECT_SELF)))
        {
                //Apply the VFX impact and effects
                            DeathlessFrenzyCheck(oTarget);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
                
                
                //Apply the bonuses to the PC
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, TurnsToSeconds(nDuration),TRUE,-1,nCaster);
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP, OBJECT_SELF, TurnsToSeconds(nDuration),TRUE,-1,nCaster);
            SetLocalInt(OBJECT_SELF, "DeathKnell", TRUE);
                DelayCommand(9.0, DeathKnellCheck(OBJECT_SELF));
        }
    }

}
else
{
    FloatingTextStringOnCreature("*Death Knell failure: The target isn't weak enough*", OBJECT_SELF, FALSE);
}

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}