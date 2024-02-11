// Checks whether the PC can manifest an AC of level 6

#include "psi_inc_ac_const"
#include "psi_inc_psifunc"


const int nCost = 11;

int StartingConditional()
{
    object oPC = GetPCSpeaker();

    return GetManifesterLevel(oPC, GetLocalInt(oPC, "AC_Class")) >= nCost;
}