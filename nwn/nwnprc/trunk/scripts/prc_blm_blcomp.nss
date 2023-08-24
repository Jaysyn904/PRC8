// Written by Stratovarius
// Turns Blood Component on and off.

void main()
{

     object oPC = OBJECT_SELF;
     string nMes = "";

     if(!GetLocalInt(oPC, "BloodComponent"))
     {    
	SetLocalInt(oPC, "BloodComponent", TRUE);
     	nMes = "*Blood Component Activated*";
     }
     else     
     {
	// Removes effects
	DeleteLocalInt(oPC, "BloodComponent");
	nMes = "*Blood Component Deactivated*";
     }

     FloatingTextStringOnCreature(nMes, oPC, FALSE);
}