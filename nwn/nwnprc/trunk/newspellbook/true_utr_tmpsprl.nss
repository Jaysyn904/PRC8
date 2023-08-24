/*
   ----------------
   Temporal Spiral

   true_utr_tmpsprl
   ----------------

   2/8/06 by Stratovarius
*/ /** @file

    Temporal Spiral

    Level: Evolving Mind 3
    Range: 60 feet
    Target: One Creature
    Duration: 1 Round (Normal) or 3 Rounds (Reverse)
    Spell Resistance: Yes
    Save: None (Normal) or Will Negates (Reverse)
    Metautterances: Extend

    Normal:  Everything your target does seems quicker.
             Your ally gains an additional move action (haste).
    Reverse: This powerful utterance sounds like the churning of ancient earth, freezing your target in place.
             Your foe is dazed for three rounds.
*/

#include "true_inc_trufunc"
#include "true_utterhook"
//#include "prc_alterations"

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
    struct utterance utter = EvaluateUtterance(oTrueSpeaker, oTarget, METAUTTERANCE_EXTEND, LEXICON_EVOLVING_MIND);

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
        if (utter.nSpellId == UTTER_TEMPORAL_SPIRAL)
        {
        	// Used to Ignore SR in Speak Unto the Masses for friendly utterances.
        	utter.bIgnoreSR = TRUE;
        	// This utterance applies only to friends
        	utter.bFriend = TRUE;
        	// eLink is used for Duration Effects (Buff/Penalty to AC)
        	utter.fDur       = RoundsToSeconds(1);
        	utter.eLink = EffectHaste();
        	utter.eLink2 = EffectVisualEffect(VFX_IMP_HASTE);
        }
        // The REVERSE effect of the Utterance goes here
        else // UTTER_TEMPORAL_SPIRAL_R
        {
        	// Duration for this part
        	utter.fDur       = RoundsToSeconds(3);
        	// If the Spell Penetration fails, don't apply any effects
        	// Its done this way so the law of sequence is applied properly
        	nSRCheck = PRCDoResistSpell(oTrueSpeaker, oTarget, utter.nPen);
        	if (!nSRCheck)
        	{
        		// Saving throw
        		nSaveCheck = PRCMySavingThrow(utter.nSaveThrow, oTarget, utter.nSaveDC, utter.nSaveType, OBJECT_SELF);
        		if(!nSaveCheck)
                	{
                		// Concealment
				utter.eLink = EffectDazed();
				utter.eLink2 = EffectVisualEffect(VFX_IMP_DAZED_S);
			}
        	}
        }
        if(utter.bExtend) utter.fDur *= 2;
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
