//::///////////////////////////////////////////////
//:: Standalone psionic configuration NUI events
//:: prc_nui_psi_ev
//:://////////////////////////////////////////////

#include "prc_nui_psi_inc"
#include "prc_nui_consts"

void NUISpellbookPsiRememberGeometry(object oPC, int nToken)
{
    json jGeometry = NuiGetBind(oPC, nToken, "geometry");
    if (jGeometry != JsonNull())
        SetLocalJson(oPC, PRC_NUI_PSI_GEOMETRY_VAR, jGeometry);
}

void NUISpellbookPsiStandaloneRefresh(object oPC, int nToken)
{
    NUISpellbookPsiRememberGeometry(oPC, nToken);
    SetLocalInt(oPC, PRC_NUI_PSI_REBUILD_TOKEN_VAR, nToken);
    NuiDestroy(oPC, nToken);
    ExecuteScript(PRC_NUI_PSI_VIEW_SCRIPT, oPC);
}

void main()
{
    object oPC = NuiGetEventPlayer();
    int nToken = NuiGetEventWindow();
    string sEvent = NuiGetEventType();
    string sElement = NuiGetEventElement();

    if (NuiGetWindowId(oPC, nToken) != PRC_NUI_PSI_WINDOW_ID)
        return;
    if (sEvent == "watch" && sElement == "geometry")
    {
        if (NuiFindWindow(oPC, PRC_NUI_PSI_WINDOW_ID) == nToken)
            NUISpellbookPsiRememberGeometry(oPC, nToken);
        return;
    }
    if (sEvent == "closed" || sEvent == "close")
    {
        if (GetLocalInt(oPC, PRC_NUI_PSI_REBUILD_TOKEN_VAR) == nToken)
        {
            DeleteLocalInt(oPC, PRC_NUI_PSI_REBUILD_TOKEN_VAR);
            return;
        }
        int nCurrent = NuiFindWindow(oPC, PRC_NUI_PSI_WINDOW_ID);
        if (nCurrent && nCurrent != nToken)
            return;
        NUISpellbookPsiRememberGeometry(oPC, nToken);
        DeleteLocalInt(oPC, PRC_NUI_PSI_DEFAULT_CONFIRM_VAR);
        return;
    }
    if (sEvent != "mouseup"
        || NuiFindWindow(oPC, PRC_NUI_PSI_WINDOW_ID) != nToken)
        return;

    json jPayload = NuiGetEventPayload();
    int nButton = JsonGetInt(JsonObjectGet(jPayload, "mouse_btn"));
    if (nButton != NUI_PAYLOAD_BUTTON_LEFT_CLICK)
        return;

    int nGeneration = GetLocalInt(oPC, PRC_NUI_PSI_GENERATION_VAR);
    if (NUISpellbookPsiElementGeneration(sElement) != nGeneration)
        return;
    if (FindSubString(sElement, PRC_NUI_PSI_CLOSE_BUTTON) == 0)
    {
        if (NUISpellbookPsiElementValue(
                sElement, PRC_NUI_PSI_CLOSE_BUTTON
            ) != 0)
            return;
        NUISpellbookPsiRememberGeometry(oPC, nToken);
        DeleteLocalInt(oPC, PRC_NUI_PSI_DEFAULT_CONFIRM_VAR);
        NuiDestroy(oPC, nToken);
        return;
    }

    int nResult = NUISpellbookPsiHandleAction(
        oPC, sElement, nGeneration
    );
    if (nResult == PRC_NUI_PSI_ACTION_REFRESH)
        NUISpellbookPsiStandaloneRefresh(oPC, nToken);
}
