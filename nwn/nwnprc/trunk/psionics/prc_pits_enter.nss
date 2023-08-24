void main()
{
    object oTarget = GetObjectByTag("PRC_Temptation");
    effect eAppear = EffectDisappear();
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eAppear, oTarget);

    oTarget = GetObjectByTag("PRC_Compassion");
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eAppear, oTarget);
}
