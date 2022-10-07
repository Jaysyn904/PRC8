// Written by Stratovarius
// Turns Blood Component on and off.

void main()
{

     object oPC = OBJECT_SELF;
     string nMes = "";

     if(!GetLocalInt(oPC, "RuneCharges"))
     {  
     	if (GetLocalInt(oPC, "RuneUsesPerDay"))
     	{
     		DeleteLocalInt(oPC, "RuneUsesPerDay");
     		FloatingTextStringOnCreature("*Uses Per Day Deactivated*", oPC, FALSE);
     	}
	SetLocalInt(oPC, "RuneCharges", TRUE);
     	nMes = "*Charges Activated*";
     }
     else     
     {
	// Removes effects
	DeleteLocalInt(oPC, "RuneCharges");
	nMes = "*Charges Deactivated*";
     }

     FloatingTextStringOnCreature(nMes, oPC, FALSE);
}