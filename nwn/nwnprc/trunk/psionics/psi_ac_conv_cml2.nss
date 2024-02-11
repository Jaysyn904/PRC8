// Checks whether the PC can manifest an AC of level 2

#include "psi_inc_ac_const"
#include "psi_inc_psifunc"


const int nCost = 3;

int StartingConditional()
{
	object oPC = GetPCSpeaker();

	return GetManifesterLevel(oPC, GetLocalInt(oPC, "AC_Class")) >= nCost;
}