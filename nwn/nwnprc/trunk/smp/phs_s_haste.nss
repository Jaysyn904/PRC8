/*:://////////////////////////////////////////////
//:: Spell Name Haste
//:: Spell FileName PHS_S_Haste
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    1 creature/level in 5M area. 8M range. 1 extra attack, +1 attack rolls,
    +1 dodge AC, +1 reflex saves, +50% movement increase.
    Counters/dispells slow.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Haste

    - 5M (15Ft, large) all allies affected
    - Removes any slow OR
    - Applies haste.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_HASTE)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    float fDelay;

    // 1 creature a level
    int nTagetsDone;

    // Duration - rounds
    float fDuration = PHS_GetDuration(PHS_ROUNDS, nCasterLevel, nMetaMagic);

    // Declare effects
    effect eHaste = PHS_CreateHasteEffect();
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eVis = EffectVisualEffect(VFX_IMP_HASTE);
    effect eRemoveVis = EffectVisualEffect(VFX_IMP_DISPEL);

    // Link
    effect eLink = EffectLinkEffects(eHaste, eCessate);

    // Just loops those in the AOE (large, 5M)
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE);
    while(GetIsObjectValid(oTarget) && nTagetsDone < nCasterLevel)
    {
        // Check faction/friendly or not
        if(GetIsFriend(oTarget) || GetFactionEqual(oTarget))
        {
            // Add one to targets done.
            nTagetsDone++;
            // Get delay
            fDelay = GetDistanceBetweenLocations(GetLocation(oTarget), lTarget)/20;
            // Check for haste
            if(PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_SLOW, oTarget, fDelay))
            {
                // Removed
                DelayCommand(fDelay, PHS_ApplyVFX(oTarget, eRemoveVis));
            }
            else
            {
                // Apply haste, no slow
                // - Remove all magical speed increases
                PHS_RemoveSpecificEffect(EFFECT_TYPE_MOVEMENT_SPEED_INCREASE, oTarget);
                // Remove previous spell castings
                PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_HASTE, oTarget);
                // Apply haste
                DelayCommand(fDelay, PHS_ApplyVFX(oTarget, eVis));
                PHS_ApplyDuration(oTarget, eLink, fDuration);
            }
        }
        // Get next target
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE);
    }
}
