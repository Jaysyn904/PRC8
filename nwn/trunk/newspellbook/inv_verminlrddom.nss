/*
    Warlock epic feat
    Verminlord dominating vermin
*/
#include "prc_inc_racial"
#include "inv_inc_invfunc"

void main()
{
    object oTarget = PRCGetSpellTargetObject();
    int nRacialType = MyPRCGetRacialType(oTarget);

    if(nRacialType != RACIAL_TYPE_VERMIN)
        return;

	DoRacialSLA(SPELL_DOMINATE_MONSTER, GetInvokerLevel(OBJECT_SELF, CLASS_TYPE_WARLOCK));
}
