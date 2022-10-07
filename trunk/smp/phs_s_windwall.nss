/*:://////////////////////////////////////////////
//:: Spell Name Wind Wall
//:: Spell FileName PHS_S_WindWall
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Evocation [Air]
    Level: Air 2, Clr 3, Drd 3, Rgr 2, Sor/Wiz 3
    Components: V, S, M/DF
    Casting Time: 1 standard action
    Range: Medium (20M)
    Effect: A 5M-radius sphere, wall of wind
    Duration: 1 round/level
    Saving Throw: None; see text
    Spell Resistance: No

    An invisible vertical curtain of wind appears. It is a roaring blast
    sufficient to tear papers and similar materials from unsuspecting hands, and
    deflect projectiles from thier target. The wind cannot be stopped by
    spell resistance.

    Firstly, any spells cast from scrolls within the sphere will require a
    reflex save to maintain its grasp on an object, or the paper is torn out of
    the casters hands and lost or torn in the wind. Secondly, small flying
    creatures cannot pass into the barrier, and if they are in the area when it
    is cast, they are pushed to the edge. Thirdly, any projectiles fired within
    or into the area have a 80% miss chance, due to the strong wind (A
    giant-thrown boulder, a siege engine projectile, and other massive ranged
    weapons are not affected.).

    Arcane Material Component: A tiny fan and a feather of exotic origin.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Changed from the original specs. It kinda creates an area of wind now...oh well,
    it is insanely easier!

    - Stops small flying animals (on a appearance check) from entering
    - Spell hook detects the spell and does a reflex save if a spell scroll is
      being used, or lose the scroll.
    - 80% miss chance for ranged weapons (IE: 80% consealment), better then
      the original 100% I think, and it applies to anyone in the sphere.

    Note: Anything affected by wind also is affected by this. I think flying
    can still be possible, but Gaseous Form are repelled as are flying animals.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_WIND_WALL)) return;

    // Declare major variables
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    // Duration in rounds
    float fDuration = PHS_GetDuration(PHS_ROUNDS, nCasterLevel, nMetaMagic);

    // Declare effects
    effect eAOE = EffectAreaOfEffect(PHS_AOE_PER_WIND_WALL);
    effect eImpact = EffectVisualEffect(VFX_IMP_WIND);

    // Apply effects
    PHS_ApplyLocationDurationAndVFX(lTarget, eImpact, eAOE, fDuration);
}
