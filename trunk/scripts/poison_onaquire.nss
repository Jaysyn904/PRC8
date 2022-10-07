//::///////////////////////////////////////////////
//:: Poisoned Item OnAcquire Event script
//:: poison_onaquire
//::///////////////////////////////////////////////
/** @file
    This script will determine if the acquired item
    was poisoned with a contact poison.

    If so, the acquirer must do a Spot check versus
    a DC stored on the item.
    On success, they notice the poison and pick the
    item up safely. They also get added to a list of
    people on the item who can safely handle it.
    On failure, they get affected by the poison.


    Locals set by this:
      pois_itm_safecount   - Integer.
                             Number of people, other
                             than the poisoner, that
                             can handle the item
                             safely.

      pois_itm_uses        - Integer.
                             Number of times this item
                             can poison people before
                             the poison wears off.

      pois_itm_safe_X      - Object.
                             If user succeeded on their
                             Spot check, they get added
                             to a list on the item.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 10.01.2005
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "inc_poison"
#include "prc_inc_spells"


void main()
{
    object oItem   = GetModuleItemAcquired();
    object oTarget = GetModuleItemAcquiredBy();
    int nUses = GetLocalInt(oItem, "pois_itm_uses");

    // Check to see if the item is poisoned. Any non-zero nUses means it is
    if(!nUses) return;

    // Some checks to see if the acquirer can safely handle the item
    // They can, if they are the poisoner or have succeeded on a Spot check regarding this item
    int bSafeToHandle = FALSE;
    int nSafeCount = GetLocalInt(oItem, "pois_itm_safecount");

    if(oTarget == GetLocalObject(oItem, "pois_itm_poisoner"))
        bSafeToHandle = TRUE;
    else
    {
        if(nSafeCount > 0)
        {
            int i;
            object oCheck;
            for(i = 1; i <= nSafeCount; i++){
                oCheck = GetLocalObject(oItem, "pois_itm_safe_" + IntToString(i));
                if(oTarget == oCheck){
                    bSafeToHandle = TRUE;
                    break;
                }
            }
        }// end if - the list has elements
    }// end else - look through the safe users list to see if current user is in there

    // Handle the acquirer not being aware of the poison
    if(!bSafeToHandle)
    {
        int nDC = GetLocalInt(oItem, "pois_itm_trap_dc");

        if(GetIsSkillSuccessful(oTarget, SKILL_SPOT, nDC))
        {
            // Inform them of the poison on the item
            SendMessageToPC(oTarget,
                            GetStringByStrRef(STRREF_ACQUIRE_SPOT_SUCCESS1) + " " +
                            GetName(oItem) + " " +
                            GetStringByStrRef(STRREF_ACQUIRE_SPOT_SUCCESS2)
                           ); // You notice xxxx is covered with poison and pick it up very carefully.
        }// end if - Spot check succeeded
        else
        {
            // Apply the poison to acquirer
            int nPoisonIdx = GetLocalInt(oItem, "pois_itm_idx");
            effect ePoison = EffectPoison(nPoisonIdx);
            SPApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoison, oTarget, 0.0f, FALSE);

            //Decrement uses remaining and handle poison wearing off
            nUses--;
            if(nUses <= 0)
                DoPoisonRemovalFromItem(oItem);
            else
                SetLocalInt(oItem, "pois_itm_uses", nUses);
        }// end else - Spot check failed

        // Either way, mark that the acquirer now knows about the poison and can safely handle the item
        nSafeCount++;
        SetLocalInt(oItem, "pois_itm_safecount", nSafeCount);
        SetLocalObject(oItem, "pois_itm_safe_" + IntToString(nSafeCount), oTarget);
    }// end if - user doesn't know about the poison
}
