//::///////////////////////////////////////////////
//:: Name           Unfettered maintain script
//:: FileName       wol_m_unfetter
//:://////////////////////////////////////////////
/*
LEGACY ITEM PENALTIES (These do not stack. Highest takes precedence).
Attack Penalty: -1 at 6th, -2 at 13th
Reflex Save Penalty: -1 at 7th, -2 at 9th, -3 at 15th, -4 at 20th
Hit Point Penalty: -2 at 7th, -4 at 8th, -6 at 10th, -8 at 14th, -10 at 16th, -12 at 20th
  
LEGACY ITEM BONUSES
7th  - +2 Greatsword
11th - +3 Greatsword
15th - +4 Greatsword
18th - +5 Greatsword

LEGACY ITEM ABILITIES
Charging Minotaur (Su): When you first unlock the legacy abilities of Unfettered at 5th level, you can use the charging minotaur maneuver five times per day, as if you knew it. Initiator level 5th.
Strength Enhancement (Su): Beginning at 9th level, you gain a +2 enhancement bonus to your Strength score as long as you hold Unfettered. This bonus improves to +4 at 13th level, and to +6 at 17th level.
Enlarge (Sp): When you attain 10th level, you can increase your size as if you had cast enlarge person on yourself. Caster level 5th.
Etherealness (Sp): Beginning at 12th level, you can become ethereal temporarily. This ability is usable once per day. Caster level 10th.
Fortification (Su): When you attain 16th level, any sneak attack scored on you is negated. 
Stoneskin (Sp): At 19th level, you gain the ability to use stoneskin on yourself once per day. Caster level 13th.
Mordenkainen’s Sword (Sp): At 20th level, you can cast Mordenkainen’s Sword once per day. Caster level 17th.
*/

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int nHD = GetHitDice(oPC);
    int nHPPen = 0;
    object oWOL = GetItemPossessedBy(oPC, "WOL_Unfettered");
    object oAmmo, oItem;
    
    // You get nothing if you aren't wielding the legacy item
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC))
    {
    	SetCompositeBonus(oSkin, "Unfettered_SavesR", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX); 
    	SetCompositeAttackBonus(oPC, "Unfettered_Atk", 0, ATTACK_BONUS_MISC);
        SetCompositeBonus(oSkin, "Unfettered_Str", 0, ITEM_PROPERTY_ABILITY_BONUS,IP_CONST_ABILITY_STR);
    	return;
    }     
    
    // 5th to 10th level abilities
    if (GetHasFeat(FEAT_LEAST_LEGACY, oPC))
    {
        if(nHD >= 5)
        {
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_UNFETTERED_MINOTAUR), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }         
        if(nHD >= 6)
        {
            SetCompositeAttackBonus(oPC, "Unfettered_Atk", -1, ATTACK_BONUS_MISC);
        }     
        if(nHD >= 7)
        {
            nHPPen += 2;
            IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(2));
            SetCompositeBonus(oSkin, "Unfettered_SavesR", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX); 
        } 
        if(nHD >= 8)
        {
            nHPPen += 2;
        } 
        if(nHD >= 9)
        {
           SetCompositeBonus(oSkin, "Unfettered_SavesR", 2, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX); 
           SetCompositeBonus(oSkin, "Unfettered_Str", 2, ITEM_PROPERTY_ABILITY_BONUS,IP_CONST_ABILITY_STR);
        }
        if(nHD >= 10)
        {
            nHPPen += 2;
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_UNFETTERED_ENLARGE), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
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
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_UNFETTERED_ETHEREAL), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }    
        if(nHD >= 13)
        {
        	SetCompositeAttackBonus(oPC, "Unfettered_Atk", -2, ATTACK_BONUS_MISC);
        	SetCompositeBonus(oSkin, "Unfettered_Str", 4, ITEM_PROPERTY_ABILITY_BONUS,IP_CONST_ABILITY_STR);
        }
        if(nHD >= 14)
        {
            nHPPen += 2;
        }            
        if(nHD >= 15)
        {
            SetCompositeBonus(oSkin, "Unfettered_SavesR", 3, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX);
            IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(4));    
        }    
        if(nHD >= 16)
        {
            nHPPen += 2;
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_IMMUNITY_SNEAKATTACK), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);        
        }     
    }
    // 17th+ level abilities
    if (GetHasFeat(FEAT_GREATER_LEGACY, oPC))
    {    
        if(nHD >= 17)
        {    
            SetCompositeBonus(oSkin, "Unfettered_Str", 6, ITEM_PROPERTY_ABILITY_BONUS,IP_CONST_ABILITY_STR);
        }  
        if(nHD >= 18)
        {
        	IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(5));
        } 
        if(nHD >= 19)
        {
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_UNFETTERED_STONESKIN), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        } 
        if(nHD >= 20)
        {
            SetCompositeBonus(oSkin, "Unfettered_SavesR", 4, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX); 
            nHPPen += 2;
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_UNFETTERED_SWORD), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        } 
    }
    
    SetLocalInt(oPC, "WoLHealthPenalty", nHPPen);    
    if (!GetLocalInt(oPC, "WoLHealthPenaltyHB") && nHPPen > 0) 
    {
        WoLHealthPenaltyHB(oPC);
        SetLocalInt(oPC, "WoLHealthPenaltyHB", TRUE);
    }    
}