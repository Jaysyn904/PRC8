//::///////////////////////////////////////////////
//:: FileName pnp_lich_camulet
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 1/24/2004 9:58:39 AM
//:://////////////////////////////////////////////
// Craft the lich amulet (create one or upgrade one)
#include "prc_alterations"
#include "pnp_lich_inc"

void PrcFeats(object oPC)
{
    object oSkin = GetPCSkin(oPC);
    ScrubPCSkin(oPC, oSkin);
    DeletePRCLocalInts(oSkin);
    DeletePRCLocalIntsT(oPC);
    EvalPRCFeats(oPC);
}

void main()
{
    object oPC = GetPCSpeaker();

    object oAmulet = GetItemPossessedBy(oPC,"lichamulet");
    int nAmuletLevel = GetAmuletLevel(oAmulet);
    // Cant upgrade past level 10
    if (nAmuletLevel >= 10)
    {
        FloatingTextStringOnCreature("You can not upgrade your phlyactery anymore", oPC);
        return;
    }

    // Make sure the PC has enough gold
    if (!GetHasGPToSpend(oPC, 40000))
    {
        FloatingTextStringOnCreature("You do not have enough gold to craft the phlyactery", oPC);
        return;
    }
    // Make sure the PC has enough exp so they dont go back a level
    // -------------------------------------------------------------------------
    // check for sufficient XP to create
    // -------------------------------------------------------------------------
    if (!GetHasXPToSpend(oPC, 1600))
    {
        FloatingTextStrRefOnCreature(3785, oPC); // Item Creation Failed - Not enough XP
        return;
    }


    // Remove some gold from the player
    SpendGP(oPC, 40000);

    // Remove some xp from the player
    SpendXP(oPC, 1600);


    // Allow the pc to get lich levels
    SetLocalInt(oPC,"PNP_AllowLich", 0);

    // do some VFX
    CraftVFX(OBJECT_SELF);

    // Create the amulet if they dont have one
    if (!GetIsObjectValid(oAmulet))
    {
        // Give them the level 1 phylactery
        oAmulet = CreateItemOnObject("lichamulet",oPC);
        SetIdentified(oAmulet,TRUE);
        //- Don't return, or they won't gain their new powers until equipping/resting.
        //return;
    }
    else
        // Upgrade the amulet if they do
        LevelUpAmulet(oAmulet,nAmuletLevel+1);

    // Trigger the level up lich check
    DelayCommand(0.1, PrcFeats(oPC));
}
