//::///////////////////////////////////////////////
//:: Name Forsaker
//:: FileName prc_forsaker.nss
//:: Created By: Stratosvarious
//:: Edited By: Fencas
//:://////////////////////////////////////////////

#include "prc_inc_combat"
#include "inc_dynconv"
#include "prc_class_const"
#include "prc_alterations"
#include "prc_ipfeat_const"
#include "nw_i0_spells"

void main()
{
	object oPC = OBJECT_SELF;
	object oItem;
	object oArmor;
	object oShield;
    object oSkin = GetPCSkin(oPC);
	
	int nSlot;
    int nClass = GetLevelByClass(CLASS_TYPE_FORSAKER, oPC);
	int nClassCheck;
    int nBonus = nClass/2;
	int nRegen = 1 + nClass/4;	
	int nSR    = 10 + nClass;
	int nEvent = GetCurrentlyRunningEvent();

    // We aren't being called from any event, instead from EvalPRCFeats
    if(nEvent == FALSE)
    {	
		//Check if level up bonus has already been chosen and given for any of past Forsaker levels
		for(nClassCheck=1; nClassCheck <= nClass; nClassCheck++)
		{
			if(!GetPersistantLocalInt(oPC, "ForsakerBoost"+IntToString(nClassCheck)))
			{
				//Level up box for stat bonus
				AssignCommand(oPC, ClearAllActions(TRUE));
				SetPersistantLocalInt(oPC,"ForsakerBoostCheck",nClassCheck);
				StartDynamicConversation("prc_forsake_abil", oPC, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oPC);
			}
		}
		
		//Fast healing 1 (+1 each 4 levels)
		SetCompositeBonus(oSkin,"ForsakerFH",nRegen,ITEM_PROPERTY_REGENERATION);
		
		//SR = 10 + Forsaker level
		IPSafeAddItemProperty(oSkin, ItemPropertyBonusSpellResistance(GetSRByValue(nSR)), 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
		
		//DR starting on level 2 = (level+1)/(Level/2)
		if (nClass >=2) ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectDamageReduction((nClass+1),(nClass/2)),oPC);

		//Natural AC increase by CON starting on level 3
		if (nClass >= 3) 
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

			if(GetIsUnarmed(oPC) && (nClass >= 3)) //If it is unarmed, give DR bypass
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
			if(nClass>=3)
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
