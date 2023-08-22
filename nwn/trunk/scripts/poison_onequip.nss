//::///////////////////////////////////////////////
//:: Poisoned Item OnEquip Event script
//:: poison_onequip
//::///////////////////////////////////////////////
/** @file
    This script will determine if the equipped item
    was poisoned with a contact poison.

    If so, the equipper will be affected by the
    poison.

    Locals set by this:
      pois_itm_uses        - Integer.
                             Number of times this item
                             can poison people before
                             the poison wears off.
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
    object oItem   = GetPCItemLastEquipped();;
    object oTarget = GetPCItemLastEquippedBy();
    int nUses = GetLocalInt(oItem, "pois_itm_uses");

    // Check to see if the item is poisoned. Any non-zero nUses means it is
    if(!nUses) return;

    int nPoisonIdx = GetLocalInt(oItem, "pois_itm_idx");


    // Some checks to see if the equipper knows the item is poisoned
    // They do if they are the poisoner or have succeeded on a Spot check regarding this item
    int bPCKnowsOfPoison = FALSE;
    int nSafeCount = GetLocalInt(oItem, "pois_itm_safecount");

    if(GetPRCSwitch(PRC_POISON_ALLOW_CLEAN_IN_EQUIP))
    {
        if(oTarget == GetLocalObject(oItem, "pois_itm_poisoner"))
            bPCKnowsOfPoison = TRUE;
        else
        {
            if(nSafeCount > 0)
            {
                int i;
                object oCheck;
                for(i = 1; i <= nSafeCount; i++){
                    oCheck = GetLocalObject(oItem, "pois_itm_safe_" + IntToString(i));
                    if(oTarget == oCheck){
                        bPCKnowsOfPoison = TRUE;
                        break;
                    }
                }
            }// end if - the list has elements
        }// end else - look through the safe users list to see if current user is in there
    }// end if - one is allowed to clean at all

    // If the equipper knows of the poison, we assume they are bright enough to try
    // cleaning the item before equipping it.
    if(bPCKnowsOfPoison)
    {
        SendMessageToPC(oTarget, GetStringByStrRef(STRREF_ONEQUIP_CLEAN_ITEM));

        if(!(oTarget == GetLocalObject(oItem, "pois_itm_poisoner")))
        {
            int nDC = GetLocalInt(oItem, "pois_itm_trap_dc");

            if(!GetIsSkillSuccessful(oTarget, SKILL_DISABLE_TRAP, nDC))
            {
                // Apply the poison to the cleaner
                effect ePoison = EffectPoison(nPoisonIdx);
                SPApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoison, oTarget, 0.0f, FALSE);

                // Inform the cleaner of the fact
                SendMessageToPC(oTarget,
                                GetStringByStrRef(STRREF_CLEAN_ITEM_FAIL_1) + " " +
                                GetName(oItem) + " " +
                                GetStringByStrRef(STRREF_CLEAN_ITEM_FAIL_2)
                               ); // You slip while cleaning xxxx and touch the poison.
            }// end if - Disable Trap check failed
        }// end if - Handle cleaner != poisoner

        // Remove the poison and inform player
        DoPoisonRemovalFromItem(oItem);
        SendMessageToPC(oTarget,
                        GetStringByStrRef(STRREF_CLEAN_ITEM_SUCCESS) + " " +
                        GetName(oItem) + "."
                       ); // You remove all traces of poison off of xxxx.
    }// end if - equipper knows of poison
    else
    {
        // Apply the poison to equipper
        effect ePoison = EffectPoison(nPoisonIdx);
        SPApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoison, oTarget, 0.0f, FALSE);

        //Decrement uses remaining and handle poison wearing off
        nUses--;
        if(nUses <= 0)
            DoPoisonRemovalFromItem(oItem);
        else
            SetLocalInt(oItem, "pois_itm_uses", nUses);
    }// end else - equipper was unaware of the poison
}
