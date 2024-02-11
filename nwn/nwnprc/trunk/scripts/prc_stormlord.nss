#include "prc_alterations"
#include "prc_feat_const"
#include "prc_ipfeat_const"

////    Resistance Electricity   ////

void ResElec(int iLevel)
{
    object oSkin = GetPCSkin(OBJECT_SELF);
    if(GetLocalInt(oSkin, "StormLResElec") == iLevel) return;

    RemoveSpecificProperty(oSkin, ITEM_PROPERTY_DAMAGE_RESISTANCE, IP_CONST_DAMAGETYPE_ELECTRICAL, GetLocalInt(oSkin, "StormLResElec"));
    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ELECTRICAL, iLevel), oSkin);
    SetLocalInt(oSkin, "StormLResElec", iLevel);
}

void ShockWeap(int iEquip)
{
    object oItem, oItem1, oItem2;

    if(iEquip == 2)        // On Equip
    {
        oItem1 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);

        if(GetLocalInt(oItem1, "STShock")) return ;
		
		oItem2 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);

        if(GetLocalInt(oItem2, "STShock")) return ;

        if(GetBaseItemType(oItem1)==BASE_ITEM_SHORTSPEAR)
        {
            AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ELECTRICAL,IP_CONST_DAMAGEBONUS_1d6),oItem,9999.0);
            SetLocalInt(oItem1, "STShock", 1);
        }
		
        if(GetBaseItemType(oItem2)==BASE_ITEM_SHORTSPEAR)
        {
            AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ELECTRICAL,IP_CONST_DAMAGEBONUS_1d6),oItem,9999.0);
            SetLocalInt(oItem2, "STShock", 1);
        }		
    }
    else if(iEquip == 1)     // Unequip
    {
        oItem = GetItemLastUnequipped();
        if(GetBaseItemType(oItem) != BASE_ITEM_SHORTSPEAR) return;
        if(GetLocalInt(oItem, "STShock"))
        {
            RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS,IP_CONST_DAMAGETYPE_ELECTRICAL,IP_CONST_DAMAGEBONUS_1d6,1,"",-1,DURATION_TYPE_TEMPORARY);
            DeleteLocalInt(oItem1, "STShock");
        }
    }
    else
    {
        oItem1 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
        if(GetLocalInt(oItem1,"STShock")) return ;
		
        oItem2 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
        if(GetLocalInt(oItem2,"STShock")) return ;		

     if (GetBaseItemType(oItem1)==BASE_ITEM_SHORTSPEAR)
     {
       AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ELECTRICAL,IP_CONST_DAMAGEBONUS_1d6),oItem1,9999.0);
       SetLocalInt(oItem1,"STShock",1);
     }
	 if (GetBaseItemType(oItem2)==BASE_ITEM_SHORTSPEAR)
     {
       AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ELECTRICAL,IP_CONST_DAMAGEBONUS_1d6),oItem2,9999.0);
       SetLocalInt(oItem2,"STShock",1);
     }
  }

}

void ShockingWeap(int iEquip)
{
  object oItem, oItem1, oItem2 ;

  if (iEquip==2)
  {
     oItem1=GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
     if ( GetLocalInt(oItem1,"STThund"))
         return;

     if (GetBaseItemType(oItem1)==BASE_ITEM_SHORTSPEAR)
     {
        AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER,1),oItem1,9999.0);

        SetLocalInt(oItem1,"STThund",1);
     }
     
	 oItem2=GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
     if ( GetLocalInt(oItem2,"STThund"))
         return;

     if (GetBaseItemType(oItem2)==BASE_ITEM_SHORTSPEAR)
     {
        AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER,1),oItem2,9999.0);

        SetLocalInt(oItem2,"STThund",1);
     }	 
  }
  else if (iEquip==1)
  {
      oItem=GetItemLastUnequipped();
      if (GetBaseItemType(oItem)!=BASE_ITEM_SHORTSPEAR) return;
         RemoveSpecificProperty(oItem,ITEM_PROPERTY_ONHITCASTSPELL,IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER,0,1,"",-1,DURATION_TYPE_TEMPORARY);
      DeleteLocalInt(oItem,"STThund");
  }
   else
  {
     oItem1=GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
     if ( !GetLocalInt(oItem,"STThund")&& GetBaseItemType(oItem1)==BASE_ITEM_SHORTSPEAR )
     {
       AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER,1),oItem1,9999.0);
        SetLocalInt(oItem1,"STThund",1);
     }
     
	 oItem2=GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
     if ( !GetLocalInt(oItem2,"STThund")&& GetBaseItemType(oItem)==BASE_ITEM_SHORTSPEAR )
     {
       AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER,1),oItem2,9999.0);
        SetLocalInt(oItem2,"STThund",1);
     }	 
  }


}


void main()
{
    //Declare main variables.
    int bEquip = GetLocalInt(OBJECT_SELF, "ONEQUIP");

    int bResElec;
    if(GetHasFeat(FEAT_ELECTRIC_RES_30))      bResElec = IP_CONST_DAMAGERESIST_500;//immunity
    else if(GetHasFeat(FEAT_ELECTRIC_RES_20)) bResElec = IP_CONST_DAMAGERESIST_20;
    else if(GetHasFeat(FEAT_ELECTRIC_RES_15)) bResElec = IP_CONST_DAMAGERESIST_15;
    else if(GetHasFeat(FEAT_ELECTRIC_RES_10)) bResElec = IP_CONST_DAMAGERESIST_10;

    if(bResElec) ResElec(bResElec);
    if(GetHasFeat(FEAT_SHOCK_WEAPON)) ShockWeap(bEquip);
    if(GetHasFeat(FEAT_THUNDER_WEAPON)) ShockingWeap(bEquip);
}