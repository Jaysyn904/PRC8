//::///////////////////////////////////////////////
//:: Name           Flamecaster's Bolt maintain script
//:: FileName       wol_m_flmcaster
//:://////////////////////////////////////////////
/*
LEGACY ITEM PENALTIES (These do not stack. Highest takes precedence).
Attack Penalty: -1 at 9th, -2 at 13th
Save Penalty: -1 at 8th, -2 at 16th, -3 at 18th
Hit Point Penalty: -4 at 6th, -6 at 9th, -8 at 12th, -10 at 15th, -12 at 18th, -14 at 19th, -16 at 20th
  
LEGACY ITEM BONUSES
8th - +1 Flaming Light Crossbow
12th - +2 Flaming Light Crossbow
16th - +2 Seeking Flaming Light Crossbow
19th - +4 Seeking Flaming Light Crossbow
  
LEGACY ITEM ABILITIES
Marked Target (Su): At 5th level and higher, at will with a successful ranged touch attack that deals no damage, the struck target is outlined as if by a faerie fire spell. Caster level 5th. 
Shore Up Morale (Sp): Beginning at 5th level, once per day on command, you can use bless as the spell. Caster level 5th. 
Fiery Vengeance (Sp): At 7th level and higher, once per day on command, you can cause Flamecaster’s Bolt to launch a fireball as the spell. Caster level 7th. 
Shooting Wild (Su): At 10th level, the spirit within Flamecaster’s Bolt lends you what little precision Duegal enjoyed in life, granting you a +2 enhancement bonus to your Dexterity. At 14th level this bonus rises to +4, increasing to +6 at 17th level. 
Heat Shield (Su): Starting at 11th level, you gain Heat Endurance as a bonus feat.
Beyond Range (Su): At 18th level, you gain damage reduction 10/magic. 
Fury Unleashed (Su): Once you attain 20th level, Flamecaster’s Bolt gains the special purpose of defeating creatures that rely on overwhelming numbers to swarm their enemies. When facing opponents outnumbering you and your allies by at least 50 percent, you can use the fiery vengeance ability once per round without expending that ability’s normal daily use limit. This ability ceases to function once the numbers are even or to your advantage again. You can attempt to use fury unleashed when not outnumbered, but this requires a successful Will saving throw (DC 17).
*/

#include "prc_inc_template"

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("wol_m_flmcaster running, event: " + IntToString(nEvent));

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
    object oWOL = GetItemPossessedBy(oPC, "WOL_FlamecastersBolt");
    object oAmmo, oItem;
    
    // You get nothing if you aren't wielding the bow
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) 
    {
        SetCompositeAttackBonus(oPC, "Flamecasters_Atk", 0, ATTACK_BONUS_MISC);
        SetCompositeBonus(oSkin, "Flamecasters_SavesF", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
        SetCompositeBonus(oSkin, "Flamecasters_SavesW", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL);
        SetCompositeBonus(oSkin, "Flamecasters_SavesR", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX);
        SetCompositeBonus(oSkin, "Flamcasters_Dex", 0, ITEM_PROPERTY_ABILITY_BONUS,IP_CONST_ABILITY_DEX);
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
                IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_FC_MARK_TARGET), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
                IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_FC_MORALE), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            }         
            if(nHD >= 6)
            {
                nHPPen += 4;
            }     
            if(nHD >= 7)
            {
                IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_FC_FIREBALL), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            } 
                if(nHD >= 8)
            {
                SetCompositeBonus(oSkin, "Flamecasters_SavesF", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
                SetCompositeBonus(oSkin, "Flamecasters_SavesW", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL);
                SetCompositeBonus(oSkin, "Flamecasters_SavesR", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX);
            } 
            if(nHD >= 9)
            {
                SetCompositeAttackBonus(oPC, "Flamecasters_Atk", -1, ATTACK_BONUS_MISC);
                nHPPen += 2;
            }
            if(nHD >= 10)
            {
                SetCompositeBonus(oSkin, "Flamcasters_Dex", 2, ITEM_PROPERTY_ABILITY_BONUS,IP_CONST_ABILITY_DEX);
            }            
        }
        // 11th to 16th level abilities
        if (GetHasFeat(FEAT_LESSER_LEGACY, oPC))
        {    
            if(nHD >= 11)
            {
                IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_HEAT_ENDURANCE), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
                oAmmo = GetItemInSlot(INVENTORY_SLOT_BOLTS, oPC);
                IPSafeAddItemProperty(oAmmo, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d6), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);                
                if(DEBUG) DoDebug("wol_m_flmcaster: Adding eventhooks");
                AddEventScript(oPC, EVENT_ONPLAYEREQUIPITEM,   "wol_m_flmcaster", TRUE, FALSE);
                AddEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM, "wol_m_flmcaster", TRUE, FALSE);                
            }
            if(nHD >= 12)
            {
                nHPPen += 2;
                IPSafeAddItemProperty(oWOL, ItemPropertyAttackBonus(2));
            }    
            if(nHD >= 13)
            {
                SetCompositeAttackBonus(oPC, "Flamecasters_Atk", -2, ATTACK_BONUS_MISC);
            }
            if(nHD >= 14)
            {
                SetCompositeBonus(oSkin, "Flamcasters_Dex", 4, ITEM_PROPERTY_ABILITY_BONUS,IP_CONST_ABILITY_DEX);
            }            
            if(nHD >= 15)
            {
                nHPPen += 2;
            }    
            if(nHD >= 16)
            {
                SetCompositeBonus(oSkin, "Flamecasters_SavesF", 2, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
                SetCompositeBonus(oSkin, "Flamecasters_SavesW", 2, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL);
                SetCompositeBonus(oSkin, "Flamecasters_SavesR", 2, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX);
                IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_BLINDFIGHT), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            }     
        }
        // 17th+ level abilities
        if (GetHasFeat(FEAT_GREATER_LEGACY, oPC))
        {    
            if(nHD >= 17)
            {       
                SetCompositeBonus(oSkin, "Flamcasters_Dex", 6, ITEM_PROPERTY_ABILITY_BONUS,IP_CONST_ABILITY_DEX);
            }  
            if(nHD >= 18)
            {
                nHPPen += 2;
                SetCompositeBonus(oSkin, "Flamecasters_SavesF", 3, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
                SetCompositeBonus(oSkin, "Flamecasters_SavesW", 3, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL);
                SetCompositeBonus(oSkin, "Flamecasters_SavesR", 3, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX);
                IPSafeAddItemProperty(oSkin, ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_1, IP_CONST_DAMAGESOAK_10_HP), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            } 
            if(nHD >= 19)
            {
                nHPPen += 2;
                IPSafeAddItemProperty(oWOL, ItemPropertyAttackBonus(4));
            } 
            if(nHD >= 20)
            {
                nHPPen += 2;
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
        if(DEBUG) DoDebug("wol_m_flmcaster - OnEquip\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );

        // Only applies to weapons
        // IPGetIsMeleeWeapon is bugged and returns true on items it should not
        if(oItem == oWOL)
        {
            oAmmo = GetItemInSlot(INVENTORY_SLOT_BOLTS, oPC);
            IPSafeAddItemProperty(oAmmo, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d6), 99999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);                
        }
    }
    // We are called from the OnPlayerUnEquipItem eventhook. Remove OnHitCast: Unique Power from oPC's weapon
    else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM)
    {
        oPC   = GetItemLastUnequippedBy();
        oItem = GetItemLastUnequipped();
        if(DEBUG) DoDebug("wol_m_flmcaster - OnUnEquip\n"
                        + "oPC = " + DebugObject2Str(oPC) + "\n"
                        + "oItem = " + DebugObject2Str(oItem) + "\n"
                          );

        // Only applies to longbows, since we know that's what the Bow of the Black Archer is
        if(GetBaseItemType(oItem) == BASE_ITEM_BOLT)
        {
            RemoveSpecificProperty(oItem, ITEM_PROPERTY_DAMAGE_BONUS, IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d6, 1, "", -1, DURATION_TYPE_TEMPORARY);
        }
    }    
}