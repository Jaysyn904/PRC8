#include "prc_inc_function" 

void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int nBonus = GetLevelByClass(CLASS_TYPE_CULTIST_SHATTERED_PEAK, oPC);
    
    SetCompositeBonus(oSkin, "ShatteredPeak_B", nBonus, ITEM_PROPERTY_SKILL_BONUS, SKILL_BLUFF);
    SetCompositeBonus(oSkin, "ShatteredPeak_I", nBonus, ITEM_PROPERTY_SKILL_BONUS, SKILL_INTIMIDATE);
}
