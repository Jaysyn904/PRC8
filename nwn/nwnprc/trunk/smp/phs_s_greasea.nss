/*:://////////////////////////////////////////////
//:: Spell Name Grease: On Enter
//:: Spell FileName PHS_S_GreaseA
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Grease will knockdown creatures (falling them) each round.

    The dexterity check replaces this text:

    A creature can walk within or through the area of grease at half normal speed
    with a DC 10 Balance check. Failure means it can’t move that round (and must
    then make a Reflex save or fall), while failure by 5 or more means it falls
    (see the Balance skill for details).

    Which only applies if they are doing ACTION_MOVETOPOINT.

    On Enter:
    - Applies the 50% (half speed) movement penalty, always (no SR).

    I've decided heartbeat might as well do the knockdown.
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
    effect eSlow = EffectMovementSpeedDecrease(50);

    // Fire cast spell at event for the target
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_GREASE);

    // Apply effects
    PHS_AOE_OnEnterEffects(eSlow, oTarget, PHS_SPELL_GREASE);
}
