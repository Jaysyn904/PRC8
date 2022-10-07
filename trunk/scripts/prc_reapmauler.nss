#include "prc_alterations"

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("prc_reapmauler running, event: " + IntToString(nEvent));

    // Get the PC. This is event-dependent
    object oPC;
    switch(nEvent)
    {
        case EVENT_ITEM_ONHIT:          oPC = OBJECT_SELF;               break;
        case EVENT_ONPLAYEREQUIPITEM:   oPC = GetItemLastEquippedBy();   break;
        case EVENT_ONPLAYERUNEQUIPITEM: oPC = GetItemLastUnequippedBy(); break;

        default:
            oPC = OBJECT_SELF;
    }
    
    object oItem;
    object oArmour = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
    object oSkin = GetPCSkin(oPC);
    int nArmour = GetBaseAC(oArmour);

    // We aren't being called from any event, instead from EvalPRCFeats
    if(nEvent == FALSE)
    {
        // Hook in the events, needed from level 1 for IP Feats
        if(DEBUG) DoDebug("prc_reapmauler: Adding eventhooks");
        AddEventScript(oPC, EVENT_ONPLAYEREQUIPITEM,   "prc_reapmauler", TRUE, FALSE);
        AddEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM, "prc_reapmauler", TRUE, FALSE);
        // Clean up
        if (nArmour > 3)
        {        
            RemoveItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_GRAPPLE));
            RemoveItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_MOBILITY));
            //FloatingTextStringOnCreature("prc_reapmauler: removing feats", oPC, FALSE);
        }   
        // Light armour only
        if (3 >= nArmour)
        {
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_GRAPPLE), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_MOBILITY), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            //FloatingTextStringOnCreature("prc_reapmauler: Adding feats", oPC, FALSE);
        }          
    }
    // We are called from the OnPlayerEquipItem eventhook. Add OnHitCast: Unique Power to oPC's weapon
    else if(nEvent == EVENT_ONPLAYEREQUIPITEM)
    {
        oPC   = GetItemLastEquippedBy();
        oItem = GetItemLastEquipped();
        if(DEBUG) DoDebug("prc_reapmauler - OnEquip\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );
                          
        // Light armour only
        if (3 >= nArmour)
        {
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_GRAPPLE), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_MOBILITY), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
           //FloatingTextStringOnCreature("prc_reapmauler: Adding feats", oPC, FALSE);
        }                          
    }
    // We are called from the OnPlayerUnEquipItem eventhook. Remove OnHitCast: Unique Power from oPC's weapon
    else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM)
    {
        oPC   = GetItemLastUnequippedBy();
        oItem = GetItemLastUnequipped();
        if(DEBUG) DoDebug("prc_reapmauler - OnUnEquip\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );
        // Clean up
        if (nArmour > 3)
        {        
            RemoveItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_GRAPPLE));
            RemoveItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_MOBILITY));
            //FloatingTextStringOnCreature("prc_reapmauler: removing feats", oPC, FALSE);
        }    
    }
}
