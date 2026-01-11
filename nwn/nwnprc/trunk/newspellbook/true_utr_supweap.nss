/*
    ----------------
    Suppress Weapon

    true_utr_supweap
    ----------------

    12/8/06 by Stratovarius
*/ /** @file

    Suppress Weapon

    Level: Crafted Tool 3
    Range: 30 feet
    Target: One Weapon with an Energy Special
    Duration: 5 Rounds
    Spell Resistance: Yes
    Metautterances: Extend

    You can suppress the energy properties of a single weapon.
    The targeted weapon loses any energy damage property.
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
        utter.nPen       = GetTrueSpeakPenetration(oTrueSpeaker);
        utter.fDur       = RoundsToSeconds(5);
        if(utter.bExtend) utter.fDur *= 2;

	int nSRCheck = PRCDoResistSpell(oTrueSpeaker, oTarget, utter.nPen);
	if (!nSRCheck)
        {  
        	itemproperty ip = GetFirstItemProperty(oTarget);
     		while(GetIsItemPropertyValid(ip))
     		{
        		int ipType = GetItemPropertyType(ip);
        		// Find a damage bonus
			if (ipType == ITEM_PROPERTY_DAMAGE_BONUS)
			{
			    // Dice
	                    int iTemp = GetItemPropertyCostTableValue(ip);
	                    // Damage Type
	                    int iDamageType = GetItemPropertySubType(ip);
	                     if (iDamageType == IP_CONST_DAMAGETYPE_ACID || iDamageType == IP_CONST_DAMAGETYPE_COLD || 
	                         iDamageType == IP_CONST_DAMAGETYPE_FIRE || iDamageType == IP_CONST_DAMAGETYPE_ELECTRICAL || 
	                         iDamageType == IP_CONST_DAMAGETYPE_SONIC || iDamageType == IP_CONST_DAMAGETYPE_DIVINE || 
	                         iDamageType == IP_CONST_DAMAGETYPE_NEGATIVE || iDamageType == IP_CONST_DAMAGETYPE_POSITIVE || 
	                         iDamageType == IP_CONST_DAMAGETYPE_MAGICAL)
			         {
			       		RemoveSpecificProperty(oTarget,ITEM_PROPERTY_DAMAGE_BONUS,iDamageType,iTemp,1);
			       		// eLink2 is used for Impact Effects (Vis)
        				utter.eLink2 = EffectVisualEffect(VFX_IMP_DISENTIGRATION_SMP);
			       		
					// Once you've removed the iprop, readd it later
               			  	DelayCommand(utter.fDur, AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(iDamageType, iTemp), oTarget));
               		         }
	                }
					
					ip = GetNextItemProperty(oTarget);

                }
    	}

        // Impact Effects
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, utter.eLink2, GetItemPossessor(oTarget));
        
        // Mark for the Law of Sequence. This only happens if the utterance succeeds, which is why its down here.
        if (!nSRCheck) DoLawOfSequence(oTrueSpeaker, utter.nSpellId, utter.fDur);
    }// end if - Successful utterance
}
