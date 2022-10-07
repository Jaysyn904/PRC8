//::///////////////////////////////////////////////
//:: Name           Ur maintain script
//:: FileName       wol_m_ur
//:://////////////////////////////////////////////
/*
LEGACY ITEM PENALTIES (These do not stack. Highest takes precedence).
Skill Penalty: -1 at 7th, -2 at 13th, -3 at 18th
Hit Point Penalty: -2 at 6th, -4 at 8th, -6 at 9th, -8 at 10th, -10 at 12th, -12 at 14th, -14 at 16th, -16 at 18th, -18 at 19th, -20 at 20th
  
LEGACY ITEM BONUSES
8th - +2 Handaxe
12th - +3 Handaxe
15th - +4 Handaxe
18th - +5 Keen Handaxe

LEGACY ITEM ABILITIES
Fast Movement (Su): At 6th level, your base land speed increases by 5 feet. Treat this as an enhancement bonus. At 11th level, this bonus improves to 10 feet. 
Keen Sight (Su): You gain a +5 competence bonus on Spot checks at 9th level. 
Swift Stride (Su): Starting at 10th level, three times per day as a swift action, you can grant yourself a 30foot enhancement bonus on your base land speed. The increase lasts 1 round. Caster level 5th.
Stealthy Approach (Su): At 13th level, you gain a +10 competence bonus on Move Silently checks. 
Wolf’s Cunning (Su): You are able to react to danger with surprising speed. At 16th level, you gain Improved Initiative. 
Implacable Will (Su): At 17th level, you gain a +5 morale bonus on Will saves. 
Healing Totem (Sp): Starting at 19th level, two times per day as a swift action, you can use cure critical wounds (self only) as the spell. Caster level 15th. 
Natural Lore (Su): At 19th level, you gain a +5 competence bonus on Lore checks. 
Savage Transformation (Su): Beginning at 20th level, once per day as a free action, you can enter a state of savagery lasting for 10 rounds. In this state, you are immune to poison, death effects, and fear effects. Any damage that would reduce you to –1 or fewer hit points is ignored.
*/

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;    
    object oSkin = GetPCSkin(oPC);
    int nHD = GetHitDice(oPC);
    int nHPPen = 0;
    object oWOL = GetItemPossessedBy(oPC, "WOL_Ur");
    
    // You get nothing if you aren't wielding the weapon
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) 
    {
    	SetCompositeBonus(oSkin, "Ur_Spot", 0, ITEM_PROPERTY_SKILL_BONUS, SKILL_SPOT);
    	SetCompositeBonus(oSkin, "Ur_MS", 0, ITEM_PROPERTY_SKILL_BONUS, SKILL_MOVE_SILENTLY);
    	SetCompositeBonus(oSkin, "Ur_Will", 0, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEBASETYPE_WILL);
    	SetCompositeBonus(oSkin, "Ur_Lore", 0, ITEM_PROPERTY_SKILL_BONUS, SKILL_LORE);
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
            nHPPen += 2;
        }     
        if(nHD >= 7)
        {
            if (13 > nHD) ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(ExtraordinaryEffect(EffectSkillDecrease(SKILL_ALL_SKILLS, 1)), "WOLEffect"), oPC);
        } 
        if(nHD >= 8)
        {
            nHPPen += 2;   
            IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(2));
        } 
        if(nHD >= 9)
        {
            nHPPen += 2;     
            SetCompositeBonus(oSkin, "Ur_Spot", 5, ITEM_PROPERTY_SKILL_BONUS, SKILL_SPOT);
        }
        if(nHD >= 10)
        {
            nHPPen += 2;           
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_UR_SWIFT), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);  
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
            IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(3));
        }    
        if(nHD >= 13)
        {
            if (18 > nHD) ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(ExtraordinaryEffect(EffectSkillDecrease(SKILL_ALL_SKILLS, 2)), "WOLEffect"), oPC);
            SetCompositeBonus(oSkin, "Ur_MS", 10, ITEM_PROPERTY_SKILL_BONUS, SKILL_MOVE_SILENTLY);
        }
        if(nHD >= 14)
        {
            nHPPen += 2;
        }            
        if(nHD >= 15)
        {
            IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(4));
        }    
        if(nHD >= 16)
        {
            nHPPen += 2;       
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_INIT), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE); 
        }     
    }
    // 17th+ level abilities
    if (GetHasFeat(FEAT_GREATER_LEGACY, oPC))
    {    
        if(nHD >= 17)
        {    
            SetCompositeBonus(oSkin, "Ur_Will", 5, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEBASETYPE_WILL);
        }  
        if(nHD >= 18)
        {
            nHPPen += 2;
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(ExtraordinaryEffect(EffectSkillDecrease(SKILL_ALL_SKILLS, 3)), "WOLEffect"), oPC);
            IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(5));  
            IPSafeAddItemProperty(oWOL, ItemPropertyKeen());  
        } 
        if(nHD >= 19)
        {
            nHPPen += 2;
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_UR_HEALING), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            SetCompositeBonus(oSkin, "Ur_Lore", 5, ITEM_PROPERTY_SKILL_BONUS, SKILL_LORE);
        } 
        if(nHD >= 20)
        {
            nHPPen += 2;
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_UR_SAVAGE), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);  
        } 
    }    
        
    SetLocalInt(oPC, "WoLHealthPenalty", nHPPen);    
    if (!GetLocalInt(oPC, "WoLHealthPenaltyHB") && nHPPen > 0) 
    {
        WoLHealthPenaltyHB(oPC);
        SetLocalInt(oPC, "WoLHealthPenaltyHB", TRUE);
    }
}