/*
    ----------------
    Transmute Weapon

    true_utr_tranwep
    ----------------

    12/8/06 by Stratovarius
*/ /** @file

    Transmute Weapon

    Level: Crafted Tool 4
    Range: 30 feet
    Target: One Weapon (Or Possessor)
    Duration: 5 Rounds
    Spell Resistance: No
    Metautterances: Extend

    Your words fundamentally alter the material of which a weapon is made, transforming it according to your whim.
    The target weapon ignores all non-epic (x/+5 or lower) DR.
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
    oTarget             = CraftedToolTarget(oTrueSpeaker, oTarget);
    struct utterance utter = EvaluateUtterance(oTrueSpeaker, oTarget, METAUTTERANCE_EXTEND, LEXICON_CRAFTED_TOOL);

    if(utter.bCanUtter)
    {
        // This is done so Speak Unto the Masses can read it out of the structure
        utter.fDur       = RoundsToSeconds(5);
        if(utter.bExtend) utter.fDur *= 2;
        // This utterance applies only to friends
	utter.bFriend = TRUE;
	// Used to Ignore SR in Speak Unto the Masses for friendly utterances.
        utter.bIgnoreSR = TRUE;

        // +5/-5 to break DR
        utter.ipIProp1 = ItemPropertyAttackBonus(5);
        IPSafeAddItemProperty(oTarget, utter.ipIProp1, utter.fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        // -5 here
	utter.ipIProp2 = ItemPropertyAttackPenalty(5);
        IPSafeAddItemProperty(oTarget, utter.ipIProp2, utter.fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);        
        // eLink2 is used for Impact Effects (Vis)
        utter.eLink2 = EffectVisualEffect(VFX_IMP_EPIC_GEM_SAPPHIRE_SMP);

        // Impact Effects
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, utter.eLink2, GetItemPossessor(oTarget));
        
        // Mark for the Law of Sequence. This only happens if the utterance succeeds, which is why its down here.
        DoLawOfSequence(oTrueSpeaker, utter.nSpellId, utter.fDur);
    }// end if - Successful utterance
}
