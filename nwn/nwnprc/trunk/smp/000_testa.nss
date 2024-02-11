void main()
{
    // AOE On Enter - a
    object oCreator = GetAreaOfEffectCreator(OBJECT_SELF);

    // Check spell Id, ETC:
    int nSpellId = GetSpellId();
    int nActual = SPELL_FIREBALL;

    // Get save DC:
    int nSpellSaveDC = GetSpellSaveDC();

    // Get caster level
    int nCasterLevel = GetCasterLevel(oCreator);

    // Get tag
    string sTag = GetTag(OBJECT_SELF);
    string sName = GetName(OBJECT_SELF);
    string sResRef = GetResRef(OBJECT_SELF);

    // We relay the information.
    SendMessageToPC(oCreator, "ENTER (BLUE): (T: " + sTag + ")(N: " + sName + ")(RR: " + sResRef + "). ID1: " + IntToString(nSpellId) + ". ID2: " + IntToString(nActual) + ". SaveDC: " + IntToString(nSpellSaveDC) + ". CasterLevel: " + IntToString(nCasterLevel) + ".");

    // Apply an On Enter effect
    object oTarget = GetEnteringObject();
    effect eDur = EffectVisualEffect(VFX_DUR_IOUNSTONE_BLUE);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDur, oTarget);
}
