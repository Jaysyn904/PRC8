/*:://////////////////////////////////////////////
//:: Spell Name Web
//:: Spell FileName PHS_S_Web
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Conjuration (Creation)
    Level: Sor/Wiz 2
    Components: V, S, M
    Casting Time: 1 standard action
    Range: Medium (20M)
    Effect: Webs in a 6.67M-radius (20-ft.) spread
    Duration: 10 min./level (D)
    Saving Throw: Reflex negates; see text
    Spell Resistance: No

    Web creates a many-layered mass of strong, sticky strands, although cannot
    overlap with any exsisting web spells. These strands
    trap those caught in them. The strands are similar to spider webs but far
    larger and tougher. Creatures caught within a web become entangled among the
    gluey fibers. Attacking a creature in a web won’t cause you to become
    entangled.

    Anyone in the effect’s area when the spell is cast must make a Reflex save.

    If this save succeeds, the creature is entangled (-2 to all attacks, -4 to
    AC), but not prevented from moving, though moving is more difficult than
    normal for being entangled, and must be done with an 80% movement speed
    penalty.

    If the save fails, the creature is entangled and can’t move from its space,
    but can break loose by making a DC 20 Strength check. Once loose (either by
    making the initial Reflex save or a later Strength check), a creature
    remains entangled, but may move through the web very slowly, as above.

    Because of the web engulfing targets, you gain partial (20%) cover against
    ranged attacks while entangled within the web.

    The strands of a web spell are flammable. Any area-affecting fire spell cast
    at the web can set the webs alight and burn it away. All creatures within
    flaming webs take 2d4 points of fire damage from the flames, but of course
    can escape.

    Material Component: A bit of spider web.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Web, woo!

    Added a lot more things then the Bioware version. It's effects are done
    mainly On Enter, strength checks On Heartbeat.

    On Exit removes everying, as par normal.

    Fire spells can also burst the web into flames - ouch. Need to add that into
    all fire spells!

    Note: Cannot overlap with exsisting spells, so it's clean. We make sure
    the target location is not withing 6.7M of any web AOE's.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_WEB)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Duration in minutes. 10 minutes/level!
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel * 10, nMetaMagic);

    // We cannot actually cast it if it'll be in an exisiting AOE
    object oOtherAOE = GetNearestObjectByTag(PHS_AOE_TAG_PER_WEB, oCaster, 1);

    // Check distance and validility
    if(GetIsObjectValid(oOtherAOE) &&
       GetDistanceBetweenLocations(GetLocation(oOtherAOE), lTarget) <= 6.67)
    {
        FloatingTextStringOnCreature("*You cannot create another web which overlaps with an exsisting web*", oCaster, FALSE);
        return;
    }

    // Declare effects
    effect eAOE = EffectAreaOfEffect(PHS_AOE_PER_WEB);

    // Apply effects
    PHS_ApplyLocationDuration(lTarget, eAOE, fDuration);
}
