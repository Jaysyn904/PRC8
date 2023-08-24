/*:://////////////////////////////////////////////
//:: Spell Name Waves of Fatigue
//:: Spell FileName PHS_S_WavesOfFat
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Necromancy
    Level: Sor/Wiz 5
    Components: V, S
    Casting Time: 1 standard action
    Range: 10M (30 ft.)
    Area: Cone-shaped burst
    Duration: Instantaneous
    Saving Throw: No
    Spell Resistance: Yes

    Waves of negative energy render all living creatures in the spell’s area
    fatigued. This spell has no effect on a creature that is already fatigued.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Easy, using PHS_ApplyFatigue(), and thats that.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check
    if(!PHS_SpellHookCheck(PHS_SPELL_WAVES_OF_FATIGUE)) return;

    // Delcare major variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lTarget = GetSpellTargetLocation();
    float fDelay;

    // Declare effects
    effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);

    // Cycle through all objects in the 10M cone.
    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 10.0, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget))
    {
        // PvP check
        if(!GetIsReactionTypeFriendly(oTarget) &&
        // Make sure they are not immune to spells
           !PHS_TotalSpellImmunity(oTarget))
        {
            // Signal event
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_WAVES_OF_FATIGUE);

            // Get delay
            fDelay = GetDistanceToObject(oTarget)/20;

            // Spell resistance check
            if(!PHS_SpellResistanceCheck(oCaster, oTarget, fDelay))
            {
                // Apply fatigue
                DelayCommand(fDelay - 0.1, PHS_ApplyFatigue(oTarget));
                DelayCommand(fDelay, PHS_ApplyVFX(oTarget, eVis));
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 10.0, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
}
