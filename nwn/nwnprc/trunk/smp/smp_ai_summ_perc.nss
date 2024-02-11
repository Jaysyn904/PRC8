/*:://////////////////////////////////////////////
//:: Name Summon Monster - On Perception
//:: FileName SMP_AI_Summ_Perc
//:://////////////////////////////////////////////
    On Perception.

    Attacks the last person seen if it was an enemy. If it disappeared
    and was our target, we do another combat round.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_AI_INCLUDE"

void main()
{
    // Delcare major variables
    object oSelf = OBJECT_SELF;
    object oSeen = GetLastPerceived();
    object oMaster = GetMaster();
    int bHeard = GetLastPerceptionHeard();// If oSeen is NOW heard
    int bInaudible = GetLastPerceptionInaudible();// If oSeen is NOW not heard
    int bSeen = GetLastPerceptionSeen();//  If oSeen is NOW seen
    int bVanished = GetLastPerceptionVanished();//  If oSeen is NOW not seen
    int bEnemy = GetIsEnemy(oSeen);

    // Check if in combat
    if(!GetIsInCombat() && GetIsObjectValid(oSeen))
    {
        // Attack any enemy we see
        if(bEnemy)
        {
            if(bSeen || bHeard)
            {
                // Attack!
                SMPAI_SummonAttack(oSeen);
            }
            else if(bVanished || bInaudible)
            {
                if(GetLocalObject(oSelf, "SMPAI_LAST_TARGET") == oSeen)
                {
                    // Check area's. If they moved, and master is not in this area
                    // too, we follow
                    if(GetArea(oMaster) == GetArea(oSeen) &&
                       GetArea(oSeen) != GetArea(oSelf))
                    {
                        // Follow
                        ClearAllActions();
                        ActionMoveToObject(oSeen, TRUE);
                    }
                    else
                    {
                        // Reevaluate
                        SMPAI_SummonAttack();
                    }
                }
            }
        }
    }
}
