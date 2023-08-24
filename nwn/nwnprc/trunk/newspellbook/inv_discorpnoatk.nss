//::///////////////////////////////////////////////
//:: Name      Dark Discorporation
//:: FileName  inv_discorpnoatk.nss
//::///////////////////////////////////////////////
/*

Enforces Dark Discorporation's inability to
directly attack

*/

#include "prc_alterations"

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("inv_discorpnoatk running, event: " + IntToString(nEvent));

    // Init the PC.
    object oPC;
    object oItem;

    // We aren't being called from any event, instead from EvalPRCFeats
    if(nEvent == FALSE)
    {
        oPC = OBJECT_SELF;
        // Hook in the events
        if(DEBUG) DoDebug("inv_discorpnoatk: Adding eventhooks");
        AddEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM, "inv_discorpnoatk", TRUE, FALSE);
        //may not be needed, put in just in case(ala HotU start)
        AddEventScript(oPC, EVENT_ONUNAQUIREITEM, "inv_discorpnoatk", TRUE, FALSE);
    }
    else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM)
    {
        oPC = GetItemLastUnequippedBy();
        oItem = GetItemLastUnequipped();
        if(DEBUG) DoDebug("inv_discorpnoatk - OnUnEquip");
        if(GetTag(oItem) == "prc_eldrtch_glv")
        {
        //object oNoAtk = GetItemPossessedBy(oPC, "prc_eldrtch_glv");

        //if(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC) == OBJECT_INVALID)
            AssignCommand(oPC, ActionEquipItem(oItem, INVENTORY_SLOT_RIGHTHAND));
        }
    }
    else if(nEvent == EVENT_ONUNAQUIREITEM)
    {
        if(DEBUG) DoDebug("inv_discorpnoatk: OnUnAcquire");
        oItem = GetModuleItemLost();
        if(GetTag(oItem) == "prc_eldrtch_glv")
        {
            if(DEBUG) DoDebug("Destroying lost warlock stuff");
            MyDestroyObject(oItem);
        }
    }
}