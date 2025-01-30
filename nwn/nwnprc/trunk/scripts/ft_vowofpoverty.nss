//::///////////////////////////////////////////////
//:: Name Vow of Poverty
//:: FileName ft_vowofpoverty.nss
//:: Created By: Fencas
//:: Created On: 2024-12-02
//:: Based On: Stratovarius' Forsaker
//:://////////////////////////////////////////////

#include "prc_inc_combat"
#include "inc_dynconv"
#include "prc_class_const"
#include "prc_inc_clsfunc"
#include "prc_alterations"
#include "NW_I0_GENERIC"
#include "nw_i0_spells"
#include "inc_persist_loca"

effect VoPDamage(int nTotalEnhancement) 
{
	effect eDamage;
	if      (nTotalEnhancement>=15) eDamage = EffectDamageIncrease(DAMAGE_BONUS_15,DAMAGE_TYPE_BLUDGEONING || DAMAGE_TYPE_SLASHING || DAMAGE_TYPE_PIERCING);
	else if (nTotalEnhancement>=14) eDamage = EffectDamageIncrease(DAMAGE_BONUS_14,DAMAGE_TYPE_BLUDGEONING || DAMAGE_TYPE_SLASHING || DAMAGE_TYPE_PIERCING);
	else if (nTotalEnhancement>=13) eDamage = EffectDamageIncrease(DAMAGE_BONUS_13,DAMAGE_TYPE_BLUDGEONING || DAMAGE_TYPE_SLASHING || DAMAGE_TYPE_PIERCING);
	else if (nTotalEnhancement>=12) eDamage = EffectDamageIncrease(DAMAGE_BONUS_12,DAMAGE_TYPE_BLUDGEONING || DAMAGE_TYPE_SLASHING || DAMAGE_TYPE_PIERCING);
	else if (nTotalEnhancement>=11) eDamage = EffectDamageIncrease(DAMAGE_BONUS_11,DAMAGE_TYPE_BLUDGEONING || DAMAGE_TYPE_SLASHING || DAMAGE_TYPE_PIERCING);
	else if (nTotalEnhancement>=10) eDamage = EffectDamageIncrease(DAMAGE_BONUS_10,DAMAGE_TYPE_BLUDGEONING || DAMAGE_TYPE_SLASHING || DAMAGE_TYPE_PIERCING);
	else if (nTotalEnhancement>=9) eDamage = EffectDamageIncrease(DAMAGE_BONUS_9,DAMAGE_TYPE_BLUDGEONING || DAMAGE_TYPE_SLASHING || DAMAGE_TYPE_PIERCING);
	else if (nTotalEnhancement>=8) eDamage = EffectDamageIncrease(DAMAGE_BONUS_8,DAMAGE_TYPE_BLUDGEONING || DAMAGE_TYPE_SLASHING || DAMAGE_TYPE_PIERCING);
	else if (nTotalEnhancement>=7) eDamage = EffectDamageIncrease(DAMAGE_BONUS_7,DAMAGE_TYPE_BLUDGEONING || DAMAGE_TYPE_SLASHING || DAMAGE_TYPE_PIERCING);
	else if (nTotalEnhancement>=6) eDamage = EffectDamageIncrease(DAMAGE_BONUS_6,DAMAGE_TYPE_BLUDGEONING || DAMAGE_TYPE_SLASHING || DAMAGE_TYPE_PIERCING);
	else if (nTotalEnhancement>=5) eDamage = EffectDamageIncrease(DAMAGE_BONUS_5,DAMAGE_TYPE_BLUDGEONING || DAMAGE_TYPE_SLASHING || DAMAGE_TYPE_PIERCING);
	else if (nTotalEnhancement>=4) eDamage = EffectDamageIncrease(DAMAGE_BONUS_4,DAMAGE_TYPE_BLUDGEONING || DAMAGE_TYPE_SLASHING || DAMAGE_TYPE_PIERCING);
	else if (nTotalEnhancement>=3) eDamage = EffectDamageIncrease(DAMAGE_BONUS_3,DAMAGE_TYPE_BLUDGEONING || DAMAGE_TYPE_SLASHING || DAMAGE_TYPE_PIERCING);
	else if (nTotalEnhancement>=2) eDamage = EffectDamageIncrease(DAMAGE_BONUS_2,DAMAGE_TYPE_BLUDGEONING || DAMAGE_TYPE_SLASHING || DAMAGE_TYPE_PIERCING);
	else if (nTotalEnhancement>=1) eDamage = EffectDamageIncrease(DAMAGE_BONUS_1,DAMAGE_TYPE_BLUDGEONING || DAMAGE_TYPE_SLASHING || DAMAGE_TYPE_PIERCING);
	
	return eDamage;
}

void main()
{
    object oPC;
	oPC = OBJECT_SELF;
    object oItem;
	object oArmor;
	object oShield;
    object oSkin = GetPCSkin(oPC);
	int nEvent = GetCurrentlyRunningEvent();
    int nLevel = GetCharacterLevel(oPC)-GetPersistantLocalInt(oPC,"VoPLevel1")+1;
	int nACArmor = 4+nLevel/3;
	int nACDeflection = nLevel/6;
	int nACNatural = nLevel/8;
	int nRegen = 1+(nLevel-17)/7;
	int nDR = 5*(1+(nLevel-10)/9);
	int nER = (10*(1+(nLevel-13)/7))-5;
	int nForsakerBonus = GetLevelByClass(CLASS_TYPE_FORSAKER, oPC)/2;
	int nSlot, nLevelCheck, nExaltedStrike, nTotalEnhancement;
	
	//Enhancement bonus for unarmed damage and weapons; consider the bigger, Forsaker or VoP
	if(nLevel>=10)      						nExaltedStrike = 1+(nLevel-7)/3;
	else if(nLevel>=4)  						nExaltedStrike = 1;
	if(nForsakerBonus>=nExaltedStrike)          nTotalEnhancement = nForsakerBonus;
	else 									    nTotalEnhancement = nExaltedStrike;
	
    // We aren't being called from any event, instead from EvalPRCFeats
	
    if(nEvent == FALSE)
	{	
		//Check if level up bonus has already been chosen and given for any of past VoP levels
		for(nLevelCheck=1; nLevelCheck <= nLevel; nLevelCheck++)
		{	
			//Call stat boost dialogue for level 7 and each 4 levels after that
			if (!GetPersistantLocalInt(oPC, "VoPBoost"+IntToString(nLevelCheck)) && (nLevelCheck-(nLevelCheck/4)*4 == 3) && (nLevelCheck >= 7) && (nLevelCheck <= 27)) 
			{
				AssignCommand(oPC, ClearAllActions(TRUE));
				SetPersistantLocalInt(oPC,"VoPBoostCheck",nLevelCheck);
				StartDynamicConversation("ft_vowpoverty_ab", oPC, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oPC);	
			}
		
			//Call exalted feat for each even level
			if (!GetPersistantLocalInt(oPC, "VoPFeat"+IntToString(nLevelCheck)) && (nLevelCheck-(nLevelCheck/2)*2 == 0)) 
			{
				AssignCommand(oPC, ClearAllActions(TRUE));
				SetPersistantLocalInt(oPC,"VoPFeatCheck",nLevelCheck);
				StartDynamicConversation("ft_vowpoverty_ft", oPC, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oPC);	
			}
		}
		
		//AC Armor +4 on 1st, then +1 each 3 levels
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectACIncrease(nACArmor, AC_ARMOUR_ENCHANTMENT_BONUS)), oPC);
		
		//Deflection Armor +1 each 6 levels
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectACIncrease(nACDeflection, AC_DEFLECTION_BONUS)), oPC);
		
		//Resistences +1 on 7, then each 5 levels; must use SetPersistantLocalInt to avoid duplication on new levels
		if ((nLevel>=7) && (nLevel-(nLevel/5)*5 == 2))
		{	
			if (!GetPersistantLocalInt(oPC, "VoPResistance"+IntToString(nLevel)))
			{
				ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(EffectSavingThrowIncrease(SAVING_THROW_ALL, 1, SAVING_THROW_TYPE_ALL)), oPC);
				SetPersistantLocalInt(oPC, "VoPResistance"+IntToString(nLevel),1);
			}
		}
		
		//Natural Armor +1 each 8 levels
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(EffectACIncrease(nACNatural, AC_NATURAL_BONUS)), oPC);
		
		//DR 5/Enhancement starting 10, +5 each 9 levels
		if (nLevel >= 10) ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectDamageReduction(nDR,nTotalEnhancement)),oPC);
		
		//Energy resistance 5 for acid, cold ,electrical, fire and sonic on 13th, than +10 each 7 levels
		if (nLevel>=13)
		{
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDamageResistance(DAMAGE_TYPE_ACID, nER, 0, FALSE), oPC);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDamageResistance(DAMAGE_TYPE_COLD, nER, 0, FALSE), oPC);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, nER, 0, FALSE), oPC);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDamageResistance(DAMAGE_TYPE_FIRE, nER, 0, FALSE), oPC);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDamageResistance(DAMAGE_TYPE_SONIC, nER, 0, FALSE), oPC);
		}
		
		//Freedom of Movement at 14th
		if (nLevel>=14) IPSafeAddItemProperty(oSkin, ItemPropertyFreeAction(), 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, TRUE);
		
		//Regeneration 1 at 17th, +1 at each 7 levels
		if (nLevel>=17) SetCompositeBonus(oSkin, "VoPFH", nRegen, ITEM_PROPERTY_REGENERATION);
		
		//True Seeing at 18th
		if (nLevel>=18) IPSafeAddItemProperty(oSkin, ItemPropertyTrueSeeing(), 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, TRUE);
		
		// Exalted Strike - only applies to weapons or unarmed
		effect eEffect1 = EffectAttackIncrease(nTotalEnhancement);
		effect eEffect2 = VoPDamage(nTotalEnhancement);
		effect eLink = EffectLinkEffects(eEffect1,eEffect2);
			   eLink = SupernaturalEffect(eLink);
			   eLink = TagEffect(eLink, "EffectExaltedStrike");
		
		//Remove any prior bonus to avoid duplication
		effect eCheckEffect = GetFirstEffect(oPC);
		while (GetIsEffectValid(eCheckEffect))
		{
			if(GetEffectTag(eCheckEffect) == "EffectExaltedStrike") RemoveEffect(oPC, eCheckEffect);
			eCheckEffect = GetNextEffect(oPC);
		}
	    
		//Give player the bonus, regardless of the weapon
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC); 	
		
		// For some reason, EVENT_ONPLAYEREQUIPITEM just works with weapons, so it is better to check all other items for magic elsewhere		
		for (nSlot=0; nSlot < 13; nSlot++) //All but creatures slots
		{
			oItem=GetItemInSlot(nSlot, oPC);
			if((GetIsItemPropertyValid(GetFirstItemProperty(oItem)) && !(GetItemPropertyTag(GetFirstItemProperty(oItem)) == "Tag_PRC_OnHitKeeper")
			  && !(nSlot == 4 || nSlot == 5)) 										   //Check if it is magical (all items but on the hands)
			   || (nSlot == 1 && GetBaseAC(oItem) >= 1)                                //Check if it is an armor (AC>0)
			   || (nSlot == 5 && GetBaseItemType(oItem) == BASE_ITEM_SMALLSHIELD ||    //Check if it is a shield 
							     GetBaseItemType(oItem) == BASE_ITEM_LARGESHIELD || 
								 GetBaseItemType(oItem) == BASE_ITEM_TOWERSHIELD))
			{
				AssignCommand(oPC, ClearAllActions(TRUE));
				AssignCommand(oPC, ActionUnequipItem(oItem));
				FloatingTextStringOnCreature(GetName(oItem)+" would break your vow!", oPC, FALSE);
			}
		}
		
		//Remove bonus from unequiped weapons
		oItem = GetPCItemLastUnequipped();
		if(IPGetIsMeleeWeapon(oItem) || GetWeaponRanged(oItem))   IPRemoveAllItemProperties(oItem, DURATION_TYPE_PERMANENT); 
		
        AddEventScript(oPC, EVENT_SCRIPT_MODULE_ON_EQUIP_ITEM, "ft_vowofpoverty", TRUE, FALSE);
    }
	
    // We are called from the OnPlayerUnEquipItem eventhook. Remove OnHitCast: Unique Power from oPC's weapon
    else if(nEvent == EVENT_SCRIPT_MODULE_ON_EQUIP_ITEM)
	{
		oItem = GetPCItemLastEquipped();
		int iWeaponAllowed = GetBaseItemType(oItem) == BASE_ITEM_CLUB 
						  || GetBaseItemType(oItem) == BASE_ITEM_DAGGER
						  || GetBaseItemType(oItem) == BASE_ITEM_DART
						  || GetBaseItemType(oItem) == BASE_ITEM_HEAVYCROSSBOW
						  || GetBaseItemType(oItem) == BASE_ITEM_LIGHTCROSSBOW
						  || GetBaseItemType(oItem) == BASE_ITEM_LIGHTMACE
						  || GetBaseItemType(oItem) == BASE_ITEM_MORNINGSTAR
						  || GetBaseItemType(oItem) == BASE_ITEM_QUARTERSTAFF
						  || GetBaseItemType(oItem) == BASE_ITEM_SICKLE
						  || GetBaseItemType(oItem) == BASE_ITEM_SLING
						  || GetBaseItemType(oItem) == BASE_ITEM_SHORTSPEAR
						  || GetBaseItemType(oItem) == BASE_ITEM_BOLT
						  || GetBaseItemType(oItem) == BASE_ITEM_GOAD
						  || GetBaseItemType(oItem) == BASE_ITEM_KATAR
						  || GetBaseItemType(oItem) == BASE_ITEM_HEAVY_MACE
						  || GetBaseItemType(oItem) == BASE_ITEM_BULLET;
		
		//Check if the magic is JUST Sanctify
		int iMagic = 0;
		itemproperty eCheckIP = GetFirstItemProperty(oItem);
		while (GetIsItemPropertyValid(eCheckIP))
		{
			if(!(GetItemPropertyTag(eCheckIP) == "Sanctify1") && !(GetItemPropertyTag(eCheckIP) == "Sanctify2") && !(GetItemPropertyTag(eCheckIP) == "Sanctify3")
			  && !(GetItemPropertyTag(eCheckIP) == "Sanctify4"))   iMagic = 1;
			eCheckIP = GetNextItemProperty(oItem);
		}
		
		if((IPGetIsMeleeWeapon(oItem) || GetWeaponRanged(oItem)) && (iMagic || !iWeaponAllowed)) //Check if weapon is magical or not on allowed list	        
		{
			if(!(GetBaseItemType(oItem) == BASE_ITEM_SLING && GetItemPropertyType(GetFirstItemProperty(oItem)) == ITEM_PROPERTY_MIGHTY)) //Allow Mighty Bonus on Slings
			{
				AssignCommand(oPC, ClearAllActions(TRUE));
				AssignCommand(oPC, ActionUnequipItem(oItem));
				FloatingTextStringOnCreature(GetName(oItem)+" would break your vow!", oPC, FALSE);
			}
		}
	}
}

