//::///////////////////////////////////////////////
//:: OnUnaquireItem eventscript
//:: prc_onunaquire
//:://////////////////////////////////////////////
//Include required for Imbue Arrow functionality.
#include "prc_inc_spells"

void main()
{
    object oItem = GetModuleItemLost();
    object oPC   = GetModuleItemLostBy();
    string sTag  = GetTag(oItem);

    // Do not run for some of the PRC special items
    if(sTag == "PRC_MANIFTOKEN"
    || sTag == "HideToken"
    || GetResRef(oItem) == "base_prc_skin")
        return;

    //if(DEBUG) DoDebug("Running OnUnaquireItem, creature = '" + GetName(oPC) + "' is PC: " + DebugBool2String(GetIsPC(oPC)) + "; Item = '" + GetName(oItem) + "' - '" + GetTag(oItem) + "'");

    if(GetPRCSwitch(PRC_AUTO_UNIDENTIFY_ON_UNACQUIRE))
    {
        object oNewOwner = GetItemPossessor(oItem);
        if(GetIsObjectValid(oNewOwner))
        {
            if((GetObjectType(oNewOwner) == OBJECT_TYPE_CREATURE
                && (GetIsFriend(oPC, oNewOwner)
                    || GetIsNeutral(oPC, oNewOwner)))
                || GetObjectType(oNewOwner) == OBJECT_TYPE_STORE)
            {
            }
            else
                SetIdentified(oItem, FALSE);
        }   
        else
        {
            //put on ground?
            SetIdentified(oItem, FALSE);
        }
    }

    // Remove all temporary item properties when dropped/given away/stolen/sold.
    if(GetIsObjectValid(oItem))//needed for last of stack etc items
        DeletePRCLocalIntsT(oPC,oItem);

    // Execute scripts hooked to this event for the creature and item triggering it
    ExecuteAllScriptsHookedToEvent(oPC, EVENT_ONUNAQUIREITEM);
    ExecuteAllScriptsHookedToEvent(oItem, EVENT_ITEM_ONUNAQUIREITEM);

    // Tag-based scripting hook for PRC items
    SetUserDefinedItemEventNumber(X2_ITEM_EVENT_UNACQUIRE);
    ExecuteScript("is_"+sTag, OBJECT_SELF);
}