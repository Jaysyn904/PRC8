//::///////////////////////////////////////////////
//:: Power Attack Events
//:: hp_pa_events
//:://////////////////////////////////////////////
/*
    The NUI events for the Power Attack NUI Window
*/
//:://////////////////////////////////////////////
//:: Created By: Rakiov
//:: Created On: 22.05.2005
//:://////////////////////////////////////////////

#include "nw_inc_nui"
#include "hp_pa_view"

//
// SetWindowGeometry
// Sets the window geometry for the Power Attack NUI to the player
// so it can be remembered when opened next time
//
// Arguments:
//   oPlayer object the player that owns the window
//   nToken int the windowId
//
void SetWindowGeometry(object oPlayer, int nToken);

void main()
{
    object oPlayer   = NuiGetEventPlayer();
    int nToken               = NuiGetEventWindow();
    string sEvent    = NuiGetEventType();
    string sElement  = NuiGetEventElement();
    int nIndex               = NuiGetEventArrayIndex();
    string sWindowId = NuiGetWindowId(oPlayer, nToken);

    //HandleWindowInspectorEvent(); // used to debug

    if(sWindowId != NUI_PRC_POWER_ATTACK_WINDOW)
    {
        return;
    }

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

    int currentBAB = GetBaseAttackBonus(oPlayer);

    if (sElement == NUI_PRC_PA_LEFT_BUTTON_EVENT)
    {
        // if the decreased power attack doesn't go below 0 then perform PA decrease
        if(currentPAAmount-1 >= 0)
        {
            SetLocalInt(oPlayer, "PRC_PowerAttack_Level", currentPAAmount-1);
            ExecuteScript("hp_pa_script", oPlayer);
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
            ExecuteScript("hp_pa_script", oPlayer);
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

    // set the geometry to the player since we only get mouseup events on button presses :(
    NuiSetBind(oPlayer, nToken, NUI_PRC_PA_TEXT_BIND, JsonString(IntToString(currentPAAmount)));
    SetWindowGeometry(oPlayer, nToken);
}

void SetWindowGeometry(object oPlayer, int nToken)
{
    json dimensions = NuiGetBind(oPlayer, nToken, "geometry");
    SetLocalJson(oPlayer, NUI_PRC_PA_GEOMETRY_VAR, dimensions);
}