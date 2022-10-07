//::///////////////////////////////////////////////
//:: Name      Demoncall
//:: FileName  sp_demoncall.nss
//:://////////////////////////////////////////////
/**@file Demoncall
Divination [Evil]
Level: Blk 2, Demonic 2, Demonologist 2
Components: V, S, M
Casting Time: 1 action
Range: Personal
Target: Caster
Duration: Instantaneous
 
The caster taps into the forbidden knowledge of 
demons, giving her a +10 profane bonus on any one 
check (made immediately) involving Knowledge (arcana),
Knowledge (the planes), or Knowledge (religion).

Author:    Tenjac
Created:   
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
	// Run the spellhook.
	
	if (!X2PreSpellCastCode()) return;
		
	PRCSetSchool(SPELL_SCHOOL_DIVINATION);
	
	object oPC = OBJECT_SELF;
	effect eLore = EffectSkillIncrease(SKILL_LORE, 10);
	
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLore, oPC, 3.0f);
	
	PRCSetSchool();
	//SPEvilShift(oPC);
	
}
	