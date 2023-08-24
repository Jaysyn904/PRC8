/*
   ----------------
   Speed of the Zephyr, Greater

   true_utr_zephyrg
   ----------------

   2/8/06 by Stratovarius
*/ /** @file

    Speed of the Zephyr, Greater
    
    Level: Evolving Mind 3
    Range: 60 feet
    Target: One Creature
    Duration: 3 Rounds
    Spell Resistance: Yes
    Save: None
    Metautterances: Extend

    Normal:  Your ally's movements are quicker, enhacing his offensive and defensive capabilities
             Your ally gains haste.
    Reverse: When you speak this utterance, your target moves as though through molasses
             Your target is slowed.
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
        utter.fDur = RoundsToSeconds(3);
        if(utter.bExtend) utter.fDur *= 2;
        utter.nPen = GetTrueSpeakPenetration(oTrueSpeaker);
        int nSRCheck;
        
        // The NORMAL effect of the Utterance goes here
        if (utter.nSpellId == UTTER_SPEED_ZEPHYR_GREATER)
        {
        	// Used to Ignore SR in Speak Unto the Masses for friendly utterances.
		utter.bIgnoreSR = TRUE;
		// This utterance applies only to friends
        	utter.bFriend = TRUE;
        	// Movement boost
        	utter.eLink = EffectHaste();
        	// Impact VFX 
		utter.eLink2 = EffectVisualEffect(VFX_IMP_HASTE);
        }
        // The REVERSE effect of the Utterance goes here
        else // UTTER_SPEED_ZEPHYR_GREATER_R
        {
		// If the Spell Penetration fails, don't apply any effects
		nSRCheck = PRCDoResistSpell(oTrueSpeaker, oTarget, utter.nPen);
		if (!nSRCheck)
		{
			// eLink is used for Duration Effects (Speed Decrease)
			utter.eLink = EffectSlow();
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
