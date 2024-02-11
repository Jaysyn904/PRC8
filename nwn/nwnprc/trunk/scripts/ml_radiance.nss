void main()
{
    //Declare major variables
    object oPC = OBJECT_SELF;
    effect eRadiance = EffectVisualEffect(VFX_DUR_ULTRAVISION);
    effect eUltra = EffectUltravision();
    effect eAC = EffectACIncrease(2,AC_DODGE_BONUS);
    eAC = VersusRacialTypeEffect(eAC,RACIAL_TYPE_UNDEAD);
    effect eLink = EffectLinkEffects(eRadiance, eUltra);
    eLink = EffectLinkEffects(eLink, eAC);
    SupernaturalEffect(eLink);
    ApplyEffectToObject(2,eLink,OBJECT_SELF);
}
