#include "prc_feat_const"
#include "inc_item_props"

void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    if (GetHasFeat(FEAT_VIGIL_ARMOR, oPC))
    {
        SetCompositeBonus(oSkin,"VigilantSkinBonus",2,ITEM_PROPERTY_AC_BONUS);
    }
    if (GetHasFeat(FEAT_VIGIL_HEAL, oPC))
    {
        SetCompositeBonus(oSkin,"VigilantNaturalHealing",1,ITEM_PROPERTY_REGENERATION);
    }
}