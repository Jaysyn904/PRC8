// Sets the option Power Resist active on the AC being edited 


#include "psi_inc_ac_const"
#include "psi_inc_ac_convo"


void main()
{
    object oPC = GetPCSpeaker();
    int nFlags = GetLocalInt(oPC, ASTRAL_CONSTRUCT_OPTION_FLAGS + EDIT);
        nFlags |= ASTRAL_CONSTRUCT_OPTION_POWER_RESIST;
    
    SetLocalInt(oPC, ASTRAL_CONSTRUCT_OPTION_FLAGS + EDIT, nFlags);
}
