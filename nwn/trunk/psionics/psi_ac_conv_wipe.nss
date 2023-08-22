// Clean up the temporary AC convo variables

#include "psi_inc_ac_const"

void main()
{
    object oPC = GetPCSpeaker();

    DeleteLocalInt(oPC, ASTRAL_CONSTRUCT_LEVEL              + EDIT);
    DeleteLocalInt(oPC, ASTRAL_CONSTRUCT_OPTION_FLAGS       + EDIT);
    DeleteLocalInt(oPC, ASTRAL_CONSTRUCT_RESISTANCE_FLAGS   + EDIT);
    DeleteLocalInt(oPC, ASTRAL_CONSTRUCT_ENERGY_TOUCH_FLAGS + EDIT);
    DeleteLocalInt(oPC, ASTRAL_CONSTRUCT_ENERGY_BOLT_FLAGS  + EDIT);

    DeleteLocalInt(oPC, CURRENT_SLOT);
}
