//::///////////////////////////////////////////////
//:: Races of the Dragon Feats
//:: prc_rotdfeat.nss
//::///////////////////////////////////////////////
/*
    Handles the following feats from Races of the Dragon:
    Dragon Tail
    Dragon Wings
    Dragonwrought
*/
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Nov 13, 2007
//:://////////////////////////////////////////////

void dragonwrought(object oSkin);

#include "pnp_shft_poly"
#include "prc_inc_natweap"
#include "prc_x2_itemprop"

//the feats common to all dragonwrought
void dragonwrought(object oSkin)
{
    IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_DRAGON), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    IPSafeAddItemProperty(oSkin, ItemPropertyDarkvision(), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_DRAGON_IMMUNE), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
}

void main()
{

    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int nSize = PRCGetCreatureSize(oPC);
    int nWingType;
    int nTailType;

    //wings
    if (GetHasFeat(FEAT_KOB_DRAGONWROUGHT_BK) || GetHasFeat(FEAT_DRACONIC_HERITAGE_BK)) nWingType = PRC_WING_TYPE_DRAGON_BLACK;
    else if (GetHasFeat(FEAT_KOB_DRAGONWROUGHT_BL) || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_AM) || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_SA) || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_TP) || GetHasFeat(FEAT_DRACONIC_HERITAGE_BL) || GetHasFeat(FEAT_DRACONIC_HERITAGE_AM) || GetHasFeat(FEAT_DRACONIC_HERITAGE_SA) || GetHasFeat(FEAT_DRACONIC_HERITAGE_TP)) nWingType = PRC_WING_TYPE_DRAGON_BLUE;
    else if (GetHasFeat(FEAT_KOB_DRAGONWROUGHT_GR) || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_EM) || GetHasFeat(FEAT_DRACONIC_HERITAGE_GR) || GetHasFeat(FEAT_DRACONIC_HERITAGE_EM)) nWingType = PRC_WING_TYPE_DRAGON_GREEN;
    else if (GetHasFeat(FEAT_KOB_DRAGONWROUGHT_RD) || GetHasFeat(FEAT_DRACONIC_HERITAGE_RD)) nWingType = PRC_WING_TYPE_DRAGON_RED;
    else if (GetHasFeat(FEAT_KOB_DRAGONWROUGHT_WH) || GetHasFeat(FEAT_DRACONIC_HERITAGE_WH)) nWingType = PRC_WING_TYPE_DRAGON_WHITE;
    else if (GetHasFeat(FEAT_KOB_DRAGONWROUGHT_CR) || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_SR) || GetHasFeat(FEAT_DRACONIC_HERITAGE_CR) || GetHasFeat(FEAT_DRACONIC_HERITAGE_SR)) nWingType = PRC_WING_TYPE_DRAGON_SILVER;
    else if (GetHasFeat(FEAT_KOB_DRAGONWROUGHT_BS) || GetHasFeat(FEAT_DRACONIC_HERITAGE_BS)) nWingType = PRC_WING_TYPE_DRAGON_BRASS;
    else if (GetHasFeat(FEAT_KOB_DRAGONWROUGHT_BZ) || GetHasFeat(FEAT_DRACONIC_HERITAGE_BZ)) nWingType = PRC_WING_TYPE_DRAGON_BRONZE;
    else if (GetHasFeat(FEAT_KOB_DRAGONWROUGHT_CP) || GetHasFeat(FEAT_DRACONIC_HERITAGE_CP)) nWingType = PRC_WING_TYPE_DRAGON_COPPER;
    else if (GetHasFeat(FEAT_KOB_DRAGONWROUGHT_GD) || GetHasFeat(FEAT_DRACONIC_HERITAGE_GD)) nWingType = PRC_WING_TYPE_DRAGON_GOLD;
    else nWingType = PRC_WING_TYPE_DRAGON_RED;
    
    //Tails
    if (GetHasFeat(FEAT_KOB_DRAGONWROUGHT_BK) || GetHasFeat(FEAT_DRACONIC_HERITAGE_BK)) nTailType = PRC_TAIL_TYPE_DRAGON_BLACK;
    else if (GetHasFeat(FEAT_KOB_DRAGONWROUGHT_BL) || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_AM) || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_SA) || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_TP) || GetHasFeat(FEAT_DRACONIC_HERITAGE_BL) || GetHasFeat(FEAT_DRACONIC_HERITAGE_AM) || GetHasFeat(FEAT_DRACONIC_HERITAGE_SA) || GetHasFeat(FEAT_DRACONIC_HERITAGE_TP)) nTailType = PRC_TAIL_TYPE_DRAGON_BLUE;
    else if (GetHasFeat(FEAT_KOB_DRAGONWROUGHT_GR) || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_EM) || GetHasFeat(FEAT_DRACONIC_HERITAGE_GR) || GetHasFeat(FEAT_DRACONIC_HERITAGE_EM)) nTailType = PRC_TAIL_TYPE_DRAGON_GREEN;
    else if (GetHasFeat(FEAT_KOB_DRAGONWROUGHT_RD) || GetHasFeat(FEAT_DRACONIC_HERITAGE_RD)) nTailType = PRC_TAIL_TYPE_DRAGON_RED;
    else if (GetHasFeat(FEAT_KOB_DRAGONWROUGHT_WH) || GetHasFeat(FEAT_DRACONIC_HERITAGE_WH)) nTailType = PRC_TAIL_TYPE_DRAGON_WHITE;
    else if (GetHasFeat(FEAT_KOB_DRAGONWROUGHT_CR) || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_SR) || GetHasFeat(FEAT_DRACONIC_HERITAGE_CR) || GetHasFeat(FEAT_DRACONIC_HERITAGE_SR)) nTailType = PRC_TAIL_TYPE_DRAGON_SILVER;
    else if ((GetRacialType(oPC) == RACIAL_TYPE_BOZAK) || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_BS) || GetHasFeat(FEAT_DRACONIC_HERITAGE_BS)) nTailType = PRC_TAIL_TYPE_DRAGON_BRASS;
    else if ((GetRacialType(oPC) == RACIAL_TYPE_BAAZ) || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_BZ) || GetHasFeat(FEAT_DRACONIC_HERITAGE_BZ)) nTailType = PRC_TAIL_TYPE_DRAGON_BRONZE;
    else if ((GetRacialType(oPC) == RACIAL_TYPE_KAPAK) || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_CP) || GetHasFeat(FEAT_DRACONIC_HERITAGE_CP)) nTailType = PRC_TAIL_TYPE_DRAGON_COPPER;
    else if (GetHasFeat(FEAT_KOB_DRAGONWROUGHT_GD) || GetHasFeat(FEAT_DRACONIC_HERITAGE_GD)) nTailType = PRC_TAIL_TYPE_DRAGON_GOLD;
    else nTailType = PRC_TAIL_TYPE_DRAGON_RED;

    //Adds the dragon tail
    if(GetHasFeat(FEAT_KOB_DRAGON_TAIL, oPC))
    {
        string sResRef = "prc_kobdratail_";
        sResRef += GetAffixForSize(nSize);
        if(DEBUG) DoDebug(sResRef);
        AddNaturalSecondaryWeapon(oPC, sResRef);
        DoTail(oPC, nTailType);
    }

    //Adds the wings
    if(GetHasFeat(FEAT_KOB_DRAGON_WING_A, oPC) 
       || GetHasFeat(FEAT_KOB_DRAGON_WING_BC, oPC) 
       || GetHasFeat(FEAT_KOB_DRAGON_WING_BG, oPC) 
       || GetHasFeat(FEAT_KOB_DRAGON_WING_BM, oPC))
    {
         SetCompositeBonus(oSkin, "Dragon_Glide", 10, ITEM_PROPERTY_SKILL_BONUS, SKILL_JUMP);
         DoWings(oPC, nWingType);
    }
    
    //+2 to Hide for Black, Blue, White, and Copper heritage
    if(GetHasFeat(FEAT_KOB_DRAGONWROUGHT_BK, oPC)
       || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_BL, oPC)
       || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_WH, oPC)
       || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_CP, oPC))
    {
         dragonwrought(oSkin);
         SetCompositeBonus(oSkin, "DA_Hide", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_HIDE);
    }
    
    //+2 to Appraise for Red heritage
    if(GetHasFeat(FEAT_KOB_DRAGONWROUGHT_RD, oPC))
    {
         dragonwrought(oSkin);
         SetCompositeBonus(oSkin, "DA_Appraise", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_APPRAISE);
    }
    
    //+2 to Move Silently for Green heritage
    if(GetHasFeat(FEAT_KOB_DRAGONWROUGHT_GR, oPC))
    {
         dragonwrought(oSkin);
         SetCompositeBonus(oSkin, "DA_Move_Silent", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_MOVE_SILENTLY);
    }
    
    //+2 to Persuade(Diplomacy) for Amethyst and Crystal heritage
    if(GetHasFeat(FEAT_KOB_DRAGONWROUGHT_AM, oPC)
       || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_CR, oPC))
    {
         dragonwrought(oSkin);
         SetCompositeBonus(oSkin, "DA_Persuade", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_PERSUADE);
    }
    
    //+2 to Lore for Emerald, Sapphire, and Brass Heritage.  Brass should
    //have Gather Information, using Lore as substitute.
    if(GetHasFeat(FEAT_KOB_DRAGONWROUGHT_EM, oPC)
       || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_SA, oPC)
       || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_BS, oPC))
    {
         dragonwrought(oSkin);
         SetCompositeBonus(oSkin, "DA_Lore", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_LORE);
    }
    
    //+2 to Jump for Topaz, standing in for the +2 to Swim they should have
    if(GetHasFeat(FEAT_KOB_DRAGONWROUGHT_TP, oPC))
    {
         dragonwrought(oSkin);
         SetCompositeBonus(oSkin, "DA_Jump", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_JUMP);
    }
    
    //+2 to Search for Bronze, standing in for +2 to Survival
    if(GetHasFeat(FEAT_KOB_DRAGONWROUGHT_BZ, oPC))
    {
         dragonwrought(oSkin);
         SetCompositeBonus(oSkin, "DA_Search", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_SEARCH);
    }
    
    //+2 to Heal for Gold heritage
    if(GetHasFeat(FEAT_KOB_DRAGONWROUGHT_GD, oPC))
    {
         dragonwrought(oSkin);
         SetCompositeBonus(oSkin, "DA_Heal", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_HEAL);
    }
    
    //+2 to Bluff for Silver heritage, standing in for +2 to Disguise
    if(GetHasFeat(FEAT_KOB_DRAGONWROUGHT_SR, oPC))
    {
         dragonwrought(oSkin);
         SetCompositeBonus(oSkin, "DA_Bluff", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_BLUFF);
    }
}