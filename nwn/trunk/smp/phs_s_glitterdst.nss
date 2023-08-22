/*:://////////////////////////////////////////////
//:: Spell Name Glitterdust
//:: Spell FileName PHS_S_Glitterdst
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    20M range, 3.3M radius, blindness (will negates) removes invisiblity from
    enemies, and -40 on hide checks.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    -40  to hide checks, for those inside the AOE when it hits.

    Use a specific AOE visual, which lasts for 6.0 seconds.

    Needs a single-target duration visual really, too.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Check item useage.
    if(!PHS_SpellHookCheck(PHS_SPELL_GLITTERDUST)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    float fDelay;

    // Get duration in rounds.
    float fDuration = PHS_GetDuration(PHS_ROUNDS, nCasterLevel, nMetaMagic);

    // Declare Effects
    //effect eVis = EffectVisualEffect(VFX_IMP_BREACH); // Glisteny!
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    // Penalty of -40 hide whatever
    effect ePenalty = EffectSkillDecrease(SKILL_HIDE, 40);
    effect ePenaltyLink = EffectLinkEffects(eCessate, ePenalty);
    // Save VS blindness
    effect eBlindDur = EffectVisualEffect(VFX_DUR_BLIND);
    effect eBlind = EffectBlindness();
    effect eBlindLink = EffectLinkEffects(eBlindDur, eBlind);
    eBlindLink = EffectLinkEffects(eCessate, eBlindLink);

    // Apply AOE location explosion
    effect eAOE = EffectVisualEffect(PHS_VFX_FNF_GLITTERDUST);
    PHS_ApplyLocationDuration(lTarget, eAOE, 6.0);

    // Get all targets in a sphere, medium (3.3) radius, objects
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, TRUE);
    // Loop targets
    while(GetIsObjectValid(oTarget))
    {
        // PvP Check
        if(!GetIsReactionTypeFriendly(oTarget, oCaster))
        {
            // Fire cast spell at event for the specified target
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_GLITTERDUST);

            // Get the distance between the explosion and the target to calculate delay
            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;

            // No current needed impact effect.

            // Remove invisibility effects
            PHS_RemoveSpecificEffect(EFFECT_TYPE_IMPROVEDINVISIBILITY, oTarget);
            PHS_RemoveSpecificEffect(EFFECT_TYPE_INVISIBILITY, oTarget);

            // Apply penalty to saves
            DelayCommand(fDelay, PHS_ApplyDuration(oTarget, ePenaltyLink, fDuration));

            // Apply blindness on a failed will save
            if(!PHS_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_NONE, OBJECT_SELF, fDelay))
            {
                // Apply penalty to saves
                DelayCommand(fDelay, PHS_ApplyDuration(oTarget, eBlindLink, fDuration));
            }
        }
        // Get Next Target
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, TRUE);
    }
}
