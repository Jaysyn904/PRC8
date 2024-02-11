/*:://////////////////////////////////////////////
//:: Name Summon Monster - On Heartbeat
//:: FileName SMP_AI_Summ_Hert
//:://////////////////////////////////////////////
    On Heartbeat.

    Moves to the caster, depending on orders.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_AI_INCLUDE"

void main()
{
    // Delcare major variables
    object oSelf = OBJECT_SELF;
    object oMaster = GetMaster();

    // Check if in combat and moving or not
    if(!GetIsInCombat() && GetCurrentAction() != ACTION_MOVETOPOINT)
    {
        // Move to the master
        ClearAllActions();
        ActionForceFollowObject(oMaster, 2.0);
    }
}
