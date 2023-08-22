//::///////////////////////////////////////////////
//:: Name           Steadfast maintain script
//:: FileName       wol_m_steadfast
//:://////////////////////////////////////////////
/*
LEGACY ITEM BONUSES
5th - Enduring vigor 1/day 
6th – Climber 
7th - Rooted 
8th - Slow 
10th - +2 scimitar
*/

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int nHD = GetHitDice(oPC);
    int nHPPen = 0;
    object oWOL = GetItemPossessedBy(oPC, "WOL_Steadfast");
    
    // You get nothing if you aren't wielding the legacy weapon
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC))
    {
    	SetCompositeBonus(oSkin, "Steadfast_SavesR", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX);
    	SetCompositeAttackBonus(oPC, "Steadfast_AtkPen", 0, ATTACK_BONUS_MISC);
    	SetCompositeBonus(oSkin, "Steadfast_Climb", 0, ITEM_PROPERTY_SKILL_BONUS, SKILL_CLIMB);
    	return;
    }
    
    // 5th to 10th level abilities
    if (GetHasFeat(FEAT_LEAST_LEGACY, oPC))
    {
        if(nHD >= 5)
        {
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_STEADFAST_VIGOR), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }         
        if(nHD >= 6)
        {
            SetCompositeAttackBonus(oPC, "Steadfast_AtkPen", -1, ATTACK_BONUS_MISC);
            SetCompositeBonus(oSkin, "Steadfast_Climb", 5, ITEM_PROPERTY_SKILL_BONUS, SKILL_CLIMB);
        }     
        if(nHD >= 7)
        {
            nHPPen += 2;
            SetCompositeBonus(oSkin, "Steadfast_SavesR", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX);
            SetLocalInt(oPC, "Steadfast_Rooted", TRUE);
        } 
        if(nHD >= 8)
        {
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_STEADFAST_SLOW), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            nHPPen += 2;
        } 
        if(nHD >= 9)
        {
            SetCompositeBonus(oSkin, "Steadfast_SavesR", 2, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX);   
            
        }
        if(nHD >= 10)
        {
            IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(2));
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