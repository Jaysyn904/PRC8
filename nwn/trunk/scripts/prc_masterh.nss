//::///////////////////////////////////////////////
//:: [Master Harper Feat]
//:: [prc_masterh.nss]
//:://////////////////////////////////////////////
//:: Check to see which Master Harper feats a creature
//:: has and apply the appropriate bonuses.
//:://////////////////////////////////////////////
//:: Created By: Age
//:: Created On: Feb 6, 2004
//:://////////////////////////////////////////////

#include "prc_class_const"
#include "prc_feat_const"
#include "inc_item_props"

void main()
{
    //SpawnScriptDebugger();
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int iHarperLevel = GetLevelByClass(CLASS_TYPE_MASTER_HARPER,oPC);

    // New skill to give the Master Harper a bonus to Lore from "Harper Knowledge" feat gained on level 1.
    SetCompositeBonus(oSkin, "MHHarperKnowledge", iHarperLevel, ITEM_PROPERTY_SKILL_BONUS, SKILL_LORE);

    if(GetHasFeat(FEAT_LYCANBANE, oPC))
        SetCompositeBonus(oSkin, "MHLycanbane", 5, ITEM_PROPERTY_AC_BONUS_VS_RACIAL_GROUP, IP_CONST_RACIALTYPE_SHAPECHANGER);

    if(GetHasFeat(FEAT_MILILS_EAR, oPC))
        SetCompositeBonus(oSkin, "MHMililEar", 4, ITEM_PROPERTY_SKILL_BONUS, SKILL_LISTEN);

    if(GetHasFeat(FEAT_DENEIRS_OREL,oPC))
        SetCompositeBonus(oSkin, "MHDeneirsOrel", 4, ITEM_PROPERTY_SKILL_BONUS, SKILL_SPELLCRAFT);
}