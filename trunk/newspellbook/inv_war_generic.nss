/*
    generic maneuver calling function
*/
#include "inv_inc_invfunc"

void main()
{
    UseInvocation(GetPowerFromSpellID(PRCGetSpellId()), CLASS_TYPE_WARLOCK);
    if(DEBUG) DoDebug("inv_war_generic: SpellID: " + IntToString(PRCGetSpellId()));
    if(DEBUG) DoDebug("inv_war_generic: PowerID: " + IntToString(GetPowerFromSpellID(PRCGetSpellId())));
}