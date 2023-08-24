/*:://////////////////////////////////////////////
//:: Spell Name Sleet Storm
//:: Spell FileName PHS_S_SleetStor
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Conjuration (Creation) [Cold]
    Level: Drd 3, Sor/Wiz 3
    Components: V, S, M/DF
    Casting Time: 1 standard action
    Range: Long (40M)
    Area: Cylinder 13.33M radius (40-ft.)
    Duration: 1 round/level
    Saving Throw: Reflex negates; see text
    Spell Resistance: No

    Driving sleet blocks all sight (even darkvision) within it, causing
    blindness to those in the area, and causes the ground in the area to be icy.
    A creature must make a DC 10 reflex save or fall over each round. Even if they
    pass, they can only walk within the sleet at half normal speed.

    Arcane Material Component: A pinch of dust and a few drops of water.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    I'll use Darkness style Invisibility + Darkness effect.

    No EffectUltravision() will be used in spells.

    The save is static, it was a DC10 Balance check, a DC10 reflex save is
    plenty large - still has a 1 in 20 chance of falling.

    13.33M is large! huge even! and it needs to be a good effect, it must
    really snow hard!
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_SLEET_STORM)) return;

    // Declare major variables
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Duration - 1 round/level
    float fDuration = PHS_GetDuration(PHS_ROUNDS, nCasterLevel, nMetaMagic);

    // Declare effects
    effect eAOE = EffectAreaOfEffect(PHS_AOE_PER_SLEET_STORM);

    // Apply effects
    PHS_ApplyLocationDuration(lTarget, eAOE, fDuration);
}
