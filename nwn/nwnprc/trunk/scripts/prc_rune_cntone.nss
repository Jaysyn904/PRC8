// Written by Stratovarius
// Turns Blood Component on and off.

void main()
{

	object oPC = OBJECT_SELF;
	string nMes = "";

	int nCount = GetLocalInt(oPC, "RuneCounter");
	nCount += 1;
	if (nCount > 50) nCount = 50;
	SetLocalInt(oPC, "RuneCounter", nCount);	
	nMes = "*Rune Counter Value is: " + IntToString(nCount) + "*";
	FloatingTextStringOnCreature(nMes, oPC, FALSE);
}