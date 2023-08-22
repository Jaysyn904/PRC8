// Returns true if the AC being edited has Resistance - Fire
// Result is normalized to TRUE / FALSE

#include "psi_inc_ac_const"

int StartingConditional()
{
    object oPC = GetPCSpeaker();

    return (GetLocalInt(oPC, ASTRAL_CONSTRUCT_RESISTANCE_FLAGS + EDIT) &
                             ELEMENT_FIRE)
           != 0;
}
