/**
 * @file
 * Spellscript for Wargird's Armor SLAs
 *
 */

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    int nCasterLevel, nDC, nSpell, nUses;
    int nSLA = GetSpellId();
    effect eNone;
    
    object oWOL = GetItemPossessedBy(oPC, "WOL_WargirdsArmor");
    
    // You get nothing if you aren't wielding the weapon
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_CHEST, oPC)) return;  

    switch(nSLA){
        case WOL_WARGIRDS_HASTE:
        {
            nCasterLevel = 10;
            nSpell = SPELL_HASTE;
            nUses = 5;
            break;
        } 
        case WOL_WARGIRDS_STONESKIN:
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
        DoRacialSLA(nSpell, nCasterLevel, nDC);
        SetLegacyUses(oPC, nSLA);
        FloatingTextStringOnCreature("You have "+IntToString(nUses - GetLegacyUses(oPC, nSLA))+ " uses of " + GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSLA))) + " remaining today.", oPC, FALSE);
    }     
}
        