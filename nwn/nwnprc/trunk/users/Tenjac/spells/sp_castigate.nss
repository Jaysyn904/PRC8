//:://////////////////////////////////////////////
//:: Name     Castigate
//:: FileName   sp_castigate.nss
//:://////////////////////////////////////////////
/** @file Evocation [Sonic]
Level: Cleric 4, Paladin 4, Purification 4,
Components: V,
Casting Time: 1 standard action
Range: 10 ft.
Area: 10-ft.-radius burst centered on you
Duration: Instantaneous
Saving Throw: Fortitude half
Spell Resistance: Yes

Shouting your deity's teachings, you rebuke your foes with the magic 
of your sacred words.

This spell has no effect on creatures that cannot hear.
All creatures whose alignment differs from yours on both 
the law—chaos and the good—evil axes take 1d4 points of damage
per caster level (maximum 10d4). All creatures whose alignment 
differs from yours on one component take half damage, and this 
spell does not deal damage to those who share your alignment.

A Fortitude saving throw reduces damage by half.
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 1/28/21
//:://////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_add_spell_dc"


void main()
{
	if(!X2PreSpellCastCode()) return;
	PRCSetSchool(SPELL_SCHOOL_EVOCATION);
	object oPC = OBJECT_SELF;
        int nCasterLvl = PRCGetCasterLevel(oPC);
        int nDC = PRCGetSaveDC(oTarget, oPC);
        float fDur =  3600 * nCasterLvl;
        int nMetaMagic = PRCGetMetaMagicFeat();
        if(nMetaMagic & METAMAGIC_EXTEND) fDur += fDur;
        location lLoc = PRCGetSpellTargetLocation();
        int nAlignGE = GetAlignmentGoodEvil(oPC);
        int nAlignLC = GetAlignmentLawChaos(oPC);
        int nTargetAlignGE;
        int nTargetAlignLC;
        int nDam;
        int nLevels = min(10, nCasterLvl);
        float fRadius = FeetToMeters(10);
        
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_HOWL_WAR_CRY), oPC);
        
        object oTarget = (MyFirstObjectInShape(SHAPE_SPHERE, fRadius. lLoc, FALSE));
        
        while(GetIsObjectValid(oTarget))
        {
        	//Not deaf
        	if(GetHasEffect(EFFECT_TYPE_DEAF, oTarget) == FALSE)
        	{
        		//SR
        		if(!PRCDoResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
			{				
				nTargetAlignGE = GetAlignmentGoodEvil(oTarget);
				nTargetAlignLC = GetAlignmentLawChaos(oTarget);
				
				//Test alignment differences
				//Both
				if(nAlignGE != nTargetAlignGE) && (nAlignLC != nTargetAlignLC)
				{
					nDam = d4(nLevels);
				}
				//Half for one 
				else if(nAlignGE != nTargetAlignGE) || (nAlignLC != nTargetAlignLC)
				{
					nDam = d4(nLevels)/2;
				}
				
				//save for half
				if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_DIVINE))
				{
					nDam = nDam/2;
				}
				
				if(nDam > 0)
				{
					SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDam, DAMAGE_TYPE_DIVINE), oTarget);
					SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectvisualEffect(VFX_IMP_HEAD_HOLY), oTarget);
				}
			}
		}
		oTarget = MyNextObjectInShape(SHAPE_SPHERE, fRadius. lLoc, FALSE);
	}		
	PRCSetSchool();
}