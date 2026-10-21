//::///////////////////////////////////////////////  
//:: Ranged Legerdemain - Open Lock  
//:: prc_at_legerlock.nss  
//:://////////////////////////////////////////////  
//::  
//:: Allows caster to use skills at a range  
//:: of up to 30 feet.  
//::  
//:://///////////////////////////  
//:: Created By: Stratovarius  
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
            // Key-required locks cannot be bypassed by Open Lock at all,  
            // unless the caster is carrying the matching key.  
            if(GetLockKeyRequired(oLock))  
            {  
                string sKeyTag = GetLockKeyTag(oLock);  
                object oKey = GetItemPossessedBy(oCaster, sKeyTag);  
                if(GetIsObjectValid(oKey))  
                {  
                    SetLocked(oLock, FALSE);  
                }  
                // else: no key, fail silently, as a locked/key-required door should  
            }  
            else  
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
}