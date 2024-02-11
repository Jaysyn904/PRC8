/*
   ----------------
   Singular Mind

   true_utr_sngmnd
   ----------------

    4/8/06 by Stratovarius
*/ /** @file

    Singular Mind

    Level: Evolving Mind 6
    Range: 60 feet
    Target: One Creature
    Duration: Instantaneous (Normal) or 5 Rounds (Reverse)
    Spell Resistance: Yes
    Save: None (Normal) or Will Negates (Reverse)
    Metautterances: Extend

    Normal:  With a word, you liberate your target from all foreign influence, freeing her mind. Any enchantments or curses are converted to runic truespeech and fade harmlessly away.
             This utterance removes any negative mind affecting effect.
    Reverse: Your words crawl into the mind of your enemy, allowing you to control your foe's body as if it were your puppet.
             Your target is dominated.
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
        utter.fDur       = RoundsToSeconds(5);
        if(utter.bExtend) utter.fDur *= 2;
        int nSRCheck;
        int nSaveCheck;
        
        // The NORMAL effect of the Utterance goes here
        if (utter.nSpellId == UTTER_SINGULAR_MIND)
        {
        	// Used to Ignore SR in Speak Unto the Masses for friendly utterances.
        	utter.bIgnoreSR = TRUE;
        	// This utterance applies only to friends
        	utter.bFriend = TRUE;
        	
            	effect eFear = GetFirstEffect(oTarget);
            	//Get the first effect on the current target
            	while(GetIsEffectValid(eFear))
            	{
            	    if (GetEffectType(eFear) == EFFECT_TYPE_CHARMED ||
            	        GetEffectType(eFear) == EFFECT_TYPE_CONFUSED ||
            	        GetEffectType(eFear) == EFFECT_TYPE_CURSE ||
            	        GetEffectType(eFear) == EFFECT_TYPE_DAZED ||
            	        GetEffectType(eFear) == EFFECT_TYPE_DOMINATED ||
            	        GetEffectType(eFear) == EFFECT_TYPE_CONFUSED ||
            	        GetEffectType(eFear) == EFFECT_TYPE_FRIGHTENED ||
            	        GetEffectType(eFear) == EFFECT_TYPE_SLEEP ||
            	        GetEffectType(eFear) == EFFECT_TYPE_STUNNED)
            	    {
            	        //Remove any fear effects and apply the VFX impact
            	        RemoveEffect(oTarget, eFear);
            	    }
            	    //Get the next effect on the target
            	    eFear = GetNextEffect(oTarget);
            	}
        	utter.eLink2 = EffectVisualEffect(VFX_IMP_REMOVE_CONDITION);
        	// No duration
        	utter.fDur = 0.0;
        }
        // The REVERSE effect of the Utterance goes here
        else // UTTER_SINGULAR_MIND_R
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
                		// Dominated
				utter.eLink = EffectLinkEffects(EffectDominated(), EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DOMINATED));
				utter.eLink2 = EffectLinkEffects(EffectVisualEffect(VFX_IMP_DOMINATE_S), EffectVisualEffect(VFX_FNF_FEEBLEMIND));
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
