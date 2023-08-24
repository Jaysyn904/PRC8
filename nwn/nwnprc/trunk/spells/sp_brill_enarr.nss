//::///////////////////////////////////////////////
//:: Name      Brilliant Energy Arrow
//:: FileName  sp_brill_enarr.nss
//:://////////////////////////////////////////////
/** @file Brilliant Energy Arrow
Transmutation
Level: Assassin 2, ranger 2, justice of weald and woe 2
Components: V, M
Casting Time: 1 swift action
Range: Self
Target: One magical or masterwork arrow or bolt
Duration: Instantaneous
Saving Throw: None
Spell Resistance: Yes

When this spell is cast, a masterwork arrow or bolt, its head transforms
into brilliant energy. A brilliant energy missile ignores nonliving matter.
Armor bonuses to AC (including any enhancement bonuses to that
armor) do not count against it because the missile passes through
armor. It deals normal damage and has no effect on constructs,
undead, and objects. 

Material Component: Magical or masterwork arrow or bolt.


Author:    Tenjac
Created:   8/14/08
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_craft_inc"
#include "prc_inc_combat"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);

    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nCasterLvl = PRCGetCasterLevel(oPC);
    object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    int nType = GetBaseItemType(oWeap);
    object oAmmo;
    effect eVis;

    //Has to be a bow of some sort
    if(nType != BASE_ITEM_LONGBOW && 
    nType != BASE_ITEM_SHORTBOW &&
    nType != BASE_ITEM_LIGHTCROSSBOW && 
    nType != BASE_ITEM_HEAVYCROSSBOW)
    {
        PRCSetSchool();
        return;
    }

    //Doesn't work on non-living
    if(!PRCGetIsAliveCreature(oTarget))
    {
        SendMessageToPC(oPC, "Invalid target type; target is not living.");
        return;
    }

    if(nType == BASE_ITEM_LONGBOW || nType == BASE_ITEM_SHORTBOW)
    {
        oAmmo = GetItemInSlot(INVENTORY_SLOT_ARROWS, oPC);
    }
    
    else if (nType == BASE_ITEM_LIGHTCROSSBOW || nType == BASE_ITEM_HEAVYCROSSBOW)
    {
        oAmmo = GetItemInSlot(INVENTORY_SLOT_BOLTS, oPC);
    }

    //Check for Masterwork or magical
    string sMaterial = GetStringLeft(GetTag(oAmmo), 3);

    if((!(GetMaterialString(StringToInt(sMaterial)) == sMaterial && sMaterial != "000") && !GetIsMagicItem(oAmmo)))
    {
        PRCSetSchool();
        SendMessageToPC(oPC, "Invalid ammo type.");
        return;
    }

    //Get armor bonuses - Armor
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oTarget);
    int nBonus = GetAC(oArmor);

    //Helm
    object oHelm = GetItemInSlot(INVENTORY_SLOT_HEAD, oTarget);
    nBonus += GetItemACValue(oHelm);

    //Perform the attack with specified bonus
    PerformAttack(oTarget, oPC, eVis, 0.0, nBonus);

    PRCSetSchool();
}