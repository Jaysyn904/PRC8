/**
 * @file
 * Spellscript for Eventide's Edge SLAs
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
    
    object oWOL = GetItemPossessedBy(oPC, "WOL_Eventide");
    
    // You get nothing if you aren't wielding the weapon
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) return;  

    switch(nSLA){
        case WOL_EVENTIDE_COMET:
        {
            nCasterLevel = 10;
            nSpell = MOVE_SS_COMET_THROW;
            nUses = 999;
            break;
        } 
        case WOL_EVENTIDE_BAFFLE:
        {
            nUses = 3;
            // Check uses per day. 
            if (nUses > GetLegacyUses(oPC, nSLA))
            {            
                SetLegacyUses(oPC, nSLA);
                SetLocalInt(oPC, "EventideBaffle", TRUE);
                DelayCommand(6.0, DeleteLocalInt(oPC, "EventideBaffle"));
            } 
            break;
        } 
        case WOL_EVENTIDE_INVIS:
        {
            nCasterLevel = 10;
            nSpell = SPELL_IMPROVED_INVISIBILITY;
            nUses = 2;
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
        