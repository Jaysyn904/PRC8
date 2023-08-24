//::///////////////////////////////////////////////
//:: Metabreath - Maximize Breath
//:: prc_breath_max.nss
//::///////////////////////////////////////////////
/*
    Toggles the Maximize Breath feat on and off.
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
                  
     if(GetLocalInt(oPC, "MaximizeBreath"))
     {
         sMes = "*Maximize Breath Deactivated*";
         DeleteLocalInt(oPC,"MaximizeBreath");
     }
     else     
     {
         sMes = "*Maximize Breath Activated*";
         SetLocalInt(oPC, "MaximizeBreath", TRUE);
     }

     FloatingTextStringOnCreature(sMes, oPC, FALSE);
}