/*
   ----------------
   Vision Sharpened

   true_utr_visshrp
   ----------------

   2/8/06 by Stratovarius
*/ /** @file

    Vision Sharpened

    Level: Evolving Mind 3
    Range: 60 feet
    Target: One Creature
    Duration: 5 Rounds
    Spell Resistance: Yes
    Save: None
    Metautterances: Extend

    Normal:  Your ally can see the unseen in the warp and weft of air nearby.
             Your ally gains See Invisibility.
    Reverse: With the reverse of this utterance, your target disappears from view.
             Your ally becomes invisibile.
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
        utter.nPen       = GetTrueSpeakPenetration(oTrueSpeaker);
        utter.fDur       = RoundsToSeconds(5);
        int nSRCheck;
        if(utter.bExtend) utter.fDur *= 2;
        // This utterance applies only to friends
	utter.bFriend = TRUE;
	// Used to Ignore SR in Speak Unto the Masses for friendly utterances.
        utter.bIgnoreSR = TRUE;        
        
        // The NORMAL effect of the Utterance goes here
        if (utter.nSpellId == UTTER_VISION_SHARPENED)
        {
        	// See Invis
        	utter.eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_ULTRAVISION), EffectSeeInvisible());
        	// Impact VFX 
        	utter.eLink2 = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);
        }
        // The REVERSE effect of the Utterance goes here
        else // UTTER_VISION_SHARPENED_R
        {
        	// If the Spell Penetration fails, don't apply any effects
        	nSRCheck = PRCDoResistSpell(oTrueSpeaker, oTarget, utter.nPen);
        	if (!nSRCheck)
        	{
       			// Invis
       			utter.eLink = EffectLinkEffects(EffectInvisibility(INVISIBILITY_TYPE_NORMAL), EffectVisualEffect(VFX_DUR_INVISIBILITY));
       			// Impact VFX 
        		utter.eLink2 = EffectVisualEffect(VFX_IMP_HEAD_MIND);
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
