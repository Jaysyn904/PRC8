/*

    Gold        500
    XP          501
    XPSet       502
    Lawful      503
    Chaotic     504
    Good        505
    Evil        506
    Neutral     507
    LawfulSet   508
    ChaoticSet  509
    GoodSet     510
    EvilSet     511
    NeutralSet  512

*/


void main()
{
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY), OBJECT_SELF);

    SetListenPattern(OBJECT_SELF, "Gold *n",            500);
    SetListenPattern(OBJECT_SELF, "GP *n",              500);
    SetListenPattern(OBJECT_SELF, "Gold*n",             500);
    SetListenPattern(OBJECT_SELF, "GP*n",               500);

    SetListenPattern(OBJECT_SELF, "Experience *n",      501);
    SetListenPattern(OBJECT_SELF, "XP *n",              501);
    SetListenPattern(OBJECT_SELF, "Experience*n",       501);
    SetListenPattern(OBJECT_SELF, "XP*n",               501);

    SetListenPattern(OBJECT_SELF, "Set Experience *n",  502);
    SetListenPattern(OBJECT_SELF, "Set XP *n",          502);
    SetListenPattern(OBJECT_SELF, "Set Experience*n",   502);
    SetListenPattern(OBJECT_SELF, "Set XP*n",           502);

    SetListenPattern(OBJECT_SELF, "Lawful *n",          503);
    SetListenPattern(OBJECT_SELF, "Law *n",             503);
    SetListenPattern(OBJECT_SELF, "Lawful*n",           503);
    SetListenPattern(OBJECT_SELF, "Law*n",              503);

    SetListenPattern(OBJECT_SELF, "Chaotic *n",         504);
    SetListenPattern(OBJECT_SELF, "Chaos *n",           504);
    SetListenPattern(OBJECT_SELF, "Chaotic*n",          504);
    SetListenPattern(OBJECT_SELF, "Chaos*n",            504);

    SetListening(OBJECT_SELF, TRUE);
}
