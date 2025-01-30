/**
 * @file
 * Spellscript for Kamate SLAs
 *
 */

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    int nCasterLevel, nDC, nSpell, nUses;
    int nSLA = GetSpellId();
    effect eNone;
    int nInstant = FALSE;
    
    object oWOL = GetItemPossessedBy(oPC, "WOL_Kamate");
    
    // You get nothing if you aren't wielding the weapon
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) return;  

    switch(nSLA){
        case WOL_KAMATE_STEEL_WIND:
        {
            nCasterLevel = 5;
            nSpell = MOVE_IH_STEEL_WIND;
            nUses = 5;
            break;
        } 
        case WOL_KAMATE_SHOCK:
        {
            nCasterLevel = 5;
            nSpell = SPELL_SHOCKING_GRASP;
            nUses = 1;
            nInstant = TRUE;
            break;
        }   
        case WOL_KAMATE_LIGHTNING:
        {
            nCasterLevel = 10;
            nSpell = SPELL_LIGHTNING_BOLT;
            nUses = 3;
            nDC = PRCMax(14, 13 + GetAbilityModifier(ABILITY_CHARISMA, oPC));            
            break;
        }  
        case WOL_KAMATE_CHAIN:
        {
            nCasterLevel = 15;
            nSpell = SPELL_CHAIN_LIGHTNING;
            nUses = 1;
            nDC = PRCMax(16, 14 + GetAbilityModifier(ABILITY_CHARISMA, oPC));            
            break;
        }  
        case WOL_KAMATE_TRUE_STRIKE:
        {
            nCasterLevel = 20;
            nSpell = SPELL_TRUE_STRIKE;
            nUses = 1;
            nInstant = TRUE;
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
        DoRacialSLA(nSpell, nCasterLevel, nDC, nInstant);
        SetLegacyUses(oPC, nSLA);
        FloatingTextStringOnCreature("You have "+IntToString(nUses - GetLegacyUses(oPC, nSLA))+ " uses of " + GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSLA))) + " remaining today.", oPC, FALSE);
    }     
}
        