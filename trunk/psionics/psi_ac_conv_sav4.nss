// Save the AC to slot 4

#include "psi_inc_ac_const"

const string sSlotToUse = "4";

void main()
{
    object oPC = GetPCSpeaker();

    SetLocalInt(oPC, ASTRAL_CONSTRUCT_LEVEL              + sSlotToUse, GetLocalInt(oPC, ASTRAL_CONSTRUCT_LEVEL              + EDIT));
    SetLocalInt(oPC, ASTRAL_CONSTRUCT_OPTION_FLAGS       + sSlotToUse, GetLocalInt(oPC, ASTRAL_CONSTRUCT_OPTION_FLAGS       + EDIT));
    SetLocalInt(oPC, ASTRAL_CONSTRUCT_RESISTANCE_FLAGS   + sSlotToUse, GetLocalInt(oPC, ASTRAL_CONSTRUCT_RESISTANCE_FLAGS   + EDIT));
    SetLocalInt(oPC, ASTRAL_CONSTRUCT_ENERGY_TOUCH_FLAGS + sSlotToUse, GetLocalInt(oPC, ASTRAL_CONSTRUCT_ENERGY_TOUCH_FLAGS + EDIT));
    SetLocalInt(oPC, ASTRAL_CONSTRUCT_ENERGY_BOLT_FLAGS  + sSlotToUse, GetLocalInt(oPC, ASTRAL_CONSTRUCT_ENERGY_BOLT_FLAGS  + EDIT));
}
