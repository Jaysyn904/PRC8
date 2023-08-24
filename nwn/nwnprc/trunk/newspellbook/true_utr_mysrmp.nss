/*
   ----------------
   Mystic Rampart

   true_utr_mysrmp
   ----------------

    4/8/06 by Stratovarius
*/ /** @file

    Mystic Rampart

    Level: Evolving Mind 6
    Range: 60 feet
    Target: One Creature
    Duration: 5 Rounds
    Spell Resistance: Yes
    Save: None
    Metautterances: Extend

    Normal:  With a complex string of syllables, an intagible tower superimposes itself over your ally, greatly enhancing his ability to protect himself.
             Your ally gains 5/- Damage Resistance, and +5 saves.
    Reverse: You speak and your target becomes vulnerable.
             Your target takes a -5 AC and Saving Throw Penalty.
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
        
        // The NORMAL effect of the Utterance goes here
        if (utter.nSpellId == UTTER_MYSTIC_RAMPART)
        {
        	// Used to Ignore SR in Speak Unto the Masses for friendly utterances.
        	utter.bIgnoreSR = TRUE;
        	// This utterance applies only to friends
        	utter.bFriend = TRUE;
        	// eLink is used for Duration Effects (Buff/Penalty to AC)
        	utter.eLink = EffectLinkEffects(EffectSavingThrowIncrease(SAVING_THROW_ALL, 5), EffectVisualEffect(PSI_DUR_INTELLECT_FORTRESS));
        	utter.eLink = EffectLinkEffects(utter.eLink, EffectDamageResistance(DAMAGE_TYPE_SLASHING,    5));
		utter.eLink = EffectLinkEffects(utter.eLink, EffectDamageResistance(DAMAGE_TYPE_PIERCING,    5));
                utter.eLink = EffectLinkEffects(utter.eLink, EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING, 5));
        	// Impact VFX 
        	utter.eLink2 = EffectVisualEffect(VFX_IMP_DRAGONBLAST);
        }
        // The REVERSE effect of the Utterance goes here
        else // UTTER_MYSTIC_RAMPART_R
        {
        	// If the Spell Penetration fails, don't apply any effects
        	nSRCheck = PRCDoResistSpell(oTrueSpeaker, oTarget, utter.nPen);
        	if (!nSRCheck)
        	{
       			// eLink is used for Duration Effects (Buff/Penalty to AC)
			utter.eLink = EffectLinkEffects(EffectACDecrease(5), EffectVisualEffect(VFX_DUR_ARMOR_OF_DARKNESS));
			utter.eLink = EffectLinkEffects(utter.eLink, EffectSavingThrowDecrease(SAVING_THROW_ALL, 5));
       			// Impact VFX 
        		utter.eLink2 = EffectVisualEffect(VFX_IMP_DIMENSIONLOCK);
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
