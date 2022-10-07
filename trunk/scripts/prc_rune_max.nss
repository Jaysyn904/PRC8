// Written by Stratovarius
// Turns Blood Component on and off.

void main()
{

     object oPC = OBJECT_SELF;
     string nMes = "";

     if(!GetLocalInt(oPC, "MaximizeRune"))
     {    
	SetLocalInt(oPC, "MaximizeRune", TRUE);
     	nMes = "*Maximize Rune Activated*";
     }
     else     
     {
	// Removes effects
	DeleteLocalInt(oPC, "MaximizeRune");
	nMes = "*Maximize Rune Deactivated*";
     }

     FloatingTextStringOnCreature(nMes, oPC, FALSE);
}