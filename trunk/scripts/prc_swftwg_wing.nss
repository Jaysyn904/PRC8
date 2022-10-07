//::///////////////////////////////////////////////
//:: Wing Activation and Deactivation for Swift Wing
//:: prc_swftwg_wing.nss
//::///////////////////////////////////////////////
/*
    Handles the wing activation and deactivation for the Swift Wing class.
*/
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Nov 20, 2007
//:://////////////////////////////////////////////

#include "pnp_shft_poly"

//internal fucntion to remove wings
void RemoveSWWings(object oPC)
{
    object oSkin = GetPCSkin(oPC);
    //if not shifted
    SetPersistantLocalInt(oPC, "WingsOn", FALSE);
    int nOriginalWings = GetPersistantLocalInt(oPC, "AppearanceStoredWing");
    SetCreatureWingType(nOriginalWings, oPC);
    IPRemoveMatchingItemProperties(oSkin, ITEM_PROPERTY_SKILL_BONUS, DURATION_TYPE_TEMPORARY, SKILL_JUMP);
}

//internal function to turn wings on
void AddSWWings(object oPC)
{
    object oSkin = GetPCSkin(oPC);
    //if not shifted
    //store current appearance to be safe 
    StoreAppearance(oPC);
    //grant wings
    SetPersistantLocalInt(oPC, "WingsOn", TRUE);
    int nWingType = GetHasFeat(FEAT_DRAGON_AFFINITY_BK, oPC)     ? PRC_WING_TYPE_DRAGON_BLACK:
                  GetHasFeat(FEAT_DRAGON_AFFINITY_BL, oPC)      ? PRC_WING_TYPE_DRAGON_BLUE :
                  GetHasFeat(FEAT_DRAGON_AFFINITY_AM, oPC)      ? PRC_WING_TYPE_DRAGON_BLUE :
                  GetHasFeat(FEAT_DRAGON_AFFINITY_SA, oPC)      ? PRC_WING_TYPE_DRAGON_BLUE :
                  GetHasFeat(FEAT_DRAGON_AFFINITY_TP, oPC)      ? PRC_WING_TYPE_DRAGON_BLUE :
                  GetHasFeat(FEAT_DRAGON_AFFINITY_BS, oPC)      ? PRC_WING_TYPE_DRAGON_BRASS :
                  GetHasFeat(FEAT_DRAGON_AFFINITY_BZ, oPC)      ? PRC_WING_TYPE_DRAGON_BRONZE :
                  GetHasFeat(FEAT_DRAGON_AFFINITY_CP, oPC)      ? PRC_WING_TYPE_DRAGON_COPPER :
                  GetHasFeat(FEAT_DRAGON_AFFINITY_GD, oPC)      ? PRC_WING_TYPE_DRAGON_GOLD :
                  GetHasFeat(FEAT_DRAGON_AFFINITY_GR, oPC)      ? PRC_WING_TYPE_DRAGON_GREEN :
                  GetHasFeat(FEAT_DRAGON_AFFINITY_EM, oPC)      ? PRC_WING_TYPE_DRAGON_GREEN :
                  GetHasFeat(FEAT_DRAGON_AFFINITY_SR, oPC)      ? PRC_WING_TYPE_DRAGON_SILVER :
                  GetHasFeat(FEAT_DRAGON_AFFINITY_CR, oPC)      ? PRC_WING_TYPE_DRAGON_SILVER :
                  GetHasFeat(FEAT_DRAGON_AFFINITY_WH, oPC)      ? PRC_WING_TYPE_DRAGON_WHITE :
                  GetHasFeat(FEAT_DRAGON_AFFINITY_RD, oPC)      ? PRC_WING_TYPE_DRAGON_RED :
                  CREATURE_WING_TYPE_DRAGON;
    SetCreatureWingType(nWingType, oPC);
    AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertySkillBonus(SKILL_JUMP, 10), oSkin, 9999.0);
}

void main()
{
    object oPC = OBJECT_SELF;
    if(!GetIsPolyMorphedOrShifted(oPC))
    {
        if(!GetPersistantLocalInt(oPC, "WingsOn"))
            AddSWWings(oPC);
        else
            RemoveSWWings(oPC);
    }
    else
        FloatingTextStringOnCreature("You cannot use this ability while shifted.", oPC, FALSE);
}