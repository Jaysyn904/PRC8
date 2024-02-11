//::///////////////////////////////////////////////
//:: Name      Chaav's Laugh
//:: FileName  sp_chaavs_lgh.nss
//:://////////////////////////////////////////////
/**@file Chaav's Laugh
Enchantment (Compulsion)[Good, Mind-Affecting]
Level: Cleric 5, Joy 5
Components: V
Casting Time: 1 standard action
Range: 40ft
Area: 40-ft-radius spread centered on you
Duration: 1 minute/level
Saving Throw: Will negates
Spell Resistance: Yes

You release a joyous, boistrous laugh that 
strengthens the resolve of good creatures and
weakens the resolve of evil creatures.

Good creatures within the spell's area gain the
following benefits for the duration of the spell:
a +2 morale bonus on attack rolls an saves against
fear effects. plus temporary hit points equal to
1d8 + caster level(to a maximum of 1d8 +20 at level
20).  

Evil creatures within the spell's are that fail a 
Will save take a -2 morale penalty on attack rolls
and saves against fear effects for the duration of
the spell.  

Creatures must beable to hear the laugh to be
affected by the spell. Creatures that are neither 
good nor evil are anaffected by Chaav's Laugh.

Author:    Tenjac
Created:   7/10/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
	if(!X2PreSpellCastCode()) return;
	
	PRCSetSchool(SPELL_SCHOOL_ENCHANTMENT);
	
	object oPC = OBJECT_SELF;
	location lLoc = GetLocation(oPC);
	object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, 12.19f, lLoc, TRUE, OBJECT_TYPE_CREATURE); 
	int nCasterLvl = PRCGetCasterLevel(oPC);
	int nDC;
	int nAlign;
	int nMetaMagic = PRCGetMetaMagicFeat();
	int nModify = 2;
	float fDur = (60.0f * nCasterLvl);
	
	if(nMetaMagic & METAMAGIC_EMPOWER)
	{
		nModify = 3;
	}
	
	if(nMetaMagic & METAMAGIC_EXTEND)
	{
		fDur += fDur;
	}
	
	effect eVilLink = EffectLinkEffects(EffectAttackDecrease(nModify, ATTACK_BONUS_MISC), EffectSavingThrowDecrease(SAVING_THROW_ALL, nModify, SAVING_THROW_TYPE_FEAR));
	effect eGoodLink = EffectLinkEffects(EffectAttackIncrease(nModify, ATTACK_BONUS_MISC), EffectSavingThrowIncrease(SAVING_THROW_ALL, nModify, SAVING_THROW_TYPE_FEAR));
	       eGoodLink = EffectLinkEffects(eGoodLink, EffectTemporaryHitpoints(d8(1) + min(20, nCasterLvl)));
	       
	while(GetIsObjectValid(oTarget))
	{
		nAlign = GetAlignmentGoodEvil(oTarget);
		nDC = PRCGetSaveDC(oTarget, oPC);
		
		if(!PRCGetHasEffect(EFFECT_TYPE_DEAF, oTarget))
		{
			
			if (nAlign == ALIGNMENT_EVIL)
			{
				//SR
				if(!PRCDoResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
				{
					//Save
					if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
					{
						SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVilLink, oTarget, fDur);				
					}
				}
			}
			
			if(nAlign == ALIGNMENT_GOOD)
			{
				SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eGoodLink, oTarget, fDur);
			}
		}
		oTarget = MyNextObjectInShape(SHAPE_SPHERE, 12.19f, lLoc, TRUE, OBJECT_TYPE_CREATURE); 
	}			
	//SPGoodShift(oPC);
	PRCSetSchool();
}
				
		
		
		
	
	