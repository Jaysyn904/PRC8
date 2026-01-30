//:://////////////////////////////////////////////
//:	ft_tch_gold_ice.nss
/*
	Touch of Golden Ice
	(Book of Exalted Deeds, p. 47)

	[Exalted]

	Your touch is poisonous to evil creatures.
	Prerequisite: CON 13
	
	Benefit: Any evil creature you touch with your 
	bare hand, fist, or natural weapon is ravaged 
	by golden ice (see Ravages and Afflictions in 
	Chapter 3: Exalted Equipment for effects).
	
	This handles the onHit events.

*/
//:
//:://////////////////////////////////////////////
//::
//:: Created by: Jaysyn
//:: Created on: 2026-01-30 08:21:32
//::
//:://////////////////////////////////////////////

#include "prc_inc_function"  
#include "prc_inc_unarmed"  
#include "prc_inc_onhit"  
#include "prc_inc_combat"  
#include "inc_ravage"  
  
void main()  
{  
    int nEvent = GetRunningEvent();  
    if(DEBUG) DoDebug("ft_tch_gold_ice running, event: " + IntToString(nEvent));  
  
    // Get the PC. This is event-dependent  
    object oPC;  
    switch(nEvent)  
    {  
        case EVENT_ITEM_ONHIT:          oPC = OBJECT_SELF;               break;  
        case EVENT_ONPLAYEREQUIPITEM:   oPC = GetItemLastEquippedBy();   break;  
        case EVENT_ONPLAYERUNEQUIPITEM: oPC = GetItemLastUnequippedBy(); break;  
        default:  
            oPC = OBJECT_SELF;  
    }  
  
    // Check if character has the feat and meets requirements  
    if(!GetHasFeat(FEAT_RAVAGEGOLDENICE, oPC) ||   
       GetAlignmentGoodEvil(oPC) != ALIGNMENT_GOOD)  
        return;  
  
    // We aren't being called from any event, instead from EvalPRCFeats  
    if(nEvent == FALSE)  
    {  
        // Hook in the events  
        if(DEBUG) DoDebug("ft_tch_gold_ice: Adding eventhooks");  
        AddEventScript(oPC, EVENT_ONPLAYEREQUIPITEM,   "ft_tch_gold_ice", TRUE, FALSE);  
        AddEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM, "ft_tch_gold_ice", TRUE, FALSE); 
		
		AddEventScript(oPC, CALLBACKHOOK_UNARMED, "ft_tch_gold_ice", TRUE, FALSE);		
    }  
	// We're being called from the OnHit eventhook    
	else if(nEvent == EVENT_ITEM_ONHIT)    
	{    
		object oTarget = PRCGetSpellTargetObject();    
			
		if(DEBUG) DoDebug("ft_tch_gold_ice: OnHit:\n"    
						+ "oPC = " + DebugObject2Str(oPC) + "\n"    
						+ "oTarget = " + DebugObject2Str(oTarget) + "\n");    
	  
		// Check constitution prerequisite (Con 13)    
		if(GetAbilityScore(oPC, ABILITY_CONSTITUTION, TRUE) < 13)    
			return;    
				
		// Only affect evil targets    
		if(GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL)    
		{    
			effect eRavage = EffectPoison(POISON_RAVAGE_GOLDEN_ICE);    
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eRavage, oTarget);    
				
			effect eVFX = EffectVisualEffect(VFX_IMP_PULSE_NATURE);    
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oTarget);    
		}    
	}
	// We are called from the Unarmed Callback eventhook 
	else if(nEvent == CALLBACKHOOK_UNARMED)  
	{  
		if(DEBUG) DoDebug("ft_tch_gold_ice: Unarmed callback - adding to creature weapon");  
		  
		// Get the creature weapon that was just created  
		object oCreatureWeapon = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC);  
		if(GetIsObjectValid(oCreatureWeapon))  
		{  
			IPSafeAddItemProperty(oCreatureWeapon,   
				ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1),   
				9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);  
			AddEventScript(oCreatureWeapon, EVENT_ITEM_ONHIT, "ft_tch_gold_ice", TRUE, FALSE);  
			  
			if(DEBUG) DoDebug("ft_tch_gold_ice: Added on-hit property to creature weapon");  
		}  
	}	
	// We are called from the OnPlayerEquipItem eventhook      
	else if(nEvent == EVENT_ONPLAYEREQUIPITEM)      
	{      
		object oItem = GetItemLastEquipped();      
		object oSkin = GetPCSkin(oPC);      
		if(DEBUG) DoDebug("ft_tch_gold_ice - OnEquip\n"      
						+ "oPC = " + DebugObject2Str(oPC) + "\n"      
						+ "oItem = " + DebugObject2Str(oItem) + "\n");      
	  
		// Add to unarmed weapons only      
		if(oItem == GetItemInSlot(INVENTORY_SLOT_ARMS, oPC))  
		{  
			// Add to gloves  
			IPSafeAddItemProperty(oItem,   
				ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1),   
				9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);  
			AddEventScript(oItem, EVENT_ITEM_ONHIT, "ft_tch_gold_ice", TRUE, FALSE);  
			  
			// Also add to creature weapon if it exists  
			object oCreatureWeapon = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC);  
			if(GetIsObjectValid(oCreatureWeapon))  
			{  
				IPSafeAddItemProperty(oCreatureWeapon,   
					ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1),   
					9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);  
				AddEventScript(oCreatureWeapon, EVENT_ITEM_ONHIT, "ft_tch_gold_ice", TRUE, FALSE);  
			}  
		}
	}
	  
	// We are called from the OnPlayerUnEquipItem eventhook      
	else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM)      
	{      
		object oItem = GetItemLastUnequipped();      
		if(DEBUG) DoDebug("ft_tch_gold_ice - OnUnEquip\n"      
						+ "oPC = " + DebugObject2Str(oPC) + "\n"      
						+ "oItem = " + DebugObject2Str(oItem) + "\n");      
	  
		// Remove eventhook and property      
		RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "ft_tch_gold_ice", TRUE, FALSE);  
		RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", -1, DURATION_TYPE_TEMPORARY);  
	}
}