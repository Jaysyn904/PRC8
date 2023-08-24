/*
03/02/21 by Stratovarius

Aym, Queen Avarice
  
Once a monarch of dwarves, Aym allowed her greed to bring an end to her empire. As a vestige, she gives her 
host the ability to wear armor without impedance, to set creatures alight with a touch, to resist the effects of fire, and to scatter objects with heavy blows.

Vestige Level: 1st
Binding DC: 15
Special Requirement: None

Granted Abilities: 
Aym grants you powers that reflect her dwarven heritage and the ruin she brought to her kingdom.

Dwarven Step: You can move at normal speed (without the usual reduction) while wearing medium or heavy armor.

Halo of Fire: At will, you can shroud yourself in a wreath of flame. Any opponent that strikes you in melee takes 
1d6 points of fire damage. You can also deal 1d6 points of fire damage with each melee touch attack you make.

Improved Disarm: You gain the benefit of the Improved Disarm feat.

Medium Armor Proficiency: You are proficient with medium armor.

Resistance to Fire: You have resistance to fire 10.

Ruinous Attack: If your effective binder level is at least 10th, your melee attacks are treated as +5 for the purpose of overcoming damage reduction.
*/

#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = PRCGetSpellTargetObject(); 

    effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_PERM_ELEMENTAL_SAVANT_FIRE), EffectPact(oBinder));
   
    // We get this with the Practiced Binder feat
    if (GetLevelByClass(CLASS_TYPE_BINDER, oBinder) || GetHasFeat(FEAT_PRACTICED_BINDER, oBinder))
    {
           if (!GetIsVestigeExploited(oBinder, VESTIGE_AYM_RESIST_FIRE)) eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_FIRE, 10));
    }	
	
    // Binders only down here
    if (GetLevelByClass(CLASS_TYPE_BINDER, oBinder)) 
    {
    	object oItem;
    	if (!GetIsVestigeExploited(oBinder, VESTIGE_AYM_MEDIUM_ARMOR)) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_ARMOR_PROF_MEDIUM), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    	if (!GetIsVestigeExploited(oBinder, VESTIGE_AYM_IMP_DISARM)) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_PRC_IMPROVED_DISARM), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    	if (!GetIsVestigeExploited(oBinder, VESTIGE_AYM_HALO_FIRE)) 
    	{
    		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_AYM_HALO), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    		// Add eventhook to the armor
    		oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, oBinder);
    		IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    		AddEventScript(oItem, EVENT_ITEM_ONHIT, "bnd_events", TRUE, FALSE);        	
    	}	
		if (!GetIsVestigeExploited(oBinder, VESTIGE_AYM_RUINOUS_ATTACK))
		{
    		oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oBinder);
        	if(IPGetIsMeleeWeapon(oItem) && GetBinderLevel(oBinder, VESTIGE_AYM) >= 10)
        	{         
   				IPSafeAddItemProperty(oItem, ItemPropertyAttackBonus(5), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);        	
   				IPSafeAddItemProperty(oItem, ItemPropertyAttackPenalty(5), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);        	
       		}    	
    		oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oBinder);
        	if(IPGetIsMeleeWeapon(oItem) && GetBinderLevel(oBinder, VESTIGE_AYM) >= 10)
        	{         
   				IPSafeAddItemProperty(oItem, ItemPropertyAttackBonus(5), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);        	
   				IPSafeAddItemProperty(oItem, ItemPropertyAttackPenalty(5), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);        	
       		}     	
       	}	
    }	
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oBinder, HoursToSeconds(24));      
}