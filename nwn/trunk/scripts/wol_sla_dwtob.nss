/**
 * @file
 * Spellscript for Desert Wind ToB SLAs
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
    
    object oWOL = GetItemPossessedBy(oPC, "WOL_DesertWindTOB");
    
    // You get nothing if you aren't wielding the weapon
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) return;  

    switch(nSLA){
        case WOL_DWTOB_BURNING_BLADE:
        {
            nCasterLevel = 10;
            nSpell = MOVE_DW_BURNING_BLADE;
            nUses = 3;
            break;
        } 
        case WOL_DWTOB_FAN_THE_FLAMES:
        {
            nCasterLevel = 10;
            nSpell = MOVE_DW_FAN_FLAMES;
            nUses = 999;
            break;
        } 
        case WOL_DWTOB_WYRMS_FLAME:
        {
            nCasterLevel = 20;
            nSpell = MOVE_DW_WYRMS_FLAME;
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
        DoRacialSLA(nSpell, nCasterLevel, nDC, nInstant);
        SetLegacyUses(oPC, nSLA);
        FloatingTextStringOnCreature("You have "+IntToString(nUses - GetLegacyUses(oPC, nSLA))+ " uses of " + GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSLA))) + " remaining today.", oPC, FALSE);
    }     
}
        