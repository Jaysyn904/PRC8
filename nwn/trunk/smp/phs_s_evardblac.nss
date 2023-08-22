/*:://////////////////////////////////////////////
//:: Spell Name Evard's Black Tentacles
//:: Spell FileName PHS_S_EvardBlac
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Conjuration (Creation)
    Level: Sor/Wiz 4
    Components: V, S, M
    Casting Time: 1 standard action
    Range: Medium (20M)
    Area: 6.67-M.-radius spread
    Duration: 1 round/level (D)
    Saving Throw: None
    Spell Resistance: No

    This spell conjures a field of rubbery black tentacles. These waving members
    seem to spring forth from the earth, floor, or whatever surface is underfoot.
    They grasp and entwine around creatures that enter the area, holding them
    fast and crushing them with great strength.

    Every creature within the area of the spell must make a grapple check,
    opposed by the grapple check of the tentacles. Treat the tentacles attacking
    a particular target as a Large creature with a base attack bonus equal to
    your caster level and a Strength score of 19. Thus, its grapple check
    modifier is equal to your caster level +8. The tentacles cannot be attacked.

    Once the tentacles grapple an opponent, causing them to become entangled,
    they may make a grapple check each round to deal 1d6+4 points of bludgeoning
    damage. The tentacles continue to crush the opponent until the spell ends or
    the opponent escapes by the tentacles failing a later check. Unless the
    target enters the area again, tentacles will not attempt to grapple them again.

    Any creature that enters the area of the spell is immediately attacked by
    the tentacles. Even creatures who aren’t grappling with the tentacles may
    move through the area at only half normal speed.

    Material Component: A piece of tentacle from a giant octopus or a giant squid.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Note: Changed name to Evard's Black Tentacles

    Grapple check uses the functions created for this, and other spells-which-grapple
    things.

    The tentacles will only attack (using a proper attack thing) On Enter.

    If they have the entanglement of tentacles, the HB will continue to grapple.

    Always applies 50% movement speed decrease. Removes all effects On Exit. Will
    not grapple someone with the spells effects already.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_EVARDS_BLACK_TENTACLES)) return;

    // Declare major variables
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    // Duration - 1 round/level
    float fDuration = PHS_GetDuration(PHS_ROUNDS, nCasterLevel, nMetaMagic);

    // Declare effects
    effect eAOE = EffectAreaOfEffect(PHS_AOE_PER_EVARDS_BLACK_TENTACLES);

    // Apply effects
    PHS_ApplyLocationDuration(lTarget, eAOE, fDuration);
}
