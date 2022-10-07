//::///////////////////////////////////////////////
//:: Default On Damaged
//:: NW_C2_DEFAULT6
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    If already fighting then ignore, else determine
    combat round
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 16, 2001
//:://////////////////////////////////////////////
//::
//:: Found main script in rust monster scripts.
//:: Edited for PRC use. aser
//::

#include "prc_inc_combat"

///Checks to see if weapon is metal///
int IsItemMetal(object oItem)
{
  int nReturnVal=0;
  int type=GetBaseItemType(oItem);
   if((type==BASE_ITEM_BASTARDSWORD)
     ||type==BASE_ITEM_BATTLEAXE
     ||type==BASE_ITEM_DAGGER
     ||type==BASE_ITEM_DIREMACE
     ||type==BASE_ITEM_DOUBLEAXE
     ||type==BASE_ITEM_DWARVENWARAXE
     ||type==BASE_ITEM_GREATAXE
     ||type==BASE_ITEM_GREATSWORD
     ||type==BASE_ITEM_HALBERD
     ||type==BASE_ITEM_HANDAXE
     ||type==BASE_ITEM_HEAVYFLAIL
     ||type==BASE_ITEM_KAMA
     ||type==BASE_ITEM_KATANA
     ||type==BASE_ITEM_KUKRI
     ||type==BASE_ITEM_LIGHTFLAIL
     ||type==BASE_ITEM_LIGHTHAMMER
     ||type==BASE_ITEM_LIGHTMACE
     ||type==BASE_ITEM_LONGSWORD
     ||type==BASE_ITEM_MORNINGSTAR
     ||type==BASE_ITEM_RAPIER
     ||type==BASE_ITEM_SCIMITAR
     ||type==BASE_ITEM_SCYTHE
     ||type==BASE_ITEM_SHORTSWORD
     ||type==BASE_ITEM_SHURIKEN
     ||type==BASE_ITEM_SICKLE
     ||type==BASE_ITEM_THROWINGAXE
     ||type==BASE_ITEM_TWOBLADEDSWORD
     ||type==BASE_ITEM_WARHAMMER)
  {
    nReturnVal=2;// Mostly metal
  }
  return nReturnVal;
}

void main()
{

        object oPC = OBJECT_SELF;
        object oTarget = PRCGetSpellTargetObject();
        object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
        int iEnch = GetWeaponEnhancement(oWeapon, oPC, oTarget);
        int iAB = GetWeaponAttackBonusItemProperty(oWeapon, oPC);

    int iHit = GetAttackRoll(oTarget, OBJECT_SELF, OBJECT_INVALID, 0, 0,0,TRUE, 0.0, TOUCH_ATTACK_MELEE_SPELL);
     if (iHit > 0)
      {
        if (GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oTarget) != OBJECT_INVALID)
        {
          oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
          if (!GetWeaponRanged(oWeapon) && (IsItemMetal(oWeapon)>0))
          {
            string sWeapon = GetName(oWeapon);
            if(iEnch >= 1 || iAB >= 1)// If magical
            {
             SendMessageToPC(oPC,"The weapons magical properties resists the rust effects.");
            }
            else //if plain
            {
             SendMessageToPC(oPC,"You destroyed your opponents weapon.");
             DestroyObject(oWeapon);
             ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_IMP_ACID_L),oTarget);
            }
          }
        }


     }
}