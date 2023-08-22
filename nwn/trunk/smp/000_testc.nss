void main()
{
    // AOE On Exit - C
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

    // Check effects on target
    object oTarget = GetExitingObject();
    string sCreator, sEffectId, sType, sSubtype;
    effect eCheck = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eCheck))
    {
        sCreator = GetName(GetEffectCreator(eCheck));
        sEffectId = IntToString(GetEffectSpellId(eCheck));
        sType = IntToString(GetEffectType(eCheck));
        sSubtype = IntToString(GetEffectSubType(eCheck));

        // Relay message
        SendMessageToPC(oCreator, "EXIT: EXITER: " + GetName(oTarget) + ". Creator: " + sCreator + ". Spell ID: " + sEffectId + ". Type: " + sType + ". Subtype: " + sSubtype + ".");

        eCheck = GetNextEffect(oTarget);
    }
}
