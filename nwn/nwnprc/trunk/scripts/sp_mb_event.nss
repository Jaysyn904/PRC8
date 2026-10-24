// Moonbeam removal only. Deliberately has no spellcasting/PRC include.
// A removed linked effect may no longer expose its tag. Inspect the surviving
// controller after the engine finishes removal instead of recasting anything.
void MoonbeamAfterRemoval(object oCaster, string sExpectedController)
{
    if(!GetIsObjectValid(oCaster)
        || GetLocalString(oCaster, "PRC_MOONBEAM_CONTROLLER") != sExpectedController)
        return;

    int nScanned;
    effect eTest = GetFirstEffect(oCaster);
    while(GetIsEffectValid(eTest) && nScanned < 4096)
    {
        if(GetEffectType(eTest) == EFFECT_TYPE_RUNSCRIPT
            && GetEffectTag(eTest) == sExpectedController)
            return;
        eTest = GetNextEffect(oCaster);
        nScanned++;
    }
    // An unexpectedly large effect list is not proof the controller is gone.
    if(GetIsEffectValid(eTest))
        return;

    DeleteLocalString(oCaster, "PRC_MOONBEAM_CONTROLLER");
    DeleteLocalFloat(oCaster, "PRC_MOONBEAM_FACING");
    DeleteLocalInt(oCaster, "PRC_MOONBEAM_REDIRECT_ACTIVE");
    DeleteLocalInt(oCaster, "PRC_MOONBEAM_REDIRECT_SERIAL");
    if(GetIsPC(oCaster) && NuiFindWindow(oCaster, "prcSpellbookNui"))
        ExecuteScript("prc_nui_sb_view", oCaster);
}

void main()
{
    if(GetLastRunScriptEffectScriptType() != RUNSCRIPT_EFFECT_SCRIPT_TYPE_ON_REMOVED)
        return;
    string sController = GetLocalString(OBJECT_SELF, "PRC_MOONBEAM_CONTROLLER");
    if(sController != "")
        DelayCommand(0.0f, MoonbeamAfterRemoval(OBJECT_SELF, sController));
}
