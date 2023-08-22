/**
 * @file
 * Spellscript for Scarab of Aradros SLAs
 *
 */

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    int nCasterLevel, nDC, nSpell, nUses;
    int nSLA = GetSpellId();
    effect eNone;
    
    object oWOL = GetItemPossessedBy(oPC, "WOL_Aradros");
    
    // You get nothing if you aren't wielding the weapon
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_NECK, oPC)) return;    

    switch(nSLA){
        case WOL_ARADROS_EXTEND:
        {
            nUses = 3;
            // Check uses per day. 
            if (nUses > GetLegacyUses(oPC, nSLA))
            {            
                SetLegacyUses(oPC, nSLA);
                SetLocalInt(oPC, "Aradros_Extend", TRUE);
            } 
            break;
        } 
        case WOL_ARADROS_EXTEND_ACID:
        {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDamageResistance(DAMAGE_TYPE_ACID, 30), oPC, 60.0);
            break;
        } 
        case WOL_ARADROS_EXTEND_COLD:
        {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDamageResistance(DAMAGE_TYPE_COLD, 30), oPC, 60.0);
            break;
        }
        case WOL_ARADROS_EXTEND_ELEC:
        {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, 30), oPC, 60.0);
            break;
        }
        case WOL_ARADROS_EXTEND_FIRE:
        {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDamageResistance(DAMAGE_TYPE_FIRE, 30), oPC, 60.0);
            break;
        }
        case WOL_ARADROS_EXTEND_SONIC:
        {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDamageResistance(DAMAGE_TYPE_SONIC, 30), oPC, 60.0);
            break;
        }        
    }
    
    // Check uses per day
    if (GetLegacyUses(oPC, nSLA) >= nUses && nSLA == WOL_ARADROS_EXTEND)
    {
        FloatingTextStringOnCreature("You have used " + GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSLA))) + " the maximum amount of times today.", oPC, FALSE);
        return;
    }   
    else if (nSLA == WOL_ARADROS_EXTEND) 
    {
        FloatingTextStringOnCreature("You have "+IntToString(nUses - GetLegacyUses(oPC, nSLA))+ " uses of " + GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSLA))) + " remaining today.", oPC, FALSE);
    }    
}
        