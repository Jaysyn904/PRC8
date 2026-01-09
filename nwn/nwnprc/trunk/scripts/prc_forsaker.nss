//::///////////////////////////////////////////////  
//:: Name Forsaker  
//:: FileName prc_forsaker.nss  
//:: Created By: Stratosvarious  
//:: Edited By: Fencas  
//:://////////////////////////////////////////////  
  
#include "prc_inc_function"  
#include "prc_inc_combat"  
#include "inc_dynconv"  
#include "prc_alterations"  
  
void main()    
{    
    int nEvent = GetRunningEvent();    
    if(DEBUG) DoDebug("prc_forsaker running, event: " + IntToString(nEvent));    
	    
	// Get the PC. This is event-dependent    
    object oPC;    
    switch(nEvent)    
    {    
        case EVENT_ITEM_ONHIT:          oPC = OBJECT_SELF;               break;    
        case EVENT_ONPLAYEREQUIPITEM:   oPC = GetItemLastEquippedBy();   break;    
        case EVENT_ONPLAYERUNEQUIPITEM: oPC = GetItemLastUnequippedBy(); break;    
        case EVENT_ONHEARTBEAT:         oPC = OBJECT_SELF;               break;    
    
        default:    
            oPC = OBJECT_SELF;    
    }    
	object oItem;    
	object oArmor;    
	object oShield;    
    object oSkin = GetPCSkin(oPC);    
	    
	int nSlot;    
    int nForsakerLvl 		= GetLevelByClass(CLASS_TYPE_FORSAKER, oPC);    
	int nForsakerLvlCheck;    
    int nBonus 				= nForsakerLvl/2;    
	int nRegen 				= 1 + nForsakerLvl/4;	    
	int nSR    				= 10 + nForsakerLvl;    
		    
    if(nEvent == FALSE)    
    {	    
		    
		//Check if level up bonus has already been chosen and given for any of past Forsaker levels    
		for(nForsakerLvlCheck=1; nForsakerLvlCheck <= nForsakerLvl; nForsakerLvlCheck++)    
		{    
			if(!GetPersistantLocalInt(oPC, "ForsakerBoost"+IntToString(nForsakerLvlCheck)))    
			{    
				//Level up box for stat bonus    
				AssignCommand(oPC, ClearAllActions(TRUE));    
				SetPersistantLocalInt(oPC,"ForsakerBoostCheck",nForsakerLvlCheck);    
				StartDynamicConversation("prc_forsake_abil", oPC, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oPC);    
			}    
		}    
		    
		//Fast healing 1 (+1 each 4 levels)    
		SetCompositeBonus(oSkin,"ForsakerFH",nRegen,ITEM_PROPERTY_REGENERATION);    
		    
		//SR = 10 + Forsaker level    
		IPSafeAddItemProperty(oSkin, ItemPropertyBonusSpellResistance(GetSRByValue(nSR)), 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);    
		    
		//DR starting on level 2 = (level+1)/(Level/2)    
		if (nForsakerLvl >=2) ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectDamageReduction((nForsakerLvl+1),(nForsakerLvl/2)),oPC);    
    
		//Natural AC increase by CON starting on level 3    
		if (nForsakerLvl >= 3)     
		{    
			effect eEffect1 = EffectACIncrease(GetAbilityModifier(ABILITY_CONSTITUTION, oPC), AC_NATURAL_BONUS);    
				   eEffect1 = ExtraordinaryEffect(eEffect1);    
				   eEffect1 = TagEffect(eEffect1, "EffectToughDefense");    
			    
			//Remove any prior bonus to avoid duplication    
			effect eCheckEffect = GetFirstEffect(oPC);    
			while (GetIsEffectValid(eCheckEffect))    
			{    
				if(GetEffectTag(eCheckEffect) == "EffectToughDefense") RemoveEffect(oPC, eCheckEffect);    
				eCheckEffect = GetNextEffect(oPC);    
			}    
			    
			//Give player the bonus    
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect1, oPC); 	    
		}    
    
		if(!GetHasFeat(FEAT_VOWOFPOVERTY,oPC))    
		{    
			// REMOVED: Aggressive inventory scanning that was removing all magical items    
			// This was causing permanent property loss for players    
			// The Forsaker class should still prevent magical item usage through equip events    
			    
			if(GetIsUnarmed(oPC) && (nForsakerLvl >= 3)) //If it is unarmed, give DR bypass    
			{    
				ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAttackIncrease(nBonus),oPC);    
				ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAttackDecrease(nBonus),oPC);    
			}    
		}		    
        // Hook in the events, needed from level 1 for Magic Hatred    
        if(DEBUG) DoDebug("prc_forsaker: Adding eventhooks");    
        AddEventScript(oPC, EVENT_ONPLAYEREQUIPITEM,   "prc_forsaker", TRUE, FALSE);    
        AddEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM, "prc_forsaker", TRUE, FALSE);    
    }    
    // We are called from the OnPlayerEquipItem eventhook. Handle magical item restriction    
    else if(nEvent == EVENT_ONPLAYEREQUIPITEM)    
    {    
        oPC   = GetItemLastEquippedBy();    
        oItem = GetItemLastEquipped();    
        if(DEBUG) DoDebug("prc_forsaker - OnEquip\n"    
                        + "oPC = " + DebugObject2Str(oPC) + "\n"    
                        + "oItem = " + DebugObject2Str(oItem) + "\n");    
						    
		if(!GetHasFeat(FEAT_VOWOFPOVERTY,oPC))    
		{    
			// Check if item is a creature item - if so, skip magical item check  
			int nItemType = GetBaseItemType(oItem);  
			if(nItemType == BASE_ITEM_CBLUDGWEAPON ||  
			   nItemType == BASE_ITEM_CPIERCWEAPON ||  
			   nItemType == BASE_ITEM_CREATUREITEM ||  
			   nItemType == BASE_ITEM_CSLASHWEAPON ||  
			   nItemType == BASE_ITEM_CSLSHPRCWEAP)  
			{  
				// Item is a creature weapon, allow it  
				return;  
			}  
			  
			// Check if the item being equipped is magical    
			// Only check the item being equipped, not entire inventory    
			int bIsMagical = FALSE;    
			itemproperty ipCheck = GetFirstItemProperty(oItem);    
			while (GetIsItemPropertyValid(ipCheck))    
			{    
				// Skip protected properties    
				if(GetItemPropertyTag(ipCheck) != "Tag_PRC_OnHitKeeper")    
				{    
					bIsMagical = TRUE;    
					break;    
				}    
				ipCheck = GetNextItemProperty(oItem);    
			}    
			    
			// If item is magical and not a torch, unequip it    
			if(bIsMagical && GetResRef(oItem) != "nw_it_torch001")      
			{      
				AssignCommand(oPC, ClearAllActions(TRUE));      
				AssignCommand(oPC, ActionUnequipItem(oItem));      
				FloatingTextStringOnCreature(GetName(oItem)+" is a magical item!", oPC, FALSE);      
			}    
			// If non-magical weapon and Forsaker has DR bypass, add bonuses    
			else if(!bIsMagical && (IPGetIsMeleeWeapon(oItem) || GetWeaponRanged(oItem)) && (nForsakerLvl >= 3))    
			{    
				// Add DR bypass bonuses to non-magical weapons    
				itemproperty ipAttack = ItemPropertyAttackBonus(nBonus);    
				ipAttack = TagItemProperty(ipAttack, "ForsakerDRBypass");    
				IPSafeAddItemProperty(oItem, ipAttack, 99999.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);    
				    
				itemproperty ipPenalty = ItemPropertyAttackPenalty(nBonus);    
				ipPenalty = TagItemProperty(ipPenalty, "ForsakerDRBypass");    
				IPSafeAddItemProperty(oItem, ipPenalty, 99999.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);    
				    
				// Remove unarmed bonus    
				effect eLoop = GetFirstEffect(oPC);    
				while(GetIsEffectValid(eLoop))    
				{    
					if(GetEffectType(eLoop) == EFFECT_TYPE_ATTACK_INCREASE     
					  || GetEffectType(eLoop) == EFFECT_TYPE_ATTACK_DECREASE) RemoveEffect(oPC,eLoop);    
					eLoop = GetNextEffect(oPC);    
				}    
			}    
		}    
	}		    
    // We are called from the OnPlayerUnEquipItem eventhook. Clean up Forsaker properties    
    else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM)    
    {    
        oPC   = GetItemLastUnequippedBy();    
        oItem = GetItemLastUnequipped();    
        if(DEBUG) DoDebug("prc_forsaker - OnUnEquip\n"    
                        + "oPC = " + DebugObject2Str(oPC) + "\n"    
                        + "oItem = " + DebugObject2Str(oItem) + "\n"    
                          );    
    
        // Only remove properties that Forsaker actually added    
        if(IPGetIsMeleeWeapon(oItem) || GetWeaponRanged(oItem))    
        {    
            if (nForsakerLvl >= 3)    
            {    
                // Remove only tagged Forsaker properties    
                itemproperty ipCheck = GetFirstItemProperty(oItem);    
                while (GetIsItemPropertyValid(ipCheck))    
                {    
                    if (GetItemPropertyTag(ipCheck) == "ForsakerDRBypass")    
                    {    
                        RemoveItemProperty(oItem, ipCheck);    
                    }    
                    ipCheck = GetNextItemProperty(oItem);    
                }    
            }    
        }    
            
        // If now unarmed, give DR bypass back to player    
        if(GetIsUnarmed(oPC) && (nForsakerLvl >= 3))    
        {    
            ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAttackIncrease(nBonus),oPC);    
            ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAttackDecrease(nBonus),oPC);    
        }    
    }	    
}


/* void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("prc_forsaker running, event: " + IntToString(nEvent));
	
	// Get the PC. This is event-dependent
    object oPC;
    switch(nEvent)
    {
        case EVENT_ITEM_ONHIT:          oPC = OBJECT_SELF;               break;
        case EVENT_ONPLAYEREQUIPITEM:   oPC = GetItemLastEquippedBy();   break;
        case EVENT_ONPLAYERUNEQUIPITEM: oPC = GetItemLastUnequippedBy(); break;
        case EVENT_ONHEARTBEAT:         oPC = OBJECT_SELF;               break;

        default:
            oPC = OBJECT_SELF;
    }
	object oItem;
	object oArmor;
	object oShield;
    object oSkin = GetPCSkin(oPC);
	
	int nSlot;
    int nForsakerLvl 		= GetLevelByClass(CLASS_TYPE_FORSAKER, oPC);
	int nForsakerLvlCheck;
    int nBonus 				= nForsakerLvl/2;
	int nRegen 				= 1 + nForsakerLvl/4;	
	int nSR    				= 10 + nForsakerLvl;
		
    if(nEvent == FALSE)
    {	
		
		//Check if level up bonus has already been chosen and given for any of past Forsaker levels
		for(nForsakerLvlCheck=1; nForsakerLvlCheck <= nForsakerLvl; nForsakerLvlCheck++)
		{
			if(!GetPersistantLocalInt(oPC, "ForsakerBoost"+IntToString(nForsakerLvlCheck)))
			{
				//Level up box for stat bonus
				AssignCommand(oPC, ClearAllActions(TRUE));
				SetPersistantLocalInt(oPC,"ForsakerBoostCheck",nForsakerLvlCheck);
				StartDynamicConversation("prc_forsake_abil", oPC, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oPC);
			}
		}
		
		//Fast healing 1 (+1 each 4 levels)
		SetCompositeBonus(oSkin,"ForsakerFH",nRegen,ITEM_PROPERTY_REGENERATION);
		
		//SR = 10 + Forsaker level
		IPSafeAddItemProperty(oSkin, ItemPropertyBonusSpellResistance(GetSRByValue(nSR)), 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
		
		//DR starting on level 2 = (level+1)/(Level/2)
		if (nForsakerLvl >=2) ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectDamageReduction((nForsakerLvl+1),(nForsakerLvl/2)),oPC);

		//Natural AC increase by CON starting on level 3
		if (nForsakerLvl >= 3) 
		{
			effect eEffect1 = EffectACIncrease(GetAbilityModifier(ABILITY_CONSTITUTION, oPC), AC_NATURAL_BONUS);
				   eEffect1 = ExtraordinaryEffect(eEffect1);
				   eEffect1 = TagEffect(eEffect1, "EffectToughDefense");
			
			//Remove any prior bonus to avoid duplication
			effect eCheckEffect = GetFirstEffect(oPC);
			while (GetIsEffectValid(eCheckEffect))
			{
				if(GetEffectTag(eCheckEffect) == "EffectToughDefense") RemoveEffect(oPC, eCheckEffect);
				eCheckEffect = GetNextEffect(oPC);
			}
			
			//Give player the bonus
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect1, oPC); 	
		}

		if(!GetHasFeat(FEAT_VOWOFPOVERTY,oPC))
		{
			for (nSlot=0; nSlot < 13; nSlot++) //All but creatures slots  
			{  
				oItem=GetItemInSlot(nSlot, oPC);  
				//Check if it is magical and not a torch  
				if(GetIsItemPropertyValid(GetFirstItemProperty(oItem)) &&   
				   !(GetItemPropertyTag(GetFirstItemProperty(oItem)) == "Tag_PRC_OnHitKeeper") &&  
				   GetResRef(oItem) != "nw_it_torch001")  
				{  
					AssignCommand(oPC, ClearAllActions(TRUE));  
					AssignCommand(oPC, ActionUnequipItem(oItem));  
					FloatingTextStringOnCreature(GetName(oItem)+" is a magical item!", oPC, FALSE);  
				}  
			}

			if(GetIsUnarmed(oPC) && (nForsakerLvl >= 3)) //If it is unarmed, give DR bypass
			{
				ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAttackIncrease(nBonus),oPC);
				ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAttackDecrease(nBonus),oPC);
				
				//Remove last weapon(s) bonus
				oItem = GetPCItemLastUnequipped();
				if((IPGetIsMeleeWeapon(oItem) || GetWeaponRanged(oItem)))
				{
					RemoveSpecificProperty(oItem, ITEM_PROPERTY_ATTACK_BONUS, -1, -1, 1, "", -1, DURATION_TYPE_TEMPORARY);
					RemoveSpecificProperty(oItem, ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER, -1, -1, 1, "", -1, DURATION_TYPE_TEMPORARY);
				}
			}
		}		
        // Hook in the events, needed from level 1 for Magic Hatred
        if(DEBUG) DoDebug("prc_forsaker: Adding eventhooks");
        AddEventScript(oPC, EVENT_ONPLAYEREQUIPITEM,   "prc_forsaker", TRUE, FALSE);
        AddEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM, "prc_forsaker", TRUE, FALSE);
    }
    // We are called from the OnPlayerEquipItem eventhook. Add OnHitCast: Unique Power to oPC's weapon
    else if(nEvent == EVENT_ONPLAYEREQUIPITEM)
    {
        oPC   = GetItemLastEquippedBy();
        oItem = GetItemLastEquipped();
        if(DEBUG) DoDebug("prc_forsaker - OnEquip\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n");
						
		if(!GetHasFeat(FEAT_VOWOFPOVERTY,oPC))
		{
			for (nSlot=0; nSlot < 13; nSlot++) //All but creatures slots  
			{  
				oItem=GetItemInSlot(nSlot, oPC);  
				//Check if it is magical and not a torch  
				if(GetIsItemPropertyValid(GetFirstItemProperty(oItem)) &&   
				   !(GetItemPropertyTag(GetFirstItemProperty(oItem)) == "Tag_PRC_OnHitKeeper") &&  
				   GetResRef(oItem) != "nw_it_torch001")  
				{  
					AssignCommand(oPC, ClearAllActions(TRUE));  
					AssignCommand(oPC, ActionUnequipItem(oItem));  
					FloatingTextStringOnCreature(GetName(oItem)+" is a magical item!", oPC, FALSE);  
				}  
			}

			if(GetIsUnarmed(oPC) && (nForsakerLvl >= 3)) //If it is unarmed, give DR bypass
			{
				ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAttackIncrease(nBonus),oPC);
				ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAttackDecrease(nBonus),oPC);
				
				//Remove last weapon(s) bonus
				oItem = GetPCItemLastUnequipped();
				if((IPGetIsMeleeWeapon(oItem) || GetWeaponRanged(oItem)))
				{
					RemoveSpecificProperty(oItem, ITEM_PROPERTY_ATTACK_BONUS, -1, -1, 1, "", -1, DURATION_TYPE_TEMPORARY);
					RemoveSpecificProperty(oItem, ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER, -1, -1, 1, "", -1, DURATION_TYPE_TEMPORARY);
				}
			}
		}
	}		
    // We are called from the OnPlayerUnEquipItem eventhook. Remove OnHitCast: Unique Power from oPC's weapon
    else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM)
    {
        oPC   = GetItemLastUnequippedBy();
        oItem = GetItemLastUnequipped();
        if(DEBUG) DoDebug("prc_forsaker - OnUnEquip\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );

        // Only applies to weapons
        if(IPGetIsMeleeWeapon(oItem) || GetWeaponRanged(oItem))
        {
            if (nForsakerLvl >= 3) RemoveSpecificProperty(oItem, ITEM_PROPERTY_ATTACK_BONUS, -1, -1, 1, "", -1, DURATION_TYPE_TEMPORARY);
            if (nForsakerLvl >= 3) RemoveSpecificProperty(oItem, ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER, -1, -1, 1, "", -1, DURATION_TYPE_TEMPORARY);
        }
    }	
} */
	

/*     // We aren't being called from any event, instead from EvalPRCFeats
    if(nEvent == FALSE)
    {	
		//Check if level up bonus has already been chosen and given for any of past Forsaker levels
		for(nForsakerLvlCheck=1; nForsakerLvlCheck <= nForsakerLvl; nForsakerLvlCheck++)
		{
			if(!GetPersistantLocalInt(oPC, "ForsakerBoost"+IntToString(nForsakerLvlCheck)))
			{
				//Level up box for stat bonus
				AssignCommand(oPC, ClearAllActions(TRUE));
				SetPersistantLocalInt(oPC,"ForsakerBoostCheck",nForsakerLvlCheck);
				StartDynamicConversation("prc_forsake_abil", oPC, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oPC);
			}
		}
		
		//Fast healing 1 (+1 each 4 levels)
		SetCompositeBonus(oSkin,"ForsakerFH",nRegen,ITEM_PROPERTY_REGENERATION);
		
		//SR = 10 + Forsaker level
		IPSafeAddItemProperty(oSkin, ItemPropertyBonusSpellResistance(GetSRByValue(nSR)), 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
		
		//DR starting on level 2 = (level+1)/(Level/2)
		if (nForsakerLvl >=2) ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectDamageReduction((nForsakerLvl+1),(nForsakerLvl/2)),oPC);

		//Natural AC increase by CON starting on level 3
		if (nForsakerLvl >= 3) 
		{
			effect eEffect1 = EffectACIncrease(GetAbilityModifier(ABILITY_CONSTITUTION, oPC), AC_NATURAL_BONUS);
				   eEffect1 = ExtraordinaryEffect(eEffect1);
				   eEffect1 = TagEffect(eEffect1, "EffectToughDefense");
			
			//Remove any prior bonus to avoid duplication
			effect eCheckEffect = GetFirstEffect(oPC);
			while (GetIsEffectValid(eCheckEffect))
			{
				if(GetEffectTag(eCheckEffect) == "EffectToughDefense") RemoveEffect(oPC, eCheckEffect);
				eCheckEffect = GetNextEffect(oPC);
			}
			
			//Give player the bonus
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect1, oPC); 	
		}

		// For some reason, EVENT_ONPLAYEREQUIPITEM just works with weapons, so armors and shields should be checked elsewhere
		if(!GetHasFeat(FEAT_VOWOFPOVERTY,oPC))
		{
			for (nSlot=0; nSlot < 13; nSlot++) //All but creatures slots
			{
				oItem=GetItemInSlot(nSlot, oPC);
				//Check if it is magical
				if(GetIsItemPropertyValid(GetFirstItemProperty(oItem)) && !(GetItemPropertyTag(GetFirstItemProperty(oItem)) == "Tag_PRC_OnHitKeeper"))
				{
					AssignCommand(oPC, ClearAllActions(TRUE));
					AssignCommand(oPC, ActionUnequipItem(oItem));
					FloatingTextStringOnCreature(GetName(oItem)+" is a magical item!", oPC, FALSE);
				}
			}

			if(GetIsUnarmed(oPC) && (nForsakerLvl >= 3)) //If it is unarmed, give DR bypass
			{
				ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAttackIncrease(nBonus),oPC);
				ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectAttackDecrease(nBonus),oPC);
				
				//Remove last weapon(s) bonus
				oItem = GetPCItemLastUnequipped();
				if((IPGetIsMeleeWeapon(oItem) || GetWeaponRanged(oItem)))
				{
					RemoveSpecificProperty(oItem, ITEM_PROPERTY_ATTACK_BONUS, -1, -1, 1, "", -1, DURATION_TYPE_TEMPORARY);
					RemoveSpecificProperty(oItem, ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER, -1, -1, 1, "", -1, DURATION_TYPE_TEMPORARY);
				}
			}
		}
		
        // Hook in the events
        AddEventScript(oPC, EVENT_SCRIPT_MODULE_ON_EQUIP_ITEM,   "prc_forsaker", TRUE, FALSE);
    }
	
    // We are called from the OnPlayerEquipItem eventhook. Add OnHitCast: Unique Power to oPC's weapon
    else if((nEvent == EVENT_SCRIPT_MODULE_ON_EQUIP_ITEM) && (!GetHasFeat(FEAT_VOWOFPOVERTY,oPC)))
    {
		oItem = GetPCItemLastEquipped();
		
		//Check if the magic is JUST Sanctify
		int iMagic = 0;
		itemproperty eCheckIP = GetFirstItemProperty(oItem);
		while (GetIsItemPropertyValid(eCheckIP))
		{
			if(!(GetItemPropertyTag(eCheckIP) == "Sanctify1") && !(GetItemPropertyTag(eCheckIP) == "Sanctify2") && !(GetItemPropertyTag(eCheckIP) == "Sanctify3")
			  && !(GetItemPropertyTag(eCheckIP) == "Sanctify4"))   iMagic = 1;
			eCheckIP = GetNextItemProperty(oItem);
		}
		
		//Check if weapons are magical
		if(iMagic && (IPGetIsMeleeWeapon(oItem) || GetWeaponRanged(oItem)) &&
		  !(GetBaseItemType(oItem) == BASE_ITEM_SLING && GetItemPropertyType(GetFirstItemProperty(oItem)) == ITEM_PROPERTY_MIGHTY)) 
		  //Check if weapon is magical or not on allowed list
		{
			AssignCommand(oPC, ClearAllActions(TRUE));
			AssignCommand(oPC, ActionUnequipItem(oItem));
			FloatingTextStringOnCreature(GetName(oItem)+" is a magical item!", oPC, FALSE);
		}
		else 
		{
			if(nForsakerLvl>=3)
			{
				//Give bonus to weapon(s)
				IPSafeAddItemProperty(oItem, ItemPropertyAttackBonus(nBonus), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
				IPSafeAddItemProperty(oItem, ItemPropertyAttackPenalty(nBonus), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);	
				
				//Remove unarmed bonus
				effect eLoop = GetFirstEffect(oPC);
				while(GetIsEffectValid(eLoop))
				{
					if(GetEffectType(eLoop) == EFFECT_TYPE_ATTACK_INCREASE 
					  || GetEffectType(eLoop) == EFFECT_TYPE_ATTACK_DECREASE) RemoveEffect(oPC,eLoop);
					eLoop = GetNextEffect(oPC);
				}
			}
		}
    }
}
 */