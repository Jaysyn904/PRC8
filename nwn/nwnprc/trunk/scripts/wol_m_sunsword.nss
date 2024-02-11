//::///////////////////////////////////////////////
//:: Name           Sunsword maintain script
//:: FileName       wol_m_sunsword
//:://////////////////////////////////////////////
/*
LEGACY ITEM PENALTIES (These do not stack. Highest takes precedence).
Skill Check Penalty: -1 at 7th, -2 at 13th, -3 at 17th
Hit Point Penalty: -2 at 6th, -4 at 8th, -6 at 9th, -8 at 11th, -10 at 12th, -12 at 14th, -14 at 16th, -16 at 17th, -18 at 19th, -20 at 20th

LEGACY ITEM BONUSES
5th - +2 Bastard Sword
11th - +3 Bastard Sword
13th - +4 Bastard Sword
17th - +5 Keen Bastard Sword

LEGACY ITEM ABILITIES
Fires of the Day (Sp): At 9th, you can cast daylight once per day. At 16th level, you can use it at will.
Undeath's Bane (Su): At 10th level, you deal an extra 3d6 damage to undead
Death Ward (Sp): At 14th level, you can cast death ward once per day.
Banish Undead (Sp): At 19th level, once per day you can cast banishment on undead creatures, instead of outsiders.
Undeath to Death (Sp): At 20th level, once per day you can cast undeath to death.
*/

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;    
    object oSkin = GetPCSkin(oPC);
    int nHD = GetHitDice(oPC);
    int nHPPen = 0;
    object oWOL = GetItemPossessedBy(oPC, "WOL_Sunsword");
    
    // You get nothing if you aren't wielding the weapon
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) return;
    
    // 5th to 10th level abilities
    if (GetHasFeat(FEAT_LEAST_LEGACY, oPC))
    {
        if(nHD >= 5)
        {
        	IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(2));
        }         
        if(nHD >= 6)
        {
            nHPPen += 2;
        }     
        if(nHD >= 7)
        {
            if (13 > nHD) ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(ExtraordinaryEffect(EffectSkillDecrease(SKILL_ALL_SKILLS, 1)), "WOLEffect"), oPC);
        } 
        if(nHD >= 8)
        {
            nHPPen += 2;
        } 
        if(nHD >= 9)
        {
            nHPPen += 2;
      		IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_SUNSWORD_DAY), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }
        if(nHD >= 10)
        {
            IPSafeAddItemProperty(oWOL, ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD, IP_CONST_DAMAGETYPE_SLASHING, IP_CONST_DAMAGEBONUS_3d6));             
        }    
    }
    // 11th to 16th level abilities
    if (GetHasFeat(FEAT_LESSER_LEGACY, oPC))
    {    
        if(nHD >= 11)
        {
            nHPPen += 2;
            IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(3));
        }
        if(nHD >= 12)
        {
            nHPPen += 2;
        }    
        if(nHD >= 13)
        {
            if (17 > nHD) ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(ExtraordinaryEffect(EffectSkillDecrease(SKILL_ALL_SKILLS, 2)), "WOLEffect"), oPC);
            IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(4));
        }
        if(nHD >= 14)
        {
            nHPPen += 2;
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_SUNSWORD_WARD), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }            
        if(nHD >= 15)
        {
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
            IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(5));
            IPSafeAddItemProperty(oWOL, ItemPropertyKeen());
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(ExtraordinaryEffect(EffectSkillDecrease(SKILL_ALL_SKILLS, 3)), "WOLEffect"), oPC);
            nHPPen += 2;
        }  
        if(nHD >= 18)
        {

        } 
        if(nHD >= 19)
        {
            nHPPen += 2;
			IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_SUNSWORD_BANISH), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); 
        } 
        if(nHD >= 20)
        {
            nHPPen += 2;
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_SUNSWORD_UNDEATH), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        } 
    }    
        
    SetLocalInt(oPC, "WoLHealthPenalty", nHPPen);    
    if (!GetLocalInt(oPC, "WoLHealthPenaltyHB") && nHPPen > 0) 
    {
        WoLHealthPenaltyHB(oPC);
        SetLocalInt(oPC, "WoLHealthPenaltyHB", TRUE);
    }
    
}