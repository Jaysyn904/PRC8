
#include "prc_alterations"

void RemoveAllIP(object oItem)
{
   itemproperty ip = GetFirstItemProperty(oItem);
    int total = 0;

    while(GetIsItemPropertyValid(ip))
    {
       RemoveItemProperty(oItem, ip);
       ip = GetNextItemProperty(oItem);
    }

}

void main()
{

   if (GetMaxHenchmen() < 4)
   {
      SetMaxHenchmen(4);
   }
   
   if (!GetHasFeat(FEAT_ENERGON_COMPANION))
   {

     int nLoop, nCount;
     object oHench;
     for (nLoop=1; nLoop<=GetMaxHenchmen(); nLoop++)
     {
        oHench = GetHenchman(OBJECT_SELF, nLoop);

        if (GetResRef(oHench)=="xagya2")
        {
           RemoveHenchman(OBJECT_SELF,oHench);
           AssignCommand(oHench, SetIsDestroyable(TRUE));
           DestroyObject(oHench);
        }
     }
      return;
   }


   int nLoop, nCount;
   object oHench;
   for (nLoop=1; nLoop<=GetMaxHenchmen(); nLoop++)
   {
    oHench = GetHenchman(OBJECT_SELF, nLoop);

      if (GetIsObjectValid(oHench))  nCount++;

     if (GetResRef(oHench)=="xagya2")
     {
        RemoveHenchman(OBJECT_SELF,oHench);
        AssignCommand(oHench, SetIsDestroyable(TRUE));
        DestroyObject(oHench);
        nCount--;
     }
   }

    if (nCount >= GetMaxHenchmen()) return;


    oHench = CreateObject(OBJECT_TYPE_CREATURE,"xagya2", GetSpellTargetLocation());
    AddHenchman(OBJECT_SELF,oHench);


    object  oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST,oHench);
    object  oAmulet = GetItemInSlot(INVENTORY_SLOT_NECK,oHench);
    object  oRing1 = GetItemInSlot(INVENTORY_SLOT_LEFTRING,oHench);
    object  oRing2 = GetItemInSlot(INVENTORY_SLOT_RIGHTRING,oHench);
    object  oBelt = GetItemInSlot(INVENTORY_SLOT_BELT,oHench);
    object  oCloak = GetItemInSlot(INVENTORY_SLOT_CLOAK,oHench);
    object  oGauntlet = GetItemInSlot(INVENTORY_SLOT_ARMS,oHench);
    object  oBoot = GetItemInSlot(INVENTORY_SLOT_BOOTS,oHench);

    int iLvl = GetHitDice(OBJECT_SELF);

    int iBonus = (iLvl/5)+1;

    RemoveAllIP(oArmor);
    SetItemCursedFlag(oArmor,TRUE);
    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyACBonus(iBonus),oArmor);
    RemoveAllIP(oAmulet);
    SetItemCursedFlag(oAmulet,TRUE);
    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyAbilityBonus(IP_CONST_ABILITY_WIS,iBonus),oAmulet);
    RemoveAllIP(oRing1);
    SetItemCursedFlag(oRing1,TRUE);
    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyACBonus(iBonus),oRing1);
    RemoveAllIP(oRing2);
    SetItemCursedFlag(oRing2,TRUE);
    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusSavingThrow(IP_CONST_SAVEBASETYPE_FORTITUDE,iBonus),oRing2);
    RemoveAllIP(oBelt);
    SetItemCursedFlag(oBelt,TRUE);
    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyAbilityBonus(IP_CONST_ABILITY_STR,iBonus),oBelt);
    RemoveAllIP(oCloak);
    SetItemCursedFlag(oCloak,TRUE);
    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyAbilityBonus(IP_CONST_ABILITY_CHA,iBonus),oCloak);
    RemoveAllIP(oGauntlet);
    SetItemCursedFlag(oGauntlet,TRUE);
    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyAbilityBonus(IP_CONST_ABILITY_DEX,iBonus),oGauntlet);
    RemoveAllIP(oBoot);
    SetItemCursedFlag(oBoot,TRUE);
    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyAbilityBonus(IP_CONST_ABILITY_CON,iBonus),oBoot);

   AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageReduction(iBonus-1,(iLvl/10)),oArmor);


   int i;
   for (i = 0; i < 4; i++)
      LevelUpHenchman( oHench,CLASS_TYPE_OUTSIDER,TRUE,PACKAGE_INVALID);

   int  iFeat = GetHasFeat(FEAT_POSITIVE_ENERGY_BURST);

   if ( GetHitDice(OBJECT_SELF) >7)
   {
      int level = (GetHitDice(OBJECT_SELF)-7+iFeat*2)/2;

     for (i = 0; i < level ; i++)
      LevelUpHenchman( oHench,CLASS_TYPE_CLERIC,TRUE,PACKAGE_CLERIC_DIVINE);

     if ( (GetHitDice(OBJECT_SELF)-7+iFeat*2)!= level*2) level++;

     for (i = 0; i < level ; i++)
      LevelUpHenchman( oHench,CLASS_TYPE_OUTSIDER,TRUE,PACKAGE_INVALID);

   }


    object oCreL=GetItemInSlot(INVENTORY_SLOT_CWEAPON_L,oHench);
    object oCreR=GetItemInSlot(INVENTORY_SLOT_CWEAPON_R,oHench);

    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_POSITIVE,IP_CONST_DAMAGEBONUS_1d6),oCreL);
    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_POSITIVE,IP_CONST_DAMAGEBONUS_1d6),oCreR);


//    effect eConceal = SupernaturalEffect(EffectConcealment(50));
//    DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eConceal, oHench));



}

