//::///////////////////////////////////////////////
//:: Name           Shishi-O maintain script
//:: FileName       wol_m_shishio
//:://////////////////////////////////////////////
/*
LEGACY ITEM PENALTIES (These do not stack. Highest takes precedence).
Attack Penalty: -1 at 9th, -2 at 13th
Save Penalty: -1 at 8th, -2 at 16th, -3 at 18th
Hit Point Penalty: -4 at 6th, -6 at 9th, -8 at 12th, -10 at 15th, -12 at 18th, -14 at 19th, -16 at 20th

LEGACY ITEM BONUSES
10th - +2 Katana
13th - +3 Katana
16th - +3 Thundering Katana
18th - +4 Thundering Katana
20th - +5 Thundering Katana

LEGACY ITEM ABILITIES
Charm Animal (Sp): At 5th level and higher, at will on command, you can use charm animal as the spell. The save DC is 11, or 11 + your Charisma modifier, whichever is higher. Caster level 5th. 
Summon Lion (Sp): Starting at 8th level, once per day on command, you can summon a lion as if with the summon nature’s ally III spell. At 12th level, you can instead summon a dire tiger as if with the summon nature’s ally V spell. Caster level 10th. 
Cat Leap (Su): At 11th level, you gain a +5 enhancement bonus on Jump checks. 
Glorious Form of the Tiger General (Sp): Beginning at 15th level, once per day on command, you can transform into a dire tiger as if you used the polymorph spell. Caster level 10th. 
Tiger’s Charge (Su): At 17th level and higher, you can make a full attack with Shish-O after a charge. 
Deafening Roar (Sp): Starting at 19th level, once per day on command, you can cause Shishi-O to emit a mighty roar that functions as a greater shout spell. The save DC is 22, or 18 + your Charisma modifier, whichever is higher. Caster level 15th.
*/

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int nHD = GetHitDice(oPC);
    int nHPPen = 0;
    object oWOL = GetItemPossessedBy(oPC, "WOL_Shishio");
    object oAmmo, oItem;
    
    // You get nothing if you aren't wielding the legacy item
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) 
    {
        SetCompositeAttackBonus(oPC, "Shishio_Atk", 0, ATTACK_BONUS_MISC);
        SetCompositeBonus(oSkin, "Shishio_BonusW", 0, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEBASETYPE_WILL);
        SetCompositeBonus(oSkin, "Shishio_SavesF", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
        SetCompositeBonus(oSkin, "Shishio_SavesW", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL);
        SetCompositeBonus(oSkin, "Shishio_SavesR", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX);
        SetCompositeBonus(oSkin, "Shishio_jump", 0, ITEM_PROPERTY_SKILL_BONUS, SKILL_JUMP);
    	return;
    }      
    
    // 5th to 10th level abilities
    if (GetHasFeat(FEAT_LEAST_LEGACY, oPC))
    {
        if(nHD >= 5)
        {
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_SHISHIO_CHARM), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }         
        if(nHD >= 6)
        {
            nHPPen += 4;
            SetCompositeBonus(oSkin, "Shishio_BonusW", 2, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEBASETYPE_WILL);
        }     
        if(nHD >= 7)
        {
        } 
        if(nHD >= 8)
        {
            SetCompositeBonus(oSkin, "Shishio_SavesF", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
            SetCompositeBonus(oSkin, "Shishio_SavesW", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL);
            SetCompositeBonus(oSkin, "Shishio_SavesR", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX);
        } 
        if(nHD >= 9)
        {
            SetCompositeAttackBonus(oPC, "Shishio_Atk", -1, ATTACK_BONUS_MISC);
            nHPPen += 2;
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_SHISHIO_SUMMON), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }
        if(nHD >= 10)
        {
            IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(2));            
        }            
    }
    // 11th to 16th level abilities
    if (GetHasFeat(FEAT_LESSER_LEGACY, oPC))
    {    
        if(nHD >= 11)
        {
            SetCompositeBonus(oSkin, "Shishio_jump", 5, ITEM_PROPERTY_SKILL_BONUS, SKILL_JUMP);
        }
        if(nHD >= 12)
        {
            nHPPen += 2;
        }    
        if(nHD >= 13)
        {
            SetCompositeAttackBonus(oPC, "Shishio_Atk", -2, ATTACK_BONUS_MISC);
            IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(3));
        }
        if(nHD >= 14)
        {
        }            
        if(nHD >= 15)
        {
            nHPPen += 2;
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_SHISHIO_POLY), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }    
        if(nHD >= 16)
        {
            SetCompositeBonus(oSkin, "Shishio_SavesF", 2, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
            SetCompositeBonus(oSkin, "Shishio_SavesW", 2, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL);
            SetCompositeBonus(oSkin, "Shishio_SavesR", 2, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX);
            IPSafeAddItemProperty(oWOL, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_SONIC, IP_CONST_DAMAGEBONUS_1d6));
        }     
    }
    // 17th+ level abilities
    if (GetHasFeat(FEAT_GREATER_LEGACY, oPC))
    {    
        if(nHD >= 17)
        {       
            SetLocalInt(oPC, "Shishio_Pounce", TRUE);
        }  
        if(nHD >= 18)
        {
            nHPPen += 2;
            SetCompositeBonus(oSkin, "Shishio_SavesF", 3, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
            SetCompositeBonus(oSkin, "Shishio_SavesW", 3, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL);
            SetCompositeBonus(oSkin, "Shishio_SavesR", 3, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX);
            IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(4));
        } 
        if(nHD >= 19)
        {
            nHPPen += 2;
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_SHISHIO_SHOUT), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        } 
        if(nHD >= 20)
        {
            nHPPen += 2;
            IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(5));
        } 
    }
    
    SetLocalInt(oPC, "WoLHealthPenalty", nHPPen);    
    if (!GetLocalInt(oPC, "WoLHealthPenaltyHB") && nHPPen > 0) 
    {
        WoLHealthPenaltyHB(oPC);
        SetLocalInt(oPC, "WoLHealthPenaltyHB", TRUE);
    }    
}