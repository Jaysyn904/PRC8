/*:://////////////////////////////////////////////
//:: Spell Name Darkness: On Enter
//:: Spell FileName PHS_S_DarknessA
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    AOE mearly applies a 20% consealment bonus. Note that if they have Daylight
    applied to them, then it cannot be consealed as the effects negate each
    other.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Check AOE status
    if(!PHS_CheckAOECreator()) return;

    // Declare major variables
    object oTarget = GetEnteringObject();
    object oCreator = GetAreaOfEffectCreator();

    //Declare major effects
    effect eConseal = EffectConcealment(20);

    //Fire cast spell at event for the target
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_DARKNESS);

    // Apply effects
    // * Cosealment doesn't overlap.
    PHS_ApplyPermanent(oTarget, eConseal);
}
