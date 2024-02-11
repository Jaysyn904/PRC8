/*
    ----------------
    Metamagic Catalyst

    true_utr_metacat
    ----------------

    17/8/06 by Stratovarius
*/ /** @file

    Metamagic Catalyst

    Level: Crafted Tool 5
    Range: Touch
    Target: One Scroll or Potion
    Duration: 2 Rounds
    Spell Resistance: No
    Metautterances: Extend

    Your touch enables a potion consumed or scroll read to be augmented with metamagic.
    You may Extend or Empower a scroll or potion.
    You may Maximize a scroll or potion, but this increases the Truespeech DC by 10.
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
        utter.fDur       = RoundsToSeconds(2);
        if(utter.bExtend) utter.fDur *= 2;
        
	itemproperty ipIP;
	int nipSpellID;
        ipIP = GetFirstItemProperty(oTarget);
        while(GetIsItemPropertyValid(ipIP))
        {
        	if(GetItemPropertyType(ipIP) == ITEM_PROPERTY_CAST_SPELL)
        	{
        		nipSpellID = GetItemPropertySubType(ipIP);
        		//convert that to a real ID
        		nipSpellID = StringToInt(Get2DACache("iprp_spells", "SpellIndex", nipSpellID));
        	}
        	ipIP = GetNextItemProperty(oTarget);
        }

        
        // The first effect of the Utterance goes here
        if (utter.nSpellId == UTTER_METAMAGIC_CATALYST_EMP)
        {
        	// Meta-Empower
        	utter.ipIProp1 = ItemPropertyCastSpellMetamagic(nipSpellID, METAMAGIC_EMPOWER);
        	IPSafeAddItemProperty(oTarget, utter.ipIProp1, utter.fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        	// eLink2 is used for Impact Effects (Damage)
        	utter.eLink2 = EffectVisualEffect(TOF_VFX_ALARM_MENTAL);
        }
        // The second effect of the Utterance goes here
        else if (utter.nSpellId == UTTER_METAMAGIC_CATALYST_EXT)
        {
        	// Meta-Extend
        	utter.ipIProp1 = ItemPropertyCastSpellMetamagic(nipSpellID, METAMAGIC_EXTEND);
        	IPSafeAddItemProperty(oTarget, utter.ipIProp1, utter.fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        	// eLink2 is used for Impact Effects (Damage)
        	utter.eLink2 = EffectVisualEffect(TOF_VFX_ALARM_MENTAL);
        }        
        else /* Effects of UTTER_METAMAGIC_CATALYST_MAX would be here */
        {
        	// Meta-Max
        	utter.ipIProp1 = ItemPropertyCastSpellMetamagic(nipSpellID, METAMAGIC_MAXIMIZE);
        	IPSafeAddItemProperty(oTarget, utter.ipIProp1, utter.fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        	// eLink2 is used for Impact Effects (Damage)
        	utter.eLink2 = EffectVisualEffect(TOF_VFX_ALARM_MENTAL);
        }
        // Impact Effects
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, utter.eLink2, oTarget);
        
        // Mark for the Law of Sequence. This only happens if the utterance succeeds, which is why its down here.
        DoLawOfSequence(oTrueSpeaker, utter.nSpellId, utter.fDur);
    }// end if - Successful utterance
}
