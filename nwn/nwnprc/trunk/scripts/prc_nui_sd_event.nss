//::///////////////////////////////////////////////
//:: PRC Spell Duration NUI Events
//:: prc_nui_sd_event
//:://////////////////////////////////////////////
/*
    This is the logic that handles the events for the Spell Duration NUI
*/
//:://////////////////////////////////////////////
//:: Created By: Rakiov
//:: Created On: 29.11.2025
//:://////////////////////////////////////////////

#include "prc_nui_lv_inc"

void RemoveSpellEffectBySpellID(int spellId, object oPC)
{
    effect selectedEffect = GetFirstEffect(oPC);
    while (GetIsEffectValid(selectedEffect))
    {
        int selectedSpellId = GetEffectSpellId(selectedEffect);
        if (selectedSpellId == spellId)
            RemoveEffect(oPC, selectedEffect);
        selectedEffect = GetNextEffect(oPC);
    }
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
    if (FindSubString(sElement, NUI_SPELL_DURATION_SPELLID_BASE_CANCEL_BUTTON) >= 0)
    {
        int spellId = StringToInt(RegExpReplace(NUI_SPELL_DURATION_SPELLID_BASE_CANCEL_BUTTON, sElement, ""));
        RemoveSpellEffectBySpellID(spellId, oPlayer);
        SetScriptParam(NUI_DURATION_NO_LOOP_PARAM, "1");
        ExecuteScript("prc_nui_dur_view", oPlayer);
        return;
    }
}

