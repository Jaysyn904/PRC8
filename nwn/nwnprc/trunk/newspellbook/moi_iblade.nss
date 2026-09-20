#include "moi_inc_moifunc"
#include "inc_dynconv"
#include "prc_nui_moi_cst"
#include "prc_inc_util"

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
    else if(nEvent == EVENT_ONPLAYERREST_FINISHED && nClass > 0)    
    {
		if(GetHighestMeldshaperLevel(oMeldshaper) == 0)
		{
			// A generation-stamped saved NUI default is applied by prc_rest
			// after the normal feat rebuild.  Without it, retain the original
			// forced conversation exactly as before.
			if (GetLocalInt(
					oMeldshaper,
					PRC_MOI_BLADE_REST_GENERATION_VAR
				) == GetLocalInt(oMeldshaper, PRC_Rest_Generation)
				&& GetLocalInt(
					oMeldshaper,
					PRC_MOI_BLADE_REST_GENERATION_VAR
				) > 0)
				return;
			AssignCommand(oMeldshaper, ClearAllActions(TRUE));
			StartDynamicConversation("moi_iblade_bind", oMeldshaper, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oMeldshaper);
        }	
    }    
}
