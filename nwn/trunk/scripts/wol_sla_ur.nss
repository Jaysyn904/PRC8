/**
 * @file
 * Spellscript for Ur SLAs
 *
 */

#include "prc_inc_template"

void main()
{
    object oPC = OBJECT_SELF;
    int nCasterLevel, nDC, nSpell, nUses;
    int nSLA = GetSpellId();
    
    object oWOL = GetItemPossessedBy(oPC, "WOL_Ur");
    
    // You get nothing if you aren't wielding the weapon
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) return;    

    switch(nSLA){
        case WOL_UR_SWIFT:
        {
            nUses = 3;
            // Check uses per day. 
            if (nUses > GetLegacyUses(oPC, nSLA))
            {            
                SetLegacyUses(oPC, nSLA);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectMovementSpeedIncrease(99)), oPC, 6.0);       
            } 
            break;
        }  
        case WOL_UR_HEALING:
        {
            nCasterLevel = 15;
            nSpell = SPELL_CURE_CRITICAL_WOUNDS;
            nUses = 2;
            break;
        }        
        case WOL_UR_SAVAGE:
        {
            nUses = 1;
            // Check uses per day. 
            if (nUses > GetLegacyUses(oPC, nSLA))
            {        
                SetLegacyUses(oPC, nSLA);
                effect eLink = EffectLinkEffects(EffectImmunity(IMMUNITY_TYPE_DEATH), EffectImmunity(IMMUNITY_TYPE_POISON));
                       eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_FEAR));
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oPC, 60.0); 
                SetImmortal(oPC, TRUE);
                DelayCommand(60.0, SetImmortal(oPC, FALSE));
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
        