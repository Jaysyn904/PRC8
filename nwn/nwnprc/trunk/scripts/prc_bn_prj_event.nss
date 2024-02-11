//::///////////////////////////////////////////////
//:: Baelnorn Projection - Eventhooks
//:: prc_bn_prj_event
//::///////////////////////////////////////////////
/**
    This script prevents a Baelnorn using Projection
    from picking up items. It forces an
    ActionPutDownItem repeatedly until the item is
    dropped.

    This script is fired via eventhook from the
    OnAcquire event.


    Possible problems
    - The dropping may be workable around somehow.
     - Might be replaced by a copy of the item to
       ground and deletion of the original
      - This has it's own problems. It will at the
        very least break any object references to
        the item.

    @author Ornedan
    @date   Created  - 2005.05.18
    @date   Modified - 2005.11.04
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"

const float DROP_DELAY = 2.0f;

// A pseudo-hb function that checks if the item has been dropped yet
// If it hasn't, clears action queue and queues another drop.
void CheckIsDropped(object oCreature, object oItem)
{
	if(DEBUG) DoDebug("prc_bn_prj_event: CheckIsDropped()");
	
    if(GetItemPossessor(oItem) == oCreature)
    {
	    if(DEBUG) DoDebug("prc_bn_prj_event:GetItemPosessor(oItem) == oCreature");
        // No check for commandability here. Let's not break any cutscenes
        // If cheating does occur, set the char to commandable first here.
        //And remember to restore the setting.

        AssignCommand(oCreature, ClearAllActions());
        AssignCommand(oCreature, ActionPutDownItem(oItem));

        DelayCommand(DROP_DELAY, CheckIsDropped(oCreature, oItem));
    }
}

void main()
{
    int nEvent = GetRunningEvent();
    object oPC, oItem;
if(DEBUG) DoDebug("prc_bn_prj_event running, event = " + IntToString(nEvent));
    switch(nEvent)
    {
        // Nerf equipped weapons
        case EVENT_ONPLAYEREQUIPITEM:
            oPC   = GetItemLastEquippedBy();
            oItem = GetItemLastEquipped();
if(DEBUG) DoDebug("Equipped item, nerfing:"
                + "oPC = " + DebugObject2Str(oItem) + "\n"
                + "oItem = " + DebugObject2Str(oItem) + "\n"
                  );
            if(IPGetIsMeleeWeapon(oItem) || GetWeaponRanged(oItem))
            {
                AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyNoDamage(), oItem);
                array_set_object(oPC, "PRC_BaelnornProj_Nerfed", array_get_size(oPC, "PRC_BaelnornProj_Nerfed"), oItem);
            }

            break;
        /*case EVENT_ONPLAYERUNEQUIPITEM:
            break;*/
        case EVENT_ONACQUIREITEM:
            oPC   = GetModuleItemAcquiredBy();
            oItem = GetModuleItemAcquired();

            AssignCommand(oPC, ActionPutDownItem(oItem));
            DelayCommand(DROP_DELAY, CheckIsDropped(oPC, oItem));

            break;
        /*case EVENT_ONUNAQUIREITEM:
            break;*/
        case EVENT_ONPLAYERREST_STARTED:
            oPC = GetLastBeingRested();

            // Signal the projection monitoring HB
            SetLocalInt(oPC, "PRC_BaelnornProjection_Abort", TRUE);
            break;
            
        case EVENT_ONCLIENTENTER:
             object oPC = GetEnteringObject();
             
             // Remove eventhooks
             RemoveEventScript(oPC, EVENT_ONPLAYEREQUIPITEM,    "prc_bn_prj_event", TRUE, FALSE); // OnEquip
             RemoveEventScript(oPC, EVENT_ONACQUIREITEM,        "prc_bn_prj_event", TRUE, FALSE); // OnAcquire
             RemoveEventScript(oPC, EVENT_ONPLAYERREST_STARTED, "prc_bn_prj_event", FALSE, FALSE); // OnRest
             RemoveEventScript(oPC, EVENT_ONCLIENTENTER,        "prc_bn_prj_event", TRUE, FALSE); //OnClientEnter   
             break;

        /*default:
            if(DEBUG) DoDebug("prc_bn_prj_event: ERROR: Called for unhandled event: " + IntToString(nEvent));
            return;*/
    }
}

