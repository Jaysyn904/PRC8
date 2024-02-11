/*:://////////////////////////////////////////////
//:: Spell Name Plant Growth
//:: Spell FileName PHS_S_PlantGrow
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation
    Level: Drd 3, Plant 3, Rgr 3
    Components: V, S, DF
    Casting Time: 1 standard action
    Range: 10M
    Area: 10M-radius sphere (30ft) centred on the caster
    Duration: Instantaneous
    Saving Throw: None
    Spell Resistance: No

    Plant growth will make plants and bushes in the area, or create some where
    are are none. The plants entwine to form a thicket or jungle that creatures
    must hack or force a way through. Speed drops down by 90% (60% for large or
    larger sized creatures). This spell can only be cast outside overground, in
    the sunlight.

    Only diminish plants can stop/dispel this spell's effects. Dispel magic has
    no effect on it.

    Plant growth counters diminish plants.

    This spell has no effect on plant creatures.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Changed from the original, it does take the overgrowth part seriously.

    It also can only be cast outdoors, overground.

    90% (or 60% for larger+ creatures) movement speed decrease. Anyone with
    the correct feats are not affected. (FEAT_WOODLAND_STRIDE)

    Might make it have a duration, to be fair, it does create plants, where it
    shouldn't really!
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_PLANT_GROWTH)) return;

    // Declare major variables
    location lTarget = GetSpellTargetLocation();// Should be OBJECT_SELF's location

    // Declare effects
    effect eAOE = EffectAreaOfEffect(PHS_AOE_PER_PLANT_GROWTH);
    effect eImpact = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_NATURE);

    // Apply effects
    PHS_ApplyLocationPermanentAndVFX(lTarget, eImpact, eAOE);
}
