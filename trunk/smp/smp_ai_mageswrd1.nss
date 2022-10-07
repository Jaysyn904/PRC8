/*:://////////////////////////////////////////////
//:: Name On Spawn: Mage's Sword
//:: FileName SMP_AI_MageSwrd1
//:://////////////////////////////////////////////
    On Spawn.

    This sets our attacks to 1 permamently.

    1 = Spawn, 2 = Spell Cast at, 3 = Heartbeat. They do all the work. This creature
    is plotted as it is a force creature.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_AI_INCLUDE"

void main()
{
    // No listening - does very little but attack.

    // Set attacks to 1
    SetBaseAttackBonus(1);
}
