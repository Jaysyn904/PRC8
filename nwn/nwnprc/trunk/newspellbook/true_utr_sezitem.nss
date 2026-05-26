/*
    ----------------
    Seize Item

    true_utr_sezitem
    ----------------

    17/8/06 by Stratovarius
*/ /** @file

    Seize Item

    Level: Crafted Tool 5
    Range: 30 feet
    Target: One Object
    Duration: Instantaneous
    Spell Resistance: Yes
    Metautterances: None

    You speak a word to make an object your own, forcing it out of the hands of its owner, if necessary.
    This utterance brings an object within range to your hand. If it is possessed by another creature, 
    you must make a disarm attempt to gain the item.
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
    struct utterance utter = EvaluateUtterance(oTrueSpeaker, oTarget, METAUTTERANCE_NONE, LEXICON_CRAFTED_TOOL);

    if(utter.bCanUtter)
    {
        // This is done so Speak Unto the Masses can read it out of the structure
        utter.nPen       = GetTrueSpeakPenetration(oTrueSpeaker);
        int nSRCheck     = PRCDoResistSpell(oTrueSpeaker, GetItemPossessor(oTarget), utter.nPen);
        
        // If there is no possessor
        if (GetItemPossessor(oTarget) == OBJECT_INVALID)
        {
        	// Copy it
                CopyItem(oTarget, oTrueSpeaker, FALSE);
                MyDestroyObject(oTarget); // Make sure the item does get destroyed
		}
		else if (!nSRCheck) // There is a possessor, so roll SR
        {  
        	int nDisarmDC = GetLevelByClass(CLASS_TYPE_TRUENAMER, oTrueSpeaker) + GetAbilityModifier(ABILITY_INTELLIGENCE, oTrueSpeaker) + d20();
        	int nOppose = GetAttackBonus(oTrueSpeaker, GetItemPossessor(oTarget), oTarget) + d20();
        	
        	if (nDisarmDC >= nOppose && GetIsCreatureDisarmable(GetItemPossessor(oTarget)) && !GetPRCSwitch(PRC_PNP_DISARM))
        	{
        		// Copy it
		        CopyItem(oTarget, oTrueSpeaker, FALSE);
                MyDestroyObject(oTarget); // Make sure the item does get destroyed
        	}
    	}

        // Impact Effects
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_BIGBYS_FORCEFUL_HAND), GetLocation(oTarget));
    }// end if - Successful utterance
}
