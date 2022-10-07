#include "psi_inc_psifunc"

void main()
{
    object oManifester = OBJECT_SELF;
    object oWeaponR = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oManifester);
    object oWeaponL = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oManifester);
    
    if (!GetLocalInt(oManifester, "ShadowMindStab"))
    {
    	SetLocalInt(oManifester, "ShadowMindStab", TRUE);
    	FloatingTextStringOnCreature("Mind Stab Activated", oManifester, FALSE);    	
    	IPSafeAddItemProperty(oWeaponR, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    	IPSafeAddItemProperty(oWeaponL, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); 	
    }
    else
    {
    	// Clean up
    	DeleteLocalInt(oManifester, "ShadowMindStab");
    	FloatingTextStringOnCreature("Mind Stab Deactivated", oManifester, FALSE);
    	RemoveSpecificProperty(oWeaponR, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", 1, DURATION_TYPE_TEMPORARY);
    	RemoveSpecificProperty(oWeaponL, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", 1, DURATION_TYPE_TEMPORARY);
    }	
}