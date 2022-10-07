//::///////////////////////////////////////////////
//:: Ranged Legerdemain - Open Lock
//:: prc_at_legerlock.nss
//:://////////////////////////////////////////////
//::
//:: Allows caster to use skills at a range
//:: of up to 30 feet.
//::
//:://///////////////////////////
//:: Created By: Stratovariust
//:: Created On: Mar 4, 2004
//::////////////////////////////////////////////////////////////


#include "prc_alterations"
#include "x2_inc_spellhook"

void main()
{
    //Declare major variables
    int nDC;
    object oCaster = OBJECT_SELF;
    object oLock = PRCGetSpellTargetObject();
    int nType = GetObjectType(oLock);
    if(nType == OBJECT_TYPE_DOOR
    || nType == OBJECT_TYPE_PLACEABLE)
    {
        if(GetDistanceToObject(oLock) <= 30.0)
        {
            nDC = GetLockUnlockDC(oLock);
            nDC = nDC + 5;
            if(GetIsSkillSuccessful(oCaster, SKILL_OPEN_LOCK, nDC))
            {
                SetLocked(oLock, FALSE);
            }
        }
    }
}