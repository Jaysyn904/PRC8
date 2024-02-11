//::///////////////////////////////////////////////
//:: Name           Caput Mortuum maintain script
//:: FileName       wol_m_cptmortum
//:://////////////////////////////////////////////
/*
LEGACY ITEM BONUSES
5th - +1 Vicious Scythe
9th - +2 Vicious Scythe
11th - +3 Vicious Scythe
13th - +4 Vicious Scythe
15th - +5 Vicious Scythe
17th - +5 Unholy Vicious Scythe
19th - +5 Unholy Vicious Wounding Scythe
*/

#include "prc_inc_template"

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("wol_m_cptmortum running, event: " + IntToString(nEvent));

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
    int nHD = GetHitDice(oPC);
    int nHPPen = 0;
    int nSlot = 0;
    object oWOL = GetItemPossessedBy(oPC, "WOL_CaputMortuum");
    object oAmmo, oItem;
    
    // You get nothing if you aren't wielding the bow
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) return;
    
    // We aren't being called from any event, instead from EvalPRCFeats
    if(nEvent == FALSE)
    {    
        // 5th to 10th level abilities
        if (GetHasFeat(FEAT_LEAST_LEGACY, oPC))
        {
            if(nHD >= 5)
            {
                IPSafeAddItemProperty(oWOL, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_PIERCING, IP_CONST_DAMAGEBONUS_2d6));
                if(DEBUG) DoDebug("wol_m_cptmortum: Adding eventhooks");
                AddEventScript(oPC, EVENT_ONPLAYEREQUIPITEM,   "wol_m_cptmortum", TRUE, FALSE);
                AddEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM, "wol_m_cptmortum", TRUE, FALSE); 
                AddEventScript(oWOL, EVENT_ITEM_ONHIT, "wol_m_cptmortum", TRUE, FALSE);

                // Add the OnHitCastSpell: Unique needed to trigger the event
                IPSafeAddItemProperty(oWOL, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);                
            }         
            if(nHD >= 6)
            {
                nHPPen += 2;
                nSlot = 1;
            }     
            if(nHD >= 7)
            {
                nHPPen += 2;
            } 
            if(nHD >= 8)
            {
                SetCompositeAttackBonus(oPC, "WeaponofLegacy", -1, ATTACK_BONUS_MISC);
                nSlot = 2;
            } 
            if(nHD >= 9)
            {
                nHPPen += 2;
                // Adds in the plus 1 that exists on the bow by default
                IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(2));
            }
            if(nHD >= 10)
            {
                nSlot = 3;
            }    
        }
        // 11th to 16th level abilities
        if (GetHasFeat(FEAT_LESSER_LEGACY, oPC))
        {    
            if(nHD >= 11)
            {
                IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(3));               
            }
            if(nHD >= 12)
            {
                nSlot = 4;
            }    
            if(nHD >= 13)
            {
                nHPPen += 2;
                IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(4));              
            }
            if(nHD >= 14)
            {
                nSlot = 5;
            }            
            if(nHD >= 15)
            {
                nHPPen += 2;
                IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(5));
            }    
            if(nHD >= 16)
            {
                nSlot = 6;
            }     
        }
        // 17th+ level abilities
        if (GetHasFeat(FEAT_GREATER_LEGACY, oPC))
        {    
            if(nHD >= 17)
            {    
                IPSafeAddItemProperty(oWOL, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_GOOD, IP_CONST_DAMAGETYPE_PIERCING, IP_CONST_DAMAGEBONUS_2d6));
            }  
            if(nHD >= 18)
            {
                nSlot = 7;
            } 
            if(nHD >= 19)
            {
                nHPPen += 2;
            } 
            if(nHD >= 20)
            {
                nSlot = 8;
            } 
        }    
            
        SetLocalInt(oPC, "WoLHealthPenalty", nHPPen);    
        if (!GetLocalInt(oPC, "WoLHealthPenaltyHB") && nHPPen > 0) 
        {
            WoLHealthPenaltyHB(oPC);
            SetLocalInt(oPC, "WoLHealthPenaltyHB", TRUE);
        }
        WoLSpellSlotPenalty(oPC, nSlot);
    }
    // We are called from the OnPlayerEquipItem eventhook. Add OnHitCast: Unique Power to oPC's weapon
    else if(nEvent == EVENT_ONPLAYEREQUIPITEM)
    {
        oPC   = GetItemLastEquippedBy();
        oItem = GetItemLastEquipped();
        if(DEBUG) DoDebug("wol_m_cptmortum - OnEquip\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );

        // Only applies to weapons
        // IPGetIsMeleeWeapon is bugged and returns true on items it should not
        if(oItem == oWOL)
        {
            // Add eventhook to the item
            AddEventScript(oItem, EVENT_ITEM_ONHIT, "wol_m_cptmortum", TRUE, FALSE);

            // Add the OnHitCastSpell: Unique needed to trigger the event
            IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }
    }
    // We are called from the OnPlayerUnEquipItem eventhook. Remove OnHitCast: Unique Power from oPC's weapon
    else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM)
    {
        oPC   = GetItemLastUnequippedBy();
        oItem = GetItemLastUnequipped();
        if(DEBUG) DoDebug("wol_m_cptmortum - OnUnEquip\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );

        // Only applies to the WoL
        if(GetBaseItemType(oItem) == BASE_ITEM_SCYTHE)
        {
            // Add eventhook to the item
            RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "wol_m_cptmortum", TRUE, FALSE);

            // Remove the temporary OnHitCastSpell: Unique
            // Makes sure to get ammo if its a ranged weapon
            RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", -1, DURATION_TYPE_TEMPORARY);
        }
    }  
    else if(nEvent == EVENT_ITEM_ONHIT)
    {
        oItem          = GetSpellCastItem();
        object oTarget = PRCGetSpellTargetObject();
        if(DEBUG) DoDebug("wol_m_cptmortum: OnHit:\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                        + "oTarget = " + DebugObject2Str(oTarget) + "\n"
                          );

        // Was it Caput Mortuum
        if(oItem == oWOL)
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6(), DAMAGE_TYPE_POSITIVE), oPC);
            // Only works on those not critical immune
            if (nHD >= 19 && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT))
                ApplyAbilityDamage(oTarget, ABILITY_CONSTITUTION, 1, DURATION_TYPE_PERMANENT);
        }// end if - Item is a melee weapon
    }// end if - Running OnHit event    
}