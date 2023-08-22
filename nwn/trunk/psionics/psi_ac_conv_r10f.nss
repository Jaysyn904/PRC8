// Removes Energy Touch - Fire from the AC being edited. Also removes Energy Touch
// itself if there are no other elements remaining.

#include "psi_inc_ac_const"
#include "psi_inc_ac_convo"


void main()
{
    object oPC = GetPCSpeaker();

    int nElemFlags = GetLocalInt(oPC, ASTRAL_CONSTRUCT_ENERGY_TOUCH_FLAGS + EDIT);
        nElemFlags ^= ELEMENT_FIRE;

    SetLocalInt(oPC, ASTRAL_CONSTRUCT_ENERGY_TOUCH_FLAGS + EDIT, nElemFlags);

    if(GetNumberOfFlagsRaised(nElemFlags) == 0)
    {
        int nFlags = GetLocalInt(oPC, ASTRAL_CONSTRUCT_OPTION_FLAGS + EDIT);
            nFlags ^= ASTRAL_CONSTRUCT_OPTION_ENERGY_TOUCH;

        SetLocalInt(oPC, ASTRAL_CONSTRUCT_OPTION_FLAGS + EDIT, nFlags);
    }
}
