/*:://////////////////////////////////////////////
//:: Spell Name Entangle: On Enter
//:: Spell FileName PHS_S_EntangleA
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    No SR, noting that.

    On Heartbeat will do reflex saves to apply EffectEntangle, for a permament
    duration.
    On Heartbeat will do a STR check if they are already entangled, to remove it.

    On Enter applies slow effect. On Exit should remove all effects.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Check AOE status
    if(!PHS_CheckAOECreator()) return;

    // Set plot flag to TRUE
    // * As this is centred on the caster, this will always fire straight away
    SetPlotFlag(OBJECT_SELF, TRUE);

    // Declare major variables
    object oTarget = GetEnteringObject();
    object oCreator = GetAreaOfEffectCreator();

    //Declare major effects
    effect eSlow = EffectMovementSpeedDecrease(50);

    //Fire cast spell at event for the target
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_ENTANGLE);

    // Apply effects
    PHS_AOE_OnEnterEffects(eSlow, oTarget, PHS_SPELL_ENTANGLE);
}
