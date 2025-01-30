//For crafted items

#include "prc_craft_inc"

//:: Assumes only one bane/dread can be applied
void BaneCheck(object oItem)
{
    if(!GetIsObjectValid(oItem))
        return;

    itemproperty ipDread, ipBane;
    int bDread = FALSE, bBane = FALSE;
    ipBane = GetSpecificProperty(oItem, ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP, -1, IP_CONST_DAMAGEBONUS_2d6);
    bBane = GetIsItemPropertyValid(ipBane);
    if(!bBane)
    {   //don't want to search through itemprops again
        ipDread = GetSpecificProperty(oItem, ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP, -1, IP_CONST_DAMAGEBONUS_4d6);
        bDread = GetIsItemPropertyValid(ipDread);
    }
    if(bBane || bDread)
    {
        int nRace, nBonus;
        int nEnhance = IPGetWeaponEnhancementBonus(oItem);
        if(bBane)
        {
            nRace = GetItemPropertySubType(ipBane);
        }
        else
        {
            nRace = GetItemPropertySubType(ipDread);
        }
        //Refresh enhancement bonuses in case of item upgrade
        SetCompositeBonusT(oItem, "BaseEnhancementRace", nEnhance, ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_RACIAL_GROUP, nRace);
        SetCompositeBonusT(oItem, "BaneEnhancement", (bDread) ? 4 : 2, ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_RACIAL_GROUP, nRace);
    }
}

void main()
{
    object oPC 			= OBJECT_SELF;
    object oArmor 		= GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
	object oSkin		= GetPCSkin(oPC);
    int nBonus 			= 0;
    int nCapIncrease 	= 0;
    int nLevel 			= (GetLevelByClass(CLASS_TYPE_COC, oPC));
    int nAC 			= GetBaseAC(oArmor);

    BaneCheck(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC));
    BaneCheck(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC));
	
    if (oArmor == OBJECT_INVALID)
    {
        //SendMessageToPC(GetFirstPC(), "DEBUG: prc_mithral -> Invalid armor found.");
		SetCompositeBonus(oSkin, "PRC_CRAFT_MITHRAL", 0, ITEM_PROPERTY_AC_BONUS);
        return;
    }
	
    if (nAC < 1) //:: Must be wearing armor
    {
        //SendMessageToPC(GetFirstPC(), "DEBUG: prc_mithral -> No armor found.");
		SetCompositeBonus(oSkin, "PRC_CRAFT_MITHRAL", 0, ITEM_PROPERTY_AC_BONUS);
        return;
    }	

	if(StringToInt(GetStringLeft(GetTag(oArmor), 3)) & 16) //:: TAG ID for Mithral armor
    {   
        //SendMessageToPC(GetFirstPC(), "DEBUG: prc_mithral -> Mithral armor found.");
		nCapIncrease += 2;
    }
    
	if(nCapIncrease)
    {
        
	//:: Get the maximum Dexterity bonus from armor.2da
		string sMaxDexBonus 	= Get2DACache("armor", "DEXBONUS", nAC);
		int nMaxDexBonus 		= StringToInt(sMaxDexBonus);
		
        if(nMaxDexBonus < 1)
            nBonus = 0;     //:: can't increase max dex bonus on 0 base AC armour since it's unlimited
		
        int nDexBonus = GetAbilityModifier(ABILITY_DEXTERITY, oPC);
		//SendMessageToPC(GetFirstPC(), "DEBUG: prc_mithral -> DEX bonus is "+ IntToString(nDexBonus)+".");
		
        if(nDexBonus > nMaxDexBonus)
        {
            nBonus = PRCMin(nDexBonus - nMaxDexBonus, nCapIncrease);			
        }
    
		//SendMessageToPC(GetFirstPC(), "DEBUG: prc_mithral -> nBonus is "+ IntToString(nBonus)+".");
		
		if (nLevel < 3) //:: 3rd lvl+ Champion of Corellon handles this in their class script
		{
			SetCompositeBonus(oSkin, "PRC_CRAFT_MITHRAL", nBonus, ITEM_PROPERTY_AC_BONUS);
			//SendMessageToPC(GetFirstPC(), "DEBUG: prc_mithral -> adding bonus.");
		}
		else
		{
			SetCompositeBonus(oSkin, "PRC_CRAFT_MITHRAL", 0, ITEM_PROPERTY_AC_BONUS);
			//SendMessageToPC(GetFirstPC(), "DEBUG: prc_mithral -> skipping bonus.");
		}
	}
}