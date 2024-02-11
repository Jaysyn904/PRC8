//::///////////////////////////////////////////////
//:: Metabreath - Max Heighten Breath
//:: prc_metabrth_max.nss
//::///////////////////////////////////////////////
/*
    Sets Heighten Breath to maximum value.
*/
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Jan 23, 2008
//:://////////////////////////////////////////////

#include "prc_alterations"

void main()
{
     string sMes = "";
     object oPC = OBJECT_SELF;
     
     sMes = "*Heighten Breath Maximized*";
     SetLocalInt(oPC, "HeightenBreath", GetAbilityModifier(ABILITY_CONSTITUTION));

     FloatingTextStringOnCreature(sMes, oPC, FALSE);
}