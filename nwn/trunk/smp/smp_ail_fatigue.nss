/*:://////////////////////////////////////////////
//:: Spell Name Special Ailment: Fatigue
//:: Spell FileName SMP_Ail_Fatigue
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Is called from SMP_ApplyFatigue creates a placeable to
    cast this spell, may be permament, tempoary or whatever.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Special:
    - It is not a spell. Use SMP_RemoveFatigue() to apply it.
    - Exhasution will override Fatigue.

    Fatigued: A fatigued character can neither run nor charge and takes a –2
    penalty to Strength and Dexterity. Doing anything that would normally
    cause fatigue causes the fatigued character to become exhausted. After 8
    hours of complete rest, fatigued characters are no longer fatigued.

    We apply a small speed decrease, and -2 strength and dex.

    Exhausted: An exhausted character moves at half speed and takes a –6 penalty
    to Strength and Dexterity. After 1 hour of complete rest, an exhausted
    character becomes fatigued. A fatigued character becomes exhausted by doing
    something else that would normally cause fatigue.

    Extra 20% speed penatly, and non-overlapping -6 to strength and dex.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_AILMENT"

// Is oTarget fatigued or Exhausted?
int GetIsFatiguedOrExhausted(object oTarget);
// Is oTarget Exhausted?
int GetIsExhausted(object oTarget);

void main()
{
    // Get "Self" and target
    object oSelf = OBJECT_SELF;
    object oTarget = GetLocalObject(oSelf, "FATIGUE_TARGET");

    // Get duration in seconds
    float fDuration = IntToFloat(GetLocalInt(oSelf, "FATIGUE_DURATION"));
    // Get duration type
    int nDuration = GetLocalInt(oSelf, "FATIGUE_DURATION_TYPE");

    // Is it Exhaustion?
    int bExhaustion = GetLocalInt(oSelf, "FATIGUE_EXHAUSTION");


    // If only fatigue:
    if(bExhaustion == FALSE)
    {
        // Can't be affected already if it isn't permament
        if(GetIsFatiguedOrExhausted(oTarget))
        {
            // Cannot be again fatigued.
            return;
        }
    }
    // Cannot be affected by exhaustion twice either
    else //if(bExhaustion == TRUE)
    {
        if(GetIsExhausted(oTarget))
        {
            return;
        }
    }

    // All effects
    effect eFatStr = EffectAbilityDecrease(ABILITY_STRENGTH, 2);
    effect eFatDex = EffectAbilityDecrease(ABILITY_DEXTERITY, 2);
    effect eFatSlow = EffectMovementSpeedDecrease(20);
    // Link effects
    effect eFatLink = EffectLinkEffects(eFatStr, eFatDex);
    eFatLink = EffectLinkEffects(eFatLink, eFatSlow);
    eFatLink = ExtraordinaryEffect(eFatLink);

    effect eExhStr = EffectAbilityDecrease(ABILITY_STRENGTH, 6);
    effect eExhDex = EffectAbilityDecrease(ABILITY_DEXTERITY, 6);
    effect eExhSlow = EffectMovementSpeedDecrease(20);
    // This extra VFX defines it as exhaustion
    effect eExhDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    // Link effects
    effect eExhLink = EffectLinkEffects(eExhStr, eExhDex);
    eExhLink = EffectLinkEffects(eExhLink, eExhSlow);
    eExhLink = EffectLinkEffects(eExhLink, eExhDur);
    eExhLink = ExtraordinaryEffect(eExhLink);

    // Apply the Fatigue always
    ApplyEffectToObject(nDuration, eFatLink, oTarget, fDuration);

    // Apply exhaustion if it was chosen
    if(bExhaustion == TRUE)
    {
        ApplyEffectToObject(nDuration, eExhLink, oTarget, fDuration);
    }
}

// Is oTarget fatigued or Exhausted?
int GetIsFatiguedOrExhausted(object oTarget)
{
    object oFatigue = OBJECT_SELF;
    effect eCheck = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eCheck))
    {
        // Check creator of the effect is fatigue
        if(GetEffectCreator(eCheck) == oFatigue)
        {
            return TRUE;
        }
        eCheck = GetNextEffect(oTarget);
    }
    return FALSE;
}

// Is oTarget Exhausted?
int GetIsExhausted(object oTarget)
{
    // Need to have a VFX from this object
    object oFatigue = OBJECT_SELF;
    effect eCheck = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eCheck))
    {
        // Check creator of the effect is fatigue
        if(GetEffectCreator(eCheck) == oFatigue)
        {
            if(GetEffectType(eCheck) == EFFECT_TYPE_VISUALEFFECT)
            {
                return TRUE;
            }
        }
        eCheck = GetNextEffect(oTarget);
    }
    return FALSE;
}
