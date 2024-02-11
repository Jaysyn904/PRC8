//::///////////////////////////////////////////////
//:: Name           Bones of Li Peng maintain script
//:: FileName       wol_m_lipeng
//:://////////////////////////////////////////////
/*
LEGACY ITEM PENALTIES (These do not stack. Highest takes precedence).
Attack Penalty: -1 at 6th, -2 at 13th
Skill Check Penalty: -1 at 6th, -3 at 10th, -4 at 15th, -5 at 16th, -6 at 19th
Hit Point Penalty: -2 at 6th, -4 at 10th, -6 at 14th, -8 at 18th
  
LEGACY ITEM BONUSES
7th  - +2 Kama
10th - +2 Defending Kama
11th - +2 Defending Holy Kama
15th - +3 Defending Holy Kama
17th - +4 Defending Holy Kama
20th - +5 Defending Holy Kama

LEGACY ITEM ABILITIES
Master’s Grace (Su): At 5th level, you acquire some of Li-Peng’s legendary nimbleness, gaining a +2 enhancement bonus to Dexterity. At 18th level, this bonus rises to +6.
Student of the Master (Su): Beginning at 13th level, you are treated as a monk five levels higher than your actual monk level for purposes of unarmed damage. You can make one additional stunning attack per day, if you have the Stunning Fist feat. If you have no monk levels, you gain the unarmed damage of a 5th-level monk. This bonus does not include a monk’s Wisdom bonus to Armor Class.
Oneness of Balance (Su): At 19th level, you gain a +10 competence bonus on Balance, Jump, and Tumble checks.
*/

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;    
    object oSkin = GetPCSkin(oPC);
    int nHD = GetHitDice(oPC);
    int nHPPen = 0;
    object oWOL = GetItemPossessedBy(oPC, "WOL_LiPeng");
    
    // You get nothing if you don't have the kama
    if(!GetIsObjectValid(oWOL))
    {
        SetCompositeAttackBonus(oPC, "LiPeng_Atk", 0, ATTACK_BONUS_MISC);
	    SetCompositeBonus(oSkin, "LiPeng_Dex", 0, ITEM_PROPERTY_ABILITY_BONUS,IP_CONST_ABILITY_DEX);
        SetCompositeBonus(oSkin, "LiPeng_B", 0, ITEM_PROPERTY_SKILL_BONUS, SKILL_BALANCE);
        SetCompositeBonus(oSkin, "LiPeng_T", 0, ITEM_PROPERTY_SKILL_BONUS, SKILL_TUMBLE);
        SetCompositeBonus(oSkin, "LiPeng_J", 0, ITEM_PROPERTY_SKILL_BONUS, SKILL_JUMP);
    	return;
    }
    
    // 5th to 10th level abilities
    if (GetHasFeat(FEAT_LEAST_LEGACY, oPC))
    {
        if(nHD >= 5)
        {
        	SetCompositeBonus(oSkin, "LiPeng_Dex", 2, ITEM_PROPERTY_ABILITY_BONUS,IP_CONST_ABILITY_DEX);
        }         
        if(nHD >= 6)
        {
            nHPPen += 2;
            if (10 > nHD) ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(ExtraordinaryEffect(EffectSkillDecrease(SKILL_ALL_SKILLS, 1)), "WOLEffect"), oPC);     
        }     
        if(nHD >= 7)
        {
            SetCompositeAttackBonus(oPC, "LiPeng_Atk", -1, ATTACK_BONUS_MISC);
            IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(2));
        } 
        if(nHD >= 8)
        {

        } 
        if(nHD >= 9)
        {
            
        }
        if(nHD >= 10)
        {
            nHPPen += 2;
            if (15 > nHD) ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(ExtraordinaryEffect(EffectSkillDecrease(SKILL_ALL_SKILLS, 3)), "WOLEffect"), oPC);     
            IPSafeAddItemProperty(oWOL, ItemPropertyACBonus(1));
        }    
    }
    // 11th to 16th level abilities
    if (GetHasFeat(FEAT_LESSER_LEGACY, oPC))
    {    
        if(nHD >= 11)
        {
            IPSafeAddItemProperty(oWOL, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL, IP_CONST_DAMAGETYPE_SLASHING, IP_CONST_DAMAGEBONUS_2d6));
        }
        if(nHD >= 12)
        {
                  
        }    
        if(nHD >= 13)
        {
        	SetCompositeAttackBonus(oPC, "LiPeng_Atk", -2, ATTACK_BONUS_MISC);
        	SetLocalInt(oPC, "LiPengMonk", 5);
        	SetLocalInt(oPC, "LiPengStun", 1);
        }
        if(nHD >= 14)
        {
            nHPPen += 2;
        }            
        if(nHD >= 15)
        {
        	IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(3));
        	if (16 > nHD) ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(ExtraordinaryEffect(EffectSkillDecrease(SKILL_ALL_SKILLS, 4)), "WOLEffect"), oPC);     
        }    
        if(nHD >= 16)
        {
            if (19 > nHD) ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(ExtraordinaryEffect(EffectSkillDecrease(SKILL_ALL_SKILLS, 5)), "WOLEffect"), oPC);      
        }     
    }
    // 17th+ level abilities
    if (GetHasFeat(FEAT_GREATER_LEGACY, oPC))
    {    
        if(nHD >= 17)
        {    
            IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(4));
        }  
        if(nHD >= 18)
        {
        	nHPPen += 2;
        	SetCompositeBonus(oSkin, "LiPeng_Dex", 6, ITEM_PROPERTY_ABILITY_BONUS,IP_CONST_ABILITY_DEX);
        } 
        if(nHD >= 19)
        {
        	ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(ExtraordinaryEffect(EffectSkillDecrease(SKILL_ALL_SKILLS, 6)), "WOLEffect"), oPC);     
        	SetCompositeBonus(oSkin, "LiPeng_B", 10, ITEM_PROPERTY_SKILL_BONUS, SKILL_BALANCE);
        	SetCompositeBonus(oSkin, "LiPeng_T", 10, ITEM_PROPERTY_SKILL_BONUS, SKILL_TUMBLE);
        	SetCompositeBonus(oSkin, "LiPeng_J", 10, ITEM_PROPERTY_SKILL_BONUS, SKILL_JUMP);
        } 
        if(nHD >= 20)
        {
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