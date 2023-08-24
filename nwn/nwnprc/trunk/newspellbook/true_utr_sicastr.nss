/*
   ----------------
   Silent Caster
   true_utr_sicastr
   ----------------

   1/8/06 by Stratovarius
*/ /** @file

    Silent Caster

    Level: Evolving Mind 2
    Range: 60 feet
    Target: One Creature
    Duration: 1 Round
    Spell Resistance: Yes
    Save: None (Normal) or Will Negates (Reverse)
    Metautterances: Extend

    Normal:  Your ally can cast spells without making a sound.
             Your ally gains Automatic Silent Spell 1-3.
    Reverse: An enemy creature is unable to speak or make a peep, its vocal cords completely stilled
             Your target is silenced.
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
        utter.fDur       = RoundsToSeconds(1);
        if(utter.bExtend) utter.fDur *= 2;
        int nSRCheck;
        int nSaveCheck;
        
        // The NORMAL effect of the Utterance goes here
        if (utter.nSpellId == UTTER_SILENT_CASTER)
        {
        	// This utterance applies only to friends
	        utter.bFriend = TRUE;
	        // Used to Ignore SR in Speak Unto the Masses for friendly utterances.
        	utter.bIgnoreSR = TRUE;
       		utter.ipIProp1 = PRCItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_AUTO_SILENT_I);
       		utter.ipIProp2 = PRCItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_AUTO_SILENT_II);
       		utter.ipIProp3 = PRCItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_AUTO_SILENT_III);
       		object oSkin = GetPCSkin(oTrueSpeaker);
       		IPSafeAddItemProperty(oSkin, utter.ipIProp1, utter.fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
       		IPSafeAddItemProperty(oSkin, utter.ipIProp2, utter.fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
       		IPSafeAddItemProperty(oSkin, utter.ipIProp3, utter.fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
       		// Visuals 
       		utter.eLink = EffectVisualEffect(VFX_DUR_AURA_SILENCE);
       		utter.eLink2 = EffectVisualEffect(VFX_IMP_SILENCE);
       		// Make sure Law of Sequence is activated
        }
        // The REVERSE effect of the Utterance goes here
        else /* Effects of UTTER_SILENT_CASTER_R would be here */
        {
        	// If the Spell Penetration fails, don't apply any effects
        	nSRCheck = PRCDoResistSpell(oTrueSpeaker, oTarget, utter.nPen);
        	if (!nSRCheck)
        	{
        		// Saving throw
        		nSaveCheck = PRCMySavingThrow(utter.nSaveThrow, oTarget, utter.nSaveDC, utter.nSaveType, OBJECT_SELF);
        		if(!nSaveCheck)
                	{
                		// Concealment
				utter.eLink = EffectLinkEffects(EffectSilence(), EffectVisualEffect(VFX_DUR_AURA_SILENCE));
				utter.eLink2 = EffectVisualEffect(VFX_IMP_SILENCE);
			}
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
        if (!nSRCheck && !nSaveCheck) DoLawOfSequence(oTrueSpeaker, utter.nSpellId, utter.fDur);
    }// end if - Successful utterance
}