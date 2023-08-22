/*
   ----------------
   Deny Passage, Enter

   true_utr_dnypasa
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
    object oTarget = GetEnteringObject();
    
    // Only affect enemies/neutrals
    if (!GetIsFriend(oTarget, GetAreaOfEffectCreator()))
    {
   	//Fire cast spell at event for the target
    	SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), UTTER_DENY_PASSAGE));
    	
    	// Punt them out of the area
	DoPush(oTarget, OBJECT_SELF);
    }
}

void DoPush(object oTarget, object oTrueSpeaker, int nReverse = FALSE)
{
            // Calculate how far the creature gets pushed
            float fDistance = FeetToMeters(10.0);
            // Determine if they hit a wall on the way
            location lTrueSpeaker   = GetLocation(oTrueSpeaker);
            location lTargetOrigin = GetLocation(oTarget);
            vector vAngle          = AngleToVector(GetRelativeAngleBetweenLocations(lTrueSpeaker, lTargetOrigin));
            vector vTargetOrigin   = GetPosition(oTarget);
            vector vTarget         = vTargetOrigin + (vAngle * fDistance);

            if(!LineOfSightVector(vTargetOrigin, vTarget))
            {
                // Hit a wall, binary search for the wall
                float fEpsilon    = 1.0f;          // Search precision
                float fLowerBound = 0.0f;          // The lower search bound, initialise to 0
                float fUpperBound = fDistance;     // The upper search bound, initialise to the initial distance
                fDistance         = fDistance / 2; // The search position, set to middle of the range

                do{
                    // Create test vector for this iteration
                    vTarget = vTargetOrigin + (vAngle * fDistance);

                    // Determine which bound to move.
                    if(LineOfSightVector(vTargetOrigin, vTarget))
                        fLowerBound = fDistance;
                    else
                        fUpperBound = fDistance;

                    // Get the new middle point
                    fDistance = (fUpperBound + fLowerBound) / 2;
                }while(fabs(fUpperBound - fLowerBound) > fEpsilon);
            }

            // Create the final target vector
            vTarget = vTargetOrigin + (vAngle * fDistance);

            // Move the target
            location lTargetDestination = Location(GetArea(oTarget), vTarget, GetFacing(oTarget));
            AssignCommand(oTarget, ClearAllActions(TRUE));
            AssignCommand(oTarget, JumpToLocation(lTargetDestination));
}