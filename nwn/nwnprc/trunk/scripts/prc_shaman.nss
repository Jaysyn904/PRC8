#include "inc_item_props"
#include "prc_class_const"

void main()
{
    object oPC = OBJECT_SELF;

    if(GetLevelByClass(CLASS_TYPE_SHAMAN, oPC) > 4)
    {
        int nSave = GetAbilityModifier(ABILITY_CHARISMA, oPC);
        if(nSave > 0)
        {
            object oSkin = GetPCSkin(oPC);
            SetCompositeBonus(oSkin, "SpiritsFavourRef", nSave, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEBASETYPE_REFLEX);
            SetCompositeBonus(oSkin, "SpiritsFavourFort", nSave, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEBASETYPE_FORTITUDE);
            SetCompositeBonus(oSkin, "SpiritsFavourWill", nSave, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEBASETYPE_WILL);
        }
    }
}