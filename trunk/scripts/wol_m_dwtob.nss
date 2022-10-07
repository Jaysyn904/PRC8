//::///////////////////////////////////////////////
//:: Name           Desert Wind ToB maintain script
//:: FileName       wol_m_dwtob
//:://////////////////////////////////////////////
/*
LEGACY ITEM PENALTIES (These do not stack. Highest takes precedence).
Attack Penalty: -1 at 6th, -2 at 13th
Fortitude Save Penalty: -1 at 7th, -2 at 9th, -3 at 15th, -4 at 20th
Hit Point Penalty: -2 at 7th, -4 at 8th, -6 at 10th, -8 at 14th, -10 at 16th, -12 at 20th
  
LEGACY ITEM BONUSES
9th  - +1 Flaming Scimitar
11th - +2 Flaming Scimitar
16th - +2 Flaming Burst Scimitar
18th - +3 Flaming Burst Scimitar
20th - +4 Flaming Burst Scimitar

LEGACY ITEM ABILITIES
Desert Child (Su): Beginning at 5th level, you get the Heat Endurance feat.
Fiery Slash (Sp): At 6th level and higher, can cast the burning hands spell three times per day. The save DC is 11, or 11 + your Charisma modifier, whichever is higher. Caster level 5th. 
Dance of Flame and Wind (Su): At 7th level, Desert Wind grants you a +2 enhancement bonus to Dexterity. This bonus increases to +4 at 14th level and to +6 at 17th level.
Burning Blade (Su): At 12th level and higher, you can initiate the burning blade maneuver up to three times per day.
Fan the Flames (Su): Beginning at 15th level, you can use the fan the flames maneuver at will.
Wyrm's Flame (Su): At 19th level and higher, you can use the wyrm’s flame maneuver three times per day.
*/

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int nHD = GetHitDice(oPC);
    int nHPPen = 0;
    object oWOL = GetItemPossessedBy(oPC, "WOL_DesertWindTOB");
    object oAmmo, oItem;
    
    // You get nothing if you aren't wielding the legacy item
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) 
    {
        SetCompositeAttackBonus(oPC, "DesertWindToB_Atk", 0, ATTACK_BONUS_MISC);
        SetCompositeBonus(oSkin, "DesertWindToB_SavesR", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
        SetCompositeBonus(oSkin, "DesertWind_Dex", 0, ITEM_PROPERTY_ABILITY_BONUS,IP_CONST_ABILITY_DEX);
    	return;
    }
    
    // 5th to 10th level abilities
    if (GetHasFeat(FEAT_LEAST_LEGACY, oPC))
    {
        if(nHD >= 5)
        {
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_HEAT_ENDURANCE), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }         
        if(nHD >= 6)
        {
            SetCompositeAttackBonus(oPC, "DesertWindToB_Atk", -1, ATTACK_BONUS_MISC);
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_DW_FIERY_SLASH), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }     
        if(nHD >= 7)
        {
            nHPPen += 2;
            SetCompositeBonus(oSkin, "DesertWind_Dex", 2, ITEM_PROPERTY_ABILITY_BONUS,IP_CONST_ABILITY_DEX);
            SetCompositeBonus(oSkin, "DesertWindToB_SavesR", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE); 
        } 
        if(nHD >= 8)
        {
            nHPPen += 2;
        } 
        if(nHD >= 9)
        {
           SetCompositeBonus(oSkin, "DesertWindToB_SavesR", 2, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE); 
           IPSafeAddItemProperty(oWOL, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d6));
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
            IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(2));    
        }
        if(nHD >= 12)
        {
        	IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_DWTOB_BURNING_BLADE), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }    
        if(nHD >= 13)
        {
        	SetCompositeAttackBonus(oPC, "DesertWindToB_Atk", -2, ATTACK_BONUS_MISC);
        }
        if(nHD >= 14)
        {
            nHPPen += 2;
            SetCompositeBonus(oSkin, "DesertWind_Dex", 4, ITEM_PROPERTY_ABILITY_BONUS,IP_CONST_ABILITY_DEX);
        }            
        if(nHD >= 15)
        {
            SetCompositeBonus(oSkin, "DesertWindToB_SavesR", 3, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_DWTOB_FAN_THE_FLAMES), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }    
        if(nHD >= 16)
        {
            nHPPen += 2;
            IPSafeAddItemProperty(oWOL, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_2d6));            	
        }     
    }
    // 17th+ level abilities
    if (GetHasFeat(FEAT_GREATER_LEGACY, oPC))
    {    
        if(nHD >= 17)
        {    
            SetCompositeBonus(oSkin, "DesertWind_Dex", 6, ITEM_PROPERTY_ABILITY_BONUS,IP_CONST_ABILITY_DEX);
        }  
        if(nHD >= 18)
        {
        	IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(3));
        } 
        if(nHD >= 19)
        {
        	IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_DWTOB_WYRMS_FLAME), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        } 
        if(nHD >= 20)
        {
            SetCompositeBonus(oSkin, "DesertWindToB_SavesR", 4, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE); 
            nHPPen += 2;
            IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(4));    
        } 
    }
    
    SetLocalInt(oPC, "WoLHealthPenalty", nHPPen);    
    if (!GetLocalInt(oPC, "WoLHealthPenaltyHB") && nHPPen > 0) 
    {
        WoLHealthPenaltyHB(oPC);
        SetLocalInt(oPC, "WoLHealthPenaltyHB", TRUE);
    }    
}