/**
 * @file
 * Spellscript for Notched Spear SLAs
 *
 */

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    int nCasterLevel, nDC, nSpell, nUses;
    int nSLA = GetSpellId();
    int nKnell = GetHasSpellEffect(SPELL_DEATH_KNELL, oPC);
    effect eNone;
    
    object oWOL = GetItemPossessedBy(oPC, "WOL_Mindsplinter");
    
    // You get nothing if you aren't wielding the weapon
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) return;  

    switch(nSLA){
        case WOL_NS_FISHES:
        {
            nCasterLevel = 5;
            nSpell = SPELL_CHARM_PERSON_OR_ANIMAL;
            nUses = 999;
            break;
        } 
        case WOL_NS_KRAKEN:
        {
            nCasterLevel = 3;
            nSpell = SPELL_DARKNESS;
            nUses = 3;
            break;
        }   
        case WOL_NS_SCION:
        {
            nCasterLevel = 10;
            nSpell = SPELL_SUMMON_CREATURE_IV;
            nUses = 1;
            break;
        } 
        case WOL_NS_SEA_CHILDREN:
        {
            nCasterLevel = 20;
            nSpell = SPELL_SUMMON_CREATURE_IX;
            nUses = 3;
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
        