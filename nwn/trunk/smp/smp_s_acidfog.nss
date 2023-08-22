/*:://////////////////////////////////////////////
//:: Spell Name Acid fog
//:: Spell FileName SMP_S_AcidFog
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Conjuration (Creation) [Acid]
    Level: Sor/Wiz 6, Water 7
    Components: V, S, M/DF
    Casting Time: 1 standard action
    Range: Medium (20M)
    Effect: Fog spreads in a 5M (20-ft.) radius
    Duration: 1 round/level
    Saving Throw: None

    Acid fog creates a billowing mass of misty vapors. The fog obscures sight,
    and therefore provides consealment of 20% against melee attacks, and 50%
    against ranged attacks, and anyone inside the fog has a -2 penalty to
    all melee attack rolls. The vapors prevent effective ranged weapon attacks
    (except for magic rays and the like).

    In addition to slowing creatures down by 80% of thier normal movement rate,
    and obscuring sight, this spell’s vapors are highly acidic. Each round on
    your turn, starting when you cast the spell, the fog deals 2d6 points of
    acid damage to each creature and object within it.

    Arcane Material Component: A pinch of dried, powdered peas combined with
    powdered animal hoof.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    We have changed the in-game description to be independant of "Solid fog"
    and "Fog Cloud" descriptions.

    It is nearly the best of its abilities:

    We do apply the movement decrease, but changes to some stats as well.
    Everyone gets a 80% movement decrease, -2 to melee attack + damage rolls.
    20% melee, and 100% ranged consealment (+100% ranged miss chance).
    It also only does 2d6 damage each heartbeat. Can be destroyed by gust of wind.
    No save, no spell resistance.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!SMP_SpellHookCheck()) return;

    // Declare major variables
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = SMP_GetCasterLevel();
    int nMetaMagic = SMP_GetMetaMagicFeat();
    // Duration - 1 round/level
    float fDuration = SMP_GetDuration(SMP_ROUNDS, nCasterLevel, nMetaMagic);

    // Declare effects
    effect eAOE = EffectAreaOfEffect(SMP_AOE_PER_ACID_FOG);
    // Impact VFX  (Same as 257)
    effect eImpact = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_ACID);

    // Apply effects
    SMP_ApplyLocationDurationAndVFX(lTarget, eImpact, eAOE, fDuration);
}
