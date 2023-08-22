//::///////////////////////////////////////////////
//:: Name      Elation
//:: FileName  sp_elation.nss
//:://////////////////////////////////////////////
/**@file Elation
Enchantment [Mind-Affecting] 
Level: Brd 2, Clr 2, Sor/Wiz 3 
Components: V, S
Casting Time: 1 standard action 
Range: 80 ft.
Targets: Allies in an 80-ft.radius spread of you
Duration: 1 round/level
Saving Throw: Will negates (harmless) 
Spell Resistance: Yes (harmless)

Your allies become elated, full of energy and joy. 
Affected creatures gain a +2 morale bonus to 
effective Strength and Dexterity, and their speed 
increases by +5 feet.

Elation does not remove the condition of fatigue,
but it does offset most of the penalties for being
fatigued.

Author:    Tenjac
Created:   6/25/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
	if(!X2PreSpellCastCode()) return;
	
	PRCSetSchool(SPELL_SCHOOL_ENCHANTMENT);
	
	object oPC = OBJECT_SELF;
	object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, 24.4f, GetLocation(oPC), FALSE, OBJECT_TYPE_CREATURE);
	int nCasterLvl = PRCGetCasterLevel(oPC);
	float fDur = RoundsToSeconds(nCasterLvl);
	int nMetaMagic = PRCGetMetaMagicFeat();
	
	if (nMetaMagic & METAMAGIC_EXTEND)
	{
		fDur += fDur;
	}
		
	if (oTarget == oPC)
	{
		oTarget = MyNextObjectInShape(SHAPE_SPHERE, 24.4f, GetLocation(oPC), FALSE, OBJECT_TYPE_CREATURE);
	}
	
	effect eBuff = EffectLinkEffects(EffectAbilityIncrease(ABILITY_STRENGTH, 2), EffectAbilityIncrease(ABILITY_DEXTERITY, 2));
	
	while(GetIsObjectValid(oTarget))
	{
		if(!GetIsEnemy(oTarget, oPC))
		{
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE), oTarget);
			SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBuff, oTarget, fDur);
		}
		oTarget = MyNextObjectInShape(SHAPE_SPHERE, 24.4f, GetLocation(oPC), FALSE, OBJECT_TYPE_CREATURE);
	}
	PRCSetSchool();
}
	
	