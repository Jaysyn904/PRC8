/*
    generic mystery calling function
*/
#include "shd_inc_shdfunc"

void main()
{
    UseMystery(GetPowerFromSpellID(PRCGetSpellId()), CLASS_TYPE_SHADOWCASTER);
    if(DEBUG) DoDebug("shd_shd_generic: SpellID: " + IntToString(GetPowerFromSpellID(PRCGetSpellId())));
}