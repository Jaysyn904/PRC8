// Written by Stratovarius
// Turns Attune Gem on and off.

void main()
{

     object oPC = OBJECT_SELF;
     string nMes = "";

     if(!GetLocalInt(oPC, "AttuneGem"))
     {    
	SetLocalInt(oPC, "AttuneGem", TRUE);
     	nMes = "*Attune Gem Activated*";
     }
     else     
     {
	// Removes effects
	DeleteLocalInt(oPC, "AttuneGem");
	nMes = "*Attune Gem Deactivated*";
     }

     FloatingTextStringOnCreature(nMes, oPC, FALSE);
}