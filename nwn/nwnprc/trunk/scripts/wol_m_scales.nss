//::///////////////////////////////////////////////
//:: Name           Scales of Balance maintain script
//:: FileName       wol_m_scales
//:://////////////////////////////////////////////
/*
LEGACY ITEM PENALTIES (These do not stack. Highest takes precedence).
Attack Penalty: -1 at 9th, -2 at 13th
Save Penalty: -1 at 8th, -2 at 16th, -3 at 18th
Hit Point Penalty: -4 at 6th, -6 at 9th, -8 at 12th, -10 at 15th, -12 at 18th, -14 at 19th, -16 at 20th
  
LEGACY ITEM BONUSES
5th - +1 Quarterstaff
10th - +2 Quarterstaff
14th - +3 Quarterstaff

LEGACY ITEM ABILITIES
Eye of Mortality (Su): At 6th level and higher, three times per day you can cast detect undead. Caster level 5th.
Lifetouch (Sp): Beginning at 7th level, three times per day, you can use cure light wounds. Caster level 5th. 
Death’s Swift Wing (Sp): At 11th level and higher, two times per day as a swift action, you can use death knell. The save DC is 13, or 12 + your Charisma modifier, whichever is higher. Caster level 10th. 
Lifedrain (Sp): Starting at 16th level, two times per day you can use enervation as the spell. The save DC is 16, or 14 + your Charisma modifier, whichever is higher. Caster level 13th. 
Unity of Balance (Su): At 17th level, you become immune to energy drain and death effects. 
Bodily Integrity (Sp): Beginning at 18th level, once per day on command, you can use heal on yourself only, as the spell. Caster level 15th. 
Ending Point (Sp): At 20th level and higher, once per day on command, you can use finger of death. The save DC is 20, or 17 + your Charisma modifier, whichever is higher. Caster level 17th.</entry>
*/

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int nHD = GetHitDice(oPC);
    int nHPPen = 0;
    object oWOL = GetItemPossessedBy(oPC, "WOL_ScalesBalance");
    object oAmmo, oItem;
    
    // You get nothing if you aren't wielding the legacy item
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) 
    {
        SetCompositeAttackBonus(oPC, "ScalesB_Atk", 0, ATTACK_BONUS_MISC);
        SetCompositeBonus(oSkin, "ScalesB_BonusW", 0, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEBASETYPE_WILL);
        SetCompositeBonus(oSkin, "ScalesB_SavesF", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
        SetCompositeBonus(oSkin, "ScalesB_SavesW", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL);
        SetCompositeBonus(oSkin, "ScalesB_SavesR", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX);
    	return;
    }
    
    // 5th to 10th level abilities
    if (GetHasFeat(FEAT_LEAST_LEGACY, oPC))
    {
        if(nHD >= 5)
        {
            IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(1));
        }         
        if(nHD >= 6)
        {
            nHPPen += 4;
            SetCompositeBonus(oSkin, "ScalesB_BonusW", 2, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEBASETYPE_WILL);
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_SCALES_DETECT), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }     
        if(nHD >= 7)
        {
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_SCALES_CURE), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        } 
        if(nHD >= 8)
        {
            SetCompositeBonus(oSkin, "ScalesB_SavesF", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
            SetCompositeBonus(oSkin, "ScalesB_SavesW", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL);
            SetCompositeBonus(oSkin, "ScalesB_SavesR", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX);
        } 
        if(nHD >= 9)
        {
            SetCompositeAttackBonus(oPC, "ScalesB_Atk", -1, ATTACK_BONUS_MISC);
            nHPPen += 2;
        }
        if(nHD >= 10)
        {
            IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(2));
        }            
    }
    // 11th to 16th level abilities
    if (GetHasFeat(FEAT_LESSER_LEGACY, oPC))
    {    
        if(nHD >= 11)
        {
            
        }
        if(nHD >= 12)
        {
            nHPPen += 2;
        }    
        if(nHD >= 13)
        {
            SetCompositeAttackBonus(oPC, "ScalesB_Atk", -2, ATTACK_BONUS_MISC);
            
        }
        if(nHD >= 14)
        {
            IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(3));
        }            
        if(nHD >= 15)
        {
            nHPPen += 2;
        }    
        if(nHD >= 16)
        {
            SetCompositeBonus(oSkin, "ScalesB_SavesF", 2, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
            SetCompositeBonus(oSkin, "ScalesB_SavesW", 2, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL);
            SetCompositeBonus(oSkin, "ScalesB_SavesR", 2, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX);
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_SCALES_ENERV), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }     
    }
    // 17th+ level abilities
    if (GetHasFeat(FEAT_GREATER_LEGACY, oPC))
    {    
        if(nHD >= 17)
        {       
            IPSafeAddItemProperty(oSkin, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_DEATH_MAGIC), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            IPSafeAddItemProperty(oSkin, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_LEVEL_ABIL_DRAIN), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }  
        if(nHD >= 18)
        {
            nHPPen += 2;
            SetCompositeBonus(oSkin, "ScalesB_SavesF", 3, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
            SetCompositeBonus(oSkin, "ScalesB_SavesW", 3, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL);
            SetCompositeBonus(oSkin, "ScalesB_SavesR", 3, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX);
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_SCALES_HEAL), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        } 
        if(nHD >= 19)
        {
            nHPPen += 2;
        } 
        if(nHD >= 20)
        {
            nHPPen += 2;
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_SCALES_FINGER), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        } 
    }
    
    SetLocalInt(oPC, "WoLHealthPenalty", nHPPen);    
    if (!GetLocalInt(oPC, "WoLHealthPenaltyHB") && nHPPen > 0) 
    {
        WoLHealthPenaltyHB(oPC);
        SetLocalInt(oPC, "WoLHealthPenaltyHB", TRUE);
    }    
}