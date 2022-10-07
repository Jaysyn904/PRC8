/*:://////////////////////////////////////////////
//:: Spell Name Whatever: On Heartbeat
//:: Spell FileName XXX_S_WhateverC
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    This is simple, and is an AOE which dazes (as the Bioware stinking cloud
    spell, kinda).

    Will negates, and SR applies. Nothing is applied On Enter. Only needs
    an On Heartbeat effect.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Check AOE
    if(!SMP_CheckAOECreator()) return;

    // Declare major variables
    object oTarget;
    object oCaster = GetAreaOfEffectCreator();
    float fDelay;

    // 1 round duration for the daze.
    float fDuration = RoundsToSeconds(1);

    // Declare Effects
    effect eVis = EffectVisualEffect(VFX_IMP_DAZED_S);
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eDaze = EffectDazed();
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    // Link effects
    effect eLink = EffectLinkEffects(eMind, eDaze);
    eLink = EffectLinkEffects(eLink, eCessate);

    // Start cycling through the AOE Object for viable targets
    oTarget = GetFirstInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget))
    {
        // PvP check
        if(!GetIsReactionTypeFriendly(oTarget, oCaster) &&
        // Make sure they are not immune to spells
           !SMP_TotalSpellImmunity(oTarget))
        {
            // Get a small delay
            fDelay = SMP_GetRandomDelay(0.1, 3.0);

            // Spell resistance
            if(!SMP_SpellResistanceCheck(oCaster, oTarget, fDelay))
            {
                // Fire cast spell at event for the affected target
                SMP_SignalSpellCastAt(oTarget, SMP_SPELL_WHATEVER);

                // Apply damage and visuals
                DelayCommand(fDelay, SMP_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration));
            }
        }
        // Get next target.
        oTarget = GetNextInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);
    }
}
