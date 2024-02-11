//::///////////////////////////////////////////////
//:: Ignore SR switch
//:: true_ignore_sr
//::///////////////////////////////////////////////
/** @file
    Switches the Ignore SR check on and off

    @author Stratovarius
    @date   Created - 2006.07.18
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "true_inc_trufunc"

void main()
{
    object oPC = OBJECT_SELF;

    SetLocalInt(oPC, TRUE_IGNORE_SR, !GetLocalInt(oPC, TRUE_IGNORE_SR));
    FloatingTextStringOnCreature("Ignore Spell Resistance " + (GetLocalInt(oPC, TRUE_IGNORE_SR) ? GetStringByStrRef(63798/*Activated*/):GetStringByStrRef(63799/*Deactivated*/)), oPC, FALSE);
}