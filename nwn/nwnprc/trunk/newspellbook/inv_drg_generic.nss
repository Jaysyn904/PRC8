/*
    generic invocation calling function
*/
#include "inv_inc_invfunc"

void main()
{
    UseInvocation(GetPowerFromSpellID(PRCGetSpellId()), CLASS_TYPE_DRAGON_SHAMAN);
}