/*
   ----------------
   Caster Lens

   true_utr_castlns
   ----------------

   3/8/06 by Stratovarius
*/ /** @file

    Caster Lens

    Level: Evolving Mind 4
    Range: 60 feet
    Target: One Creature
    Duration: 3 Rounds
    Spell Resistance: Yes
    Save: None
    Metautterances: Extend

    Normal:  Your utterance creates an intangible lens that improves your target's potency and aptitude with magic.
             Your ally gains +2 Caster Level.
    Reverse: The reverse of this utterance impedes the flow of magical energy through your enemy, inhibiting its ability to cast spells.
             Your foe takes a -2 to Caster Level.
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
        utter.fDur       = RoundsToSeconds(3);
        int nSRCheck;
        if(utter.bExtend) utter.fDur *= 2;
        
        // The NORMAL effect of the Utterance goes here
        if (utter.nSpellId == UTTER_CASTER_LENS)
        {
        	// Used to Ignore SR in Speak Unto the Masses for friendly utterances.
        	utter.bIgnoreSR = TRUE;
        	// This utterance applies only to friends
        	utter.bFriend = TRUE;
        	// eLink is used for Duration Effects (Buff/Penalty to AC)
        	SetLocalInt(oTarget, "TrueCasterLens", 2);
        	utter.eLink = EffectVisualEffect(VFX_DUR_ENTROPIC_SHIELD);
        	// Impact VFX 
        	utter.eLink2 = EffectVisualEffect(VFX_IMP_HEAD_MIND);
        }
        // The REVERSE effect of the Utterance goes here
        else // UTTER_CASTER_LENS_R
        {
        	// If the Spell Penetration fails, don't apply any effects
        	nSRCheck = PRCDoResistSpell(oTrueSpeaker, oTarget, utter.nPen);
        	if (!nSRCheck)
        	{
       			// eLink is used for Duration Effects (Buff/Penalty to AC)
       			SetLocalInt(oTarget, "TrueCasterLens", -2);
       			utter.eLink = EffectVisualEffect(VFX_DUR_SHADOWS_ANTILIGHT);
       			// Impact VFX 
        		utter.eLink2 = EffectVisualEffect(VFX_IMP_HEAD_ODD);
        	}
        }
        // Duration Effects
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, utter.eLink, oTarget, utter.fDur, TRUE, utter.nSpellId, utter.nTruespeakerLevel);
        // Impact Effects
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, utter.eLink2, oTarget);
        // Clean Up
        DelayCommand(utter.fDur, DeleteLocalInt(oTarget, "TrueCasterLens"));
        
        // Speak Unto the Masses. Swats an area with the effects of this utterance
        DoSpeakUntoTheMasses(oTrueSpeaker, oTarget, utter);
        // Mark for the Law of Sequence. This only happens if the utterance succeeds, which is why its down here.
        // The utterance isn't active if SR stops it
        if (!nSRCheck) DoLawOfSequence(oTrueSpeaker, utter.nSpellId, utter.fDur);
    }// end if - Successful utterance    
}
