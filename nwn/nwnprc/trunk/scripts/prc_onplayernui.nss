//::///////////////////////////////////////////////
//:: NUI Events
//:: prc_onplayernui (hp_nui_events)
//:://////////////////////////////////////////////
/*
    This handles any NUI events and sends them to
    appropriate NUI Event handler depending on the
    window Id
*/
//:://////////////////////////////////////////////
//:: Created By: Rakiov
//:: Created On: 22.05.2005
//:://////////////////////////////////////////////

#include "prc_nui_consts"

void main()
{
    object oPlayer   = NuiGetEventPlayer();
    int nToken               = NuiGetEventWindow();
    string sWindowId = NuiGetWindowId(oPlayer, nToken);

    // Open the Power Attack NUI
    if(sWindowId == NUI_PRC_POWER_ATTACK_WINDOW)
        ExecuteScript("prc_nui_pa_event");

    // Open the Spellbook NUI
    if(sWindowId == PRC_SPELLBOOK_NUI_WINDOW_ID)
        ExecuteScript("prc_nui_sb_event");

    // Handle Archivist next-rest preparation separately from live casting.
    if(sWindowId == PRC_ARCHIVIST_PREP_NUI_WINDOW_ID)
        ExecuteScript("prc_nui_ap_event");

    if (sWindowId == NUI_SPELL_DESCRIPTION_WINDOW_ID)
        ExecuteScript("prc_nui_dsc_evnt");

    if (sWindowId == NUI_LEVEL_UP_WINDOW_ID)
        ExecuteScript("prc_nui_lv_event");

    if (sWindowId == DURATION_NUI_WINDOW_ID)
        ExecuteScript("prc_nui_sd_event");

    if (sWindowId == NUI_PRC_RESOURCE_WINDOW)
        ExecuteScript("prc_nui_rs_event");

    return;
}
