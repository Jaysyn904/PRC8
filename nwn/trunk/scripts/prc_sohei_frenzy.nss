/////////////////////////////////////////////////
// Sohei Frenzy
//-----------------------------------------------
// Created By: Stratovarius
/////////////////////////////////////////////////

#include "prc_alterations"

void main()
{
    // The pile of effects that are given to the Sohei when it frenzies
    // -2 AB, +2 Dex/Str, +1 Attack, +10 feet per round, and can't cast spells
    effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, 2);
    effect eDex = EffectAbilityIncrease(ABILITY_DEXTERITY, 2);
    effect eMov = EffectMovementSpeedIncrease(33);
    effect eAtk = EffectModifyAttacks(1);
    effect eAB  = EffectAttackDecrease(2);
    effect eSpell = EffectSpellFailure(100);
    effect eLink = EffectLinkEffects(eStr, eDur);
    eLink = EffectLinkEffects(eLink, eDex);
    eLink = EffectLinkEffects(eLink, eMov);
    eLink = EffectLinkEffects(eLink, eAtk);
    eLink = EffectLinkEffects(eLink, eAB);
    eLink = EffectLinkEffects(eLink, eSpell);
    
    eLink = ExtraordinaryEffect(eLink);
    int nDur = (GetAbilityModifier(ABILITY_CONSTITUTION, OBJECT_SELF) + 3);

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, RoundsToSeconds(nDur));
    
    DelayCommand(RoundsToSeconds(nDur), ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectFatigue(), OBJECT_SELF, RoundsToSeconds(nDur)));
}