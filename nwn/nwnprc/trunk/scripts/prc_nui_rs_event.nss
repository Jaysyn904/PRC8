//::///////////////////////////////////////////////
//:: PRC Character Resource NUI - events
//:: prc_nui_rs_event
//:://////////////////////////////////////////////

#include "prc_nui_res_inc"

void main()
{
    object oPC = NuiGetEventPlayer();
    int nToken = NuiGetEventWindow();
    string sEvent = NuiGetEventType();
    string sElement = NuiGetEventElement();

    if (sEvent == "watch" && sElement == "geometry")
    {
        SetLocalJson(oPC, NUI_PRC_RESOURCE_GEOMETRY_VAR, NuiGetBind(oPC, nToken, "geometry"));
        return;
    }

    if (sEvent == "close")
    {
        SetLocalInt(oPC, NUI_PRC_RESOURCE_GENERATION_VAR,
            GetLocalInt(oPC, NUI_PRC_RESOURCE_GENERATION_VAR) + 1);
        return;
    }

    if (sEvent != "mouseup" || sElement != NUI_PRC_RESOURCE_FOCUS_BUTTON)
        return;

    if (GetMaximumPowerPoints(oPC) <= 0)
        return;

    if (GetIsPsionicallyFocused(oPC))
    {
        SendMessageToPC(oPC, "You are already Psionically Focused.");
        return;
    }

    if (GetCurrentPowerPoints(oPC) <= 0)
    {
        SendMessageToPC(oPC, "You have no Power Points and cannot gain Psionic Focus.");
        return;
    }

    // Use the real PRC radial action so Concentration, action time, feats, and
    // failure behavior remain identical to gaining focus from the radial menu.
    AssignCommand(oPC,
        ActionUseFeat(FEAT_PSIONIC_FOCUS, oPC, NUI_PRC_RESOURCE_FOCUS_GAIN_SPELL));
}

