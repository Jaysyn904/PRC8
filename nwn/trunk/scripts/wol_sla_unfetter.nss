/**
 * @file
 * Spellscript for Unfettered SLAs
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
    
    object oWOL = GetItemPossessedBy(oPC, "WOL_Unfettered");
    
    // You get nothing if you aren't wielding the weapon
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) return;  

    switch(nSLA){
        case WOL_UNFETTERED_MINOTAUR:
        {
            nCasterLevel = 5;
            nSpell = MOVE_SD_CHARGING_MINOTAUR;
            nUses = 5;
            break;
        } 
        case WOL_UNFETTERED_ENLARGE:
        {
            nCasterLevel = 5;
            nSpell = SPELL_ENLARGE_PERSON;
            nUses = 1;
            break;
        } 
        case WOL_UNFETTERED_ETHEREAL:
        {
            nCasterLevel = 10;
            nSpell = SPELL_ETHEREALNESS;
            nUses = 1;
            break;
        }         
        case WOL_UNFETTERED_STONESKIN:
        {
            nCasterLevel = 13;
            nSpell = SPELL_STONESKIN;
            nUses = 1;
            break;
        }   
        case WOL_UNFETTERED_SWORD:
        {
            nCasterLevel = 17;
            nSpell = SPELL_MORDENKAINENS_SWORD;
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
        