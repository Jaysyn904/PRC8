//::///////////////////////////////////////////////
//:: Name           Crimson Ruination maintain script
//:: FileName       wol_m_crimruin
//:://////////////////////////////////////////////
/*
LEGACY ITEM PENALTIES (These do not stack. Highest takes precedence).
Skill Penalty: -1 at 7th, -2 at 13th, -3 at 18th
Hit Point Penalty: -2 at 6th, -4 at 8th, -6 at 9th, -8 at 10th, -10 at 12th, -12 at 14th, -14 at 16th, -16 at 18th, -18 at 19th, -20 at 20th
  
LEGACY ITEM BONUSES
9th - +1 dragon bane greatsword
11th - +2 dragon bane greatsword
15th - +2 frost dragon bane greatsword
17th - +3 frost keen dragon bane greatsword
20th - +4 frost keen dragon bane greatsword

LEGACY ITEM ABILITIES
Protection From Evil (Su): At 5th level and higher, you constantly benefit from the effects of a protection from evil spell. Caster level 5th. 
Dragon Armor (Su): At 6th level, you gain a +1 deflection bonus to Armor Class. This bonus increases to +2 at 13th level. 
Endure Elements (Su): Beginning at 6th level, you act as if continually under the effects of an endure elements spell. Caster level 5th. - Changed for heat endurance
Shield From Fire (Su): At 7th level, you gain resistance to fire 5. This resistance increases to 10 at 12th level and to 20 at 18th level.
Evade Fiery Doom (Su): At 14th level and higher, you gain the benefit of evasion against any dragon’s breath weapon. 
Ray of the Frozen Fate (Sp): Starting at 19th level, two times per day on command, you can use polar ray as the spell. The ray erupts from the tip of Crimson Ruination’s blade. Caster level 20th. 
*/

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;    
    object oSkin = GetPCSkin(oPC);
    int nHD = GetHitDice(oPC);
    int nHPPen = 0;
    object oWOL = GetItemPossessedBy(oPC, "WOL_CrimsonRuination");
    
    // You get nothing if you aren't wielding the weapon
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) return;
    
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
            if (13 > nHD) ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(SupernaturalEffect(EffectACIncrease(1, AC_DEFLECTION_BONUS)), "WOLEffect"), oPC);
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_HEAT_ENDURANCE), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }     
        if(nHD >= 7)
        {
            
            if (13 > nHD) ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(ExtraordinaryEffect(EffectSkillDecrease(SKILL_ALL_SKILLS, 1)), "WOLEffect"), oPC);
            IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGERESIST_5), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        } 
            if(nHD >= 8)
        {
            nHPPen += 2;
        } 
        if(nHD >= 9)
        {
            nHPPen += 2;
            IPSafeAddItemProperty(oWOL, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_DRAGON, 3));
            IPSafeAddItemProperty(oWOL, ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_DRAGON, IP_CONST_DAMAGETYPE_SLASHING, IP_CONST_DAMAGEBONUS_2d6));            
        }
        if(nHD >= 10)
        {
            nHPPen += 2;
            
        }    
    }
    // 11th to 16th level abilities
    if (GetHasFeat(FEAT_LESSER_LEGACY, oPC))
    {    
        if(nHD >= 11)
        {
            IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(2));
            IPSafeAddItemProperty(oWOL, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_DRAGON, 4));
        }
        if(nHD >= 12)
        {
            nHPPen += 2;
            IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGERESIST_10), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }    
        if(nHD >= 13)
        {
            if (18 > nHD) ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(ExtraordinaryEffect(EffectSkillDecrease(SKILL_ALL_SKILLS, 2)), "WOLEffect"), oPC);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(SupernaturalEffect(EffectACIncrease(2, AC_DEFLECTION_BONUS)), "WOLEffect"), oPC);
        }
        if(nHD >= 14)
        {
            nHPPen += 2;
        }            
        if(nHD >= 15)
        {
            IPSafeAddItemProperty(oWOL, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGEBONUS_1d6));
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
            IPSafeAddItemProperty(oWOL, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_DRAGON, 5));
            IPSafeAddItemProperty(oWOL, ItemPropertyKeen());
        }  
        if(nHD >= 18)
        {
            nHPPen += 2;
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(ExtraordinaryEffect(EffectSkillDecrease(SKILL_ALL_SKILLS, 3)), "WOLEffect"), oPC);
            IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGERESIST_20), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        } 
        if(nHD >= 19)
        {
            nHPPen += 2;

            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_CR_FROZEN_FATE), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        } 
        if(nHD >= 20)
        {
            nHPPen += 2;
            IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(4));
            IPSafeAddItemProperty(oWOL, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_DRAGON, 6));
        } 
    }    
        
    SetLocalInt(oPC, "WoLHealthPenalty", nHPPen);    
    if (!GetLocalInt(oPC, "WoLHealthPenaltyHB") && nHPPen > 0) 
    {
        WoLHealthPenaltyHB(oPC);
        SetLocalInt(oPC, "WoLHealthPenaltyHB", TRUE);
    }
    
}