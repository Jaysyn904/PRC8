//::///////////////////////////////////////////////
//:: Name           Umbral Awn maintain script
//:: FileName       wol_m_umbral
//:://////////////////////////////////////////////
/*
LEGACY ITEM PENALTIES (These do not stack. Highest takes precedence).
Attack Penalty: -1 at 6th, -2 at 13th
Fortitude Save Penalty: -1 at 7th, -2 at 9th, -3 at 15th, -4 at 20th
Hit Point Penalty: -2 at 7th, -4 at 8th, -6 at 10th, -8 at 14th, -10 at 16th, -12 at 20th
  
LEGACY ITEM BONUSES
7th  - +1 Blind Fight Dagger
14th - +2 Blind Fight Dagger
19th - +2 Haste Blind Fight Dagger

LEGACY ITEM ABILITIES
Shadowcloak (Ex): At 5th level, the weapon improves your stealth. In the first round of an encounter, you can hide in plain sight.
Sneak Attack (Ex): At 8th level, you deal an extra 1d6 points of damage with Umbral Awn. The extra damage from this ability stacks with that of sneak attack from other sources. When you attain 12th level, the sneak attack damage granted by Umbral Awn increases to +2d6, and when you attain 17th level, it increases again to +3d6.
Shadowstrike (Ex): When you attain 11th level, your connection to Umbral Awn and your mastery of the Shadow Hand discipline let you take greater advantage of flanking positions. When using a Shadow Hand maneuver, you gain an extra +2 bonus on attacks if flanking your foe.
Invisibility (Sp): When you attain 16th level, Umbral Awn lets you meld into your own shadow. You can use invisibility at will, as the spell. Caster Level: 10th.
Shadowstep (Su): At 20th level, three times per day, as a swift action, you can become incorporeal until the beginning of your next turn.
*/

#include "prc_inc_template"

void TriggerShadowcloak(object oPC, int nCombat);

void TriggerShadowcloak(object oPC, int nCombat)
{
	SetLocalInt(oPC, "ShadowcloakHBRunning", TRUE);
	DelayCommand(0.249, DeleteLocalInt(oPC, "ShadowcloakHBRunning"));
	int nCurrent = GetIsInCombat(oPC);
	object oSkin = GetPCSkin(oPC);
	// We just entered combat
	if (nCurrent == TRUE && nCombat == FALSE)
		IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_BLINDFIGHT), 6.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);

    DelayCommand(0.25, TriggerShadowcloak(oPC, nCurrent));
}

void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int nHD = GetHitDice(oPC);
    int nHPPen = 0;
    object oWOL = GetItemPossessedBy(oPC, "WOL_Umbral");
    object oAmmo, oItem;
    
    // You get nothing if you aren't wielding the legacy item
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) 
    {
    	SetCompositeBonus(oSkin, "Umbral_SavesR", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE); 
    	SetCompositeAttackBonus(oPC, "Umbral_Atk", 0, ATTACK_BONUS_MISC);
    	return;
    }     
    
    // 5th to 10th level abilities
    if (GetHasFeat(FEAT_LEAST_LEGACY, oPC))
    {
        if(nHD >= 5)
        {
        	if (!GetLocalInt(oPC, "ShadowcloakHBRunning")) DeleteLocalInt(oPC, "ShadowcloakHB");
        	if (!GetLocalInt(oPC, "ShadowcloakHB")) 
        	{
        	    TriggerShadowcloak(oPC, FALSE);
        	    SetLocalInt(oPC, "ShadowcloakHB", TRUE);
        	}
        }         
        if(nHD >= 6)
        {
            SetCompositeAttackBonus(oPC, "Umbral_Atk", -1, ATTACK_BONUS_MISC);
        }     
        if(nHD >= 7)
        {
            nHPPen += 2;
            SetCompositeBonus(oSkin, "Umbral_SavesR", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE); 
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_BLINDFIGHT), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        } 
        if(nHD >= 8)
        {
            nHPPen += 2;
            SetLocalInt(oPC, "UmbralSneak", 1);
        } 
        if(nHD >= 9)
        {
           SetCompositeBonus(oSkin, "Umbral_SavesR", 2, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE); 
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
        	SetLocalInt(oPC, "UmbralStrike", TRUE);
        }
        if(nHD >= 12)
        {
			SetLocalInt(oPC, "UmbralSneak", 2);
        }    
        if(nHD >= 13)
        {
        	SetCompositeAttackBonus(oPC, "Umbral_Atk", -2, ATTACK_BONUS_MISC);
        }
        if(nHD >= 14)
        {
            nHPPen += 2;
            IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(2)); 
        }            
        if(nHD >= 15)
        {
            SetCompositeBonus(oSkin, "Umbral_SavesR", 3, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
        }    
        if(nHD >= 16)
        {
            nHPPen += 2;
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_UMBRAL_INVIS), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }     
    }
    // 17th+ level abilities
    if (GetHasFeat(FEAT_GREATER_LEGACY, oPC))
    {    
        if(nHD >= 17)
        {    
        	SetLocalInt(oPC, "UmbralSneak", 3);
        }  
        if(nHD >= 18)
        {
        } 
        if(nHD >= 19)
        {
        	ActionCastSpell(WOL_UMBRAL_SPEED_WEAPON, 5, 0, 0, METAMAGIC_NONE, CLASS_TYPE_INVALID, FALSE, TRUE, oPC, TRUE, FALSE);
        } 
        if(nHD >= 20)
        {
            SetCompositeBonus(oSkin, "Umbral_SavesR", 4, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE); 
            nHPPen += 2;
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_UMBRAL_INCORP), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        } 
    }
    
    SetLocalInt(oPC, "WoLHealthPenalty", nHPPen);    
    if (!GetLocalInt(oPC, "WoLHealthPenaltyHB") && nHPPen > 0) 
    {
        WoLHealthPenaltyHB(oPC);
        SetLocalInt(oPC, "WoLHealthPenaltyHB", TRUE);
    }    
}