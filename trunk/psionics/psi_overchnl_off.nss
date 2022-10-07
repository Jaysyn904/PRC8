//::///////////////////////////////////////////////
//:: Overchannel - off
//:: psi_overchnl_off
//:://////////////////////////////////////////////
/** @file
    Turns Overchannel off.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 21.03.2005
//:://////////////////////////////////////////////

#include "psi_inc_psifunc"


void main()
{
    object oPC = OBJECT_SELF;
    SetLocalInt(oPC, PRC_OVERCHANNEL, 0);
    FloatingTextStrRefOnCreature(16824034, oPC, FALSE); // "Overchannel Off"
}