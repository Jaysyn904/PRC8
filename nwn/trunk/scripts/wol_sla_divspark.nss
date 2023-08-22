/**
 * @file
 * Spellscript for Divine Spark SLAs
 *
 */

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    int nCasterLevel, nDC, nSpell, nUses;
    int nSLA = GetSpellId();
    effect eNone;
    
    object oWOL = GetItemPossessedBy(oPC, "WOL_DivineSpark");
    
    // You get nothing if you aren't wielding the weapon
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_NECK, oPC)) return;  

    switch(nSLA){
        case WOL_DIVSPARK_FEAR:
        {
            nCasterLevel = 5;
            nSpell = SPELL_MAGIC_CIRCLE_AGAINST_EVIL;
            nUses = 1;
            break;
        } 
        case WOL_DIVSPARK_LIGHT:
        {
            nCasterLevel = 10;
            nSpell = SPELL_SEARING_LIGHT;
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
        