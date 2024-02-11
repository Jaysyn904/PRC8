//::///////////////////////////////////////////////
//:: Name           Infiltrator maintain script
//:: FileName       wol_m_infil
//:://////////////////////////////////////////////
/*
LEGACY ITEM PENALTIES (These do not stack. Highest takes precedence).
Reflex Save Penalty: -1 at 7th, -2 at 12th
Hit Point Penalty: -2 at 6th, -4 at 10th
Skill Check Penalty: -1 at 7th, -2 at 8th, -3 at 14th, -4 at 16th, -5 at 19th, -6 at 20th

LEGACY ITEM BONUSES
12th - +3 Mithral Chain Shirt

LEGACY ITEM ABILITIES
Low Light Vision (Su): At 5th level, you gain lowlight vision.
Collecting Facts (Su): At 6th level, Infiltrator grants you a +5 competence bonus on Spot checks. At 18th level, this bonus increases to +15.
Thorough Sweep (Su): At 8th level, Infiltrator grants you a +5 competence bonus on Search checks. At 19th level, this bonus increases to +15.
Higher Vantage (Su): At 10th level, Infiltrator grants you a +5 competence bonus on Climb checks. At 13th level, this bonus increases to +15.
Darkvision (Su): At 11th level, you gain darkvision with a range of 60 feet. 
Fly on the Wall (Sp): At 15th level and higher, at will on command, you can use invisibility as the spell. Caster level 10th.
Incisive Mind (Sp): Beginning at 16th level, you gain a +2 bonus to Bluff, Persuade, and Intimidate.
See Invisible (Su): At 17th level, you gain the ability to see invisible creatures.
Nondetection (Su): Starting at 20th level, you act as if constantly under the effects of a nondetection spell. Caster level 5th.
*/

#include "prc_inc_template"

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("wol_m_fullmoon running, event: " + IntToString(nEvent));

    // Get the PC. This is event-dependent
    object oPC;
    switch(nEvent)
    {
        case EVENT_ITEM_ONHIT:          oPC = OBJECT_SELF;               break;
        case EVENT_ONPLAYEREQUIPITEM:   oPC = GetItemLastEquippedBy();   break;
        case EVENT_ONPLAYERUNEQUIPITEM: oPC = GetItemLastUnequippedBy(); break;
        case EVENT_ONHEARTBEAT:         oPC = OBJECT_SELF;               break;

        default:
            oPC = OBJECT_SELF;
    }
    
    object oSkin = GetPCSkin(oPC);
    int nHD = GetHitDice(oPC);
    int nHPPen = 0;
    int nSlot = 0;
    object oWOL = GetItemPossessedBy(oPC, "WOL_FullMoon");
    object oAmmo, oItem;
    
    // You get nothing if you aren't wielding the item
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC))
    {
        SetCompositeBonus(oSkin, "Infiltrator_Sp", 0, ITEM_PROPERTY_SKILL_BONUS, SKILL_SPOT);
        SetCompositeBonus(oSkin, "Infiltrator_Se", 0, ITEM_PROPERTY_SKILL_BONUS, SKILL_SEARCH);
        SetCompositeBonus(oSkin, "Infiltrator_Cl", 0, ITEM_PROPERTY_SKILL_BONUS, SKILL_CLIMB);
        SetCompositeBonus(oSkin, "Infiltrator_Bl", 0, ITEM_PROPERTY_SKILL_BONUS, SKILL_BLUFF);
        SetCompositeBonus(oSkin, "Infiltrator_Pe", 0, ITEM_PROPERTY_SKILL_BONUS, SKILL_PERSUADE);
        SetCompositeBonus(oSkin, "Infiltrator_In", 0, ITEM_PROPERTY_SKILL_BONUS, SKILL_INTIMIDATE);
    	return;
    }
    
    // We aren't being called from any event, instead from EvalPRCFeats
    if(nEvent == FALSE)
    {    
        // 5th to 10th level abilities
        if (GetHasFeat(FEAT_LEAST_LEGACY, oPC))
        {
            if(nHD >= 5)
            {
				IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_LOWLIGHT_VISION), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            }         
            if(nHD >= 6)
            {
                nHPPen += 2;
                SetCompositeBonus(oSkin, "Infiltrator_Sp", 5, ITEM_PROPERTY_SKILL_BONUS, SKILL_SPOT);
            }     
            if(nHD >= 7)
            {
                if (8 > nHD) ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(ExtraordinaryEffect(EffectSkillDecrease(SKILL_ALL_SKILLS, 1)), "WOLEffect"), oPC);
            } 
            if(nHD >= 8)
            {
                if (14 > nHD) ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(ExtraordinaryEffect(EffectSkillDecrease(SKILL_ALL_SKILLS, 2)), "WOLEffect"), oPC);
                SetCompositeBonus(oSkin, "Infiltrator_Se", 5, ITEM_PROPERTY_SKILL_BONUS, SKILL_SEARCH);
            } 
            if(nHD >= 9)
            {
            }
            if(nHD >= 10)
            {
                nHPPen += 2;
                SetCompositeBonus(oSkin, "Infiltrator_Cl", 5, ITEM_PROPERTY_SKILL_BONUS, SKILL_CLIMB);
            }    
        }
        // 11th to 16th level abilities
        if (GetHasFeat(FEAT_LESSER_LEGACY, oPC))
        {    
            if(nHD >= 11)
            {
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(SupernaturalEffect(EffectUltravision()), "WOLEffect"), oPC);
                IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_DARKVISION), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
                IPSafeAddItemProperty(oSkin, ItemPropertyDarkvision(), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            }
            if(nHD >= 12)
            {
            	IPSafeAddItemProperty(oWOL, ItemPropertyACBonus(3));
            }    
            if(nHD >= 13)
            {
				SetCompositeBonus(oSkin, "Infiltrator_Cl", 15, ITEM_PROPERTY_SKILL_BONUS, SKILL_CLIMB);
            }
            if(nHD >= 14)
            {
                if (16 > nHD) ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(ExtraordinaryEffect(EffectSkillDecrease(SKILL_ALL_SKILLS, 3)), "WOLEffect"), oPC);
            }            
            if(nHD >= 15)
            {
            	IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_UMBRAL_INVIS), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            }    
            if(nHD >= 16)
            {
                if (19 > nHD) ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(ExtraordinaryEffect(EffectSkillDecrease(SKILL_ALL_SKILLS, 4)), "WOLEffect"), oPC);
                SetCompositeBonus(oSkin, "Infiltrator_Bl", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_BLUFF);
                SetCompositeBonus(oSkin, "Infiltrator_Pe", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_PERSUADE);
                SetCompositeBonus(oSkin, "Infiltrator_In", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_INTIMIDATE);
            }     
        }
        // 17th+ level abilities
        if (GetHasFeat(FEAT_GREATER_LEGACY, oPC))
        {    
            if(nHD >= 17)
            {    
            	ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(SupernaturalEffect(EffectSeeInvisible()), "WOLEffect"), oPC);
            }  
            if(nHD >= 18)
            {
            	SetCompositeBonus(oSkin, "Infiltrator_Sp", 15, ITEM_PROPERTY_SKILL_BONUS, SKILL_SPOT);
            } 
            if(nHD >= 19)
            {
                if (20 > nHD) ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(ExtraordinaryEffect(EffectSkillDecrease(SKILL_ALL_SKILLS, 5)), "WOLEffect"), oPC);
                SetCompositeBonus(oSkin, "Infiltrator_Se", 15, ITEM_PROPERTY_SKILL_BONUS, SKILL_SEARCH);
            } 
            if(nHD >= 20)
            {
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(ExtraordinaryEffect(EffectSkillDecrease(SKILL_ALL_SKILLS, 6)), "WOLEffect"), oPC);
                ActionCastSpell(SPELL_NONDETECTION, 5, 0, 0, METAMAGIC_NONE, CLASS_TYPE_INVALID, FALSE, TRUE, oPC, TRUE, FALSE);
            } 
        }    
            
        SetLocalInt(oPC, "WoLHealthPenalty", nHPPen);    
        if (!GetLocalInt(oPC, "WoLHealthPenaltyHB") && nHPPen > 0) 
        {
            WoLHealthPenaltyHB(oPC);
            SetLocalInt(oPC, "WoLHealthPenaltyHB", TRUE);
        }
    }
}