//::///////////////////////////////////////////////
//:: Name           Faithful Avenger maintain script
//:: FileName       wol_m_faithful
//:://////////////////////////////////////////////
/*
LEGACY ITEM PENALTIES (These do not stack. Highest takes precedence).
Attack Penalty: -1 at 6th, -2 at 13th
Fortitude Save Penalty: -1 at 7th, -2 at 9th, -3 at 15th, -4 at 20th
Hit Point Penalty: -2 at 7th, -4 at 8th, -6 at 10th, -8 at 14th, -10 at 16th, -12 at 20th
  
LEGACY ITEM BONUSES
7th  - +2 Cold Iron Greatsword
13th - +2 Holy Cold Iron Greatsword
18th - +3 Holy Cold Iron Greatsword

LEGACY ITEM ABILITIES
Faithful Strike (Ex): You get a +1 attack bonus against evil enemies. If you are lawful, you get a +1 bonus against chaotic enemies. If you are chaotic, you get a +1 bonus against lawful enemies.
Blessing of Faith (Su): At 9th level, you gain a +2 enhancement bonus to your Constitution score. This bonus increases to +4 at 15th level and to +6 at 19th level.
Detect Evil (Sp): At 10th level and higher, you can use detect evil, as the spell, at will (CL 10th).
Lesser Restoration (Sp): At 11th level, you can use lesser restoration, as the spell, three times per day (CL 10th).
Boundless Determination (Ex): When you attain 16th level, you gain the ability to assume the immortal fortitude stance. If you already possess this class feature, your immortal fortitude stance grants you temporary hit points each round
equal to your total crusader level.
Restoration (Sp): At 17th level, you can use restoration on yourself once per day as a swift action (CL 15th).
Resiliency (Ex): At 20th level, you gain the ability to ignore damage for one round once per day.
*/

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int nHD = GetHitDice(oPC);
    int nHPPen = 0;
    object oWOL = GetItemPossessedBy(oPC, "WOL_Faithful");
    object oAmmo, oItem;
    
    // You get nothing if you aren't wielding the legacy item
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) 
    {
        SetCompositeAttackBonus(oPC, "Faithful_Atk", 0, ATTACK_BONUS_MISC);
        SetCompositeBonus(oSkin, "Faithful_SavesR", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
        SetCompositeBonus(oSkin, "Faithful_Con", 0, ITEM_PROPERTY_ABILITY_BONUS,IP_CONST_ABILITY_CON);
    	return;
    }
    
    // 5th to 10th level abilities
    if (GetHasFeat(FEAT_LEAST_LEGACY, oPC))
    {
        if(nHD >= 5)
        {
            ActionCastSpell(WOL_FAITHFUL_STRIKE, 5, 0, 0, METAMAGIC_NONE, CLASS_TYPE_INVALID, FALSE, TRUE, oPC, TRUE, FALSE);
        }         
        if(nHD >= 6)
        {
            SetCompositeAttackBonus(oPC, "Faithful_Atk", -1, ATTACK_BONUS_MISC);
        }     
        if(nHD >= 7)
        {
            nHPPen += 2;
            IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(2));   
            SetCompositeBonus(oSkin, "Faithful_SavesR", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE); 
        } 
        if(nHD >= 8)
        {
            nHPPen += 2;
        } 
        if(nHD >= 9)
        {
           SetCompositeBonus(oSkin, "Faithful_SavesR", 2, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE); 
           SetCompositeBonus(oSkin, "Faithful_Con", 2, ITEM_PROPERTY_ABILITY_BONUS,IP_CONST_ABILITY_CON);
        }
        if(nHD >= 10)
        {
            nHPPen += 2;
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_FAITHFUL_DETECT), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }    
    }
    // 11th to 16th level abilities
    if (GetHasFeat(FEAT_LESSER_LEGACY, oPC))
    {    
        if(nHD >= 11)
        {
             IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_FAITHFUL_LR), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }
        if(nHD >= 12)
        {

        }    
        if(nHD >= 13)
        {
        	SetCompositeAttackBonus(oPC, "Faithful_Atk", -2, ATTACK_BONUS_MISC);
        	IPSafeAddItemProperty(oWOL, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL, IP_CONST_DAMAGETYPE_SLASHING, IP_CONST_DAMAGEBONUS_2d6));
        }
        if(nHD >= 14)
        {
            nHPPen += 2;
        }            
        if(nHD >= 15)
        {
            SetCompositeBonus(oSkin, "Faithful_SavesR", 3, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
            SetCompositeBonus(oSkin, "Faithful_Con", 4, ITEM_PROPERTY_ABILITY_BONUS,IP_CONST_ABILITY_CON);
        }    
        if(nHD >= 16)
        {
            nHPPen += 2;
    		IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_FAITHFUL_IMMORTAL), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }     
    }
    // 17th+ level abilities
    if (GetHasFeat(FEAT_GREATER_LEGACY, oPC))
    {    
        if(nHD >= 17)
        {    
        	IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_FAITHFUL_RESTORE), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }  
        if(nHD >= 18)
        {
        	IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(3));
        } 
        if(nHD >= 19)
        {
        	SetCompositeBonus(oSkin, "Faithful_Con", 6, ITEM_PROPERTY_ABILITY_BONUS,IP_CONST_ABILITY_CON);
        } 
        if(nHD >= 20)
        {
            SetCompositeBonus(oSkin, "Faithful_SavesR", 4, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE); 
            nHPPen += 2;
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_FAITHFUL_RESILIENCY), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        } 
    }
    
    SetLocalInt(oPC, "WoLHealthPenalty", nHPPen);    
    if (!GetLocalInt(oPC, "WoLHealthPenaltyHB") && nHPPen > 0) 
    {
        WoLHealthPenaltyHB(oPC);
        SetLocalInt(oPC, "WoLHealthPenaltyHB", TRUE);
    }    
}