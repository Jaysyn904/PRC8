/**
 * @file
 * Spellscript for Scales of Balance SLAs
 *
 */

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    int nCasterLevel, nDC, nSpell, nUses;
    int nSLA = GetSpellId();
    effect eNone;
    
    object oWOL = GetItemPossessedBy(oPC, "WOL_ScalesBalance");
    
    // You get nothing if you aren't wielding the weapon
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) return;  

    switch(nSLA){
        case WOL_SCALES_DETECT:
        {
            nCasterLevel = 5;
            nSpell = SPELL_DETECT_UNDEAD;
            nUses = 3;
            break;
        } 
        case WOL_SCALES_CURE:
        {
            nCasterLevel = 5;
            nSpell = SPELL_CURE_LIGHT_WOUNDS;
            nUses = 3;
            break;
        }         
        case WOL_SCALES_KNELL:
        {
            nCasterLevel = 10;
            nSpell = SPELL_DEATH_KNELL;
            nUses = 2;
            nDC = 13;            
            if (12 + GetAbilityModifier(ABILITY_CHARISMA, oPC) > nDC)
                nDC = 12 + GetAbilityModifier(ABILITY_CHARISMA, oPC);              
            break;
        }   
        case WOL_SCALES_ENERV:
        {
            nCasterLevel = 13;
            nSpell = SPELL_ENERVATION;
            nUses = 2;
            nDC = 16;            
            if (14 + GetAbilityModifier(ABILITY_CHARISMA, oPC) > nDC)
                nDC = 14 + GetAbilityModifier(ABILITY_CHARISMA, oPC); 
            break;
        } 
        case WOL_SCALES_HEAL:
        {
            nCasterLevel = 15;
            nSpell = SPELL_HEAL;
            nUses = 1;
            break;
        }         
        case WOL_SCALES_FINGER:
        {
            nCasterLevel = 17;
            nSpell = SPELL_FINGER_OF_DEATH;
            nUses = 1;
            nDC = 20;            
            if (17 + GetAbilityModifier(ABILITY_CHARISMA, oPC) > nDC)
                nDC = 17 + GetAbilityModifier(ABILITY_CHARISMA, oPC); 
            break;
        }        
    }
    
    // Check uses per day
    if (GetLegacyUses(oPC, nSLA) >= nUses)
    {
        FloatingTextStringOnCreature("You have used " + GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSLA))) + " the maximum amount of times today.", oPC, FALSE);
        return;
    }   
    if (nSpell > 0) 
    {
        DoRacialSLA(nSpell, nCasterLevel, nDC);
        SetLegacyUses(oPC, nSLA);
        FloatingTextStringOnCreature("You have "+IntToString(nUses - GetLegacyUses(oPC, nSLA))+ " uses of " + GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSLA))) + " remaining today.", oPC, FALSE);
    }     
}
        