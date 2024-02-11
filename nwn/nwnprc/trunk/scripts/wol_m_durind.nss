//::///////////////////////////////////////////////
//:: Name           Durindana maintain script
//:: FileName       wol_m_durind
//:://////////////////////////////////////////////
/*
LEGACY ITEM PENALTIES (These do not stack. Highest takes precedence).
Attack Penalty: -1 at 9th, -2 at 13th
Save Penalty: -1 at 8th, -2 at 15th, -3 at 18th
Hit Point Penalty: -4 at 6th, -6 at 9th, -8 at 11th, -10 at 18th, -12 at 19th, -14 at 20th

LEGACY ITEM BONUSES
9th  - +2 Longsword
11th - +2 Holy Longsword
15th - +3 Holy Longsword
17th - +3 Holy Undead Bane Longsword
20th - +4 Holy Undead Bane Longsword

LEGACY ITEM ABILITIES
Saint’s Grace (Su): At 5th level, you gain a +2 resistance bonus on all saving throws.
Endure Evil (Su): Beginning at 6th level, you enjoy the constant effects of a protection from evil spell. Caster level 5th.
Pelor’s Gaze (Sp): At 7th level and higher, once per day on command, you can cause Durindana to shed daylight as the spell. Caster level 5th.
Pelor’s Baleful Eye (Su): Starting at 13th level, as long as you carry Durindana before you, you turn undead as though you were four levels higher in the class that grants you the ability.
Pelor’s Protecting Grasp (Sp): At 14th level and higher, once per day on command, you can use death ward as the spell. Caster level 7th.
Hallowed Ground (Su): Beginning at 18th level, once per day, you can drive Durindana’s blade into the surface on which you stand, creating the effects of a hallow spell with a daylight spell tied to it. Caster level 9th.
Pelor’s Dazzling Beneficence (Su): At 19th level and higher, as a swift action, you can call down Pelor’s gaze on yourself, which manifests as a dazzling golden light. You then glow as brightly as a torch, but more importantly, your actual location is difficult to pin down through the radiance, granting you total concealment for 15 rounds.
*/

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int nHD = GetHitDice(oPC);
    int nHPPen = 0;
    object oWOL = GetItemPossessedBy(oPC, "WOL_Durindana");
    object oAmmo, oItem;
    
    // You get nothing if you aren't wielding the legacy item
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) 
    {
        SetCompositeAttackBonus(oPC, "Durindana_Atk", 0, ATTACK_BONUS_MISC);
        SetCompositeBonus(oSkin, "Durindana_SavesF", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
        SetCompositeBonus(oSkin, "Durindana_SavesW", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL);
        SetCompositeBonus(oSkin, "Durindana_SavesR", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX);
        SetCompositeBonus(oSkin, "Durindana_BonusF", 0, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEBASETYPE_FORTITUDE);
        SetCompositeBonus(oSkin, "Durindana_BonusW", 0, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEBASETYPE_WILL);
        SetCompositeBonus(oSkin, "Durindana_BonusR", 0, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEBASETYPE_REFLEX);
    	return;
    }
    
    // 5th to 10th level abilities
    if (GetHasFeat(FEAT_LEAST_LEGACY, oPC))
    {
        if(nHD >= 5)
        {
            SetCompositeBonus(oSkin, "Durindana_BonusF", 2, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEBASETYPE_FORTITUDE);
            SetCompositeBonus(oSkin, "Durindana_BonusW", 2, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEBASETYPE_WILL);
            SetCompositeBonus(oSkin, "Durindana_BonusR", 2, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEBASETYPE_REFLEX);
        }         
        if(nHD >= 6)
        {
            nHPPen += 4;
            ActionCastSpell(SPELL_PROTECTION_FROM_EVIL, 5, 0, 0, METAMAGIC_NONE, CLASS_TYPE_INVALID, FALSE, TRUE, oPC, TRUE, FALSE);
        }     
        if(nHD >= 7)
        {
        	IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_DURINDANA_DAYLIGHT), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        } 
        if(nHD >= 8)
        {
            SetCompositeBonus(oSkin, "Durindana_SavesF", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
            SetCompositeBonus(oSkin, "Durindana_SavesW", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL);
            SetCompositeBonus(oSkin, "Durindana_SavesR", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX);
        } 
        if(nHD >= 9)
        {
            SetCompositeAttackBonus(oPC, "Durindana_Atk", -1, ATTACK_BONUS_MISC);
            nHPPen += 2;
            IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(2));
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
            nHPPen += 2;      
            IPSafeAddItemProperty(oWOL, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL, IP_CONST_DAMAGETYPE_SLASHING, IP_CONST_DAMAGEBONUS_2d6));
        }
        if(nHD >= 12)
        {
        }    
        if(nHD >= 13)
        {
            SetCompositeAttackBonus(oPC, "Durindana_Atk", -2, ATTACK_BONUS_MISC);
            SetLocalInt(oPC, "WOLTurning", 4);
        }
        if(nHD >= 14)
        {
			IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_DURINDANA_WARD), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }            
        if(nHD >= 15)
        {
            IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(3));
            SetCompositeBonus(oSkin, "Durindana_SavesF", 2, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
            SetCompositeBonus(oSkin, "Durindana_SavesW", 2, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL);
            SetCompositeBonus(oSkin, "Durindana_SavesR", 2, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX);            
        }    
        if(nHD >= 16)
        {
        }     
    }
    // 17th+ level abilities
    if (GetHasFeat(FEAT_GREATER_LEGACY, oPC))
    {    
        if(nHD >= 17)
        {       
            IPSafeAddItemProperty(oWOL, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD, 5));
            IPSafeAddItemProperty(oWOL, ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD, IP_CONST_DAMAGETYPE_SLASHING, IP_CONST_DAMAGEBONUS_2d6));                    
        }  
        if(nHD >= 18)
        {
            nHPPen += 2;
            SetCompositeBonus(oSkin, "Durindana_SavesF", 3, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
            SetCompositeBonus(oSkin, "Durindana_SavesW", 3, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL);
            SetCompositeBonus(oSkin, "Durindana_SavesR", 3, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX);
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_DURINDANA_HALLOW), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        } 
        if(nHD >= 19)
        {
            nHPPen += 2;
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_DURINDANA_DAZZLE), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        } 
        if(nHD >= 20)
        {
            nHPPen += 2;
            IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(4));
            IPSafeAddItemProperty(oWOL, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD, 6));
        } 
    }
    
    SetLocalInt(oPC, "WoLHealthPenalty", nHPPen);    
    if (!GetLocalInt(oPC, "WoLHealthPenaltyHB") && nHPPen > 0) 
    {
        WoLHealthPenaltyHB(oPC);
        SetLocalInt(oPC, "WoLHealthPenaltyHB", TRUE);
    }    
}