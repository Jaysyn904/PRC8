/*
    generic powercalling function
*/
#include "psi_inc_psifunc"

void main()
{
    UsePower(GetPowerFromSpellID(PRCGetSpellId()), CLASS_TYPE_WILDER);
    if(DEBUG) DoDebug("psi_wil_generic: SpellID: " + IntToString(PRCGetSpellId()));
    if(DEBUG) DoDebug("psi_wil_generic: PowerID: " + IntToString(GetPowerFromSpellID(PRCGetSpellId())));
}
