//::///////////////////////////////////////////////
//:: Name           Scarab of Aradros maintain script
//:: FileName       wol_m_aradros
//:://////////////////////////////////////////////
/*
LEGACY ITEM PENALTIES (These do not stack. Highest takes precedence).
Save Penalty: -1 at 6th
Caster Level Penalty: -1 at 7th, -2 at 13th
Skill Penalty: -1 at 8th, -2 at 15th
  
LEGACY ITEM BONUSES
7th - Scarab of Resistance +2
10th - Scarab of Resistance +3
13th - Scarab of Resistance +4
16th - Scarab of Resistance +5

LEGACY ITEM ABILITIES
 Arcane Health (Su): Starting at 5th level, you gain 10 temporary hit points after resting. 
 Winged Range (Su): At 6th level and higher, you can cast up to three arcane spells per day of up to 3rd level that are extended as though using the Extend Spell metamagic feat. At 12th level, you can extend three arcane spells per day that are 6th level or lower. 
 Carapaced Nerves (Su): As the Scarab of Aradros builds a connection with you, it aids your ability to focus your mind. At 8th level, you gain a +5 bonus on Concentration checks. 
 Survive Any Extreme (Su): Starting at 11th level, at will as an immediate action, you can grant yourself resistance 30 to one type of energy (acid, cold, electricity, fire, or sonic). This effect lasts for 1 minute. 
 Scarab Shell (Su): At 15th level and higher, you benefit from the effects of a shield spell. Caster level 10th.
*/

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;    
    object oSkin = GetPCSkin(oPC);
    int nHD = GetHitDice(oPC);
    object oWOL = GetItemPossessedBy(oPC, "WOL_Aradros");
    
    // You get nothing if you aren't wielding the weapon
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_NECK, oPC)) 
    {
        SetCompositeBonus(oSkin, "Aradros_SavesF", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
        SetCompositeBonus(oSkin, "Aradros_SavesW", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL);
        SetCompositeBonus(oSkin, "Aradros_SavesR", 0, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX);
        SetCompositeBonus(oSkin, "Aradros_Concentration", 0, ITEM_PROPERTY_SKILL_BONUS, SKILL_CONCENTRATION);
    	return;
    }
    
    // 5th to 10th level abilities
    if (GetHasFeat(FEAT_LEAST_LEGACY, oPC))
    {
        if(nHD >= 5)
        {
            if (!GetLocalInt(oPC, "AradrosTHP"))
            {
                effect eBad = GetFirstEffect(oPC);
                //This stops it stacking with itself if not expended
                while(GetIsEffectValid(eBad))
                {
                    int nInt = GetEffectSpellId(eBad);
                    if (GetEffectType(eBad) == EFFECT_TYPE_TEMPORARY_HITPOINTS)
                    {
                        RemoveEffect(oPC, eBad);
                    }
                    eBad = GetNextEffect(oPC);
                }            
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectTemporaryHitpoints(10)), oPC);
                SetLocalInt(oPC, "AradrosTHP", TRUE);
            }    
        }         
        if(nHD >= 6)
        {
            SetCompositeBonus(oSkin, "Aradros_SavesF", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_FORTITUDE);
            SetCompositeBonus(oSkin, "Aradros_SavesW", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_WILL);
            SetCompositeBonus(oSkin, "Aradros_SavesR", 1, ITEM_PROPERTY_DECREASED_SAVING_THROWS, IP_CONST_SAVEBASETYPE_REFLEX);
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_ARADROS_EXTEND), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }     
        if(nHD >= 7)
        {
            SetLocalInt(oPC, "WoLCasterPenalty", 1);
            IPSafeAddItemProperty(oWOL, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_UNIVERSAL, 2));
        } 
        if(nHD >= 8)
        {
            SetCompositeBonus(oSkin, "Aradros_Concentration", 5, ITEM_PROPERTY_SKILL_BONUS, SKILL_CONCENTRATION);
            if (15 > nHD) ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(ExtraordinaryEffect(EffectSkillDecrease(SKILL_ALL_SKILLS, 1)), "WOLEffect"), oPC);
        } 
        if(nHD >= 9)
        {
        }
        if(nHD >= 10)
        {
            IPSafeAddItemProperty(oWOL, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_UNIVERSAL, 3));
        }    
    }
    // 11th to 16th level abilities
    if (GetHasFeat(FEAT_LESSER_LEGACY, oPC))
    {    
        if(nHD >= 11)
        {
            IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_ARADROS_SURVIVE), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }
        if(nHD >= 12)
        {

        }    
        if(nHD >= 13)
        {
            SetLocalInt(oPC, "WoLCasterPenalty", 2);
            IPSafeAddItemProperty(oWOL, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_UNIVERSAL, 4));          
        }
        if(nHD >= 14)
        {
        }            
        if(nHD >= 15)
        {
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, TagEffect(ExtraordinaryEffect(EffectSkillDecrease(SKILL_ALL_SKILLS, 2)), "WOLEffect"), oPC);
            ActionCastSpell(SPELL_SHIELD, 10, 0, 0, METAMAGIC_NONE, CLASS_TYPE_INVALID, FALSE, TRUE, oPC, TRUE, FALSE);
        }    
        if(nHD >= 16)
        {
            IPSafeAddItemProperty(oWOL, ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_UNIVERSAL, 5));
        }     
    }
}