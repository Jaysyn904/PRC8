/**
 * @file
 * Spellscript for Desert Wind SLAs
 *
 */

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    int nCasterLevel, nDC, nSpell, nUses;
    int nSLA = GetSpellId();
    effect eNone;
    
    object oWOL = GetItemPossessedBy(oPC, "WOL_DesertWind");
    
    // You get nothing if you aren't wielding the weapon
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) return;  

    switch(nSLA){
        case WOL_DW_FIERY_SLASH:
        {
            nCasterLevel = 5;
            nSpell = SPELL_BURNING_HANDS;
            nUses = 3;
            nDC = 11;            
            if (11 + GetAbilityModifier(ABILITY_CHARISMA, oPC) > nDC)
                nDC = 11 + GetAbilityModifier(ABILITY_CHARISMA, oPC);              
            break;
        } 
        case WOL_DW_HOWLING_WIND:
        {
            nCasterLevel = 5;
            nSpell = SPELL_GUST_OF_WIND;
            nUses = 3;
            nDC = 13;            
            if (12 + GetAbilityModifier(ABILITY_CHARISMA, oPC) > nDC)
                nDC = 12 + GetAbilityModifier(ABILITY_CHARISMA, oPC);              
            break;
        }   
        case WOL_DW_FAN_FLAMES:
        {
            nCasterLevel = 10;
            nSpell = SPELL_FIREBALL;
            nUses = 1;
            nDC = 14;            
            if (13 + GetAbilityModifier(ABILITY_CHARISMA, oPC) > nDC)
                nDC = 13 + GetAbilityModifier(ABILITY_CHARISMA, oPC); 
            SetLocalInt(oPC, "WOL_DesertWindFireball", TRUE);
            DelayCommand(2.0, DeleteLocalInt(oPC, "WOL_DesertWindFireball"));
            break;
        } 
        case WOL_DW_DUST_DESERT:
        {
            nCasterLevel = 15;
            nSpell = SPELL_DISINTEGRATE;
            nUses = 1;
            nDC = 19;
            if (16 + GetAbilityModifier(ABILITY_CHARISMA, oPC) > nDC)
                nDC = 16 + GetAbilityModifier(ABILITY_CHARISMA, oPC);            
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
        