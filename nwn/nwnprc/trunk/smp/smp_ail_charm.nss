/*:://////////////////////////////////////////////
//:: Name Spell's Charm Heartbeat Script
//:: FileName SMP_ail_charm
//:://////////////////////////////////////////////
    This is run on heartbeat.

    It runs on PCs or NPCs. It uses the AI to target any enemies and
    attack them. Uses the default AI for now (SoU Version if possible).
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//:: Created On: October
//::////////////////////////////////////////////*/

#include "NW_I0_GENERIC"
#include "SMP_INC_AILMENT"

void main()
{
    // We can edit actions to...
    SetCommandable(TRUE);

    // Stop
    ClearAllActions();
    // Attack
    DetermineCombatRound();
    if(!GetIsInCombat(OBJECT_SELF))
    {
        // Follow after any actions.
        ActionForceFollowObject(GetMaster(), 5.0);
    }
    // Return to state of can't edit actions
    SetCommandable(FALSE);
}
