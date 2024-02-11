//::///////////////////////////////////////////////
//:: Mighty Contender of Kord
//:: prc_contendkord.nss
//:://////////////////////////////////////////////
//:: Applies the Contender Strength boost
//:://////////////////////////////////////////////

#include "inc_item_props"
#include "prc_class_const"

void main()
{
    object oPC = OBJECT_SELF;
    int nKord = GetLevelByClass(CLASS_TYPE_MIGHTY_CONTENDER_KORD, oPC);

    // Get the first boost at level 5
    /*if(nKord > 4)
    {
        object oSkin = GetPCSkin(oPC);
        int nBonus = nKord > 8 ? 2 : 1;
        int iTest = GetPersistantLocalInt(oPC, "NWNX_MightyContenderStr");
        int nDiff = nBonus - iTest;

        if(nDiff != 0)//only part of the bouns was applied permanently or not applied at all
            SetCompositeBonus(oSkin, "MightyContenderStrength", nDiff, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_STR);
    }*/
}