//::///////////////////////////////////////////////
//:: Wild Surge: Off
//:: prc_wld_srg_off
//::///////////////////////////////////////////////
/** @file
    Turns Wild Surge off on the using character.
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "psi_inc_psifunc"


void main()
{
    object oPC = OBJECT_SELF;
    SetLocalInt(oPC, PRC_WILD_SURGE, 0);
    FloatingTextStrRefOnCreature(16823612, oPC, FALSE); // "Wild Surge Off"
}