// Written by Stratovarius
// Turns Bloodseeking Spell on and off.

void main()
{

     object oPC = OBJECT_SELF;
     string nMes = "";

     if(!GetLocalInt(oPC, "BloodSeeking"))
     {    
	SetLocalInt(oPC, "BloodSeeking", TRUE);
     	nMes = "*Blood Seeking Activated*";
     }
     else     
     {
	// Removes effects
	DeleteLocalInt(oPC, "BloodSeeking");
	nMes = "*Blood Seeking Deactivated*";
     }

     FloatingTextStringOnCreature(nMes, oPC, FALSE);
}