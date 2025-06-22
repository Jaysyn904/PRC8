//::///////////////////////////////////////////////
//:: PRC Level Up NUI Events
//:: prc_nui_lv_event
//:://////////////////////////////////////////////
/*
    This is the logic that handles the events for the Level Up NUI
*/
//:://////////////////////////////////////////////
//:: Created By: Rakiov
//:: Created On: 20.06.2005
//:://////////////////////////////////////////////

#include "prc_nui_lv_inc"

void SetupAndCallSpellDescriptionNUI(object oPlayer, int spellbookId, int classId)
{
    string sFile = GetClassSpellbookFile(classId);
    int featId = StringToInt(Get2DACache(sFile, "FeatID", spellbookId));
    int spellId = StringToInt(Get2DACache(sFile, "SpellID", spellbookId));
    int realSpellId = StringToInt(Get2DACache(sFile, "RealSpellID", spellbookId));

    CreateSpellDescriptionNUI(oPlayer, featId, spellId, realSpellId, classId);
}

void main()
{
    object oPlayer   = NuiGetEventPlayer();
    int nToken               = NuiGetEventWindow();
    string sEvent    = NuiGetEventType();
    string sElement  = NuiGetEventElement();
    string sWindowId = NuiGetWindowId(oPlayer, nToken);

    // Not a mouseup event, nothing to do.
    if (sEvent != "mouseup")
    {
        return;
    }

    // we clicked a spell circle, set the selected circle to the new one and refresh the window
    if (FindSubString(sElement, NUI_LEVEL_UP_SPELL_CIRCLE_BUTTON_BASEID) >= 0)
    {
        int selectedCircle = StringToInt(RegExpReplace(NUI_LEVEL_UP_SPELL_CIRCLE_BUTTON_BASEID, sElement, ""));
        SetLocalInt(oPlayer, NUI_LEVEL_UP_SELECTED_CIRCLE_VAR, selectedCircle);
        CloseNUILevelUpWindow(oPlayer);
        ExecuteScript("prc_nui_lv_view", oPlayer);
        return;
    }

    json jPayload = NuiGetEventPayload();
    int nButton = JsonGetInt(JsonObjectGet(jPayload, "mouse_btn"));

    if (FindSubString(sElement, NUI_LEVEL_UP_SPELL_DISABLED_BUTTON_BASEID) >= 0)
    {
        int spellbookId = StringToInt(RegExpReplace(NUI_LEVEL_UP_SPELL_DISABLED_BUTTON_BASEID, sElement, ""));
        int classId = GetLocalInt(oPlayer, NUI_LEVEL_UP_SELECTED_CLASS_VAR);

        //  we right clicked a disabled button, tell what the spell is
        if (nButton == NUI_PAYLOAD_BUTTON_RIGHT_CLICK)
        {
            SetupAndCallSpellDescriptionNUI(oPlayer, spellbookId, classId);
            return;
        }
        // we left clicked a disabled button, tell why it was disables
        if (nButton == NUI_PAYLOAD_BUTTON_LEFT_CLICK)
        {
            SendMessageToPC(oPlayer, ReasonForDisabledSpell(classId, spellbookId, oPlayer));
            return;
        }
    }

    if (FindSubString(sElement, NUI_LEVEL_UP_SPELL_CHOSEN_DISABLED_BUTTON_BASEID) >= 0)
    {
        int spellbookId = StringToInt(RegExpReplace(NUI_LEVEL_UP_SPELL_CHOSEN_DISABLED_BUTTON_BASEID, sElement, ""));
        int classId = GetLocalInt(oPlayer, NUI_LEVEL_UP_SELECTED_CLASS_VAR);

        //  we right clicked a disabled button, tell what the spell is
        if (nButton == NUI_PAYLOAD_BUTTON_RIGHT_CLICK)
        {
            SetupAndCallSpellDescriptionNUI(oPlayer, spellbookId, classId);
            return;
        }
        // we left clicked a disabled button, tell why it was disabled
        if (nButton == NUI_PAYLOAD_BUTTON_LEFT_CLICK)
        {
            SendMessageToPC(oPlayer, ReasonForDisabledChosen(classId, spellbookId, oPlayer));
            return;
        }
    }

    if (FindSubString(sElement, NUI_LEVEL_UP_SPELL_BUTTON_BASEID) >= 0)
    {
        int spellbookId = StringToInt(RegExpReplace(NUI_LEVEL_UP_SPELL_BUTTON_BASEID, sElement, ""));
        int classId = GetLocalInt(oPlayer, NUI_LEVEL_UP_SELECTED_CLASS_VAR);

        // If right click, open the Spell Description NUI
        if (nButton == NUI_PAYLOAD_BUTTON_RIGHT_CLICK)
        {
            SetupAndCallSpellDescriptionNUI(oPlayer, spellbookId, classId);
            return;
        }
        // we are adding the spell to the chosen spell list then refreshing the window
        if (nButton == NUI_PAYLOAD_BUTTON_LEFT_CLICK)
        {
            int chosenCircle = GetLocalInt(oPlayer, NUI_LEVEL_UP_SELECTED_CIRCLE_VAR);

            AddSpellToChosenList(classId, spellbookId, chosenCircle, oPlayer);
            CloseNUILevelUpWindow(oPlayer);
            ExecuteScript("prc_nui_lv_view", oPlayer);
        }
        return;
    }

    if (FindSubString(sElement, NUI_LEVEL_UP_SPELL_CHOSEN_BUTTON_BASEID) >= 0)
    {
        int spellbookId = StringToInt(RegExpReplace(NUI_LEVEL_UP_SPELL_CHOSEN_BUTTON_BASEID, sElement, ""));
        int classId = GetLocalInt(oPlayer, NUI_LEVEL_UP_SELECTED_CLASS_VAR);


        json jPayload = NuiGetEventPayload();
        int nButton = JsonGetInt(JsonObjectGet(jPayload, "mouse_btn"));

        // If right click, open the Spell Description NUI
        if (nButton == NUI_PAYLOAD_BUTTON_RIGHT_CLICK)
        {
            SetupAndCallSpellDescriptionNUI(oPlayer, spellbookId, classId);
            return;
        }
        // we are removing a chosen spell from the chosen list then refreshing the window
        if (nButton == NUI_PAYLOAD_BUTTON_LEFT_CLICK)
        {
            int chosenCircle = GetLocalInt(oPlayer, NUI_LEVEL_UP_SELECTED_CIRCLE_VAR);

            RemoveSpellFromChosenList(classId, spellbookId, chosenCircle, oPlayer);
            CloseNUILevelUpWindow(oPlayer);
            ExecuteScript("prc_nui_lv_view", oPlayer);
        }
        return;
    }
    // we are resetting our choices
    if (sElement == NUI_LEVEL_UP_RESET_BUTTON)
    {
        ResetChoices(oPlayer);
        CloseNUILevelUpWindow(oPlayer);
        ExecuteScript("prc_nui_lv_view", oPlayer);
        return;
    }
    // finalize all our choices
    if (sElement == NUI_LEVEL_UP_DONE_BUTTON)
    {
        int classId = GetLocalInt(oPlayer, NUI_LEVEL_UP_SELECTED_CLASS_VAR);
        FinishLevelUp(classId, oPlayer);
        CloseNUILevelUpWindow(oPlayer);
        ExecuteScript("prc_amagsys_gain", oPlayer);
        DelayCommand(0.2f, ExecuteScript("prc_nui_sb_view", oPlayer));
        return;
    }
}

