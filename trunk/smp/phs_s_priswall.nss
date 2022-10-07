/*:://////////////////////////////////////////////
//:: Spell Name Prismatic Wall
//:: Spell FileName PHS_S_PrisWall
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Abjuration
    Level: Sor/Wiz 8
    Components: V, S
    Casting Time: 1 standard action
    Range: Close (8M)
    Effect: Wall 10M long, 1M wide
    Duration: 10 min./level (D)
    Saving Throw: See text
    Spell Resistance: See text

    Prismatic wall creates a vertical, opaque wall-a shimmering, multicolored
    plane of light. The wall flashes with seven colors, each of which has a
    distinct power and purpose. The wall is immobile, and you can pass through
    and remain near the wall without harm. However, any other creature with less
    than 8 HD that is within 10M (30ft) of the centre of the wall is blinded for
    2d4 rounds by the colors if it looks at the wall.

    The wall’s proportions are about 10 meters long, 1 meters wide. A prismatic
    wall spell cast to materialize in a space occupied by a creature is
    disrupted, and the spell is wasted. Note that unlike prismatic sphere there
    is no effect on spells or ranged weapons in or around the wall.

    Each color in the wall has a special effect. The accompanying table shows
    the seven colors of the wall, the order in which they appear, their effects
    on creatures trying to pass through the wall.

    For a creature attempting to pass through the wall, they suffer the effects
    of each color in order. Spell resistance is effective against a prismatic
    wall, but the caster level check must be repeated for each color present.
    Dispel magic and similar spells affect a prismatic wall as normal.

    Color   Order   Effect of Color
    Red     1st Deals 20 points of fire damage (Reflex half).
    Orange  2nd Deals 40 points of acid damage (Reflex half).
    Yellow  3rd Deals 80 points of electricity damage (Reflex half).
    Green   4th Poison (Kills; Fortitude partial for 1d6 points of Con damage instead).
    Blue    5th Turned to stone (Fortitude negates).
    Indigo  6th Will save or become insane (as insanity spell).
    Violet  7th Creatures sent to another plane (Will negates)
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As it stated above.

    Simplified a lot. It now doesn't stop spells or missiles (ugly!) but will
    do th effects of each thing On Enter - ugly!

    This is still powerful (very much so) for the level.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_PRISMATIC_WALL)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    location lTarget = GetSpellTargetLocation();// Should be OBJECT_SELF's location
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    // Duration - 10 minutes/level
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel * 10, nMetaMagic);

    // Declare effects
    effect eAOE = EffectAreaOfEffect(PHS_AOE_PER_PRISMATIC_WALL);

    // Set local integer so that the first ones will not be affected, which
    // is removed after 0.1 seconds.
    string sLocal = PHS_MOVING_BARRIER_START + IntToString(PHS_SPELL_PRISMATIC_WALL);
    SetLocalInt(oCaster, sLocal, TRUE);
    DelayCommand(0.1, DeleteLocalInt(oCaster, sLocal));

    // Apply effects
    PHS_ApplyLocationDuration(lTarget, eAOE, fDuration);
}
