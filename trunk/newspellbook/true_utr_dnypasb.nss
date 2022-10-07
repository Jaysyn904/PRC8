/*
   ----------------
   Deny Passage, Exit

   true_utr_dnypasb
   ----------------

    4/9/06 by Stratovarius
*/ /** @file

    Deny Passage

    Level: Perfected Map 4
    Range: 100 feet
    Area: 20' Radius
    Duration: 1 Minute
    Spell Resistance: No
    Save: None
    Metautterances: Extend

    You force an area to deny access to a group of creatures specified by your utterance. 
    Hostile creatures cannot enter or exit the area of effect.
*/

#include "true_inc_trufunc"
#include "true_utterhook"
//#include "prc_alterations"

void DoPush(object oTarget, object oTrueSpeaker, int nReverse = FALSE);

void main()
{
    SetAllAoEInts(UTTER_DENY_PASSAGE, OBJECT_SELF, GetSpellSaveDC());
    object oTarget = GetExitingObject();
    
    // Only affect enemies/neutrals
    if (!GetIsFriend(oTarget, GetAreaOfEffectCreator()))
    {
   	//Fire cast spell at event for the target
    	SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), UTTER_DENY_PASSAGE));
    	
    	// Punt them back into the area
	DoPush(oTarget, OBJECT_SELF);
    }
}

void DoPush(object oTarget, object oTrueSpeaker, int nReverse = FALSE)
{
            // Get Location
            location lTrueSpeaker   = GetLocation(oTrueSpeaker);
            
            // Move the target back to the centre of the AoE
            AssignCommand(oTarget, ClearAllActions(TRUE));
            AssignCommand(oTarget, JumpToLocation(lTrueSpeaker));
}