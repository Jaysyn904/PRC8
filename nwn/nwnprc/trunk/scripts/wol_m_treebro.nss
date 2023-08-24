//::///////////////////////////////////////////////
//:: Name           Treebrother maintain script
//:: FileName       wol_m_treebro
//:://////////////////////////////////////////////
/*
LEGACY ITEM PENALTIES (These do not stack. Highest takes precedence).
Attack Penalty: -1 at 8th
Hit Point Penalty: -2 at 6th, -4 at 7th, -6 at 9th, -8 at 13th, -10 at 15th
Spell Slot Lost: 1st at 6th, 2nd at 8th, 3rd at 10th, 4th at 12th, 5th at 14th, 6th at 16th

LEGACY ITEM ABILITIES
Shillelagh (Sp): At 5th level and higher, once per day you can cast the shillelagh spell. Caster level 5th. 
Green Empathy (Su): Beginning at 6th level, you can attempt to charm plants by rolling 1d20 and adding your character level plus your Charisma modifier.
Entangle (Sp): Starting at 8th level, three times per day, you can use entangle as the spell. The save DC is 11, or 11 + your Charisma modifier, whichever is higher. Caster level 5th. 
Woodland Stealth (Su): At 10th level, you gain a +5 competence bonus on Hide and Move Silently checks made in natural areas.
Fast Movement (Su): At 11th level, you gain a 10 foot enhancement bonus to your base land speed. 
Ow's Insight (Sp): At 13th level and higher, once per day, you can use owl's insight as the spell. Caster level 10th. 
Changestaff (Sp): Starting at 16th level, once per day you can transform Treebrother as though with the changestaff spell. The duration of the effect is only 1 hour.
*/

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;    
    object oSkin = GetPCSkin(oPC);
    int nHD = GetHitDice(oPC);
    int nHPPen = 0;
    int nSlot = 0;
    object oWOL = GetItemPossessedBy(oPC, "WOL_Treebrother");
    
    // You get nothing if you aren't wielding the item
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) return;
    
    // 5th to 10th level abilities
    if (GetHasFeat(FEAT_LEAST_LEGACY, oPC))
    {
        if(nHD >= 5)
        {
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_TREEBRO_SHILL), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }         
        if(nHD >= 6)
        {
            nHPPen += 2;
            nSlot = 1;
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_TREEBRO_EMPATHY), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }     
        if(nHD >= 7)
        {
            nHPPen += 2;
            SetCompositeAttackBonus(oPC, "Treebrother_Atk", -1, ATTACK_BONUS_MISC);
        } 
        if(nHD >= 8)
        {
            nSlot = 2;
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_TREEBRO_ENTANGLE), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        } 
        if(nHD >= 9)
        {
            nHPPen += 2;
        }
        if(nHD >= 10)
        {
            nSlot = 3;
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
            nSlot = 4;
        }    
        if(nHD >= 13)
        {
            nHPPen += 2;
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_TREEBRO_INSIGHT), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }
        if(nHD >= 14)
        {
            nSlot = 5;
        }            
        if(nHD >= 15)
        {
            nHPPen += 2;
        }    
        if(nHD >= 16)
        {
            nSlot = 6;
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_TREEBRO_CHANGESTAFF), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }     
    } 
        
    SetLocalInt(oPC, "WoLHealthPenalty", nHPPen);    
    if (!GetLocalInt(oPC, "WoLHealthPenaltyHB") && nHPPen > 0) 
    {
        WoLHealthPenaltyHB(oPC);
        SetLocalInt(oPC, "WoLHealthPenaltyHB", TRUE);
    }
    WoLSpellSlotPenalty(oPC, nSlot);
}