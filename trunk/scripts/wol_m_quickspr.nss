//::///////////////////////////////////////////////
//:: Name           Quickspur's Ally maintain script
//:: FileName       wol_m_quickspr
//:://////////////////////////////////////////////
/*
LEGACY ITEM PENALTIES (These do not stack. Highest takes precedence).
Attack Penalty: -1 at 9th, -2 at 13th
Save Penalty: -1 at 8th, -2 at 16th, -3 at 18th
Hit Point Penalty: -4 at 6th, -6 at 9th, -8 at 12th, -10 at 15th, -12 at 18th, -14 at 19th, -16 at 20th

LEGACY ITEM BONUSES
5th  - +1 bashing shield (+1 weapon)
8th  - +2 bashing shield (+1 weapon)
11th - +2 bashing shield (+2 weapon)
13th - +3 bashing shield (+2 weapon)
15th - +3 bashing shield (+3 weapon)
17th - +4 bashing shield (+4 weapon)
19th - +5 bashing shield (+5 weapon)

LEGACY ITEM ABILITIES
Quickspur (Su): At 6th level and higher, you gain a +5 competence bonus on Ride checks.
Arrowblight (Sp): At 10th level and higher, once per day you can use entropic shield as the spell. Caster level 5th.
Resist Fire (Sp): Beginning at 11th level, once per day, you can use resist elements. Caster level 5th.
Phantom Steed (Sp): Starting at 16th level, once per day, you can use phantom steed. Caster level 10th.
Weaponbend (Sp): At 18th level and higher, three times per day, you can use blur. Caster level 15th.
Stoneguard (Sp): Beginning at 20th level, once per day, you can use stoneskin. Caster level 15th.
*/

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int nHD = GetHitDice(oPC);
    int nHPPen = 0;
    object oWOL = GetItemPossessedBy(oPC, "WOL_quickspr");
    object oAmmo, oItem;
    
    // You get nothing if you aren't wielding the legacy item
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) 
    {
        SetCompositeAttackBonus(oPC, "quickspr_Atk", 0, ATTACK_BONUS_MISC);
        SetCompositeBonus(oSkin, "quickspr_SavesF", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
        SetCompositeBonus(oSkin, "quickspr_SavesW", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL);
        SetCompositeBonus(oSkin, "quickspr_SavesR", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX);
        SetCompositeBonus(oSkin, "Quickspur_Ride", 0, ITEM_PROPERTY_SKILL_BONUS, SKILL_RIDE);
    	return;
    }
    
    // 5th to 10th level abilities
    if (GetHasFeat(FEAT_LEAST_LEGACY, oPC))
    {
        if(nHD >= 5)
        {
            SetLocalInt(oPC, "BashingEnchant", 1);
        }         
        if(nHD >= 6)
        {
            nHPPen += 4;
            SetCompositeBonus(oSkin, "Quickspur_Ride", 5, ITEM_PROPERTY_SKILL_BONUS, SKILL_RIDE);
        }     
        if(nHD >= 7)
        {
        } 
        if(nHD >= 8)
        {
            SetCompositeBonus(oSkin, "quickspr_SavesF", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
            SetCompositeBonus(oSkin, "quickspr_SavesW", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL);
            SetCompositeBonus(oSkin, "quickspr_SavesR", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX);
            IPSafeAddItemProperty(oWOL, ItemPropertyACBonus(2));
        } 
        if(nHD >= 9)
        {
            SetCompositeAttackBonus(oPC, "quickspr_Atk", -1, ATTACK_BONUS_MISC);
            nHPPen += 2;
        }
        if(nHD >= 10)
        {
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_QUICKSPUR_SHIELD), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }            
    }
    // 11th to 16th level abilities
    if (GetHasFeat(FEAT_LESSER_LEGACY, oPC))
    {    
        if(nHD >= 11)
        {
        	IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_QUICKSPUR_RESIST), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        	SetLocalInt(oPC, "BashingEnchant", 2);
        }
        if(nHD >= 12)
        {
            nHPPen += 2;
        }    
        if(nHD >= 13)
        {
            SetCompositeAttackBonus(oPC, "quickspr_Atk", -2, ATTACK_BONUS_MISC);
            IPSafeAddItemProperty(oWOL, ItemPropertyACBonus(3));
        }
        if(nHD >= 14)
        {
        }            
        if(nHD >= 15)
        {
            nHPPen += 2;
            SetLocalInt(oPC, "BashingEnchant", 3);
        }    
        if(nHD >= 16)
        {
            SetCompositeBonus(oSkin, "quickspr_SavesF", 2, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
            SetCompositeBonus(oSkin, "quickspr_SavesW", 2, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL);
            SetCompositeBonus(oSkin, "quickspr_SavesR", 2, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX);
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_QUICKSPUR_STEED), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }     
    }
    // 17th+ level abilities
    if (GetHasFeat(FEAT_GREATER_LEGACY, oPC))
    {    
        if(nHD >= 17)
        {       
        	SetLocalInt(oPC, "BashingEnchant", 4);
        	IPSafeAddItemProperty(oWOL, ItemPropertyACBonus(4));
        }  
        if(nHD >= 18)
        {
            nHPPen += 2;
            SetCompositeBonus(oSkin, "quickspr_SavesF", 3, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
            SetCompositeBonus(oSkin, "quickspr_SavesW", 3, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL);
            SetCompositeBonus(oSkin, "quickspr_SavesR", 3, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX);
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_QUICKSPUR_BLUR), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        } 
        if(nHD >= 19)
        {
            nHPPen += 2;
            SetLocalInt(oPC, "BashingEnchant", 5);
            IPSafeAddItemProperty(oWOL, ItemPropertyACBonus(5));
        } 
        if(nHD >= 20)
        {
            nHPPen += 2;
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_QUICKSPUR_STONE), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        } 
    }
    
    SetLocalInt(oPC, "WoLHealthPenalty", nHPPen);    
    if (!GetLocalInt(oPC, "WoLHealthPenaltyHB") && nHPPen > 0) 
    {
        WoLHealthPenaltyHB(oPC);
        SetLocalInt(oPC, "WoLHealthPenaltyHB", TRUE);
    }    
}