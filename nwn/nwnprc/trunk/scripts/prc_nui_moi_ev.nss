//::///////////////////////////////////////////////
//:: Incarnum Loadout editor events
//:: prc_nui_moi_ev
//:://////////////////////////////////////////////

#include "prc_nui_moi_pln"
#include "prc_nui_consts"

void MoiLoadoutRememberGeometry(object oPC, int nToken)
{
    json jGeometry = NuiGetBind(oPC, nToken, "geometry");
    if (jGeometry != JsonNull())
        SetLocalJson(oPC, PRC_MOI_LOADOUT_GEOMETRY_VAR, jGeometry);
}

void MoiLoadoutRefresh(object oPC, int nToken)
{
    MoiLoadoutRememberGeometry(oPC, nToken);
    SetLocalInt(oPC, PRC_MOI_LOADOUT_REBUILD_TOKEN_VAR, nToken);
    NuiDestroy(oPC, nToken);
    ExecuteScript("prc_nui_moi_vw", oPC);
}

void MoiLoadoutOpenDescription(object oPC, int nMeld)
{
    int nRow = MoiLoadoutFindMeldRow(nMeld);
    if (nRow <= 0)
        return;
    int nFeat = StringToInt(Get2DACache(
        GetMeldFile(), "FeatID", nRow
    ));
    SetLocalInt(oPC, NUI_SPELL_DESCRIPTION_FEATID_VAR, nFeat);
    SetLocalInt(oPC, NUI_SPELL_DESCRIPTION_SPELLID_VAR, nMeld);
    SetLocalInt(oPC, NUI_SPELL_DESCRIPTION_REAL_SPELLID_VAR, nMeld);
    DeleteLocalInt(oPC, NUI_SPELL_DESCRIPTION_CLASSID_VAR);
    ExecuteScript("prc_nui_dsc_view", oPC);
}

void MoiLoadoutReport(object oPC, string sError)
{
    if (sError != "")
        SendMessageToPC(oPC, sError);
}

void main()
{
    object oPC = NuiGetEventPlayer();
    int nToken = NuiGetEventWindow();
    string sEvent = NuiGetEventType();
    string sElement = NuiGetEventElement();

    if (NuiGetWindowId(oPC, nToken) != PRC_MOI_LOADOUT_NUI_WINDOW_ID)
        return;

    if (sEvent == "watch" && sElement == "geometry")
    {
        if (NuiFindWindow(oPC, PRC_MOI_LOADOUT_NUI_WINDOW_ID) == nToken)
            MoiLoadoutRememberGeometry(oPC, nToken);
        return;
    }

    if (sEvent == "closed" || sEvent == "close")
    {
        if (GetLocalInt(oPC, PRC_MOI_LOADOUT_REBUILD_TOKEN_VAR) == nToken)
        {
            DeleteLocalInt(oPC, PRC_MOI_LOADOUT_REBUILD_TOKEN_VAR);
            return;
        }
        int nCurrent = NuiFindWindow(oPC, PRC_MOI_LOADOUT_NUI_WINDOW_ID);
        if (nCurrent && nCurrent != nToken)
            return;
        MoiLoadoutRememberGeometry(oPC, nToken);
        MoiLoadoutDiscardDraft(oPC, FALSE);
        return;
    }

    if (sEvent != "mouseup"
        || NuiFindWindow(oPC, PRC_MOI_LOADOUT_NUI_WINDOW_ID) != nToken
        || !GetLocalInt(oPC, PRC_MOI_LOADOUT_ACTIVE_VAR))
        return;

    int nGeneration = MoiLoadoutElementGeneration(sElement);
    if (nGeneration <= 0
        || nGeneration != GetLocalInt(oPC, PRC_MOI_LOADOUT_GENERATION_VAR))
        return;

    json jPayload = NuiGetEventPayload();
    int nButton = JsonGetInt(JsonObjectGet(jPayload, "mouse_btn"));

    if (FindSubString(sElement, PRC_MOI_LOADOUT_STEP_BUTTON) == 0)
    {
        if (nButton != NUI_PAYLOAD_BUTTON_LEFT_CLICK)
            return;
        int nStage = MoiLoadoutElementValue(
            sElement,
            PRC_MOI_LOADOUT_STEP_BUTTON
        );
        if (nStage < PRC_MOI_LOADOUT_STAGE_SHAPE
            || nStage > PRC_MOI_LOADOUT_STAGE_BIND)
            return;
        SetLocalInt(oPC, PRC_MOI_LOADOUT_STAGE_VAR, nStage);
        MoiLoadoutRefresh(oPC, nToken);
        return;
    }

    if (FindSubString(sElement, PRC_MOI_LOADOUT_CLASS_BUTTON) == 0)
    {
        if (nButton != NUI_PAYLOAD_BUTTON_LEFT_CLICK)
            return;
        int nClass = MoiLoadoutElementValue(
            sElement,
            PRC_MOI_LOADOUT_CLASS_BUTTON
        );
        if (MoiLoadoutClassMaximum(oPC, nClass) <= 0)
            return;
        SetLocalInt(oPC, PRC_MOI_LOADOUT_CLASS_VAR, nClass);
        SetLocalInt(oPC, PRC_MOI_LOADOUT_CHAKRA_VAR, CHAKRA_CROWN);
        MoiLoadoutRefresh(oPC, nToken);
        return;
    }

    if (FindSubString(sElement, PRC_MOI_LOADOUT_CHAKRA_BUTTON) == 0)
    {
        if (nButton != NUI_PAYLOAD_BUTTON_LEFT_CLICK)
            return;
        int nChakra = MoiLoadoutElementValue(
            sElement,
            PRC_MOI_LOADOUT_CHAKRA_BUTTON
        );
        int nClass = GetLocalInt(oPC, PRC_MOI_LOADOUT_CLASS_VAR);
        if (nChakra < CHAKRA_CROWN
            || nChakra > CHAKRA_DOUBLE_SOUL
            || nChakra == CHAKRA_TOTEM)
            return;
        if (nChakra >= CHAKRA_DOUBLE_CROWN
            && (!MoiLoadoutHasClassChakra(
                    MoiLoadoutGetDraft(oPC),
                    nClass,
                    DoubleChakraToChakra(nChakra)
                )
                || !GetHasFeat(MoiLoadoutDoubleChakraFeat(nChakra), oPC)))
            return;
        SetLocalInt(oPC, PRC_MOI_LOADOUT_CHAKRA_VAR, nChakra);
        MoiLoadoutRefresh(oPC, nToken);
        return;
    }

    if (FindSubString(sElement, PRC_MOI_LOADOUT_MELD_BUTTON) == 0)
    {
        int nMeld = MoiLoadoutElementValue(
            sElement,
            PRC_MOI_LOADOUT_MELD_BUTTON
        );
        if (nButton == NUI_PAYLOAD_BUTTON_RIGHT_CLICK)
        {
            MoiLoadoutOpenDescription(oPC, nMeld);
            return;
        }
        if (nButton != NUI_PAYLOAD_BUTTON_LEFT_CLICK
            || GetLocalInt(oPC, PRC_MOI_LOADOUT_STAGE_VAR)
                != PRC_MOI_LOADOUT_STAGE_SHAPE)
            return;
        string sError = MoiLoadoutSelectMeld(
            oPC,
            GetLocalInt(oPC, PRC_MOI_LOADOUT_CLASS_VAR),
            GetLocalInt(oPC, PRC_MOI_LOADOUT_CHAKRA_VAR),
            nMeld
        );
        MoiLoadoutReport(oPC, sError);
        if (sError == "")
            MoiLoadoutRefresh(oPC, nToken);
        return;
    }

    if (FindSubString(sElement, PRC_MOI_LOADOUT_CLEAR_SLOT_BUTTON) == 0)
    {
        if (nButton != NUI_PAYLOAD_BUTTON_LEFT_CLICK)
            return;
        if (MoiLoadoutRemoveSlot(
            oPC,
            GetLocalInt(oPC, PRC_MOI_LOADOUT_CLASS_VAR),
            GetLocalInt(oPC, PRC_MOI_LOADOUT_CHAKRA_VAR)
        ))
            MoiLoadoutRefresh(oPC, nToken);
        return;
    }

    if (FindSubString(sElement, PRC_MOI_LOADOUT_INVEST_DOWN_BUTTON) == 0
        || FindSubString(sElement, PRC_MOI_LOADOUT_INVEST_UP_BUTTON) == 0)
    {
        if (nButton != NUI_PAYLOAD_BUTTON_LEFT_CLICK)
            return;
        string sBase = FindSubString(
            sElement,
            PRC_MOI_LOADOUT_INVEST_DOWN_BUTTON
        ) == 0
            ? PRC_MOI_LOADOUT_INVEST_DOWN_BUTTON
            : PRC_MOI_LOADOUT_INVEST_UP_BUTTON;
        int nIndex = MoiLoadoutElementValue(sElement, sBase);
        int nDelta = sBase == PRC_MOI_LOADOUT_INVEST_DOWN_BUTTON ? -1 : 1;
        string sError = MoiLoadoutAdjustInvestment(oPC, nIndex, nDelta);
        MoiLoadoutReport(oPC, sError);
        if (sError == "")
            MoiLoadoutRefresh(oPC, nToken);
        return;
    }

    if (FindSubString(sElement, PRC_MOI_LOADOUT_EXPANDED_BUTTON) == 0)
    {
        if (nButton != NUI_PAYLOAD_BUTTON_LEFT_CLICK)
            return;
        string sError = MoiLoadoutToggleExpanded(
            oPC,
            MoiLoadoutElementValue(
                sElement,
                PRC_MOI_LOADOUT_EXPANDED_BUTTON
            )
        );
        MoiLoadoutReport(oPC, sError);
        if (sError == "")
            MoiLoadoutRefresh(oPC, nToken);
        return;
    }

    if (FindSubString(sElement, PRC_MOI_LOADOUT_BIND_SLOT_BUTTON) == 0)
    {
        if (nButton != NUI_PAYLOAD_BUTTON_LEFT_CLICK)
            return;
        string sError = MoiLoadoutToggleStandardBind(
            oPC,
            MoiLoadoutElementValue(
                sElement,
                PRC_MOI_LOADOUT_BIND_SLOT_BUTTON
            )
        );
        MoiLoadoutReport(oPC, sError);
        if (sError == "") MoiLoadoutRefresh(oPC, nToken);
        return;
    }

    if (FindSubString(sElement, PRC_MOI_LOADOUT_BIND_TOTEM_BUTTON) == 0
        || FindSubString(sElement, PRC_MOI_LOADOUT_BIND_DTOTEM_BUTTON) == 0)
    {
        if (nButton != NUI_PAYLOAD_BUTTON_LEFT_CLICK)
            return;
        int bDouble = FindSubString(
            sElement,
            PRC_MOI_LOADOUT_BIND_DTOTEM_BUTTON
        ) == 0;
        string sBase = bDouble
            ? PRC_MOI_LOADOUT_BIND_DTOTEM_BUTTON
            : PRC_MOI_LOADOUT_BIND_TOTEM_BUTTON;
        string sError = MoiLoadoutToggleTotemBind(
            oPC,
            MoiLoadoutElementValue(sElement, sBase),
            bDouble ? CHAKRA_DOUBLE_TOTEM : CHAKRA_TOTEM
        );
        MoiLoadoutReport(oPC, sError);
        if (sError == "") MoiLoadoutRefresh(oPC, nToken);
        return;
    }

    if (FindSubString(sElement, PRC_MOI_LOADOUT_ASTRAL_DOWN_BUTTON) == 0
        || FindSubString(sElement, PRC_MOI_LOADOUT_ASTRAL_UP_BUTTON) == 0)
    {
        if (nButton != NUI_PAYLOAD_BUTTON_LEFT_CLICK)
            return;
        int bDown = FindSubString(
            sElement,
            PRC_MOI_LOADOUT_ASTRAL_DOWN_BUTTON
        ) == 0;
        string sBase = bDown
            ? PRC_MOI_LOADOUT_ASTRAL_DOWN_BUTTON
            : PRC_MOI_LOADOUT_ASTRAL_UP_BUTTON;
        string sError = MoiLoadoutAdjustAspect(
            oPC,
            MoiLoadoutElementValue(sElement, sBase),
            bDown ? -1 : 1
        );
        MoiLoadoutReport(oPC, sError);
        if (sError == "") MoiLoadoutRefresh(oPC, nToken);
        return;
    }

    if (FindSubString(sElement, PRC_MOI_LOADOUT_CAPTURE_BUTTON) == 0)
    {
        if (nButton != NUI_PAYLOAD_BUTTON_LEFT_CLICK)
            return;
        json jCurrent = MoiLoadoutCaptureCurrent(oPC);
        if (jCurrent == JsonNull())
        {
            SendMessageToPC(
                oPC,
                "The live soulmeld state is ambiguous and cannot be captured safely. Build this draft from the Shape step."
            );
            return;
        }
        if (JsonGetLength(jCurrent) == 0)
        {
            SendMessageToPC(oPC, "No live Incarnum setup was found to capture.");
            return;
        }
        MoiLoadoutSetDraft(oPC, jCurrent);
        SendMessageToPC(oPC, "The current live Incarnum setup was copied into this draft.");
        MoiLoadoutRefresh(oPC, nToken);
        return;
    }

    if (FindSubString(sElement, PRC_MOI_LOADOUT_CLEAR_DRAFT_BUTTON) == 0)
    {
        if (nButton != NUI_PAYLOAD_BUTTON_LEFT_CLICK)
            return;
        MoiLoadoutClearDraft(oPC);
        MoiLoadoutRefresh(oPC, nToken);
        return;
    }

    if (FindSubString(sElement, PRC_MOI_LOADOUT_CLEAR_SAVED_BUTTON) == 0)
    {
        if (nButton != NUI_PAYLOAD_BUTTON_LEFT_CLICK)
            return;
        MoiLoadoutClearSaved(oPC);
        SendMessageToPC(oPC, "The saved Incarnum rest loadout was cleared.");
        MoiLoadoutRefresh(oPC, nToken);
        return;
    }

    if (FindSubString(sElement, PRC_MOI_LOADOUT_CANCEL_BUTTON) == 0)
    {
        if (nButton != NUI_PAYLOAD_BUTTON_LEFT_CLICK)
            return;
        MoiLoadoutRememberGeometry(oPC, nToken);
        MoiLoadoutDiscardDraft(oPC);
        return;
    }

    if (FindSubString(sElement, PRC_MOI_LOADOUT_SAVE_BUTTON) == 0)
    {
        if (nButton != NUI_PAYLOAD_BUTTON_LEFT_CLICK)
            return;
        json jDraft = MoiLoadoutGetDraft(oPC);
        string sError = MoiLoadoutValidate(oPC, jDraft);
        if (sError != "")
        {
            SendMessageToPC(oPC, sError);
            return;
        }
        if (!MoiLoadoutWriteDraft(oPC, jDraft))
        {
            SendMessageToPC(
                oPC,
                "The Incarnum loadout could not be saved. The previous default was disabled rather than partially overwritten."
            );
            return;
        }

        MoiLoadoutRememberGeometry(oPC, nToken);
        SendMessageToPC(
            oPC,
            "Incarnum default saved. Shape, investment, and binding will be restored after your next completed rest."
        );
        MoiLoadoutDiscardDraft(oPC);
        if (NuiFindWindow(oPC, PRC_SPELLBOOK_NUI_WINDOW_ID)
            && GetLocalInt(oPC, PRC_SPELLBOOK_SELECTED_MODE_VAR) == 2)
            ExecuteScript("prc_nui_sb_view", oPC);
        return;
    }
}
