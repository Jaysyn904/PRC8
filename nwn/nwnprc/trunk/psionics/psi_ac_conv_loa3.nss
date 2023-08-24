// Copies the data from AC slot 3 to the modifying variables

#include "psi_inc_ac_const"

string sSlot = "3";

void main()
{
    object oPC = GetPCSpeaker();

    SetLocalInt(oPC, ASTRAL_CONSTRUCT_LEVEL              + EDIT, GetLocalInt(oPC, ASTRAL_CONSTRUCT_LEVEL              + sSlot));
    SetLocalInt(oPC, ASTRAL_CONSTRUCT_OPTION_FLAGS       + EDIT, GetLocalInt(oPC, ASTRAL_CONSTRUCT_OPTION_FLAGS       + sSlot));
    SetLocalInt(oPC, ASTRAL_CONSTRUCT_RESISTANCE_FLAGS   + EDIT, GetLocalInt(oPC, ASTRAL_CONSTRUCT_RESISTANCE_FLAGS   + sSlot));
    SetLocalInt(oPC, ASTRAL_CONSTRUCT_ENERGY_TOUCH_FLAGS + EDIT, GetLocalInt(oPC, ASTRAL_CONSTRUCT_ENERGY_TOUCH_FLAGS + sSlot));
    SetLocalInt(oPC, ASTRAL_CONSTRUCT_ENERGY_BOLT_FLAGS  + EDIT, GetLocalInt(oPC, ASTRAL_CONSTRUCT_ENERGY_BOLT_FLAGS  + sSlot));
}
