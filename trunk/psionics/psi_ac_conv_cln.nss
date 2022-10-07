// Clean up the temporary AC convo variables

#include "psi_inc_ac_const"

void main()
{
    object oPC = GetPCSpeaker();

    SetLocalInt(oPC, ASTRAL_CONSTRUCT_LEVEL              + EDIT, 0);
    SetLocalInt(oPC, ASTRAL_CONSTRUCT_OPTION_FLAGS       + EDIT, 0);
    SetLocalInt(oPC, ASTRAL_CONSTRUCT_RESISTANCE_FLAGS   + EDIT, 0);
    SetLocalInt(oPC, ASTRAL_CONSTRUCT_ENERGY_TOUCH_FLAGS + EDIT, 0);
    SetLocalInt(oPC, ASTRAL_CONSTRUCT_ENERGY_BOLT_FLAGS  + EDIT, 0);

    SetLocalInt(oPC, CURRENT_SLOT, 0);
}
