//::///////////////////////////////////////////////
//:: Name      Devil's Eye
//:: FileName  sp_devils_eye.nss
//:://////////////////////////////////////////////
/**@file Devil's Eye 
Divination [Evil] 
Level: Blk 2, Clr 3, Diabolic 2, Sor/Wiz 3
Components: V, S 
Casting Time: 1 action 
Range: Personal 
Target: Caster
Duration: 1 minute/level

The caster gains the visual acuity of a devil. He
can see not only in darkness, but also in magical 
darkness, with a range of 30 feet.

Author:    Tenjac
Created:   
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
	PRCSetSchool(SPELL_SCHOOL_DIVINATION);
	
	// Run the spellhook. 
	if (!X2PreSpellCastCode()) return;
	
	object oPC = OBJECT_SELF;
	int nCasterLvl = PRCGetCasterLevel(oPC);
	effect eUltra = EffectUltravision();
	effect eVis = EffectVisualEffect(VFX_DUR_ULTRAVISION);
	effect eLink = EffectLinkEffects(eUltra, eVis);
	float fDur = (60.0f * nCasterLvl);
	
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDur);
	
	PRCSetSchool();
	//SPEvilShift(oPC);
}
	
	