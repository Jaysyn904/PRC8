//::///////////////////////////////////////////////
//:: Name      Crushing Despair
//:: FileName  sp_crsh_despair.nss
//:://////////////////////////////////////////////
/**@file Crushing Despair
Enchantment (Compulsion) [Mind-Affecting]
Level: Brd 3, Wiz 4
Components: V, S, M
Casting Time: 1 standard action
Range: 30 ft.
Area: Cone
Duration: 1 min./level
Saving Throw: Will negates
Spell Resistance: Yes

A cone of despair causes great sadness in the subjects. Each affected creature takes a –2 penalty on attack rolls, saving throws, ability checks, skill checks, and weapon damage rolls. 

Author:    Stratovarius
Created:   5/17/2009
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_add_spell_dc"
void main()
{
	if(!X2PreSpellCastCode()) return;
	object oPC = OBJECT_SELF;
	location lLoc = PRCGetSpellTargetLocation();
	object oTarget = MyFirstObjectInShape(SHAPE_SPELLCONE, FeetToMeters(30.0), lLoc, TRUE, OBJECT_TYPE_CREATURE);	
	int nCasterLvl = PRCGetCasterLevel(oPC);
	int nMetaMagic = PRCGetMetaMagicFeat();
	int nPenalty = 2;
	int nDC = PRCGetSaveDC(oTarget, oPC);
	float fDur = RoundsToSeconds(nCasterLvl);
	
	if (nMetaMagic & METAMAGIC_EXTEND)
	{
		fDur = (fDur * 2);
	}
	
	effect eVis = EffectVisualEffect(VFX_DUR_GLOW_BLUE);
	effect eLink = EffectAttackDecrease(nPenalty, ATTACK_BONUS_MISC);					      
	       eLink = EffectLinkEffects(eLink, EffectSavingThrowDecrease(SAVING_THROW_ALL, nPenalty, SAVING_THROW_TYPE_ALL));
	       eLink = EffectLinkEffects(eLink, EffectSkillDecrease(SKILL_ALL_SKILLS, nPenalty));
	       eLink = EffectLinkEffects(eLink, EffectDamageDecrease(nPenalty, DAMAGE_TYPE_BLUDGEONING|DAMAGE_TYPE_PIERCING|DAMAGE_TYPE_SLASHING));
	       //eLink = EffectLinkEffects(eLink, EffectDamageDecrease(nPenalty, DAMAGE_TYPE_PIERCING));
	       //eLink = EffectLinkEffects(eLink, EffectDamageDecrease(nPenalty, DAMAGE_TYPE_BLUDGEONING));
	       // Physical damage reduction affects all physical, so this is actually a 3x reduction
	       eLink = EffectLinkEffects(eLink, eVis);
	       
	while(GetIsObjectValid(oTarget))
	{		
		if(!PRCDoResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr())&& !GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS))
		{
			//Save
			if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
			{
				SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur);
			}
		}
		oTarget = MyNextObjectInShape(SHAPE_SPELLCONE, FeetToMeters(30.0), lLoc, TRUE, OBJECT_TYPE_CREATURE);
	}
	
	PRCSetSchool();
}
	
	