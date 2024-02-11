//::///////////////////////////////////////////////
//:: Name           Notched Spear maintain script
//:: FileName       wol_m_notched
//:://////////////////////////////////////////////
/*
LEGACY ITEM PENALTIES (These do not stack. Highest takes precedence).
Skill Penalty: -1 at 7th, -2 at 13th, -3 at 18th
Hit Point Penalty: -2 at 6th, -4 at 8th, -6 at 9th, -8 at 10th, -10 at 12th, -12 at 14th, -14 at 16th, -16 at 18th, -18 at 19th, -20 at 20th
  
LEGACY ITEM BONUSES
8th - +1 Monstrous Humanoid Bane Spear
10th - +2 Monstrous Humanoid Bane Spear
13th - +3 Monstrous Humanoid Bane Spear
16th - +4 Monstrous Humanoid Bane Spear
20th - +5 Monstrous Humanoid Bane Spear

LEGACY ITEM ABILITIES
Parliament of Fishes (Su): Beginning at 5th level, you can cast charm animals at will. Caster level 5th. 
Concealment of the Kraken (Sp): At 6th level and higher, three times per day on command, you can use darkness as the spell. Caster level 3rd. 
Scion of the Sea (Sp): At 14th level and higher, once per day, you can cast summon nature’s ally IV spell. Caster level 10th. 
Paths of the Tides (Su): Beginning at 17th level, you persistently gain the benefit of a freedom of movement spell. Caster level 15th. 
Command the Sea Children (Sp): At 19th level and higher, three times per day on command, you can use summon nature’s ally IX as the spell. Caster level 20th.
*/

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;    
    object oSkin = GetPCSkin(oPC);
    int nHD = GetHitDice(oPC);
    int nHPPen = 0;
    object oWOL = GetItemPossessedBy(oPC, "WOL_NotchedSpear");
    
    // You get nothing if you aren't wielding the weapon
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) return;
    
    // 5th to 10th level abilities
    if (GetHasFeat(FEAT_LEAST_LEGACY, oPC))
    {
        if(nHD >= 5)
        {
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_NS_FISHES), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }         
        if(nHD >= 6)
        {
            nHPPen += 2;
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_NS_KRAKEN), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }     
        if(nHD >= 7)
        {
            if (13 > nHD) ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(ExtraordinaryEffect(EffectSkillDecrease(SKILL_ALL_SKILLS, 1)), "WOLEffect"), oPC);
        } 
        if(nHD >= 8)
        {
            nHPPen += 2;
            IPSafeAddItemProperty(oWOL, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_MONSTROUS, 3));
            IPSafeAddItemProperty(oWOL, ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_MONSTROUS, IP_CONST_DAMAGETYPE_PIERCING, IP_CONST_DAMAGEBONUS_2d6));              
        } 
        if(nHD >= 9)
        {
            nHPPen += 2;          
        }
        if(nHD >= 10)
        {
            nHPPen += 2;
            IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(2));
            IPSafeAddItemProperty(oWOL, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_MONSTROUS, 4));            
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
            if (18 > nHD) ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(ExtraordinaryEffect(EffectSkillDecrease(SKILL_ALL_SKILLS, 2)), "WOLEffect"), oPC);
            IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(3));
            IPSafeAddItemProperty(oWOL, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_MONSTROUS, 5));  
        }
        if(nHD >= 14)
        {
            nHPPen += 2;
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_NS_SCION), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }            
        if(nHD >= 15)
        {
        }    
        if(nHD >= 16)
        {
            nHPPen += 2;
            IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(4));
            IPSafeAddItemProperty(oWOL, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_MONSTROUS, 6));              
        }     
    }
    // 17th+ level abilities
    if (GetHasFeat(FEAT_GREATER_LEGACY, oPC))
    {    
        if(nHD >= 17)
        {    
            ActionCastSpell(SPELL_FREEDOM_OF_MOVEMENT, 15, 0, 0, METAMAGIC_NONE, CLASS_TYPE_INVALID, FALSE, TRUE, oPC, TRUE, FALSE);
        }  
        if(nHD >= 18)
        {
            nHPPen += 2;
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(ExtraordinaryEffect(EffectSkillDecrease(SKILL_ALL_SKILLS, 3)), "WOLEffect"), oPC);
        } 
        if(nHD >= 19)
        {
            nHPPen += 2;
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_NS_SEA_CHILDREN), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        } 
        if(nHD >= 20)
        {
            nHPPen += 2;
            IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(5));
            IPSafeAddItemProperty(oWOL, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_MONSTROUS, 7));  
        } 
    }    
        
    SetLocalInt(oPC, "WoLHealthPenalty", nHPPen);    
    if (!GetLocalInt(oPC, "WoLHealthPenaltyHB") && nHPPen > 0) 
    {
        WoLHealthPenaltyHB(oPC);
        SetLocalInt(oPC, "WoLHealthPenaltyHB", TRUE);
    }
}