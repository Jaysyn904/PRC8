//::///////////////////////////////////////////////
//:: Open the Incarnum Loadout editor
//:: prc_nui_moi_ed
//:://////////////////////////////////////////////

#include "prc_nui_moi_pln"

void main()
{
    object oPC = OBJECT_SELF;
    if (!GetIsPC(oPC) || !MoiLoadoutHasShapingClass(oPC))
    {
        SendMessageToPC(oPC, "This character has no soulmeld loadout to plan.");
        return;
    }

    int nWindow = NuiFindWindow(oPC, PRC_MOI_LOADOUT_NUI_WINDOW_ID);
    int bActive = GetLocalInt(oPC, PRC_MOI_LOADOUT_ACTIVE_VAR);
    if (bActive && !nWindow)
    {
        MoiLoadoutDiscardDraft(oPC, FALSE);
        bActive = FALSE;
    }
    if (!bActive && !MoiLoadoutInitialize(oPC))
        return;

    ExecuteScript("prc_nui_moi_vw", oPC);
}

