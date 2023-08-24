// Determines whether the AC being edited already has Celerity

#include "psi_inc_ac_const"
#include "psi_inc_ac_convo"


int StartingConditional()
{
    object oPC = GetPCSpeaker();
    int nFlags = GetLocalInt(oPC, ASTRAL_CONSTRUCT_OPTION_FLAGS + EDIT);
    return (nFlags & ASTRAL_CONSTRUCT_OPTION_CELERITY) == 0;
}
