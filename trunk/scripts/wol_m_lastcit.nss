//::///////////////////////////////////////////////
//:: Name           Blade of the Last Citade maintain script
//:: FileName       wol_m_lastcit
//:://////////////////////////////////////////////
/*
LEGACY ITEM PENALTIES (These do not stack. Highest takes precedence).
Attack Penalty: -1 at 9th, -2 at 13th, -3 at 18th
Save Penalty: -1 at 8th, -2 at 16th
Hit Point Penalty: -4 at 6th, -6 at 9th, -8 at 12th, -10 at 15th, -12 at 19th, -14 at 20th
  
LEGACY ITEM BONUSES
6th  - +1 Longsword
8th  - +2 Longsword
11th - +3 Longsword
14th - +4 Longsword
17th - +5 Defending Longsword

LEGACY ITEM ABILITIES
Leading the Attack (Su): When you first unlock the legacy abilities of Blade of the Last Citadel at 5th level, you can use the leading the attack maneuver five times per day, as if you knew it. Initiator level 5th.
Prayer (Sp): Beginning at 10th level, you can use prayer once per day. Caster level 7th.
Remove Fear (Sp): At 12th level, you gain the ability to use remove fear as an immediate action. This ability is usable three times per day. Caster level 10th.
Cure Critical Wounds (Sp): At 16th level, you can use cure critical wounds on yourself once per day as a swift action. Caster level 11th.
Blade Barrier (Sp): Beginning at 18th level, you can cast blade barrier three times per day. Caster level 15th.
Heal (Sp): At 20th level, you can use heal on yourself once per day as a swift action. Caster level 17th.
*/

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int nHD = GetHitDice(oPC);
    int nHPPen = 0;
    object oWOL = GetItemPossessedBy(oPC, "WOL_LastCitadel");
    object oAmmo, oItem;
    
    // You get nothing if you aren't wielding the legacy item
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) 
    {
        SetCompositeAttackBonus(oPC, "LastCitadel_Atk", 0, ATTACK_BONUS_MISC);
        SetCompositeBonus(oSkin, "LastCitadel_SavesF", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
        SetCompositeBonus(oSkin, "LastCitadel_SavesW", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL);
        SetCompositeBonus(oSkin, "LastCitadel_SavesR", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX);
    	return;
    }
    
    // 5th to 10th level abilities
    if (GetHasFeat(FEAT_LEAST_LEGACY, oPC))
    {
        if(nHD >= 5)
        {
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_LAST_CITADEL_ATTACK), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }         
        if(nHD >= 6)
        {
            nHPPen += 4;
        }     
        if(nHD >= 7)
        {
        } 
        if(nHD >= 8)
        {
            SetCompositeBonus(oSkin, "LastCitadel_SavesF", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
            SetCompositeBonus(oSkin, "LastCitadel_SavesW", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL);
            SetCompositeBonus(oSkin, "LastCitadel_SavesR", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX);
            IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(2));
        } 
        if(nHD >= 9)
        {
            SetCompositeAttackBonus(oPC, "LastCitadel_Atk", -1, ATTACK_BONUS_MISC);
            nHPPen += 2;
        }
        if(nHD >= 10)
        {
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_LAST_CITADEL_PRAYER), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
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
            nHPPen += 2;
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_LAST_CITADEL_FEAR), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }    
        if(nHD >= 13)
        {
            SetCompositeAttackBonus(oPC, "LastCitadel_Atk", -2, ATTACK_BONUS_MISC);
        }
        if(nHD >= 14)
        {
        	IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(4));
        }            
        if(nHD >= 15)
        {
            nHPPen += 2;
        }    
        if(nHD >= 16)
        {
            SetCompositeBonus(oSkin, "LastCitadel_SavesF", 2, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
            SetCompositeBonus(oSkin, "LastCitadel_SavesW", 2, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL);
            SetCompositeBonus(oSkin, "LastCitadel_SavesR", 2, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX);
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_LAST_CITADEL_CURE), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }     
    }
    // 17th+ level abilities
    if (GetHasFeat(FEAT_GREATER_LEGACY, oPC))
    {    
        if(nHD >= 17)
        {       
            IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(5));
            IPSafeAddItemProperty(oWOL, ItemPropertyACBonus(1));
        }  
        if(nHD >= 18)
        {
        	SetCompositeAttackBonus(oPC, "LastCitadel_Atk", -3, ATTACK_BONUS_MISC);
        	IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_LAST_CITADEL_BLADE), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        } 
        if(nHD >= 19)
        {
            nHPPen += 2;
        } 
        if(nHD >= 20)
        {
            nHPPen += 2;
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_LAST_CITADEL_HEAL), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        } 
    }
    
    SetLocalInt(oPC, "WoLHealthPenalty", nHPPen);    
    if (!GetLocalInt(oPC, "WoLHealthPenaltyHB") && nHPPen > 0) 
    {
        WoLHealthPenaltyHB(oPC);
        SetLocalInt(oPC, "WoLHealthPenaltyHB", TRUE);
    }    
}