/*
   ----------------
   Eldritch Attraction

   true_utr_eldarct
   ----------------

    4/8/06 by Stratovarius
*/ /** @file

    Eldritch Attraction

    Level: Evolving Mind 5
    Range: 60 feet
    Target: One Creature
    Duration: Instantaneous
    Spell Resistance: Yes
    Save: None (Normal) or Will Negates (Reverse)
    Metautterances: None

    Normal:  The universe responds to your words by forcing your target closer to you.
             Your target is moved closer to you by 40 feet.
    Reverse: Your target is repelled, forced away by your command of Truespeech. 
             Your target is moved away from you by 40 feet.
*/

#include "true_inc_trufunc"
#include "true_utterhook"
//#include "prc_alterations"

void DoPush(object oTarget, object oTrueSpeaker, int nReverse = FALSE);

void main()
{
/*
  Spellcast Hook Code
  Added 2006-7-19 by Stratovarius
  If you want to make changes to all utterances
  check true_utterhook to find out more

*/

    if (!TruePreUtterCastCode())
    {
    // If code within the PreUtterCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    object oTrueSpeaker = OBJECT_SELF;
    object oTarget      = PRCGetSpellTargetObject();
    struct utterance utter = EvaluateUtterance(oTrueSpeaker, oTarget, METAUTTERANCE_NONE, LEXICON_EVOLVING_MIND);

    if(utter.bCanUtter)
    {
	// This is done so Speak Unto the Masses can read it out of the structure
 	utter.nSaveType  = SAVING_THROW_TYPE_NONE;
    	utter.nSaveThrow = SAVING_THROW_WILL;
        utter.nPen       = GetTrueSpeakPenetration(oTrueSpeaker);
        utter.nSaveDC    = GetTrueSpeakerDC(oTrueSpeaker);    	
        int nSRCheck;
        int nSaveCheck;
        
        // The NORMAL effect of the Utterance goes here
        if (utter.nSpellId == UTTER_ELDRITCH_ATTRACTION)
        {
        	// If the Spell Penetration fails, don't apply any effects
        	// Its done this way so the law of sequence is applied properly
        	nSRCheck = PRCDoResistSpell(oTrueSpeaker, oTarget, utter.nPen);
        	if (!nSRCheck)
        	{
        		// Saving throw
        		nSaveCheck = PRCMySavingThrow(utter.nSaveThrow, oTarget, utter.nSaveDC, utter.nSaveType, OBJECT_SELF);
        		if(!nSaveCheck)
                	{
                		// Movement
				DoPush(oTarget, oTrueSpeaker, TRUE);
				utter.eLink2 = EffectVisualEffect(VFX_IMP_DIMENSIONLOCK);
			}
        	}
        }
        // The REVERSE effect of the Utterance goes here
        else // UTTER_ELDRITCH_ATTRACTION_R
        {
        	// If the Spell Penetration fails, don't apply any effects
        	// Its done this way so the law of sequence is applied properly
        	nSRCheck = PRCDoResistSpell(oTrueSpeaker, oTarget, utter.nPen);
        	if (!nSRCheck)
        	{
        		// Saving throw
        		nSaveCheck = PRCMySavingThrow(utter.nSaveThrow, oTarget, utter.nSaveDC, utter.nSaveType, OBJECT_SELF);
        		if(!nSaveCheck)
                	{
                		// Movement
				DoPush(oTarget, oTrueSpeaker);
				utter.eLink2 = EffectVisualEffect(VFX_IMP_DIMENSIONLOCK);
			}
        	}
        }
        // Duration Effects
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, utter.eLink, oTarget, utter.fDur, TRUE, utter.nSpellId, utter.nTruespeakerLevel);
        // Impact Effects
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, utter.eLink2, oTarget);
        
        // Speak Unto the Masses. Swats an area with the effects of this utterance
        DoSpeakUntoTheMasses(oTrueSpeaker, oTarget, utter);
        // Mark for the Law of Sequence. This only happens if the utterance succeeds, which is why its down here.
        // The utterance isn't active if SR stops it
        if (!nSRCheck && !nSaveCheck) DoLawOfSequence(oTrueSpeaker, utter.nSpellId, utter.fDur);
    }// end if - Successful utterance    
}

void DoPush(object oTarget, object oTrueSpeaker, int nReverse = FALSE)
{
            // Calculate how far the creature gets pushed
            float fDistance = FeetToMeters(40.0);
            // Flip distance
            if (nReverse) fDistance *= -1;
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