//::///////////////////////////////////////////////
//:: Name      Dancing Web
//:: FileName  sp_dancg_web.nss
//:://////////////////////////////////////////////
/**@file Dancing Web 
Evocation [Good] 
Level: Clr 5, Drd 5, Sor/Wiz 4
Components: V, S, M/DF 
Casting Time: 1 standard action
Range: Medium (100 ft. + 10 ft./level) 
Area: 20-ft.-radius burst
Duration: Instantaneous
Saving Throw: Reflex half; see text 
Spell Resistance: Yes
 
This spell creates a burst of magical energy that 
deals 1d6 points per level of non-lethal damage 
maximum 10d6). Further, evil creatures that fail 
their saving throw become entangled by lingering 
threads of magical energy for 1d6 rounds. An 
entangled creature takes a -2 penalty on attack 
rolls and a -4 penalty to effective Dexterity; 
the entangled target can move at half speed but
can't run or charge.

Arcane Material Component: A bit of spider's web.

Author:    Tenjac
Created:   7/6/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
	if(!X2PreSpellCastCode()) return;
	
	PRCSetSchool(SPELL_SCHOOL_EVOCATION);
	
	object oPC = OBJECT_SELF;
	location lLoc = PRCGetSpellTargetLocation();
	object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, 6.10f, lLoc, TRUE, OBJECT_TYPE_CREATURE);
	float fDur;
	int nMetaMagic = PRCGetMetaMagicFeat();
	int nCasterLvl = PRCGetCasterLevel(oPC);
	int nMin = PRCMin(10, nCasterLvl);
	int nDam;
	int nDC = PRCGetSaveDC(oTarget, oPC);
	
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_DISPEL_DISJUNCTION), lLoc);
		
	while(GetIsObjectValid(oTarget))
	{				
		//SR
		if(!PRCDoResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
		{
			//Should be non-lethal
			nDam = d6(nMin);
			
			if(nMetaMagic & METAMAGIC_MAXIMIZE)
			{
				nDam = 6 * nMin;
				fDur = RoundsToSeconds(6);
			}
			
			if(nMetaMagic & METAMAGIC_EMPOWER)
			{
				nDam += (nDam/2);
			}
			nDam += SpellDamagePerDice(oPC, nMin);
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_MAGICAL), oTarget);
			
			if(GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL)
			{
				if(!PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_GOOD))
				{
					fDur = RoundsToSeconds(d6(1));
					
					if(nMetaMagic & METAMAGIC_EXTEND)
					{
						fDur += fDur;
					}
					
					SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectEntangle(), oTarget, fDur);
				}
			}
		}
		oTarget = MyNextObjectInShape(SHAPE_SPHERE, 6.10f, lLoc, TRUE, OBJECT_TYPE_CREATURE);
	}
	
	//SPGoodShift(oPC);
	
	PRCSetSchool();
}