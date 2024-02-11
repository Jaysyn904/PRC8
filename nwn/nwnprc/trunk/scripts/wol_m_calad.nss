//::///////////////////////////////////////////////
//:: Name           Caladbolg maintain script
//:: FileName       wol_m_calad
//:://////////////////////////////////////////////
/*
LEGACY ITEM PENALTIES (These do not stack. Highest takes precedence).
Attack Penalty: -1 at 6th, -2 at 12th, -3 at 18th
Reflex Save Penalty: -1 at 7th, -2 at 9th, -3 at 15th, -4 at 20th
Hit Point Penalty: -2 at 7th, -4 at 8th, -6 at 10th, -8 at 14th, -10 at 16th
  
LEGACY ITEM BONUSES
7th - +1 Cleaving Shortsword
13th - +2 Cleaving Shortsword
16th - +3 Cleaving Shortsword
19th - +4 Cleaving Shortsword
  
LEGACY ITEM ABILITIES
Strength of Heroes (Su): At 5th level, you gain a +2 enhancement bonus to Strength. This bonus rises to +4 at 11th level and to +6th at 17th level. 
Bull’s Charge (Su): At 6th level, you gain a +4 bonus on the opposed Strength check made during a bull rush attempt, and you push your opponent back an additional 5 feet if the attempt is successful. 
Defiance of Heroes (Su): At 8th level, you gain a +2 resistance bonus on all saving throws. 
Sword Eater (Su): At 9th level and higher, when you use Caladbolg to attempt to disarm an opponent’s weapon, you gain a +4 bonus on the opposed attack roll. 
Unstoppable Cleave (Su): Starting at 15th level, you gain the Great Cleave feat.
Imprisoning Stroke (Su): Beginning at 20th level, once per day you can imprison a foe struck by the sword beneath the earth, as the imprisonment spell. You must declare that you are activating the 
effect before you make the attack roll. The struck creature must make a Will save to avoid the spell’s effects. The save DC is 23, or 19 + your Charisma modifier, whichever is higher. If the attack 
misses, the ability is wasted for the day. Caster level 17th. 
*/

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int nHD = GetHitDice(oPC);
    int nHPPen = 0;
    object oWOL = GetItemPossessedBy(oPC, "WOL_Caladbolg");
    object oAmmo, oItem;
    
    // You get nothing if you aren't wielding the legacy item
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) 
    {
        SetCompositeAttackBonus(oPC, "Caladbolg_Atk", 0, ATTACK_BONUS_MISC);
        SetCompositeBonus(oSkin, "Caladbolg_SavesR", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX);
        SetCompositeBonus(oSkin, "Caladbolg_Str", 0, ITEM_PROPERTY_ABILITY_BONUS,IP_CONST_ABILITY_STR);
    	return;
    }
    
    // 5th to 10th level abilities
    if (GetHasFeat(FEAT_LEAST_LEGACY, oPC))
    {
        if(nHD >= 5)
        {
            SetCompositeBonus(oSkin, "Caladbolg_Str", 2, ITEM_PROPERTY_ABILITY_BONUS,IP_CONST_ABILITY_STR);
        }         
        if(nHD >= 6)
        {
            nHPPen += 2;
            SetCompositeAttackBonus(oPC, "Caladbolg_Atk", -1, ATTACK_BONUS_MISC);
            SetLocalInt(oPC, "Caladbolg_Bullrush", TRUE);
        }     
        if(nHD >= 7)
        {
            nHPPen += 2;
            SetCompositeBonus(oSkin, "Caladbolg_SavesR", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX); 
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_CLEAVE), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        } 
        if(nHD >= 8)
        {
            nHPPen += 2;
            IPSafeAddItemProperty(oSkin, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_UNIVERSAL, 2));
        } 
        if(nHD >= 9)
        {
           SetCompositeBonus(oSkin, "Caladbolg_SavesR", 2, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX); 
           SetLocalInt(oPC, "Caladbolg_Disarm", TRUE);
        }
        if(nHD >= 10)
        {
            nHPPen += 2;
            IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(2));
        }    
    }
    // 11th to 16th level abilities
    if (GetHasFeat(FEAT_LESSER_LEGACY, oPC))
    {    
        if(nHD >= 11)
        {
            SetCompositeBonus(oSkin, "Caladbolg_Str", 4, ITEM_PROPERTY_ABILITY_BONUS,IP_CONST_ABILITY_STR);
        }
        if(nHD >= 12)
        {
            SetCompositeAttackBonus(oPC, "Caladbolg_Atk", -2, ATTACK_BONUS_MISC);
        }    
        if(nHD >= 13)
        {
        }
        if(nHD >= 14)
        {
            nHPPen += 2;
        }            
        if(nHD >= 15)
        {
            SetCompositeBonus(oSkin, "Caladbolg_SavesR", 3, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX);
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_GREAT_CLEAVE), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }    
        if(nHD >= 16)
        {
            nHPPen += 2;
            IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(3));            
        }     
    }
    // 17th+ level abilities
    if (GetHasFeat(FEAT_GREATER_LEGACY, oPC))
    {    
        if(nHD >= 17)
        {    
            SetCompositeBonus(oSkin, "Caladbolg_Str", 6, ITEM_PROPERTY_ABILITY_BONUS,IP_CONST_ABILITY_STR);
        }  
        if(nHD >= 18)
        {
            SetCompositeAttackBonus(oPC, "Caladbolg_Atk", -3, ATTACK_BONUS_MISC);
        } 
        if(nHD >= 19)
        {
            IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(5));
        } 
        if(nHD >= 20)
        {
            SetCompositeBonus(oSkin, "Caladbolg_SavesR", 4, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX); 
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_CALAD_IMPRISON), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        } 
    }
    
    SetLocalInt(oPC, "WoLHealthPenalty", nHPPen);    
    if (!GetLocalInt(oPC, "WoLHealthPenaltyHB") && nHPPen > 0) 
    {
        WoLHealthPenaltyHB(oPC);
        SetLocalInt(oPC, "WoLHealthPenaltyHB", TRUE);
    }    
}