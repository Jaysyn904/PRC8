/*
   ----------------
   Hidden Truth

   true_utr_hdntrth
   ----------------

   1/8/06 by Stratovarius
*/ /** @file

    Hidden Truth
    
    Level: Evolving Mind 2
    Range: 60 feet
    Target: One Creature
    Duration: 1 Round
    Spell Resistance: No
    Save: None
    Metautterances: Extend

    Normal:  Your words allow your target to tap into a reserve of knowledge
             Your ally gains +10 to all Lore checks.
    Reverse: Your target's words ring true thanks to this utterance - even if they actually are not.
             Your ally gains +10 to all Bluff checks.
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
        // Used to Ignore SR in Speak Unto the Masses for friendly utterances.
	utter.bIgnoreSR = TRUE;
	// This utterance applies only to friends
        utter.bFriend = TRUE;
        utter.fDur = RoundsToSeconds(1);
        if(utter.bExtend) utter.fDur *= 2;
        
        // The NORMAL effect of the Utterance goes here
        if (utter.nSpellId == UTTER_HIDDEN_TRUTH)
        {
        	// Lore
        	utter.eLink = EffectLinkEffects(EffectSkillIncrease(SKILL_LORE, 10), EffectVisualEffect(VFX_DUR_SHIELD_OF_LAW));
        }
        // The REVERSE effect of the Utterance goes here
        else // UTTER_HIDDEN_TRUTH_R
        {
		// Bluff
		utter.eLink = EffectLinkEffects(EffectSkillIncrease(SKILL_BLUFF, 10), EffectVisualEffect(VFX_DUR_ENTROPIC_SHIELD));
        }
        // Duration Effects
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, utter.eLink, oTarget, utter.fDur, TRUE, utter.nSpellId, utter.nTruespeakerLevel);
        
        // Speak Unto the Masses. Swats an area with the effects of this utterance
        DoSpeakUntoTheMasses(oTrueSpeaker, oTarget, utter);
        // Mark for the Law of Sequence. This only happens if the utterance succeeds, which is why its down here.
        // The utterance isn't active if SR stops it
        DoLawOfSequence(oTrueSpeaker, utter.nSpellId, utter.fDur);
    }// end if - Successful utterance    
}
