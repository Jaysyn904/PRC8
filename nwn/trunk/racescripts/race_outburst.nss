/* Outburst racial ability for Maenads
   -2 Int and Wis and +2 Str for 4 rounds.*/

//#include "prc_alterations"

void main()
{
    object oPC = OBJECT_SELF;

    effect eAbilDec = EffectAbilityDecrease(ABILITY_INTELLIGENCE, 2);
    effect eAbilDec2 = EffectAbilityDecrease(ABILITY_WISDOM, 2);
    effect eAbilInc = EffectAbilityIncrease(ABILITY_STRENGTH, 2);
    effect eVis = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eAbilDec, eAbilDec2);
           eLink = EffectLinkEffects(eLink, eAbilInc);
           eLink = EffectLinkEffects(eLink, eVis);

    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HOLY_AID), oPC);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, RoundsToSeconds(4));
}