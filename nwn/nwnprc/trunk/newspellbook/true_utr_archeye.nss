/*
   ----------------
   Archer's Eye

   true_utr_archeye
   ----------------

   1/8/06 by Stratovarius
*/ /** @file

    Archer's Eye

    Level: Evolving Mind 2
    Range: 60 feet
    Target: One Creature
    Duration: 5 Rounds
    Spell Resistance: None
    Save: None
    Metautterances: Extend

    Normal:  With a few words of Truespeech, you allow your target to strike true with his ranged attacks.
             Your target gains Blindfight if they are using a ranged weapon.
    Reverse: Your utterance wards an ally from harm, preventing the arrows of your enemies from finding their mark.
             Your target gains DR 10/- against piercing, stopping 10 points per TrueSpeaker level, with a max of 100 damage.
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
    object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
    struct utterance utter = EvaluateUtterance(oTrueSpeaker, oTarget, METAUTTERANCE_EXTEND, LEXICON_EVOLVING_MIND);
        
    if(utter.bCanUtter)
    {
        utter.fDur       = RoundsToSeconds(5);
        if(utter.bExtend) utter.fDur *= 2;
        // This utterance applies only to friends
        utter.bFriend = TRUE;
        
        // The NORMAL effect of the Utterance goes here
        if (utter.nSpellId == UTTER_ARCHERS_EYE)
        {
        	if (GetWeaponRanged(oItem))
        	{
        		utter.ipIProp1 = PRCItemPropertyBonusFeat(IP_CONST_FEAT_BLINDFIGHT);
        		object oSkin = GetPCSkin(oTrueSpeaker);
        		IPSafeAddItemProperty(oSkin, utter.ipIProp1, utter.fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        		// Visuals 
        		utter.eLink = EffectVisualEffect(VFX_DUR_ULTRAVISION);
        	}
        	else
        	    FloatingTextStringOnCreature("Your target does not have a ranged weapon equipped. Utterance Failed.", oTrueSpeaker, FALSE);
        }
        // The REVERSE effect of the Utterance goes here
        else /* Effects of UTTER_ARCHERS_EYE_R would be here */
        {
        	// Damage Resistance 10 piercing, max of 100 total
		utter.eLink = EffectLinkEffects(EffectDamageResistance(DAMAGE_TYPE_PIERCING, 10, min((10 * utter.nTruespeakerLevel), 100)), EffectVisualEffect(VFX_DUR_PROTECTION_ARROWS));
        }
        // If either of these ApplyEffect isn't needed, delete it.
        // Duration Effects
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, utter.eLink, oTarget, utter.fDur, TRUE, utter.nSpellId, utter.nTruespeakerLevel);
        
        // Speak Unto the Masses. Swats an area with the effects of this utterance
        DoSpeakUntoTheMasses(oTrueSpeaker, oTarget, utter);
        // Mark for the Law of Sequence. This only happens if the utterance succeeds, which is why its down here.
        // The utterance isn't active if SR or Saves stop it
        // Make sure to delete one if not needed
        DoLawOfSequence(oTrueSpeaker, utter.nSpellId, utter.fDur);
    }// end if - Successful utterance
}