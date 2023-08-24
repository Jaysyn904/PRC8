/*
   ----------------
   Inertial Surge

   true_utr_inrtsrg
   ----------------

   19/7/06 by Stratovarius
*/ /** @file

    Inertial Surge

    Level: Evolving Mind 1
    Range: 60 feet
    Target: One Creature
    Duration: 1 round
    Spell Resistance: Yes
    Save: None
    Metautterances: Extend

    Normal: Your words free the target from many impediments, allowing her to slip from any constraints.
            The target gains freedom of movement for one round.
    Reverse: Your words cause black tentacles to grow from the ground and clutch at the feet of your enemy, preventing them from moving anywhere.
             For one round the target is unable to move, but can take other actions normally.
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
        utter.nSaveDC    = GetTrueSpeakerDC(oTrueSpeaker);
        utter.fDur       = RoundsToSeconds(1);
        int nSRCheck;
        if(utter.bExtend) utter.fDur *= 2;
        
        // The NORMAL effect of the Utterance goes here
        if (utter.nSpellId == UTTER_INERTIAL_SURGE)
        {
        	// Used to Ignore SR in Speak Unto the Masses for friendly utterances.
		utter.bIgnoreSR = TRUE;
		// This utterance applies only to friends
        	utter.bFriend = TRUE;
        	// Freedom of Movement
    		effect eParal = EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
    		effect eEntangle = EffectImmunity(IMMUNITY_TYPE_ENTANGLE);
    		effect eSlow = EffectImmunity(IMMUNITY_TYPE_SLOW);
    		effect eMove = EffectImmunity(IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE);
    		effect eVis = EffectVisualEffect(VFX_DUR_FREEDOM_OF_MOVEMENT);
    		effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    		//Link effects
    		utter.eLink = EffectLinkEffects(eParal, eEntangle);
    		utter.eLink = EffectLinkEffects(utter.eLink, eSlow);
    		utter.eLink = EffectLinkEffects(utter.eLink, eVis);
    		utter.eLink = EffectLinkEffects(utter.eLink, eDur);
    		utter.eLink = EffectLinkEffects(utter.eLink, eMove);        
        }
        // The REVERSE effect of the Utterance goes here
        else /* Effects of UTTER_INERTIAL_SURGE_R go here */
        {
        	// If the Spell Penetration fails, don't apply any effects
        	nSRCheck = PRCDoResistSpell(oTrueSpeaker, oTarget, utter.nPen);
        	if (!nSRCheck)
        	{
       			// Hold the Target
       			utter.eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_ENTANGLE), EffectCutsceneImmobilize());
        	}
        }
        // Duration Effects
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, utter.eLink, oTarget, utter.fDur, TRUE, utter.nSpellId, utter.nTruespeakerLevel);
        
        // Speak Unto the Masses. Swats an area with the effects of this utterance
        DoSpeakUntoTheMasses(oTrueSpeaker, oTarget, utter);
        // Mark for the Law of Sequence. This only happens if the utterance succeeds, which is why its down here.
        // The utterance isn't active if SR or Saves stop it
        if (!nSRCheck) DoLawOfSequence(oTrueSpeaker, utter.nSpellId, utter.fDur);
    }// end if - Successful utterance
}
