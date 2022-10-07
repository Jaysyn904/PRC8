/*
   ----------------
   Speed of the Zephyr

   true_utr_zephyr
   ----------------

   1/8/06 by Stratovarius
*/ /** @file

    Speed of the Zephyr
    
    Level: Evolving Mind 2
    Range: 60 feet
    Target: One Creature
    Duration: 5 Round
    Spell Resistance: Yes
    Save: None
    Metautterances: Extend

    Normal:  You urge your ally on to greater speed with this utterance.
             Your ally gains 20' per round speed boost.
    Reverse: The target of this utterance cannot move as quickly as it had just a moment before.
             Your target takes a 10' per round speed penalty.
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
        utter.fDur = RoundsToSeconds(5);
        if(utter.bExtend) utter.fDur *= 2;
        utter.nPen = GetTrueSpeakPenetration(oTrueSpeaker);
        int nSRCheck;
        
        // The NORMAL effect of the Utterance goes here
        if (utter.nSpellId == UTTER_SPEED_ZEPHYR)
        {
        	// Used to Ignore SR in Speak Unto the Masses for friendly utterances.
		utter.bIgnoreSR = TRUE;
		// This utterance applies only to friends
        	utter.bFriend = TRUE;
        	// Movement boost
        	utter.eLink = EffectMovementSpeedIncrease(66);
        	// Impact VFX 
		utter.eLink2 = EffectVisualEffect(VFX_IMP_HASTE);
        }
        // The REVERSE effect of the Utterance goes here
        else // UTTER_SPEED_ZEPHYR_R
        {
		// If the Spell Penetration fails, don't apply any effects
		nSRCheck = PRCDoResistSpell(oTrueSpeaker, oTarget, utter.nPen);
		if (!nSRCheck)
		{
			// eLink is used for Duration Effects (Speed Decrease)
			utter.eLink = EffectMovementSpeedDecrease(33);
			// Impact VFX 
			utter.eLink2 = EffectVisualEffect(VFX_IMP_SLOW);
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
        if (!nSRCheck) DoLawOfSequence(oTrueSpeaker, utter.nSpellId, utter.fDur);
    }// end if - Successful utterance    
}
