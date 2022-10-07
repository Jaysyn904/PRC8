
void main()
{
    object oPC = OBJECT_SELF;
    int nWis = GetAbilityModifier(ABILITY_WISDOM, oPC);
    if(nWis < 1) nWis = 1;

    effect eAC = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
           eAC = EffectLinkEffects(eAC, EffectACIncrease(4, AC_ARMOUR_ENCHANTMENT_BONUS));
           eAC = EffectLinkEffects(eAC, EffectSavingThrowIncrease(SAVING_THROW_ALL, 4));
           eAC = EffectLinkEffects(eAC, EffectSpellResistanceIncrease(25));
           eAC = SupernaturalEffect(eAC);

    effect eVFX = EffectVisualEffect(VFX_IMP_AC_BONUS);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAC, oPC, RoundsToSeconds(nWis));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oPC);
}