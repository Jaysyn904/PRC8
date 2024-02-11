/**
 * @file
 * Spellscript for Faithful Avenger SLAs
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
    
    object oWOL = GetItemPossessedBy(oPC, "WOL_Faithful");
    
    // You get nothing if you aren't wielding the weapon
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) return;  

    switch(nSLA){
        case WOL_FAITHFUL_IMMORTAL:
        {
            nCasterLevel = 15;
            nSpell = MOVE_DS_IMMORTAL_FORTITUDE;
            nUses = 999;
            break;
        } 
        case WOL_FAITHFUL_STRIKE:
        {
			if (GetAlignmentLawChaos(oPC) == ALIGNMENT_CHAOTIC) ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(VersusAlignmentEffect(EffectAttackIncrease(1), ALIGNMENT_LAWFUL, ALIGNMENT_ALL)), oPC, 9999.0);
			if (GetAlignmentLawChaos(oPC) == ALIGNMENT_LAWFUL ) ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(VersusAlignmentEffect(EffectAttackIncrease(1), ALIGNMENT_CHAOTIC, ALIGNMENT_ALL)), oPC, 9999.0);
			if (GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD) ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(VersusAlignmentEffect(EffectAttackIncrease(1), ALIGNMENT_ALL, ALIGNMENT_EVIL)), oPC, 9999.0);
            break;
        } 
        case WOL_FAITHFUL_DETECT:
        {
            nCasterLevel = 10;
            nSpell = SPELL_DETECT_EVIL;
            nUses = 999;
            break;
        }         
        case WOL_FAITHFUL_LR:
        {
            nCasterLevel = 10;
            nSpell = SPELL_LESSER_RESTORATION;
            nUses = 3;
            break;
        }   
        case WOL_FAITHFUL_RESTORE:
        {
            nCasterLevel = 15;
            nSpell = SPELL_RESTORATION;
            nUses = 1;
            nInstant = TRUE;
            break;
        }  
        case WOL_FAITHFUL_RESILIENCY:
        {
            nUses = 1;
            // Check uses per day. 
            if (nUses > GetLegacyUses(oPC, nSLA))
            {            
                SetLegacyUses(oPC, nSLA);
        		// Damage immunities
               	effect eLink = EffectLinkEffects(EffectVisualEffect(PSI_DUR_TIMELESS_BODY), EffectDamageImmunityIncrease(DAMAGE_TYPE_ACID, 100));
               	eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING, 100));
               	eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD,        100));
               	eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_DIVINE,      100));
               	eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL,  100));
               	eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE,        100));
               	eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_MAGICAL,     100));
               	eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_NEGATIVE,    100));
               	eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_PIERCING,    100));
               	eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_POSITIVE,    100));
               	eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING,    100));
               	eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_SONIC,       100));                
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oPC, 6.0);       
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
        