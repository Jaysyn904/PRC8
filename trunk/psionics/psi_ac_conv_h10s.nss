// Returns true if the AC being edited has Energy Touch - Sonic
// Result is normalized to TRUE / FALSE

#include "psi_inc_ac_const"

int StartingConditional()
{
    object oPC = GetPCSpeaker();

    return (GetLocalInt(oPC, ASTRAL_CONSTRUCT_ENERGY_TOUCH_FLAGS + EDIT) &
                             ELEMENT_SONIC)
           != 0;
}
