#include "inc_item_props"
#include "prc_class_const"

void main()
{
    // Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int nLevel = GetLevelByClass(CLASS_TYPE_THRALL_OF_GRAZZT_A, oPC)
               + GetLevelByClass(CLASS_TYPE_THRALL_OF_GRAZZT_D, oPC);

    // Bonus on certain CHA based skills
    int nBonus = nLevel >= 29 ? 9:
                 nLevel >= 25 ? 8:
                 nLevel >= 21 ? 7:
                 nLevel >= 17 ? 6:
                 nLevel >= 13 ? 5:
                 nLevel >= 11 ? 4:
                 nLevel >=  7 ? 3:
                 nLevel >=  5 ? 2:
                 nLevel >=  3 ? 1:
                 0;

    if(GetLocalInt(oSkin, "Dark_Charm_AE") == nBonus)
        return;

    SetCompositeBonus(oSkin, "Dark_Charm_AE", nBonus, ITEM_PROPERTY_SKILL_BONUS,SKILL_ANIMAL_EMPATHY);
    SetCompositeBonus(oSkin, "Dark_Charm_PF", nBonus, ITEM_PROPERTY_SKILL_BONUS,SKILL_PERFORM);
    SetCompositeBonus(oSkin, "Dark_Charm_PS", nBonus, ITEM_PROPERTY_SKILL_BONUS,SKILL_PERSUADE);
    SetCompositeBonus(oSkin, "Dark_Charm_BL", nBonus, ITEM_PROPERTY_SKILL_BONUS,SKILL_BLUFF);
}