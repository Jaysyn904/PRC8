//::///////////////////////////////////////////////
//:: Name           Arik's Vengeance maintain script
//:: FileName       wol_m_arik
//:://////////////////////////////////////////////
/*
LEGACY ITEM PENALTIES (These do not stack. Highest takes precedence).
Attack Penalty: -1 at 6th
Manifester Level Penalty: -1 at 6th, -2 at 14th
Hit Point Penalty: -2 at 7th, -4 at 9th, -6 at 12th, -8 at 13th, -10 at 15th, -12 at 18th, -14 at 19th
Power Point Penalty: -2 at 7th, -4 at 10th, -6 at 13th, -8 at 16th, -10 at 18th, -12 at 20th

LEGACY ITEM BONUSES
6th - +1 Heavy Mace of Impact
11th - +2 Heavy Mace of Impact
16th - +2 Psychokinetic Heavy Mace of Impact
17th - +2 Outsider Bane Psychokinetic Heavy Mace of Impact
20th - +5 Outsider Bane Psychokinetic Heavy Mace of Impact

LEGACY ITEM ABILITIES
Psicrystal Awakening (Su): At 5th, you gain +3 to Spot.
Armor of Wrath (Su): At 7th level, you gain a +1 deflection bonus to Armor Class.
Vengeful Tenacity (Su): At 8th level, you gain a +1 resistance bonus on all saving throws.
Swift Feet (Su): At 10th level, you gain a 10-foot enhancement to your base ground movement.
Firewalker (Su): At 13th level, you gain resistance to fire 10.
While I Still Stand (Su): At 20th level, Arik's Vengeance grants a +6 enhancement bonus to your Constitution score.
*/

#include "prc_inc_template"
#include "psi_inc_ppoints"

void main()
{
    object oPC = OBJECT_SELF;    
    object oSkin = GetPCSkin(oPC);
    int nHD = GetHitDice(oPC);
    int nHPPen, nPsiPen;
    object oWOL = GetItemPossessedBy(oPC, "WOL_Arik");
    
    // You get nothing if you aren't wielding the weapon
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) 
    {
        SetCompositeAttackBonus(oPC, "Arik_Atk", 0, ATTACK_BONUS_MISC);
		SetCompositeBonus(oSkin, "AriksCon", 0, ITEM_PROPERTY_ABILITY_BONUS,IP_CONST_ABILITY_CON);
        SetCompositeBonus(oSkin, "Arik_Spot", 0, ITEM_PROPERTY_SKILL_BONUS, SKILL_SPOT);
    	return;
    }
    
    // 5th to 10th level abilities
    if (GetHasFeat(FEAT_LEAST_LEGACY, oPC))
    {
        if(nHD >= 5)
        {
        	SetCompositeBonus(oSkin, "Arik_Spot", 5, ITEM_PROPERTY_SKILL_BONUS, SKILL_SPOT);
        }         
        if(nHD >= 6)
        {
            SetCompositeAttackBonus(oPC, "Arik_Atk", -1, ATTACK_BONUS_MISC);
            SetLocalInt(oPC, "WoLManifPenalty", 1); 
            IPSafeAddItemProperty(oWOL, ItemPropertyKeen());
        }     
        if(nHD >= 7)
        {
            nHPPen += 2;
            nPsiPen += 2;
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(SupernaturalEffect(EffectACIncrease(1, AC_DEFLECTION_BONUS)), "WOLEffect"), oPC);            
        } 
        if(nHD >= 8)
        {
			IPSafeAddItemProperty(oWOL, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_UNIVERSAL, 1));        
        } 
        if(nHD >= 9)
        {
            nHPPen += 2;
        }
        if(nHD >= 10)
        {
            nPsiPen += 2;
        }    
    }
    // 11th to 16th level abilities
    if (GetHasFeat(FEAT_LESSER_LEGACY, oPC))
    {    
        if(nHD >= 11)
        {
        	IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(2));
        }
        if(nHD >= 12)
        {
            nHPPen += 2;
        }    
        if(nHD >= 13)
        {
            nHPPen += 2;        
            nPsiPen += 2;
            IPSafeAddItemProperty(oWOL, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGERESIST_10));
        }
        if(nHD >= 14)
        {
            SetLocalInt(oPC, "WoLManifPenalty", 2);
        }            
        if(nHD >= 15)
        {
            nHPPen += 2;
        }    
        if(nHD >= 16)
        {
            nPsiPen += 2;
            IPSafeAddItemProperty(oWOL, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_MAGICAL, IP_CONST_DAMAGEBONUS_1d4));
        }     
    }
    // 17th+ level abilities
    if (GetHasFeat(FEAT_GREATER_LEGACY, oPC))
    {    
        if(nHD >= 17)
        {    
            IPSafeAddItemProperty(oWOL, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_OUTSIDER, 4));
            IPSafeAddItemProperty(oWOL, ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_OUTSIDER, IP_CONST_DAMAGETYPE_BLUDGEONING, IP_CONST_DAMAGEBONUS_2d6));        
        }  
        if(nHD >= 18)
        {
            nHPPen += 2;
            nPsiPen += 2;
        } 
        if(nHD >= 19)
        {
            nHPPen += 2;
        } 
        if(nHD >= 20)
        {
            SetCompositeBonus(oSkin, "AriksCon", 6, ITEM_PROPERTY_ABILITY_BONUS,IP_CONST_ABILITY_CON);
            nPsiPen += 2;
            IPSafeAddItemProperty(oWOL, ItemPropertyEnhancementBonus(5));
            IPSafeAddItemProperty(oWOL, ItemPropertyAttackBonusVsRace(IP_CONST_RACIALTYPE_OUTSIDER, 7));
        } 
    }    
        
    SetLocalInt(oPC, "WoLHealthPenalty", nHPPen);    
    if (!GetLocalInt(oPC, "WoLHealthPenaltyHB") && nHPPen > 0) 
    {
        WoLHealthPenaltyHB(oPC);
        SetLocalInt(oPC, "WoLHealthPenaltyHB", TRUE);
    }
   
    if (!GetLocalInt(oPC, "WoLPsiPointsPenalty") && nPsiPen > 0) 
    {
        LosePowerPoints(oPC, nPsiPen);
        SetLocalInt(oPC, "WoLPsiPointsPenalty", TRUE);
    }    
}