#include "prc_alterations"
#include "prc_feat_const"
#include "prc_class_const"

void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);

    int iLevel = GetLevelByClass(CLASS_TYPE_ALAGHAR, oPC);
    int iArmorBonus = ((iLevel + 1)/3);

    SetCompositeBonus(oSkin, "SilverbeardAC", iArmorBonus, ITEM_PROPERTY_AC_BONUS);
}