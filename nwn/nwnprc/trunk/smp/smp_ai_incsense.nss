/*:://////////////////////////////////////////////
//:: Name AI Senses include.
//:: FileName SMP_AI_INCSENSE
//:://////////////////////////////////////////////
//:: Description
//:://////////////////////////////////////////////
    Include file for Tremmorsense, scent and so on.

    Tremmorsense:

    Tremorsense (Ex): A creature can detect and pinpoint any creature or
    object within 20 meters (60 feet) in contact with the ground.
    - 20M can be different.


    BLINDSIGHT AND BLINDSENSE

    Blindsense (Ex): Using nonvisual senses, such as acute smell or hearing, a
    creature with blindsense notices things it cannot see. The creature usually
    does not need to make Spot or Listen checks to pinpoint the location of a
    creature within range of its blindsense ability, provided that it has line
    of effect to that creature. Any opponent the creature cannot see still has
    total concealment against the creature with blindsense, and the creature
    still has the normal miss chance when attacking foes that have concealment.
    Visibility still affects the movement of a creature with blindsense. A
    creature with blindsense is still denied its Dexterity bonus to Armor Class
    against attacks from creatures it cannot see.


    Blindsight (Ex): This ability is similar to blindsense, but is far more
    discerning. Using nonvisual senses, such as sensitivity to vibrations, keen
    smell, acute hearing, or echolocation, a creature with blindsight maneuvers
    and fights as well as a sighted creature. Invisibility, darkness, and most
    kinds of concealment are irrelevant, though the creature must have line of
    effect to a creature or object to discern that creature or object. The
    ability’s range is specified in the creature’s descriptive text. The
    creature usually does not need to make Spot or Listen checks to notice
    creatures within range of its blindsight ability. Unless noted otherwise,
    blindsight is continuous, and the creature need do nothing to use it. Some
    forms of blindsight, however, must be triggered as a free action. If so,
    this is noted in the creature’s description. If a creature must trigger its
    blindsight ability, the creature gains the benefits of blindsight only
    during its turn.

    Special abilties descriptions:

    Some creatures have blindsight, the extraordinary ability to use a nonvisual
    sense (or a combination of such senses) to operate effectively without
    vision. Such sense may include sensitivity to vibrations, acute scent, keen
    hearing, or echolocation. This ability makes invisibility and concealment
    (even magical darkness) irrelevant to the creature (though it still can’t
    see ethereal creatures). This ability operates out to a range specified in
    the creature description.

    * Blindsight never allows a creature to distinguish color or visual
      contrast. A creature cannot read with blindsight.
    * Blindsight does not subject a creature to gaze attacks (even though
      darkvision does).
    * Blinding attacks do not penalize creatures using blindsight.
    * Deafening attacks thwart blindsight if it relies on hearing.
    * Blindsight works underwater but not in a vacuum.
    * Blindsight negates displacement and blur effects.

    Blindsense: Other creatures have blindsense, a lesser ability that lets the
    creature notice things it cannot see, but without the precision of
    blindsight. The creature with blindsense usually does not need to make Spot
    or Listen checks to notice and locate creatures within range of its
    blindsense ability, provided that it has line of effect to that creature.
    Any opponent the creature cannot see has total concealment (50% miss chance)
    against the creature with blindsense, and the blindsensing creature still
    has the normal miss chance when attacking foes that have concealment.
    Visibility still affects the movement of a creature with blindsense. A
    creature with blindsense is still denied its Dexterity bonus to Armor Class
    against attacks from creatures it cannot see.



    Scent (Ex): This special quality allows a creature to detect approaching
    enemies, sniff out hidden foes, and track by sense of smell. Creatures with
    the scent ability can identify familiar odors just as humans do familiar
    sights.

    The creature can detect opponents within 10M (30 feet) by sense of smell. If
    the opponent is upwind, the range increases to 20M (60 feet); if downwind, it
    drops to 5M (15 feet). Strong scents, such as smoke or rotting garbage, can be
    detected at twice the ranges noted above. Overpowering scents, such as
    skunk musk or troglodyte stench, can be detected at triple normal range.

    When a creature detects a scent, the exact location of the source is not
    revealed—only its presence somewhere within range. The creature can take
    a move action to note the direction of the scent.

    Whenever the creature comes within 1.5M (5 feet) of the source, the creature
    pinpoints the source’s location.

    Creatures with the scent ability can identify familiar odors just as
    humans do familiar sights.

    Water, particularly running water, ruins a trail for air-breathing
    creatures. Water-breathing creatures that have the scent ability, however,
    can use it in the water easily.

    False, powerful odors can easily mask other scents. The presence of such an
    odor completely spoils the ability to properly detect or identify creatures,
    and the base Survival DC to track becomes 20 rather than 10.

    Tremorsense (Ex): A creature with tremorsense is sensitive to vibrations
    in the ground and can automatically pinpoint the location of anything that
    is in contact with the ground. The ability’s range is specified in the
    creature’s descriptive text.

    A creature with tremorsense automatically senses the location of anything
    that is in contact with the ground and within range.

    If no straight path exists through the ground from the creature to those
    that it’s sensing, then the range defines the maximum distance of the
    shortest indirect path. It must itself be in contact with the ground, and
    the creatures must be moving.

    As long as the other creatures are taking physical actions, including
    casting spells with somatic components, they’re considered moving; they
    don’t have to move from place to place for a creature with tremorsense
    to detect them.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

// Include constants
#include "SMP_INC_CONSTANTS"

// Returns a creature we cannot see or hear, but can sense by them moving.
// If they have moved since the last time we used this, or are moving now, and
// are within the range of 20M, we attack them.
object SMPAI_Tremmorsense();

// Returns, for searching, an object we can smell within 10M.
object SMPAI_ScentSearch();
// Returns, if any, an object which is detected within 1.5M we can smell.
object SMPAI_ScentAttack();

// Returns a creature we cannot see or hear, but can sense by them moving.
// If they have moved since the last time we used this, or are moving now, and
// are within the range of 20M, we attack them.
object SMPAI_Tremmorsense()
{
    // Check if anyone is within 20M we cannot see or hear
    int nNth = 1;
    object oTest = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE, OBJECT_SELF, nNth, CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, CREATURE_TYPE_PERCEPTION, PERCEPTION_NOT_SEEN_AND_NOT_HEARD);
    while(GetIsObjectValid(oTest) && GetDistanceToObject(oTest) <= 20.0)
    {
        // If they are moving
        if(GetCurrentAction(oTest) == ACTION_MOVETOPOINT)
        {
            // Return this object
            return oTest;
        }
        nNth++;
        oTest = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE, OBJECT_SELF, nNth, CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, CREATURE_TYPE_PERCEPTION, PERCEPTION_NOT_SEEN_AND_NOT_HEARD);
    }
    // Nothing found to attack
    return OBJECT_INVALID;
}

// Returns, for searching, an object we can smell within 10M.
object SMPAI_ScentSearch()
{
    // Check if anyone is within 10M we cannot see or hear
    object oTest = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE, OBJECT_SELF, 1, CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, CREATURE_TYPE_PERCEPTION, PERCEPTION_NOT_SEEN_AND_NOT_HEARD);
    if(GetIsObjectValid(oTest) && GetDistanceToObject(oTest) <= 10.0)
    {
        // Return this object
        return oTest;
    }
    // Nothing found to attack
    return OBJECT_INVALID;
}

// Returns, if any, an object which is detected within 1.5M we can smell.
object SMPAI_ScentAttack()
{
    // Check if anyone is moving within 1.5M we cannot see or hear
    object oTest = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE, OBJECT_SELF, 1, CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, CREATURE_TYPE_PERCEPTION, PERCEPTION_NOT_SEEN_AND_NOT_HEARD);
    if(GetIsObjectValid(oTest) && GetDistanceToObject(oTest) <= 1.5)
    {
        // Return this object
        return oTest;
    }
    // Nothing found to attack
    return OBJECT_INVALID;
}

