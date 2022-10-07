/*
   ----------------
   Sensory Focus

   true_utr_snsfoc
   ----------------

    4/8/06 by Stratovarius
*/ /** @file

    Sensory Focus
    
    Level: Evolving Mind 5
    Range: 60 feet
    Target: One Creature
    Duration: 1 Round (Normal) or 3 Rounds (Reverse)
    Spell Resistance: No
    Save: Fortitude
    Metautterances: Extend

    Normal:  Your target can pierce the veil of deception and see everything as it truly is.
             Your ally gains trueseeing.
    Reverse: Your words strip away your target's ability to see or hear
             Your target is struck blind and deaf.
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
    	utter.nSaveThrow = SAVING_THROW_FORT;
        utter.nPen       = GetTrueSpeakPenetration(oTrueSpeaker);
        utter.nSaveDC    = GetTrueSpeakerDC(oTrueSpeaker); 
        int nSRCheck;
        int nSaveCheck;
        
        // The NORMAL effect of the Utterance goes here
        if (utter.nSpellId == UTTER_SENSORY_FOCUS)
        {
        	utter.fDur       = RoundsToSeconds(1);
		// Used to Ignore SR in Speak Unto the Masses for friendly utterances.
		utter.bIgnoreSR = TRUE;
		// This utterance applies only to friends
        	utter.bFriend = TRUE;
        	// Lore
        	utter.eLink = EffectLinkEffects(EffectTrueSeeing(), EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT));
        }
        // The REVERSE effect of the Utterance goes here
        else // UTTER_SENSORY_FOCUS_R
        {
		utter.fDur       = RoundsToSeconds(3);
        	// If the Spell Penetration fails, don't apply any effects
        	// Its done this way so the law of sequence is applied properly
        	nSRCheck = PRCDoResistSpell(oTrueSpeaker, oTarget, utter.nPen);
        	if (!nSRCheck && PRCGetIsAliveCreature(oTarget))
        	{
        		// Saving throw
        		nSaveCheck = PRCMySavingThrow(utter.nSaveThrow, oTarget, utter.nSaveDC, utter.nSaveType, OBJECT_SELF);
        		if(!nSaveCheck)
                	{
                		// Concealment
				utter.eLink = EffectLinkEffects(EffectBlindness(), EffectDeaf());
				utter.eLink = EffectLinkEffects(utter.eLink, EffectVisualEffect(VFX_IMP_BLIND_DEAF_M));
				utter.eLink = EffectLinkEffects(utter.eLink, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));
			}
        	}
        }
        if(utter.bExtend) utter.fDur *= 2;
        // Duration Effects
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, utter.eLink, oTarget, utter.fDur, TRUE, utter.nSpellId, utter.nTruespeakerLevel);
        
        // Speak Unto the Masses. Swats an area with the effects of this utterance
        DoSpeakUntoTheMasses(oTrueSpeaker, oTarget, utter);
        // Mark for the Law of Sequence. This only happens if the utterance succeeds, which is why its down here.
        // The utterance isn't active if SR/Save stops it
        if (!nSRCheck && !nSaveCheck) DoLawOfSequence(oTrueSpeaker, utter.nSpellId, utter.fDur);
    }// end if - Successful utterance    
}
