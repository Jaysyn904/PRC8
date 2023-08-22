/*
   ----------------
   Strike of Might

   true_utr_strkmi
   ----------------

   1/8/06 by Stratovarius
*/ /** @file

    Strike of Might
    
    Level: Evolving Mind 2
    Range: 60 feet
    Target: One Creature
    Duration: 1 Round
    Spell Resistance: No
    Save: None
    Metautterances: Extend

    Normal:  You tap into an ally's damage potential, augmenting his combat abilities substantially
             Your ally gains +10 damage on his next strike
    Reverse: You briefly enfeeble an enemy, causing its swing to slow and deal less damage
             Your target deals 5 less damage on his next attack.
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
    struct utterance utter = EvaluateUtterance(oTrueSpeaker, oTarget, METAUTTERANCE_NONE, LEXICON_EVOLVING_MIND);

    if(utter.bCanUtter)
    {
    	// An attempt to apply it to only one attack
    	int nAttacks = GetMainHandAttacks(oTarget) + GetOffHandAttacks(oTarget);
        utter.fDur = 6.0 / nAttacks;
        utter.nPen = GetTrueSpeakPenetration(oTrueSpeaker);
        int nSRCheck;
        
        // The NORMAL effect of the Utterance goes here
        if (utter.nSpellId == UTTER_STRIKE_MIGHT)
        {
        	// Used to Ignore SR in Speak Unto the Masses for friendly utterances.
		utter.bIgnoreSR = TRUE;
		// This utterance applies only to friends
        	utter.bFriend = TRUE;
        	// Damage boost
        	utter.eLink = EffectDamageIncrease(DAMAGE_BONUS_10);
        	// Impact VFX 
		utter.eLink2 = EffectVisualEffect(VFX_IMP_DIVINE_STRIKE_HOLY);
        }
        // The REVERSE effect of the Utterance goes here
        else // UTTER_STRIKE_MIGHT_R
        {
		// If the Spell Penetration fails, don't apply any effects
		nSRCheck = PRCDoResistSpell(oTrueSpeaker, oTarget, utter.nPen);
		if (!nSRCheck)
		{
			// Damage Decrease
			object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
			int nDamage = GetWeaponDamageType(oItem);
			utter.eLink = EffectDamageDecrease(5, nDamage);
			// Impact VFX 
			utter.eLink2 = EffectVisualEffect(VFX_IMP_DOOM);
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
