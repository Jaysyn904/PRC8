// Set the AC's level to 9

#include "psi_inc_ac_const"


const int nNewLevel = 9;

void main()
{
	object oPC = GetPCSpeaker();

	int nPrevLevel = GetLocalInt(oPC, ASTRAL_CONSTRUCT_LEVEL + EDIT);

	// If the new level is less than the previous, wipe all selected options
	if(nPrevLevel > nNewLevel)
	{
		SetLocalInt(oPC, ASTRAL_CONSTRUCT_OPTION_FLAGS       + EDIT, 0);
		SetLocalInt(oPC, ASTRAL_CONSTRUCT_RESISTANCE_FLAGS   + EDIT, 0);
		SetLocalInt(oPC, ASTRAL_CONSTRUCT_ENERGY_TOUCH_FLAGS + EDIT, 0);
		SetLocalInt(oPC, ASTRAL_CONSTRUCT_ENERGY_BOLT_FLAGS  + EDIT, 0);
	}

	SetLocalInt(oPC, ASTRAL_CONSTRUCT_LEVEL + EDIT, nNewLevel);
}