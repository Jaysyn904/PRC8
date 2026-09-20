//::///////////////////////////////////////////////
//:: PRC Binder pact-management NUI events
//:: prc_nui_bnd_evnt
//:://////////////////////////////////////////////

#include "prc_nui_bnd_inc"

void BNDRememberGeometry(object oPC, int nToken)
{
    json jGeometry = NuiGetBind(oPC, nToken, "geometry");
    if (jGeometry != JsonNull())
        SetLocalJson(oPC, PRC_BINDER_NUI_GEOMETRY_VAR, jGeometry);
}

void BNDRefresh(object oPC, int nToken)
{
    BNDRememberGeometry(oPC, nToken);
    SetLocalInt(oPC, PRC_BINDER_NUI_REBUILD_TOKEN_VAR, nToken);
    NuiDestroy(oPC, nToken);
    ExecuteScript("prc_nui_bnd_view", oPC);
}

void BNDReturnHome(object oPC, int nToken)
{
    BinderNUIResetDraft(oPC);
    SetLocalInt(oPC, PRC_BINDER_NUI_STAGE_VAR, PRC_BINDER_NUI_STAGE_HOME);
    BNDRefresh(oPC, nToken);
}

int BNDGetHomeMappedRow(object oPC, int nIndex, int bBound)
{
    if (GetLocalInt(oPC, PRC_BINDER_NUI_MAP_GEN_VAR)
            != GetLocalInt(oPC, PRC_BINDER_NUI_VIEW_GEN_VAR))
        return -1;
    json jMap;
    if (bBound)
        jMap = GetLocalJson(oPC, PRC_BINDER_NUI_HOME_BOUND_MAP_VAR);
    else
        jMap = GetLocalJson(oPC, PRC_BINDER_NUI_HOME_BIND_MAP_VAR);
    if (JsonGetType(jMap) != JSON_TYPE_ARRAY
        || nIndex < 0 || nIndex >= JsonGetLength(jMap))
        return -1;
    json jValue = JsonArrayGet(jMap, nIndex);
    if (JsonGetType(jValue) != JSON_TYPE_INTEGER)
        return -1;
    return JsonGetInt(jValue);
}

void main()
{
    object oPC = NuiGetEventPlayer();
    int nToken = NuiGetEventWindow();
    string sEvent = NuiGetEventType();
    string sElement = NuiGetEventElement();
    int nArrayIndex = NuiGetEventArrayIndex();

    if (NuiGetWindowId(oPC, nToken) != PRC_BINDER_NUI_WINDOW_ID)
        return;

    if (sEvent == "watch" && sElement == "geometry")
    {
        if (NuiFindWindow(oPC, PRC_BINDER_NUI_WINDOW_ID) == nToken)
            BNDRememberGeometry(oPC, nToken);
        return;
    }

    if (sEvent == "closed" || sEvent == "close")
    {
        if (GetLocalInt(oPC, PRC_BINDER_NUI_REBUILD_TOKEN_VAR) == nToken)
        {
            DeleteLocalInt(oPC, PRC_BINDER_NUI_REBUILD_TOKEN_VAR);
            return;
        }
        int nCurrent = NuiFindWindow(oPC, PRC_BINDER_NUI_WINDOW_ID);
        if (nCurrent && nCurrent != nToken)
            return;
        BNDRememberGeometry(oPC, nToken);
        if (!GetLocalInt(oPC, PRC_BINDER_NUI_RITUAL_TYPE_VAR))
            BinderNUIDiscardDraft(oPC, FALSE);
        return;
    }

    if (sEvent != "mouseup"
        || NuiFindWindow(oPC, PRC_BINDER_NUI_WINDOW_ID) != nToken
        || !GetLocalInt(oPC, PRC_BINDER_NUI_ACTIVE_VAR))
        return;

    json jPayload = NuiGetEventPayload();
    int nButton = JsonGetInt(JsonObjectGet(jPayload, "mouse_btn"));
    int nStage = GetLocalInt(oPC, PRC_BINDER_NUI_STAGE_VAR);

    if (sElement == PRC_BINDER_NUI_CLOSE_BUTTON)
    {
        if (nButton != NUI_PAYLOAD_BUTTON_LEFT_CLICK)
            return;
        BNDRememberGeometry(oPC, nToken);
        BinderNUIDiscardDraft(oPC);
        return;
    }

    if (sElement == PRC_BINDER_NUI_CANCEL_BUTTON)
    {
        if (nButton != NUI_PAYLOAD_BUTTON_LEFT_CLICK
            || nStage == PRC_BINDER_NUI_STAGE_EXPLOIT_SPELL)
            return;
        BNDReturnHome(oPC, nToken);
        return;
    }

    if (sElement == PRC_BINDER_NUI_HOME_BIND_LIST)
    {
        int nRow = BNDGetHomeMappedRow(oPC, nArrayIndex, FALSE);
        if (nRow < 1)
            return;
        if (nButton == NUI_PAYLOAD_BUTTON_RIGHT_CLICK)
        {
            SendMessageToPC(oPC, BinderNUIVestigeName(nRow) + ":\n"
                + BinderNUIVestigeDescription(nRow));
            return;
        }
        if (nButton != NUI_PAYLOAD_BUTTON_LEFT_CLICK)
            return;
        if (!BinderNUIBasicCanBindRow(oPC, nRow))
        {
            SendMessageToPC(oPC, "That vestige is no longer available to bind.");
            BinderNUIBuildHomeMaps(oPC);
            BNDRefresh(oPC, nToken);
            return;
        }

        BinderNUIResetDraft(oPC);
        SetLocalInt(oPC, PRC_BINDER_NUI_SELECTED_ROW_VAR, nRow);
        if (GetLevelByClass(CLASS_TYPE_ANIMA_MAGE, oPC) >= 2
            && !GetLocalInt(oPC, "ExploitVestige"))
        {
            SetLocalInt(oPC, PRC_BINDER_NUI_STAGE_VAR, PRC_BINDER_NUI_STAGE_EXPLOIT);
            BinderNUIBuildExploitChoices(oPC, nRow);
        }
        else
        {
            SetLocalInt(oPC, PRC_BINDER_NUI_STAGE_VAR, PRC_BINDER_NUI_STAGE_METHOD);
            BinderNUIBuildMethodChoices(oPC);
        }
        BNDRefresh(oPC, nToken);
        return;
    }

    if (sElement == PRC_BINDER_NUI_HOME_BOUND_LIST)
    {
        int nRow = BNDGetHomeMappedRow(oPC, nArrayIndex, TRUE);
        if (nRow < 1)
            return;
        if (nButton == NUI_PAYLOAD_BUTTON_RIGHT_CLICK)
        {
            SendMessageToPC(oPC, BinderNUIVestigeName(nRow) + ":\n"
                + BinderNUIVestigeDescription(nRow));
            return;
        }
        if (nButton != NUI_PAYLOAD_BUTTON_LEFT_CLICK)
            return;
        if (!GetHasFeat(FEAT_EXPEL_VESTIGE, oPC))
        {
            SendMessageToPC(oPC, "You need the Expel Vestige feat to do that.");
            return;
        }
        if (GetFeatRemainingUses(FEAT_EXPEL_VESTIGE, oPC) <= 0)
        {
            SendMessageToPC(oPC, "You have already used Expel Vestige today.");
            return;
        }
        BinderNUIResetDraft(oPC);
        SetLocalInt(oPC, PRC_BINDER_NUI_SELECTED_ROW_VAR, nRow);
        SetLocalInt(oPC, PRC_BINDER_NUI_STAGE_VAR, PRC_BINDER_NUI_STAGE_EXPEL_CONFIRM);
        BNDRefresh(oPC, nToken);
        return;
    }

    if (sElement == PRC_BINDER_NUI_CHOICE_LIST)
    {
        int nChoice = BinderNUIGetMappedChoice(oPC, nArrayIndex);
        if (nChoice < 0 || nButton != NUI_PAYLOAD_BUTTON_LEFT_CLICK)
            return;

        if (nStage == PRC_BINDER_NUI_STAGE_EXPLOIT)
        {
            int nRow = GetLocalInt(oPC, PRC_BINDER_NUI_SELECTED_ROW_VAR);
            if (nChoice > 0
                && StringToInt(Get2DACache("vestigeabil", "VestigeNum", nChoice)) != nRow)
                return;
            if (nChoice > 0)
                SetLocalInt(oPC, PRC_BINDER_NUI_EXPLOIT_VAR, nChoice);
            else
                DeleteLocalInt(oPC, PRC_BINDER_NUI_EXPLOIT_VAR);
            SetLocalInt(oPC, PRC_BINDER_NUI_STAGE_VAR, PRC_BINDER_NUI_STAGE_METHOD);
            BinderNUIBuildMethodChoices(oPC);
            BNDRefresh(oPC, nToken);
            return;
        }
        if (nStage == PRC_BINDER_NUI_STAGE_METHOD)
        {
            if (nChoice == PRC_BINDER_NUI_METHOD_RAPID
                && (!GetHasFeat(FEAT_RAPID_PACT_MAKING, oPC)
                    || GetLocalInt(oPC, "RapidPactMaking")))
                return;
            if (nChoice < PRC_BINDER_NUI_METHOD_NORMAL
                || nChoice > PRC_BINDER_NUI_METHOD_RAPID)
                return;
            SetLocalInt(oPC, PRC_BINDER_NUI_METHOD_VAR, nChoice);
            BinderNUIAdvanceAfterMethod(oPC);
            BNDRefresh(oPC, nToken);
            return;
        }
        if (nStage == PRC_BINDER_NUI_STAGE_AUGMENT)
        {
            if (BinderNUIAugmentAdd(oPC, nChoice))
                BNDRefresh(oPC, nToken);
            return;
        }
        if (nStage == PRC_BINDER_NUI_STAGE_NABERIUS)
        {
            if (BinderNUINaberiusAdd(oPC, nChoice))
            {
                BinderNUIBuildNaberiusChoices(oPC);
                BNDRefresh(oPC, nToken);
            }
            return;
        }
        if (nStage == PRC_BINDER_NUI_STAGE_ASTAROTH)
        {
            if (!BinderNUIIsAstarothFeatValid(oPC, nChoice))
                return;
            SetLocalInt(oPC, PRC_BINDER_NUI_ASTAROTH_VAR, nChoice);
            SetLocalInt(oPC, PRC_BINDER_NUI_STAGE_VAR, PRC_BINDER_NUI_STAGE_BIND_CONFIRM);
            BinderNUIClearTransientMaps(oPC);
            BNDRefresh(oPC, nToken);
            return;
        }
        if (nStage == PRC_BINDER_NUI_STAGE_EXPLOIT_SPELL)
        {
            if (nChoice <= 0 || !GetLocalInt(oPC, PRC_BINDER_NUI_PENDING_SPELL_VAR))
                return;
            SetLocalInt(oPC, "ExploitVestigeSpell", nChoice);
            DeleteLocalInt(oPC, PRC_BINDER_NUI_PENDING_SPELL_VAR);
            SendMessageToPC(oPC, "Exploit Vestige bonus spell selected: "
                + GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nChoice))));
            BNDRememberGeometry(oPC, nToken);
            BinderNUIDiscardDraft(oPC);
            return;
        }
    }

    if (sElement == PRC_BINDER_NUI_RESET_BUTTON)
    {
        if (nButton != NUI_PAYLOAD_BUTTON_LEFT_CLICK)
            return;
        if (nStage == PRC_BINDER_NUI_STAGE_AUGMENT)
        {
            SetLocalJson(oPC, PRC_BINDER_NUI_AUGMENT_VAR, BinderNUINewAugmentDraft());
            BinderNUIBuildAugmentChoices(oPC);
            BNDRefresh(oPC, nToken);
        }
        else if (nStage == PRC_BINDER_NUI_STAGE_NABERIUS)
        {
            SetLocalJson(oPC, PRC_BINDER_NUI_NABERIUS_VAR, JsonArray());
            BinderNUIBuildNaberiusChoices(oPC);
            BNDRefresh(oPC, nToken);
        }
        return;
    }

    if (sElement == PRC_BINDER_NUI_CONTINUE_BUTTON)
    {
        if (nButton != NUI_PAYLOAD_BUTTON_LEFT_CLICK)
            return;
        if (nStage == PRC_BINDER_NUI_STAGE_AUGMENT)
        {
            if (BinderNUIAugmentTotal(oPC) != GetPactAugmentCount(oPC))
                return;
            BinderNUIAdvanceAfterAugment(oPC);
            BNDRefresh(oPC, nToken);
            return;
        }
        if (nStage == PRC_BINDER_NUI_STAGE_NABERIUS)
        {
            json jNab = GetLocalJson(oPC, PRC_BINDER_NUI_NABERIUS_VAR);
            if (JsonGetType(jNab) != JSON_TYPE_ARRAY
                || JsonGetLength(jNab) != GetAbilityModifier(ABILITY_CONSTITUTION, oPC))
                return;
            BinderNUIAdvanceAfterNaberius(oPC);
            BNDRefresh(oPC, nToken);
            return;
        }
        if (nStage == PRC_BINDER_NUI_STAGE_BIND_CONFIRM)
        {
            BNDRememberGeometry(oPC, nToken);
            AssignCommand(oPC, ClearAllActions(TRUE));
            if (BinderNUIBeginBinding(oPC))
                BinderNUIDiscardDraft(oPC);
            return;
        }
        if (nStage == PRC_BINDER_NUI_STAGE_EXPEL_CONFIRM)
        {
            BNDRememberGeometry(oPC, nToken);
            AssignCommand(oPC, ClearAllActions(TRUE));
            if (BinderNUIBeginExpel(oPC))
                BinderNUIDiscardDraft(oPC);
            return;
        }
    }
}
