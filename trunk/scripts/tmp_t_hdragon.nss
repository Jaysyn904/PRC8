//::///////////////////////////////////////////////
//:: Name           Half-Dragon template test script
//:: FileName       tmp_t_hdragon.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

Half-Dragon

"Half-dragon" is an inherited template that can be
added to any living, corporeal creature (referred to
hereafter as the base creature).

*/
//:://////////////////////////////////////////////
//:: Created By: xwarren
//:: Created On: 25/04/10
//:://////////////////////////////////////////////

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);

    if(GetLevelByClass(CLASS_TYPE_DRAGON_DISCIPLE, oPC))
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);

    int nRace = MyPRCGetRacialType(oPC);
    if(nRace != RACIAL_TYPE_DWARF
        && nRace != RACIAL_TYPE_ELF
        && nRace != RACIAL_TYPE_GNOME
        && nRace != RACIAL_TYPE_HALFLING
        && nRace != RACIAL_TYPE_HALFELF
        && nRace != RACIAL_TYPE_HALFORC
        && nRace != RACIAL_TYPE_HUMAN
        && nRace != RACIAL_TYPE_HUMANOID_GOBLINOID
        && nRace != RACIAL_TYPE_HUMANOID_MONSTROUS
        && nRace != RACIAL_TYPE_HUMANOID_ORC
        && nRace != RACIAL_TYPE_HUMANOID_REPTILIAN
        && nRace != RACIAL_TYPE_ABERRATION
        && nRace != RACIAL_TYPE_ANIMAL
        && nRace != RACIAL_TYPE_BEAST
        && nRace != RACIAL_TYPE_ANIMAL
        && nRace != RACIAL_TYPE_DRAGON
        && nRace != RACIAL_TYPE_FEY
        && nRace != RACIAL_TYPE_GIANT
        && nRace != RACIAL_TYPE_MAGICAL_BEAST
        && nRace != RACIAL_TYPE_VERMIN
        //&& nRace != RACIAL_TYPE_CONSTRUCT
        && nRace != RACIAL_TYPE_ELEMENTAL
        && nRace != RACIAL_TYPE_OUTSIDER
        && nRace != RACIAL_TYPE_SHAPECHANGER
        //&& nRace != RACIAL_TYPE_UNDEAD
        && nRace != RACIAL_TYPE_OOZE
        )
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
}