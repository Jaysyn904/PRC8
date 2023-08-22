//::///////////////////////////////////////////////
//:: Name           Supernal Clarity maintain script
//:: FileName       wol_m_supernal
//:://////////////////////////////////////////////
/*
LEGACY ITEM PENALTIES (These do not stack. Highest takes precedence).
Attack Penalty: -1 at 6th, -2 at 13th
Fortitude Save Penalty: -1 at 7th, -2 at 9th, -3 at 15th, -4 at 20th
Hit Point Penalty: -2 at 7th, -4 at 8th, -6 at 10th, -8 at 14th, -10 at 16th, -12 at 20th
  
LEGACY ITEM BONUSES
10th - +2 Rapier
12th - +2 Keen Rapier
15th - +3 Keen Rapier
17th - +4 Keen Rapier
19th - +5 Keen Rapier

LEGACY ITEM ABILITIES
Intimidating Strike (Ex): At 5th level, you can use the sapphire nightmare blade maneuver five times per day.
Diamond Strike (Su): Beginning at 7th level, you gain a +1 insight bonus on any attack roll made as part of a Diamond Mind strike delivered with Supernal Clarity.
Psychic Poise (Su): At 8th level, you add your Concentration modifier to Balance for one round, three times per day.
Haste (Su): Beginning at 11th level, you can tap into the inherent speed held within Supernal Clarity. You can use haste (self only) for 1 round as a swift action. This ability is usable up to five times per day. Caster level 10th.
Uncanny Dodge (Ex): As a wielder of Supernal Clarity, you learn to be ready for battle at all times. Beginning at 13th level, you gain Uncanny Dodge.
Freedom of Movement (Sp): Starting at 16th level, you can cast freedom of movement on yourself once per day as an immediate action. This ability functions as the spell, except that the duration is 1 minute. Caster level 10th.
Time Stop (Sp): When you unlock the final legacy power of Supernal Clarity at 20th level, you gain the ability to move so quickly that time seems to halt in place. Once per day on command, you can use time stop as the spell. Caster level 20th.
*/

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int nHD = GetHitDice(oPC);
    int nHPPen = 0;
    object oWOL = GetItemPossessedBy(oPC, "WOL_Supernal");
    object oAmmo, oItem;
    
    // You get nothing if you aren't wielding the legacy item
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) 
    {
    	SetCompositeBonus(oSkin, "Supernal_SavesR", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE); 
    	SetCompositeAttackBonus(oPC, "Supernal_Atk", 0, ATTACK_BONUS_MISC);
    	return;
    }  
    
    // 5th to 10th level abilities
    if (GetHasFeat(FEAT_LEAST_LEGACY, oPC))
    {
        if(nHD >= 5)
        {
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_SUPERNAL_NIGHTMARE), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }         
        if(nHD >= 6)
        {
            SetCompositeAttackBonus(oPC, "Supernal_Atk", -1, ATTACK_BONUS_MISC);
        }     
        if(nHD >= 7)
        {
            nHPPen += 2;
            SetCompositeBonus(oSkin, "Supernal_SavesR", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE); 
            SetLocalInt(oPC, "SupernalAttack", TRUE);
        } 
        if(nHD >= 8)
        {
            nHPPen += 2;
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_SUPERNAL_PSYCHIC_POISE), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        } 
        if(nHD >= 9)
        {
           SetCompositeBonus(oSkin, "Supernal_SavesR", 2, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE); 
        }
        if(nHD >= 10)
        {
            nHPPen += 2;
            IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(2)); 
        }    
    }
    // 11th to 16th level abilities
    if (GetHasFeat(FEAT_LESSER_LEGACY, oPC))
    {    
        if(nHD >= 11)
        {
        	IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_SUPERNAL_HASTE), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }
        if(nHD >= 12)
        {
			IPSafeAddItemProperty(oWOL, ItemPropertyKeen()); 
        }    
        if(nHD >= 13)
        {
        	SetCompositeAttackBonus(oPC, "Supernal_Atk", -2, ATTACK_BONUS_MISC);
        	IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_UNCANNY_DODGE1), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }
        if(nHD >= 14)
        {
            nHPPen += 2;
        }            
        if(nHD >= 15)
        {
            SetCompositeBonus(oSkin, "Supernal_SavesR", 3, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
            IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(3)); 
        }    
        if(nHD >= 16)
        {
            nHPPen += 2;
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_SUPERNAL_FREEDOM), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }     
    }
    // 17th+ level abilities
    if (GetHasFeat(FEAT_GREATER_LEGACY, oPC))
    {    
        if(nHD >= 17)
        {    
        	IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(4)); 
        }  
        if(nHD >= 18)
        {
        	
        } 
        if(nHD >= 19)
        {
        	IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(5)); 
        } 
        if(nHD >= 20)
        {
            SetCompositeBonus(oSkin, "Supernal_SavesR", 4, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE); 
            nHPPen += 2;
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_SUPERNAL_TIMESTOP), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        } 
    }
    
    SetLocalInt(oPC, "WoLHealthPenalty", nHPPen);    
    if (!GetLocalInt(oPC, "WoLHealthPenaltyHB") && nHPPen > 0) 
    {
        WoLHealthPenaltyHB(oPC);
        SetLocalInt(oPC, "WoLHealthPenaltyHB", TRUE);
    }    
}