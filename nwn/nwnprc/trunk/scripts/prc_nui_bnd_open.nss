//::///////////////////////////////////////////////
//:: PRC Binder pact-management NUI opener
//:: prc_nui_bnd_open
//:://////////////////////////////////////////////

#include "prc_nui_bnd_inc"

void main()
{
    object oPC = OBJECT_SELF;
    if (!BinderNUIHasAccess(oPC))
    {
        SendMessageToPC(oPC, "You do not have Soul Binding or the Bind Vestige feat.");
        return;
    }

    // Do not let reopening the manager overwrite an in-progress ritual or a
    // mandatory good-pact Exploit Vestige spell selection.
    if (GetLocalInt(oPC, PRC_BINDER_NUI_RITUAL_TYPE_VAR))
    {
        SendMessageToPC(oPC, "Your current vestige ritual must finish first.");
        return;
    }
    if (GetLocalInt(oPC, PRC_BINDER_NUI_PENDING_SPELL_VAR)
        && GetLocalInt(oPC, PRC_BINDER_NUI_STAGE_VAR)
            == PRC_BINDER_NUI_STAGE_EXPLOIT_SPELL)
    {
        ExecuteScript("prc_nui_bnd_view", oPC);
        return;
    }

    BinderNUIStartSession(oPC);
    if (GetLocalInt(oPC, PRC_BINDER_NUI_ACTIVE_VAR))
        ExecuteScript("prc_nui_bnd_view", oPC);
}
