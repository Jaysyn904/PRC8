//::///////////////////////////////////////////////
//:: Swordsage Sense Magic.
//::
/*
    Identify target item.
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: July 15, 2005
//:://////////////////////////////////////////////

#include "prc_alterations"

void main()
{
        object oItem = PRCGetSpellTargetObject();

        // Only works on these item types
        if (IPGetIsMeleeWeapon(oItem) || GetBaseItemType(oItem) == BASE_ITEM_ARMOR || GetWeaponRanged(oItem))
        {
            SetIdentified(oItem, TRUE);
        }
}

