//::///////////////////////////////////////////////
//:: Speak Unto the Masses switch
//:: true_speak_mass
//::///////////////////////////////////////////////
/** @file
    Switches the Truenamer ability Speak Unto the Masses on or off.

    @author Stratovarius
    @date   Created - 2006.07.20
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "true_inc_trufunc"

void main()
{
    object oPC = OBJECT_SELF;

    SetLocalInt(oPC, TRUE_SPEAK_UNTO_MASSES, !GetLocalInt(oPC, TRUE_SPEAK_UNTO_MASSES));
    FloatingTextStringOnCreature("Speak Unto the Masses " + (GetLocalInt(oPC, TRUE_SPEAK_UNTO_MASSES) ? GetStringByStrRef(63798/*Activated*/):GetStringByStrRef(63799/*Deactivated*/)), oPC, FALSE);
}