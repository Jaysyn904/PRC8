//::///////////////////////////////////////////////
//:: PRC Spell Description NUI Events
//:: prc_nui_dsc_evnt
//:://////////////////////////////////////////////
/*
    This is the event logic used for the spell description nui
*/
//:://////////////////////////////////////////////
//:: Created By: Rakiov
//:: Created On: 20.06.2005
//:://////////////////////////////////////////////

#include "prc_nui_consts"

void main()
{
    object oPlayer   = NuiGetEventPlayer();
    int nToken       = NuiGetEventWindow();
    string sEvent    = NuiGetEventType();
    string sElement  = NuiGetEventElement();
    string sWindowId = NuiGetWindowId(oPlayer, nToken);

    // if the OK button was clicked then we close the window.
    if (sElement == NUI_SPELL_DESCRIPTION_OK_BUTTON)
        DelayCommand(0.1f, NuiDestroy(oPlayer, nToken));
}

