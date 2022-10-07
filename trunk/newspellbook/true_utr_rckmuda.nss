/*
   ----------------
   Speak Rock to Mud, Enter

   true_utr_rckmuda
   ----------------

    2/9/06 by Stratovarius
*/ /** @file

    Speak Rock to Mud

    Level: Perfected Map 2
    Range: 100 feet
    Area: 20' Radius
    Duration: 1 Minute
    Spell Resistance: No
    Save: None
    Metautterances: Extend

    With a word, you create an area of viscous, sucking mud.
    Every creature in the area has their speed reduced by 80%, and take a -2 penalty to AC and Attack.
*/

#include "true_inc_trufunc"
#include "true_utterhook"
//#include "prc_alterations"

void main()
{
    SetAllAoEInts(UTTER_SPEAK_ROCK_MUD,OBJECT_SELF, GetSpellSaveDC());

    //Declare major variables
    object oTarget = GetEnteringObject();
    effect eSlow = EffectMovementSpeedDecrease(80);
    effect eAttack = EffectAttackDecrease(2);
    effect eAC = EffectACDecrease(2);
    // Link
    effect eLink = EffectLinkEffects(eSlow, eAttack);
    eLink = EffectLinkEffects(eLink, eAC);

    //Fire cast spell at event for the target
    SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), UTTER_SPEAK_ROCK_MUD));

    // Maximum time possible. If its less, its simply cleaned up when the utterance ends.
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(20));
}
