//::///////////////////////////////////////////////
//:: Metabreath - Tempest Breath
//:: prc_breath_tmpst.nss
//::///////////////////////////////////////////////
/*
    Toggles the Tempest Breath feat on and off.
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
                  
     if(GetLocalInt(oPC, "TempestBreath"))
     {
         sMes = "*Tempest Breath Deactivated*";
         DeleteLocalInt(oPC,"TempestBreath");
     }
     else     
     {
         sMes = "*Tempest Breath Activated*";
         SetLocalInt(oPC, "TempestBreath", TRUE);
     }

     FloatingTextStringOnCreature(sMes, oPC, FALSE);
}