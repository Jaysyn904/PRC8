/*
    generic utterance calling function
*/
#include "true_inc_trufunc"

void main()
{
    UseUtterance(GetPowerFromSpellID(PRCGetSpellId()), CLASS_TYPE_TRUENAMER);
    //if(DEBUG) DoDebug("true_utr_generic: SpellID: " + IntToString(GetPowerFromSpellID(PRCGetSpellId())));
}