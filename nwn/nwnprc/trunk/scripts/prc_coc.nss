/*
    prc_coc

    Applies some of the passive bonuses

    By: Flaming_Sword
    Created: Oct 10, 2007
    Modified: Oct 27, 2007

*/

//compiler would completely crap itself unless this include was here
//#include "prc_alterations"
#include "prc_craft_inc"

//adds onhit: unique power, copied from swashbuckler code
void CritSTR(object oPC, int iEquip)
{
    object oItem;
    if(iEquip == 1)
    {
        oItem=GetItemLastUnequipped();
        RemoveSpecificProperty(oItem,ITEM_PROPERTY_ONHITCASTSPELL,IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER,0,1,"",-1,DURATION_TYPE_TEMPORARY);
        DeleteLocalInt(oItem,"CritHarm");
    }
    else
    {
        oItem=GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
        if(!GetLocalInt(oItem,"CritHarm"))
        {
            AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER,1),oItem,9999.0);
            SetLocalInt(oItem,"CritHarm",1);
        }
        oItem=GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
        if(!GetLocalInt(oItem,"CritHarm"))
        {
            AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER,1),oItem,9999.0);
            SetLocalInt(oItem,"CritHarm",1);
        }
    }
}

void SuperiorDefense(object oPC, int nLevel)
{
    object oSkin 	= GetPCSkin(oPC);
	object oArmor 	= GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
	
	int nDEXb		= GetAbilityModifier(ABILITY_DEXTERITY, oPC);
	int nMithral 	= 0;
	int nBonus		= 0;
	
	//SendMessageToPC(GetFirstPC(), "DEBUG: prc_coc -> PC's DEX bonus is "+ IntToString(nDEXb)+".");
	
//:: Abort CoC & Mithral checks if not wearing armor	
    if (oArmor == OBJECT_INVALID)
    {
        //SendMessageToPC(GetFirstPC(), "DEBUG: prc_coc -> No armor found, aborting.");
		SetCompositeBonus(oSkin, "SuperiorDefenseDexBonus", 0, ITEM_PROPERTY_AC_BONUS);
		SetCompositeBonus(oSkin, "PRC_CRAFT_MITHRAL", 0, ITEM_PROPERTY_AC_BONUS);
		return;		
    }

//:: Determine the base AC value of the armor
    int nAC = GetBaseAC(oArmor);
	//SendMessageToPC(GetFirstPC(), "DEBUG: prc_coc -> Base AC is "+ IntToString(nAC)+".");
	
//:: Get modifier for Mithral armor, if any.
	if(StringToInt(GetStringLeft(GetTag(oArmor), 3)) & 16) //:: TAG ID for Mithral armor
	{   
		//SendMessageToPC(GetFirstPC(), "DEBUG: prc_coc -> Mithral armor found. +2 Max DEX Bonus");
		nMithral	= 2;
		nBonus = nBonus + 2;
	}
	
//:: Get the maximum Dexterity bonus from armor.2da
	string sMaxDexBonus	= Get2DACache("armor", "DEXBONUS", nAC);
	int nMaxDexBonus 	= StringToInt(sMaxDexBonus);
	//SendMessageToPC(GetFirstPC(), "DEBUG: prc_coc -> Armor's Max DEX bonus is "+ IntToString(nMaxDexBonus)+".");

//:: Calculate the new  bonus from CoC levels
	nBonus = 1 + (nLevel - 3) / 3;
	//SendMessageToPC(GetFirstPC(), "DEBUG: prc_coc -> nBonus from class levels is "+ IntToString(nBonus)+".");
		
	//SendMessageToPC(GetFirstPC(), "DEBUG: prc_coc -> nBonus before DEX cap is "+ IntToString(nBonus)+".");
		
	if (nBonus > nDEXb) //:: Caps AC bonus @ PCs Dex bonus
	{
		nBonus == nDEXb;
	}		
		
	//SendMessageToPC(GetFirstPC(), "DEBUG: prc_coc -> nBonus after DEX cap is "+ IntToString(nBonus)+".");

    if (nAC > 3) //:: Medium armor starts @ 4 AC
    {
		int nNewDexBonus = nMaxDexBonus + nBonus;
		
		//SendMessageToPC(GetFirstPC(), "DEBUG: prc_coc -> nNewDexBonus is "+ IntToString(nNewDexBonus)+".");
		//SendMessageToPC(GetFirstPC(), "DEBUG: prc_coc -> nMithral Bonus is "+ IntToString(nMithral)+".");

	//:: Store the new Dex bonus as deflection AC on the character's skin (should be dodge)
		//SendMessageToPC(GetFirstPC(), "DEBUG: prc_coc -> Final SuperiorDefenseDexBonus is "+ IntToString(nNewDexBonus + nMithral)+".");
		SetCompositeBonus(oSkin, "SuperiorDefenseDexBonus", nNewDexBonus + nMithral, ITEM_PROPERTY_AC_BONUS);
		//SendMessageToPC(GetFirstPC(), "DEBUG: prc_coc -> -------------------------------------------");
	}
	else
	{
		if(nMithral)
		{
			//SendMessageToPC(GetFirstPC(), "DEBUG: prc_coc -> Light Mithral Armor found");
			SetCompositeBonus(oSkin, "SuperiorDefenseDexBonus", nMithral, ITEM_PROPERTY_AC_BONUS);
		}
		else
		{
			//SendMessageToPC(GetFirstPC(), "DEBUG: prc_coc -> Light Armor found");
			SetCompositeBonus(oSkin, "SuperiorDefenseDexBonus", 0, ITEM_PROPERTY_AC_BONUS);		
		}	
		
	}
	
}
		

/* void SuperiorDefense(object oPC, int nLevel)
{
	object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
	object oSkin = GetPCSkin(oPC);
	int nPen = GetItemArmourCheckPenalty(oArmor);
	int nDex = GetAbilityModifier(ABILITY_DEXTERITY, oPC);
	// Dexterity Armour check penalty reduced by 1 per 3 levels.
	int nRed = 0;
	if (nPen >= (nLevel / 3)) nRed = nLevel / 3;
	else nRed = nPen;
	
	if (nRed > 0) SetCompositeBonus(oSkin, "SuperiorDefense", nRed, ITEM_PROPERTY_AC_BONUS);
	
	else
	(SetCompositeBonus(oSkin, "SuperiorDefense", 0, ITEM_PROPERTY_AC_BONUS));
} */

void main()
{
    object oPC = OBJECT_SELF;
    int nLevel = (GetLevelByClass(CLASS_TYPE_COC, oPC));
    object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
    int nBase = GetBaseItemType(oWeapon);
    int iEquip= GetLocalInt(oPC,"ONEQUIP");

    if(nLevel >= 2)
    {
        if(GetIsObjectValid(oWeapon) &&
            ((nBase == BASE_ITEM_LONGSWORD) ||
            (nBase == BASE_ITEM_RAPIER) ||
            (nBase == BASE_ITEM_ELVEN_LIGHTBLADE) ||
            (nBase == BASE_ITEM_ELVEN_THINBLADE) ||
            (nBase == BASE_ITEM_ELVEN_COURTBLADE) ||
            (nBase == BASE_ITEM_SCIMITAR)
            ))
            ActionCastSpellOnSelf(SPELL_COC_DAMAGE);
        else
            PRCRemoveEffectsFromSpell(oPC, SPELL_COC_DAMAGE);
        CritSTR(oPC, iEquip);
    }
    if(nLevel >= 3)
    {
    	SuperiorDefense(oPC, nLevel);
    }
}