/*
    ----------------
    Remove Item

    true_utr_rmvitm
    ----------------

    12/8/06 by Stratovarius
*/ /** @file

    Remove Item

    Level: Crafted Tool 3
    Range: 30 feet
    Target: One Item (Or Possessor)
    Duration: 1 Round
    Spell Resistance: Yes
    Metautterances: Extend

    Your words of Truespeech remove an item from your target's possession
    The targeted item is removed from the target's possession for one round.
*/

#include "true_inc_trufunc"
#include "true_utterhook"
//#include "prc_alterations"

void RestoreItem(object oTarget)
{
	CopyItem(oTarget, GetItemPossessor(oTarget), TRUE);
}

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
    oTarget             = CraftedToolTarget(oTrueSpeaker, oTarget);
    struct utterance utter = EvaluateUtterance(oTrueSpeaker, oTarget, METAUTTERANCE_EXTEND, LEXICON_CRAFTED_TOOL);

    if(utter.bCanUtter)
    {
        // This is done so Speak Unto the Masses can read it out of the structure
        utter.nPen       = GetTrueSpeakPenetration(oTrueSpeaker);
        utter.fDur       = RoundsToSeconds(1);
        if(utter.bExtend) utter.fDur *= 2;

	int nSRCheck = PRCDoResistSpell(oTrueSpeaker, oTarget, utter.nPen);
	if (!nSRCheck)
        {
        	// Make sure they get the item back
        	// Done this way so DelayCommand accepts it
    		DelayCommand(utter.fDur, RestoreItem(oTarget));
    		// Then remove it
    		DestroyObject(oTarget);
    		utter.eLink2 = EffectVisualEffect(VFX_FNF_RUSTING_GRASP);
    	}

        // Impact Effects
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, utter.eLink2, GetItemPossessor(oTarget));
        
        // Mark for the Law of Sequence. This only happens if the utterance succeeds, which is why its down here.
        if (!nSRCheck) DoLawOfSequence(oTrueSpeaker, utter.nSpellId, utter.fDur);
    }// end if - Successful utterance
}
