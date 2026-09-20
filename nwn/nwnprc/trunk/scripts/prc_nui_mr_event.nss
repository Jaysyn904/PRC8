//::///////////////////////////////////////////////
//:: PRC Maneuver Readying NUI Events
//:: prc_nui_mr_event
//:://////////////////////////////////////////////

#include "prc_nui_mr_inc"

void MRRememberGeometry(object oPC, int nToken)
{
    json jGeometry = NuiGetBind(oPC, nToken, "geometry");
    if (jGeometry != JsonNull())
        SetLocalJson(oPC, PRC_MANEUVER_READY_GEOMETRY_VAR, jGeometry);
}

void MRRefresh(object oPC, int nToken)
{
    MRRememberGeometry(oPC, nToken);
    SetLocalInt(oPC, PRC_MANEUVER_READY_REBUILD_TOKEN_VAR, nToken);
    NuiDestroy(oPC, nToken);
    ExecuteScript("prc_nui_mr_view", oPC);
}

void main()
{
    object oPC = NuiGetEventPlayer();
    int nToken = NuiGetEventWindow();
    string sEvent = NuiGetEventType();
    string sElement = NuiGetEventElement();
    int nArrayIndex = NuiGetEventArrayIndex();

    if (NuiGetWindowId(oPC, nToken) != PRC_MANEUVER_READY_NUI_WINDOW_ID)
        return;

    if (sEvent == "watch" && sElement == "geometry")
    {
        if (NuiFindWindow(oPC, PRC_MANEUVER_READY_NUI_WINDOW_ID) != nToken)
            return;
        MRRememberGeometry(oPC, nToken);
        return;
    }

    // The title-bar X is a true Cancel. A view refresh destroys the old token,
    // so ignore only that superseded token's delayed close notification.
    if (sEvent == "closed" || sEvent == "close")
    {
        if (GetLocalInt(oPC, PRC_MANEUVER_READY_REBUILD_TOKEN_VAR) == nToken)
        {
            DeleteLocalInt(oPC, PRC_MANEUVER_READY_REBUILD_TOKEN_VAR);
            return;
        }
        int nCurrentToken = NuiFindWindow(oPC, PRC_MANEUVER_READY_NUI_WINDOW_ID);
        if (nCurrentToken && nCurrentToken != nToken)
            return;
        MRRememberGeometry(oPC, nToken);
        ManeuverReadyDiscardDraft(oPC, FALSE);
        return;
    }

    if (sEvent != "mouseup"
        || NuiFindWindow(oPC, PRC_MANEUVER_READY_NUI_WINDOW_ID) != nToken
        || !GetLocalInt(oPC, PRC_MANEUVER_READY_ACTIVE_VAR))
        return;

    int nClass = GetLocalInt(oPC, PRC_MANEUVER_READY_CLASS_VAR);
    if (!ManeuverReadyIsInitiatorClass(nClass)
        || GetLevelByClass(nClass, oPC) <= 0)
        return;

    json jPayload = NuiGetEventPayload();
    int nButton = JsonGetInt(JsonObjectGet(jPayload, "mouse_btn"));

    if (FindSubString(sElement, PRC_MANEUVER_READY_LEVEL_BUTTON) == 0)
    {
        if (nButton != NUI_PAYLOAD_BUTTON_LEFT_CLICK)
            return;
        int nLevel = StringToInt(RegExpReplace(
            PRC_MANEUVER_READY_LEVEL_BUTTON,
            sElement,
            ""
        ));
        if (nLevel < 1
            || nLevel > ManeuverReadyMaxLevel(oPC, nClass)
            || !ManeuverReadyHasKnownAtLevel(oPC, nClass, nLevel))
            return;

        SetLocalInt(oPC, PRC_MANEUVER_READY_LEVEL_VAR, nLevel);
        MRRefresh(oPC, nToken);
        return;
    }

    if (sElement == PRC_MANEUVER_READY_KNOWN_LIST_BUTTON)
    {
        json jMap = GetLocalJson(oPC, PRC_MANEUVER_READY_KNOWN_MAP_VAR);
        if (JsonGetType(jMap) != JSON_TYPE_ARRAY
            || nArrayIndex < 0 || nArrayIndex >= JsonGetLength(jMap))
            return;

        int nManeuver = JsonGetInt(JsonArrayGet(jMap, nArrayIndex));
        int nLevel = GetLocalInt(oPC, PRC_MANEUVER_READY_LEVEL_VAR);
        if (!ManeuverReadyIsKnown(oPC, nClass, nManeuver)
            || ManeuverReadyGetLevel(nClass, nManeuver) != nLevel
            || ManeuverReadyDraftContains(oPC, nManeuver))
            return;

        if (nButton == NUI_PAYLOAD_BUTTON_RIGHT_CLICK)
        {
            ManeuverReadyOpenDescription(oPC, nClass, nManeuver);
            return;
        }
        if (nButton != NUI_PAYLOAD_BUTTON_LEFT_CLICK)
            return;

        if (!ManeuverReadyAdd(oPC, nManeuver))
        {
            if (ManeuverReadyDraftCount(oPC)
                >= ManeuverReadyTargetCount(oPC, nClass))
                SendMessageToPC(oPC, "Every readied maneuver slot is already filled.");
            else
                SendMessageToPC(oPC, "That maneuver is no longer available for this plan.");
            return;
        }
        MRRefresh(oPC, nToken);
        return;
    }

    if (sElement == PRC_MANEUVER_READY_PLAN_LIST_BUTTON)
    {
        json jMap = GetLocalJson(oPC, PRC_MANEUVER_READY_PLAN_MAP_VAR);
        if (JsonGetType(jMap) != JSON_TYPE_ARRAY
            || nArrayIndex < 0 || nArrayIndex >= JsonGetLength(jMap))
            return;

        int nManeuver = JsonGetInt(JsonArrayGet(jMap, nArrayIndex));
        if (!ManeuverReadyDraftContains(oPC, nManeuver))
            return;

        if (nButton == NUI_PAYLOAD_BUTTON_RIGHT_CLICK)
        {
            ManeuverReadyOpenDescription(oPC, nClass, nManeuver);
            return;
        }
        if (nButton != NUI_PAYLOAD_BUTTON_LEFT_CLICK)
            return;

        if (ManeuverReadyRemove(oPC, nManeuver))
            MRRefresh(oPC, nToken);
        return;
    }

    if (sElement == PRC_MANEUVER_READY_CLEAR_BUTTON)
    {
        if (nButton != NUI_PAYLOAD_BUTTON_LEFT_CLICK)
            return;
        ManeuverReadyClear(oPC);
        MRRefresh(oPC, nToken);
        return;
    }

    if (sElement == PRC_MANEUVER_READY_CANCEL_BUTTON)
    {
        if (nButton != NUI_PAYLOAD_BUTTON_LEFT_CLICK)
            return;
        MRRememberGeometry(oPC, nToken);
        ManeuverReadyDiscardDraft(oPC);
        return;
    }

    if (sElement == PRC_MANEUVER_READY_SAVE_BUTTON)
    {
        if (nButton != NUI_PAYLOAD_BUTTON_LEFT_CLICK)
            return;

        string sError = ManeuverReadyValidateDraft(oPC);
        if (sError != "")
        {
            SendMessageToPC(oPC, sError);
            return;
        }
        if (!ManeuverReadyCommitDraft(oPC))
        {
            SendMessageToPC(
                oPC,
                "The maneuver plan could not be applied. Your readied maneuvers were not changed."
            );
            return;
        }

        MRRememberGeometry(oPC, nToken);
        SendMessageToPC(oPC, "Readied maneuvers updated and recovered.");
        ManeuverReadyDiscardDraft(oPC);

        // The tier-0 map is structural roster data, so rebuild it after the
        // atomic commit while keeping the existing spellbook window alive.
        if (NuiFindWindow(oPC, PRC_SPELLBOOK_NUI_WINDOW_ID)
            && GetLocalInt(oPC, PRC_SPELLBOOK_SELECTED_MODE_VAR)
                == PRC_SPELLBOOK_MODE_CLASS
            && GetLocalInt(oPC, PRC_SPELLBOOK_SELECTED_CLASSID_VAR) == nClass
            && GetLocalInt(oPC, PRC_SPELLBOOK_SELECTED_CIRCLE_VAR) == 0)
            ExecuteScript("prc_nui_sb_view", oPC);
        return;
    }
}
