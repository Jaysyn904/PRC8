/**
 * @file
 * Spellscript for Umbral Awn SLAs
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
    
    object oWOL = GetItemPossessedBy(oPC, "WOL_Umbral");
    
    // You get nothing if you aren't wielding the weapon
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC) && 
       GetItemPossessedBy(oPC, "WOL_Infiltrator") != GetItemInSlot(INVENTORY_SLOT_CHEST, oPC)) return;  

    switch(nSLA){
        case WOL_UMBRAL_INCORP:
        {
            nUses = 3;
            // Check uses per day. 
            if (nUses > GetLegacyUses(oPC, nSLA))
            {            
                SetLegacyUses(oPC, nSLA);
				SetIncorporeal(oPC, 6.0f, 2);      
            } 
            break;
        } 
        case WOL_UMBRAL_INVIS:
        {
            nCasterLevel = 10;
            nSpell = SPELL_INVISIBILITY;
            nUses = 999;
            break;
        }  
        case WOL_UMBRAL_SPEED_WEAPON:
        {
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectModifyAttacks(1)), oPC, 9999.0);
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
        