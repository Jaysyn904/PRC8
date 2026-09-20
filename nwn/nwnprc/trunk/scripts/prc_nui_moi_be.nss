//::///////////////////////////////////////////////
//:: Incarnum Blade blademeld editor events
//:: prc_nui_moi_be
//:://////////////////////////////////////////////

#include "prc_nui_moi_bld"
#include "prc_nui_consts"

void MoiBladeRememberGeometry(object oPC, int nToken)
{
    json jGeometry = NuiGetBind(oPC, nToken, "geometry");
    if (jGeometry != JsonNull())
        SetLocalJson(oPC, PRC_MOI_BLADE_GEOMETRY_VAR, jGeometry);
}

void MoiBladeRefresh(object oPC, int nToken)
{
    MoiBladeRememberGeometry(oPC, nToken);
    SetLocalInt(oPC, PRC_MOI_BLADE_REBUILD_TOKEN_VAR, nToken);
    NuiDestroy(oPC, nToken);
    ExecuteScript("prc_nui_moi_bv", oPC);
}

void main()
{
    object oPC = NuiGetEventPlayer();
    int nToken = NuiGetEventWindow();
    string sEvent = NuiGetEventType();
    string sElement = NuiGetEventElement();

    if (NuiGetWindowId(oPC, nToken) != PRC_MOI_BLADE_NUI_WINDOW_ID)
        return;

    if (sEvent == "watch" && sElement == "geometry")
    {
        if (NuiFindWindow(oPC, PRC_MOI_BLADE_NUI_WINDOW_ID) == nToken)
            MoiBladeRememberGeometry(oPC, nToken);
        return;
    }

    if (sEvent == "closed" || sEvent == "close")
    {
        if (GetLocalInt(oPC, PRC_MOI_BLADE_REBUILD_TOKEN_VAR) == nToken)
        {
            DeleteLocalInt(oPC, PRC_MOI_BLADE_REBUILD_TOKEN_VAR);
            return;
        }
        int nCurrent = NuiFindWindow(oPC, PRC_MOI_BLADE_NUI_WINDOW_ID);
        if (nCurrent && nCurrent != nToken)
            return;
        MoiBladeRememberGeometry(oPC, nToken);
        MoiBladeDiscardDraft(oPC, FALSE);
        return;
    }

    if (sEvent != "mouseup"
        || NuiFindWindow(oPC, PRC_MOI_BLADE_NUI_WINDOW_ID) != nToken
        || !GetLocalInt(oPC, PRC_MOI_BLADE_ACTIVE_VAR))
        return;

    int nGeneration = MoiBladeElementGeneration(sElement);
    if (nGeneration <= 0
        || nGeneration != GetLocalInt(oPC, PRC_MOI_BLADE_GENERATION_VAR))
        return;

    json jPayload = NuiGetEventPayload();
    int nButton = JsonGetInt(JsonObjectGet(jPayload, "mouse_btn"));
    if (nButton != NUI_PAYLOAD_BUTTON_LEFT_CLICK)
        return;

    if (FindSubString(sElement, PRC_MOI_BLADE_CHAKRA_BUTTON) == 0)
    {
        int nChakra = MoiBladeElementValue(
            sElement,
            PRC_MOI_BLADE_CHAKRA_BUTTON
        );
        if (sElement != MoiBladeStampValueId(
                PRC_MOI_BLADE_CHAKRA_BUTTON,
                nChakra,
                nGeneration
            )
            || !MoiBladeChakraUnlocked(oPC, nChakra))
            return;
        MoiBladeToggleDraft(oPC, nChakra);
        MoiBladeRefresh(oPC, nToken);
        return;
    }

    if (sElement == MoiBladeStampId(
            PRC_MOI_BLADE_CLOSE_BUTTON,
            nGeneration
        ))
    {
        MoiBladeRememberGeometry(oPC, nToken);
        MoiBladeDiscardDraft(oPC);
        return;
    }

    if (sElement == MoiBladeStampId(
            PRC_MOI_BLADE_CLEAR_BUTTON,
            nGeneration
        ))
    {
        MoiBladeClearSaved(oPC);
        SendMessageToPC(
            oPC,
            "Your saved blademeld rest default was cleared. Completed rest will use the original PRC picker."
        );
        MoiBladeRefresh(oPC, nToken);
        return;
    }

    int nFirst = GetLocalInt(oPC, PRC_MOI_BLADE_DRAFT_FIRST_VAR);
    int nSecond = GetLocalInt(oPC, PRC_MOI_BLADE_DRAFT_SECOND_VAR);
    string sError = MoiBladeValidateChoices(oPC, nFirst, nSecond);

    if (sElement == MoiBladeStampId(
            PRC_MOI_BLADE_SAVE_BUTTON,
            nGeneration
        ))
    {
        if (sError != "" || !MoiBladeWriteSaved(oPC, nFirst, nSecond))
        {
            SendMessageToPC(
                oPC,
                sError != "" ? sError : "The blademeld default could not be saved."
            );
            MoiBladeRefresh(oPC, nToken);
            return;
        }
        SendMessageToPC(
            oPC,
            "Saved blademeld rest default: "
          + MoiBladeChoiceSummary(nFirst, nSecond) + "."
        );
        MoiBladeRefresh(oPC, nToken);
        return;
    }

    if (sElement == MoiBladeStampId(
            PRC_MOI_BLADE_REBIND_BUTTON,
            nGeneration
        ))
    {
        if (sError != "")
        {
            SendMessageToPC(oPC, sError);
            MoiBladeRefresh(oPC, nToken);
            return;
        }

        MoiBladeRememberGeometry(oPC, nToken);
        SetLocalInt(
            oPC,
            PRC_MOI_BLADE_APPLY_MODE_VAR,
            PRC_MOI_BLADE_APPLY_MODE_REBIND
        );
        ExecuteScript("prc_nui_moi_ba", oPC);
        return;
    }
}
