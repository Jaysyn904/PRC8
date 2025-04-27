//::///////////////////////////////////////////////
//:: [Vassal Feats]
//:: [prc_vassal.nss]
//:://////////////////////////////////////////////
//:: Check to see which Vassal of Bahamut lvls a creature
//:: has and apply the appropriate bonuses.
//:://////////////////////////////////////////////
//:: Created By: Zedium
//:: Created On: April 5, 2005
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_feat_const"
#include "prc_class_const"

void CleanExtraArmors(object oPC)
{
    // Cleanup routine variables
    object oChk;
    int nArmor4 = 0, nArmor6 = 0, nArmor8 = 0;

    // Clean up any extra armors.
    // This loop counts the armors and destroys any beyond the first one
    oChk = GetFirstItemInInventory(oPC);
    while (GetIsObjectValid(oChk))
    {
        if (GetTag(oChk) == "PlatinumArmor4")
        {
            nArmor4++;
            if (nArmor4 > 1) DestroyObject(oChk, 0.0);
        }
        else if (GetTag(oChk) == "PlatinumArmor6")
        {
            nArmor6++;
            if (nArmor6 > 1) DestroyObject(oChk, 0.0);
        }
        else if (GetTag(oChk) == "PlatinumArmor8")
        {
            nArmor8++;
            if (nArmor8 > 1) DestroyObject(oChk, 0.0);
        }
        
        oChk = GetNextItemInInventory(oPC);
    }
    // This loop gets rid of any Platinum Armor +6 and +4 if they have any +8
    if (nArmor8 > 0)
    {
        oChk = GetFirstItemInInventory(oPC);
        while (GetIsObjectValid(oChk))
        {
            if (GetTag(oChk) == "PlatinumArmor6") DestroyObject(oChk, 0.0);
            else if (GetTag(oChk) == "PlatinumArmor4") DestroyObject(oChk, 0.0);
        
            oChk = GetNextItemInInventory(oPC);
        }
    }
    // This loop gets rid of any Platinum Armor +4 if they have any +6
    else if (nArmor6 > 0)
    {
        oChk = GetFirstItemInInventory(oPC);
        while (GetIsObjectValid(oChk))
        {
            if (GetTag(oChk) == "PlatinumArmor4") DestroyObject(oChk, 0.0);
        
            oChk = GetNextItemInInventory(oPC);
        }
    }
}

void AddArmorOnhit(object oPC,int iEquip)
{
    object oItem;

    if(iEquip == 2)
    {
        oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);

        if(GetLocalInt(oItem,"Dragonwrack"))
            return;

        if(GetBaseItemType(oItem) == BASE_ITEM_ARMOR)
        {
            AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER,1),oItem,999.0);
            SetLocalInt(oItem,"Dragonwrack",1);
        }
    }
    else if(iEquip == 1)
    {
        oItem = GetItemLastUnequipped();
        if(GetBaseItemType(oItem) != BASE_ITEM_ARMOR)
            return;

        RemoveSpecificProperty(oItem,ITEM_PROPERTY_ONHITCASTSPELL,IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER,0);
        DeleteLocalInt(oItem,"Dragonwrack");
    }
    else
    {
        oItem = GetItemInSlot(INVENTORY_SLOT_CHEST,oPC);
        if(!GetLocalInt(oItem,"Dragonwrack") && GetBaseItemType(oItem) == BASE_ITEM_ARMOR)
        {
            AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER,1),oItem,999.0);
            SetLocalInt(oItem,"Dragonwrack",1);
        }
    }
}

/* 	Dragonwrack (Su): Evil dragons that strike a vassal of Bahamut or 
	are struck by him suffer grievous wounds. At 4th level, a vassal 
	of Bahamut deals +2d6 points of damage with each successful 
	melee attack made against an evil creature of the dragon type. 
	Furthermore, any such creature that strikes the vassal with a 
	natural weapon or melee weapon takes 1d6 points of damage.  */
	
void DWRightWeap(object oPC, int iEquip)
{
    object oItem;

    if (iEquip == 2) // Equipping something
    {
        oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
        if (!GetIsObjectValid(oItem)) return;

        if (GetLocalInt(oItem, "DWright"))
            return;

        int nType = GetBaseItemType(oItem);
        if (nType != BASE_ITEM_SMALLSHIELD && nType != BASE_ITEM_TOWERSHIELD && nType != BASE_ITEM_LARGESHIELD)
        {
            AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), oItem, 999.0);
            SetLocalInt(oItem, "DWright", 1);
        }
    }
    else if (iEquip == 1) // Unequipping something
    {
        oItem = GetItemLastUnequipped();
        if (!GetIsObjectValid(oItem)) return;

        int nType = GetBaseItemType(oItem);
        if (nType == BASE_ITEM_SMALLSHIELD || nType == BASE_ITEM_TOWERSHIELD || nType == BASE_ITEM_LARGESHIELD)
            return;

        RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0);
        DeleteLocalInt(oItem, "DWright");
    }
    else // Fallback (e.g., login or heartbeat refresh)
    {
        oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
        if (!GetIsObjectValid(oItem)) return;

        if (!GetLocalInt(oItem, "DWright"))
        {
            int nType = GetBaseItemType(oItem);
            if (nType != BASE_ITEM_SMALLSHIELD && nType != BASE_ITEM_TOWERSHIELD && nType != BASE_ITEM_LARGESHIELD)
            {
                AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), oItem, 999.0);
                SetLocalInt(oItem, "DWright", 1);
            }
        }
    }
}

void DWLeftWeap(object oPC, int iEquip)
{
    object oItem;

    if (iEquip == 2) // Equipping something
    {
        oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
        if (!GetIsObjectValid(oItem)) return;

        if (GetLocalInt(oItem, "DWleft"))
            return;

        int nType = GetBaseItemType(oItem);
        if (nType != BASE_ITEM_SMALLSHIELD && nType != BASE_ITEM_TOWERSHIELD && nType != BASE_ITEM_LARGESHIELD)
        {
            AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), oItem, 999.0);
            SetLocalInt(oItem, "DWleft", 1);
        }
    }
    else if (iEquip == 1) // Unequipping something
    {
        oItem = GetItemLastUnequipped();
        if (!GetIsObjectValid(oItem)) return;

        int nType = GetBaseItemType(oItem);
        if (nType == BASE_ITEM_SMALLSHIELD || nType == BASE_ITEM_TOWERSHIELD || nType == BASE_ITEM_LARGESHIELD)
            return;

        RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0);
        DeleteLocalInt(oItem, "DWleft");
    }
    else // Fallback (e.g., login or heartbeat refresh)
    {
        oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
        if (!GetIsObjectValid(oItem)) return;

        if (!GetLocalInt(oItem, "DWleft"))
        {
            int nType = GetBaseItemType(oItem);
            if (nType != BASE_ITEM_SMALLSHIELD && nType != BASE_ITEM_TOWERSHIELD && nType != BASE_ITEM_LARGESHIELD)
            {
                AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), oItem, 999.0);
                SetLocalInt(oItem, "DWleft", 1);
            }
        }
    }
}


/* void DWLeftWeap(object oPC,int iEquip)
{
  object oItem ;

  if (iEquip==2)
  {
     oItem=GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
     if ( GetLocalInt(oItem,"DWleft"))
         return;

     if (GetBaseItemType(oItem)!=BASE_ITEM_SMALLSHIELD && BASE_ITEM_TOWERSHIELD && BASE_ITEM_LARGESHIELD)
     {
        AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER,1),oItem,9999.0);

        SetLocalInt(oItem,"DWleft",1);
     }
  }
  else if (iEquip==1)
  {
      oItem=GetItemLastUnequipped();
      if (GetBaseItemType(oItem)==BASE_ITEM_SMALLSHIELD || BASE_ITEM_TOWERSHIELD || BASE_ITEM_LARGESHIELD) return;
         RemoveSpecificProperty(oItem,ITEM_PROPERTY_ONHITCASTSPELL,IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER,0);
      DeleteLocalInt(oItem,"DWleft");
  }
   else
  {
     oItem=GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
     if ( !GetLocalInt(oItem,"DWleft")&& GetBaseItemType(oItem)!=BASE_ITEM_SMALLSHIELD && BASE_ITEM_TOWERSHIELD && BASE_ITEM_LARGESHIELD)
     {
       AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER,1),oItem,9999.0);
        SetLocalInt(oItem,"DWleft",1);
     }
  }
  }
 */
void ImperiousAura(object oPC, object oSkin, int iLevel)
{
    if(GetLocalInt(oSkin, "ImperiousAura") == iLevel) return;

    SetCompositeBonus(oSkin, "ImperiousAuraA",  iLevel, ITEM_PROPERTY_SKILL_BONUS, SKILL_APPRAISE);
    SetCompositeBonus(oSkin, "ImperiousAuraP",  iLevel, ITEM_PROPERTY_SKILL_BONUS, SKILL_PERFORM);
    SetCompositeBonus(oSkin, "ImperiousAuraPe", iLevel, ITEM_PROPERTY_SKILL_BONUS, SKILL_PERSUADE);
    SetCompositeBonus(oSkin, "ImperiousAuraT",  iLevel, ITEM_PROPERTY_SKILL_BONUS, SKILL_SENSE_MOTIVE);
    SetCompositeBonus(oSkin, "ImperiousAuraB",  iLevel, ITEM_PROPERTY_SKILL_BONUS, SKILL_BLUFF);
    SetCompositeBonus(oSkin, "ImperiousAuraI",  iLevel, ITEM_PROPERTY_SKILL_BONUS, SKILL_INTIMIDATE);
}

void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int nVassal = GetLevelByClass(CLASS_TYPE_VASSAL, oPC);
    int iEquip = GetLocalInt(oPC, "ONEQUIP");

    //Imperious Aura
    if(nVassal) ImperiousAura(oPC, oSkin, (nVassal+1)/2);

    // *Level 4
    //Dragonwrack
    if(nVassal >= 4)
    {
        AddArmorOnhit(oPC, iEquip);
        DWRightWeap(oPC, iEquip);
        DWLeftWeap(oPC, iEquip);
    }

    // Clean up any extra armors
    DelayCommand(3.0, CleanExtraArmors(oPC));
}