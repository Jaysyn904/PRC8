//::///////////////////////////////////////////////
//:: Name           Coral's Bite maintain script
//:: FileName       wol_m_corals
//:://////////////////////////////////////////////
/*
LEGACY ITEM PENALTIES (These do not stack. Highest takes precedence).
Attack Penalty: -1 at 6th, -2 at 12th, -3 at 18th
Will Save Penalty: -1 at 7th, -2 at 9th, -3 at 15th, -4 at 20th
Hit Point Penalty: -2 at 6th, -4 at 7th, -6 at 9th, -8 at 14th, -10 at 15th
  
LEGACY ITEM BONUSES
5th  - +2 Spear
11th - +2 Monstrous Humanoid Bane Spear
16th - +3 Monstrous Humanoid Bane Spear
17th - +4 Monstrous Humanoid Bane Spear
20th - +5 Monstrous Humanoid Bane Spear

LEGACY ITEM ABILITIES
Dolphin’s Ear (Su): Beginning at 6th level, you gain a +5 bonus to Listen.
Coral Armor (Su): At 7th level, the coral from which Coral’s Bite is formed grants a +1 natural armor bonus to Armor Class. The natural armor bonus increases to +2 at 9th level, to +3 at 14th level, to +4 at 18th level, and to +5 at 20th level.
Breathless (Su): At 12th level and higher, you no longer need to breath, and are immune to effects that require breathing to function, such as drown and certain cloud spells.
*/

#include "prc_inc_template"

void main()
{
    int nEvent = GetRunningEvent();

    // Get the PC. This is event-dependent
    object oPC, oItem;
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
    object oWOL = GetItemPossessedBy(oPC, "WOL_CoralsBite");
    object oAmu = GetItemInSlot(INVENTORY_SLOT_NECK, oPC);
    
    // You get nothing if you aren't wielding the weapon
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC))
    {
        SetCompositeAttackBonus(oPC, "Corals_Atk", 0, ATTACK_BONUS_MISC);
        SetCompositeBonus(oSkin, "Corals_SavesR", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL);
        SetCompositeBonus(oSkin, "Corals_L", 0, ITEM_PROPERTY_SKILL_BONUS, SKILL_LISTEN);
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
            	IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(2));
            }         
            if(nHD >= 6)
            {
                nHPPen += 2;
                SetCompositeAttackBonus(oPC, "Corals_Atk", -1, ATTACK_BONUS_MISC);
                SetCompositeBonus(oSkin, "Corals_L", 5, ITEM_PROPERTY_SKILL_BONUS, SKILL_LISTEN);
            }     
            if(nHD >= 7)
            {
                nHPPen += 2;
                SetCompositeBonus(oSkin, "Corals_SavesR", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL); 
                if (9 > nHD) IPSafeAddItemProperty(oAmu, ItemPropertyACBonus(1), 9999.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
            } 
            if(nHD >= 8)
            {

            } 
            if(nHD >= 9)
            {
               SetCompositeBonus(oSkin, "Corals_SavesR", 2, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL); 
               nHPPen += 2;
               if (14 > nHD) IPSafeAddItemProperty(oAmu, ItemPropertyACBonus(2), 9999.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
            }
            if(nHD >= 10)
            {
            }    
        }
        // 11th to 16th level abilities
        if (GetHasFeat(FEAT_LESSER_LEGACY, oPC))
        {    
            if(nHD >= 11)
            {
                IPSafeAddItemProperty(oWOL, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_MONSTROUS, 4));
                IPSafeAddItemProperty(oWOL, ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_MONSTROUS, IP_CONST_DAMAGETYPE_PIERCING, IP_CONST_DAMAGEBONUS_2d6)); 
            }
            if(nHD >= 12)
            {
                SetCompositeAttackBonus(oPC, "Corals_Atk", -2, ATTACK_BONUS_MISC);
                IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_BREATHLESS), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            }    
            if(nHD >= 13)
            {
            }
            if(nHD >= 14)
            {
                nHPPen += 2;
                if (18 > nHD) IPSafeAddItemProperty(oAmu, ItemPropertyACBonus(3), 9999.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
            }            
            if(nHD >= 15)
            {
                SetCompositeBonus(oSkin, "Corals_SavesR", 3, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL); 
                nHPPen += 2;
            }    
            if(nHD >= 16)
            {
                IPSafeAddItemProperty(oWOL, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_MONSTROUS, 5));
                IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(3));  
            }     
        }
        // 17th+ level abilities
        if (GetHasFeat(FEAT_GREATER_LEGACY, oPC))
        {    
            if(nHD >= 17)
            {    
                IPSafeAddItemProperty(oWOL, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_MONSTROUS, 6));
                IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(4));              
            }  
            if(nHD >= 18)
            {
                SetCompositeAttackBonus(oPC, "Corals_Atk", -3, ATTACK_BONUS_MISC);
                if (20 > nHD) IPSafeAddItemProperty(oAmu, ItemPropertyACBonus(4), 9999.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
            } 
            if(nHD >= 19)
            {
                IPSafeAddItemProperty(oWOL, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_HUMANOID_MONSTROUS, 7));
                IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(5));              
            } 
            if(nHD >= 20)
            {
                SetCompositeBonus(oSkin, "Corals_SavesR", 4, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL); 
                IPSafeAddItemProperty(oAmu, ItemPropertyACBonus(5), 9999.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
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

