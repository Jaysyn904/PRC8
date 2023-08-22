/*:://////////////////////////////////////////////
//:: Spell Name Calm Emotions
//:: Spell FileName SMP_S_CalmEmot
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Calm Emotions
    Enchantment (Compulsion) [Mind-Affecting]
    Level: Brd 2, Clr 2, Law 2
    Components: V, S, DF
    Casting Time: 1 standard action
    Range: Medium (20M)
    Area: All Creatures in a 6.67-M.-radius spread
    Duration: Concentration, up to 1 round/level (D)
    Saving Throw: Will negates
    Spell Resistance: Yes

    This spell calms agitated creatures. You have no control over the affected
    creatures, but calm emotions can stop raging creatures from fighting or
    joyous ones from reveling. Creatures so affected cannot take violent actions
    or do anything destructive, and act as if dazed by sudden calmness. Any
    aggressive action against or damage dealt to a calmed creature immediately
    breaks the spell on all calmed creatures.

    This spell automatically suppresses any fear or confusion condition on all
    targets. While the spell lasts, a suppressed spell or effect has no effect.
    When the calm emotions spell ends, the original spell or effect takes hold
    of the creature again, provided that its duration has not expired in the
    meantime.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    NOTE: Concentration not tested!

    Uses a Dazed effect.

    Confusion is NOT removed, nor is Fear.

    This uses new calm functions to make sure the targets are not attacked (and
    if are, the spell effects are removed).
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_CONCENTR"
#include "SMP_INC_CALM"

void main()
{
    // If we are concentrating, and cast at the same spot, we set the integer
    // for the hypnotic pattern up by one.
    object oCaster = OBJECT_SELF;
    location lTarget = GetSpellTargetLocation();

    // Check the function
    if(SMP_ConcentatingContinueCheck(SMP_SPELL_CALM_EMOTIONS, lTarget, SMP_AOE_TAG_PER_CALM_EMOTIONS, 18.0, oCaster)) return;

    // Else, new spell!

    // Spell Hook Check.
    if(!SMP_SpellHookCheck()) return;

    // Declare major variables
    object oTarget;
    int nCasterLevel = SMP_GetCasterLevel();
    int nSpellSaveDC = SMP_GetSpellSaveDC();
    int nMetaMagic = SMP_GetMetaMagicFeat();
    float fDelay, fDistance;

    // We set the "Concentration" thing to 18 seconds
    // This also returns the array we set people affected to, and does the new
    // action.
    string sArrayLocal = SMP_ConcentatingStart(SMP_SPELL_CALM_EMOTIONS, nCasterLevel, lTarget, SMP_AOE_PER_CALM_EMOTIONS);
    int nArrayCount;

    // Note on duration: We apply it permamently, however, it will definatly
    // be removed by the AOE.

    // Declare Effects
    effect eVis = EffectVisualEffect(VFX_IMP_DAZED_S);
    effect eDaze = EffectDazed();
    effect eDazeDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // Link effects
    effect eLink = EffectLinkEffects(eDaze, eDazeDur);
    eLink = EffectLinkEffects(eLink, eCessate);

    // Get the first target in the spell area
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 6.67, lTarget, TRUE);
    while(GetIsObjectValid(oTarget))
    {
        // Make faction check to ignore allies
        if(!GetIsReactionTypeFriendly(oTarget) &&
        // Make sure they are not immune to spells
           !SMP_TotalSpellImmunity(oTarget))
        {
            // Fire cast spell at event for the specified target
            SMP_SignalSpellCastAt(oTarget, SMP_SPELL_CALM_EMOTIONS);

            // Make SR check
            if(!SMP_SpellResistanceCheck(oCaster, oTarget, fDelay) &&
               !SMP_ImmunityCheck(oTarget, IMMUNITY_TYPE_DAZED, fDelay) &&
               !SMP_ImmunityCheck(oTarget, IMMUNITY_TYPE_MIND_SPELLS, fDelay))
            {
                // Will saving throw
                if(!SMP_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_MIND_SPELLS, oCaster, fDelay))
                {
                    // Add to the array
                    nArrayCount++;
                    SetLocalObject(oCaster, sArrayLocal + IntToString(nArrayCount), oTarget);

                    // Apply effects
                    SMP_SetCalm(oTarget);
                    SMP_ApplyPermanentAndVFX(oTarget, eVis, eLink);
                }
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, 6.67, lTarget, TRUE);
    }
    // Set the max people in the array
    SetLocalInt(oCaster, sArrayLocal, nArrayCount);
}
