#include "moi_inc_moifunc"

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("moi_umbral running, event: " + IntToString(nEvent));

    // Get the PC. This is event-dependent
    object oMeldshaper;
    object oItem;    
    switch(nEvent)
    {
        case EVENT_ONPLAYEREQUIPITEM:   oMeldshaper = GetItemLastEquippedBy();   break;
        case EVENT_ONPLAYERUNEQUIPITEM: oMeldshaper = GetItemLastUnequippedBy(); break;

        default:
            oMeldshaper = OBJECT_SELF;
    }

    // We aren't being called from any event, instead from EvalPRCFeats
    if(nEvent == FALSE)
    {
        // Hook in the events, needed from level 1 for Skirmish
        if(DEBUG) DoDebug("moi_umbral: Adding eventhooks");
        AddEventScript(oMeldshaper, EVENT_ONPLAYEREQUIPITEM,   "moi_umbral", TRUE, FALSE);
        AddEventScript(oMeldshaper, EVENT_ONPLAYERUNEQUIPITEM, "moi_umbral", TRUE, FALSE);
    }
    // We are called from the OnPlayerEquipItem eventhook. Add OnHitCast: Unique Power to oMeldshaper's weapon
    else if(nEvent == EVENT_ONPLAYEREQUIPITEM)
    {
        oMeldshaper   = GetItemLastEquippedBy();
        oItem = GetItemLastEquipped();
        if(DEBUG) DoDebug("moi_umbral - OnEquip\n"
                        + "oMeldshaper = " + DebugObject2Str(oMeldshaper) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );
        if (IPGetIsMeleeWeapon(oItem) && GetHasSpellEffect(MELD_UMBRAL_SOUL, oMeldshaper))
        {            
            // Add eventhook to the item
            AddEventScript(oItem, EVENT_ITEM_ONHIT, "moi_umbral", TRUE, FALSE);
        	IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    	}          
    }
    // We are called from the OnPlayerUnEquipItem eventhook. Remove OnHitCast: Unique Power from oMeldshaper's weapon
    else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM)
    {
        oMeldshaper   = GetItemLastUnequippedBy();
        oItem = GetItemLastUnequipped();
        if(DEBUG) DoDebug("moi_umbral - OnUnEquip\n"
                        + "oMeldshaper = " + DebugObject2Str(oMeldshaper) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );

        // Only applies to weapons
        if(IPGetIsMeleeWeapon(oItem))
        {
            // Remove the temporary OnHitCastSpell: Unique
            RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "moi_umbral", TRUE, FALSE);
            RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", -1, DURATION_TYPE_TEMPORARY);
        }
        // Clean up when the spell effect isn't around
        if (!GetHasSpellEffect(MELD_UMBRAL_SOUL, oMeldshaper))
        {
        	RemoveEventScript(oMeldshaper, EVENT_ONPLAYERUNEQUIPITEM, "moi_umbral", TRUE, FALSE);
        	RemoveEventScript(oMeldshaper, EVENT_ONPLAYEREQUIPITEM,   "moi_umbral", TRUE, FALSE);
        }
    }
    else if(nEvent == EVENT_ITEM_ONHIT)
    {
        oItem          = GetSpellCastItem();
        object oTarget = PRCGetSpellTargetObject();
        if(DEBUG) DoDebug("moi_umbral: OnHit:\n"
                        + "oMeldshaper = " + DebugObject2Str(oMeldshaper) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                        + "oTarget = " + DebugObject2Str(oTarget) + "\n"
                          );
        int nEssentia = GetEssentiaInvested(oMeldshaper, MELD_UMBRAL_SOUL);                  
		if (nEssentia && !GetLocalInt(oMeldshaper, "UmbralDelay")) 
		{
			int nDC = 10 + GetAbilityModifier(ABILITY_CONSTITUTION, oMeldshaper) + nEssentia;
			if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC))
			{
				ApplyAbilityDamage(oTarget, ABILITY_STRENGTH, nEssentia, DURATION_TYPE_TEMPORARY, TRUE, -1.0);
			}
			SetLocalInt(oMeldshaper, "UmbralDelay", TRUE);
			DelayCommand(5.9, DeleteLocalInt(oMeldshaper, "UmbralDelay"));
		}	
    }// end if - Running OnHit event    
}
