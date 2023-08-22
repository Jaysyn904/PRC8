#include "prc_inc_combat"
#include "prc_inc_sneak"

int SkirmishDamage(object oPC, object oTarget, int nClass)
{
    int nDamage = 0;
    float fRange = 30.0; // default range is 30 feat
    if (GetHasFeat(FEAT_CROSSBOW_SNIPER, oPC) && 
        ((GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) == BASE_ITEM_LIGHTCROSSBOW && GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_CROSSBOW, oPC)) || 
         (GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) == BASE_ITEM_HEAVYCROSSBOW && GetHasFeat(FEAT_WEAPON_FOCUS_HEAVY_CROSSBOW, oPC))))
          fRange = 60.0; // Crossbow Sniper doubles the range
          
    // Only works on non-crit immune and they're within range
    if (!GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT) && FeetToMeters(fRange) >= GetDistanceBetween(oPC, oTarget))
    {
        // Swift Amubusher
        if (GetHasFeat(FEAT_SWIFT_AMBUSHER, oPC))
            nClass += GetLevelByClass(CLASS_TYPE_ROGUE, oPC);
        
        // Increased Dice every 4 levels (1, 5, 9 and so on)
        int nDice = (nClass + 3) / 4;
        
        // Improved Skirmish
        if (GetLocalInt(oPC, "ScoutSkirmish") == 20) nDice += 2;

        //Dragon Devotee and Hand of the Winged Masters damage bonus feats
        int nBonusFeatDice = 0;
        int nCount;
        for(nCount = FEAT_SPECIAL_SKIRMISH_5D6; nCount >= FEAT_SPECIAL_SKIRMISH_1D6; nCount--)
        {
            if (GetHasFeat(nCount,oPC))
            {
                nBonusFeatDice = nCount - FEAT_SPECIAL_SKIRMISH_1D6 + 1;
                if (DEBUG) DoDebug("prc_scout: Bonus Skirmish Dice: " + IntToString(nBonusFeatDice));
                break;
            }
        }
        nDice += nBonusFeatDice;

        nDamage = d6(nDice);

        if(GetHasFeat(FEAT_DRAGONFIRE_STRIKE, oPC) && GetLocalInt(oPC, "DragonFireOn"))
            nDamage += d6();
        if(GetHasFeat(FEAT_IMP_DRAGONFIRE_STRIKE, oPC) && GetLocalInt(oPC, "DragonFireOn"))
            nDamage += nDice;
        nDamage += (GetEssentiaInvestedFeat(oPC, FEAT_INDIGO_STRIKE)*2);    
    }
	if (nDamage) FloatingTextStringOnCreature("Skirmished for "+IntToString(nDamage)+" damage", oPC, FALSE);
    return nDamage;
}

// This is only called if you have Skirmished successfully
void SkirmishAC(object oPC, int nClass)
{
    // Swift Amubusher
    if (GetHasFeat(FEAT_SWIFT_AMBUSHER, oPC))
        nClass += GetLevelByClass(CLASS_TYPE_ROGUE, oPC);
    // Increased Dice every 4 levels (3, 7, 11 and so on)
    int nDice = (nClass + 1) / 4;
    // Improved Skirmish
    if (GetLocalInt(oPC, "ScoutSkirmish") == 20) nDice += 2;
    effect eAC = ExtraordinaryEffect(EffectACIncrease(nDice));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAC, oPC, 6.0);
}

void BattleFortitude(object oPC, int nClass)
{
    // Increased Fort every 9 levels (2, 11, 20 and so on)
    int nFort = (nClass + 7) / 9;
    //check Battle Fort lock to make sure it doesn't stack inappropriately
    if(GetLocalInt(oPC, "BattleFortitude") >= nFort) return;
    effect eFort = ExtraordinaryEffect(EffectSavingThrowIncrease(SAVING_THROW_FORT, nFort));
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFort, oPC);

    //Set Battle Fortitude Lock
    SetLocalInt(oPC, "BattleFortitude", nFort);
}

// Permanent Freedom of movement spell
void FreeMovement(object oPC, int nClass)
{
    if (nClass >= 18)
    {
        effect eParal = EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
        effect eEntangle = EffectImmunity(IMMUNITY_TYPE_ENTANGLE);
        effect eSlow = EffectImmunity(IMMUNITY_TYPE_SLOW);
        effect eMove = EffectImmunity(IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE);

        //Link effects
        effect eLink = EffectLinkEffects(eParal, eEntangle);
        eLink = EffectLinkEffects(eLink, eSlow);
        eLink = EffectLinkEffects(eLink, eMove);

        ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(eLink), oPC);
    }
}

void FastMovement(object oPC, int nClass)
{
    // Speed bonus. +20 feet at level 11, +10 feet at level 3
    // In NWN this is +66% and +33% (Assume 30 feet as base speed)
    if (nClass >= 11) ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(EffectMovementSpeedIncrease(66)), oPC);
    else if (nClass >= 3) ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(EffectMovementSpeedIncrease(33)), oPC);
}

void BlindSight(object oPC, int nClass)
{
    // Blindsense -> Darkvis
    // Blindsight -> True Seeing
    if (nClass >= 20) ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(EffectTrueSeeing()), oPC);
    else if (nClass >= 10) ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(EffectUltravision()), oPC);
}

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("prc_scout running, event: " + IntToString(nEvent));

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
    object oAmmo;
    int nClass = GetLevelByClass(CLASS_TYPE_SCOUT, oPC);
    int nArmour = GetBaseAC(oArmour);


    // We aren't being called from any event, instead from EvalPRCFeats
    if(nEvent == FALSE)
    {
        // Light armour only
        if (3 >= nArmour)
        {
            FastMovement(oPC, nClass);
            BattleFortitude(oPC, nClass);
            FreeMovement(oPC, nClass);
        }
        // Doesn't depend on light armour
        BlindSight(oPC, nClass);

        // Hook in the events, needed from level 1 for Skirmish
        if(DEBUG) DoDebug("prc_scout: Adding eventhooks");
        AddEventScript(oPC, EVENT_ONPLAYEREQUIPITEM,   "prc_scout", TRUE, FALSE);
        AddEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM, "prc_scout", TRUE, FALSE);
        AddEventScript(oPC, EVENT_ONHEARTBEAT,         "prc_scout", TRUE, FALSE);
    }
    // We're being called from the OnHit eventhook, so deal the damage
    // Light armour only
    else if(nEvent == EVENT_ITEM_ONHIT && 3 >= nArmour)
    {
        oItem          = GetSpellCastItem();
        object oTarget = PRCGetSpellTargetObject();
        if(DEBUG) DoDebug("prc_scout: OnHit:\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                        + "oTarget = " + DebugObject2Str(oTarget) + "\n"
                          );

        // Only applies to weapons, and the Scout must have moved this round. 
        if(GetLocalInt(oPC, "ScoutSkirmish") && ( GetWeaponRanged(oItem) || IPGetIsProjectile(oItem) || IPGetIsMeleeWeapon(oItem)) )  // oItem is the ammo in the case of bows and crossbows
        {
            // Calculate Skirmish damage and apply

            int nDamageType = GetWeaponDamageType(oItem);
	
            //Dragonfire Strike Handling
            if(GetHasFeat(FEAT_DRAGONFIRE_STRIKE, oPC) && GetLocalInt(oPC, "DragonFireOn"))
                nDamageType = GetDragonfireDamageType(oPC);

	        else if(IPGetIsProjectile(oItem) && (GetBaseItemType(oItem) == BASE_ITEM_BULLET))
	    	    nDamageType = DAMAGE_TYPE_BLUDGEONING;
		
	        else if (IPGetIsProjectile(oItem))
		        nDamageType = DAMAGE_TYPE_PIERCING;
		
            effect eDam = EffectDamage(SkirmishDamage(oPC, oTarget, nClass), nDamageType);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
        }// end if - Item is a melee weapon
    }// end if - Running OnHit event
    // We are called from the OnPlayerEquipItem eventhook. Add OnHitCast: Unique Power to oPC's weapon
    else if(nEvent == EVENT_ONPLAYEREQUIPITEM)
    {
        oPC   = GetItemLastEquippedBy();
        oItem = GetItemLastEquipped();
        if(DEBUG) DoDebug("prc_scout - OnEquip\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );

        // Only applies to weapons
        // IPGetIsMeleeWeapon is bugged and returns true on items it should not
        if(oItem == GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC) || 
           (oItem == GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC) && !GetIsShield(oItem)) ||
           GetWeaponRanged(oItem))
        {
        
            if (DEBUG)
            {
            	if (IPGetIsMeleeWeapon(oItem)) DoDebug("IPGetIsMeleeWeapon: TRUE");
                if (GetWeaponRanged(oItem))    DoDebug("GetWeaponRanged: TRUE");
            }

                if (GetWeaponRanged(oItem))
                {	    
	                // Add eventhook to the ranged weapons like darts
	                IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
                    AddEventScript(oItem, EVENT_ITEM_ONHIT, "prc_scout", TRUE, FALSE);
        
                    oAmmo = GetItemInSlot(INVENTORY_SLOT_BOLTS, oPC);
                    IPSafeAddItemProperty(oAmmo, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
                    AddEventScript(oAmmo, EVENT_ITEM_ONHIT, "prc_scout", TRUE, FALSE);
        
                    oAmmo = GetItemInSlot(INVENTORY_SLOT_BULLETS, oPC);
                    IPSafeAddItemProperty(oAmmo, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
                    AddEventScript(oAmmo, EVENT_ITEM_ONHIT, "prc_scout", TRUE, FALSE);

                    oAmmo = GetItemInSlot(INVENTORY_SLOT_ARROWS, oPC);
                    IPSafeAddItemProperty(oAmmo, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
                    AddEventScript(oAmmo, EVENT_ITEM_ONHIT, "prc_scout", TRUE, FALSE);
                }
                else if (IPGetIsMeleeWeapon(oItem))
                {            
                    // Add eventhook to the item
                    AddEventScript(oItem, EVENT_ITEM_ONHIT, "prc_scout", TRUE, FALSE);

                    // Add the OnHitCastSpell: Unique needed to trigger the event
                    // Makes sure to get ammo if its a ranged weapon
                    IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
                }

            }
    }
    // We are called from the OnPlayerUnEquipItem eventhook. Remove OnHitCast: Unique Power from oPC's weapon
    else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM)
    {
        oPC   = GetItemLastUnequippedBy();
        oItem = GetItemLastUnequipped();
        if(DEBUG) DoDebug("prc_scout - OnUnEquip\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );

        // Only applies to weapons
        if(IPGetIsMeleeWeapon(oItem) || GetWeaponRanged(oItem))
        {
            // Add eventhook to the item
            RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "prc_scout", TRUE, FALSE);

            // Remove the temporary OnHitCastSpell: Unique
            // Makes sure to get ammo if its a ranged weapon
            RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", -1, DURATION_TYPE_TEMPORARY);

            oAmmo = GetItemInSlot(INVENTORY_SLOT_BOLTS, oPC);
            RemoveSpecificProperty(oAmmo, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", -1, DURATION_TYPE_TEMPORARY);

            oAmmo = GetItemInSlot(INVENTORY_SLOT_BULLETS, oPC);
            RemoveSpecificProperty(oAmmo, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", -1, DURATION_TYPE_TEMPORARY);

            oAmmo = GetItemInSlot(INVENTORY_SLOT_ARROWS, oPC);
            RemoveSpecificProperty(oAmmo, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", -1, DURATION_TYPE_TEMPORARY);
        }
    }
    // This is used to determine the Scout's AC bonus for skirmishing
    // Light armour only
    else if(nEvent == EVENT_ONHEARTBEAT && 3 >= nArmour)
    {
        // Check to see if the WP is valid
        string sWPTag = "PRC_ScoutWP_" + GetName(oPC);
        object oTestWP = GetWaypointByTag(sWPTag);
        if (!GetIsObjectValid(oTestWP))
        {
            // Create waypoint for the movement
            CreateObject(OBJECT_TYPE_WAYPOINT, "nw_waypoint001", GetLocation(oPC), FALSE, sWPTag);
            if(DEBUG) DoDebug("prc_scout: Scout WP for " + DebugObject2Str(oPC) + " didn't exist, creating. Tag: " + sWPTag);
        }
        else // We have a test waypoint, now to check the distance
        {
            // Distance moved in the last round
            float fDist = GetDistanceBetween(oPC, oTestWP);
            // Distance needed to move
            float fCheck = FeetToMeters(10.0);

            // Now clean up the WP and create a new one for next round's check
            DestroyObject(oTestWP);
            CreateObject(OBJECT_TYPE_WAYPOINT, "nw_waypoint001", GetLocation(oPC), FALSE, sWPTag);

            if(DEBUG) DoDebug("prc_scout: Moved enough: " + DebugBool2String(fDist >= fCheck));

            // Moved the distance
            if (fDist >= fCheck)
            {
                // We have skirmished
                SetLocalInt(oPC, "ScoutSkirmish", TRUE);
                
                // We have improved skirmished
                if (GetHasFeat(FEAT_IMPROVED_SKIMISH, oPC) && fDist >= FeetToMeters(20.0))
                    SetLocalInt(oPC, "ScoutSkirmish", 20);
                
                // Only lasts for a round
                DelayCommand(6.0, DeleteLocalInt(oPC, "ScoutSkirmish"));
                // Give the AC bonus
                SkirmishAC(oPC, nClass);
            }
        }
    }
}
