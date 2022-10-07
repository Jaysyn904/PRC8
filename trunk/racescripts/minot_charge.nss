/*
    Minotaur does an extra 1d6 damage over the 
    3d6+6 of its normal attack
*/

#include "prc_inc_combmove"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();

    DoCharge(oPC, oTarget, TRUE, TRUE, d6());
}
