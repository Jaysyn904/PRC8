/*:://////////////////////////////////////////////
//:: Spell Name Mind Fog
//:: Spell FileName PHS_S_MindFog
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Enchantment (Compulsion) [Mind-Affecting]
    Level: Brd 5, Sor/Wiz 5
    Components: V, S
    Casting Time: 1 standard action
    Range: Medium (20M)
    Effect: Fog spreads in 6.67-M. radius
    Duration: 30 minutes and 2d6 rounds; see text
    Saving Throw: Will negates
    Spell Resistance: Yes

    Mind fog produces a bank of thin mist that weakens the mental resistance of
    those caught in it. Creatures in the mind fog take a -10 competence penalty
    on Will saves. (A creature that successfully saves against the fog is not
    affected and need not make further saves even if it remains in the fog.)
    Affected creatures take the penalty as long as they remain in the fog and
    for 2d6 rounds thereafter. The fog is stationary and lasts for 30 minutes
    (or until dispersed by wind).

    A moderate wind (11+ mph) disperses the fog in four rounds; a strong wind
    (21+ mph) disperses the fog in 1 round.

    The fog is thin and does not significantly hamper vision.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Mind fog, similar to Biowares.

    Ok, On Enter, we save against the spell and if fail, will take -10 on
    will saves.

    On Exit, if they still have the spells effects, will have the permament
    effects removed and have tempoary ones added.

    If, On Enter, they have tempoary (not permament) effects only, of this spell,
    they will make a new save and if failed, put permament effects on and remove
    the tempoary ones.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_MIND_FOG)) return;

    // Declare major variables
    location lTarget = GetSpellTargetLocation();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Duration is 30 minutes
    float fDuration = PHS_GetDuration(PHS_MINUTES, 30, nMetaMagic);

    // Declare effects
    effect eAOE = EffectAreaOfEffect(PHS_AOE_PER_MIND_FOG);
    // Impact VFX
    effect eImpact = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_MIND);

    // Apply effects
    PHS_ApplyLocationDurationAndVFX(lTarget, eImpact, eAOE, fDuration);
}
