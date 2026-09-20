//::///////////////////////////////////////////////
//:: Open the Incarnum Blade blademeld editor
//:: prc_nui_moi_bo
//:://////////////////////////////////////////////

#include "prc_nui_moi_bld"

void main()
{
    object oPC = OBJECT_SELF;
    if (!GetIsPC(oPC)
        || GetLevelByClass(CLASS_TYPE_INCARNUM_BLADE, oPC) <= 0)
        return;

    int nExisting = NuiFindWindow(oPC, PRC_MOI_BLADE_NUI_WINDOW_ID);
    if (nExisting && GetLocalInt(oPC, PRC_MOI_BLADE_ACTIVE_VAR))
        return;

    MoiBladeDiscardDraft(oPC, FALSE);
    MoiBladeOpenDraft(oPC);
    ExecuteScript("prc_nui_moi_bv", oPC);
}
