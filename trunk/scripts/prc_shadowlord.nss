
#include "prc_feat_const"
#include "prc_class_const"
#include "prc_spell_const"
#include "prc_alterations"

void Discorp(object oPC,int iEquip)
{
  object oItem ;

  if (iEquip==2)
  {
     oItem=GetItemInSlot(INVENTORY_SLOT_CHEST,oPC);
     if ( GetLocalInt(oItem,"ShaDiscorp")) return;

        AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER,1),oItem,9999.0);
        SetLocalInt(oItem,"ShaDiscorp",1);
  }
  else if (iEquip==1)
  {
      oItem=GetItemLastUnequipped();
      if (!GetLocalInt(oItem,"ShaDiscorp")) return;
         RemoveSpecificProperty(oItem,ITEM_PROPERTY_ONHITCASTSPELL,IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER,0,1,"",-1,DURATION_TYPE_TEMPORARY);
      DeleteLocalInt(oItem,"ShaDiscorp");
  }
   else
  {
     oItem=GetItemInSlot(INVENTORY_SLOT_CHEST,oPC);
     if ( !GetLocalInt(oItem,"ShaDiscorp"))
     {
       AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER,1),oItem,9999.0);
       SetLocalInt(oItem,"ShaDiscorp",1);
     }
  }


}


void main()
{

     //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);

    int bDiscor= GetHasFeat(FEAT_SHADOWDISCOPOR, oPC) ? 1 : 0;

    if (GetLocalInt(oPC,"ONENTER")) return;
    if (bDiscor>0)   Discorp(oPC,GetLocalInt(oPC,"ONEQUIP"));


}
