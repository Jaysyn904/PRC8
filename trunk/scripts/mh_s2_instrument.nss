#include "prc_inc_clsfunc"

void main()
{
    //object oCaster = GetLastSpellCaster();
    object oCaster = OBJECT_SELF;

    if(GetLocalInt(oCaster,"use_CIMM"))
    {
        UnactiveModeCIMM(oCaster);
    }
    else
    {
        ActiveModeCIMM(oCaster);
    }
}
