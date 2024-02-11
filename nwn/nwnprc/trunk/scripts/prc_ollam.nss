#include "prc_alterations"
#include "prc_class_const"

void Lore(object oPC ,object oSkin ,int iLevel)
{

   if(GetLocalInt(oSkin, "OllamLore") == iLevel) return;

    SetCompositeBonus(oSkin, "OllamLore", iLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_LORE);
}

void main()
{

     //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int nClass = GetLevelByClass(CLASS_TYPE_OLLAM, oPC);
    Lore(oPC, oSkin, nClass);
}
