//::///////////////////////////////////////////////
//:: Toggle the standalone psionic configuration NUI
//:: prc_nui_psi_op
//:://////////////////////////////////////////////

#include "prc_nui_psi_inc"

void main()
{
    object oPC = OBJECT_SELF;
    if (!GetIsPC(oPC) || !NUISpellbookPsiHasContent(oPC))
        return;

    int nToken = NuiFindWindow(oPC, PRC_NUI_PSI_WINDOW_ID);
    if (nToken)
    {
        json jGeometry = NuiGetBind(oPC, nToken, "geometry");
        if (jGeometry != JsonNull())
            SetLocalJson(oPC, PRC_NUI_PSI_GEOMETRY_VAR, jGeometry);
        DeleteLocalInt(oPC, PRC_NUI_PSI_DEFAULT_CONFIRM_VAR);
        NuiDestroy(oPC, nToken);
        return;
    }
    ExecuteScript(PRC_NUI_PSI_VIEW_SCRIPT, oPC);
}
