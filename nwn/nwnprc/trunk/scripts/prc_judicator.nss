//::///////////////////////////////////////////////
//:: Selvetarms Blessing
//:://////////////////////////////////////////////
/*
    Script to modify skin of the Drow Judicator
*/
//:://////////////////////////////////////////////
//:: Created By: Oni5115
//:: Created On: July 19, 2004
//:: Modified By: PsychicToaster
//:: Modified On: 7-31-2004
//:://////////////////////////////////////////////

#include "inc_item_props"
#include "prc_feat_const"

void main()
{
    //Declare main variables.
    object oPC = OBJECT_SELF;

    if(GetHasFeat(FEAT_SELVETARMS_BLESSING, oPC))
    {
        object oSkin = GetPCSkin(oPC);
        SetCompositeBonus(oSkin, "SelvBlessFortBonus", 3, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEBASETYPE_FORTITUDE);
        SetCompositeBonus(oSkin, "SelvBlessRefBonus",  3, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEBASETYPE_REFLEX);
        SetCompositeBonus(oSkin, "SelvBlessWillBonus", 3, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEBASETYPE_WILL);
    }
}