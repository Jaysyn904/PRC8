/*
    ----------------
    Fortify Armour

    true_utr_fortify
    ----------------

    5/8/06 by Stratovarius
*/ /** @file

    Fortify Armour

    Level: Crafted Tool 1
    Range: 30 feet
    Target: One Suit of Armour (Or Possessor)
    Duration: 5 Rounds
    Spell Resistance: No
    Metautterances: Extend

    A suit of armour covers its wearer's vital areas more effectively, providing better protection against attacks.
    Sneak: Makes the target armour grant immunity to sneak attacks.
    Critical Hits: Makes the target armour grant immunity to critical hits, but increases the Truespeech DC by 10.
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
        
        // The NORMAL effect of the Utterance goes here
        if (utter.nSpellId == UTTER_FORTIFY_ARMOUR_SNEAK /* Example Utterance */)
        {
        	// Immunity to Sneak attack
        	utter.ipIProp1 = ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_BACKSTAB);
        	IPSafeAddItemProperty(oTarget, utter.ipIProp1, utter.fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        	// eLink2 is used for Impact Effects (Damage)
        	utter.eLink2 = EffectVisualEffect(VFX_FNF_MAGIC_VESTAMENT);
        }
        // The REVERSE effect of the Utterance goes here
        else /* Effects of UTTER_FORTIFY_ARMOUR_CRIT_r would be here */
        {
        	// Immunity to Sneak attack
        	utter.ipIProp1 = ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_CRITICAL_HITS);
        	IPSafeAddItemProperty(oTarget, utter.ipIProp1, utter.fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        	// eLink2 is used for Impact Effects (Damage)
        	utter.eLink2 = EffectVisualEffect(VFX_FNF_MAGIC_VESTAMENT);
        }
        // Impact Effects
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, utter.eLink2, oTarget);
        
        // Mark for the Law of Sequence. This only happens if the utterance succeeds, which is why its down here.
        DoLawOfSequence(oTrueSpeaker, utter.nSpellId, utter.fDur);
    }// end if - Successful utterance
}
