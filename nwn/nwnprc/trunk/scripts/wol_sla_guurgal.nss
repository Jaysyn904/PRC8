/**
 * @file
 * Spellscript for Guurgal SLAs
 *
 */

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    int nCasterLevel, nDC, nSpell, nUses;
    int nSLA = GetSpellId();
    effect eNone;
    
    object oWOL = GetItemPossessedBy(oPC, "WOL_Guurgal");
    
    // You get nothing if you aren't wielding the weapon
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) return;    

    switch(nSLA){
        case WOL_GUURGAL_FORCE:
        {
            nCasterLevel = 5;
            nSpell = SPELL_MIRROR_IMAGE;
            nUses = 1;
            break;
        } 
        case WOL_GUURGAL_RAGE:
        {
            nUses = 1;
            // Check uses per day. 
            if (nUses > GetLegacyUses(oPC, nSLA))
            {            
                SetLegacyUses(oPC, nSLA);
                effect eLink =                          EffectAbilityIncrease(ABILITY_STRENGTH, 6);
                       eLink = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_CONSTITUTION, 2));
                       eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_WILL, 3));
                       eLink = EffectLinkEffects(eLink, EffectACDecrease(2));
                effect eVis  = EffectVisualEffect(VFX_IMP_PDK_INSPIRE_COURAGE);
                float fDuration = RoundsToSeconds(10);
        
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oPC, fDuration);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);       
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
        DoRacialSLA(nSpell, nCasterLevel, nDC);
        SetLegacyUses(oPC, nSLA);
        FloatingTextStringOnCreature("You have "+IntToString(nUses - GetLegacyUses(oPC, nSLA))+ " uses of " + GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSLA))) + " remaining today.", oPC, FALSE);
    }     
}
        