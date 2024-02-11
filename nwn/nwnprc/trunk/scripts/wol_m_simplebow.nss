//::///////////////////////////////////////////////
//:: Name           Simple Bow maintain script
//:: FileName       wol_m_simplebow
//:://////////////////////////////////////////////
/*
LEGACY ITEM PENALTIES (These do not stack. Highest takes precedence).
Attack Penalty: -1 at 6th
Manifester Level Penalty: -1 at 8th, -2 at 14th
Hit Point Penalty: -2 at 7th, -4 at 9th, -6 at 12th, -8 at 13th, -10 at 15th, -12 at 18th, -14 at 19th
Power Point Penalty: -2 at 7th, -4 at 10th, -6 at 13th, -8 at 16th, -10 at 18th, -12 at 20th
  
LEGACY ITEM BONUSES
11th - +2 Longbow
17th - +2 Longbow of Speed

LEGACY ITEM ABILITIES
Curve Space (Su): At 6th level, while you hold Simple Bow and are psionically focused, you gain a +1 deflection bonus to Armor Class. This bonus improves to +2 at 10th level, to +3 at 13th level, to +4 at 16th level, and to +5 at 19th level. 
Lotus Mastery (Su): At 6th level and higher, you gain a +4 bonus on saves against poison. 
Draw the Mind (Su): At 8th level, you gain a +2 enhancement bonus to Wisdom. This bonus improves to +4 at 12th level and to +6 at 15th level. 
True Seeing (Sp): Beginning at 18th level, once per day as a move action, you can use true seeing as the spell. Caster level 13th.
Simple Focus (Su): At 19th level and higher, three times per day, you can expend Simple Bow’s psionic focus, which functions just as if you had expended your own. 
Prescience of the Bow (Su): Starting at 20th level, once per day, you can apply a +15 insight bonus on any single attack roll.
*/

#include "prc_inc_template"
#include "psi_inc_ppoints"

void main()
{
    object oPC = OBJECT_SELF;    
    object oSkin = GetPCSkin(oPC);
    int nHD = GetHitDice(oPC);
    int nHPPen, nPsiPen;
    object oWOL = GetItemPossessedBy(oPC, "WOL_SimpleBow");
    
    // You get nothing if you aren't wielding the weapon
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) 
    {
        SetCompositeAttackBonus(oPC, "SimpleBow_Atk", 0, ATTACK_BONUS_MISC);
        SetCompositeBonus(oSkin, "SimpleBow_Poison", 0, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEVS_POISON);
        SetCompositeBonus(oSkin, "SimpleBow_Wis", 0, ITEM_PROPERTY_ABILITY_BONUS,IP_CONST_ABILITY_WIS);
    	return;
    }    
    
    // 5th to 10th level abilities
    if (GetHasFeat(FEAT_LEAST_LEGACY, oPC))
    {
        if(nHD >= 5)
        {
        }         
        if(nHD >= 6)
        {
            SetCompositeAttackBonus(oPC, "SimpleBow_Atk", -1, ATTACK_BONUS_MISC);
            if(10 > nHD) ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(SupernaturalEffect(EffectACIncrease(1, AC_DEFLECTION_BONUS)), "WOLEffect"), oPC);
            SetCompositeBonus(oSkin, "SimpleBow_Poison", 4, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEVS_POISON);
        }     
        if(nHD >= 7)
        {
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(ExtraordinaryEffect(EffectSkillDecrease(SKILL_ALL_SKILLS, 1)), "WOLEffect"), oPC);
            nHPPen += 2;
            nPsiPen += 2;
        } 
        if(nHD >= 8)
        {
            SetCompositeBonus(oSkin, "SimpleBow_Wis", 2, ITEM_PROPERTY_ABILITY_BONUS,IP_CONST_ABILITY_WIS);
            SetLocalInt(oPC, "WoLManifPenalty", 1);
        } 
        if(nHD >= 9)
        {
            nHPPen += 2;
        }
        if(nHD >= 10)
        {
            if(13 > nHD) ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(SupernaturalEffect(EffectACIncrease(2, AC_DEFLECTION_BONUS)), "WOLEffect"), oPC);
            nPsiPen += 2;
        }    
    }
    // 11th to 16th level abilities
    if (GetHasFeat(FEAT_LESSER_LEGACY, oPC))
    {    
        if(nHD >= 11)
        {
            IPSafeAddItemProperty(oWOL, ItemPropertyAttackBonus(2));
        }
        if(nHD >= 12)
        {
            nHPPen += 2;
            SetCompositeBonus(oSkin, "SimpleBow_Wis", 4, ITEM_PROPERTY_ABILITY_BONUS,IP_CONST_ABILITY_WIS);
        }    
        if(nHD >= 13)
        {
            nHPPen += 2;        
            if(16 > nHD) ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(SupernaturalEffect(EffectACIncrease(3, AC_DEFLECTION_BONUS)), "WOLEffect"), oPC);
            nPsiPen += 2;
        }
        if(nHD >= 14)
        {
            SetLocalInt(oPC, "WoLManifPenalty", 2);
        }            
        if(nHD >= 15)
        {
            nHPPen += 2;
            SetCompositeBonus(oSkin, "SimpleBow_Wis", 6, ITEM_PROPERTY_ABILITY_BONUS,IP_CONST_ABILITY_WIS);
        }    
        if(nHD >= 16)
        {
            if(19 > nHD) ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(SupernaturalEffect(EffectACIncrease(4, AC_DEFLECTION_BONUS)), "WOLEffect"), oPC);
            nPsiPen += 2;
        }     
    }
    // 17th+ level abilities
    if (GetHasFeat(FEAT_GREATER_LEGACY, oPC))
    {    
        if(nHD >= 17)
        {    
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(ExtraordinaryEffect(EffectModifyAttacks(1)), "WOLEffect"), oPC);
        }  
        if(nHD >= 18)
        {
            nHPPen += 2;
            nPsiPen += 2;
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_SIMPLEBOW_TRUE_SEEING), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        } 
        if(nHD >= 19)
        {
            nHPPen += 2;
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(SupernaturalEffect(EffectACIncrease(5, AC_DEFLECTION_BONUS)), "WOLEffect"), oPC);
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_SIMPLEBOW_FOCUS), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        } 
        if(nHD >= 20)
        {
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_SIMPLEBOW_PRESCIENCE), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            nPsiPen += 2;
        } 
    }    
        
    SetLocalInt(oPC, "WoLHealthPenalty", nHPPen);    
    if (!GetLocalInt(oPC, "WoLHealthPenaltyHB") && nHPPen > 0) 
    {
        WoLHealthPenaltyHB(oPC);
        SetLocalInt(oPC, "WoLHealthPenaltyHB", TRUE);
    }
   
    if (!GetLocalInt(oPC, "WoLPsiPointsPenalty") && nPsiPen > 0) 
    {
        LosePowerPoints(oPC, nPsiPen);
        SetLocalInt(oPC, "WoLPsiPointsPenalty", TRUE);
    }    
}