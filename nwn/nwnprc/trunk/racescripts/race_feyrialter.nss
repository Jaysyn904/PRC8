//::///////////////////////////////////////////////
//:: Name        Fey'ri alter self
//:: FileName    race_feyrialter
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Shane Hennessy
//:: Created On:
//:://////////////////////////////////////////////
// disguise for fey'ri

#include "pnp_shft_poly"

//internal function to remove wings
void RemoveWings(object oPC)
{
    //if not shifted
    //store current appearance to be safe 
    StoreAppearance(oPC);
    SetPersistantLocalInt(oPC, "WingsOff", TRUE);
    SetCreatureWingType(CREATURE_WING_TYPE_NONE, oPC);
}

//internal function to turn wings on
void AddWings(object oPC)
{
    //grant wings
    SetPersistantLocalInt(oPC, "WingsOff", FALSE);
    SetCreatureWingType(CREATURE_WING_TYPE_DEMON, oPC);
}

void main()
{
    object oPC = OBJECT_SELF;
    if(!GetIsPolyMorphedOrShifted(oPC))
    {
        if(!GetPersistantLocalInt(oPC, "WingsOff"))
            RemoveWings(oPC);
        else
            AddWings(oPC);
    }
    else
        FloatingTextStringOnCreature("You cannot use this ability while shifted.", oPC, FALSE);
}