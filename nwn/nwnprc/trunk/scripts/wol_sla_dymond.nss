/**
 * @file
 * Spellscript for Dymondheart SLAs
 *
 */

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    int nCasterLevel, nDC, nSpell, nUses;
    int nSLA = GetSpellId();
    effect eNone;
    
    object oWOL = GetItemPossessedBy(oPC, "WOL_Dymondheart");
    
    // You get nothing if you aren't wielding the weapon
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) return;  

    switch(nSLA){
        case WOL_DYMOND_BOLTS:
        {
            nCasterLevel = 5;
            nSpell = SPELL_PROTECTION_FROM_ARROWS;
            nUses = 1;
            break;
        } 
        case WOL_DYMOND_DEFLECT:
        {
            nUses = 1;
            SetLocalInt(oPC, "Dymond_Deflect", TRUE);
            break;
        }   
        case WOL_DYMOND_DAYLIGHT:
        {
            nCasterLevel = 5;
            nSpell = SPELL_DAYLIGHT;
            nUses = 1;
            break;
        } 
        case WOL_DYMOND_CURE:
        {
            nCasterLevel = 10;
            nSpell = SPELL_CURE_CRITICAL_WOUNDS;
            nUses = 4;
            break;
        } 
        case WOL_DYMOND_BANISH:
        {
            nCasterLevel = 15;
            nSpell = SPELL_BANISHMENT;
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
        