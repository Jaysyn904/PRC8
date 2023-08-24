//::///////////////////////////////////////////////
//:: Overchannel - 1 manifester level
//:: psi_overchnl_1
//:://////////////////////////////////////////////
/** @file
    Sets Overchannel to one manifester level.
    User will manifest as if it had one more
    level in the currently used manifesting class,
    but takes 1d8 damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 21.03.2005
//:://////////////////////////////////////////////

#include "psi_inc_psifunc"


const int nLevel = 1;

void main()
{
    object oPC = OBJECT_SELF;
    if(!GetLocalInt(oPC, PRC_WILD_SURGE))
    {
        SetLocalInt(oPC, PRC_OVERCHANNEL, nLevel);
        FloatingTextStrRefOnCreature(16824028, oPC, FALSE); // "Overchannel Level One"
    }
    else
        FloatingTextStrRefOnCreature(16824029, oPC, FALSE); // "You cannot have Overchannel and Wild Surge active at the same time"
}