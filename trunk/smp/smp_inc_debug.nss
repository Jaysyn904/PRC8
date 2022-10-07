/*:://////////////////////////////////////////////
//:: Name Debug Include
//:: FileName SMP_INC_DEBUG
//:://////////////////////////////////////////////
//:: Notes
//:://////////////////////////////////////////////
    Debug include.

    Has a few debug things.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

// SMP_INC_DEBUG. Send sString to first PC
void SMP_Debug(string sString);

// SMP_INC_DEBUG. Reports each effect on oObject, to the first PC
void SMP_DebugReportEffects(object oObject);


// SMP_INC_DEBUG. Send sString to first PC
void SMP_Debug(string sString)
{
    object oPC = GetFirstPC();
    SendMessageToPC(oPC, sString);
}

// SMP_INC_DEBUG. Reports each effect on oObject, to the first PC
void SMP_DebugReportEffects(object oObject)
{
    object oReport = GetFirstPC();
    string sCreator, sEffectId, sType, sSubtype;
    effect eCheck = GetFirstEffect(oObject);
    SendMessageToPC(oReport, "EFFECTS ON: " + GetName(oObject));
    while(GetIsEffectValid(eCheck))
    {
        sCreator = GetName(GetEffectCreator(eCheck));
        sEffectId = IntToString(GetEffectSpellId(eCheck));
        sType = IntToString(GetEffectType(eCheck));
        sSubtype = IntToString(GetEffectSubType(eCheck));

        // Relay message
        SendMessageToPC(oReport, "EFFECT: [Creator: " + sCreator + "] [Spell ID: " + sEffectId + "] [Type: " + sType + "] [Subtype: " + sSubtype + "]");

        eCheck = GetNextEffect(oObject);
    }
}

// End of file Debug lines. Uncomment below "/*" with "//" and compile.
/*
void main()
{
    return;
}
//*/
