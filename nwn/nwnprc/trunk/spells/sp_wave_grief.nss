//::///////////////////////////////////////////////
//:: Name      Wave of Grief
//:: FileName  sp_wave_grief.nss
//:://////////////////////////////////////////////
/**@file Wave of Grief
Enchantment [Evil, Mind-Affecting] 
Level: Brd 2, Clr 2
Components: S, M 
Casting Time: 1 action 
Range: Close (25 ft. + 5 ft./2 levels) 
Area: Cone
Duration: 1 round/level 
Saving Throw: Will negates 
Spell Resistance: Yes
 
All within the cone when the spell is cast are 
overcome with sorrow and grief. They take a -3 morale
penalty on all attack rolls, saving throws, ability 
checks, and skill checks. 

Material Component: Three tears. 

Author:    Tenjac
Created:   5/9/2006
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_add_spell_dc"
void main()
{
	object oPC = OBJECT_SELF;
	location lLoc = PRCGetSpellTargetLocation();
	object oTarget = MyFirstObjectInShape(SHAPE_SPELLCONE, 7.62f, lLoc, TRUE, OBJECT_TYPE_CREATURE);	
	int nCasterLvl = PRCGetCasterLevel(oPC);
	int nMetaMagic = PRCGetMetaMagicFeat();
	int nPenalty = 3;
	int nDC = PRCGetSaveDC(oTarget, oPC);
	float fDur = RoundsToSeconds(nCasterLvl);
	
	if(nMetaMagic & METAMAGIC_EMPOWER)
	{
		nPenalty += (nPenalty/2);
	}	
	
	if (nMetaMagic & METAMAGIC_EXTEND)
	{
		fDur = (fDur * 2);
	}
	
	effect eVis = EffectVisualEffect(VFX_DUR_GLOW_BLUE);
	effect eLink = EffectAttackDecrease(nPenalty, ATTACK_BONUS_MISC);					      
	       eLink = EffectLinkEffects(eLink, EffectSavingThrowDecrease(SAVING_THROW_ALL, nPenalty, SAVING_THROW_TYPE_ALL));
	       eLink = EffectLinkEffects(eLink, EffectSkillDecrease(SKILL_ALL_SKILLS, nPenalty));
	       eLink = EffectLinkEffects(eLink, eVis);
	
	       	
	while(GetIsObjectValid(oTarget))
	{		
		if(!PRCDoResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
		{
			//Save
			if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_EVIL))
			{
				SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur);
			}
		}
		oTarget = MyNextObjectInShape(SHAPE_SPELLCONE, 7.62f, lLoc, TRUE, OBJECT_TYPE_CREATURE);
	}
	
	//SPEvilShift(oPC);
	PRCSetSchool();
}
	
	