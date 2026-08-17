//::///////////////////////////////////////////////
//:: PRC Archivist Preparation NUI Events
//:: prc_nui_ap_event
//:://////////////////////////////////////////////

#include "prc_nui_ap_inc"

void APRememberGeometry(object oPC, int nToken)
{
    json jGeometry = NuiGetBind(oPC, nToken, "geometry");
    if (jGeometry != JsonNull())
        SetLocalJson(oPC, PRC_ARCHIVIST_PREP_GEOMETRY_VAR, jGeometry);
}

void APRefresh(object oPC, int nToken)
{
    APRememberGeometry(oPC, nToken);
    SetLocalInt(oPC, PRC_ARCHIVIST_PREP_REBUILD_TOKEN_VAR, nToken);
    NuiDestroy(oPC, nToken);
    ExecuteScript("prc_nui_ap_view", oPC);
}

int APEventMetamagicFeat(int nMetamagic)
{
    switch (nMetamagic)
    {
        case METAMAGIC_EMPOWER:  return FEAT_EMPOWER_SPELL;
        case METAMAGIC_EXTEND:   return FEAT_EXTEND_SPELL;
        case METAMAGIC_MAXIMIZE: return FEAT_MAXIMIZE_SPELL;
        case METAMAGIC_QUICKEN:  return FEAT_QUICKEN_SPELL;
        case METAMAGIC_SILENT:   return FEAT_SILENCE_SPELL;
        case METAMAGIC_STILL:    return FEAT_STILL_SPELL;
    }
    return 0;
}

int APEventCanSelectMetamagic(object oPC, int nCircle, int nMetamagic)
{
    if (nMetamagic == METAMAGIC_NONE)
        return TRUE;
    int nFeat = APEventMetamagicFeat(nMetamagic);
    int nAdjustment = GetMetaMagicSpellLevelAdjustment(nMetamagic);
    return nFeat > 0 && GetHasFeat(nFeat, oPC) && nAdjustment > 0 && nAdjustment <= nCircle;
}

void main()
{
    object oPC = NuiGetEventPlayer();
    int nToken = NuiGetEventWindow();
    string sEvent = NuiGetEventType();
    string sElement = NuiGetEventElement();
    int nArrayIndex = NuiGetEventArrayIndex();

    if (NuiGetWindowId(oPC, nToken) != PRC_ARCHIVIST_PREP_NUI_WINDOW_ID)
        return;

    if (sEvent == "watch" && sElement == "geometry")
    {
        if (NuiFindWindow(oPC, PRC_ARCHIVIST_PREP_NUI_WINDOW_ID) != nToken)
            return;
        APRememberGeometry(oPC, nToken);
        return;
    }

    // Clicking the title-bar X is a true Cancel: no persistent spellbook
    // state has been touched, and the local draft is discarded.
    if (sEvent == "closed" || sEvent == "close")
    {
        if (GetLocalInt(oPC, PRC_ARCHIVIST_PREP_REBUILD_TOKEN_VAR) == nToken)
        {
            DeleteLocalInt(oPC, PRC_ARCHIVIST_PREP_REBUILD_TOKEN_VAR);
            return;
        }
        // A view refresh destroys the old token and immediately creates a new
        // one. Ignore a delayed close event from that superseded token.
        int nCurrentToken = NuiFindWindow(oPC, PRC_ARCHIVIST_PREP_NUI_WINDOW_ID);
        if (nCurrentToken && nCurrentToken != nToken)
            return;
        APRememberGeometry(oPC, nToken);
        ArchivistPrepDiscardDraft(oPC, FALSE);
        return;
    }

    if (sEvent != "mouseup"
        || NuiFindWindow(oPC, PRC_ARCHIVIST_PREP_NUI_WINDOW_ID) != nToken
        || !GetLocalInt(oPC, PRC_ARCHIVIST_PREP_ACTIVE_VAR))
        return;

    json jPayload = NuiGetEventPayload();
    int nButton = JsonGetInt(JsonObjectGet(jPayload, "mouse_btn"));

    if (sElement == PRC_ARCHIVIST_PREP_FILTER_BUTTON)
    {
        if (nButton != NUI_PAYLOAD_BUTTON_LEFT_CLICK)
            return;
        SetLocalString(oPC, PRC_ARCHIVIST_PREP_FILTER_VAR,
            JsonGetString(NuiGetBind(oPC, nToken, PRC_ARCHIVIST_PREP_FILTER_BIND)));
        APRefresh(oPC, nToken);
        return;
    }

    if (sElement == PRC_ARCHIVIST_PREP_KNOWN_LIST_BTN)
    {
        json jRows = GetLocalJson(oPC, PRC_ARCHIVIST_PREP_KNOWN_MAP_VAR);
        if (JsonGetType(jRows) != JSON_TYPE_ARRAY
            || nArrayIndex < 0 || nArrayIndex >= JsonGetLength(jRows))
            return;

        int nRow = JsonGetInt(JsonArrayGet(jRows, nArrayIndex));
        int nCircle = GetLocalInt(oPC, PRC_ARCHIVIST_PREP_CIRCLE_VAR);
        // The local map is only a presentation cache. Never trust it without
        // checking the player's current known library and metamagic ownership.
        if (!ArchivistPrepIsKnownRow(oPC, nRow, nCircle))
            return;

        if (nButton == NUI_PAYLOAD_BUTTON_RIGHT_CLICK)
        {
            ArchivistPrepOpenDescription(oPC, nRow);
            return;
        }
        if (nButton != NUI_PAYLOAD_BUTTON_LEFT_CLICK)
            return;

        if (!ArchivistPrepAddRow(oPC, nCircle, nRow))
        {
            if (ArchivistPrepDraftFilled(oPC, nCircle) >= ArchivistPrepGetSlotCount(oPC, nCircle))
                SendMessageToPC(oPC, "Every preparation slot in this circle is already filled.");
            else
                SendMessageToPC(oPC, "That spell or metamagic choice is no longer valid for this circle.");
            return;
        }
        APRefresh(oPC, nToken);
        return;
    }

    if (FindSubString(sElement, PRC_ARCHIVIST_PREP_CIRCLE_BUTTON) == 0)
    {
        if (nButton != NUI_PAYLOAD_BUTTON_LEFT_CLICK)
            return;
        int nCircle = StringToInt(RegExpReplace(PRC_ARCHIVIST_PREP_CIRCLE_BUTTON, sElement, ""));
        if (nCircle < 0 || nCircle > 9 || ArchivistPrepGetSlotCount(oPC, nCircle) <= 0)
            return;

        SetLocalInt(oPC, PRC_ARCHIVIST_PREP_CIRCLE_VAR, nCircle);
        int nMetamagic = GetLocalInt(oPC, PRC_ARCHIVIST_PREP_METAMAGIC_VAR);
        if (!APEventCanSelectMetamagic(oPC, nCircle, nMetamagic))
            DeleteLocalInt(oPC, PRC_ARCHIVIST_PREP_METAMAGIC_VAR);
        APRefresh(oPC, nToken);
        return;
    }

    if (FindSubString(sElement, PRC_ARCHIVIST_PREP_META_BUTTON) == 0)
    {
        if (nButton != NUI_PAYLOAD_BUTTON_LEFT_CLICK)
            return;
        int nMetamagic = StringToInt(RegExpReplace(PRC_ARCHIVIST_PREP_META_BUTTON, sElement, ""));
        int nCircle = GetLocalInt(oPC, PRC_ARCHIVIST_PREP_CIRCLE_VAR);
        if (!APEventCanSelectMetamagic(oPC, nCircle, nMetamagic))
            return;

        SetLocalInt(oPC, PRC_ARCHIVIST_PREP_METAMAGIC_VAR, nMetamagic);
        APRefresh(oPC, nToken);
        return;
    }

    if (FindSubString(sElement, PRC_ARCHIVIST_PREP_KNOWN_BUTTON) == 0)
    {
        int nRow = StringToInt(RegExpReplace(PRC_ARCHIVIST_PREP_KNOWN_BUTTON, sElement, ""));
        if (nButton == NUI_PAYLOAD_BUTTON_RIGHT_CLICK)
        {
            ArchivistPrepOpenDescription(oPC, nRow);
            return;
        }
        if (nButton != NUI_PAYLOAD_BUTTON_LEFT_CLICK)
            return;

        int nCircle = GetLocalInt(oPC, PRC_ARCHIVIST_PREP_CIRCLE_VAR);
        if (!ArchivistPrepAddRow(oPC, nCircle, nRow))
        {
            if (ArchivistPrepDraftFilled(oPC, nCircle) >= ArchivistPrepGetSlotCount(oPC, nCircle))
                SendMessageToPC(oPC, "Every preparation slot in this circle is already filled.");
            else
                SendMessageToPC(oPC, "That spell or metamagic choice is no longer valid for this circle.");
            return;
        }
        APRefresh(oPC, nToken);
        return;
    }

    if (FindSubString(sElement, PRC_ARCHIVIST_PREP_PLAN_BUTTON) == 0)
    {
        int nRow = StringToInt(RegExpReplace(PRC_ARCHIVIST_PREP_PLAN_BUTTON, sElement, ""));
        if (nButton == NUI_PAYLOAD_BUTTON_RIGHT_CLICK)
            ArchivistPrepOpenDescription(oPC, nRow);
        return;
    }

    if (FindSubString(sElement, PRC_ARCHIVIST_PREP_REMOVE_BUTTON) == 0)
    {
        if (nButton != NUI_PAYLOAD_BUTTON_LEFT_CLICK)
            return;
        int nRow = StringToInt(RegExpReplace(PRC_ARCHIVIST_PREP_REMOVE_BUTTON, sElement, ""));
        int nCircle = GetLocalInt(oPC, PRC_ARCHIVIST_PREP_CIRCLE_VAR);
        if (ArchivistPrepRemoveRow(oPC, nCircle, nRow))
            APRefresh(oPC, nToken);
        return;
    }

    if (sElement == PRC_ARCHIVIST_PREP_CLEAR_BUTTON)
    {
        if (nButton != NUI_PAYLOAD_BUTTON_LEFT_CLICK)
            return;
        ArchivistPrepClearCircle(oPC, GetLocalInt(oPC, PRC_ARCHIVIST_PREP_CIRCLE_VAR));
        APRefresh(oPC, nToken);
        return;
    }

    if (sElement == PRC_ARCHIVIST_PREP_CANCEL_BUTTON)
    {
        if (nButton != NUI_PAYLOAD_BUTTON_LEFT_CLICK)
            return;
        APRememberGeometry(oPC, nToken);
        ArchivistPrepDiscardDraft(oPC);
        return;
    }

    if (sElement == PRC_ARCHIVIST_PREP_SAVE_BUTTON)
    {
        if (nButton != NUI_PAYLOAD_BUTTON_LEFT_CLICK)
            return;

        string sError = ArchivistPrepValidateDraft(oPC);
        if (sError != "")
        {
            SendMessageToPC(oPC, sError);
            return;
        }

        if (!ArchivistPrepCommitDraft(oPC))
        {
            SendMessageToPC(oPC, "The preparation plan could not be saved. Your ready spells were not changed.");
            return;
        }

        APRememberGeometry(oPC, nToken);
        SendMessageToPC(oPC, "Archivist preparation saved. The new plan takes effect after your next completed rest.");
        ArchivistPrepDiscardDraft(oPC);
        return;
    }
}
