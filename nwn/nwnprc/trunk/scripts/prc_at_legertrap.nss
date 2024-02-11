//::///////////////////////////////////////////////
//:: Ranged Legerdemain- Disable Trap
//:: prc_at_legertrap.nss
//:://////////////////////////////////////////////
//::
//:: Allows caster to use skills at a range
//:: of up to 30 feet.
//::
//:://///////////////////////////
//:: Created By: Stratovariust
//:: Created On: Mar 4, 2004
//::////////////////////////////////////////////////////////////

#include "prc_inc_nwscript"

void main()
{
    //Declare major variables
    int nDC;
    object oCaster = OBJECT_SELF;
    object oTrap = PRCGetSpellTargetObject();
    int nType = GetObjectType(oTrap);
    if(nType == OBJECT_TYPE_DOOR
    || nType == OBJECT_TYPE_PLACEABLE
    || nType == OBJECT_TYPE_TRIGGER)
    {
        if(GetDistanceToObject(oTrap) <= 30.0)
        {
            nDC = GetTrapDisarmDC(oTrap);
            nDC = nDC + 5;
            if(GetIsSkillSuccessful(oCaster, SKILL_DISABLE_TRAP, nDC))
            {
                SetTrapDisabled(oTrap);
            }
        }
    }

    if(nType == OBJECT_TYPE_DOOR
    || nType == OBJECT_TYPE_PLACEABLE)
    {
        if(GetDistanceToObject(oTrap) <= 30.0)
        {
            nDC = GetLockUnlockDC(oTrap);
            nDC = nDC + 5;
            if (GetIsSkillSuccessful(oCaster, SKILL_OPEN_LOCK, nDC))
            {
                SetLocked(oTrap, FALSE);
            }
        }
    }
}