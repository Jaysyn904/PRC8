/*:://////////////////////////////////////////////
//:: Spell Name Slow
//:: Spell FileName PHS_S_Slow
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Range: Close (8M)
    Targets: One enemy creature/level in a 5M.-radius sphere
    Duration: 1 round/level
    Saving Throw: Will negates
    Spell Resistance: Yes

    An affected creature moves and attacks at a drastically slowed rate. A slowed
    creature takes a -1 penalty on attack rolls, AC, and Reflex saves. A slowed
    creature moves at half its normal speed.

    Multiple slow effects don’t stack. Slow counters and dispels haste.

    Material Component: A drop of molasses.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Haste

    - 5M (15Ft, large) all allies affected
    - Removes any haste OR
    - Applies slow.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_SLOW)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    float fDelay;

    // 1 creature a level
    int nTagetsDone;

    // Duration - rounds
    float fDuration = PHS_GetDuration(PHS_ROUNDS, nCasterLevel, nMetaMagic);

    // Declare effects
    effect eSlow = EffectSlow();
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eVis = EffectVisualEffect(VFX_IMP_SLOW);
    effect eRemoveVis = EffectVisualEffect(VFX_IMP_DISPEL);

    // Link
    effect eLink = EffectLinkEffects(eSlow, eCessate);

    // Just loops those in the AOE (5M)
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 5.0, lTarget, TRUE);
    while(GetIsObjectValid(oTarget) && nTagetsDone < nCasterLevel)
    {
        // Check if an enemy and no PvP
        if(GetIsReactionTypeHostile(oTarget))
        {
            // Add one to targets done.
            nTagetsDone++;

            // Get delay
            fDelay = GetDistanceBetweenLocations(GetLocation(oTarget), lTarget)/20;

            // Check for haste and dispel it
            if(PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_HASTE, oTarget, fDelay))
            {
                // Removed
                DelayCommand(fDelay, PHS_ApplyVFX(oTarget, eRemoveVis));
            }
            else
            {
                // Apply slow
                DelayCommand(fDelay, PHS_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration));
            }
        }
        // Get next target
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, 5.0, lTarget, TRUE);
    }
}
