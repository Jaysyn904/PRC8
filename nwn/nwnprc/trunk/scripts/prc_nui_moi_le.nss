//::///////////////////////////////////////////////
//:: Incarnum live essentia allocation events
//:: prc_nui_moi_le
//:://////////////////////////////////////////////

#include "prc_nui_moi_liv"
#include "prc_nui_consts"

void MoiLiveRememberGeometry(object oPC, int nToken)
{
    json jGeometry = NuiGetBind(oPC, nToken, "geometry");
    if (jGeometry != JsonNull())
        SetLocalJson(oPC, PRC_MOI_LIVE_GEOMETRY_VAR, jGeometry);
}

void MoiLiveRefresh(object oPC, int nToken)
{
    MoiLiveRememberGeometry(oPC, nToken);
    SetLocalInt(oPC, PRC_MOI_LIVE_REBUILD_TOKEN_VAR, nToken);
    NuiDestroy(oPC, nToken);
    ExecuteScript("prc_nui_moi_lv", oPC);
}

void MoiLiveReport(object oPC, string sError, string sSuccess)
{
    if (sError != "")
        SendMessageToPC(oPC, sError);
    else if (sSuccess != "")
        SendMessageToPC(oPC, sSuccess);
}

void main()
{
    object oPC = NuiGetEventPlayer();
    int nToken = NuiGetEventWindow();
    string sEvent = NuiGetEventType();
    string sElement = NuiGetEventElement();

    if (NuiGetWindowId(oPC, nToken) != PRC_MOI_LIVE_NUI_WINDOW_ID)
        return;
    if (sEvent == "watch" && sElement == "geometry")
    {
        if (NuiFindWindow(oPC, PRC_MOI_LIVE_NUI_WINDOW_ID) == nToken)
            MoiLiveRememberGeometry(oPC, nToken);
        return;
    }
    if (sEvent == "closed" || sEvent == "close")
    {
        if (GetLocalInt(oPC, PRC_MOI_LIVE_REBUILD_TOKEN_VAR) == nToken)
        {
            DeleteLocalInt(oPC, PRC_MOI_LIVE_REBUILD_TOKEN_VAR);
            return;
        }
        int nCurrent = NuiFindWindow(oPC, PRC_MOI_LIVE_NUI_WINDOW_ID);
        if (nCurrent && nCurrent != nToken)
            return;
        MoiLiveRememberGeometry(oPC, nToken);
        MoiLiveClearState(oPC);
        return;
    }
    if (sEvent != "mouseup"
        || NuiFindWindow(oPC, PRC_MOI_LIVE_NUI_WINDOW_ID) != nToken)
        return;

    int nGeneration = MoiLiveElementGeneration(sElement);
    if (nGeneration <= 0
        || nGeneration != GetLocalInt(oPC, PRC_MOI_LIVE_GENERATION_VAR))
        return;

    json jPayload = NuiGetEventPayload();
    int nButton = JsonGetInt(JsonObjectGet(jPayload, "mouse_btn"));
    if (nButton != NUI_PAYLOAD_BUTTON_LEFT_CLICK)
        return;

    if (FindSubString(sElement, PRC_MOI_LIVE_PAGE_BUTTON) == 0)
    {
        int nPage = MoiLiveElementValue(sElement, PRC_MOI_LIVE_PAGE_BUTTON);
        if (nPage < PRC_MOI_LIVE_PAGE_MOVABLE
            || nPage > PRC_MOI_LIVE_PAGE_SOULCASTER)
            return;
        SetLocalInt(oPC, PRC_MOI_LIVE_PAGE_VAR, nPage);
        MoiLiveRefresh(oPC, nToken);
        return;
    }

    if (FindSubString(sElement, PRC_MOI_LIVE_MOVABLE_DOWN_BUTTON) == 0
        || FindSubString(sElement, PRC_MOI_LIVE_MOVABLE_UP_BUTTON) == 0)
    {
        int bDown = FindSubString(
            sElement, PRC_MOI_LIVE_MOVABLE_DOWN_BUTTON
        ) == 0;
        string sBase = bDown
            ? PRC_MOI_LIVE_MOVABLE_DOWN_BUTTON
            : PRC_MOI_LIVE_MOVABLE_UP_BUTTON;
        string sError = MoiLiveAdjustMovable(
            oPC,
            MoiLiveElementValue(sElement, sBase),
            bDown ? -1 : 1
        );
        MoiLiveReport(oPC, sError, "");
        if (sError == "")
            MoiLiveRefresh(oPC, nToken);
        return;
    }

    if (FindSubString(sElement, PRC_MOI_LIVE_MOVABLE_APPLY_BUTTON) == 0)
    {
        string sError = MoiLiveApplyMovable(oPC);
        MoiLiveReport(oPC, sError, "Movable essentia allocation applied.");
        if (sError == "")
        {
            SetLocalJson(oPC, PRC_MOI_LIVE_DRAFT_VAR, MoiLiveBuildMovable(oPC));
            MoiLiveRefresh(oPC, nToken);
        }
        return;
    }

    if (FindSubString(sElement, PRC_MOI_LIVE_FEAT_DOWN_BUTTON) == 0
        || FindSubString(sElement, PRC_MOI_LIVE_FEAT_UP_BUTTON) == 0)
    {
        int bDown = FindSubString(sElement, PRC_MOI_LIVE_FEAT_DOWN_BUTTON) == 0;
        string sBase = bDown
            ? PRC_MOI_LIVE_FEAT_DOWN_BUTTON
            : PRC_MOI_LIVE_FEAT_UP_BUTTON;
        string sError = MoiLiveAdjustFeatAmount(
            oPC,
            MoiLiveElementValue(sElement, sBase),
            bDown ? -1 : 1
        );
        MoiLiveReport(oPC, sError, "");
        if (sError == "")
            MoiLiveRefresh(oPC, nToken);
        return;
    }

    if (FindSubString(sElement, PRC_MOI_LIVE_FEAT_COMMIT_BUTTON) == 0)
    {
        int nFeat = MoiLiveElementValue(
            sElement, PRC_MOI_LIVE_FEAT_COMMIT_BUTTON
        );
        string sError = MoiLiveCommitFeat(oPC, nFeat);
        MoiLiveReport(oPC, sError, "Essentia locked into "
            + MoiLiveFeatName(nFeat) + " until rest.");
        if (sError == "")
            MoiLiveRefresh(oPC, nToken);
        return;
    }

    if (FindSubString(sElement, PRC_MOI_LIVE_CAST_KIND_BUTTON) == 0)
    {
        int nKind = MoiLiveElementValue(
            sElement, PRC_MOI_LIVE_CAST_KIND_BUTTON
        );
        if ((nKind == PRC_MOI_LIVE_CAST_ARCANE
                && GetPrimaryArcaneClass(oPC) == CLASS_TYPE_INVALID)
            || (nKind == PRC_MOI_LIVE_CAST_PSIONIC
                && GetPrimaryPsionicClass(oPC) == CLASS_TYPE_INVALID))
            return;
        SetLocalInt(oPC, PRC_MOI_LIVE_CAST_KIND_VAR, nKind);
        MoiLiveRefresh(oPC, nToken);
        return;
    }

    if (FindSubString(sElement, PRC_MOI_LIVE_CAST_LEVEL_BUTTON) == 0)
    {
        int nLevel = MoiLiveElementValue(
            sElement, PRC_MOI_LIVE_CAST_LEVEL_BUTTON
        );
        if (nLevel < 1 || nLevel > 9)
            return;
        SetLocalInt(oPC, PRC_MOI_LIVE_CAST_LEVEL_VAR, nLevel);
        MoiLiveRefresh(oPC, nToken);
        return;
    }

    if (FindSubString(sElement, PRC_MOI_LIVE_CAST_COMMIT_BUTTON) == 0)
    {
        int nSpell = MoiLiveElementValue(
            sElement, PRC_MOI_LIVE_CAST_COMMIT_BUTTON
        );
        string sError = MoiLiveCommitSpell(
            oPC,
            GetLocalInt(oPC, PRC_MOI_LIVE_CAST_KIND_VAR),
            GetLocalInt(oPC, PRC_MOI_LIVE_CAST_LEVEL_VAR),
            nSpell
        );
        MoiLiveReport(oPC, sError, "Essentia invested into "
            + MoiLiveSpellName(nSpell) + " until it is cast.");
        if (sError == "")
            MoiLiveRefresh(oPC, nToken);
        return;
    }

    if (FindSubString(sElement, PRC_MOI_LIVE_REFRESH_BUTTON) == 0)
    {
        if (GetLocalInt(oPC, PRC_MOI_LIVE_PAGE_VAR)
                == PRC_MOI_LIVE_PAGE_MOVABLE)
            SetLocalJson(oPC, PRC_MOI_LIVE_DRAFT_VAR, MoiLiveBuildMovable(oPC));
        MoiLiveRefresh(oPC, nToken);
        return;
    }

    if (FindSubString(sElement, PRC_MOI_LIVE_CLOSE_BUTTON) == 0)
    {
        MoiLiveRememberGeometry(oPC, nToken);
        MoiLiveClearState(oPC);
        NuiDestroy(oPC, nToken);
        return;
    }
}
