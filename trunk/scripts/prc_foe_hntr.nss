//::///////////////////////////////////////////////
//:: Foe Hunter
//:://////////////////////////////////////////////
/*
    Script for Foe Hunter
*/
//:://////////////////////////////////////////////
//:: Created By: Oni5115
//:: Created On: Mar 17, 2004
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_feat_const"
#include "prc_class_const"
#include "prc_spell_const"

// Stores hated foe as a local int
void SetHatedEnemyRace(object oPC)
{
     int hatedEnemy = 0;

     if( GetHasFeat(FEAT_HATED_ENEMY_DWARF, oPC) )             hatedEnemy = RACIAL_TYPE_DWARF;
     else if(GetHasFeat(FEAT_HATED_ENEMY_ELF, oPC))            hatedEnemy = RACIAL_TYPE_ELF;
     else if(GetHasFeat(FEAT_HATED_ENEMY_GNOME, oPC))          hatedEnemy = RACIAL_TYPE_GNOME;
     else if(GetHasFeat(FEAT_HATED_ENEMY_HALFLING, oPC))       hatedEnemy = RACIAL_TYPE_HALFLING;
     else if(GetHasFeat(FEAT_HATED_ENEMY_HALFELF, oPC))        hatedEnemy = RACIAL_TYPE_HALFELF;
     else if(GetHasFeat(FEAT_HATED_ENEMY_HALFORC, oPC))        hatedEnemy = RACIAL_TYPE_HALFORC;
     else if(GetHasFeat(FEAT_HATED_ENEMY_HUMAN, oPC))          hatedEnemy = RACIAL_TYPE_HUMAN;
     else if(GetHasFeat(FEAT_HATED_ENEMY_ABERRATION, oPC))     hatedEnemy = RACIAL_TYPE_ABERRATION;
     else if(GetHasFeat(FEAT_HATED_ENEMY_ANIMAL, oPC))         hatedEnemy = RACIAL_TYPE_ANIMAL;
     else if(GetHasFeat(FEAT_HATED_ENEMY_BEAST, oPC))          hatedEnemy = RACIAL_TYPE_BEAST;
     else if(GetHasFeat(FEAT_HATED_ENEMY_CONSTRUCT, oPC))      hatedEnemy = RACIAL_TYPE_CONSTRUCT;
     else if(GetHasFeat(FEAT_HATED_ENEMY_DRAGON, oPC))         hatedEnemy = RACIAL_TYPE_DRAGON;
     else if(GetHasFeat(FEAT_HATED_ENEMY_GOBLINOID, oPC))      hatedEnemy = RACIAL_TYPE_HUMANOID_GOBLINOID;
     else if(GetHasFeat(FEAT_HATED_ENEMY_MONSTROUS, oPC))      hatedEnemy = RACIAL_TYPE_HUMANOID_MONSTROUS;
     else if(GetHasFeat(FEAT_HATED_ENEMY_ORC, oPC))            hatedEnemy = RACIAL_TYPE_HUMANOID_ORC;
     else if(GetHasFeat(FEAT_HATED_ENEMY_REPTILIAN, oPC))      hatedEnemy = RACIAL_TYPE_HUMANOID_REPTILIAN;
     else if(GetHasFeat(FEAT_HATED_ENEMY_ELEMENTAL, oPC))      hatedEnemy = RACIAL_TYPE_ELEMENTAL;
     else if(GetHasFeat(FEAT_HATED_ENEMY_FEY, oPC))            hatedEnemy = RACIAL_TYPE_FEY;
     else if(GetHasFeat(FEAT_HATED_ENEMY_GIANT, oPC))          hatedEnemy = RACIAL_TYPE_GIANT;
     else if(GetHasFeat(FEAT_HATED_ENEMY_MAGICAL_BEAST, oPC))  hatedEnemy = RACIAL_TYPE_MAGICAL_BEAST;
     else if(GetHasFeat(FEAT_HATED_ENEMY_OUTSIDER, oPC))       hatedEnemy = RACIAL_TYPE_OUTSIDER;
     else if(GetHasFeat(FEAT_HATED_ENEMY_SHAPECHANGER, oPC))   hatedEnemy = RACIAL_TYPE_SHAPECHANGER;
     else if(GetHasFeat(FEAT_HATED_ENEMY_UNDEAD, oPC))         hatedEnemy = RACIAL_TYPE_UNDEAD;
     else if(GetHasFeat(FEAT_HATED_ENEMY_VERMIN, oPC))         hatedEnemy = RACIAL_TYPE_VERMIN;

     SetLocalInt(oPC, "HatedFoe", hatedEnemy);
}

// Stored DR in a local int
void SetHatedFoeDR(object oPC)
{
     int iFHLevel = GetLevelByClass(CLASS_TYPE_FOE_HUNTER, oPC);
     int iDR = iFHLevel;

     // if the level is even then DR = FH level +1
     if( (iFHLevel%2) == 0)
     {
          iDR += 1;
     }

     SetLocalInt(oPC, "HatedFoeDR", iDR);
}

void ApplyFoeHunterRancor(object oPC, object oWeapon)
{
     IPSafeAddItemProperty(oWeapon, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
     SetLocalInt(oPC, "HasFHRancor", 2);
}

void RemoveFoeHunterRancor(object oPC, object oWeapon)
{
     RemoveSpecificProperty(oWeapon, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", 1, DURATION_TYPE_TEMPORARY);
     SetLocalInt(oPC, "HasFHRancor", 1);
}

void ApplyFoeHunterDR(object oPC, object oArmor)
{
     IPSafeAddItemProperty(oArmor, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
     SetLocalInt(oPC, "HasFHDR", 2);
}

void RemoveFoeHunterDR(object oPC, object oArmor)
{
     RemoveSpecificProperty(oArmor, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", 1, DURATION_TYPE_TEMPORARY);
     SetLocalInt(oPC, "HasFHDR", 1);
}

void main()
{
    object oPC = OBJECT_SELF;

    // Stores the values in a local int for use in on-hit script
    // prevents the checks from having to run every time player get's hit
    // saving a lot of CPU cylces

    SetHatedEnemyRace(oPC);
    SetHatedFoeDR(oPC);

    object oItem;
    int iEquip = GetLocalInt(oPC, "ONEQUIP");
    int iHasFHDR = GetLocalInt(oPC, "HasFHDR");
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);

    object oWeaponR = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

    // On error - Typically when first entering a module
    if(GetHasFeat(FEAT_HATED_ENEMY_DR) && iHasFHDR == 0)
    {
        RemoveFoeHunterDR(oPC, oArmor);
        ApplyFoeHunterDR(oPC, oArmor);

        RemoveFoeHunterRancor(oPC, oWeaponR);
        ApplyFoeHunterRancor(oPC, oWeaponR);
    }
    else if(GetHasFeat(FEAT_HATED_ENEMY_DR) && iHasFHDR != 0)
    {
        if(iEquip == 2)       // On Equip
        {
             // add bonus to armor
             oItem = GetItemLastEquipped();

             if(oItem == oArmor)
             {
                  ApplyFoeHunterDR(oPC, oArmor);
             }

             ApplyFoeHunterRancor(oPC, oWeaponR);

             if(GetWeaponRanged(oWeaponR))
             {
                  object oAmmo;
                  oAmmo = GetItemInSlot(INVENTORY_SLOT_BOLTS, oPC);
                  ApplyFoeHunterRancor(oPC, oAmmo);

                  oAmmo = GetItemInSlot(INVENTORY_SLOT_BULLETS, oPC);
                  ApplyFoeHunterRancor(oPC, oAmmo);

                  oAmmo = GetItemInSlot(INVENTORY_SLOT_ARROWS, oPC);
                  ApplyFoeHunterRancor(oPC, oAmmo);
             }
        }
        else if(iEquip == 1)  // Unequip
        {
             oItem = GetItemLastUnequipped();

             if(GetBaseItemType(oItem) == BASE_ITEM_ARMOR)
             {
                  RemoveFoeHunterDR(oPC, oItem);
             }
             else
             {
                  RemoveFoeHunterRancor(oPC, oItem);
             }
        }
        else                  // On level, rest, or other events
        {
             RemoveFoeHunterDR(oPC, oArmor);
             ApplyFoeHunterDR(oPC, oArmor);
        }
    }

}