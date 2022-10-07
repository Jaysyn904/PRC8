//::///////////////////////////////////////////////
//:: Name           Stalker's Bow maintain script
//:: FileName       wol_m_stalker
//:://////////////////////////////////////////////
/*
LEGACY ITEM PENALTIES (These do not stack. Highest takes precedence).
Save Penalty: -1 at 7th
Skill Penalty: -1 at 7th, -2 at 8th, -3 at 14th, -4 at 16th, -5 at 19th, -6 at 20th
Hit Point Penalty: -2 at 6th, -4 at 10th
  
LEGACY ITEM BONUSES
8th - +2 Composite Shortbow
11th - +3 Composite Shortbow
14th - +4 Composite Shortbow
17th - +5 Seeking Composite Shortbow
  
LEGACY ITEM ABILITIES
Adjustable Draw (Su): Starting at 5th level, Stalker’s Bow can apply any Strength bonus to damage. 
Obscurity (Su): At 6th level, you gain a +5 competence bonus on Hide checks.
Darkvision (Su): At 12th level, you gain darkvision. 
See Invisibility (Su): Starting at 16th level, you can see invisible creatures or objects, as if continually affected by the see invisibility spell. 
Stalker’s Insight (Su): At 18th level and higher, once per day on command, you gain a +10 insight bonus on Hide, Listen, Move Silently, Spot, and Survival checks for 1 hour. 
Ethereal Hunter (Su): Beginning at 20th level, you gain the ability to become ethereal for a total of 10 rounds per day. Activating this ability is a standard action.
*/

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int nHD = GetHitDice(oPC);
    int nHPPen = 0;
    object oWOL = GetItemPossessedBy(oPC, "WOL_StalkersBow");
    object oAmmo, oItem;
    
    // You get nothing if you aren't wielding the bow
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) 
    {
        SetCompositeBonus(oSkin, "StalkersBow_SavesF", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
        SetCompositeBonus(oSkin, "StalkersBow_SavesW", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL);
        SetCompositeBonus(oSkin, "StalkersBow_SavesR", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX);
    	SetCompositeBonus(oSkin, "StalkersBow_H", 0, ITEM_PROPERTY_SKILL_BONUS, SKILL_HIDE);
    	return;
    }
    
    // 5th to 10th level abilities
    if (GetHasFeat(FEAT_LEAST_LEGACY, oPC))
    {
        if(nHD >= 5)
        {
            IPSafeAddItemProperty(oWOL, ItemPropertyMaxRangeStrengthMod(20));        
        }         
        if(nHD >= 6)
        {
            SetCompositeBonus(oSkin, "StalkersBow_H", 5, ITEM_PROPERTY_SKILL_BONUS, SKILL_HIDE);
            nHPPen += 2;
        }     
        if(nHD >= 7)
        {
            if (8 > nHD) ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(ExtraordinaryEffect(EffectSkillDecrease(SKILL_ALL_SKILLS, 1)), "WOLEffect"), oPC);
            SetCompositeBonus(oSkin, "StalkersBow_SavesF", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
            SetCompositeBonus(oSkin, "StalkersBow_SavesW", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL);
            SetCompositeBonus(oSkin, "StalkersBow_SavesR", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX);
        } 
        if(nHD >= 8)
        {
            IPSafeAddItemProperty(oWOL, ItemPropertyAttackBonus(2));
            if (14 > nHD) ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(ExtraordinaryEffect(EffectSkillDecrease(SKILL_ALL_SKILLS, 2)), "WOLEffect"), oPC);
        } 
        if(nHD >= 9)
        {
            
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
            IPSafeAddItemProperty(oWOL, ItemPropertyAttackBonus(3));
        }
        if(nHD >= 12)
        {
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(SupernaturalEffect(EffectUltravision()), "WOLEffect"), oPC);
        }    
        if(nHD >= 13)
        {

        }
        if(nHD >= 14)
        {
            IPSafeAddItemProperty(oWOL, ItemPropertyAttackBonus(4));
            if (16 > nHD) ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(ExtraordinaryEffect(EffectSkillDecrease(SKILL_ALL_SKILLS, 3)), "WOLEffect"), oPC);
        }            
        if(nHD >= 15)
        {
         
        }    
        if(nHD >= 16)
        {
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(SupernaturalEffect(EffectSeeInvisible()), "WOLEffect"), oPC);
            if (19 > nHD) ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(ExtraordinaryEffect(EffectSkillDecrease(SKILL_ALL_SKILLS, 4)), "WOLEffect"), oPC);
        }     
    }
    // 17th+ level abilities
    if (GetHasFeat(FEAT_GREATER_LEGACY, oPC))
    {    
        if(nHD >= 17)
        {    
            IPSafeAddItemProperty(oWOL, ItemPropertyAttackBonus(5));
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_BLINDFIGHT), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }  
        if(nHD >= 18)
        {
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_SB_STALK), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        } 
        if(nHD >= 19)
        {
            if (20 > nHD) ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(ExtraordinaryEffect(EffectSkillDecrease(SKILL_ALL_SKILLS, 5)), "WOLEffect"), oPC);
        } 
        if(nHD >= 20)
        {
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(ExtraordinaryEffect(EffectSkillDecrease(SKILL_ALL_SKILLS, 6)), "WOLEffect"), oPC);
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_SB_ETHEREAL), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        } 
    } 
    
    SetLocalInt(oPC, "WoLHealthPenalty", nHPPen);    
    if (!GetLocalInt(oPC, "WoLHealthPenaltyHB") && nHPPen > 0) 
    {
        WoLHealthPenaltyHB(oPC);
        SetLocalInt(oPC, "WoLHealthPenaltyHB", TRUE);
    }    
}