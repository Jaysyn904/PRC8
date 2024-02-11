//::///////////////////////////////////////////////
//:: [Archivist - Lore Mastery]
//:: [prc_archivist.nss]
//:://////////////////////////////////////////////
#include "inc_item_props"
#include "prc_class_const"
#include "prc_feat_const"

void main()
{
    object oPC = OBJECT_SELF;
    int nLevel = GetLevelByClass(CLASS_TYPE_ARCHIVIST, oPC);

    if(nLevel > 1)
    {
        object oSkin = GetPCSkin(oPC);
        int nLoreBonus = GetHasFeat(FEAT_EPIC_LORE_MASTERY, oPC) ? nLevel / 2 : (nLevel + 3) / 5;

        SetCompositeBonus(oSkin, "Lore_Mastery", nLoreBonus, ITEM_PROPERTY_SKILL_BONUS, SKILL_LORE);
    }
}