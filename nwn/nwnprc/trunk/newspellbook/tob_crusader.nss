#include "tob_inc_tobfunc"
#include "prc_inc_combmove"

void DelayedDamageHB(object oPC, int nCount);

int LevelToDelayedDamage(int nLevel)
{
	int nDelayedDamage = -1;

	if (nLevel >= 60) nDelayedDamage = 80;
	else if (nLevel >= 56) nDelayedDamage = 75;
	else if (nLevel >= 52) nDelayedDamage = 70;
	else if (nLevel >= 48) nDelayedDamage = 65;
	else if (nLevel >= 44) nDelayedDamage = 60;
	else if (nLevel >= 40) nDelayedDamage = 55;
	else if (nLevel >= 36) nDelayedDamage = 50;
	else if (nLevel >= 32) nDelayedDamage = 45;
	else if (nLevel >= 28) nDelayedDamage = 40;
	else if (nLevel >= 24) nDelayedDamage = 35;
	else if (nLevel >= 20) nDelayedDamage = 30;
	else if (nLevel >= 16) nDelayedDamage = 25;
	else if (nLevel >= 12) nDelayedDamage = 20;
	else if (nLevel >= 8) nDelayedDamage = 15;
	else if (nLevel >= 4) nDelayedDamage = 10;
	else if (nLevel >= 1) nDelayedDamage = 5;

	return nDelayedDamage;
}


void IndomitableSoul(object oPC)
{
        int nSave = GetAbilityModifier(ABILITY_CHARISMA, oPC);
        // Can't be negative.
        if (0 > nSave) nSave = 0;
        // Charisma to Will saves
        effect eFort = ExtraordinaryEffect(EffectSavingThrowIncrease(SAVING_THROW_WILL, nSave));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFort, oPC);
        if (DEBUG) DoDebug("Indomitable Soul applied.");
}

void DelayedDamageHB(object oPC, int nCount)
{
    int nCurHP = GetCurrentHitPoints(oPC);
    int nPreHP = GetLocalInt(oPC, "CrusaderHP");
    int nClass = GetLevelByClass(CLASS_TYPE_CRUSADER, oPC);
    object oHand   = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    
    if (nPreHP > nCurHP)
    {
            // Check current delayed damage pool and max delayed
            int nDelayedPool = GetLocalInt(oPC, "DelayedDamage");
            int nMaxDelayed = LevelToDelayedDamage(nClass);
            //if (DEBUG) DoDebug("Delayed Pool equals: "+IntToString(nDelayedPool));
            //if (DEBUG) DoDebug("Maximum Delayed equals: "+IntToString(nMaxDelayed));
        
            // If there is space left
            if (nMaxDelayed > nDelayedPool)
            {
                // Amount remaining
                int nRemainingPool = nMaxDelayed - nDelayedPool;
                //if (DEBUG) DoDebug("Remaining Pool equals: "+IntToString(nRemainingPool));
                // Damage dealt
                int nDamageTaken = nPreHP - nCurHP;
                int nHeal = 0;
                //if (DEBUG) DoDebug("Damage Taken equals: "+IntToString(nDamageTaken));
                // Prevents player from regaining more HP than damage taken
                if(nDamageTaken >= nRemainingPool)
                    nHeal = nRemainingPool;
                else
                    nHeal = nDamageTaken;
                    
                //if (DEBUG) DoDebug("Heal Amount equals: "+IntToString(nHeal));
                // Heal them the Delayed Damage
                //effect eHeal = EffectHeal(nHeal);
                if (!GetLocalInt(oPC, "CrusaderBreak")) //ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oPC);
                	if (GetMaxHitPoints(oPC) >=  nCurHP + nHeal)
                		SetCurrentHitPoints(oPC, nCurHP + nHeal); // Done this way so it doesn't show up on the char screen
                
                // Mark the Local Int with current damage plus whatever else was healed
                SetLocalInt(oPC, "DelayedDamage", nDelayedPool + nHeal);
            }    
    }
    if (nCount == 24)
    {
        // Get the amount of damage prevented
        int nDelayedPool = GetLocalInt(oPC, "DelayedDamage");
        //if (DEBUG) DoDebug("Your delayed damage pool: " + IntToString(nDelayedPool));
        if (nDelayedPool > 0)
        {
            // Furious counterstrike is delayed damage / 5
            int nBonus = nDelayedPool / 5;
            // Minimum of one if you have delayed damage
            if (nBonus == 0 && nDelayedPool > 0) nBonus = 1;
            //if (DEBUG) DoDebug("Your furious counterstrike: " + IntToString(nBonus));
            // Calculate damage type and apply
            int nDamageType = GetWeaponDamageType(oHand);
            effect eLink = EffectLinkEffects(EffectAttackIncrease(nBonus), EffectDamageIncrease(GetIntToDamage(nBonus), nDamageType));
            eLink = EffectLinkEffects(eLink, EffectVisualEffect(PSI_DUR_BURST));
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(eLink), oPC, 6.0);
            // Visuals
            //effect eVis = EffectVisualEffect(VFX_DUR_MARK_OF_THE_HUNTER);
            //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
            
            // Now apply the delayed damage
            int nTest = GetCurrentHitPoints(oPC);
            if (nTest - nDelayedPool > 0) SetCurrentHitPoints(oPC, nTest - nDelayedPool);
            else // If this triggers, the PC is dead
            {
            	ApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(EffectDamage(nDelayedPool, DAMAGE_TYPE_POSITIVE, DAMAGE_POWER_ENERGY)), oPC);
            	ApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(EffectDeath(TRUE)), oPC);
            }	
            int nTest2 = GetCurrentHitPoints(oPC);
            if ((nTest - nDelayedPool) != nTest2) SetLocalInt(oPC, "CrusaderBreak", TRUE);
            else DeleteLocalInt(oPC, "CrusaderBreak");
        }   
        // Clean up local int for this round
        DeleteLocalInt(oPC, "DelayedDamage");
        //if (DEBUG) DoDebug("Deleted delayed damage: " + IntToString(GetLocalInt(oPC, "DelayedDamage"))); 
        nCount = 0; // Reset the loop
    }
    SetLocalInt(oPC, "CrusaderHP", GetCurrentHitPoints(oPC));
    DelayCommand(0.25, DelayedDamageHB(oPC, nCount+1));
}

void main()
{
    int nEvent = GetRunningEvent();
    //if(DEBUG) DoDebug("tob_crusader running, event: " + IntToString(nEvent));

    // Get the PC. This is event-dependent
    object oPC;
    switch(nEvent)
    {
        case EVENT_ITEM_ONHIT:          oPC = OBJECT_SELF;               break;
        case EVENT_ONPLAYEREQUIPITEM:   oPC = GetItemLastEquippedBy();   break;
        case EVENT_ONPLAYERUNEQUIPITEM: oPC = GetItemLastUnequippedBy(); break;
        case EVENT_ONHEARTBEAT:         oPC = OBJECT_SELF;               break;

        default:
            oPC = OBJECT_SELF;
    }

    object oItem;
    object oArmour = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
    object oHand   = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    int nClass = GetLevelByClass(CLASS_TYPE_CRUSADER, oPC);

    // We aren't being called from any event, instead from EvalPRCFeats
    if(nEvent == FALSE)
    {
    	// Saving throw bonus, charisma, does not stack with paladin
    	//if (nClass >= 2 && GetLevelByClass(CLASS_TYPE_PALADIN, oPC) == 0)IndomitableSoul(oPC);
        // Hook in the events, needed from level 1 for Steely Resolve
        //if(DEBUG) DoDebug("tob_crusader: Adding eventhooks");
        //AddEventScript(oPC, EVENT_ONPLAYEREQUIPITEM,   "tob_crusader", TRUE, FALSE);
        //AddEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM, "tob_crusader", TRUE, FALSE);
        AddEventScript(oPC, EVENT_ONHEARTBEAT,         "tob_crusader", TRUE, FALSE);
        //AddEventScript(oPC, EVENT_VIRTUAL_ONDAMAGED,   "tob_crusader", TRUE, FALSE);
        if (!GetLocalInt(oPC, "DelayedDamageHB")) 
        {
            DelayedDamageHB(oPC, 1);
            SetLocalInt(oPC, "DelayedDamageHB", TRUE);
        }    
    }
    // Damage reduction from Steely Resolve
    /*else if(nEvent == EVENT_VIRTUAL_ONDAMAGED)
    {
        FloatingTextStringOnCreature("Ouch ouch ouch!", oPC);
    }
    // Damage reduction from Steely Resolve
    else if(nEvent == EVENT_ITEM_ONHIT)
    {
        oItem          = GetSpellCastItem();
        object oTarget = PRCGetSpellTargetObject();
        if(DEBUG) DoDebug("tob_crusader: OnHit:\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                        + "oTarget = " + DebugObject2Str(oTarget) + "\n"
                          );

        // Only applies to armours
        if(GetBaseItemType(oItem) == BASE_ITEM_ARMOR)
        {
        	// Check current delayed damage pool and max delayed
		    int nDelayedPool = GetLocalInt(oPC, "DelayedDamage");
		    int nMaxDelayed = LevelToDelayedDamage(nClass);
            if (DEBUG) DoDebug("Delayed Pool equals: "+IntToString(nDelayedPool));
            if (DEBUG) DoDebug("Maximum Delayed equals: "+IntToString(nMaxDelayed));
		
		    // If there is space left
		    if (nMaxDelayed > nDelayedPool)
		    {
		    	// Amount remaining
		    	int nRemainingPool = nMaxDelayed - nDelayedPool;
                if (DEBUG) DoDebug("Remaining Pool equals: "+IntToString(nRemainingPool));
		    	// Damage dealt
		    	int nDamageTaken = GetTotalDamageDealt();
     	    	int nHeal = 0;
                if (DEBUG) DoDebug("Damage Taken equals: "+IntToString(nDamageTaken));
		    	// Prevents player from regaining more HP than damage taken
		    	if(nDamageTaken >= nRemainingPool)
		    		nHeal = nRemainingPool;
		    	else
		    		nHeal = nDamageTaken;
                    
                if (DEBUG) DoDebug("Heal Amount equals: "+IntToString(nHeal));
                // Heal them the Delayed Damage
		    	effect eHeal = EffectHeal(nHeal);
		    	ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oPC);
		    	
		    	// Mark the Local Int with current damage plus whatever else was healed
		    	SetLocalInt(oPC, "DelayedDamage", nDelayedPool + nHeal);
		    }
        }// end if - Item is an armour
    }// end if - Running OnHit event
    // We are called from the OnPlayerEquipItem eventhook. Add OnHitCast: Unique Power to oPC's armour
    else if(nEvent == EVENT_ONPLAYEREQUIPITEM)
    {
        oPC   = GetItemLastEquippedBy();
        oItem = GetItemLastEquipped();
        if(DEBUG) DoDebug("tob_crusader - OnEquip");

        // Only applies to armours
        if(GetBaseItemType(oItem) == BASE_ITEM_ARMOR)
        {
            // Add eventhook to the item
            AddEventScript(oItem, EVENT_ITEM_ONHIT, "tob_crusader", TRUE, FALSE);

            // Add the OnHitCastSpell: Unique needed to trigger the event
            IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }
    }
    // We are called from the OnPlayerUnEquipItem eventhook. Remove OnHitCast: Unique Power from oPC's armour
    else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM)
    {
        oPC   = GetItemLastUnequippedBy();
        oItem = GetItemLastUnequipped();
        if(DEBUG) DoDebug("tob_crusader - OnUnEquip");

        // Only applies to armours
        if(GetBaseItemType(oItem) == BASE_ITEM_ARMOR)
        {
            // Add eventhook to the item
            RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "tob_crusader", TRUE, FALSE);

            // Remove the temporary OnHitCastSpell: Unique
            RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", 1, DURATION_TYPE_TEMPORARY);
        }
    }*/
    // This is used to determine the bonus from Furious Counterstrike
    else if(nEvent == EVENT_ONHEARTBEAT)
    {
        //if they are deleveled completely out of Crusader, no need to keep running these
        if(!GetLevelByClass(CLASS_TYPE_CRUSADER, oPC))
        {
            RemoveEventScript(oPC, EVENT_ONPLAYEREQUIPITEM,   "tob_crusader", TRUE, FALSE);
            RemoveEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM, "tob_crusader", TRUE, FALSE);
            RemoveEventScript(oPC, EVENT_ONHEARTBEAT,         "tob_crusader", TRUE, FALSE);
        }
    }
}