/*:://////////////////////////////////////////////
//:: Name On Heartbeat: Mage's Sword
//:: FileName SMP_AI_MageSwrd2
//:://////////////////////////////////////////////
    On Heartbeat.

    This will move to the caster if we become more then 8M away, or the caster
    cannot see us, and

    1 = Spawn, 2 = Heartbeat. They do all the work. This creature
    is plotted as it is a force creature.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_AI_INCLUDE"

void main()
{
    // Get master caster blaster raster daster...
    object oCaster = GetMaster();
    object oSelf = OBJECT_SELF;

    // Else, move to them if we are more then 8M away, or they cannot see us...
    if(GetArea(oCaster) != GetArea(oSelf) ||
       GetDistanceToObject(oCaster) > RANGE_SPELL_CLOSE ||
      !GetObjectSeen(oSelf, oCaster))
    {
        // Move to the master
        ClearAllActions();
        ActionForceFollowObject(oCaster, 2.0);
    }
    else
    {
        // Get nearest enemy
        object oEnemy = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY,
                                           oSelf, 1,
                                           CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN,
                                           CREATURE_TYPE_IS_ALIVE, TRUE);
        // Attack if valid
        if(GetIsObjectValid(oEnemy) && GetDistanceBetween(oEnemy, oCaster) <= 10.0)
        {
            ClearAllActions();
            ActionAttack(oEnemy);
        }
        else
        {
            // Move to the master
            ClearAllActions();
            ActionForceFollowObject(oCaster, 2.0);
        }
    }
}
