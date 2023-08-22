//::///////////////////////////////////////////////
//:: Name      Necrotic Empowerment
//:: FileName  sp_nec_empower.nss
//:://////////////////////////////////////////////
/** @file
Necrotic Empowerment
Necromancy [Evil]
Level: Clr 8, sor/wiz 8
Components: V, S, F
Casting Time: 1 standard action
Range: Personal
Target: You
Duration: 1 round/level

You call upon the mother cyst that your body hosts, 
drawing from it strength, vigor, speed, and vicious 
certainty. While the spell is in effect, you gain a 
+8 enhancement bonus to Dexterity, Intelligence, and

Wisdom, a +8 natural armor bonus to Armor Class as 
your skin briefly crusts and hardens, a +5 competence 
bonus on Fortitude saves, and 100 temporary hit points.

While the empowerment lasts, you are unable to cast any
other mother cyst feat-enabled spell.

Focus: Caster must possess a mother cyst.
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells" 
#include "spinc_necro_cyst"
#include "inc_utility"

void main()
{
	
	// Set the spellschool
	PRCSetSchool(SPELL_SCHOOL_NECROMANCY); 
	
	// Run the spellhook. 
	if (!X2PreSpellCastCode()) return;
	
	//Check for casting ability
	if(!GetCanCastNecroticSpells(OBJECT_SELF))
	return;
	
	//Define vars
	object oPC = OBJECT_SELF;
	object oSkin = GetPCSkin(oPC);
	int nCasterLevel = PRCGetCasterLevel(oPC);
	float fDuration = RoundsToSeconds(nCasterLevel);
	int nMetaMagic = PRCGetMetaMagicFeat();
	
	if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
	{
		fDuration = (fDuration * 2);
	}
	
	//Define Ability bonuses
	effect eDex = EffectAbilityIncrease(ABILITY_DEXTERITY, 8);
	effect eInt = EffectAbilityIncrease(ABILITY_INTELLIGENCE, 8);
	effect eWis = EffectAbilityIncrease(ABILITY_WISDOM, 8);
	
	//Define Natural Armor bonus 
	effect eNatArm = EffectACIncrease(8, AC_NATURAL_BONUS);
	
	//Define Fortitude save bonus 
	effect eFortSave = EffectSavingThrowIncrease(SAVING_THROW_FORT, 5, SAVING_THROW_TYPE_ALL);
	
	//Define HP bonus
	effect eHP = EffectTemporaryHitpoints(100);
	
	//Define VFX
	effect eVis = EffectVisualEffect(VFX_DUR_PARALYZED);
	       	
	//Link effects
	effect eLink = EffectLinkEffects(eDex, eInt);
	       eLink = EffectLinkEffects(eLink, eWis);
	       eLink = EffectLinkEffects(eLink, eNatArm);
	       eLink = EffectLinkEffects(eLink, eFortSave);
	       eLink = EffectLinkEffects(eLink, eHP);
	       eLink = EffectLinkEffects(eLink, eVis);
	
	//Apply all effects
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDuration);
	PRCSetSchool();
	
	//SPEvilShift(oPC);
}