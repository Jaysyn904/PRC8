/*
05/03/21 by Stratovarius

Visage of the Dead: Mindless undead believe you to be one of them and do not attack you except
in self-defense, or when ordered to do so by their creator.

OnEnter
*/

#include "bnd_inc_bndfunc"

void main()
{
    //Declare major variables
    object oBinder = OBJECT_SELF;
    //FloatingTextStringOnCreature(GetName(oBinder)+" created this AoE", GetFirstPC());
	object oTarget = GetLocalObject(oBinder, "TenebrousCharm");
	//FloatingTextStringOnCreature(GetName(oTarget)+" is the target", GetFirstPC());
	
	object oItem = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oTarget);
	int nRemove = FALSE;
    itemproperty ip = GetFirstItemProperty(oItem);
    while(GetIsItemPropertyValid(ip))
    {
    	if (GetItemPropertyType(ip) == ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS && GetItemPropertySubType(ip) == IP_CONST_IMMUNITYMISC_MINDSPELLS)
    	{
    		RemoveItemProperty(oItem, ip);
    		nRemove = TRUE;
    	}	
    	if (GetItemPropertyType(ip) == ITEM_PROPERTY_MIND_BLANK)
    	{
    		RemoveItemProperty(oItem, ip);
    		nRemove = TRUE;
    	}
        	
        ip = GetNextItemProperty(oItem);
    }	
	
    AssignCommand(oTarget, ClearAllActions(TRUE));
    effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_MIND_AFFECTING_POSITIVE), EffectCharmed());
    DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oTarget, HoursToSeconds(24)));   
    if (nRemove) DelayCommand(1.0, AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_MINDSPELLS), oItem));
}
