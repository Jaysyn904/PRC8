//::///////////////////////////////////////////////
//:: Name           Wargird's Armor maintain script
//:: FileName       wol_m_wargirds
//:://////////////////////////////////////////////
/*
LEGACY ITEM PENALTIES (These do not stack. Highest takes precedence).
Attack Penalty: -1 at 6th, -2 at 12th, -3 at 18th
Will Save Penalty: -1 at 7th, -2 at 9th, -3 at 15th, -4 at 20th
Hit Point Penalty: -2 at 7th, -4 at 8th, -6 at 10th, -8 at 14th, -10 at 16th
  
LEGACY ITEM BONUSES
6th - +2 Breastplate
9th - +3 Breastplate
13th - +4 Breastplate
17th - +5 Breastplate
19th - +5 Breastplate of Fortification

LEGACY ITEM ABILITIES
Easy Movement (Su): Beginning at 5th level, Wargird’s Armor is treated as light armor for any purpose related to your movement. 
Warrior’s Surge (Su): At 7th level and higher, once per day when a melee attack would reduce you to 0 or fewer hit points, you immediately gain a +4 bonus to Strength and Constitution for 5 rounds. This ability activates without an action on your part—you have no control over this feature. 
Fast Movement (Su): At 10th level, you gain a 5-foot enhancement bonus to your base land speed. 
Haste (Sp): Starting at 16th level, five times per day as a swift action, you can use haste as the spell. Caster level 10th. 
Resistance to Cold (Su): At 18th level, you gain resistance to cold 20. 
Stoneskin (Sp): At 20th level and higher, once per day on command, you can use stoneskin as the spell. Caster level 15th. 
*/

void WarriorsSurge(object oPC)
{
    if (10 >= GetCurrentHitPoints(oPC) && !GetLocalInt(oPC, "WarriorsSurgeUse"))
    {
        effect eLink = EffectLinkEffects(EffectAbilityIncrease(ABILITY_STRENGTH, 4), EffectAbilityIncrease(ABILITY_CONSTITUTION, 4));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oPC, 30.0);
        SetLocalInt(oPC, "WarriorsSurgeUse", TRUE);
    }
    DelayCommand(0.25, WarriorsSurge(oPC));
}

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;    
    object oSkin = GetPCSkin(oPC);
    int nHD = GetHitDice(oPC);
    object oWOL = GetItemPossessedBy(oPC, "WOL_WargirdsArmor");
    int nHPPen = 0;
    
    // You get nothing if you aren't wielding the WOL
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_CHEST, oPC))
    {
    	SetCompositeBonus(oSkin, "Wargirds_SavesW", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL); 
    	SetCompositeAttackBonus(oPC, "Wargirds_Atk", 0, ATTACK_BONUS_MISC);
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
            SetCompositeAttackBonus(oPC, "Wargirds_Atk", -1, ATTACK_BONUS_MISC);  
            IPSafeAddItemProperty(oWOL, ItemPropertyACBonus(2));
        }     
        if(nHD >= 7)
        {
            nHPPen += 2;
            SetCompositeBonus(oSkin, "Wargirds_SavesW", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL); 
            if (!GetLocalInt(oPC, "WarriorsSurgeHB")) 
            {
                WarriorsSurge(oPC);
                SetLocalInt(oPC, "WarriorsSurgeHB", TRUE);
            }             
        } 
        if(nHD >= 8)
        {
            nHPPen += 2;            
        } 
        if(nHD >= 9)
        {
            SetCompositeBonus(oSkin, "Wargirds_SavesW", 2, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL); 
            IPSafeAddItemProperty(oWOL, ItemPropertyACBonus(3));
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
        }
        if(nHD >= 12)
        {
            SetCompositeAttackBonus(oPC, "Wargirds_Atk", -2, ATTACK_BONUS_MISC);
        }    
        if(nHD >= 13)
        {
            IPSafeAddItemProperty(oWOL, ItemPropertyACBonus(4));
        }
        if(nHD >= 14)
        {
            nHPPen += 2;        
        }            
        if(nHD >= 15)
        {
            SetCompositeBonus(oSkin, "Wargirds_SavesW", 3, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL); 
        }    
        if(nHD >= 16)
        {
            nHPPen += 2;      
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_WARGIRDS_HASTE), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }     
    }
    // 17th+ level abilities
    if (GetHasFeat(FEAT_GREATER_LEGACY, oPC))
    {    
        if(nHD >= 17)
        {    
            IPSafeAddItemProperty(oWOL, ItemPropertyACBonus(5));  
        }  
        if(nHD >= 18)
        {
            SetCompositeAttackBonus(oPC, "Wargirds_Atk", -3, ATTACK_BONUS_MISC);
            IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGERESIST_20), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        } 
        if(nHD >= 19)
        {
            IPSafeAddItemProperty(oWOL, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_CRITICAL_HITS));
        } 
        if(nHD >= 20)
        {
            SetCompositeBonus(oSkin, "Wargirds_SavesW", 4, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL); 
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_WARGIRDS_STONESKIN), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        } 
    }     
        
    SetLocalInt(oPC, "WoLHealthPenalty", nHPPen);    
    if (!GetLocalInt(oPC, "WoLHealthPenaltyHB") && nHPPen > 0) 
    {
        WoLHealthPenaltyHB(oPC);
        SetLocalInt(oPC, "WoLHealthPenaltyHB", TRUE);
    }    
}