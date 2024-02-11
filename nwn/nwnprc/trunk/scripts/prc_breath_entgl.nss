//::///////////////////////////////////////////////
//:: Breath Channeling - Entangling Exhalation
//:: prc_breath_entgl.nss
//::///////////////////////////////////////////////
/*
    Toggles Entangling Exhalation on and off.
*/
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Jan 22, 2008
//:://////////////////////////////////////////////

#include "prc_alterations"

void main()
{
     string sMes = "";
     object oPC = OBJECT_SELF;
                  
     if(GetLocalInt(oPC, "EntangleBreath"))
     {
         sMes = "*Entangling Exhalation Deactivated*";
         DeleteLocalInt(oPC,"EntangleBreath");
     }
     else     
     {
         sMes = "*Entangling Exhalation Activated*";
         SetLocalInt(oPC, "EntangleBreath", TRUE);
     }

     FloatingTextStringOnCreature(sMes, oPC, FALSE);
}