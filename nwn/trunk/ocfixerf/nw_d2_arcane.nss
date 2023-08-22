//::///////////////////////////////////////////////
//:: Check Arcane
//:: NW_D2_Arcane
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Checks if the PC is an arcane spellcaster
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 18, 2001
//:://////////////////////////////////////////////
/**
* Modified by: fluffyamoeba
* oc_fix script for PRC base spellcasters to get through the prelude
*/

#include "prc_class_const"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    if(GetLevelByClass(CLASS_TYPE_ARTIFICER, oPC)
    || GetLevelByClass(CLASS_TYPE_BARD, oPC)
    || GetLevelByClass(CLASS_TYPE_BEGUILER, oPC)
    || GetLevelByClass(CLASS_TYPE_DRAGONFIRE_ADEPT, oPC)
    || GetLevelByClass(CLASS_TYPE_DREAD_NECROMANCER, oPC)
    || GetLevelByClass(CLASS_TYPE_DUSKBLADE, oPC)
    || GetLevelByClass(CLASS_TYPE_HEXBLADE, oPC)
    || GetLevelByClass(CLASS_TYPE_PSION, oPC)
    || GetLevelByClass(CLASS_TYPE_PSYWAR, oPC)
    || GetLevelByClass(CLASS_TYPE_SORCERER, oPC)
    || GetLevelByClass(CLASS_TYPE_SHADOWCASTER, oPC)
    || GetLevelByClass(CLASS_TYPE_WARLOCK, oPC)
    || GetLevelByClass(CLASS_TYPE_WARMAGE, oPC)
    || GetLevelByClass(CLASS_TYPE_WILDER, oPC)
    || GetLevelByClass(CLASS_TYPE_WITCH, oPC)
    || GetLevelByClass(CLASS_TYPE_WIZARD, oPC))
    {
        return TRUE;
    }
    return FALSE;
}