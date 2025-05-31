//::///////////////////////////////////////////////
//:: Power Attack NUI Events
//:: prc_nui_pa_event
//:://////////////////////////////////////////////
/*
    A class that handles the event firings from 
	the Power Attack NUI
*/
//:://////////////////////////////////////////////
//:: Created By: Rakiov
//:: Created On: 24.05.2005
//:://////////////////////////////////////////////

#include "prc_nui_consts"

void SetWindowGeometry(object oPlayer, int nToken);

void main()
{
    object oPlayer   = NuiGetEventPlayer();
    int nToken               = NuiGetEventWindow();
    string sEvent    = NuiGetEventType();
    string sElement  = NuiGetEventElement();
    int nIndex               = NuiGetEventArrayIndex();


    // Get the current Power Attack value for player
    int currentPAAmount = GetLocalInt(oPlayer, "PRC_PowerAttack_Level");

    // if the window is closed, save the geometry
    if (sEvent == "close")
    {
        SetWindowGeometry(oPlayer, nToken);
        return;
    }

    // Not a mouseup event, nothing to do.
    if (sEvent != "mouseup")
    {
        return;
    }

    // set the geometry to the player since we only get mouseup events on button presses :(
    SetWindowGeometry(oPlayer, nToken);

    int currentBAB = GetBaseAttackBonus(oPlayer);

    if (sElement == NUI_PRC_PA_LEFT_BUTTON_EVENT)
    {
        // if the decreased power attack doesn't go below 0 then perform PA decrease
        if(currentPAAmount-1 >= 0)
        {
            SetLocalInt(oPlayer, "PRC_PowerAttack_Level", currentPAAmount-1);
            ExecuteScript("prc_nui_pa_trggr", oPlayer);
            // if decreased pwoer attack is lower than the current BAB then allow
            // the incrase button
            if(currentPAAmount-1 <= currentBAB)
            {
                NuiSetBind(oPlayer, nToken, NUI_PRC_PA_RIGHT_BUTTON_ENABLED_BIND, JsonBool(TRUE));
            }
        }
        else
        {
            // otherwise we have hit the limit and disable the left button
            NuiSetBind(oPlayer, nToken, NUI_PRC_PA_LEFT_BUTTON_ENABLED_BIND, JsonBool(FALSE));
        }
    }

    if (sElement == NUI_PRC_PA_RIGHT_BUTTON_EVENT)
    {
        //if the incrased power attack amount is less than or equal to the BAB
        // then perform the PA increase
        if(currentPAAmount+1 <= currentBAB)
        {
            SetLocalInt(oPlayer, "PRC_PowerAttack_Level", currentPAAmount+1);
            ExecuteScript("prc_nui_pa_trggr", oPlayer);
            // if the increased power attack amount is greater than 0 then enable
            // the decrease button
            if (currentPAAmount+1 > 0)
            {
                NuiSetBind(oPlayer, nToken, NUI_PRC_PA_LEFT_BUTTON_ENABLED_BIND, JsonBool(TRUE));
            }
        }
        else
        {
            // otherwise we have hit the limit and disable the right button
            NuiSetBind(oPlayer, nToken, NUI_PRC_PA_RIGHT_BUTTON_ENABLED_BIND, JsonBool(FALSE));
        }
    }

    currentPAAmount = GetLocalInt(oPlayer, "PRC_PowerAttack_Level");

    NuiSetBind(oPlayer, nToken, NUI_PRC_PA_TEXT_BIND, JsonString(IntToString(currentPAAmount)));
}

void SetWindowGeometry(object oPlayer, int nToken)
{
    json dimensions = NuiGetBind(oPlayer, nToken, "geometry");
    SetLocalJson(oPlayer, NUI_PRC_PA_GEOMETRY_VAR, dimensions);
}
