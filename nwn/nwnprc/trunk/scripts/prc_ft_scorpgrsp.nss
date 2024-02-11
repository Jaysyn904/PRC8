//::///////////////////////////////////////////////
//:: Scorpion's Grasp feat
//:: prc_ft_scorpgrsp
//::///////////////////////////////////////////////
/** @file
    Does the triggering and event scripts for the feat

    @author Stratovarius
    @date   Created - 2019.6.17
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_combmove"

//////////////////////////////////////////////////
/*       Void Main and Event Triggers           */
//////////////////////////////////////////////////

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("prc_ft_scorpgrsp running, event: " + IntToString(nEvent));

    // Get the PC. This is event-dependent
    object oPC;
    object oItem;
    switch(nEvent)
    {
        case EVENT_ITEM_ONHIT:          oPC = OBJECT_SELF;               break;
        case EVENT_ONPLAYEREQUIPITEM:   oPC = GetItemLastEquippedBy();   break;
        case EVENT_ONPLAYERUNEQUIPITEM: oPC = GetItemLastUnequippedBy(); break;

        default:
            oPC = OBJECT_SELF;
    }

    // We aren't being called from any event, instead from the player
    if(nEvent == FALSE)
    {
        string nMes = "";
        object oRight = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
        object oLeft = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);        
        object oFist = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC);        
        
        if(!GetLocalInt(oPC, "ScorpionsGrasp"))
        {    
            SetLocalInt(oPC, "ScorpionsGrasp", TRUE);
            nMes = "Scorpion's Grasp Active";
            // Hook in the events
            if(DEBUG) DoDebug("prc_ft_scorpgrsp: Adding eventhooks");
            AddEventScript(oPC, EVENT_ONPLAYEREQUIPITEM,   "prc_ft_scorpgrsp", TRUE, FALSE);
            AddEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM, "prc_ft_scorpgrsp", TRUE, FALSE);
            
            // Apply the OnHits
            if (GetIsObjectValid(oRight) && IPGetIsMeleeWeapon(oRight))
            {
                // Add eventhook to the weapon
                IPSafeAddItemProperty(oRight, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
                AddEventScript(oRight, EVENT_ITEM_ONHIT, "prc_ft_scorpgrsp", TRUE, FALSE);                    
            }            
            // Apply the OnHits
            if (GetIsObjectValid(oLeft) && IPGetIsMeleeWeapon(oLeft))
            {
                // Add eventhook to the weapon
                IPSafeAddItemProperty(oLeft, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
                AddEventScript(oLeft, EVENT_ITEM_ONHIT, "prc_ft_scorpgrsp", TRUE, FALSE);                    
            }    
            // Apply the OnHits
            if (GetIsObjectValid(oFist))
            {
                // Add eventhook to the weapon
                IPSafeAddItemProperty(oFist, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
                AddEventScript(oFist, EVENT_ITEM_ONHIT, "prc_ft_scorpgrsp", TRUE, FALSE);                    
            }             
        }
        else     
        {
            // Removes effects
            DeleteLocalInt(oPC, "ScorpionsGrasp");
            nMes = "Scorpion's Grasp Deactivated";
            RemoveEventScript(oPC, EVENT_ONPLAYEREQUIPITEM, "prc_ft_scorpgrsp", TRUE, FALSE);
            RemoveEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM, "prc_ft_scorpgrsp", TRUE, FALSE);
            
            // Apply the OnHits
            if (GetIsObjectValid(oRight) && IPGetIsMeleeWeapon(oRight))
            {
                // Remove eventhook to the item
                RemoveEventScript(oRight, EVENT_ITEM_ONHIT, "prc_ft_scorpgrsp", TRUE, FALSE);

                // Remove the temporary OnHitCastSpell: Unique
                RemoveSpecificProperty(oRight, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", 1, DURATION_TYPE_TEMPORARY);                    
            }            
            // Apply the OnHits
            if (GetIsObjectValid(oLeft) && IPGetIsMeleeWeapon(oLeft))
            {
                // Remove eventhook to the item
                RemoveEventScript(oLeft, EVENT_ITEM_ONHIT, "prc_ft_scorpgrsp", TRUE, FALSE);

                // Remove the temporary OnHitCastSpell: Unique
                RemoveSpecificProperty(oLeft, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", 1, DURATION_TYPE_TEMPORARY);                     
            }   
            // Apply the OnHits
            if (GetIsObjectValid(oFist))
            {
                // Remove eventhook to the item
                RemoveEventScript(oFist, EVENT_ITEM_ONHIT, "prc_ft_scorpgrsp", TRUE, FALSE);

                // Remove the temporary OnHitCastSpell: Unique
                RemoveSpecificProperty(oFist, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", 1, DURATION_TYPE_TEMPORARY);                     
            }            
        }

        FloatingTextStringOnCreature(nMes, oPC, FALSE);    
    }
    else if(nEvent == EVENT_ITEM_ONHIT && !GetGrapple(oPC)) // Don't run this if already in a grapple
    {
        oItem          = GetSpellCastItem();
        object oTarget = PRCGetSpellTargetObject();
        if(DEBUG) DoDebug("prc_ft_scorpgrsp: OnHit:\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                        + "oTarget = " + DebugObject2Str(oTarget) + "\n"
                          );
                          
        object oRight = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
        object oLeft = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC); 
        
        // Non-light weapons you need to unequip
        if (GetIsLightWeapon(oPC))
            SetLocalInt(oPC, "ScorpionLight", TRUE);
        else  
        {
            if (IPGetIsMeleeWeapon(oLeft)) ForceUnequip(oPC, oLeft, INVENTORY_SLOT_LEFTHAND);
            ForceUnequip(oPC, oRight, INVENTORY_SLOT_RIGHTHAND);
        }
        DoGrapple(oPC, oTarget, 0, FALSE, TRUE);

    }// end if - Running OnHit event
    else if(nEvent == EVENT_ONPLAYEREQUIPITEM && GetLocalInt(oPC, "ScorpionsGrasp")) // Only apply on equip when the feat is active
    {
        oPC   = GetItemLastEquippedBy();
        oItem = GetItemLastEquipped();
        if(DEBUG) DoDebug("prc_ft_scorpgrsp - OnEquip\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );

        // Only applies to weapons
        if (IPGetIsMeleeWeapon(oItem))
        {
            // Add eventhook to the weapon
            IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            AddEventScript(oItem, EVENT_ITEM_ONHIT, "prc_ft_scorpgrsp", TRUE, FALSE);                    
        }
    }
    // We are called from the OnPlayerUnEquipItem eventhook. Remove OnHitCast: Unique Power from oPC's weapon
    else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM)
    {
        oPC   = GetItemLastUnequippedBy();
        oItem = GetItemLastUnequipped();
        if(DEBUG) DoDebug("prc_ft_scorpgrsp - OnUnEquip\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );

        // Only applies to weapons
        if (IPGetIsMeleeWeapon(oItem))
        {
            // Remove eventhook to the item
            RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "prc_ft_scorpgrsp", TRUE, FALSE);

            // Remove the temporary OnHitCastSpell: Unique
            RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", 1, DURATION_TYPE_TEMPORARY);                   
        } 
    }
}