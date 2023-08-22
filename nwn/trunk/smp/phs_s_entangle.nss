/*:://////////////////////////////////////////////
//:: Spell Name Entangle
//:: Spell FileName PHS_S_Entangle
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation
    Level: Drd 1, Plant 1, Rgr 1
    Components: V, S, DF
    Casting Time: 1 standard action
    Range: Long (40M)
    Area: Plants in a 13.33-M.-radius spread
    Duration: 1 min./level (D)
    Saving Throw: Reflex partial, Strength check; see text
    Spell Resistance: No

    Grasses, weeds, bushes, and even trees wrap, twist, and entwine about
    creatures in the area or those that enter the area, holding them fast and
    causing them to become entangled. If the area contains no plants, they may
    spring up from the ground and entangle creatures anyway. The creature can
    break free and move half its normal speed by making a DC 20 Strength check.
    A creature that succeeds on a Reflex save is not entangled but can still
    move at only half speed through the area. Each round on your turn, the
    plants once again attempt to entangle all creatures that have avoided or
    escaped entanglement.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    No SR, noting that.

    On Heartbeat will do reflex saves to apply EffectEntangle, for a permament
    duration.
    On Heartbeat will do a STR check if they are already entangled, to remove it.

    On Enter applies slow effect. On Exit should remove all effects.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_ENTANGLE)) return;

    // Declare major variables
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    // Duration in minutes
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel, nMetaMagic);

    // Declare effects
    effect eAOE = EffectAreaOfEffect(PHS_AOE_PER_ENTANGLE);

    // Apply effects
    PHS_ApplyLocationDuration(lTarget, eAOE, fDuration);
}
