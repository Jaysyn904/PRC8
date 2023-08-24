/*
    prc_hexbl_unluck

    Hexblade gains 20% concealment
*/

void main()
{
    //Declare major variables
    object oCaster = OBJECT_SELF;
    float fDuration = RoundsToSeconds(3 + GetAbilityModifier(ABILITY_CHARISMA, oCaster));
    effect eShield = EffectLinkEffects(EffectConcealment(20), EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
           eShield = SupernaturalEffect(eShield);
    effect eVis    = EffectVisualEffect(VFX_IMP_AC_BONUS);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShield, oCaster, fDuration);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oCaster);
}