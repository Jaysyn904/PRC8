//::///////////////////////////////////////////////
//:: Breath Channeling - Exhale Immunity
//:: prc_breath_immun.nss
//::///////////////////////////////////////////////
/*
    Toggles Exhale Immunity on and off.
*/
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Jan 21, 2008
//:://////////////////////////////////////////////

#include "prc_alterations"

void main()
{
     string sMes = "";
     object oPC = OBJECT_SELF;
                  
     if(GetLocalInt(oPC, "ExhaleImmunity"))
     {
         sMes = "*Exhale Immunity Deselected*";
         DeleteLocalInt(oPC,"ExhaleImmunity");
     }
     else     
     {
         sMes = "*Exhale Immunity Selected*";
         SetLocalInt(oPC, "ExhaleImmunity", TRUE);
     }

     FloatingTextStringOnCreature(sMes, oPC, FALSE);
}