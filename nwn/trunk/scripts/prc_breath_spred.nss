//::///////////////////////////////////////////////
//:: Metabreath - Spreading Breath
//:: prc_breath_spred.nss
//::///////////////////////////////////////////////
/*
    Toggles the Spreading Breath feat on and off.
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
                  
     if(GetLocalInt(oPC, "SpreadingBreath"))
     {
         sMes = "*Spreading Breath Deactivated*";
         DeleteLocalInt(oPC,"SpreadingBreath");
     }
     else     
     {
         sMes = "*Spreading Breath Activated*";
         SetLocalInt(oPC, "SpreadingBreath", TRUE);
     }

     FloatingTextStringOnCreature(sMes, oPC, FALSE);
}