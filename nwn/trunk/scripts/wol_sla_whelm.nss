/**
 * @file
 * Spellscript for Whelm SLAs
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
    
    object oWOL = GetItemPossessedBy(oPC, "WOL_Whelm");
    
    // You get nothing if you aren't wielding the weapon
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) return;    
	
	switch(nSLA)
	{
        case WOL_WHELM_DETECT_GIANT:
        {
            nCasterLevel = 5;
            if(!X2PreSpellCastCode()) return;
            PRCSetSchool(SPELL_SCHOOL_DIVINATION);
            float fDuration = TurnsToSeconds(nCasterLevel);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_DETECT), oPC, fDuration);
            DetectRaceAura(0, RACIAL_TYPE_GIANT, GetLocation(oPC), VFX_BEAM_FIRE, FeetToMeters(60.0));
            PRCSetSchool();
            nUses = 999;
            break;
        }  
		
		case WOL_WHELM_LOCATE_OBJECT:
        {
            nCasterLevel = 5;
            nSpell = SPELL_LOCATE_OBJECT;
            nUses = 3;              
            break;
        }   
		
		
		case WOL_WHELM_DETECT_GOBLIN:
        {
            nCasterLevel = 5;
            if(!X2PreSpellCastCode()) return;
            PRCSetSchool(SPELL_SCHOOL_DIVINATION);
            float fDuration = TurnsToSeconds(nCasterLevel);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_DETECT), oPC, fDuration);
            DetectRaceAura(0, RACIAL_TYPE_HUMANOID_GOBLINOID, GetLocation(oPC), VFX_BEAM_FIRE, FeetToMeters(60.0));
            PRCSetSchool();
            nUses = 999;
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
        