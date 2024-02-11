/*
   ----------------
   Word of Nurturing, Moderate
   true_utr_wrdntmd
   ----------------

   19/7/06 by Stratovarius
*/ /** @file

    Word of Nurturing, Moderate

    Level: Evolving Mind 3
    Range: 60 feet
    Target: One Creature
    Duration: 5 Rounds or 1 round
    Spell Resistance: Yes
    Save: None
    Metautterances: Extend, Empower

    Normal:  Your words soothe your ally, gradually restoring some of the damage he has sustained.
             Your ally gains regeneration +5.
    Reverse: Your words rip at your enemy, tearing at its flesh and bones.
             Your foe takes a 4d6 damage, and 4d6 damage the next round if you concentrate. Concentration involves doing nothing more strenous than moving.
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
    struct utterance utter = EvaluateUtterance(oTrueSpeaker, oTarget, (METAUTTERANCE_EXTEND | METAUTTERANCE_EMPOWER), LEXICON_EVOLVING_MIND);

    if(utter.bCanUtter)
    {
        // This is done so Speak Unto the Masses can read it out of the structure
        utter.nPen       = GetTrueSpeakPenetration(oTrueSpeaker);
        int nSRCheck;
        
        
        // The NORMAL effect of the Utterance goes here
        if (utter.nSpellId == UTTER_WORD_NURTURING_MODERATE)
        {
        	// This utterance applies only to friends
		utter.bFriend = TRUE;
		// Used to Ignore SR in Speak Unto the Masses for friendly utterances.
        	utter.bIgnoreSR = TRUE;
        	utter.fDur       = RoundsToSeconds(5);
        	// Regeneration
        	utter.eLink = EffectRegenerate(5, 6.0);
        	// Impact VFX 
        	utter.eLink2 = EffectVisualEffect(VFX_IMP_HEALING_G_MAG);
        }
        // The REVERSE effect of the Utterance goes here
        else // UTTER_WORD_NURTURING_MODERATE_R
        {
        	utter.fDur       = RoundsToSeconds(1);
        	
        	// If the Spell Penetration fails, don't apply any effects
        	nSRCheck = PRCDoResistSpell(oTrueSpeaker, oTarget, utter.nPen);
        	if (!nSRCheck)
        	{
       			// Skill Penalty
       			utter.eLink = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
       			int nDamage = d6(4);
			// Empower it
			if(utter.bEmpower) nDamage += (nDamage/2);
       			// Impact VFX 
        		utter.eLink2 = EffectLinkEffects(EffectVisualEffect(VFX_IMP_MAGVIO), EffectDamage(nDamage));
        		// This takes care of the concentration bit of the utterance
        		DelayCommand(6.0, DoWordOfNurturingReverse(oTrueSpeaker, oTarget, utter));
        	}
        }
        if(utter.bExtend) utter.fDur *= 2;
        // This stops a bug where it doesnt apply for the first round and so they only get 4 rounds of healing
        if (utter.nSpellId == UTTER_WORD_NURTURING_MODERATE) utter.fDur += 6.0;
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
