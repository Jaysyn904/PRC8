/*
    Bariaur Charge
*/

#include "prc_inc_combmove"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
	SetLocalInt(oPC, "BariaurCharge", TRUE);
    DoCharge(oPC, oTarget);
}
