//::///////////////////////////////////////////////
//:: Name       racial appearance enforcenemt
//:: FileName  race_appear
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This script make sure a character is only useing
    an appearance that is allowed by their race.
    Takes transformational classes into account too.
    Also applies wings/tails when appropriate
    
    Note: Rather than the simplistic Appearance column
    in racialtypes.2da this takes the data from
    racialappear.2da 

*/
//:://////////////////////////////////////////////
//:: Created By: Primogrnitor
//:: Created On: 13/9/06
//:://////////////////////////////////////////////


#include "prc_alterations"

void main()
{
    object oPC = OBJECT_SELF;
    if(GetIsPolyMorphedOrShifted(oPC))
        return;

    int nRace = GetRacialType(oPC);
    int nCurrAppear = GetAppearanceType(oPC);
    int nNewAppear  = nCurrAppear;
    int nCurrWings  = GetCreatureWingType(oPC);
    int nNewWings   = nCurrWings;
    int nCurrTail   = GetCreatureTailType(oPC);
    int nNewTail    = nCurrTail;

    //race checks
    //appearance
    nNewAppear = StringToInt(Get2DACache("racialtypes", "Appearance", nRace));
    //wings
    //tails

    //class checks
    //appearance
    if(GetLevelByClass(CLASS_TYPE_LICH, oPC) >= 10)
        nNewAppear = APPEARANCE_TYPE_DEMI_LICH;
    else if(GetLevelByClass(CLASS_TYPE_LICH, oPC) >= 4)
        nNewAppear = APPEARANCE_TYPE_LICH;
    //wings
    //tails

    //set it if it changes
    if(nNewAppear != nCurrAppear)
        SetCreatureAppearanceType(oPC, nNewAppear);
    if(nNewTail != nCurrTail)
        SetCreatureTailType(nNewTail, oPC);
    if(nNewWings != nCurrWings)
        SetCreatureWingType(nNewWings, oPC);
}