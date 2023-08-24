//::///////////////////////////////////////////////
//:: Metabreath - Shape Breath
//:: prc_breath_shape.nss
//::///////////////////////////////////////////////
/*
    Toggles the Shape Breath feat on and off.
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
                  
     if(GetLocalInt(oPC, "ShapeBreath"))
     {
         sMes = "*Normal Breath Shape*";
         DeleteLocalInt(oPC,"ShapeBreath");
     }
     else     
     {
         sMes = "*Alternate Breath Shape*";
         SetLocalInt(oPC, "ShapeBreath", TRUE);
     }

     FloatingTextStringOnCreature(sMes, oPC, FALSE);
}