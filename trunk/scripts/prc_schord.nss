//::///////////////////////////////////////////////
//:: [Sublime Chord - Bardic Knowledge]
//:: [prc_schord.nss]
//:://////////////////////////////////////////////
#include "inc_item_props"
#include "prc_class_const"

void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int nLevel = GetLevelByClass(CLASS_TYPE_SUBLIME_CHORD, oPC);

    SetCompositeBonus(oSkin, "SChBardicKnowledge", nLevel, ITEM_PROPERTY_SKILL_BONUS, SKILL_LORE);
}
