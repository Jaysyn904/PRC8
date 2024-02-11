/*
    Ollam's Inspire Resilience
*/

#include "prc_alterations"
#include "prc_inc_spells"

void main()
{
    object oTarget = PRCGetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_SONIC);

    if (MyPRCGetRacialType(oTarget) == RACIAL_TYPE_DWARF)
    {
        effect eLink = EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING, 5);
        eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_PIERCING, 5));
        eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_SLASHING, 5));
        eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_FORT, 4));
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 60.0);
    }
    else
    {
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSavingThrowIncrease(SAVING_THROW_FORT, 2), oTarget, 60.0);
        DelayCommand(60.0, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectShaken(), oTarget, 60.0));
    }

    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}

