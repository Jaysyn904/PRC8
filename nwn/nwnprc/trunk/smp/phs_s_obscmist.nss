/*:://////////////////////////////////////////////
//:: Spell Name Obscuring Mist
//:: Spell FileName PHS_S_ObscMist
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Range: Personal
    Effect: Cloud spreads in 6.67M.-radius from you
    Duration: 1 min./level
    Saving Throw: None
    Spell Resistance: No

    A misty vapor arises around you. It is stationary once created. The vapor
    obscures all sight, including darkvision, giving the effect of partial
    consealment to melee attacks (20% miss chance). Creatures farther away for
    ranged attacks have total concealment (50% miss chance).

    A moderate wind (11+ mph), such as from a gust of wind spell, disperses the
    fog in 4 rounds. A strong wind (21+ mph) disperses the fog in 1 round. A
    fireball, flame strike, or similar spell burns away the fog in the explosive
    or fiery spell’s area. A wall of fire burns away the fog if the centre of
    the fog overlaps with the fire.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Easy peasy. Applies the spell - should be only able to be cast at self.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_OBSCURING_MIST)) return;

    // Declare major variables
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    // Duration in minutes
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel, nMetaMagic);

    // Declare effects
    effect eAOE = EffectAreaOfEffect(PHS_AOE_PER_OBSCURING_MIST);
    // Impact VFX
    effect eImpact = EffectVisualEffect(PHS_VFX_FNF_GAS_EXPLOSION_MIST);

    // Apply effects
    PHS_ApplyLocationDurationAndVFX(lTarget, eImpact, eAOE, fDuration);
}
