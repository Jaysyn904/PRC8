//::///////////////////////////////////////////////
//:: Quicken Utterance switch
//:: true_meta_quickn
//::///////////////////////////////////////////////
/** @file
    Switches the metautterance feat Quicken Utterance on or off.

    @author Stratovarius
    @date   Created - 2006.07.18
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "true_inc_trufunc"

void main()
{
    object oPC = OBJECT_SELF;

    SetLocalInt(oPC, METAUTTERANCE_QUICKEN_VAR, !GetLocalInt(oPC, METAUTTERANCE_QUICKEN_VAR));
    FloatingTextStringOnCreature("Quicken Utterance " + (GetLocalInt(oPC, METAUTTERANCE_QUICKEN_VAR) ? GetStringByStrRef(63798/*Activated*/):GetStringByStrRef(63799/*Deactivated*/)), oPC, FALSE);
}