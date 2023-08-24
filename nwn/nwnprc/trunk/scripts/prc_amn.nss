#include "prc_inc_function"

void main()
{
    //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
	SetCompositeBonus(oSkin, "ShadowThiefBluff", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_BLUFF);
	SetCompositeBonus(oSkin, "ShadowThiefDiplo", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_PERSUADE);
}