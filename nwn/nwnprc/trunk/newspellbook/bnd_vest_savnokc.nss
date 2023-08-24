/*
01/03/21 by Stratovarius

Savnok, the Instigator
  
Granted Abilities: 
Savnok grants you abilities associated with his death and the command of allies’ positions.

Call Armor: At will as a full-round action, you can summon a suit of full plate armor, which appears about your body. As you attain higher effective binder levels, the armor’s
quality improves, as given on the following table. At 5th level, it becomes +1. At 9th level, +2. At 13th level, it grants immunity to sneak attacks. At 17th level, +4. 
At 20th level, immunity to critical hits. You can dismiss the armor with another full-round action.
*/

#include "bnd_inc_bndfunc"

void SavnokDamageResist(object oBinder, object oArmor, int nLevel)
{
    int nDR = IP_CONST_DAMAGERESIST_1;
    if (nLevel >= 36)      nDR = IP_CONST_DAMAGERESIST_10;
    else if (nLevel >= 32) nDR = IP_CONST_DAMAGERESIST_9;
    else if (nLevel >= 28) nDR = IP_CONST_DAMAGERESIST_8;
    else if (nLevel >= 24) nDR = IP_CONST_DAMAGERESIST_7;
    else if (nLevel >= 20) nDR = IP_CONST_DAMAGERESIST_6;
    else if (nLevel >= 16) nDR = IP_CONST_DAMAGERESIST_5;
    else if (nLevel >= 12) nDR = IP_CONST_DAMAGERESIST_4;
    else if (nLevel >= 8)  nDR = IP_CONST_DAMAGERESIST_3;
    else if (nLevel >= 4)  nDR = IP_CONST_DAMAGERESIST_2;
													   
    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_SLASHING, nDR), oArmor);
    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_BLUDGEONING, nDR), oArmor);
}

void main()
{
	object oBinder = OBJECT_SELF;
	
    object oArmor = GetItemPossessedBy(oBinder, "SavnokCallArmor");
    if (GetIsObjectValid(oArmor))
    {
    	SetPlotFlag(oArmor, FALSE);
		DestroyObject(oArmor);	
	}	
	else
	{
		int nBinderLevel = GetBinderLevel(oBinder, VESTIGE_SAVNOK);
		oArmor = CreateItemOnObject("nw_aarcl007", oBinder, 1, "SavnokCallArmor");
		if (nBinderLevel >= 17) IPSafeAddItemProperty(oArmor, ItemPropertyACBonus(4));
		else if (nBinderLevel >= 9) IPSafeAddItemProperty(oArmor, ItemPropertyACBonus(2));
		else if (nBinderLevel >= 5) IPSafeAddItemProperty(oArmor, ItemPropertyACBonus(1));
		if (nBinderLevel >= 13) IPSafeAddItemProperty(oArmor, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_BACKSTAB));
		if (nBinderLevel >= 20) IPSafeAddItemProperty(oArmor, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_CRITICAL_HITS));
		
    	if (GetLevelByClass(CLASS_TYPE_BINDER, oBinder) || GetHasFeat(FEAT_PRACTICED_BINDER, oBinder))	
    	{
    		if (!GetIsVestigeExploited(oBinder, VESTIGE_SAVNOK_SAVNOKS_ARMOR)) SavnokDamageResist(oBinder, oArmor, nBinderLevel);
    	}
		
        SetDroppableFlag(oArmor, FALSE);
        SetItemCursedFlag(oArmor, TRUE); 	
        SetPlotFlag(oArmor, TRUE);
		SetName(oArmor, "Savnok's Gift");
		SetLocalInt(oBinder, "SavnokDelay", TRUE);
		DelayCommand(1.5, DeleteLocalInt(oBinder, "SavnokDelay"));		
		AssignCommand(oBinder, ActionEquipItem(oArmor, INVENTORY_SLOT_CHEST));
	}	
}
