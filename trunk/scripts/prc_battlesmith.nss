#include "inc_newspellbook" 
#include "prc_inc_core"

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("prc_battlesmith running, event: " + IntToString(nEvent));

    // Get the PC. This is event-dependent
    object oPC;
    object oItem;    
    switch(nEvent)
    {
        case EVENT_ONPLAYEREQUIPITEM:   oPC = GetItemLastEquippedBy();   break;
        case EVENT_ONPLAYERUNEQUIPITEM: oPC = GetItemLastUnequippedBy(); break;

        default:
            oPC = OBJECT_SELF;
    }

    // We aren't being called from any event, instead from EvalPRCFeats
    if(nEvent == FALSE)
    {
        // Hook in the events, needed from level 1 for Skirmish
        if(DEBUG) DoDebug("prc_battlesmith: Adding eventhooks");
        AddEventScript(oPC, EVENT_ONPLAYEREQUIPITEM,   "prc_battlesmith", TRUE, FALSE);
        AddEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM, "prc_battlesmith", TRUE, FALSE);
    }
    // We are called from the OnPlayerEquipItem eventhook. Add OnHitCast: Unique Power to oPC's weapon
    else if(nEvent == EVENT_ONPLAYEREQUIPITEM)
    {
        oPC   = GetItemLastEquippedBy();
        oItem = GetItemLastEquipped();
        if(DEBUG) DoDebug("prc_battlesmith - OnEquip\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );

        // Only applies to warhammers and armor
        if(GetBaseItemType(oItem) == BASE_ITEM_WARHAMMER || GetBaseItemType(oItem) == BASE_ITEM_ARMOR)
        {
            ActionCastSpellOnSelf(BATTLESMITH_BOOST, METAMAGIC_NONE, oPC);
        }
    }
    // We are called from the OnPlayerUnEquipItem eventhook. Remove OnHitCast: Unique Power from oPC's weapon
    else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM)
    {
        oPC   = GetItemLastUnequippedBy();
        oItem = GetItemLastUnequipped();
        if(DEBUG) DoDebug("prc_battlesmith - OnUnEquip\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );
        // Only applies to warhammers and armor
        if(GetBaseItemType(oItem) == BASE_ITEM_WARHAMMER || GetBaseItemType(oItem) == BASE_ITEM_ARMOR)
        {
            ActionCastSpellOnSelf(BATTLESMITH_BOOST, METAMAGIC_NONE, oPC);
        }
    }
}
