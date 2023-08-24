/*
07/03/21 by Barmlot

Knight of the Sacred Seal Aligned strike

Aligned Strike (+3 to all weapons to overcome DR)

*/

#include "bnd_inc_bndfunc"
#include "prc_inc_fork"

void main()
{
	object oBinder = OBJECT_SELF;	
	object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oBinder);
	
	//Aligned Strike (all weapons treated as +3 to overcome DR)
   	int nBonus = 3;
   	IPSafeAddItemProperty(oItem, ItemPropertyAttackBonus(nBonus), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);        	
   	IPSafeAddItemProperty(oItem, ItemPropertyAttackPenalty(nBonus), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);        	
	oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oBinder);
	if (GetIsWeapon(oItem))
	{
   		IPSafeAddItemProperty(oItem, ItemPropertyAttackBonus(nBonus), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);        	
   		IPSafeAddItemProperty(oItem, ItemPropertyAttackPenalty(nBonus), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);        		
	}
}