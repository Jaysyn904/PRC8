// Checks if all slots have been used. No saving partial constructs

#include "psi_inc_ac_const"
#include "psi_inc_ac_convo"


int StartingConditional()
{
	object oPC = GetPCSpeaker();
	int nACLevel = GetLocalInt(oPC, ASTRAL_CONSTRUCT_LEVEL + EDIT);

	return GetMaxSlotsForLevel(nACLevel, oPC) - GetTotalNumberOfSlotsUsed(oPC) == 0;
}