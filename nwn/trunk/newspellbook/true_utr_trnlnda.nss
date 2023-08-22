/*
   ----------------
   Transform the Landscape, Enter

   true_utr_trnlnda
   ----------------

    2/9/06 by Stratovarius
*/ /** @file

    Transform the Landscape

    Level: Perfected Map 2
    Range: 100 feet
    Area: 20' Radius
    Duration: 1 Minute
    Spell Resistance: No
    Save: None
    Metautterances: Extend

    You cause the grouns to crack and split beneath your enemies' feet, impeding their progress.
    All enemies in the area are affected by difficult terrain (50% movement speed reduction).
*/

#include "true_inc_trufunc"
#include "true_utterhook"
//#include "prc_alterations"

void main()
{
    SetAllAoEInts(UTTER_SPEAK_ROCK_MUD,OBJECT_SELF, GetSpellSaveDC());
    //Declare major variables
    object oTarget = GetEnteringObject();
    
    // Doesn't affect allies
    if (!GetIsFriend(oTarget, GetAreaOfEffectCreator()))
    {
    	//Declare major variables
    	effect eSlow = EffectMovementSpeedDecrease(50);

    	//Fire cast spell at event for the target
    	SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), UTTER_TRANSFORM_LANDSCAPE));
    	
	// Maximum time possible. If its less, its simply cleaned up when the utterance ends.
    	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSlow, oTarget, RoundsToSeconds(20));
    }
}
