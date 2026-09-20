//::///////////////////////////////////////////////
//:: PRC Runescar Scribing NUI Events
//:: prc_nui_rb_event
//:://////////////////////////////////////////////

#include "prc_nui_rb_inc"

void RBRememberGeometry(object oPC, int nToken)
{
    json jGeometry = NuiGetBind(oPC, nToken, "geometry");
    if (jGeometry != JsonNull())
        SetLocalJson(oPC, PRC_RUNESCAR_SCRIBE_GEOMETRY_VAR, jGeometry);
}

void RBRefresh(object oPC, int nToken)
{
    RBRememberGeometry(oPC, nToken);
    SetLocalInt(oPC, PRC_RUNESCAR_SCRIBE_REBUILD_TOKEN_VAR, nToken);
    NuiDestroy(oPC, nToken);
    ExecuteScript("prc_nui_rb_view", oPC);
}

void main()
{
    object oPC = NuiGetEventPlayer();
    int nToken = NuiGetEventWindow();
    string sEvent = NuiGetEventType();
    string sElement = NuiGetEventElement();
    int nArrayIndex = NuiGetEventArrayIndex();

    if (NuiGetWindowId(oPC, nToken) != PRC_RUNESCAR_SCRIBE_NUI_WINDOW_ID)
        return;

    if (sEvent == "watch" && sElement == "geometry")
    {
        if (NuiFindWindow(oPC, PRC_RUNESCAR_SCRIBE_NUI_WINDOW_ID) != nToken)
            return;
        RBRememberGeometry(oPC, nToken);
        return;
    }

    // Destroy/recreate refreshes deliberately close one superseded token.  A
    // title-bar X has no rebuild marker and is therefore a true Cancel.
    if (sEvent == "closed" || sEvent == "close")
    {
        if (GetLocalInt(oPC, PRC_RUNESCAR_SCRIBE_REBUILD_TOKEN_VAR)
            == nToken)
        {
            DeleteLocalInt(oPC, PRC_RUNESCAR_SCRIBE_REBUILD_TOKEN_VAR);
            return;
        }

        int nCurrentToken = NuiFindWindow(
            oPC,
            PRC_RUNESCAR_SCRIBE_NUI_WINDOW_ID
        );
        if (nCurrentToken && nCurrentToken != nToken)
            return;
        RBRememberGeometry(oPC, nToken);
        RunescarScribeDiscardDraft(oPC, FALSE);
        return;
    }

    if (sEvent != "mouseup"
        || NuiFindWindow(oPC, PRC_RUNESCAR_SCRIBE_NUI_WINDOW_ID) != nToken
        || !RunescarScribeHasActiveSession(oPC))
        return;

    // Every actionable ID carries the layout generation.  This remains a
    // second line of defence if the client delivers a queued event after the
    // editor token has been replaced and happens to reuse that token number.
    int nGeneration = RunescarScribeGetElementGeneration(sElement);
    if (nGeneration <= 0
        || nGeneration != GetLocalInt(
            oPC,
            PRC_RUNESCAR_SCRIBE_LAYOUT_GENERATION_VAR
        ))
        return;

    json jPayload = NuiGetEventPayload();
    int nButton = JsonGetInt(JsonObjectGet(jPayload, "mouse_btn"));

    if (FindSubString(sElement, PRC_RUNESCAR_SCRIBE_LOCATION_BUTTON) == 0)
    {
        if (nButton != NUI_PAYLOAD_BUTTON_LEFT_CLICK)
            return;
        int nPosition = RunescarScribeGetElementValue(
            sElement,
            PRC_RUNESCAR_SCRIBE_LOCATION_BUTTON
        );
        if (!RunescarScribePositionIsAvailable(oPC, nPosition))
        {
            SendMessageToPC(oPC, "That body location is no longer empty.");
            RBRefresh(oPC, nToken);
            return;
        }

        RunescarScribeSelectPosition(oPC, nPosition);
        RBRefresh(oPC, nToken);
        return;
    }

    if (FindSubString(sElement, PRC_RUNESCAR_SCRIBE_TIER_BUTTON) == 0)
    {
        if (nButton != NUI_PAYLOAD_BUTTON_LEFT_CLICK)
            return;
        int nTier = RunescarScribeGetElementValue(
            sElement,
            PRC_RUNESCAR_SCRIBE_TIER_BUTTON
        );
        if (!RunescarScribeTierIsAvailable(oPC, nTier))
        {
            SendMessageToPC(oPC, "That runescar tier is no longer available.");
            RBRefresh(oPC, nToken);
            return;
        }

        RunescarScribeSelectTier(oPC, nTier);
        RBRefresh(oPC, nToken);
        return;
    }

    if (sElement == RunescarScribeStampId(
            PRC_RUNESCAR_SCRIBE_SPELL_LIST_BUTTON,
            nGeneration
        ))
    {
        int nSpell = RunescarScribeGetMappedSpell(
            oPC,
            nArrayIndex,
            nGeneration
        );
        if (nSpell < 0)
            return;

        if (nButton == NUI_PAYLOAD_BUTTON_RIGHT_CLICK)
        {
            RunescarScribeOpenDescription(oPC, nSpell);
            return;
        }
        if (nButton != NUI_PAYLOAD_BUTTON_LEFT_CLICK)
            return;

        SetLocalInt(oPC, PRC_RUNESCAR_SCRIBE_SPELL_VAR, nSpell);
        RBRefresh(oPC, nToken);
        return;
    }

    if (sElement == RunescarScribeStampId(
            PRC_RUNESCAR_SCRIBE_CASTER_DOWN_BUTTON,
            nGeneration
        )
        || sElement == RunescarScribeStampId(
            PRC_RUNESCAR_SCRIBE_CASTER_UP_BUTTON,
            nGeneration
        ))
    {
        if (nButton != NUI_PAYLOAD_BUTTON_LEFT_CLICK)
            return;

        int nTier = GetLocalInt(oPC, PRC_RUNESCAR_SCRIBE_TIER_VAR);
        int nCasterLevel = GetLocalInt(
            oPC,
            PRC_RUNESCAR_SCRIBE_CASTER_LEVEL_VAR
        );
        int nMinimum = RunescarScribeGetMinimumCasterLevel(nTier);
        int nMaximum = GetLevelByClass(CLASS_TYPE_RUNESCARRED, oPC);
        if (sElement == RunescarScribeStampId(
                PRC_RUNESCAR_SCRIBE_CASTER_DOWN_BUTTON,
                nGeneration
            ))
            nCasterLevel--;
        else
            nCasterLevel++;

        if (nCasterLevel < nMinimum)
            nCasterLevel = nMinimum;
        if (nCasterLevel > nMaximum)
            nCasterLevel = nMaximum;
        SetLocalInt(
            oPC,
            PRC_RUNESCAR_SCRIBE_CASTER_LEVEL_VAR,
            nCasterLevel
        );
        RBRefresh(oPC, nToken);
        return;
    }

    if (sElement == RunescarScribeStampId(
            PRC_RUNESCAR_SCRIBE_CANCEL_BUTTON,
            nGeneration
        ))
    {
        if (nButton != NUI_PAYLOAD_BUTTON_LEFT_CLICK)
            return;
        RBRememberGeometry(oPC, nToken);
        RunescarScribeDiscardDraft(oPC);
        return;
    }

    if (sElement == RunescarScribeStampId(
            PRC_RUNESCAR_SCRIBE_SAVE_BUTTON,
            nGeneration
        ))
    {
        if (nButton != NUI_PAYLOAD_BUTTON_LEFT_CLICK)
            return;

        string sError = RunescarScribeValidateDraft(oPC);
        if (sError != "")
        {
            SendMessageToPC(oPC, sError);
            RBRefresh(oPC, nToken);
            return;
        }

        int nPosition = GetLocalInt(oPC, PRC_RUNESCAR_SCRIBE_LOCATION_VAR);
        int nSpell = GetLocalInt(oPC, PRC_RUNESCAR_SCRIBE_SPELL_VAR);
        int nCasterLevel = GetLocalInt(
            oPC,
            PRC_RUNESCAR_SCRIBE_CASTER_LEVEL_VAR
        );
        if (!RunescarScribeCommitDraft(oPC))
        {
            SendMessageToPC(
                oPC,
                "The runescar could not be scribed. No selection was applied."
            );
            RBRefresh(oPC, nToken);
            return;
        }

        RBRememberGeometry(oPC, nToken);
        SendMessageToPC(
            oPC,
            "Scribed " + GetSpellName(nSpell) + " on your "
            + NUISpellbookGetRunescarPositionName(nPosition)
            + " at caster level " + IntToString(nCasterLevel) + "."
        );
        RunescarScribeDiscardDraft(oPC);

        // The scar roster and one tier counter changed structurally.  Refresh
        // only the existing spellbook content host; the `/sb` window remains
        // alive and keeps its geometry.
        if (NuiFindWindow(oPC, PRC_SPELLBOOK_NUI_WINDOW_ID)
            && GetLocalInt(oPC, PRC_SPELLBOOK_SELECTED_MODE_VAR)
                == PRC_SPELLBOOK_MODE_CLASS
            && GetLocalInt(oPC, PRC_SPELLBOOK_SELECTED_CLASSID_VAR)
                == CLASS_TYPE_RUNESCARRED)
            ExecuteScript("prc_nui_sb_view", oPC);
        return;
    }
}
