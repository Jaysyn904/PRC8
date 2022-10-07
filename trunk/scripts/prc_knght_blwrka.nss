//::///////////////////////////////////////////////
//:: Knight - Bulwark of Defense, Enter
//:: prc_knght_blwrk.nss
//:://////////////////////////////////////////////
//:: Difficult Terrain
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: July 1, 2007
//:://////////////////////////////////////////////

#include "prc_alterations"

void main()
{
    //Declare major variables
    object oTarget = GetEnteringObject();
    effect eSlow = EffectMovementSpeedDecrease(50);

    // Cleaned up on exit
    if (GetIsEnemy(oTarget, GetAreaOfEffectCreator())) SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eSlow, oTarget);
}
