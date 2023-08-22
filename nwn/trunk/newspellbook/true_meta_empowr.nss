//::///////////////////////////////////////////////
//:: Empower Utterance switch
//:: true_meta_empowr
//::///////////////////////////////////////////////
/** @file
    Switches the metautterance feat Empower Utterance on or off.

    @author Stratovarius
    @date   Created - 2006.07.18
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "true_inc_trufunc"

void main()
{
    object oPC = OBJECT_SELF;

    SetLocalInt(oPC, METAUTTERANCE_EMPOWER_VAR, !GetLocalInt(oPC, METAUTTERANCE_EMPOWER_VAR));
    FloatingTextStringOnCreature("Empower Utterance " + (GetLocalInt(oPC, METAUTTERANCE_EMPOWER_VAR) ? GetStringByStrRef(63798/*Activated*/):GetStringByStrRef(63799/*Deactivated*/)), oPC, FALSE);
}