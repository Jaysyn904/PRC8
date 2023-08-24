//::///////////////////////////////////////////////
//:: Name           Tiger Fang maintain script
//:: FileName       wol_m_tigerfng
//:://////////////////////////////////////////////
/*
LEGACY ITEM PENALTIES (These do not stack. Highest takes precedence).
Attack Penalty: -1 at 6th, -2 at 13th
Fortitude Save Penalty: -1 at 7th, -2 at 9th, -3 at 15th, -4 at 20th
Hit Point Penalty: -2 at 7th, -4 at 8th, -6 at 10th, -8 at 14th, -10 at 16th, -12 at 20th
  
LEGACY ITEM BONUSES
9th  - +1 Keen Kukri
17th - +3 Keen Kukri

LEGACY ITEM ABILITIES
Frenzied Charge (Ex): The first legacy ability of Tiger Fang, which you gain at 5th level, grants you the power to take one additional attack with Tiger Fang at the end of a charge. Frenzied charge is usable once per day.
Claw of the Tiger (Su): You automatically succeed on checks made to resist disarm attempts.
Tiger Leap (Ex): At 7th level, you find more spring in your step, gaining a +5 bonus on Jump checks.
Battle Fever (Su): At 10th level, you are invigorated whenever you use Tiger Fang in melee. Three times per day, you can use a swift action to heal yourself of 1d8 points of damage. At 16th level, you can use battle fever five times per day, and it heals 2d8 damage each time.
Sharp Claw (Ex): As long as you have a Tiger Claw stance active, you deal an extra 1 point of damage with all your melee attacks, including strikes, made with Tiger Fang.
Haste (Sp): When you attain 12th level, you can use haste for 1 round as a swift action. This ability is usable five times per day.
Vicious Attack (Ex): The kukri’s keen edge finds the softest places to cut, and Tiger Fang can cut even deeper. When you attain 14th level, you gain Improved Critical (Kukri).
Devastating Attack (Ex): Tiger Fang ultimately becomes a devastating weapon, capable of dropping a foe with a single, well-placed slice. When you attain 20th level, you gain Overwhelming Critical (Kukri).
*/

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int nHD = GetHitDice(oPC);
    int nHPPen = 0;
    object oWOL = GetItemPossessedBy(oPC, "WOL_TigerFang");
    object oAmmo, oItem;
    
    // You get nothing if you aren't wielding the legacy item
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) 
    {
    	SetCompositeBonus(oSkin, "TigerFang_SavesR", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE); 
    	SetCompositeAttackBonus(oPC, "TigerFang_Atk", 0, ATTACK_BONUS_MISC);
    	SetCompositeBonus(oSkin, "TigerFang_J", 0, ITEM_PROPERTY_SKILL_BONUS, SKILL_JUMP);
    	return;
    }      
    
    // 5th to 10th level abilities
    if (GetHasFeat(FEAT_LEAST_LEGACY, oPC))
    {
        if(nHD >= 5)
        {
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_TIGER_FANG_CHARGE), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }         
        if(nHD >= 6)
        {
            SetCompositeAttackBonus(oPC, "TigerFang_Atk", -1, ATTACK_BONUS_MISC);
            SetLocalInt(oPC, "TigerFangDisarm", TRUE);
        }     
        if(nHD >= 7)
        {
            nHPPen += 2;
            SetCompositeBonus(oSkin, "TigerFang_SavesR", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE); 
            SetCompositeBonus(oSkin, "TigerFang_J", 5, ITEM_PROPERTY_SKILL_BONUS, SKILL_JUMP);
        } 
        if(nHD >= 8)
        {
            nHPPen += 2;
        } 
        if(nHD >= 9)
        {
           SetCompositeBonus(oSkin, "TigerFang_SavesR", 2, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE); 
           IPSafeAddItemProperty(oWOL, ItemPropertyKeen()); 
        }
        if(nHD >= 10)
        {
            nHPPen += 2;
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_TIGER_FANG_BATTLE), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }    
    }
    // 11th to 16th level abilities
    if (GetHasFeat(FEAT_LESSER_LEGACY, oPC))
    {    
        if(nHD >= 11)
        {
        	SetLocalInt(oPC, "TigerFangSharpClaw", TRUE);
        }
        if(nHD >= 12)
        {
			IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_TIGER_FANG_HASTE), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }    
        if(nHD >= 13)
        {
        	SetCompositeAttackBonus(oPC, "TigerFang_Atk", -2, ATTACK_BONUS_MISC);
        }
        if(nHD >= 14)
        {
            nHPPen += 2;
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_KUKRI), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }            
        if(nHD >= 15)
        {
            SetCompositeBonus(oSkin, "TigerFang_SavesR", 3, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
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
        	IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(3)); 
        }  
        if(nHD >= 18)
        {
        } 
        if(nHD >= 19)
        {
        } 
        if(nHD >= 20)
        {
            SetCompositeBonus(oSkin, "TigerFang_SavesR", 4, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE); 
            nHPPen += 2;
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_OVERWHELMING_CRITICAL_KUKRI), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        } 
    }
    
    SetLocalInt(oPC, "WoLHealthPenalty", nHPPen);    
    if (!GetLocalInt(oPC, "WoLHealthPenaltyHB") && nHPPen > 0) 
    {
        WoLHealthPenaltyHB(oPC);
        SetLocalInt(oPC, "WoLHealthPenaltyHB", TRUE);
    }    
}