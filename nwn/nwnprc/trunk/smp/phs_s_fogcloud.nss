/*:://////////////////////////////////////////////
//:: Spell Name Fog Cloud
//:: Spell FileName PHS_S_FogCloud
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Conjuration (Creation)
    Level: Drd 2, Sor/Wiz 2, Water 2
    Components: V, S
    Casting Time: 1 standard action
    Range: Medium (20M)
    Effect: Fog spreads in 6.67-M. radius
    Duration: 10 min./level
    Saving Throw: None
    Spell Resistance: No

    A bank of fog billows out from the point you designate. The fog obscures all
    sight, including darkvision, giving the effect of partial consealment to
    melee attacks (20% miss chance). Creatures farther away for ranged attacks
    have total concealment (50% miss chance). This is not a magical effect and
    is unaffected by mantals, globes and the like.

    A moderate wind (11+ mph), disperses the fog in 4 rounds; a strong wind
    (21+ mph) disperses the fog in 1 round.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Easy peasy. Applies the spell.

    Advantages over Obscuring Mist:
    - 20M range.
    - Cannot be burnt by a fire spell
    - 10 min/level, not 1 min/level.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_FOG_CLOUD)) return;

    // Declare major variables
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    // Duration 10 minutes/level
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel * 10, nMetaMagic);

    // Declare effects
    effect eAOE = EffectAreaOfEffect(PHS_AOE_PER_FOG_CLOUD);
    // Impact VFX
    effect eImpact = EffectVisualEffect(PHS_VFX_FNF_GAS_EXPLOSION_MIST);

    // Apply effects
    PHS_ApplyLocationDurationAndVFX(lTarget, eImpact, eAOE, fDuration);
}
