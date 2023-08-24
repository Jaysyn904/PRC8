/*
   ----------------
   Preternatural Clarity

   true_utr_preclar
   ----------------

    4/8/06 by Stratovarius
*/ /** @file

    Preternatural Clarity

    Level: Evolving Mind 5
    Range: 60 feet
    Target: One Creature
    Duration: 1 Round (Normal) or 5 Rounds (Reverse)
    Spell Resistance: Yes
    Save: None (Normal) or Will Negates (Reverse)
    Metautterances: Extend

    Normal:  You speak and sharpen you ally's mind with an awareness of all that is and all that might be.
             Your grant your ally a +5 Attack Bonus, or a +5 Skill boost, or a +5 Saving throw boost.
    Reverse: At your command, the universe temporarily becomes incomprehensible to your target. 
             Your foe becomes confused.
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
        if (utter.nSpellId == UTTER_PRETERNATURAL_CLARITY_ATTACK)
        {
        	utter.fDur       = RoundsToSeconds(1);
        	// Used to Ignore SR in Speak Unto the Masses for friendly utterances.
        	utter.bIgnoreSR = TRUE;
        	// This utterance applies only to friends
        	utter.bFriend = TRUE;
        	// eLink is used for Duration Effects (Buff/Penalty to AC)
        	utter.eLink = EffectLinkEffects(EffectAttackIncrease(5), EffectVisualEffect(VFX_DUR_CROWN_OF_GLORY));
        	// Impact VFX 
        	utter.eLink2 = EffectVisualEffect(VFX_IMP_HEAD_ODD);
        }
        // The NORMAL effect of the Utterance goes here
        else if (utter.nSpellId == UTTER_PRETERNATURAL_CLARITY_SKILL)
        {
        	utter.fDur       = RoundsToSeconds(1);
        	// Used to Ignore SR in Speak Unto the Masses for friendly utterances.
        	utter.bIgnoreSR = TRUE;
        	// This utterance applies only to friends
        	utter.bFriend = TRUE;
        	// eLink is used for Duration Effects (Buff/Penalty to AC)
        	utter.eLink = EffectLinkEffects(EffectSkillIncrease(SKILL_ALL_SKILLS, 5), EffectVisualEffect(VFX_DUR_CROWN_OF_GLORY));
        	// Impact VFX 
        	utter.eLink2 = EffectVisualEffect(VFX_IMP_HEAD_ODD);
        }
        // The NORMAL effect of the Utterance goes here
        else if (utter.nSpellId == UTTER_PRETERNATURAL_CLARITY_SAVE)
        {
        	utter.fDur       = RoundsToSeconds(1);
        	// Used to Ignore SR in Speak Unto the Masses for friendly utterances.
        	utter.bIgnoreSR = TRUE;
        	// This utterance applies only to friends
        	utter.bFriend = TRUE;
        	// eLink is used for Duration Effects (Buff/Penalty to AC)
        	utter.eLink = EffectLinkEffects(EffectSavingThrowIncrease(SAVING_THROW_ALL, 5), EffectVisualEffect(VFX_DUR_CROWN_OF_GLORY));
        	// Impact VFX 
        	utter.eLink2 = EffectVisualEffect(VFX_IMP_HEAD_ODD);
        }        
        // The REVERSE effect of the Utterance goes here
        else // UTTER_PRETERNATURAL_CLARITY_R
        {
        	utter.fDur       = RoundsToSeconds(5);
        	// If the Spell Penetration fails, don't apply any effects
        	// Its done this way so the law of sequence is applied properly
        	nSRCheck = PRCDoResistSpell(oTrueSpeaker, oTarget, utter.nPen);
        	if (!nSRCheck)
        	{
        		// Saving throw
        		nSaveCheck = PRCMySavingThrow(utter.nSaveThrow, oTarget, utter.nSaveDC, utter.nSaveType, OBJECT_SELF);
        		if(!nSaveCheck)
                	{
                		// Confusion
				utter.eLink = EffectLinkEffects(PRCEffectConfused(), EffectVisualEffect(VFX_DUR_CHAOS_CLOAK));
				utter.eLink2 = EffectVisualEffect(VFX_IMP_FEAR_S);
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
        if (!nSRCheck) DoLawOfSequence(oTrueSpeaker, utter.nSpellId, utter.fDur);
    }// end if - Successful utterance    
}
