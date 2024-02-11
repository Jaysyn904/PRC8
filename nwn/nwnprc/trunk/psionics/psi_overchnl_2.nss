//::///////////////////////////////////////////////
//:: Overchannel - 2 manifester levels
//:: psi_overchnl_2
//:://////////////////////////////////////////////
/** @file
    Sets Overchannel to two manifester levels.
    User will manifest as if it had two more
    level in the currently used manifesting class,
    but takes 3d8 damage.

    Can only be used by beings with at least 8 HD.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 21.03.2005
//:://////////////////////////////////////////////

#include "psi_inc_psifunc"


const int nLevel = 2;

void main()
{
    object oPC = OBJECT_SELF;
    if(!GetLocalInt(oPC, PRC_WILD_SURGE))
    {
        if(GetHitDice(oPC) >= 8)
        {
            SetLocalInt(oPC, PRC_OVERCHANNEL, nLevel);
            FloatingTextStrRefOnCreature(16824030, oPC, FALSE); // "Overchannel Level Two"
        }
        else
            FloatingTextStrRefOnCreature(16824031, oPC, FALSE); // "You need to be at least level 8 to overchannel 2 manifester levels"
    }
    else
        FloatingTextStrRefOnCreature(16824029, oPC, FALSE); // "You cannot have Overchannel and Wild Surge active at the same time"
}