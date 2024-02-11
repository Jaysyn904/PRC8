/**
 * @file
 * Spellscript for Hillcrusher SLAs
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
    
    object oWOL = GetItemPossessedBy(oPC, "WOL_Hillcrusher");
    
    // You get nothing if you aren't wielding the weapon
    if(oWOL != GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) return;    
	
	switch(nSLA){
        case WOL_HILLCRUSHER_EARTHEN_MIGHT:
        {
            nCasterLevel = 7;
            nSpell = SPELL_ENLARGE_PERSON;
            nUses = 1;
			nInstant = TRUE;
            break;
        }  
		
		case WOL_HILLCRUSHER_SOFTEN_EARTH:
        {
            nCasterLevel = 7;
            nSpell = SPELL_GREASE;
            nUses = 2;              
            break;
        }   
				
		case WOL_HILLCRUSHER_FANGS_OF_STONE:
        {
            nCasterLevel = 13;
            nSpell = SPELL_SUDDEN_STALAGMITE;
			nUses = 2;
            break;
        }  
		
		case WOL_HILLCRUSHER_RAISE_THE_EARTH:
        {
            nCasterLevel = 15;
            nSpell = SPELL_BONES_OF_THE_EARTH;
			nUses = 2;
            break;
        }  
		
		case WOL_HILLCRUSHER_SHAKE_THE_EARTH:
        {
            nCasterLevel = 17;
            nSpell = SPELL_EARTHQUAKE;
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
    if (nSpell > 0) 
    {
        DoRacialSLA(nSpell, nCasterLevel, nDC, nInstant);
        SetLegacyUses(oPC, nSLA);
        FloatingTextStringOnCreature("You have "+IntToString(nUses - GetLegacyUses(oPC, nSLA))+ " uses of " + GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSLA))) + " remaining today.", oPC, FALSE);
    }
}
        