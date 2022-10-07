//::///////////////////////////////////////////////
//:: Metabreath - Deactivation
//:: prc_metabrth_off.nss
//::///////////////////////////////////////////////
/*
    Turns Clinging, Lingering, or Heighten Breath off.
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
                  
     if(GetLocalInt(oPC, "HeightenBreath") > 0
        && GetSpellId() == SPELL_HEIGHTEN_OFF)
     {
         sMes = "*Heighten Breath Deactivated*";
         DeleteLocalInt(oPC,"HeightenBreath");
     }
                  
     if(GetLocalInt(oPC, "ClingingBreath") > 0
        && GetSpellId() == SPELL_CLINGING_OFF)
     {
         sMes = "*Clinging Breath Deactivated*";
         DeleteLocalInt(oPC,"ClingingBreath");
     }
                  
     if(GetLocalInt(oPC, "LingeringBreath") > 0
        && GetSpellId() == SPELL_LINGERING_OFF)
     {
         sMes = "*Lingering Breath Deactivated*";
         DeleteLocalInt(oPC,"LingeringBreath");
     }

     FloatingTextStringOnCreature(sMes, oPC, FALSE);
}