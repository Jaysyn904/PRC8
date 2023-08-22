#include "prc_inc_unarmed"

void main ()
{
        object oPC = OBJECT_SELF;

        //Evaluate The Unarmed Strike Feats
        SetLocalInt(OBJECT_SELF, CALL_UNARMED_FEATS, TRUE);
        SetLocalInt(OBJECT_SELF, CALL_UNARMED_FISTS, TRUE);
}
