#include "prc_inc_combat"
#include "prc_inc_sneak"

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("psi_psyrogue running, event: " + IntToString(nEvent));

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
    object oAmmo;
    if(!GetHasFeat(FEAT_PSY_MIND_CRIPPLE, oPC)) return; //Only triggers when you have that feat

    // We aren't being called from any event, instead from EvalPRCFeats
    if(nEvent == FALSE)
    {
        // Hook in the events
        if(DEBUG) DoDebug("psi_psyrogue: Adding eventhooks");
        AddEventScript(oPC, EVENT_ONPLAYEREQUIPITEM,   "psi_psyrogue", TRUE, FALSE);
        AddEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM, "psi_psyrogue", TRUE, FALSE);
    }
    // We're being called from the OnHit eventhook, so deal the damage
    else if(nEvent == EVENT_ITEM_ONHIT)
    {
        oItem          = GetSpellCastItem();
        object oTarget = PRCGetSpellTargetObject();
        if(DEBUG) DoDebug("psi_psyrogue: OnHit:\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                        + "oTarget = " + DebugObject2Str(oTarget) + "\n"
                          );

        // Only applies to weapons, and must be flanking and able to sneak attack
        if(GetIsFlanked(oTarget, oPC) && !GetIsImmune(oTarget, IMMUNITY_TYPE_SNEAK_ATTACK) && 
           ( GetWeaponRanged(oItem) || IPGetIsProjectile(oItem) || IPGetIsMeleeWeapon(oItem)) )  // oItem is the ammo in the case of bows and crossbows
        {
            ApplyAbilityDamage(oTarget, ABILITY_INTELLIGENCE, 2, DURATION_TYPE_PERMANENT, TRUE, -1.0);
            FloatingTextStringOnCreature("Mind Cripple Hit", oPC, FALSE); // "* Skirmish *"
        }// end if - Item is a melee weapon
    }// end if - Running OnHit event
    // We are called from the OnPlayerEquipItem eventhook. Add OnHitCast: Unique Power to oPC's weapon
    else if(nEvent == EVENT_ONPLAYEREQUIPITEM)
    {
        oPC   = GetItemLastEquippedBy();
        oItem = GetItemLastEquipped();
        if(DEBUG) DoDebug("psi_psyrogue - OnEquip\n"
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
                    AddEventScript(oItem, EVENT_ITEM_ONHIT, "psi_psyrogue", TRUE, FALSE);
        
                    oAmmo = GetItemInSlot(INVENTORY_SLOT_BOLTS, oPC);
                    IPSafeAddItemProperty(oAmmo, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
                    AddEventScript(oAmmo, EVENT_ITEM_ONHIT, "psi_psyrogue", TRUE, FALSE);
        
                    oAmmo = GetItemInSlot(INVENTORY_SLOT_BULLETS, oPC);
                    IPSafeAddItemProperty(oAmmo, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
                    AddEventScript(oAmmo, EVENT_ITEM_ONHIT, "psi_psyrogue", TRUE, FALSE);

                    oAmmo = GetItemInSlot(INVENTORY_SLOT_ARROWS, oPC);
                    IPSafeAddItemProperty(oAmmo, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
                    AddEventScript(oAmmo, EVENT_ITEM_ONHIT, "psi_psyrogue", TRUE, FALSE);
                }
                else if (IPGetIsMeleeWeapon(oItem))
                {            
                    // Add eventhook to the item
                    AddEventScript(oItem, EVENT_ITEM_ONHIT, "psi_psyrogue", TRUE, FALSE);

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
        if(DEBUG) DoDebug("psi_psyrogue - OnUnEquip\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );

        // Only applies to weapons
        if(IPGetIsMeleeWeapon(oItem) || GetWeaponRanged(oItem))
        {
            // Add eventhook to the item
            RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "psi_psyrogue", TRUE, FALSE);

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
}
