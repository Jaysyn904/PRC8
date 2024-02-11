/*
    generic mystery calling function
*/
#include "shd_inc_shdfunc"

void main()
{
    UseMystery(GetPowerFromSpellID(PRCGetSpellId()), CLASS_TYPE_SHADOWSMITH);
    if(DEBUG) DoDebug("shd_smt_generic: SpellID: " + IntToString(GetPowerFromSpellID(PRCGetSpellId())));
}