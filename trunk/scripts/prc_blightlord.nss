#include "prc_alterations"
#include "prc_feat_const"
#include "prc_ipfeat_const"
#include "prc_class_const"

void BLKGlaive(object oPC,int iEquip)
{
	FloatingTextStringOnCreature("Black Glaive is firing", OBJECT_SELF, FALSE);
	object oItem;

	if (iEquip==2)        // On Equip
	{
		FloatingTextStringOnCreature("Black Glaive is equipped", OBJECT_SELF, FALSE);
		FloatingTextStringOnCreature("Value of BKGlaive: " + IntToString(GetLocalInt(oPC,"BKGlaive")), OBJECT_SELF, FALSE);
		
		oItem=GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
		if (GetLocalInt(oPC,"BKGlaive")) return;

		if (GetBaseItemType(oItem)==BASE_ITEM_HALBERD)
		{
			FloatingTextStringOnCreature("Black Glaive is a Halberd", OBJECT_SELF, FALSE);
			AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_COLD,IP_CONST_DAMAGEBONUS_1d6),oItem,9999.0);
			SetLocalInt(oPC,"BKGlaive",1);
			FloatingTextStringOnCreature("Value of BKGlaive: " + IntToString(GetLocalInt(oPC,"BKGlaive")), OBJECT_SELF, FALSE);
			FloatingTextStringOnCreature("Applied Blightlord Cold Damage", OBJECT_SELF, FALSE);
		}
	}
	
	
	else if (iEquip==1)     // Unequip
	{
		FloatingTextStringOnCreature("Black Glaive is unequipped", OBJECT_SELF, FALSE);
		
		oItem=GetItemLastUnequipped();
		//if (GetBaseItemType(oItem)!=BASE_ITEM_HALBERD) return;

		FloatingTextStringOnCreature("Unequipped item is a Halberd", OBJECT_SELF, FALSE);
		
		FloatingTextStringOnCreature("Value of BKGlaive: " + IntToString(GetLocalInt(oPC,"BKGlaive")), OBJECT_SELF, FALSE);

		if (GetLocalInt(oPC,"BKGlaive"))
		{
SpawnScriptDebugger();
			RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS,IP_CONST_DAMAGETYPE_COLD,IP_CONST_DAMAGEBONUS_1d6,1,"",-1,DURATION_TYPE_TEMPORARY);
			FloatingTextStringOnCreature("Removed Blightlord Cold Damage", OBJECT_SELF, FALSE);		
			DeleteLocalInt(oPC,"BKGlaive");
			FloatingTextStringOnCreature("Value of BKGlaive: " + IntToString(GetLocalInt(oPC,"BKGlaive")), OBJECT_SELF, FALSE);
		}
	}
	/*else
	{
		FloatingTextStringOnCreature("Black Glaive is in Else statement", OBJECT_SELF, FALSE);
		
		oItem=GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
		//if (GetLocalInt(oPC,"BKGlaive")) return;

		if (GetBaseItemType(oItem)==BASE_ITEM_HALBERD)
		{
			FloatingTextStringOnCreature("Black Glaive is an ELSE Halberd", OBJECT_SELF, FALSE);
			AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_COLD,IP_CONST_DAMAGEBONUS_1d6),oItem,9999.0);
			//SetLocalInt(oPC,"BKGlaive",1);
			FloatingTextStringOnCreature("Applied Blightlord Cold Damage", OBJECT_SELF, FALSE);
		}
	}*/
}
/*

void RemoveBlackGlaive(object oPC, object oWeap)
{
    FloatingTextStringOnCreature("Remove Black Glaive is firing", OBJECT_SELF, FALSE);

    RemoveSpecificProperty(oWeap, ITEM_PROPERTY_DAMAGE_BONUS, IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d6, 1, "BlackGlaive", -1, DURATION_TYPE_TEMPORARY);
    DeleteLocalInt(oWeap, "BlackGlaive");
}

void AddBlackGlaive(object oPC, object oWeap)
{
    if(GetLocalInt(oWeap, "BlackGlaive") == TRUE) return;

    FloatingTextStringOnCreature("Add Black Glaive is firing", OBJECT_SELF, FALSE);

    RemoveBlackGlaive(oPC, oWeap);
    DelayCommand(0.1, AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGEBONUS_1d6), oWeap, 999999.0));
    SetLocalInt(oWeap, "BlackGlaive", TRUE);
}
*/
void Corrupt(object oPC, int iEquip)
{
	object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);

	if(iEquip == 2)
	{
    		oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
		if(GetLocalInt(oItem,"CorruptGlaive")) return ;

		if(GetBaseItemType(oItem) == BASE_ITEM_HALBERD)
		{
			AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyOnHitProps(IP_CONST_ONHIT_WOUNDING,IP_CONST_ONHIT_SAVEDC_20),oItem,9999.0);
			SetLocalInt(oItem,"CorruptGlaive",1);
		}
	}

	else if(iEquip == 1)
	{
		oItem = GetItemLastUnequipped();
		if(GetBaseItemType(oItem) != BASE_ITEM_HALBERD) return;

		if(GetLocalInt(oItem,"CorruptGlaive"))
			RemoveSpecificProperty(oItem,ITEM_PROPERTY_ON_HIT_PROPERTIES,IP_CONST_ONHIT_WOUNDING,IP_CONST_ONHIT_SAVEDC_20,1,"",-1,DURATION_TYPE_TEMPORARY);
		DeleteLocalInt(oItem, "CorruptGlaive");
	}
	
	else
	{
    		oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
		if(GetLocalInt(oItem,"CorruptGlaive")) return ;

		if(GetBaseItemType(oItem) == BASE_ITEM_HALBERD)
		{
			AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyOnHitProps(IP_CONST_ONHIT_WOUNDING,IP_CONST_ONHIT_SAVEDC_20),oItem,9999.0);
			SetLocalInt(oItem,"CorruptGlaive",1);
		}
	}
}

//Immunity to Disease - Blightblood
void BltBlood(object oPC, object oSkin)
{
	if(GetLocalInt(oSkin, "BlightBlood") == 1)
		return;

	AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_DISEASE), oSkin);

	SetLocalInt(oSkin, "BlightBlood", 1);
	//SendMessageToPC(oPC, "Blightblood is firing");
}

//Plant Type Gained - Winterheart
void Winterheart(object oPC ,object oSkin )
{
	if(GetLocalInt(oSkin, "WntrHeart") == 1)
   		return;

	AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_CHARM_PERSON),oSkin);
	AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_DOMINATE_PERSON),oSkin);
	AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_HOLD_PERSON),oSkin);
	AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_MASS_CHARM),oSkin);
	AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_MINDSPELLS), oSkin);
	AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_POISON), oSkin);
	AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_PARALYSIS), oSkin);
	AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_CRITICAL_HITS), oSkin);
   	AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_DISEASE), oSkin);
	AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_BACKSTAB), oSkin);

	SetLocalInt(oSkin, "WntrHeart",1);
	SendMessageToPC(oPC, "Winterheart is Firing");
}

void main()
{
	object oPC = OBJECT_SELF;
	object oSkin = GetPCSkin(oPC);
    	object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    	object oUnequip = GetItemLastUnequipped();
    	int iEquip = GetLocalInt(oPC, "ONEQUIP");
/*	
    	if(GetLevelByClass(CLASS_TYPE_BLIGHTLORD) >= 6)
    	{
    	   	if (iEquip == 1)    RemoveBlackGlaive(oPC, oUnequip);
    		if (iEquip == 2)    AddBlackGlaive(oPC, oWeap);
    	}
*/

	SendMessageToPC(oPC, "Blightlord Main is Firing");
	if(GetLevelByClass(CLASS_TYPE_BLIGHTLORD) >= 1)
      		BltBlood(oPC, oSkin);

	if(GetLevelByClass(CLASS_TYPE_BLIGHTLORD) >= 6)
        	BLKGlaive(oPC, GetLocalInt(oPC,"ONEQUIP"));

	if(GetLevelByClass(CLASS_TYPE_BLIGHTLORD) >= 8)
        	Corrupt(oPC, GetLocalInt(oPC,"ONEQUIP"));

	if(GetLevelByClass(CLASS_TYPE_BLIGHTLORD) >= 10)
        	Winterheart(oPC, oSkin);
}




