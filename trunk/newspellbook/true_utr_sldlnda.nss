/*
   ----------------
   Shield of the Landscape, Enter

   true_utr_sldlnda
   ----------------

    1/9/06 by Stratovarius
*/ /** @file

    Shield of the Landscape

    Level: Perfected Map 1
    Range: 100 feet
    Area: 20' Radius, Centred on Caster 
    Duration: 1 Minute
    Spell Resistance: No
    Save: None
    Metautterances: Extend

    You cause the ground to alter its basic form, creating cover for you allies.
    All allies (including you) in the area gain 20% concealment vs Ranged attacks.
*/

#include "true_inc_trufunc"
#include "true_utterhook"
//#include "prc_alterations"

void main()
{
    SetAllAoEInts(UTTER_SHIELD_LANDSCAPE,OBJECT_SELF, GetSpellSaveDC());

    object oTarget = GetEnteringObject();
    
    if (GetIsFriend(oTarget, GetAreaOfEffectCreator()))
    {
    	//Declare major variables
    	effect eConceal = EffectConcealment(20, MISS_CHANCE_TYPE_VS_RANGED);

    	//Fire cast spell at event for the target
    	SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), UTTER_SHIELD_LANDSCAPE));
    	
	// Maximum time possible. If its less, its simply cleaned up when the utterance ends.
    	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eConceal, oTarget, RoundsToSeconds(20));
    }
}
