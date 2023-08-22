//::///////////////////////////////////////////////
//:: Name           Devious maintain script
//:: FileName       wol_m_devious
//:://////////////////////////////////////////////
/*
Devious Synergy (Su): At 5th level, you gain a +5 competence bonus on Bluff checks. When Devious is within 30 feet of its twin, Vicious, this bonus increases to +7. 
Devious Eavesdropper (Sp): At 8th level and higher, once per day on command, you can use detect thoughts as the spell. The save DC is 13, or 12 + your Charisma modifier, whichever is higher. Caster level 5th. 
Completed Twin (Su): Once you reach 10th level, when Devious is within 30 feet of Vicious, its effective enhancement bonus is +1 better than normal. 
*/

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    object oItem;
    object oSkin = GetPCSkin(oPC);
    int nHD = GetHitDice(oPC);
    int nHPPen = 0;
    object oWOL = GetItemPossessedBy(oPC, "WOL_Devious");
    
    // You get nothing if you aren't wielding the legacy weapon
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC) && oWOL != GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC))
    {
        SetCompositeAttackBonus(oPC, "Devious_Atk", 0, ATTACK_BONUS_MISC);
        SetCompositeBonus(oSkin, "Devious_SavesF", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
        SetCompositeBonus(oSkin, "Devious_SavesW", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL);
        SetCompositeBonus(oSkin, "Devious_SavesR", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX);
        SetCompositeBonus(oSkin, "Vicious_Bluff", 0, ITEM_PROPERTY_SKILL_BONUS, SKILL_BLUFF);
    	return;
    }
    
    // 5th to 10th level abilities
    if (GetHasFeat(FEAT_LEAST_LEGACY, oPC))
    {
        if(nHD >= 5)
        {
            SetCompositeBonus(oSkin, "Devious_Bluff", 5, ITEM_PROPERTY_SKILL_BONUS, SKILL_BLUFF);
        }         
        if(nHD >= 6)
        {
        }     
        if(nHD >= 7)
        {
            nHPPen += 2;        
            IPSafeAddItemProperty(oWOL, ItemPropertyKeen());
        } 
        if(nHD >= 8)
        {
            SetCompositeAttackBonus(oPC, "Devious_Atk", -1, ATTACK_BONUS_MISC);
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_DEVIOUS_THOUGHTS), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        } 
        if(nHD >= 9)
        {
            SetCompositeBonus(oSkin, "Devious_SavesW", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL); 
            SetCompositeBonus(oSkin, "Devious_SavesR", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX); 
            SetCompositeBonus(oSkin, "Devious_SavesF", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);                 
        }
        if(nHD >= 10)
        {
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(EffectSkillDecrease(SKILL_ALL_SKILLS, 1)), oPC);                
        }    
    }
        
    SetLocalInt(oPC, "WoLHealthPenalty", nHPPen);    
    if (!GetLocalInt(oPC, "WoLHealthPenaltyHB") && nHPPen > 0) 
    {
        WoLHealthPenaltyHB(oPC);
        SetLocalInt(oPC, "WoLHealthPenaltyHB", TRUE);
    }
    
    object oTwin = GetItemPossessedBy(oPC, "WOL_Vicious");
    
    // You get none of this if you aren't wielding the twin
    if(oTwin != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC) && oTwin != GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC)) return;    
    // 5th to 10th level abilities
    if (GetHasFeat(FEAT_LEAST_LEGACY, oPC))
    {
        if(nHD >= 5)
        {
            SetCompositeBonus(oSkin, "Vicious_Bluff", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_BLUFF);
        }         
        if(nHD >= 10)
        {
            IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(2));                
        }    
    }    
}