#include "prc_class_const"
#include "inc_item_props"

void main()
{
    object oBinder = OBJECT_SELF;
    object oSkin = GetPCSkin(oBinder);
    if (GetLevelByClass(CLASS_TYPE_TENEBROUS_APOSTATE, oBinder) >= 2)
    {
        SetCompositeBonus(oSkin, "TenebrousDodge", 1, ITEM_PROPERTY_AC_BONUS);
	    SetCompositeBonus(oSkin, "TenebrousIntim", 1, ITEM_PROPERTY_SKILL_BONUS, SKILL_INTIMIDATE);
	    SetCompositeBonus(oSkin, "TenebrousBalnc", 1, ITEM_PROPERTY_SKILL_BONUS, SKILL_TUMBLE);
	    
	    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectAreaOfEffect(136, "bnd_tnb_visage", "", "")), oBinder, HoursToSeconds(24));
	}    
}