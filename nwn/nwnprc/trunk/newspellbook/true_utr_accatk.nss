/*
   ----------------
   Accelerated Attack

   true_utr_accatk
   ----------------

   2/8/06 by Stratovarius
*/ /** @file

    Perceive the Unseen

    Level: Evolving Mind 3
    Range: 60 feet
    Target: One Creature
    Duration: 1 Rounds
    Spell Resistance: None
    Save: None
    Metautterances: Extend

    Normal:  Your utterance allows your target to move quickly through the crowded battlefield, striking and darting away
             Your target gains Spring Attack.
    Reverse: A spellcaster you target gains the ability to cast a spell quickly while moving.
             Your target spellcaster gains a 20' speed boost.
*/

#include "true_inc_trufunc"
#include "true_utterhook"
#include "psi_inc_psifunc"

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
        utter.fDur       = RoundsToSeconds(1);
        if(utter.bExtend) utter.fDur *= 2;
        // This utterance applies only to friends
        utter.bFriend = TRUE;
        // Used to Ignore SR in Speak Unto the Masses for friendly utterances.
        utter.bIgnoreSR = TRUE;
        
        // The NORMAL effect of the Utterance goes here
        if (utter.nSpellId == UTTER_ACCELERATED_ATTACK)
        {
       		utter.ipIProp1 = PRCItemPropertyBonusFeat(IP_CONST_FEAT_SPRINGATTACK);
       		object oSkin = GetPCSkin(oTrueSpeaker);
       		IPSafeAddItemProperty(oSkin, utter.ipIProp1, utter.fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
       		// Visuals 
       		utter.eLink = EffectVisualEffect(VFX_DUR_SMOKE);
       		utter.eLink2 = EffectVisualEffect(VFX_IMP_HASTE);
        }
        // The REVERSE effect of the Utterance goes here
        else /* Effects of UTTER_ACCELERATED_ATTACK_R would be here */
        {
        	// See if the target is a caster
        	int nArc = GetLevelByTypeArcane(oTarget);
        	int nDiv = GetLevelByTypeDivine(oTarget);
        	int nPsi = GetHighestManifesterLevel(oTarget);
        	if (nPsi > 0 || nDiv > 0 || nArc > 0)
        	{
        		// Movement boost
		       	utter.eLink = EffectMovementSpeedIncrease(66);
		       	// Impact VFX 
			utter.eLink2 = EffectVisualEffect(VFX_IMP_HASTE);
		}
        }
        // If either of these ApplyEffect isn't needed, delete it.
        // Duration Effects
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, utter.eLink, oTarget, utter.fDur, TRUE, utter.nSpellId, utter.nTruespeakerLevel);
        // Impact Effects
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, utter.eLink2, oTarget);
        
        // Speak Unto the Masses. Swats an area with the effects of this utterance
        DoSpeakUntoTheMasses(oTrueSpeaker, oTarget, utter);
        // Mark for the Law of Sequence. This only happens if the utterance succeeds, which is why its down here.
        // The utterance isn't active if SR or Saves stop it
        // Make sure to delete one if not needed
        DoLawOfSequence(oTrueSpeaker, utter.nSpellId, utter.fDur);
    }// end if - Successful utterance
}