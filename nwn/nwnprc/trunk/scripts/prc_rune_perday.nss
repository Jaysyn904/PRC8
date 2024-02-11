// Written by Stratovarius
// Turns Blood Component on and off.

#include "prc_class_const"

void main()
{

     object oPC = OBJECT_SELF;
     string nMes = "";
     
     // Can't use this unless you're level 8
     if (GetLevelByClass(CLASS_TYPE_RUNECASTER, oPC) < 8)
     {
     	FloatingTextStringOnCreature("You are not high enough level to use this ability", oPC, FALSE);
     	return;
     }

     if(!GetLocalInt(oPC, "RuneUsesPerDay"))
     {    
     	if (GetLocalInt(oPC, "RuneCharges"))
     	{
     		DeleteLocalInt(oPC, "RuneCharges");
     		FloatingTextStringOnCreature("*Charges Deactivated*", oPC, FALSE);
     	}     
	SetLocalInt(oPC, "RuneUsesPerDay", TRUE);
     	nMes = "*Uses Per Day Activated*";
     }
     else     
     {
	// Removes effects
	DeleteLocalInt(oPC, "RuneUsesPerDay");
	nMes = "*Uses Per Day Deactivated*";
     }

     FloatingTextStringOnCreature(nMes, oPC, FALSE);
}