// Written by Stratovarius
// Turns Skull Talisman on and off.

void main()
{

     object oPC = OBJECT_SELF;
     string nMes = "";

     if(!GetLocalInt(oPC, "CraftSkullTalisman"))
     {    
	SetLocalInt(oPC, "CraftSkullTalisman", TRUE);
     	nMes = "*Craft Skull Talisman Activated*";
     }
     else     
     {
	// Removes effects
	DeleteLocalInt(oPC, "CraftSkullTalisman");
	nMes = "*Craft Skull Talisman Deactivated*";
     }

     FloatingTextStringOnCreature(nMes, oPC, FALSE);
}