//::///////////////////////////////////////////////
//:: PRC On Player GUI
//:: prc_onplayergui
//:://////////////////////////////////////////////
/*
    This is the logic for the On Player GUI event script
*/
//:://////////////////////////////////////////////
//:: Created By: Rakiov
//:: Created On: 28.11.2025
//:://////////////////////////////////////////////

#include "nw_inc_nui"
#include "prc_nui_consts"

void main()
{
    // Event variables
    object oPlayer = GetLastGuiEventPlayer();
    int nEventType = GetLastGuiEventType();
    int nEventInteger = GetLastGuiEventInteger();
    object oEventObject = GetLastGuiEventObject();

    if (nEventType == GUIEVENT_EFFECTICON_CLICK)
    {
            int windowId = NuiFindWindow(oPlayer, DURATION_NUI_WINDOW_ID);
            if (!windowId)
            {
                SetScriptParam(NUI_DURATION_MANUALLY_OPENED_PARAM, "1");
                ExecuteScript("prc_nui_dur_view", oPlayer);
            }
    }
}
