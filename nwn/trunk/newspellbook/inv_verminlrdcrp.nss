/*
    Warlock epic feat
    Verminlord creeping doom
*/
#include "prc_inc_racial"
#include "inv_inc_invfunc"

void main()
{
	DoRacialSLA(SPELL_CREEPING_DOOM, GetInvokerLevel(OBJECT_SELF, CLASS_TYPE_WARLOCK));
}
