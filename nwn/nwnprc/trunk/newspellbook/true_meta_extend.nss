//::///////////////////////////////////////////////
//:: Extend Utterance switch
//:: true_meta_extend
//::///////////////////////////////////////////////
/** @file
    Switches the metautterance feat Extend Utterance on or off.

    @author Stratovarius
    @date   Created - 2006.07.18
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "true_inc_trufunc"

void main()
{
    object oPC = OBJECT_SELF;

    SetLocalInt(oPC, METAUTTERANCE_EXTEND_VAR, !GetLocalInt(oPC, METAUTTERANCE_EXTEND_VAR));
    FloatingTextStringOnCreature("Extend Utterance " + (GetLocalInt(oPC, METAUTTERANCE_EXTEND_VAR) ? GetStringByStrRef(63798/*Activated*/):GetStringByStrRef(63799/*Deactivated*/)), oPC, FALSE);
}