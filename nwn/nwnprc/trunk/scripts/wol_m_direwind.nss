//::///////////////////////////////////////////////
//:: Name           Sling of the Dire Wind maintain script
//:: FileName       wol_m_direwind
//:://////////////////////////////////////////////
/*
LEGACY ITEM PENALTIES (These do not stack. Highest takes precedence).
Attack Penalty: -1 at 6th, -2 at 12th, -3 at 18th
Will Save Penalty: -1 at 7th, -2 at 9th, -3 at 15th, -4 at 20th
Hit Point Penalty: -2 at 7th, -4 at 8th, -6 at 10th, -8 at 14th, -10 at 16th 
  
LEGACY ITEM BONUSES
7th - +2 Sling
11th - +2 Giant Bane Sling
14th - +3 Giant Bane Sling
17th - +4 Giant Bane Sling
19th - +5 Giant Bane Sling
  
LEGACY ITEM ABILITIES
Stunning Stone (Su): Beginning at 5th level, three times per day, you can declare a stone you are about to sling to be a stunning stone. If the stone hits, the struck target must succeed on a Fortitude save or be stunned for 1 round. The save DC is 11, or 11 + your Charisma modifier, whichever is higher. 
Gust of Wind (Sp): At 6th level and higher, once per day you can use gust of wind as the spell. Caster level 5th.
Pebble to Boulder (Su): Sling of the Dire Wind deals 1d8 points of damage at 8th level, 2d6 points of damage at 12th level, 3d6 points of damage at 16th level, and 4d6 points of damage at 20th level. 
Wind Wall (Sp): Beginning at 15th level, three times per day on command, you can gain 80% concealment against ranged attacks. Caster level 10th. 
Forceful Strike (Su): At 18th level and higher, any creature struck by a stone or bullet slung by Sling of the Dire Wind can be pushed back as if by a bull rush. For resolving the bull rush, the stone’s Strength modifier is +15. The stone can’t push a target back more than 5 feet. 
*/

#include "prc_inc_template"
#include "prc_inc_combmove"

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("wol_m_direwind running, event: " + IntToString(nEvent));

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
    object oWOL = GetItemPossessedBy(oPC, "WOL_SlingDireWind");
    object oAmmo, oItem;
    
    int nDamageBonus;
    if (nHD >= 8)                                          nDamageBonus = IP_CONST_DAMAGEBONUS_1d3;
    if (nHD >= 12 && GetHasFeat(FEAT_LESSER_LEGACY, oPC))  nDamageBonus = IP_CONST_DAMAGEBONUS_1d8;
    if (nHD >= 16 && GetHasFeat(FEAT_LESSER_LEGACY, oPC))  nDamageBonus = IP_CONST_DAMAGEBONUS_4d3;
    if (nHD >= 20 && GetHasFeat(FEAT_GREATER_LEGACY, oPC)) nDamageBonus = IP_CONST_DAMAGEBONUS_2d10;
    
    // You get nothing if you aren't wielding the bow
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC))
    {
        SetCompositeAttackBonus(oPC, "DireWind_Atk", 0, ATTACK_BONUS_MISC);
        SetCompositeBonus(oSkin, "DireWind_SavesW", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL);
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
                IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_DIREWIND_STUN), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            }         
            if(nHD >= 6)
            {
                SetCompositeAttackBonus(oPC, "DireWind_Atk", -1, ATTACK_BONUS_MISC);  
                IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_DIREWIND_GUST), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            }     
            if(nHD >= 7)
            {
                nHPPen += 2;
                SetCompositeBonus(oSkin, "DireWind_SavesW", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL); 
                IPSafeAddItemProperty(oWOL, ItemPropertyAttackBonus(2));
            } 
            if(nHD >= 8)
            {
                nHPPen += 2; 
                oAmmo = GetItemInSlot(INVENTORY_SLOT_BULLETS, oPC);
                IPSafeAddItemProperty(oAmmo, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_BLUDGEONING, nDamageBonus), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
                AddEventScript(oPC, EVENT_ONPLAYEREQUIPITEM,   "wol_m_direwind", TRUE, FALSE);
                AddEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM, "wol_m_direwind", TRUE, FALSE); 
            } 
            if(nHD >= 9)
            {
                SetCompositeBonus(oSkin, "DireWind_SavesW", 2, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL); 
            }
            if(nHD >= 10)
            {
                nHPPen += 2;        
            }    
        }
        // 11th to 16th level abilities
        if (GetHasFeat(FEAT_LESSER_LEGACY, oPC))
        {    
            if(nHD >= 11)
            {
                IPSafeAddItemProperty(oWOL, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_GIANT, 4));
                oAmmo = GetItemInSlot(INVENTORY_SLOT_BULLETS, oPC);
                IPSafeAddItemProperty(oAmmo, ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_GIANT,IP_CONST_DAMAGETYPE_PIERCING,IP_CONST_DAMAGEBONUS_2d6), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);             
            }
            if(nHD >= 12)
            {
                SetCompositeAttackBonus(oPC, "DireWind_Atk", -2, ATTACK_BONUS_MISC);
            }    
            if(nHD >= 13)
            {
            }
            if(nHD >= 14)
            {
                nHPPen += 2;      
                IPSafeAddItemProperty(oWOL, ItemPropertyAttackBonus(3));
                IPSafeAddItemProperty(oWOL, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_GIANT, 5));                
            }            
            if(nHD >= 15)
            {
                SetCompositeBonus(oSkin, "DireWind_SavesW", 3, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL); 
                IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_DIREWIND_WALL), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            }    
            if(nHD >= 16)
            {
                nHPPen += 2;      
            }     
        }
        // 17th+ level abilities
        if (GetHasFeat(FEAT_GREATER_LEGACY, oPC))
        {    
            if(nHD >= 17)
            {    
                IPSafeAddItemProperty(oWOL, ItemPropertyAttackBonus(4));
                IPSafeAddItemProperty(oWOL, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_GIANT, 6));                            
            }  
            if(nHD >= 18)
            {
                SetCompositeAttackBonus(oPC, "DireWind_Atk", -3, ATTACK_BONUS_MISC);
                AddEventScript(oWOL, EVENT_ITEM_ONHIT, "wol_m_direwind", TRUE, FALSE);
            } 
            if(nHD >= 19)
            {
                IPSafeAddItemProperty(oWOL, ItemPropertyAttackBonus(5));
                IPSafeAddItemProperty(oWOL, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_GIANT, 7));                            
            } 
            if(nHD >= 20)
            {
                SetCompositeBonus(oSkin, "DireWind_SavesW", 4, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL); 
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
        if(DEBUG) DoDebug("wol_m_direwind - OnEquip\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );

        if(oItem == oWOL)
        {
            oAmmo = GetItemInSlot(INVENTORY_SLOT_BULLETS, oPC);
            
            if(nHD >= 8 && GetHasFeat(FEAT_LESSER_LEGACY, oPC))
                IPSafeAddItemProperty(oAmmo, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_BLUDGEONING, nDamageBonus), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);            
            if(nHD >= 11 && GetHasFeat(FEAT_LESSER_LEGACY, oPC))
                IPSafeAddItemProperty(oAmmo, ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_GIANT,IP_CONST_DAMAGETYPE_PIERCING,IP_CONST_DAMAGEBONUS_2d6), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            if(nHD >= 18 && GetHasFeat(FEAT_GREATER_LEGACY, oPC))
            {
                AddEventScript(oAmmo, EVENT_ITEM_ONHIT, "wol_m_direwind", TRUE, FALSE);
                IPSafeAddItemProperty(oAmmo, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);           
            }              
            
        }
    }
    // We are called from the OnPlayerUnEquipItem eventhook. Remove OnHitCast: Unique Power from oPC's weapon
    else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM)
    {
        oPC   = GetItemLastUnequippedBy();
        oItem = GetItemLastUnequipped();
        if(DEBUG) DoDebug("wol_m_direwind - OnUnEquip\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );

        // Only applies to bullets
        if(GetBaseItemType(oItem) == BASE_ITEM_BULLET)
        {
            if(nHD >= 8 && GetHasFeat(FEAT_LESSER_LEGACY, oPC))
                RemoveSpecificProperty(oItem, ITEM_PROPERTY_DAMAGE_BONUS, IP_CONST_DAMAGETYPE_BLUDGEONING, nDamageBonus, 1, "", -1, DURATION_TYPE_TEMPORARY);
            if(nHD >= 11 && GetHasFeat(FEAT_LESSER_LEGACY, oPC))
                RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP,IP_CONST_RACIALTYPE_GIANT,IP_CONST_DAMAGEBONUS_2d6, 1,"",IP_CONST_DAMAGETYPE_PIERCING,DURATION_TYPE_TEMPORARY);
            if(nHD >= 18 && GetHasFeat(FEAT_GREATER_LEGACY, oPC))
            {
                RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "wol_m_direwind", TRUE, FALSE);
                RemoveSpecificProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", -1, DURATION_TYPE_TEMPORARY);            
            }    
        }
    }    
    else if(nEvent == EVENT_ITEM_ONHIT)
    {
        oItem          = GetSpellCastItem();
        object oTarget = PRCGetSpellTargetObject();
        if(DEBUG) DoDebug("wol_m_direwind: OnHit:\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                        + "oTarget = " + DebugObject2Str(oTarget) + "\n"
                          );

        // Was it Sling of the Dire Wind
        if(oItem == oWOL)
        {
            if(nHD >= 18)
            {
                _DoBullrushCheck(oPC, oTarget, 0, FALSE);
            }              
        }// end if - Item is a melee weapon
    }    
}