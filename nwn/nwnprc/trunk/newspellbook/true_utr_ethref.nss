/*
   ----------------
   Ether Reforged

   true_utr_ethref
   ----------------

    4/8/06 by Stratovarius
*/ /** @file

    Ether Reforged
    
    Level: Evolving Mind 6
    Range: 60 feet
    Target: One Creature
    Duration: 5 Rounds
    Spell Resistance: No
    Save: None
    Metautterances: Extend

    Normal:  With this utterance, creatures of the ethereal world become as solid as the earth.
             Your target loses any ethereal effects.
    Reverse: One of your allies slips into the space between worlds and leaps onto the Ethereal Plane.
             Your ally becomes ethereal.
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
        // This utterance applies only to friends
        utter.bFriend = TRUE;
        utter.nPen       = GetTrueSpeakPenetration(oTrueSpeaker);
        int nSRCheck;
        utter.fDur = RoundsToSeconds(5);
        if(utter.bExtend) utter.fDur *= 2;
        
        // The NORMAL effect of the Utterance goes here
        if (utter.nSpellId == UTTER_ETHER_REFORGED)
        {
        	// If the Spell Penetration fails, don't apply any effects
        	// Its done this way so the law of sequence is applied properly
        	nSRCheck = PRCDoResistSpell(oTrueSpeaker, oTarget, utter.nPen);
        	if (!nSRCheck)
        	{        
	            	effect eFear = GetFirstEffect(oTarget);
	            	//Get the first effect on the current target
	            	while(GetIsEffectValid(eFear))
	            	{
	            	    if (GetEffectType(eFear) == EFFECT_TYPE_ETHEREAL)
	            	    {
	            	        //Remove any fear effects and apply the VFX impact
	            	        RemoveEffect(oTarget, eFear);
	            	    }
	            	    //Get the next effect on the target
	            	    eFear = GetNextEffect(oTarget);
	            	}
	        	utter.eLink2 = EffectVisualEffect(VFX_IMP_REMOVE_CONDITION);
	        }
        	utter.fDur = 0.0;
        }
        // The REVERSE effect of the Utterance goes here
        else // UTTER_ETHER_REFORGED_R
        {
        	// Used to Ignore SR in Speak Unto the Masses for friendly utterances.
		utter.bIgnoreSR = TRUE;
		utter.eLink     =                                EffectEthereal();
		utter.eLink     = EffectLinkEffects(utter.eLink, EffectVisualEffect(VFX_DUR_TEMPORAL_STASIS));
                utter.eLink     = EffectLinkEffects(utter.eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
        }
        // Duration Effects
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, utter.eLink, oTarget, utter.fDur, TRUE, utter.nSpellId, utter.nTruespeakerLevel);
        
        // Speak Unto the Masses. Swats an area with the effects of this utterance
        DoSpeakUntoTheMasses(oTrueSpeaker, oTarget, utter);
        // Mark for the Law of Sequence. This only happens if the utterance succeeds, which is why its down here.
        // The utterance isn't active if SR stops it
        if (!nSRCheck) DoLawOfSequence(oTrueSpeaker, utter.nSpellId, utter.fDur);
    }// end if - Successful utterance    
}
