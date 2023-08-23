#include "prc_alterations"
#include "prc_class_const"

void Lore(object oPC ,object oSkin ,int iLevel)
{

   if(GetLocalInt(oSkin, "FochlucanLore") == iLevel)
	   return;

    SetCompositeBonus(oSkin, "FochlucanLore", iLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_LORE);
}

void main()
{

//:: Declare major variables

    object oPC 		= OBJECT_SELF;
    object oSkin	= GetPCSkin(oPC);
    int nClass 		= GetLevelByClass(CLASS_TYPE_FOCHLUCAN_LYRIST, oPC);
    
	Lore(oPC, oSkin, nClass);
}