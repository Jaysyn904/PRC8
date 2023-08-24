/**
 * @file
 * Spellscript for Quickspur's Ally SLAs
 *
 */

#include "prc_inc_template"
#include "prc_inc_combat"

void main()
{
    object oPC = OBJECT_SELF;
    int nCasterLevel, nDC, nSpell, nUses;
    int nSLA = GetSpellId();
    effect eNone;
    int nInstant = FALSE;
    
    object oWOL = GetItemPossessedBy(oPC, "WOL_Quickspur");
    
    // You get nothing if you aren't wielding the weapon
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC)) return;  

    switch(nSLA){
        case WOL_QUICKSPUR_SHIELD:
        {
            nCasterLevel = 5;
            nSpell = SPELL_ENTROPIC_SHIELD;
            nUses = 1;
            break;
        }   
        case WOL_QUICKSPUR_RESIST:
        {
            nCasterLevel = 5;
            nSpell = SPELL_RESIST_ELEMENTS;
            nUses = 1;
            break;
        }   
        case WOL_QUICKSPUR_STEED:
        {
            nCasterLevel = 10;
            nSpell = SPELL_PHANTOM_STEED;
            nUses = 1;
            break;
        }   
        case WOL_QUICKSPUR_BLUR:
        {
            nCasterLevel = 15;
            nSpell = SPELL_BLUR;
            nUses = 3;
            break;
        }   
        case WOL_QUICKSPUR_STONE:
        {
            nCasterLevel = 15;
            nSpell = SPELL_STONESKIN;
            nUses = 1;
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
        