//::///////////////////////////////////////////////
//:: Slayer of Domiel Death Touch
//:: prc_sod_deathtch.nss
//::///////////////////////////////////////////////
/*
    Roll d6 per Slayer level. If it is equal or greater
    than the targets current Hitpoints, it dies.
    
    Only works on evil creatures
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: 27.2.2006
//:://////////////////////////////////////////////

#include "prc_alterations"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_IMP_DEATH_L);
    effect eDeath = EffectDeath();
    effect eLink = EffectLinkEffects(eDeath, eVis);
    int nHP = GetCurrentHitPoints(oTarget);
    int nRoll = d6(GetLevelByClass(CLASS_TYPE_SLAYER_OF_DOMIEL, oPC));
    
    // If the roll is greater or equal and you hit on a melee touch attack and the target is evil
    if (nRoll >= nHP && TouchAttackMelee(oTarget) > 0 && GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL) 
    	ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
}