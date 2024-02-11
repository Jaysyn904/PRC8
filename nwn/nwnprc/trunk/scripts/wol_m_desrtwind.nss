//::///////////////////////////////////////////////
//:: Name           Desert Wind maintain script
//:: FileName       wol_m_desrtwind
//:://////////////////////////////////////////////
/*
LEGACY ITEM PENALTIES (These do not stack. Highest takes precedence).
Attack Penalty: -1 at 7th, -2 at 14th, -3 at 19th
Save Penalty: -1 at 8th, -2 at 12th
Hit Point Penalty: -2 at 6th
Skill Penalty: -1 at 9th, -2 at 16th, -3 at 20th
  
LEGACY ITEM BONUSES
9th - +2 Scimitar
16th - +2 Flaming Scimitar
18th - +3 Flaming Scimitar
20th - +4 Flaming Scimitar

LEGACY ITEM ABILITIES
Desert Child (Su): Beginning at 5th level, you get the Heat Endurance feat.
Fiery Slash (Sp): At 6th level and higher, can cast the burning hands spell three times per day. The save DC is 11, or 11 + your Charisma modifier, whichever is higher. Caster level 5th. 
Dance of Flame and Wind (Su): At 7th level, Desert Wind grants you a +2 enhancement bonus to Dexterity. This bonus increases to +4 at 14th level and to +6 at 17th level.
Howling Wind (Sp): At 12th level and higher, three times per day, you can use gust of wind as the spell. The save DC is 13, or 12 + your Charisma modifier, whichever is higher. Caster level 5th. 
Fan the Flames (Su): Beginning at 15th level, once per day, you can use fireball as the spell. You are unharmed by the resulting fire damage. The save DC is 14, or 13 + your Charisma modifier, whichever is higher. Caster level 10th. 
Dust of the Desert (Sp): At 19th level and higher, once per day you can cast the disintegrate spell. The save DC is 19, or 16 + your Charisma modifier, whichever is higher. Caster level 15th.
*/

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;    
    object oSkin = GetPCSkin(oPC);
    int nHD = GetHitDice(oPC);
    int nHPPen = 0;
    object oWOL = GetItemPossessedBy(oPC, "WOL_DesertWind");
    
    // You get nothing if you aren't wielding the weapon
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC))
    {
        SetCompositeAttackBonus(oPC, "DesertWind_Atk", 0, ATTACK_BONUS_MISC);
        SetCompositeBonus(oSkin, "DesertWind_SavesF", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
        SetCompositeBonus(oSkin, "DesertWind_SavesW", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL);
        SetCompositeBonus(oSkin, "DesertWind_SavesR", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX);
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
            nHPPen += 2;
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_DW_FIERY_SLASH), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }     
        if(nHD >= 7)
        {
            SetCompositeBonus(oSkin, "DesertWind_Dex", 2, ITEM_PROPERTY_ABILITY_BONUS,IP_CONST_ABILITY_DEX);
            SetCompositeAttackBonus(oPC, "DesertWind_Atk", -1, ATTACK_BONUS_MISC);
        } 
        if(nHD >= 8)
        {
            SetCompositeBonus(oSkin, "DesertWind_SavesF", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
            SetCompositeBonus(oSkin, "DesertWind_SavesW", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL);
            SetCompositeBonus(oSkin, "DesertWind_SavesR", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX);        
        } 
        if(nHD >= 9)
        {
            if (16 > nHD) ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(ExtraordinaryEffect(EffectSkillDecrease(SKILL_ALL_SKILLS, 1)), "WOLEffect"), oPC);     
            IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(2));
        }
        if(nHD >= 10)
        {
            
        }    
    }
    // 11th to 16th level abilities
    if (GetHasFeat(FEAT_LESSER_LEGACY, oPC))
    {    
        if(nHD >= 11)
        {
            IPSafeAddItemProperty(oWOL, ItemPropertyACBonus(1));
        }
        if(nHD >= 12)
        {
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_DW_HOWLING_WIND), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            SetCompositeBonus(oSkin, "DesertWind_SavesF", 2, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
            SetCompositeBonus(oSkin, "DesertWind_SavesW", 2, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL);
            SetCompositeBonus(oSkin, "DesertWind_SavesR", 2, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX);                    
        }    
        if(nHD >= 13)
        {
        }
        if(nHD >= 14)
        {
            SetCompositeBonus(oSkin, "DesertWind_Dex", 4, ITEM_PROPERTY_ABILITY_BONUS,IP_CONST_ABILITY_DEX);
            SetCompositeAttackBonus(oPC, "DesertWind_Atk", -2, ATTACK_BONUS_MISC);
        }            
        if(nHD >= 15)
        {
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_DW_FAN_FLAMES), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }    
        if(nHD >= 16)
        {
            if (20 > nHD) ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(ExtraordinaryEffect(EffectSkillDecrease(SKILL_ALL_SKILLS, 2)), "WOLEffect"), oPC);      
            IPSafeAddItemProperty(oWOL, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d6));
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
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_DW_DUST_DESERT), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            SetCompositeAttackBonus(oPC, "DesertWind_Atk", -3, ATTACK_BONUS_MISC);
        } 
        if(nHD >= 20)
        {
            IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(4));
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(ExtraordinaryEffect(EffectSkillDecrease(SKILL_ALL_SKILLS, 3)), "WOLEffect"), oPC);
        } 
    }    
        
    SetLocalInt(oPC, "WoLHealthPenalty", nHPPen);    
    if (!GetLocalInt(oPC, "WoLHealthPenaltyHB") && nHPPen > 0) 
    {
        WoLHealthPenaltyHB(oPC);
        SetLocalInt(oPC, "WoLHealthPenaltyHB", TRUE);
    }
    
}