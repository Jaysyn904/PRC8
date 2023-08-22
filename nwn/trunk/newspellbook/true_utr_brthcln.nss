/*
   ----------------
   Breath of Cleansing

   true_utr_brthcln
   ----------------

   3/8/06 by Stratovarius
*/ /** @file

    Breath of Cleansing

    Level: Evolving Mind 4
    Range: 60 feet
    Target: One Creature
    Duration: 1 Round
    Spell Resistance: Yes
    Save: None (Normal) or Fort Negates (Reverse)
    Metautterances: Extend

    Normal:  With a word, magical breath passes from your mouth to another creature afflicted with harmful magic, cleansing his body of the taint.
             It will remove any poison, deafness, blindness or daze effect from your target.
    Reverse: Your words evoke feelings of terror, dread, and awe in your target.
             Your target is nauseated.
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
        if (utter.nSpellId == UTTER_BREATH_CLEANSING)
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
            	        GetEffectType(eFear) == EFFECT_TYPE_DAZED)
            	    {
            	        //Remove any fear effects and apply the VFX impact
            	        RemoveEffect(oTarget, eFear);
            	    }
            	    //Get the next effect on the target
            	    eFear = GetNextEffect(oTarget);
            	}
        	utter.eLink2 = EffectVisualEffect(VFX_IMP_REMOVE_CONDITION);
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
                	// These creatures cannot be nauseated
                	if (MyPRCGetRacialType(oTarget) != RACIAL_TYPE_UNDEAD && MyPRCGetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT && MyPRCGetRacialType(oTarget) != RACIAL_TYPE_ELEMENTAL && MyPRCGetRacialType(oTarget) != RACIAL_TYPE_OOZE)
                	{
                		// Nauseated: Can't Cast spells or Attack, can only move
						utter.eLink = EffectNausea(oTarget, utter.fDur);
					}
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
