/*:://////////////////////////////////////////////
//:: Monster Ability Name Allip Babble - On Enter
//:: Monster Ability FileName SMP_A_BabbleA
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Babble (Su): An allip constantly mutters and whines to itself, creating a
    hypnotic effect. All sane creatures within 20 meters of the allip must succeed
    on a DC 16 Will save or be affected as though by a hypnotism spell for 2d4
    rounds. This is a sonic mind-affecting compulsion effect.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Hypnotism for those in the area (heartbeat and enter script).

    Note: Anyone who saves against its effects are rendered immune to them
    for the duration.

    DC is 10 + Half undead levels + Charisma Bonus (18 Charisma, 4 levels default
    means DC 10 + 2 + 4 = 16)
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_ABILITY"

void main()
{
    // Get entering object
    object oTarget = GetEnteringObject();
    object oCreator = GetAreaOfEffectCreator();
    // Get save DC
    int nSaveDC = SMP_GetAbilitySaveDC(CLASS_TYPE_UNDEAD, ABILITY_CHARISMA);

    // Declare Effects
    effect eVis = EffectVisualEffect(VFX_IMP_CONFUSION_S);
    effect eConfuse = EffectConfused();
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eConfuse, eCessate);

    // Duration - 2d4 rounds
    float fDuration = RoundsToSeconds(d4(2));

    // Check if they are immune
    if(!SMP_GetIsImmuneToAbility(oTarget, SMP_SPELLABILITY_BABBLE, oCreator))
    {
        // Check if immune to mind spells, confusion, and they can hear.
        if(!SMP_ImmunityCheck(oTarget, IMMUNITY_TYPE_MIND_SPELLS) &&
           !SMP_ImmunityCheck(oTarget, IMMUNITY_TYPE_CONFUSED) &&
            SMP_GetCanHear(oTarget))
        {
            // Signal Spell Cast At event
            SignalEvent(oTarget, EventSpellCastAt(oCreator, SMP_SPELLABILITY_BABBLE, TRUE));

            // Will save
            if(!SMP_SavingThrow(SAVING_THROW_WILL, oTarget, nSaveDC, SAVING_THROW_TYPE_MIND_SPELLS, oCreator))
            {
                // Apply effects
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
            }
            else
            {
                // Set to be immune
                SMP_SetIsImmuneToAbility(oTarget, SMP_SPELLABILITY_BABBLE, oCreator);
            }
        }
    }
}
