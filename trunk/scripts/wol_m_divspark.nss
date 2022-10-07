//::///////////////////////////////////////////////
//:: Name           Divine Spark maintain script
//:: FileName       wol_m_divspark
//:://////////////////////////////////////////////
/*
LEGACY ITEM PENALTIES (These do not stack. Highest takes precedence).
Attack Penalty: -1 at 8th
Hit Point Penalty: -2 at 6th, -4 at 7th, -6 at 9th, -8 at 13th, -10 at 15th
Spell Slot Lost: 1st at 6th, 2nd at 8th, 3rd at 10th, 4th at 12th, 5th at 14th, 6th at 16th
  
LEGACY ITEM BONUSES
6th - Scarab of Resistance +2
9th - Scarab of Resistance +3
11th - Scarab of Resistance +4
15th - Scarab of Resistance +5

LEGACY ITEM ABILITIES
Endure Evil (Su): At 5th level and higher, you enjoy the constant effect of a protection from evil spell. Caster level 5th.
Turning Grace (Su): Beginning at 7th level, you turn undead as if you were one level higher in the class that grants you the ability. You are treated as two levels higher in that class starting at 12th level, three levels higher beginning at 14th level, and four levels higher at 16th level and above. 
Fear No Evil (Sp): Starting at 10th level, once per day on command, you can use magic circle against evil as the spell. The area is always centered on you. Caster level 5th. 
Searing Light (Sp): At 13th level and higher, once per day on command, you can use searing light as the spell. The spell is maximized. Caster level 10th.
*/

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;    
    object oSkin = GetPCSkin(oPC);
    int nHD = GetHitDice(oPC);
    object oWOL = GetItemPossessedBy(oPC, "WOL_DivineSpark");
    int nHPPen = 0;
    int nSlot = 0;    
    
    // You get nothing if you aren't wielding the WOL
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_NECK, oPC)) return;
    
    // 5th to 10th level abilities
    if (GetHasFeat(FEAT_LEAST_LEGACY, oPC))
    {
        if(nHD >= 5)
        {
            ActionCastSpell(SPELL_PROTECTION_FROM_EVIL, 5, 0, 0, METAMAGIC_NONE, CLASS_TYPE_INVALID, FALSE, TRUE, oPC, TRUE, FALSE);   
        }         
        if(nHD >= 6)
        {
            nHPPen += 2;
            IPSafeAddItemProperty(oWOL, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_UNIVERSAL, 2));            
            nSlot = 1;
        }     
        if(nHD >= 7)
        {
            nHPPen += 2;
            SetLocalInt(oPC, "WOLTurning", 1);
        } 
        if(nHD >= 8)
        {
            nSlot = 2;
            SetCompositeAttackBonus(oPC, "DivSpark_Atk", -1, ATTACK_BONUS_MISC);
        } 
        if(nHD >= 9)
        {
            IPSafeAddItemProperty(oWOL, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_UNIVERSAL, 3));        
            nHPPen += 2;
        }
        if(nHD >= 10)
        {
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_DIVSPARK_FEAR), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            nSlot = 3;
        }    
    }
    // 11th to 16th level abilities
    if (GetHasFeat(FEAT_LESSER_LEGACY, oPC))
    {    
        if(nHD >= 11)
        {
            IPSafeAddItemProperty(oWOL, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_UNIVERSAL, 4));                  
        }
        if(nHD >= 12)
        {
            nSlot = 4;
            SetLocalInt(oPC, "WOLTurning", 2);
        }    
        if(nHD >= 13)
        {
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_DIVSPARK_LIGHT), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            nHPPen += 2;
        }
        if(nHD >= 14)
        {
            nSlot = 5;
            SetLocalInt(oPC, "WOLTurning", 3);
        }            
        if(nHD >= 15)
        {
            IPSafeAddItemProperty(oWOL, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_UNIVERSAL, 5));        
            nHPPen += 2;
        }    
        if(nHD >= 16)
        {
            nSlot = 6;
            SetLocalInt(oPC, "WOLTurning", 4);
        }     
    }
            
    SetLocalInt(oPC, "WoLHealthPenalty", nHPPen);    
    if (!GetLocalInt(oPC, "WoLHealthPenaltyHB") && nHPPen > 0) 
    {
        WoLHealthPenaltyHB(oPC);
        SetLocalInt(oPC, "WoLHealthPenaltyHB", TRUE);
    }
    WoLSpellSlotPenalty(oPC, nSlot);    
}