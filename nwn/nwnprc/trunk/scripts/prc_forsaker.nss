#include "prc_inc_combat"
#include "inc_dynconv"

itemproperty ForsakerDR(int nClass)
{
	itemproperty iDR;
	if (nClass >= 30) iDR = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_15,IP_CONST_DAMAGESOAK_31_HP);
	else if (nClass >= 28) iDR = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_14,IP_CONST_DAMAGESOAK_29_HP);
	else if (nClass >= 26) iDR = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_13,IP_CONST_DAMAGESOAK_27_HP);
	else if (nClass >= 24) iDR = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_12,IP_CONST_DAMAGESOAK_25_HP);
	else if (nClass >= 22) iDR = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_11,IP_CONST_DAMAGESOAK_23_HP);
	else if (nClass >= 20) iDR = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_10,IP_CONST_DAMAGESOAK_21_HP);
	else if (nClass >= 18) iDR = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_9,IP_CONST_DAMAGESOAK_19_HP);
	else if (nClass >= 16) iDR = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_8,IP_CONST_DAMAGESOAK_17_HP);
	else if (nClass >= 14) iDR = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_7,IP_CONST_DAMAGESOAK_15_HP);
	else if (nClass >= 12) iDR = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_6,IP_CONST_DAMAGESOAK_13_HP);
	else if (nClass >= 10) iDR = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_5,IP_CONST_DAMAGESOAK_11_HP);
	else if (nClass >= 8) iDR = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_4,IP_CONST_DAMAGESOAK_9_HP);
	else if (nClass >= 6) iDR = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_3,IP_CONST_DAMAGESOAK_7_HP);
	else if (nClass >= 4) iDR = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_2,IP_CONST_DAMAGESOAK_5_HP);
	else if (nClass >= 2) iDR = ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_1,IP_CONST_DAMAGESOAK_3_HP);
	
	return iDR;
}

void ForsakerBoost(object oPC, int nClass, object oSkin)
{
	int i, nStr, nCon, nDex, nInt, nWis, nCha;
	for(i = 0; i <= nClass; i++)
	{
		int nTest = GetPersistantLocalInt(oPC, "ForsakerBoost"+IntToString(i))-1; // Taking out the -1 here
		if (nTest == ABILITY_STRENGTH) nStr++;
		else if (nTest == ABILITY_DEXTERITY) nDex++;
		else if (nTest == ABILITY_CONSTITUTION) nCon++;
		else if (nTest == ABILITY_INTELLIGENCE) nInt++;
		else if (nTest == ABILITY_WISDOM) nWis++;
		else if (nTest == ABILITY_CHARISMA) nCha++;
	} 
	
	/*FloatingTextStringOnCreature("Strength = "+IntToString(nStr), oPC, FALSE);
	FloatingTextStringOnCreature("Dex = "+IntToString(nDex), oPC, FALSE);
	FloatingTextStringOnCreature("Con = "+IntToString(nCon), oPC, FALSE);
	FloatingTextStringOnCreature("Int = "+IntToString(nInt), oPC, FALSE);
	FloatingTextStringOnCreature("Wis = "+IntToString(nWis), oPC, FALSE);
	FloatingTextStringOnCreature("Cha = "+IntToString(nCha), oPC, FALSE);*/	
	
	SetCompositeBonus(oSkin, "Forsaker_Str", nStr, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_STR);
	SetCompositeBonus(oSkin, "Forsaker_Dex", nDex, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_DEX);
	SetCompositeBonus(oSkin, "Forsaker_Con", nCon, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_CON);
	SetCompositeBonus(oSkin, "Forsaker_Int", nInt, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_INT);
	SetCompositeBonus(oSkin, "Forsaker_Wis", nWis, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_WIS);
	SetCompositeBonus(oSkin, "Forsaker_Cha", nCha, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_CHA);
}

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
    object oSkin = GetPCSkin(oPC);
    int nClass = GetLevelByClass(CLASS_TYPE_FORSAKER, oPC);
    int nBonus = nClass/2;

    // We aren't being called from any event, instead from EvalPRCFeats
    if(nEvent == FALSE)
    {
    	if (!GetPersistantLocalInt(oPC, "ForsakerBoost"+IntToString(nClass))) 
    	{
        	AssignCommand(oPC, ClearAllActions(TRUE));
        	StartDynamicConversation("prc_forsake_abil", oPC, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oPC);
        }
        
    	ForsakerBoost(oPC, nClass, oSkin);
		if (nClass >= 2) IPSafeAddItemProperty(oSkin, ForsakerDR(nClass), 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, TRUE);
		if (nClass >= 3) ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectACIncrease(GetAbilityModifier(ABILITY_CONSTITUTION, oPC), AC_NATURAL_BONUS), oPC);
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
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );

		// No equipping magical items, and make sure to ignore creature items
		if(GetIsItemPropertyValid(GetFirstItemProperty(oItem)) && oItem != GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oPC) && oItem != GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC) &&
		   oItem != GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oPC) && oItem != GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC))
		{
			AssignCommand(oPC, ClearAllActions(TRUE));
			AssignCommand(oPC, ActionUnequipItem(oItem));
			FloatingTextStringOnCreature(GetName(oItem)+" is a magical item!", oPC, FALSE);
		}		
		
        // Only applies to weapons
        if(oItem == GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC) || (oItem == GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC) && !GetIsShield(oItem)))
        {        
         	// Penetrate DR
            if (nClass >= 3) IPSafeAddItemProperty(oItem, ItemPropertyAttackBonus(nBonus), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            if (nClass >= 3) IPSafeAddItemProperty(oItem, ItemPropertyAttackPenalty(nBonus), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);			
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
            if (nClass >= 3) RemoveSpecificProperty(oItem, ITEM_PROPERTY_ATTACK_BONUS, -1, -1, 1, "", -1, DURATION_TYPE_TEMPORARY);
            if (nClass >= 3) RemoveSpecificProperty(oItem, ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER, -1, -1, 1, "", -1, DURATION_TYPE_TEMPORARY);
        }
    }
}
