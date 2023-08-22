/*
    generic invocation calling function
*/
#include "inv_inc_invfunc"

void main()
{
    UseInvocation(GetPowerFromSpellID(PRCGetSpellId()), CLASS_TYPE_DRAGONFIRE_ADEPT);
}