#include "moi_inc_moifunc"
#include "inc_dynconv"

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("moi_iblade running, event: " + IntToString(nEvent));

    // Get the PC. This is event-dependent
    object oMeldshaper;
    switch(nEvent)
    {
        case EVENT_ONPLAYEREQUIPITEM:   oMeldshaper = GetItemLastEquippedBy();   break;
        case EVENT_ONPLAYERUNEQUIPITEM: oMeldshaper = GetItemLastUnequippedBy(); break;
        case EVENT_ONPLAYERREST_FINISHED:   oMeldshaper = GetLastBeingRested();  break;

        default:
            oMeldshaper = OBJECT_SELF;
    }

    object oItem;
    int nClass = GetLevelByClass(CLASS_TYPE_INCARNUM_BLADE, oMeldshaper);

    // We aren't being called from any event, instead from EvalPRCFeats
    if(nEvent == FALSE)
    {
        // Hook in the events, needed from level 1 for Blademeld
        if(DEBUG) DoDebug("moi_iblade: Adding eventhooks");
        AddEventScript(oMeldshaper, EVENT_ONPLAYEREQUIPITEM,   "moi_iblade", TRUE, FALSE);
        AddEventScript(oMeldshaper, EVENT_ONPLAYERUNEQUIPITEM, "moi_iblade", TRUE, FALSE);
        AddEventScript(oMeldshaper, EVENT_ONPLAYERREST_FINISHED, "moi_iblade", TRUE, FALSE);
    }
    // We are called from the OnPlayerEquipItem eventhook. Add DR breaking to oMeldshaper's weapon
    else if(nEvent == EVENT_ONPLAYEREQUIPITEM)
    {
        oMeldshaper   = GetItemLastEquippedBy();
        oItem = GetItemLastEquipped();
        if(DEBUG) DoDebug("moi_iblade - OnEquip\n"
                        + "oMeldshaper = " + DebugObject2Str(oMeldshaper) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );

        // Only applies to a single melee weapon
        // IPGetIsMeleeWeapon is bugged and returns true on items it should not
        if(oItem == GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oMeldshaper) && IPGetIsMeleeWeapon(oItem))
        {
        	int nBonus = 1;
        	if (GetHasSpellEffect(MELD_BLADEMELD_SOUL, oMeldshaper)) nBonus = 3;
			IPSafeAddItemProperty(oItem, ItemPropertyAttackBonus(nBonus), 99999.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
			IPSafeAddItemProperty(oItem, ItemPropertyAttackPenalty(nBonus), 99999.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);        	
        }
    }
    // We are called from the OnPlayerUnEquipItem eventhook. Remove DR breaking from oMeldshaper's weapon
    else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM)
    {
        oMeldshaper   = GetItemLastUnequippedBy();
        oItem = GetItemLastUnequipped();
        if(DEBUG) DoDebug("moi_iblade - OnUnEquip\n"
                        + "oMeldshaper = " + DebugObject2Str(oMeldshaper) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );

        // Only applies to weapons
        if(IPGetIsMeleeWeapon(oItem))
        {
            RemoveSpecificProperty(oItem, ITEM_PROPERTY_ATTACK_BONUS, -1, -1, 1, "", -1, DURATION_TYPE_TEMPORARY);
            RemoveSpecificProperty(oItem, ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER, -1, -1, 1, "", -1, DURATION_TYPE_TEMPORARY);
        }
    }
    else if(nEvent == EVENT_ONPLAYERREST_FINISHED)    
    {
    	if(GetHighestMeldshaperLevel(oMeldshaper) == 0)
    	{
        	AssignCommand(oMeldshaper, ClearAllActions(TRUE));
        	StartDynamicConversation("moi_iblade_bind", oMeldshaper, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oMeldshaper);
        }	
    }    
}
