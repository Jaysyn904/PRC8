/* Combat medic
 *
 * Created July 17 2005
 * Author: GaiaWerewolf
 */

#include "inc_item_props"
#include "prc_class_const"

void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int nLevel = GetLevelByClass(CLASS_TYPE_COMBAT_MEDIC, oPC);

    SetCompositeBonus(oSkin, "CbtMed_Concentration", nLevel, ITEM_PROPERTY_SKILL_BONUS, SKILL_CONCENTRATION);
    SetCompositeBonus(oSkin, "CbtMed_Heal", nLevel, ITEM_PROPERTY_SKILL_BONUS, SKILL_HEAL);
}