// Removes Resistance - Cold from the AC being edited. Also removes Resistance
// itself if there are no other elements remaining.

#include "psi_inc_ac_const"
#include "psi_inc_ac_convo"


void main()
{
    object oPC = GetPCSpeaker();

    int nElemFlags = GetLocalInt(oPC, ASTRAL_CONSTRUCT_RESISTANCE_FLAGS + EDIT);
        nElemFlags ^= ELEMENT_COLD;

    SetLocalInt(oPC, ASTRAL_CONSTRUCT_RESISTANCE_FLAGS + EDIT, nElemFlags);

    if(GetNumberOfFlagsRaised(nElemFlags) == 0)
    {
        int nFlags = GetLocalInt(oPC, ASTRAL_CONSTRUCT_OPTION_FLAGS + EDIT);
            nFlags ^= ASTRAL_CONSTRUCT_OPTION_RESISTANCE;

        SetLocalInt(oPC, ASTRAL_CONSTRUCT_OPTION_FLAGS + EDIT, nFlags);
    }
}
