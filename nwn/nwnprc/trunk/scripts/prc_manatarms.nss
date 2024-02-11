#include "prc_inc_clsfunc"

void OnEquip(object oPC,object oSkin,int iLevel,object  oWeapR)
{
  object oItem=oWeapR;

  int bCore = 10 + GetLevelByClass(CLASS_TYPE_MANATARMS,oPC);
  if(GetHasFeat(FEAT_STRIKE_AT_CORE)&& GetLocalInt(oItem, "ManArmsCore")!= bCore)
  {
     if (GetLocalInt(oItem, "ManArmsCore"))
         RemoveSpecificProperty(oItem,ITEM_PROPERTY_ON_HIT_PROPERTIES,IP_CONST_ONHIT_ABILITYDRAIN, GetLocalInt(oItem, "ManArmsCore"),1,"ManArmsCore", IP_CONST_ABILITY_CON, DURATION_TYPE_TEMPORARY);
     DelayCommand(0.10,AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyOnHitProps(IP_CONST_ONHIT_ABILITYDRAIN,bCore,IP_CONST_ABILITY_CON),oItem,9999.0));
     SetLocalInt(oItem,"ManArmsCore",bCore);
  }
}

void OnUnEquip(object oPC,object oSkin,int iLevel,object oWeapR )
{
    object oItem=oWeapR;

    RemoveSpecificProperty(oItem,ITEM_PROPERTY_ON_HIT_PROPERTIES,IP_CONST_ONHIT_ABILITYDRAIN, -1,1,"ManArmsCore", IP_CONST_ABILITY_CON, DURATION_TYPE_TEMPORARY);
    DeleteLocalInt(oItem, "ManArmsCore");
}

void main()
{
  //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);

    int iEquip= GetLocalInt(oPC,"ONEQUIP");
    int iAtk = GetHasFeat(FEAT_LEGENDARY_PROWESS, oPC) ? 3 : 1;

    if (GetHasFeat(FEAT_LEGENDARY_PROWESS,oPC))
        SetCompositeBonus(oSkin,"ManArmsAC",2,ITEM_PROPERTY_AC_BONUS);

    if (GetHasFeat(FEAT_MASTER_CRITICAL,oPC))
        DelayCommand(6.0f, ImpCrit(oPC, oSkin));

    if (iEquip ==1)
    {
       OnUnEquip(oPC,oSkin,iAtk,GetItemLastUnequipped());
    }
    else
    {
       OnEquip(oPC,oSkin,iAtk,GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC));
       OnEquip(oPC,oSkin,iAtk,GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC));
    }

    if (GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)))
    {
        ActionCastSpellOnSelf(SPELL_MANATARMS_DAMAGE);
    }
    else
    {
        PRCRemoveEffectsFromSpell(oPC, SPELL_MANATARMS_DAMAGE);
    }
}
