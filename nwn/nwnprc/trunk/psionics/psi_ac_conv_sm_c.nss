// Determines whether there are enough empty slots left to show Menu C

#include "psi_inc_ac_const"
#include "psi_inc_ac_convo"


int StartingConditional()
{
	object oPC = GetPCSpeaker();

	return (GetMaxSlotsForLevel(GetLocalInt(oPC, ASTRAL_CONSTRUCT_LEVEL + EDIT), oPC) - GetTotalNumberOfSlotsUsed(oPC)) >= MENU_C_COST;
}
