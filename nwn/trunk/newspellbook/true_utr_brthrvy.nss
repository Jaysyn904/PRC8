/*
   ----------------
   Breath of Recovery

   true_utr_brthrvy
   ----------------

    4/8/06 by Stratovarius
*/ /** @file

    Breath of Recovery

    Level: Evolving Mind 6
    Range: 60 feet
    Target: One Creature
    Duration: 1 Round
    Spell Resistance: Yes
    Save: None (Normal) or Fort Negates (Reverse)
    Metautterances: Extend

    Normal:  You speak a word of purity in the language of Truespeech, reminding the universe of an ally's natural state. 
             This utterance removes ability damage, blindness, confusion, dazed, deafened, diseased, stunning, or poison.
    Reverse: Your words of power roll over you target's body, which stiffens into rigidity.
             Your target is paralyzed.
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
        utter.fDur       = RoundsToSeconds(1);
        if(utter.bExtend) utter.fDur *= 2;
        int nSRCheck;
        int nSaveCheck;
        
        // The NORMAL effect of the Utterance goes here
        if (utter.nSpellId == UTTER_BREATH_RECOVERY)
        {
        	// Used to Ignore SR in Speak Unto the Masses for friendly utterances.
        	utter.bIgnoreSR = TRUE;
        	// This utterance applies only to friends
        	utter.bFriend = TRUE;
        	
            	effect eFear = GetFirstEffect(oTarget);
            	//Get the first effect on the current target
            	while(GetIsEffectValid(eFear))
            	{
            	    if (GetEffectType(eFear) == EFFECT_TYPE_BLINDNESS ||
            	        GetEffectType(eFear) == EFFECT_TYPE_DEAF ||
            	        GetEffectType(eFear) == EFFECT_TYPE_POISON ||
            	        GetEffectType(eFear) == EFFECT_TYPE_DAZED ||
            	        GetEffectType(eFear) == EFFECT_TYPE_ABILITY_DECREASE ||
            	        GetEffectType(eFear) == EFFECT_TYPE_CONFUSED ||
            	        GetEffectType(eFear) == EFFECT_TYPE_DISEASE ||
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
        else // UTTER_BREATH_CLEANSING_R
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
                		// Paralyzed
				utter.eLink = EffectLinkEffects(EffectParalyze(), EffectVisualEffect(VFX_DUR_PARALYZE_HOLD));
				utter.eLink2 = EffectLinkEffects(EffectVisualEffect(VFX_IMP_DISEASE_S), EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE_RED));
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
