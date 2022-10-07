//::///////////////////////////////////////////////
//:: Metabreath - Enlarge Breath
//:: prc_breath_enlrg.nss
//::///////////////////////////////////////////////
/*
    Toggles the Enlarge Breath feat on and off.
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
                  
     if(GetLocalInt(oPC, "EnlargeBreath"))
     {
         sMes = "*Enlarge Breath Deactivated*";
         DeleteLocalInt(oPC,"EnlargeBreath");
     }
     else     
     {
         sMes = "*Enlarge Breath Activated*";
         SetLocalInt(oPC, "EnlargeBreath", TRUE);
     }

     FloatingTextStringOnCreature(sMes, oPC, FALSE);
}