/**
 * @file
 * Spellscript for Holy Symbol of Ravenkind SLAs
 *
 */

#include "prc_inc_template"
#include "prc_inc_s_det"

void main()
{
    object oPC = OBJECT_SELF;
    int nCasterLevel, nDC, nSpell, nUses;
    int nSLA = GetSpellId();
    effect eNone;
    
    object oWOL = GetItemPossessedBy(oPC, "WOL_Ravenkind");
    
    // You get nothing if you aren't wielding the weapon
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_NECK, oPC)) return;    
	
	switch(nSLA)
	{
        case WOL_RAVENKIND_DANCING_LIGHT:
        {
            nCasterLevel = 5;
            nSpell = SPELL_DANCING_LIGHTS;
            nUses = 999;
            break;
        }
        case WOL_RAVENKIND_LIGHT:
        {
            nCasterLevel = 5;
            nSpell = SPELL_LIGHT;
            nUses = 999;
            break;
        }   
        case WOL_RAVENKIND_FLARE:
        {
            nCasterLevel = 5;
            nSpell = SPELL_FLARE;
            nUses = 999;
            nDC = max(10, 10 + GetAbilityModifier(ABILITY_CHARISMA, oPC));            
            break;
        }         
        case WOL_RAVENKIND_DETECT_UNDEAD:
        {
            nCasterLevel = 5;
            nSpell = SPELL_DETECT_UNDEAD;
            nUses = 999;
            break;
        }  
        case WOL_RAVENKIND_HALT:
        {
            nCasterLevel = 10;
            nSpell = SPELL_HALT_UNDEAD;
            nUses = 2;
            nDC = max(14, 13 + GetAbilityModifier(ABILITY_CHARISMA, oPC));                          
            break;
        }        
        case WOL_RAVENKIND_CURE:
        {
            nCasterLevel = 5;
            nSpell = SPELL_CURE_LIGHT_WOUNDS;
            nUses = 3;
            nDC = max(11, 11 + GetAbilityModifier(ABILITY_CHARISMA, oPC));                          
            break;
        } 
        case WOL_RAVENKIND_DAYLIGHT:
        {
            nCasterLevel = 10;
            nSpell = SPELL_DAYLIGHT;
            nUses = 999;
            break;
        } 
        case WOL_RAVENKIND_WARD:
        {
            nCasterLevel = 11;
            nSpell = SPELL_DEATH_WARD;
            nUses = 1;
            break;
        }
        case WOL_RAVENKIND_BREAK:
        {
            nCasterLevel = 11;
            nSpell = SPELL_BREAK_ENCHANTMENT;
            nUses = 1;
            break;
        }    
        case WOL_RAVENKIND_HEAL:
        {
            nCasterLevel = 20;
            nSpell = SPELL_MASS_HEAL;
            nUses = 3;
            nDC = max(23, 19 + GetAbilityModifier(ABILITY_CHARISMA, oPC));                          
            break;
        }        
    }    
    
    // Check uses per day
    if (GetLegacyUses(oPC, nSLA) >= nUses)
    {
        FloatingTextStringOnCreature("You have used " + GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSLA))) + " the maximum amount of times today.", oPC, FALSE);
        return;
    }   
    SetLegacyUses(oPC, nSLA);
    FloatingTextStringOnCreature("You have "+IntToString(nUses - GetLegacyUses(oPC, nSLA))+ " uses of " + GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSLA))) + " remaining today.", oPC, FALSE);    
    if (nSpell > 0) 
        DoRacialSLA(nSpell, nCasterLevel, nDC);
}
        