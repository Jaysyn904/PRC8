/*:://////////////////////////////////////////////
//:: Spell Name Prismatic Sphere
//:: Spell FileName PHS_S_PrisSpher
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Abjuration
    Level: Sor/Wiz 7
    Components: V
    Casting Time: 1 standard action
    Range: 3.33M (10 ft.)
    Effect: 3.33M.-radius (10-ft.) sphere centered on you
    Duration: 1 min./level (D)
    Saving Throw: See text
    Spell Resistance: Yes

    You conjure up an immobile, opaque globe of shimmering, multicolored light
    that surrounds you and protects you from all forms of attack. The sphere
    flashes in all colors of the visible spectrum.

    Any other creature then yourself with less than 8 HD that is within 6.67M
    (20 feet) of the sphere, which is 10M (30ft) from the centre point, is
    blinded for 2d4x10 minutes by the colors (Spell resistance applies, no save).

    You can pass into and out of the prismatic sphere and remain near it without
    harm. However, when you’re inside it, the sphere blocks any attempt to
    project something through the sphere such as ranged weapons and including
    spells. Other creatures that attempt to attack you or pass through the
    sphere suffer a random effect of a color, randomly chosen from the table
    below.

    1d8 Color of Beam   Effect
    1   Red     20 points fire damage (Reflex half)
    2   Orange  40 points acid damage (Reflex half)
    3   Yellow  80 points electricity damage (Reflex half)
    4   Green   Poison (Kills; Fortitude partial, take 1d6 points of Con damage instead)
    5   Blue    Turned to stone (Fortitude negates)
    6   Indigo  Insane, as insanity spell (Will negates)
    7   Violet  Sent to another plane (Will negates)
    8   Struck by two colors; roll twice more, ignoring any “8” results.

    Typically, only the upper hemisphere of the globe will exist, since you
    are at the center of the sphere, so the lower half is usually excluded by
    the floor surface you are standing on. The sphere is affected by dispel
    magic as normal.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Changes include the fact it won't do all 7 effects, it is affected by dispel
    magic normally, it has a duration (might extend it higher, its a level 7
    spell).

    It still is immobile, and does blindness normally too (a second AOE)

    How does the spell stopping work?

    Well, it will add a new check into the spell hook. If we cast a spell
    into the AOE's location (can use GetNearestObjectByTag() and distance check)
    but we are not ourselves in it, it will fail.

    Ranged weapons have 100% miss chance from both inside and outside (100%
    concealment + 100% miss chance applied on enter, whatever).
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_PRISMATIC_SPHERE)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    location lTarget = GetSpellTargetLocation();// Should be OBJECT_SELF's location
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    // Duration - 1 minute/level
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel, nMetaMagic);

    // Declare effects
    effect eAOE = EffectAreaOfEffect(PHS_AOE_PER_PRISMATIC_SPHERE);

    // Set local integer so that the first ones will not be affected, which
    // is removed after 0.2 seconds.
    string sLocal = PHS_MOVING_BARRIER_START + IntToString(PHS_SPELL_PRISMATIC_SPHERE);
    SetLocalInt(oCaster, sLocal, TRUE);
    DelayCommand(0.2, DeleteLocalInt(oCaster, sLocal));

    // Apply effects
    PHS_ApplyLocationDuration(lTarget, eAOE, fDuration);
}
