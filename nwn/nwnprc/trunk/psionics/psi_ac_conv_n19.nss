// Determines whether the AC being edited already has Blindfight

#include "psi_inc_ac_const"
#include "psi_inc_ac_convo"


int StartingConditional()
{
    object oPC = GetPCSpeaker();
    int nFlags = GetLocalInt(oPC, ASTRAL_CONSTRUCT_OPTION_FLAGS + EDIT);
    return (nFlags & ASTRAL_CONSTRUCT_OPTION_BLINDFIGHT) == 0;
}
