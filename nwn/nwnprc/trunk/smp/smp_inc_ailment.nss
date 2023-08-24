/*:://////////////////////////////////////////////
//:: Name Ailment Include script.
//:: FileName SMP_INC_AILMENT
//:://////////////////////////////////////////////
    Used for the ailment scripts (SMP_ail_XXX) and anything special in them.

    This won't have much, and is seperate from SMP_INC_SPELLS.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//:: Created On: 23 may
//::////////////////////////////////////////////*/

#include "SMP_INC_REMOVE"

// SMP_INC_AILMENT. Check if oTarget has the effects of SMP_SPELL_CALM_EMOTIONS, and from it
// the dazed effect. If so, it will check if they have been attacked ETC.
// - TRUE if they have got it, and it should surpress Fear and Confusion
// - FALSE if it gets removed, or doesn't exsist.
int SMP_AilmentCheckCalmEmotions(object oTarget = OBJECT_SELF);

// SMP_INC_AILMENT. Check if oTarget has the effects of SMP_SPELL_CALM_EMOTIONS, and from it
// the dazed effect. If so, it will check if they have been attacked ETC.
// - TRUE if they have got it, and it should surpress Fear and Confusion
// - FALSE if it gets removed, or doesn't exsist.
int SMP_AilmentCheckCalmEmotions(object oTarget = OBJECT_SELF)
{
    // Return value
    int bReturn = FALSE;

    // They need the spell, obviously
    if(GetHasSpellEffect(SMP_SPELL_CALM_EMOTIONS, oTarget))
    {
        // Search through the valid effects on the target.
        effect eCheck = GetFirstEffect(oTarget);
        while(GetIsEffectValid(eCheck) && bReturn == FALSE)
        {
            // Dazed effects
            if(GetEffectType(eCheck) == EFFECT_TYPE_DAZED)
            {
                if(GetEffectSpellId(eCheck) == SMP_SPELL_CALM_EMOTIONS)
                {
                    // Got it!
                    bReturn = TRUE;
                }
            }
            //Get next effect on the target
            eCheck = GetNextEffect(oTarget);
        }
        // Have we got it so far?
        if(bReturn == TRUE)
        {
            // Check if we are going to be attacked
            // - VERY BASIC CHECK
            if(GetIsObjectValid(GetGoingToBeAttackedBy(oTarget)))
            {
                // Remove the spells effects
                SMP_RemoveSpellEffectsFromTarget(SMP_SPELL_CALM_EMOTIONS, oTarget);
                bReturn = FALSE;
            }
            // Else, keep as TRUE
        }
    }
    // Return the value
    return bReturn;
}

// End of file Debug lines. Uncomment below "/*" with "//" and compile.
/*
void main()
{
    return;
}
//*/
