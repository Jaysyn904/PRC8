//::///////////////////////////////////////////////
//:: Name           Kamate maintain script
//:: FileName       wol_m_kamate
//:://////////////////////////////////////////////
/*
LEGACY ITEM PENALTIES (These do not stack. Highest takes precedence).
Attack Penalty: -1 at 9th
Save Penalty: -1 at 8th, -2 at 13th, -3 at 16th, -4 at 18th
Hit Point Penalty: -4 at 6th, -6 at 9th, -8 at 12th, -10 at 15th, -12 at 18th, -14 at 19th, -16 at 20th
  
LEGACY ITEM BONUSES
8th  - +2 Bastard Sword
11th - +3 Bastard Sword
14th - +4 Bastard Sword
16th - +4 Shocking Burst Bastard Sword
18th - +5 Shocking Burst Bastard Sword

LEGACY ITEM ABILITIES
Steel Wind (Ex): At 5th level, you can use the steel wind maneuver five times per day, as if you knew it. If you already know steel wind, you gain a +1 bonus on any attack roll you make when you initiate the maneuver.
Shocking Grasp (Su): Beginning at 6th level, you can cast shocking grasp once per day. Activating this power is a swift action. Caster level 5th.
Accurate Strike (Su): At 9th level, you gain Blind Fight.
Stance Agility (Su): Beginning at 10th level, you gain a +2 insight bonus on Reflex saves as long as you are in an Iron Heart stance. When you attain 15th level, this bonus improves to +4.
Lightning Bolt (Sp): At 13th level, you gain the ability to use lightning bolt as the spell three times per day, on command. The save DC is 14, or 13 + your Cha modifier, whichever is higher. Caster level 10th.
Chain Lightning (Sp): Beginning at 17th level, you can cause Kamate to emit a blast of lightning that arcs to other targets, as if produced by the chain lightning spell. The save DC is 16, or 14 + your Cha modifier, whichever is higher. This ability is usable once per day. Caster level 15th.
Perfect Strike (Su): At 20th level, while you are holding Kamate, you can gain a +20 competence bonus on a single attack roll. You must choose to activate this ability (an immediate action) before you make the attack roll it is to modify. This ability is usable once per day.
*/

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int nHD = GetHitDice(oPC);
    int nHPPen = 0;
    object oWOL = GetItemPossessedBy(oPC, "WOL_Kamate");
    object oAmmo, oItem;
    
    // You get nothing if you aren't wielding the legacy item
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) 
    {
        SetCompositeAttackBonus(oPC, "Kamate_Atk", 0, ATTACK_BONUS_MISC);
        SetCompositeBonus(oSkin, "Kamate_SavesF", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
        SetCompositeBonus(oSkin, "Kamate_SavesW", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL);
        SetCompositeBonus(oSkin, "Kamate_SavesR", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX);
    	return;
    }
    
    // 5th to 10th level abilities
    if (GetHasFeat(FEAT_LEAST_LEGACY, oPC))
    {
        if(nHD >= 5)
        {
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_KAMATE_STEEL_WIND), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }         
        if(nHD >= 6)
        {
            nHPPen += 4;
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_KAMATE_SHOCK), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }     
        if(nHD >= 7)
        {

        } 
        if(nHD >= 8)
        {
            SetCompositeBonus(oSkin, "Kamate_SavesF", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE); 
            SetCompositeBonus(oSkin, "Kamate_SavesR", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX); 
            SetCompositeBonus(oSkin, "Kamate_SavesW", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL); 
            IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(2));
        } 
        if(nHD >= 9)
        {
           SetCompositeAttackBonus(oPC, "Kamate_Atk", -1, ATTACK_BONUS_MISC);
           IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_BLINDFIGHT), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
           nHPPen += 2;
        }
        if(nHD >= 10)
        {
            nHPPen += 2;
            SetLocalInt(oPC, "KamateStance", 2);
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
        }    
        if(nHD >= 13)
        {
            SetCompositeBonus(oSkin, "Kamate_SavesF", 2, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE); 
            SetCompositeBonus(oSkin, "Kamate_SavesR", 2, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX); 
            SetCompositeBonus(oSkin, "Kamate_SavesW", 2, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL); 
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_KAMATE_LIGHTNING), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }
        if(nHD >= 14)
        {
			IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(4));
        }            
        if(nHD >= 15)
        {
        	nHPPen += 2;
            SetLocalInt(oPC, "KamateStance", 2); 
        }    
        if(nHD >= 16)
        {
            SetCompositeBonus(oSkin, "Kamate_SavesF", 3, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE); 
            SetCompositeBonus(oSkin, "Kamate_SavesR", 3, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX); 
            SetCompositeBonus(oSkin, "Kamate_SavesW", 3, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL);
            IPSafeAddItemProperty(oWOL, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGEBONUS_2d6));            	
        }     
    }
    // 17th+ level abilities
    if (GetHasFeat(FEAT_GREATER_LEGACY, oPC))
    {    
        if(nHD >= 17)
        {    
        	IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_KAMATE_CHAIN), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }  
        if(nHD >= 18)
        {
            SetCompositeBonus(oSkin, "Kamate_SavesF", 4, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE); 
            SetCompositeBonus(oSkin, "Kamate_SavesR", 4, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX); 
            SetCompositeBonus(oSkin, "Kamate_SavesW", 4, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL);
            IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(5));
            nHPPen += 2;
        } 
        if(nHD >= 19)
        {
        	nHPPen += 2;
        } 
        if(nHD >= 20)
        {
            nHPPen += 2;
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_KAMATE_TRUE_STRIKE), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        } 
    }
    
    SetLocalInt(oPC, "WoLHealthPenalty", nHPPen);    
    if (!GetLocalInt(oPC, "WoLHealthPenaltyHB") && nHPPen > 0) 
    {
        WoLHealthPenaltyHB(oPC);
        SetLocalInt(oPC, "WoLHealthPenaltyHB", TRUE);
    }    
}