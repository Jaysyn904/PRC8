//::///////////////////////////////////////////////
//:: Overchannel - 3 manifester levels
//:: psi_overchnl_3
//:://////////////////////////////////////////////
/** @file
    Sets Overchannel to three manifester levels.
    User will manifest as if it had three more
    level in the currently used manifesting class,
    but takes 5d8 damage.

    Can only be used by beings with at least 15 HD.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 21.03.2005
//:://////////////////////////////////////////////

#include "psi_inc_psifunc"


const int nLevel = 3;

void main()
{
    object oPC = OBJECT_SELF;
    if(!GetLocalInt(oPC, PRC_WILD_SURGE))
    {
        if(GetHitDice(oPC) >= 15)
        {
            SetLocalInt(oPC, PRC_OVERCHANNEL, nLevel);
            FloatingTextStrRefOnCreature(16824032, oPC, FALSE); // "Overchannel Level Three"
        }
        else
            FloatingTextStrRefOnCreature(16824033, oPC, FALSE); // "You need to be at least level 15 to overchannel 3 manifester levels"
    }
    else
        FloatingTextStrRefOnCreature(16824029, oPC, FALSE); // "You cannot have Overchannel and Wild Surge active at the same time"
}