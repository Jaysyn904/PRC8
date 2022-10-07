//::///////////////////////////////////////////////
//:: Name           Exordius maintain script
//:: FileName       wol_m_exordius
//:://////////////////////////////////////////////
/*
LEGACY ITEM PENALTIES (These do not stack. Highest takes precedence).
Attack Penalty: -1 at 9th, -2 at 13th
Save Penalty: -1 at 8th, -2 at 16th, -3 at 18th
Hit Point Penalty: -4 at 6th, -6 at 9th, -8 at 12th, -10 at 15th, -12 at 18th, -14 at 19th, -16 at 20th
  
LEGACY ITEM BONUSES
8th - +2 Longsword
11th - +3 Longsword
17th - +3 Holy Longsword
20th - +5 Holy Longsword
  
LEGACY ITEM ABILITIES
Soul’s Guidance (Su): Beginning at 5th level, once per day as a standard action, you can grant yourself a +2 luck bonus on attack and damage rolls for 3 minutes. 
Will of Two (Su): At 6th level, you gain a +2 sacred bonus on all Will saves. 
Eyria’s Piety (Su): Starting at 10th level, you turn undead as though you were two levels higher in the class that grants the ability. 
Inner Strength (Sp): At 13th level and higher, once per day as a swift action, you can use cure serious wounds as the spell on yourself. Caster level 10th. 
Dismissal (Sp): Beginning at 14th level, once per day, you can force a creature to return to its native plane, as the dismissal spell. The base save DC is 16, or 14 + your Charisma modifier, whichever is higher. Add your character level to this number and subtract the target creature’s HD to determine the final save DC. Caster level 10th. 
Soul’s Sacrifice (Su): At 16th level and higher, you are immune to death effects. 
Mantle of Sacred Protection (Su): At 18th level, you gain spell resistance equal to 5 + your character level.</entry>
*/

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int nHD = GetHitDice(oPC);
    int nHPPen = 0;
    object oWOL = GetItemPossessedBy(oPC, "WOL_Exordius");
    object oAmmo, oItem;
    
    // You get nothing if you aren't wielding the legacy item
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) 
    {
        SetCompositeAttackBonus(oPC, "Exordius_Atk", 0, ATTACK_BONUS_MISC);
        SetCompositeBonus(oSkin, "Exordius_SavesF", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
        SetCompositeBonus(oSkin, "Exordius_SavesW", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL);
        SetCompositeBonus(oSkin, "Exordius_SavesR", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX);
        SetCompositeBonus(oSkin, "Exordius_BonusW", 0, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEBASETYPE_WILL);
    	return;
    }
    
    // 5th to 10th level abilities
    if (GetHasFeat(FEAT_LEAST_LEGACY, oPC))
    {
        if(nHD >= 5)
        {
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_EXORD_GUIDANCE), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }         
        if(nHD >= 6)
        {
            nHPPen += 4;
            SetCompositeBonus(oSkin, "Exordius_BonusW", 2, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEBASETYPE_WILL);
        }     
        if(nHD >= 7)
        {
        } 
        if(nHD >= 8)
        {
            SetCompositeBonus(oSkin, "Exordius_SavesF", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
            SetCompositeBonus(oSkin, "Exordius_SavesW", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL);
            SetCompositeBonus(oSkin, "Exordius_SavesR", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX);
            IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(2));
        } 
        if(nHD >= 9)
        {
            SetCompositeAttackBonus(oPC, "Exordius_Atk", -1, ATTACK_BONUS_MISC);
            nHPPen += 2;
        }
        if(nHD >= 10)
        {
            SetLocalInt(oPC, "WOLTurning", 2);
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
            SetCompositeAttackBonus(oPC, "Exordius_Atk", -2, ATTACK_BONUS_MISC);
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_EXORD_CURE), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }
        if(nHD >= 14)
        {
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_EXORD_DISMISSAL), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }            
        if(nHD >= 15)
        {
            nHPPen += 2;
        }    
        if(nHD >= 16)
        {
            SetCompositeBonus(oSkin, "Exordius_SavesF", 2, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
            SetCompositeBonus(oSkin, "Exordius_SavesW", 2, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL);
            SetCompositeBonus(oSkin, "Exordius_SavesR", 2, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX);
            IPSafeAddItemProperty(oSkin, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_DEATH_MAGIC), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }     
    }
    // 17th+ level abilities
    if (GetHasFeat(FEAT_GREATER_LEGACY, oPC))
    {    
        if(nHD >= 17)
        {       
            IPSafeAddItemProperty(oWOL, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL, IP_CONST_DAMAGETYPE_SLASHING, IP_CONST_DAMAGEBONUS_2d6));
        }  
        if(nHD >= 18)
        {
            nHPPen += 2;
            SetCompositeBonus(oSkin, "Exordius_SavesF", 3, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
            SetCompositeBonus(oSkin, "Exordius_SavesW", 3, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL);
            SetCompositeBonus(oSkin, "Exordius_SavesR", 3, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX);
            SetLocalInt(oPC, "ExordiusSR", TRUE);
        } 
        if(nHD >= 19)
        {
            nHPPen += 2;
        } 
        if(nHD >= 20)
        {
            nHPPen += 2;
            IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(5));
        } 
    }
    
    SetLocalInt(oPC, "WoLHealthPenalty", nHPPen);    
    if (!GetLocalInt(oPC, "WoLHealthPenaltyHB") && nHPPen > 0) 
    {
        WoLHealthPenaltyHB(oPC);
        SetLocalInt(oPC, "WoLHealthPenaltyHB", TRUE);
    }    
}