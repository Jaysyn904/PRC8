//::///////////////////////////////////////////////
//:: Sanctified Mind Partition Mind
//:: psi_smnd_prtmnd.nss
//::///////////////////////////////////////////////
/*
    Makes the Sanctified Mind immune to Mind Spells
    for a number of rounds equal to class + Cha
    
    once per day
*/
//:://////////////////////////////////////////////
//:: Modified By: Stratovarius
//:: Modified On: 17.2.2006
//:://////////////////////////////////////////////

#include "prc_alterations"

void main()
{

     object oPC = OBJECT_SELF;

     // Can't be immune to slow and use this ability     
     if (GetIsImmune(oPC, IMMUNITY_TYPE_SLOW))
     {
	// Removes effects
	PRCRemoveSpellEffects(GetSpellId(), oPC, oPC);
	FloatingTextStringOnCreature("*Immune to Slowing - Cannot use this Ability*", oPC, FALSE);
	IncrementRemainingFeatUses(oPC, FEAT_SANCMIND_PARTITION_MIND);
	return;
     }
     
     int nDur = GetLevelByClass(CLASS_TYPE_SANCTIFIED_MIND, oPC) + GetAbilityModifier(ABILITY_CHARISMA, oPC);
     // Minimum duration
     if (nDur < 1) nDur = 1;
  
     effect eImmune = EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);
     effect eSlow = EffectSlow();
     effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_POSITIVE);
     effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    
     effect eLink = EffectLinkEffects(eImmune, eVis);
     eLink = EffectLinkEffects(eLink, eSlow);
     eLink = EffectLinkEffects(eLink, eDur);
     // Can't dispel it
     ExtraordinaryEffect(eLink);
     ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, RoundsToSeconds(nDur));
}