//::///////////////////////////////////////////////
//:: Swordsage class abilities
//:: tob_swordsage.nss
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: May 15, 2007
//:://////////////////////////////////////////////

#include "tob_inc_tobfunc"
//#include "prc_alterations"

void AddWS(object oPC,object oSkin,int ip_feat_crit,int nFeat)
{
    // Do not add multiple instances of the same bonus feat iprop, it lags the game
    if(GetHasFeat(nFeat,oPC))
        return;
    IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(ip_feat_crit), 0.0f,
                          X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
}

// Grants a weapon focus in the discipline weapons.
void SwordSageDisciplineWeaponFocus(object oPC)
{
	object oSkin = GetPCSkin(oPC);
	if (GetHasFeat(FEAT_SS_DF_WF_DW, oPC))
	{
		// Discipline Weapons
		AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_FOCUS_SCIMITAR,       FEAT_WEAPON_FOCUS_SCIMITAR);
		AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_FOCUS_LIGHT_MACE,     FEAT_WEAPON_FOCUS_LIGHT_MACE);
		AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_FOCUS_SPEAR,          FEAT_WEAPON_FOCUS_SPEAR);
		AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_FOCUS_LIGHT_PICK,     FEAT_WEAPON_FOCUS_LIGHT_PICK);
		AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_FOCUS_FALCHION,       FEAT_WEAPON_FOCUS_FALCHION);
	}
	else if (GetHasFeat(FEAT_SS_DF_WF_DM, oPC))
	{
		// Discipline Weapons
		AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_FOCUS_KATANA,         FEAT_WEAPON_FOCUS_KATANA);
		AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_FOCUS_RAPIER,         FEAT_WEAPON_FOCUS_RAPIER);
		AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_FOCUS_BASTARD_SWORD,  FEAT_WEAPON_FOCUS_BASTARD_SWORD);
		AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_FOCUS_SPEAR,          FEAT_WEAPON_FOCUS_SPEAR);
	}
	else if (GetHasFeat(FEAT_SS_DF_WF_SS, oPC))
	{
		// Discipline Weapons
		AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_FOCUS_SHORT_SWORD,    FEAT_WEAPON_FOCUS_SHORT_SWORD);
		AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_FOCUS_STAFF,          FEAT_WEAPON_FOCUS_STAFF);
		AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_FOCUS_UNARMED_STRIKE, FEAT_WEAPON_FOCUS_UNARMED_STRIKE);
		AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_FOCUS_NUNCHAKU,	 	 FEAT_WEAPON_FOCUS_NUNCHAKU);
	}
	else if (GetHasFeat(FEAT_SS_DF_WF_SH, oPC))
	{
		// Discipline Weapons
		AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_FOCUS_SHORT_SWORD,    FEAT_WEAPON_FOCUS_SHORT_SWORD);
		AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_FOCUS_DAGGER,         FEAT_WEAPON_FOCUS_DAGGER);
		AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_FOCUS_UNARMED_STRIKE, FEAT_WEAPON_FOCUS_UNARMED_STRIKE);	
		AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_FOCUS_SAI,            FEAT_WEAPON_FOCUS_SAI);
	}
	else if (GetHasFeat(FEAT_SS_DF_WF_SD, oPC))
	{
		// Discipline Weapons
		AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_FOCUS_UNARMED_STRIKE, FEAT_WEAPON_FOCUS_UNARMED_STRIKE);
		AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_FOCUS_GREAT_AXE,      FEAT_WEAPON_FOCUS_GREAT_AXE);
		AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_FOCUS_GREAT_SWORD,    FEAT_WEAPON_FOCUS_GREAT_SWORD);
		AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_FOCUS_HEAVY_MACE,	 FEAT_WEAPON_FOCUS_HEAVY_MACE);
	}
	else if (GetHasFeat(FEAT_SS_DF_WF_TC, oPC))
	{
		// Discipline Weapons
		AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_FOCUS_UNARMED_STRIKE, FEAT_WEAPON_FOCUS_UNARMED_STRIKE);
		AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_FOCUS_GREAT_AXE,      FEAT_WEAPON_FOCUS_GREAT_AXE);
		AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_FOCUS_KAMA,           FEAT_WEAPON_FOCUS_KAMA);
		AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_FOCUS_KUKRI,          FEAT_WEAPON_FOCUS_KUKRI);
		AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_FOCUS_HAND_AXE,       FEAT_WEAPON_FOCUS_HAND_AXE);
	}
}

void main()
{
	object oPC = OBJECT_SELF;
	object oSkin = GetPCSkin(oPC);
	object oArmour = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
	int nArmour = GetItemACBase(oArmour);
	int nClass = GetLevelByClass(CLASS_TYPE_SWORDSAGE, oPC);

	if (GetLevelByClass(CLASS_TYPE_MONK, oPC) > 0)
	{
		SetCompositeBonus(oSkin, "SwordsageACBonus", 0, ITEM_PROPERTY_AC_BONUS);
	//	SendMessageToPC(oPC, "Setting to 0. Disabled.");
	}
	else if (((4 > nArmour && nArmour > 0) && nClass >= 2) // Light Armour only
		//:: Handles Chain Shirt
    || GetBaseAC(GetItemInSlot(INVENTORY_SLOT_CHEST, oPC)) > 3 || GetBaseAC(GetItemInSlot(INVENTORY_SLOT_CHEST, oPC)) == 4 && GetWeight(GetItemInSlot(INVENTORY_SLOT_CHEST)) <= 250)
	{
		SetCompositeBonus(oSkin, "SwordsageACBonus", GetAbilityModifier(ABILITY_WISDOM, oPC), ITEM_PROPERTY_AC_BONUS);
	}
	else
	{
		SetCompositeBonus(oSkin, "SwordsageACBonus", 0, ITEM_PROPERTY_AC_BONUS);
	}		
	
	SwordSageDisciplineWeaponFocus(oPC);
}