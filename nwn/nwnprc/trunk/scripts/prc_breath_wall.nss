//::///////////////////////////////////////////////
//:: Breath Channeling - Exhale Barrier
//:: prc_breath_wall.nss
//::///////////////////////////////////////////////
/*
    Toggles Exhale Barrier on and off.
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
                  
     if(GetLocalInt(oPC, "ExhaleBarrier"))
     {
         sMes = "*Exhale Barrier Deselected*";
         DeleteLocalInt(oPC,"ExhaleBarrier");
     }
     else     
     {
         sMes = "*Exhale Barrier Selected*";
         SetLocalInt(oPC, "ExhaleBarrier", TRUE);
     }

     FloatingTextStringOnCreature(sMes, oPC, FALSE);
}