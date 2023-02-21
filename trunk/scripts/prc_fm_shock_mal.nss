//::///////////////////////////////////////////////
//:: Forest Master: Shocking Great Mallet
//:: prc_fm_shock_mal.nss
//:://////////////////////////////////////////////
/*
Beginning at 2nd level, a forest master begins to awaken magical abilities 
within the wood and metal that make up his maul. Any maul used by a forest 
master is treated as if it were a +2 maul with either the frost or shock 
property (the forest master decides each round whether the weapon’s extra damage 
is cold or electricity). If the weapon has additional abilities (such as 
defending), these abilities still apply, and if the weapon has an enhancement 
bonus better than +2 the higher of the two bonuses is used. The maul does not 
gain these abilities if it is not wielded by the forest master.  At 6th-level, 
the forest master’s maul acts as a +2 icy burst or +2 shocking burst weapon, 
with the forest master deciding each round what effect the weapon has.  At 9th 
level, the forest master’s maul acts as a +3 mighty cleaving weapon in addition 
to its other properties (including its icy burst or shocking burst ability).
*/
//:://////////////////////////////////////////////
//:: Created By: Jaysyn
//:: Created On: 20230106
//:://////////////////////////////////////////////

#include "prc_alterations"

void main()
{
//:: Declare major variables
    object oPC 		= OBJECT_SELF;	
	
	int iFMLevel	= GetLevelByClass(CLASS_TYPE_FORESTMASTER, oPC);
	
	itemproperty ipIP;
	
//:: Find a maul
    object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    int bHasMaul = (GetBaseItemType(oItem) == BASE_ITEM_MAUL);

//:: Need a maul
    if(!bHasMaul)
    {
        FloatingTextStringOnCreature(GetStringByStrRef(16548+0x01000000), oPC, FALSE);
    }

//:: Remove the Cleave or Great Cleave bonus feat from the maul being unequipped
	IPRemoveMatchingItemProperties(oItem, ITEM_PROPERTY_BONUS_FEAT, DURATION_TYPE_TEMPORARY, IP_CONST_FEAT_GREAT_CLEAVE);				
	IPRemoveMatchingItemProperties(oItem, ITEM_PROPERTY_BONUS_FEAT, DURATION_TYPE_TEMPORARY, IP_CONST_FEAT_CLEAVE);			
		
//:: Remove Great Mallet damage bonuses from maul being unequipped
	IPRemoveMatchingItemProperties(oItem, ITEM_PROPERTY_DAMAGE_BONUS, DURATION_TYPE_TEMPORARY, IP_CONST_DAMAGETYPE_ELECTRICAL);
	IPRemoveMatchingItemProperties(oItem, ITEM_PROPERTY_DAMAGE_BONUS, DURATION_TYPE_TEMPORARY, IP_CONST_DAMAGETYPE_COLD);
	IPRemoveMatchingItemProperties(oItem, ITEM_PROPERTY_ENHANCEMENT_BONUS, DURATION_TYPE_TEMPORARY);
			
//:: Setup damage bonuses
	if (iFMLevel >= 9)
	{
		if (GetHasFeat(FEAT_GREAT_CLEAVE,oPC))
		{
			ipIP = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGEBONUS_1d8);
			IPSafeAddItemProperty(oItem, ipIP, 999999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
			
			ipIP = ItemPropertyEnhancementBonus(3);
			IPSafeAddItemProperty(oItem, ipIP, 999999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);	
		}
			
		else if (GetHasFeat(FEAT_CLEAVE, oPC))
		{
			ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_GREAT_CLEAVE);
			IPSafeAddItemProperty(oItem, ipIP, 999999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
			
			ipIP = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGEBONUS_1d8);
			IPSafeAddItemProperty(oItem, ipIP, 999999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
			
			ipIP = ItemPropertyEnhancementBonus(3);
			IPSafeAddItemProperty(oItem, ipIP, 999999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);			
					
		}
		else
		{
			ipIP = PRCItemPropertyBonusFeat(IP_CONST_FEAT_CLEAVE);
			IPSafeAddItemProperty(oItem, ipIP, 999999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
			
			ipIP = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGEBONUS_1d8);
			IPSafeAddItemProperty(oItem, ipIP, 999999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
			
			ipIP = ItemPropertyEnhancementBonus(3);
			IPSafeAddItemProperty(oItem, ipIP, 999999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);			
		}

	}
	else if (iFMLevel < 9 && iFMLevel > 5)
	{
			ipIP = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGEBONUS_1d8);
			IPSafeAddItemProperty(oItem, ipIP, 999999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
			
			ipIP = ItemPropertyEnhancementBonus(2);
			IPSafeAddItemProperty(oItem, ipIP, 999999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);	
	}
	else
	{
			ipIP = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGEBONUS_1d6);
			IPSafeAddItemProperty(oItem, ipIP, 999999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
			
			ipIP = ItemPropertyEnhancementBonus(2);
			IPSafeAddItemProperty(oItem, ipIP, 999999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);			
	}

}