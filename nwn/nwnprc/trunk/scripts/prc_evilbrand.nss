#include "prc_alterations"
#include "prc_feat_const"

/// +2 on Intimidate and Persuade /////////
void Evilbrand(object oPC ,object oSkin ,int iLevel)
{

   if(GetLocalInt(oSkin, "EvilbrandPe") == iLevel) return;
    SetCompositeBonus(oSkin, "EvilbrandPe", iLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_PERSUADE);
    SetCompositeBonus(oSkin, "EvilbrandI", iLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_INTIMIDATE);
}

void EB_app(object oPC,int iEquip,object oItem )
{

  object oPC = OBJECT_SELF;
  object oSkin = GetPCSkin(oPC);

  if (iEquip!=1)
  {

     if (GetBaseItemType(oItem)!=BASE_ITEM_INVALID)
     {
        Evilbrand(oPC, oSkin, 0);
        DeleteLocalInt(oSkin,"Evilbrand");
     }
     else
     {
        Evilbrand(oPC, oSkin, 2);
        SetLocalInt(oSkin,"Evilbrand",1);
     }

  }
  else if (iEquip==1)
  {

      if (GetBaseItemType(oItem)!= BASE_ITEM_INVALID) return;
        Evilbrand(oPC, oSkin, 2);
        SetLocalInt(oSkin,"Evilbrand",1);
  }

}

void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);

    //Check which feats the PC has
    int bEBHand;
    int bEBHead;
    int bEBChest;
    int bEBNeck;
    int bEBArm;
    if (GetHasFeat(FEAT_EB_HAND, oPC) > 0)
    {
     bEBHand = 1;
    }
    if (GetHasFeat(FEAT_EB_HEAD, oPC) > 0)
    {
     bEBHead = 1;
    }
    if (GetHasFeat(FEAT_EB_CHEST, oPC) > 0)
    {
     bEBChest = 1;
    }
    if (GetHasFeat(FEAT_EB_NECK, oPC)  > 0)
    {
     bEBNeck = 1;
    }
    if (GetHasFeat(FEAT_EB_ARM, oPC) > 0)
    {
     bEBArm = 1;
    }

    //Define the objects
    object oHand = GetItemInSlot(INVENTORY_SLOT_ARMS, oPC);
    object oHead = GetItemInSlot(INVENTORY_SLOT_HEAD, oPC);
    object oChest = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
    object oNeck = GetItemInSlot(INVENTORY_SLOT_CLOAK, oPC);
    object oArm = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);

    //Check alignment and check what bonus applies
    if(GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL)
    {
      if(bEBHand > 0)
        EB_app(oPC, GetLocalInt(oPC,"ONEQUIP"),oHand);


      if(bEBHead > 0)
        EB_app(oPC, GetLocalInt(oPC,"ONEQUIP"),oHead);

      if(bEBChest > 0)
        EB_app(oPC, GetLocalInt(oPC,"ONEQUIP"),oChest);

      if(bEBNeck > 0)
       EB_app(oPC, GetLocalInt(oPC,"ONEQUIP"),oNeck);

      if(bEBArm > 0)
       EB_app(oPC, GetLocalInt(oPC,"ONEQUIP"),oArm);

   }
   else
      Evilbrand(oPC, oSkin,0);

}

