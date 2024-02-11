/*:://////////////////////////////////////////////
//:: Name Spell: Song of Discord Action (Heartbeat script)
//:: FileName SMP_ail_songdisc
//:://////////////////////////////////////////////
    If they ONLY have Song Of Discord's effects, this means we have a 50% chance
    of attacking the nearest alive creature (who is not dying) with the most
    powerful thing.

    This is the script which chooses "the most powerful thing". It runs through
    all hostile spells, depending on thier level (lower spells are more randomly
    cast if they are quite low).

    It'll always attack in melee.

    It attacks the nearest seen creature (living) or, failing that, the nearest
    heard.

    This mearly does a call of one or two (two for a melee or range attack)
    Action*** calls.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_AILMENT"

void main()
{
    // Default for now: attack nearest creature we can see
    object oSelf = OBJECT_SELF;
    object oTarget = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE, oSelf, 1,
                                        CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);
    // If no valid seen target, get nearest heard
    if(!GetIsObjectValid(oTarget))
    {
        oTarget = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE, oSelf, 1,
                                     CREATURE_TYPE_PERCEPTION, PERCEPTION_HEARD);
        // If it still is not valid, we will attack ourselves due to discord...

        // Might remove, its just funny :-)
        if(!GetIsObjectValid(oTarget))
        {
            // Stop
            ClearAllActions();
            // Most damaging melee weapon and loop animation
            ActionEquipMostDamagingMelee();
            ActionPlayAnimation(ANIMATION_FIREFORGET_SPASM);
            // Do damage to us
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(1), oSelf);
            // Wait
            ActionWait(5.0);
            // Stop the script
            return;
        }
    }
    // Attack oTarget
    // Stop
    ClearAllActions();
    // Most damaging melee weapon
    ActionEquipMostDamagingMelee();
    // Attack
    ActionAttack(oTarget);
}
