/*:://////////////////////////////////////////////
//:: Spell Name Solid Fog
//:: Spell FileName PHS_S_SolidFog
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Conjuration (Creation)
    Level: Sor/Wiz 4
    Components: V, S, M
    Casting Time: 1 standard action
    Range: Medium
    Effect: Fog spreads in 6.67-M. radius
    Duration: 1 min./level
    Spell Resistance: No

    This spell functions like fog cloud, but in addition to obscuring sight
    (providing 20% consealment against melee attacks) the solid fog is so thick
    that any creature attempting to move through it progresses at a 80%
    reduction in speed, and it takes a -2 penalty on all melee attack and melee
    damage rolls. The vapors prevent effective ranged weapon attacks (except for
    magic rays and the like).

    However, unlike normal fog, only a severe wind (31+ mph) disperses these
    vapors, and it does so in 1 round.

    Material Component: A pinch of dried, powdered peas combined with powdered
    animal hoof.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Acid Fog uses this as a template. It applies, on enter (and removes on exit)
    these effects:

    80% slow down in movement.
    20% melee consealment.
    100% ranged consealment.
    100% ranged miss chance
    -2 To Hit (Melee)
    -2 To Damage (Melee)
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_SOLID_FOG)) return;

    // Declare major variables
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Duration - 1 round/level
    float fDuration = PHS_GetDuration(PHS_ROUNDS, nCasterLevel, nMetaMagic);

    // Declare effects
    effect eAOE = EffectAreaOfEffect(PHS_AOE_PER_SOLID_FOG);

    // Apply effects
    PHS_ApplyLocationDuration(lTarget, eAOE, fDuration);
}
