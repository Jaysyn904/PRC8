/**
 * @file
 * Spellscript for Blade of the Last Citadel SLAs
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
    
    object oWOL = GetItemPossessedBy(oPC, "WOL_LastCitadel");
    
    // You get nothing if you aren't wielding the weapon
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) return;  

    switch(nSLA){
        case WOL_LAST_CITADEL_ATTACK:
        {
            nCasterLevel = 5;
            nSpell = MOVE_WR_LEADING_ATTACK;
            nUses = 5;
            break;
        } 
        case WOL_LAST_CITADEL_PRAYER:
        {
            nCasterLevel = 7;
            nSpell = SPELL_PRAYER;
            nUses = 1;
            break;
        } 
        case WOL_LAST_CITADEL_FEAR:
        {
            nCasterLevel = 10;
            nSpell = SPELL_REMOVE_FEAR;
            nUses = 3;
            nInstant = TRUE;
            break;
        }         
        case WOL_LAST_CITADEL_CURE:
        {
            nCasterLevel = 11;
            nSpell = SPELL_CURE_SERIOUS_WOUNDS;
            nUses = 1;
            nInstant = TRUE;
            break;
        }   
        case WOL_LAST_CITADEL_BLADE:
        {
            nCasterLevel = 15;
            nSpell = SPELL_BLADE_BARRIER;
            nUses = 3;
            break;
        }  
        case WOL_LAST_CITADEL_HEAL:
        {
            nCasterLevel = 17;
            nSpell = SPELL_HEAL;
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
        