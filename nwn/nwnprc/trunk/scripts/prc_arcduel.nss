#include "prc_alterations"
#include "inc_utility"


// * Applies the Arcane Duelist's AC bonus as a CompositeBonus on object's skin.
void ApparentDefense(object oPC, object oSkin)
{
    if(GetLocalInt(oSkin, "ADDef") == GetAbilityModifier(ABILITY_CHARISMA, oPC)) return;

    SetCompositeBonus(oSkin, "ADDef", GetAbilityModifier(ABILITY_CHARISMA, oPC), ITEM_PROPERTY_AC_BONUS);
}


// * Removes the Arcane Duelist's Enchant Chosen Weapon bonus
void RemoveEnchantCW(object oPC, object oWeap)
{
      if (GetLocalInt(oWeap, "ADEnchant"))
      {
         SetCompositeBonusT(oWeap, "ADEnchant", 0, ITEM_PROPERTY_ENHANCEMENT_BONUS);
      }
}

// * Applies the Arcane Duelist's Enchant Chosen Weapon bonus
void EnchantCW(object oPC, object oWeap)
{
   int iBonus = 0;

      if (GetLevelByClass(CLASS_TYPE_ARCANE_DUELIST, oPC) >= 1)
         iBonus += 1;

      if (GetLevelByClass(CLASS_TYPE_ARCANE_DUELIST, oPC) >= 4)
         iBonus += 1;

      if (GetLevelByClass(CLASS_TYPE_ARCANE_DUELIST, oPC) >= 6)
         iBonus += 1;

      if (GetLevelByClass(CLASS_TYPE_ARCANE_DUELIST, oPC) >= 8)
         iBonus += 1;

      //SendMessageToPC(oPC, "Enchant Chosen Weapon has been run");
      DelayCommand(0.1,SetCompositeBonusT(oWeap, "ADEnchant", iBonus, ITEM_PROPERTY_ENHANCEMENT_BONUS));
}

void main()
{
  object oPC = OBJECT_SELF;
  object oSkin = GetPCSkin(oPC);
  object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

  if (GetHasFeat(FEAT_AD_APPARENT_DEFENSE, oPC)) ApparentDefense(oPC, oSkin);

  if (GetLocalInt(oWeap,"CHOSEN_WEAPON") == 2)
    EnchantCW(oPC, oWeap);

  if (GetLocalInt(oPC,"ONEQUIP") == 1)
        RemoveEnchantCW(oPC, GetItemLastUnequipped());
}
