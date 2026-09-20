//::///////////////////////////////////////////////
//:: PRC Runescar Saved Set Actions
//:: prc_nui_rb_plan
//:://////////////////////////////////////////////

#include "prc_nui_rb_inc"

void main()
{
    object oPC = OBJECT_SELF;
    int nAction = GetLocalInt(oPC, PRC_RUNESCAR_DEFAULT_ACTION_VAR);
    DeleteLocalInt(oPC, PRC_RUNESCAR_DEFAULT_ACTION_VAR);

    if (!GetIsPC(oPC)
        || GetLevelByClass(CLASS_TYPE_RUNESCARRED, oPC) <= 0
        || !GetHasFeat(NUI_SPELLBOOK_RUNESCAR_SCRIBE_FEAT, oPC))
        return;

    string sMessage;
    if (nAction == PRC_RUNESCAR_DEFAULT_ACTION_SAVE)
    {
        sMessage = RunescarDefaultValidateCurrentSet(oPC);
        if (sMessage == "")
        {
            if (RunescarDefaultSaveCurrentSet(oPC))
                sMessage = "Saved your current seven runescars as the default set. Restoring it later still spends normal daily uses, gold, and XP and deals normal scribing damage.";
            else
                sMessage = "The current runescar set could not be saved.";
        }
    }
    else if (nAction == PRC_RUNESCAR_DEFAULT_ACTION_CLEAR)
    {
        if (RunescarDefaultHasSet(oPC))
        {
            RunescarDefaultClearSet(oPC);
            sMessage = "Cleared your saved runescar set.";
        }
        else
            sMessage = "You do not have a saved runescar set.";
    }
    else if (nAction == PRC_RUNESCAR_DEFAULT_ACTION_SCRIBE)
        sMessage = RunescarDefaultScribeSavedSet(oPC);
    else
        return;

    SendMessageToPC(oPC, sMessage);

    // Keep the existing /sb token and geometry.  The view replaces only its
    // stable content host and advances the normal layout generation.
    if (NuiFindWindow(oPC, PRC_SPELLBOOK_NUI_WINDOW_ID)
        && GetLocalInt(oPC, PRC_SPELLBOOK_SELECTED_MODE_VAR)
            == PRC_SPELLBOOK_MODE_CLASS
        && GetLocalInt(oPC, PRC_SPELLBOOK_SELECTED_CLASSID_VAR)
            == CLASS_TYPE_RUNESCARRED)
        ExecuteScript("prc_nui_sb_view", oPC);
}
