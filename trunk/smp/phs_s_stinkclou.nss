/*:://////////////////////////////////////////////
//:: Spell Name Stinking Cloud
//:: Spell FileName PHS_S_StinkClou
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Conjuration (Creation)
    Level: Sor/Wiz 3
    Components: V, S, M
    Casting Time: 1 standard action
    Range: Medium (20M)
    Effect: Cloud spreads in 6.67M (20-ft.) radius
    Duration: 1 round/level
    Saving Throw: Fortitude negates; see text
    Spell Resistance: No

    Stinking cloud creates a bank of fog like that created by fog cloud, except
    that the vapors are nauseating. Living creatures in the cloud become dazed.
    This condition lasts as long as the creature is in the cloud and for 1d4+1
    rounds after it leaves. (Roll separately for each nauseated character.) Any
    creature that succeeds on its save but remains in the cloud must continue
    to save each round on your turn.

    Material Component: A rotten egg or several skunk cabbage leaves.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Can use the default sized AOE. It dazes until they leave the AOE - fair enough.

    This is one spell Bioware got mainly correct - except no SR checks now :-)
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_STINKING_CLOUD)) return;

    // Declare major variables
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    // Duration - 1 round/level
    float fDuration = PHS_GetDuration(PHS_ROUNDS, nCasterLevel, nMetaMagic);

    // Declare effects
    effect eAOE = EffectAreaOfEffect(PHS_AOE_PER_STINKING_CLOUD);
    effect eImpact = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_NATURE);

    // Apply effects
    PHS_ApplyLocationDurationAndVFX(lTarget, eImpact, eAOE, fDuration);
}
