//::///////////////////////////////////////////////
//:: Name      Bless Water
//:: FileName  sp_bless_water.nss
//:://////////////////////////////////////////////
/** @file Bless Water
Transmutation [Good]
Level: 	Clr 1, Pal 1
Components: 	V, S, M
Casting Time: 	1 minute
Range: 	Touch
Target: 	Flask of water touched
Duration: 	Instantaneous
Saving Throw: 	Will negates (object)
Spell Resistance: 	Yes (object)

This transmutation imbues a flask (1 pint) of water with positive energy, turning it into holy water.
Material Component

5 pounds of powdered silver (worth 25 gp). 
*/
////////////////////////////////////////////////////
// Author: Tenjac
// Date: 4.10.06
////////////////////////////////////////////////////

#include "prc_alterations"
#include "prc_inc_spells"

void main()
{
	if(!X2PreSpellCastCode()) return;
	
	PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);
	
	object oPC = OBJECT_SELF;
	
	CreateItemOnObject("x1_wmgrenade005", oPC, 1);
	
	PRCSetSchool();
}
	
