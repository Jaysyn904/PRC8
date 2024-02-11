//::///////////////////////////////////////////////
//:: Name           Holy Symbol of Ravenkind maintain script
//:: FileName       wol_m_ravenkind
//:://////////////////////////////////////////////
/*
LEGACY ITEM PENALTIES (These do not stack. Highest takes precedence).
Attack Penalty: -1 at 6th, -2 at 12th, -3 at 18th
Fort Save Penalty: -1 at 7th, -2 at 9th, -3 at 15th, -4 at 20th
Hit Point Penalty: -2 at 7th, -4 at 8th, -6 at 10th, -8 at 14th, -10 at 16th
  
LEGACY ITEM BONUSES
None

LEGACY ITEM ABILITIES
Lightbringer (Su): At 5th level, you may cast Dancing Lights, Light, or Flare at will. Caster level 5th, save DC of 10 + Charisma modifier.
Undead Detection (Su): At 6th level, you can cast Detect Undead, as per Detect Evil, at will. Caster level 5th. In addition, every weapon you wield becomes undead bane.
Halt Undead (Sp): At 9th level, you can cast Halt Undead twice per day. Caster level 10th, save DC of 14, or 14 + Charisma modifier, whichever is higher.
Cure Light Wounds (Sp): At 10th level, you can cast Cure Light Wounds three times per day. Caster level 5th, save DC of 11, or 11 + Charisma modifier, whichever is higher.
Improved Turning (Su): At 11th level, you turn undead as if your cleric level was four levels higher.
Daylight (Sp): At 12th level, you can cast Daylight at will. Caster level 10th.
Death Ward (Sp): At 14th level, you can cast Death Ward once per day. Caster level 11th.
Break Enchantment (Sp): At 16th level, you can cast Break Enchantment once per day. Caster level 11th.
Wisdom Enhancement (Su): At 17th level, you gain a +6 bonus to your wisdom score.
Mass Heal (Sp): At 20th level, you can cast Mass Heal three times per day. Caster level 20th, save DC of 23, or 19 + Charisma modifier, whichever is higher.
*/

#include "prc_inc_template"

void main()
{
    int nEvent = GetRunningEvent();
    if(DEBUG) DoDebug("wol_m_ravenkind running, event: " + IntToString(nEvent));

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
    object oWOL = GetItemPossessedBy(oPC, "WOL_Ravenkind");
    
    // You get nothing if you aren't wielding the weapon
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_NECK, oPC)) 
    {
        SetCompositeAttackBonus(oPC, "Ravenkind_Atk", 0, ATTACK_BONUS_MISC);
        SetCompositeBonus(oSkin, "Ravenkind_SavesR", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
        SetCompositeBonus(oSkin, "Ravekind_Wis", 0, ITEM_PROPERTY_ABILITY_BONUS,IP_CONST_ABILITY_WIS);  
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
            	IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_RAVENKIND_DANCE), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            	IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_RAVENKIND_FLARE), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            	IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_RAVENKIND_LIGHT), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            }         
            if(nHD >= 6)
            {
                nHPPen += 2;
                SetCompositeAttackBonus(oPC, "Ravenkind_Atk", -1, ATTACK_BONUS_MISC);
                IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_RAVENKIND_DETECT), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, TagEffect(SupernaturalEffect(VersusRacialTypeEffect(EffectDamageIncrease(d6(2), DAMAGE_TYPE_DIVINE), RACIAL_TYPE_UNDEAD)), "WOLEffect"), oPC, 9999.0);
            }     
            if(nHD >= 7)
            {
                nHPPen += 2;
                SetCompositeBonus(oSkin, "Ravenkind_SavesR", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE); 
            } 
            if(nHD >= 8)
            {
                nHPPen += 2;
            } 
            if(nHD >= 9)
            {
               SetCompositeBonus(oSkin, "Ravenkind_SavesR", 2, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE); 
               IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_RAVENKIND_HALT), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            }
            if(nHD >= 10)
            {
                nHPPen += 2;
                IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_RAVENKIND_CURE), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            }    
        }
        // 11th to 16th level abilities
        if (GetHasFeat(FEAT_LESSER_LEGACY, oPC))
        {    
            if(nHD >= 11)
            {
				SetLocalInt(oPC, "WOLTurning", 4);            
            }
            if(nHD >= 12)
            {
                SetCompositeAttackBonus(oPC, "Ravenkind_Atk", -2, ATTACK_BONUS_MISC);
                IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_RAVENKIND_DAYLIGHT), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            }    
            if(nHD >= 13)
            {
            }
            if(nHD >= 14)
            {
                nHPPen += 2;
                IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_RAVENKIND_WARD), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            }            
            if(nHD >= 15)
            {
                SetCompositeBonus(oSkin, "Ravenkind_SavesR", 3, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE); 
            }    
            if(nHD >= 16)
            {
                nHPPen += 2;
                IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_RAVENKIND_BREAK), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            }     
        }
        // 17th+ level abilities
        if (GetHasFeat(FEAT_GREATER_LEGACY, oPC))
        {    
            if(nHD >= 17)
            {  
				SetCompositeBonus(oSkin, "Ravekind_Wis", 6, ITEM_PROPERTY_ABILITY_BONUS,IP_CONST_ABILITY_WIS);            
            }  
            if(nHD >= 18)
            {
                SetCompositeAttackBonus(oPC, "Ravenkind_Atk", -3, ATTACK_BONUS_MISC);
            } 
            if(nHD >= 19)
            {
            } 
            if(nHD >= 20)
            {
                SetCompositeBonus(oSkin, "Ravenkind_SavesR", 4, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE); 
                IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_RAVENKIND_HEAL), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
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

