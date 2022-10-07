//::///////////////////////////////////////////////
//:: [Blood Archer Feats]
//:: [prc_bld_arch.nss]
//:://////////////////////////////////////////////
//:: Check to see which Blood Archer lvls a creature
//:: has and apply the appropriate bonuses.
//:://////////////////////////////////////////////
//:: Created By: Zedium
//:: Rewrite By: Oni5115
//:: Created On: Sept 2, 2004
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_feat_const"
#include "prc_class_const"

void main()
{
    // get the blood archer's level and stuff
    object oPC = OBJECT_SELF;
    int nBldarch = GetLevelByClass(CLASS_TYPE_BLARCHER, oPC);
    object oSkin = GetPCSkin(oPC);

    object oItem;
    int iEquip = GetLocalInt(oPC, "ONEQUIP");

    // Determine/Apply Regen Bonus
    int iRegenBonus = 0;
    if(nBldarch > 3) iRegenBonus++;
    if(nBldarch > 6) iRegenBonus++;

    SetCompositeBonus(oSkin, "BloodArcherRegen", iRegenBonus, ITEM_PROPERTY_REGENERATION);

    // Determine Blood Bow Bonus
    int iBloodBowBonus = nBldarch / 3;
    if (iEquip ==1)  iBloodBowBonus = 0;

    // Select last item equiped or unequiped.
    if (iEquip ==1)  oItem = GetItemLastUnequipped();
    //else             oItem = GetItemLastEquipped();

    // Apply proper modifications to item
    int iItemType = GetBaseItemType(oItem);
    switch (iItemType)
    {
         case BASE_ITEM_LONGBOW:
         //case BASE_ITEM_SHORTBOW:
              SetCompositeBonusT(oItem, "BloodBowAttackBonus", iBloodBowBonus, ITEM_PROPERTY_ATTACK_BONUS);
              SetCompositeBonusT(oItem, "BloodBowMightyBonus", iBloodBowBonus, ITEM_PROPERTY_MIGHTY);
              break;

         case BASE_ITEM_ARMOR:
              if (iEquip ==1)  RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", -1, DURATION_TYPE_TEMPORARY);
              else             IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
              break;
    }

    //must rest iBloodBowBonus for this bit, even if its an unequip
    oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    iBloodBowBonus = nBldarch / 3;
    if (GetBaseItemType(oItem) == BASE_ITEM_LONGBOW)
    {
        SetCompositeBonusT(oItem, "BloodBowAttackBonus", iBloodBowBonus, ITEM_PROPERTY_ATTACK_BONUS);
        SetCompositeBonusT(oItem, "BloodBowMightyBonus", iBloodBowBonus, ITEM_PROPERTY_MIGHTY);
    }

    oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
    if (GetIsObjectValid(oItem))
    {
        IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    }
}