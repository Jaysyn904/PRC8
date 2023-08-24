//::///////////////////////////////////////////////
//:: Name           Thaas maintain script
//:: FileName       wol_m_thaas
//:://////////////////////////////////////////////
/*
LEGACY ITEM PENALTIES (These do not stack. Highest takes precedence).
Attack Penalty: -1 at 6th, -2 at 12th, -3 at 18th
Reflex Save Penalty: -1 at 7th, -2 at 9th, -3 at 15th, -4 at 20th
Hit Point Penalty: -2 at 7th, -4 at 8th, -6 at 10th, -8 at 14th, -10 at 16th 

LEGACY ITEM BONUSES
6th  - +1 Outsider Bane Longbow
13th - +2 Outsider Bane Longbow
16th - +3 Outsider Bane Longbow
20th - +3 Holy Outsider Bane Longbow

LEGACY ITEM ABILITIES
Sense Demons (Su): At 5th level, you can detect evil outsiders, as if using the detect evil spell. Caster level 5th.
Strength Adjusting (Su): At 8th level, Thaas accepts any strength as a composite longbow.
Obstruct Summoning (Su): At 10th level, you can banish any summons created by evil outsiders of 10 hit dice or less as a swift action, no save, by targeting the summoner. At 17th level, this applies to any evil outsider.
Banishment (Sp): At 18th level, you can cast banishment, once per day. Save DC is 20 or 17 + Charisma modifier, whichever is higher. Caster level 15th.
Teleport (Sp): Starting at 19th level, you can teleport once per day. Caster level 20th.
*/

#include "prc_inc_template"
#include "prc_inc_combmove"

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("wol_m_Thaas running, event: " + IntToString(nEvent));

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
    itemproperty ipIP;
    int nMaxHP = GetMaxHitPoints(oPC);
    int nCurHP = GetCurrentHitPoints(oPC);
    int nHPPen = 0;
    object oWOL = GetItemPossessedBy(oPC, "WOL_Thaas");
    object oAmmo, oItem;
    
    // You get nothing if you aren't wielding the bow
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) 
    {
    	SetCompositeBonus(oSkin, "Thaas_SavesW", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX); 
    	SetCompositeAttackBonus(oPC, "Thaas_Atk", 0, ATTACK_BONUS_MISC);
    	return;
    }     
    
    // We aren't being called from any event, instead from EvalPRCFeats
    if(nEvent == FALSE)
    {    
        // 5th to 10th level abilities
        if (GetHasFeat(FEAT_LEAST_LEGACY, oPC))
        {
            if(nHD >= 5)
            {
                IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_THAAS_DETECT), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            }         
            if(nHD >= 6)
            {
                SetCompositeAttackBonus(oPC, "Thaas_Atk", -1, ATTACK_BONUS_MISC);  
                oAmmo = GetItemInSlot(INVENTORY_SLOT_ARROWS, oPC);
                IPSafeAddItemProperty(oAmmo, ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_OUTSIDER, IP_CONST_DAMAGETYPE_PIERCING, IP_CONST_DAMAGEBONUS_2d6), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
                AddEventScript(oPC, EVENT_ONPLAYEREQUIPITEM,   "wol_m_thaas", TRUE, FALSE);
                AddEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM, "wol_m_thaas", TRUE, FALSE);                 
            }     
            if(nHD >= 7)
            {
                nHPPen += 2;
                SetCompositeBonus(oSkin, "Thaas_SavesW", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX); 
            } 
            if(nHD >= 8)
            {
                nHPPen += 2; 
            } 
            if(nHD >= 9)
            {
                SetCompositeBonus(oSkin, "Thaas_SavesW", 2, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX); 
            }
            if(nHD >= 10)
            {
                nHPPen += 2;       
                IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_THAAS_OBSTRUCT), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            }    
        }
        // 11th to 16th level abilities
        if (GetHasFeat(FEAT_LESSER_LEGACY, oPC))
        {    
            if(nHD >= 11)
            {
            }
            if(nHD >= 12)
            {
                SetCompositeAttackBonus(oPC, "Thaas_Atk", -2, ATTACK_BONUS_MISC);
            }    
            if(nHD >= 13)
            {
            	IPSafeAddItemProperty(oWOL, ItemPropertyAttackBonus(2));
            }
            if(nHD >= 14)
            {
                nHPPen += 2;      
            }            
            if(nHD >= 15)
            {
                SetCompositeBonus(oSkin, "Thaas_SavesW", 3, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX); 
            }    
            if(nHD >= 16)
            {
                nHPPen += 2;      
                IPSafeAddItemProperty(oWOL, ItemPropertyAttackBonus(3));
            }     
        }
        // 17th+ level abilities
        if (GetHasFeat(FEAT_GREATER_LEGACY, oPC))
        {    
            if(nHD >= 17)
            {    
            }  
            if(nHD >= 18)
            {
                SetCompositeAttackBonus(oPC, "Thaas_Atk", -3, ATTACK_BONUS_MISC);
                IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_THAAS_BANISH), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            } 
            if(nHD >= 19)
            {
                IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_THAAS_TELEPORT), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            } 
            if(nHD >= 20)
            {
                SetCompositeBonus(oSkin, "Thaas_SavesW", 4, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX); 
                oAmmo = GetItemInSlot(INVENTORY_SLOT_ARROWS, oPC);
                IPSafeAddItemProperty(oAmmo, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL, IP_CONST_DAMAGETYPE_PIERCING, IP_CONST_DAMAGEBONUS_2d6), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            } 
        }     
            
        SetLocalInt(oPC, "WoLHealthPenalty", nHPPen);    
        if (!GetLocalInt(oPC, "WoLHealthPenaltyHB") && nHPPen > 0) 
        {
            WoLHealthPenaltyHB(oPC);
            SetLocalInt(oPC, "WoLHealthPenaltyHB", TRUE);
        }
    }
    // We are called from the OnPlayerEquipItem eventhook. Add OnHitCast: Unique Power to oPC's weapon
    else if(nEvent == EVENT_ONPLAYEREQUIPITEM)
    {
        oPC   = GetItemLastEquippedBy();
        oItem = GetItemLastEquipped();
        if(DEBUG) DoDebug("wol_m_Thaas - OnEquip\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );

        if(oItem == oWOL)
        {
            oAmmo = GetItemInSlot(INVENTORY_SLOT_ARROWS, oPC);
            
            if(nHD >= 6 && GetHasFeat(FEAT_LEAST_LEGACY, oPC))
                IPSafeAddItemProperty(oAmmo, ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_OUTSIDER, IP_CONST_DAMAGETYPE_PIERCING, IP_CONST_DAMAGEBONUS_2d6), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            if(nHD >= 20 && GetHasFeat(FEAT_GREATER_LEGACY, oPC))
                IPSafeAddItemProperty(oAmmo, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL, IP_CONST_DAMAGETYPE_PIERCING, IP_CONST_DAMAGEBONUS_2d6), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }
    }
    // We are called from the OnPlayerUnEquipItem eventhook. Remove OnHitCast: Unique Power from oPC's weapon
    else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM)
    {
        oPC   = GetItemLastUnequippedBy();
        oItem = GetItemLastUnequipped();
        if(DEBUG) DoDebug("wol_m_Thaas - OnUnEquip\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );

        // Only applies to bullets
        if(GetBaseItemType(oItem) == INVENTORY_SLOT_ARROWS)
        {
            if(nHD >= 6 && GetHasFeat(FEAT_LEAST_LEGACY, oPC))
                RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP,IP_CONST_RACIALTYPE_OUTSIDER,IP_CONST_DAMAGEBONUS_2d6, 1,"",IP_CONST_DAMAGETYPE_PIERCING,DURATION_TYPE_TEMPORARY);
            if(nHD >= 20 && GetHasFeat(FEAT_GREATER_LEGACY, oPC))
                RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP,IP_CONST_ALIGNMENTGROUP_EVIL,IP_CONST_DAMAGEBONUS_2d6, 1,"",IP_CONST_DAMAGETYPE_PIERCING,DURATION_TYPE_TEMPORARY);
        }
    }    
}