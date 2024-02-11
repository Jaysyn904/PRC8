// Determines whether the AC being edited already has Energy Touch - Fire

#include "psi_inc_ac_const"
#include "psi_inc_ac_convo"


int StartingConditional()
{
    object oPC = GetPCSpeaker();
    int nFlags = GetLocalInt(oPC, ASTRAL_CONSTRUCT_ENERGY_TOUCH_FLAGS + EDIT);
    return (nFlags & ELEMENT_FIRE) == 0;
}
