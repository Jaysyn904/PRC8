/**
 * @file
 * Spellscript for Durindana SLAs
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
    
    object oWOL = GetItemPossessedBy(oPC, "WOL_Durindana");
    
    // You get nothing if you aren't wielding the weapon
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) return;  

    switch(nSLA){
        case WOL_DURINDANA_DAYLIGHT:
        {
            nCasterLevel = 5;
            nSpell = SPELL_DAYLIGHT;
            nUses = 1;
            break;
        }   
        case WOL_DURINDANA_WARD:
        {
            nCasterLevel = 7;
            nSpell = SPELL_DEATH_WARD;
            nUses = 1;
            break;
        } 
        case WOL_DURINDANA_HALLOW:
        {
            nCasterLevel = 9;
            nSpell = SPELL_HALLOW;
            nUses = 1;
            ActionCastSpell(SPELL_DAYLIGHT, 9, 0, 0, METAMAGIC_NONE, CLASS_TYPE_INVALID, FALSE, TRUE, oPC, TRUE, FALSE);
            break;
        }   
        case WOL_DURINDANA_DAZZLE:
        {
            nUses = 1;
            // Check uses per day. 
            if (nUses > GetLegacyUses(oPC, nSLA))
            {        
                SetLegacyUses(oPC, nSLA);
                effect eLink = EffectLinkEffects(EffectConcealment(50), EffectVisualEffect(VFX_DUR_LIGHT_WHITE_20));
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oPC, RoundsToSeconds(15));
            }    
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
        