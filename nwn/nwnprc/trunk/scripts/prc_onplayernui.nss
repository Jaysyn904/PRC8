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
#include "prc_nui_mr_const"
#include "prc_nui_rb_const"
#include "prc_nui_moi_cst"
#include "prc_nui_moi_lc"
#include "prc_nui_bnd_cst"
#include "prc_nui_psi_cst"

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

    // Handle the staged base-initiator maneuver readying editor.
    if(sWindowId == PRC_MANEUVER_READY_NUI_WINDOW_ID)
        ExecuteScript("prc_nui_mr_event");

    // Handle immediate Runescarred body-location scribing separately from
    // the live casting view in /sb.
    if(sWindowId == PRC_RUNESCAR_SCRIBE_NUI_WINDOW_ID)
        ExecuteScript("prc_nui_rb_event");

    if(sWindowId == PRC_MOI_LOADOUT_NUI_WINDOW_ID)
        ExecuteScript("prc_nui_moi_ev");

    if(sWindowId == PRC_MOI_BLADE_NUI_WINDOW_ID)
        ExecuteScript("prc_nui_moi_be");

    // Parallel live allocation UI.  The legacy Incarnum conversations remain
    // available through their original feats and scripts.
    if(sWindowId == PRC_MOI_LIVE_NUI_WINDOW_ID)
        ExecuteScript("prc_nui_moi_le");

    // Optional pact-management companion launched from the Binder /sb tab.
    // The original Binder conversations remain available and unchanged.
    if(sWindowId == PRC_BINDER_NUI_WINDOW_ID)
        ExecuteScript(PRC_BINDER_NUI_EVENT_SCRIPT);

    // Optional psionic configuration companion launched from psionic /sb tabs.
    if(sWindowId == PRC_NUI_PSI_WINDOW_ID)
        ExecuteScript(PRC_NUI_PSI_EVENT_SCRIPT);

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
