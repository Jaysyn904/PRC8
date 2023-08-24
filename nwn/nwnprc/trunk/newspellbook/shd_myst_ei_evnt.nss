/*
18/02/19 by Stratovarius

Ephemeral Image

Master, Dark Metamorphosis 
Level/School: 7th/Illusion (Shadow) 
Effect: One shadow duplicate 
Duration: 1 minute/level (D) 
Saving Throw: None 
Spell Resistance: No

You detach your own shadow and animate it with extraplanar energies, creating a dark-hued, hazy duplicate of yourself.

This mystery functions like the spell project image, except as noted above. In addition, the image that you project has concealment.


This is a direct copy of Baelnorn Projection
*/

#include "prc_alterations"

const float DROP_DELAY = 2.0f;

// A pseudo-hb function that checks if the item has been dropped yet
// If it hasn't, clears action queue and queues another drop.
void CheckIsDropped(object oCreature, object oItem)
{
	if(DEBUG) DoDebug("shd_myst_ei_evnt: CheckIsDropped()");
	
    if(GetItemPossessor(oItem) == oCreature)
    {
	    if(DEBUG) DoDebug("shd_myst_ei_evnt:GetItemPosessor(oItem) == oCreature");
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
    object oShadow, oItem;
if(DEBUG) DoDebug("shd_myst_ei_evnt running, event = " + IntToString(nEvent));
    switch(nEvent)
    {
        // Nerf equipped weapons
        case EVENT_ONPLAYEREQUIPITEM:
            oShadow   = GetItemLastEquippedBy();
            oItem = GetItemLastEquipped();
if(DEBUG) DoDebug("Equipped item, nerfing:"
                + "oShadow = " + DebugObject2Str(oItem) + "\n"
                + "oItem = " + DebugObject2Str(oItem) + "\n"
                  );
            if(IPGetIsMeleeWeapon(oItem) || GetWeaponRanged(oItem))
            {
                AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyNoDamage(), oItem);
                array_set_object(oShadow, "PRC_EphemeralImage_Nerfed", array_get_size(oShadow, "PRC_EphemeralImage_Nerfed"), oItem);
            }

            break;
        /*case EVENT_ONPLAYERUNEQUIPITEM:
            break;*/
        case EVENT_ONACQUIREITEM:
            oShadow   = GetModuleItemAcquiredBy();
            oItem = GetModuleItemAcquired();

            AssignCommand(oShadow, ActionPutDownItem(oItem));
            DelayCommand(DROP_DELAY, CheckIsDropped(oShadow, oItem));

            break;
        /*case EVENT_ONUNAQUIREITEM:
            break;*/
        case EVENT_ONPLAYERREST_STARTED:
            oShadow = GetLastBeingRested();

            // Signal the projection monitoring HB
            SetLocalInt(oShadow, "PRC_EphemeralImage_Abort", TRUE);
            break;
            
        case EVENT_ONCLIENTENTER:
             object oShadow = GetEnteringObject();
             
             // Remove eventhooks
             RemoveEventScript(oShadow, EVENT_ONPLAYEREQUIPITEM,    "shd_myst_ei_evnt", TRUE, FALSE); // OnEquip
             RemoveEventScript(oShadow, EVENT_ONACQUIREITEM,        "shd_myst_ei_evnt", TRUE, FALSE); // OnAcquire
             RemoveEventScript(oShadow, EVENT_ONPLAYERREST_STARTED, "shd_myst_ei_evnt", FALSE, FALSE); // OnRest
             RemoveEventScript(oShadow, EVENT_ONCLIENTENTER,        "shd_myst_ei_evnt", TRUE, FALSE); //OnClientEnter           

        /*default:
            if(DEBUG) DoDebug("shd_myst_ei_evnt: ERROR: Called for unhandled event: " + IntToString(nEvent));
            return;*/
    }
}

