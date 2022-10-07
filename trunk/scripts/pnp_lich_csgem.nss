//::///////////////////////////////////////////////
//:: FileName pnp_lich_csgem
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 1/24/2004 9:39:35 AM
//:://////////////////////////////////////////////
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

// Crafts the soul gem
void main()
{
    object oPC = GetPCSpeaker();

    // Make sure the PC has enough gold
    if (!GetHasGPToSpend(oPC, 120000))
    {
        FloatingTextStringOnCreature("You do not have enough gold to craft the soul gem", oPC);
        return;
    }
    // -------------------------------------------------------------------------
    // check for sufficient XP to create
    // -------------------------------------------------------------------------
    if (!GetHasXPToSpend(oPC, 4800))
    {
        FloatingTextStrRefOnCreature(3785, oPC); // Item Creation Failed - Not enough XP
        return;
    }
    // Allow the pc to get lich levels
    SetLocalInt(oPC,"PNP_AllowLich", 0);


    // Remove some gold from the player
    SpendGP(oPC, 120000);

    // Remove some xp from the player
    SpendXP(oPC, 4800);

    // do some VFX
    CraftVFX(OBJECT_SELF);

    // Soul gem creation code
    object oSoulGem = CreateItemOnObject("soul_gem",oPC);
    itemproperty iProp = ItemPropertyCastSpell(851,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
    AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oSoulGem);

    // Trigger the level up lich check
    // - This won't reset the PC hide... so let it be handled by the rest event.
    //DelayCommand(0.1, EvalPRCFeats(oPC));
    DelayCommand(0.1, PrcFeats(oPC));

}
