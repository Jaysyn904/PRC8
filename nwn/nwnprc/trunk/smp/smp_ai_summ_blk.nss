/*:://////////////////////////////////////////////
//:: Name Summon Monster - On Blocked
//:: FileName SMP_AI_Summ_Blk
//:://////////////////////////////////////////////
    On Blocked. Will not use lockpicking skill, but will either bash the door
    down, or open it if they have hands.

    On Blocked can run for creatures or doors.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_AI_INCLUDE"

void main()
{
    // Get blocking door or creature.
    object oDoor = GetBlockingDoor();
    int nObjectType = GetObjectType(oDoor);

    // Must be a door.
    if(GetIsObjectValid(oDoor) && nObjectType == OBJECT_TYPE_DOOR)
    {
        // Check if we know it is trapped, we won't open it. Only will not open/
        // bash if there is no trap known about
        if(!GetIsTrapped(oDoor) || !GetTrapDetectedBy(oDoor, OBJECT_SELF))
        {
            if(SMPAI_GetSummonSetting(SMPAI_SUMMON_CANNOT_DOOR_OPEN) &&
               GetIsDoorActionPossible(oDoor, DOOR_ACTION_OPEN))
            {
                DoDoorAction(oDoor, DOOR_ACTION_OPEN);
                return;
            }
            else if(!SMPAI_GetSummonSetting(SMPAI_SUMMON_CANNOT_DOOR_BASH) &&
                    GetIsDoorActionPossible(oDoor, DOOR_ACTION_BASH))
            {
                DoDoorAction(oDoor, DOOR_ACTION_BASH);
                return;
            }
        }
        return;
    }
    else if(nObjectType == OBJECT_TYPE_CREATURE)
    {
        // Do nothing
        return;
    }
}
