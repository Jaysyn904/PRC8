//::///////////////////////////////////////////////
//:: Frenzied Berserker - Armor/Skin
//:://////////////////////////////////////////////
/*
    Script to modify skin of Frenzied Berserker
*/
//:://////////////////////////////////////////////
//:: Created By: Oni5115
//:: Created On: Feb 26, 2004
//:://////////////////////////////////////////////
#include "prc_alterations" // for checking if item is a weapon

void CheckSupremePowerAttack(object oPC, int iEquip)
{
      int bIsWeapon = FALSE;
      
      if(iEquip == 2)       // On Equip
      {
          object oWeapon = GetItemLastEquipped();
          if(IPGetIsMeleeWeapon(oWeapon) || GetWeaponRanged(oWeapon) )
          {
               bIsWeapon = TRUE;
          } 
      }
      else if(iEquip == 1)  // Unequip
      {
          object oWeapon = GetItemLastUnequipped();
          if(IPGetIsMeleeWeapon(oWeapon) || GetWeaponRanged(oWeapon) )
          {
               bIsWeapon = TRUE;
          } 
      }      
      
      if(GetHasFeatEffect(FEAT_SUPREME_POWER_ATTACK) && bIsWeapon)
      {    
          // Removes effects
          PRCRemoveSpellEffects(SPELL_SUPREME_POWER_ATTACK, oPC, oPC);

          string nMes = "*Supreme Power Attack Mode Deactivated*";
          FloatingTextStringOnCreature(nMes, OBJECT_SELF, FALSE);
      }
}

void ApplyAutoFrenzy(object oPC, object oArmor)
{
     IPSafeAddItemProperty(oArmor, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
     SetLocalInt(oPC, "AFrenzy", 2);
}

void RemoveAutoFrenzy(object oPC, object oArmor)
{
     RemoveSpecificProperty(oArmor, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", -1, DURATION_TYPE_TEMPORARY);
     SetLocalInt(oPC, "AFrenzy", 1);
}

void main()
{
    //Declare main variables.
    object oPC = OBJECT_SELF;
    object oItem;
    int iEquip = GetLocalInt(oPC, "ONEQUIP");
    
    if(GetHasFeat(FEAT_FRENZY) && GetLocalInt(oPC, "AFrenzy") == 0)
    {
        // remove bonus on error
        object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
        RemoveAutoFrenzy(oPC, oArmor);
        ApplyAutoFrenzy(oPC, oArmor);
    }    
    else if(GetHasFeat(FEAT_FRENZY) && GetLocalInt(oPC, "AFrenzy") != 0)
    {              
        if(iEquip == 2)       // On Equip
        {
             // add bonus to armor
             object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
             oItem = GetItemLastEquipped();
             
             if(oItem == oArmor)
             {
                  ApplyAutoFrenzy(oPC, oArmor); 
             }
        }
        else if(iEquip == 1)  // Unequip
        {
             oItem = GetItemLastUnequipped();
             
             if(GetBaseItemType(oItem) == BASE_ITEM_ARMOR)
             {
                  RemoveAutoFrenzy(oPC, oItem);
             }
        }
        else                  // On level, rest, or other events
        {
             object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
             RemoveAutoFrenzy(oPC, oArmor);
             ApplyAutoFrenzy(oPC, oArmor);
        }
    }
    
    CheckSupremePowerAttack(oPC, iEquip);
}
