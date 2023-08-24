// Sets the option Resistance - Sonic active on the AC being edited 


#include "psi_inc_ac_const"
#include "psi_inc_ac_convo"


void main()
{
    object oPC = GetPCSpeaker();
    int nFlags = GetLocalInt(oPC, ASTRAL_CONSTRUCT_OPTION_FLAGS + EDIT);
        nFlags |= ASTRAL_CONSTRUCT_OPTION_RESISTANCE;
    int nElemFlags = GetLocalInt(oPC, ASTRAL_CONSTRUCT_RESISTANCE_FLAGS + EDIT);
        nElemFlags |= ELEMENT_SONIC;
    
    SetLocalInt(oPC, ASTRAL_CONSTRUCT_OPTION_FLAGS + EDIT, nFlags);
    SetLocalInt(oPC, ASTRAL_CONSTRUCT_RESISTANCE_FLAGS + EDIT, nElemFlags);
}
