// Written by Stratovarius
// Turns Blood Component on and off.

void main()
{

	object oPC = OBJECT_SELF;
	string nMes = "";
	SetLocalInt(oPC, "RuneCounter", 0);
     	nMes = "*Rune Counter Cleared*";
	FloatingTextStringOnCreature(nMes, oPC, FALSE);
}