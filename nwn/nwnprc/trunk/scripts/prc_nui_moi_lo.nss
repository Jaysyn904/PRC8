//::///////////////////////////////////////////////
//:: Open the Incarnum live allocation NUI
//:: prc_nui_moi_lo
//:://////////////////////////////////////////////

#include "prc_nui_moi_liv"

void main()
{
    object oPC = OBJECT_SELF;
    if (!GetIsPC(oPC))
        return;

    if (!NuiFindWindow(oPC, PRC_MOI_LIVE_NUI_WINDOW_ID))
    {
        MoiLiveClearState(oPC);
        SetLocalJson(oPC, PRC_MOI_LIVE_DRAFT_VAR, MoiLiveBuildMovable(oPC));
        SetLocalInt(
            oPC,
            PRC_MOI_LIVE_PAGE_VAR,
            PRC_MOI_LIVE_PAGE_MOVABLE
        );
    }
    ExecuteScript("prc_nui_moi_lv", oPC);
}
