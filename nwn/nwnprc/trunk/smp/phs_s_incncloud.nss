/*:://////////////////////////////////////////////
//:: Spell Name Incendiary Cloud
//:: Spell FileName PHS_S_IncnCloud
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Conjuration (Creation) [Fire]
    Level: Fire 8, Sor/Wiz 8
    Components: V, S
    Casting Time: 1 standard action
    Range: Medium (20M)
    Effect: Cloud spreads in 6.67-M. radius
    Duration: 1 round/level
    Saving Throw: Reflex half; see text
    Spell Resistance: No

    An incendiary cloud spell creates a cloud of roiling smoke shot through with
    white-hot embers. The smoke obscures all sight as a fog cloud does (20% melee
    consealment, 50% ranged consealment). In addition, the white-hot embers
    within the cloud deal 4d6 points of fire damage to everything within the
    cloud on your turn each round. All targets can make Reflex saves each round
    to take half damage.

    As with fog cloud, wind disperses the smoke, a moderate wind (11+ mph)
    disperses the fog in 4 rounds; a strong wind (21+ mph) disperses the fog in
    1 round.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As the spell says. No moving fog though!

    Damage is done On Heartbeat, consealment effects (Which do not stack anyway)
    are On Enter, On Exit.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_INCENDIARY_CLOUD)) return;

    // Declare major variables
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Duration in rounds
    float fDuration = PHS_GetDuration(PHS_ROUNDS, nCasterLevel, nMetaMagic);

    // Declare effects
    effect eAOE = EffectAreaOfEffect(PHS_AOE_PER_INCENDIARY_CLOUD);
    effect eImpact = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_FIRE);

    // Apply effects
    PHS_ApplyLocationDurationAndVFX(lTarget, eImpact, eAOE, fDuration);
}
