#include "prc_inc_combat"

void ResonanceHit(object oTarget) // Called when hitting a target
{
    int nHits  = GetLocalInt(oTarget, "ResonanceHits");          // Check hits
                 SetLocalInt(oTarget, "ResonanceHits", nHits+1); // Store the hits
}

void ResonanceAdd(object oPC, object oTarget) // Called on heartbeat to add resonance to a target
{
    int nClass = GetLevelByClass(CLASS_TYPE_SERENE_GUARDIAN, oPC);
    int nRes   = GetLocalInt(oTarget, "Resonance");
    int nHits  = GetLocalInt(oTarget, "ResonanceHits"); // Check hits    
  
    // Get 2 resonance if you're level 5+ and hit 3 times in a round
    if (nHits > 2 && nClass > 4)
        SetLocalInt(oTarget, "Resonance", nRes+2);
    else if (nHits > 1) //Otherwise, normal resonance gain
        SetLocalInt(oTarget, "Resonance", nRes+1);        
        
    FloatingTextStringOnCreature(GetName(oTarget)+" has "+IntToString(GetLocalInt(oTarget, "Resonance"))+ " resonance", oPC, FALSE);
}

void ResonanceCheck(object oPC)
{
        location lLoc = GetLocation(oPC);
        object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(100.0), lLoc, FALSE, OBJECT_TYPE_CREATURE);
        
        while(GetIsObjectValid(oTarget))
        {
            if (GetLocalInt(oTarget, "ResonanceHits") > 0) // Make sure they were hit
            {
                ResonanceAdd(oPC, oTarget);
                DeleteLocalInt(oTarget, "ResonanceHits"); // Clean up
            }
            oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(100.0), lLoc, FALSE, OBJECT_TYPE_CREATURE);
       }
} 

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("prc_sereneguard running, event: " + IntToString(nEvent));

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
    
    object oSkin = GetPCSkin(oPC);
    object oItem;
    object oAmmo;
    int nClass = GetLevelByClass(CLASS_TYPE_SERENE_GUARDIAN, oPC);

    // We aren't being called from any event, instead from EvalPRCFeats
    if(nEvent == FALSE)
    {
        if(nClass >= 7) IPSafeAddItemProperty(oSkin, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_FEAR), 99999.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        // Hook in the events, needed from level 1 for Resonance
        if(DEBUG) DoDebug("prc_sereneguard: Adding eventhooks");
        AddEventScript(oPC, EVENT_ONPLAYEREQUIPITEM,   "prc_sereneguard", TRUE, FALSE);
        AddEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM, "prc_sereneguard", TRUE, FALSE);
        AddEventScript(oPC, EVENT_ONHEARTBEAT,         "prc_sereneguard", TRUE, FALSE);
    }
    // We're being called from the OnHit eventhook, so add resonance
    else if(nEvent == EVENT_ITEM_ONHIT)
    {
        oItem          = GetSpellCastItem();
        object oTarget = PRCGetSpellTargetObject();
        if(DEBUG) DoDebug("prc_sereneguard: OnHit:\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                        + "oTarget = " + DebugObject2Str(oTarget) + "\n"
                          );

        // Only applies to weapons
        if(( GetWeaponRanged(oItem) || IPGetIsProjectile(oItem) || IPGetIsMeleeWeapon(oItem)) )  // oItem is the ammo in the case of bows and crossbows
        {
            ResonanceHit(oTarget); //Count the hits
        }// end if - Item is a weapon
    }// end if - Running OnHit event
    // We are called from the OnPlayerEquipItem eventhook. Add OnHitCast: Unique Power to oPC's weapon
    else if(nEvent == EVENT_ONPLAYEREQUIPITEM)
    {
        oPC   = GetItemLastEquippedBy();
        oItem = GetItemLastEquipped();
        if(DEBUG) DoDebug("prc_sereneguard - OnEquip\n"
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
                    AddEventScript(oItem, EVENT_ITEM_ONHIT, "prc_sereneguard", TRUE, FALSE);
        
                    oAmmo = GetItemInSlot(INVENTORY_SLOT_BOLTS, oPC);
                    IPSafeAddItemProperty(oAmmo, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
                    AddEventScript(oAmmo, EVENT_ITEM_ONHIT, "prc_sereneguard", TRUE, FALSE);
        
                    oAmmo = GetItemInSlot(INVENTORY_SLOT_BULLETS, oPC);
                    IPSafeAddItemProperty(oAmmo, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
                    AddEventScript(oAmmo, EVENT_ITEM_ONHIT, "prc_sereneguard", TRUE, FALSE);

                    oAmmo = GetItemInSlot(INVENTORY_SLOT_ARROWS, oPC);
                    IPSafeAddItemProperty(oAmmo, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
                    AddEventScript(oAmmo, EVENT_ITEM_ONHIT, "prc_sereneguard", TRUE, FALSE);

                }
                else if (IPGetIsMeleeWeapon(oItem))
                {            
                    // Add eventhook to the item
                    AddEventScript(oItem, EVENT_ITEM_ONHIT, "prc_sereneguard", TRUE, FALSE);

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
        if(DEBUG) DoDebug("prc_sereneguard - OnUnEquip\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );

        // Only applies to weapons
        if(IPGetIsMeleeWeapon(oItem) || GetWeaponRanged(oItem))
        {
            // Add eventhook to the item
            RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "prc_sereneguard", TRUE, FALSE);

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
    // This is used to run the actual loop to apply resonance
    else if(nEvent == EVENT_ONHEARTBEAT)
    {
        ResonanceCheck(oPC);
    }
}
