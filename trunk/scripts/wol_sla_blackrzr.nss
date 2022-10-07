/**
 * @file
 * Spellscript for Blackrazor SLAs
 *
 */

#include "prc_inc_template"
#include "prc_inc_s_det"

void main()
{
    object oPC = OBJECT_SELF;
    int nCasterLevel, nDC, nSpell, nUses;
    int nSLA = GetSpellId();
    effect eNone;
    
    object oWOL = GetItemPossessedBy(oPC, "WOL_Blackrazor");
    
    // You get nothing if you aren't wielding the weapon
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) return;    

    switch(nSLA){
        case WOL_BLACKRAZOR_KNELL:
        {
            nCasterLevel = GetHitDice(oPC);
            nSpell = SPELL_DEATH_KNELL;
            nDC = 12 + GetAbilityModifier(ABILITY_CHARISMA, oPC);
            nUses = 1;
            if (GetHitDice(oPC) >= 13 && GetHasFeat(FEAT_LESSER_LEGACY, oPC)) nUses = 3;
            if (GetHitDice(oPC) >= 17 && GetHasFeat(FEAT_GREATER_LEGACY, oPC)) nUses = 999;
            break;
        } 
        case WOL_BLACKRAZOR_DETECT:
        {
            nCasterLevel = 5;
 		   	if(!X2PreSpellCastCode()) return;
 		   	PRCSetSchool(SPELL_SCHOOL_DIVINATION);
	    	float fDuration = TurnsToSeconds(nCasterLevel);
    		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_DETECT), oPC, fDuration);
    		DetectRaceAura(0, -1, GetLocation(oPC), VFX_BEAM_ODD, FeetToMeters(60.0));
    		PRCSetSchool();
            nUses = 3;
            break;
        }  
        case WOL_BLACKRAZOR_HASTE:
        {
            nCasterLevel = 10;
            nSpell = SPELL_HASTE;
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
    SetLegacyUses(oPC, nSLA);
    FloatingTextStringOnCreature("You have "+IntToString(nUses - GetLegacyUses(oPC, nSLA))+ " uses of " + GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSLA))) + " remaining today.", oPC, FALSE);    
    if (nSpell > 0) 
        DoRacialSLA(nSpell, nCasterLevel, nDC);     
}
        