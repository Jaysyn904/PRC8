//:://////////////////////////////////////////////
//:: Name     Aligned Aura
//:: FileName   sp_alignedaura.nss
//:://////////////////////////////////////////////
/** @file

Abjuration
Level: Blackguard 4, Cleric 4, Paladin 4,
Components: V, S, DF,
Casting Time: 1 standard action
Range: 20 ft. or 60 ft.
Area: 20-ft.-radius emanation or 60-ft.-radius burst, centered on you
Duration: 1 round/level or until discharged
Saving Throw: Fortitude partial
Spell Resistance: Yes

A rush of divine energy flows through your holy symbol, infusing your body 
with the essence of the divine ethos. When you cast this spell, choose one 
non-neutral aspect of your own alignment—chaos, evil, good, or law. 
(If you are neutral, you can select whichever alignment you wish each time 
you cast this spell). You are immediately surrounded in a 20-foot aura of 
invisible energy associated with the chosen alignment component. Anyone in 
that area who shares that alignment component gains a bonus, and anyone with 
the opposed alignment component must make a Fortitude save or take a penalty. 
The values of these modifiers and the features to which they apply are given 
on the following table. These modifiers end when the affected creature leaves 
the spell's area.

Alignment	Bonus	Penalty
Chaos	+1 on attack rolls	-1 on saving throws
Evil	+1 on damage rolls	-1 to Armor Class
Good	+1 on saving throws	-1 on attack rolls
Law	+1 to Armor Class	-1 on damage rolls
At any point before the duration expires, you can choose to unleash the spell's 
remaining power in a 60-foot burst that deals 1d4 points of damage per round of 
duration remaining (maximum 15d4) to each creature of the opposed alignment in 
the area. Each affected creature can attempt a Fortitude save for half damage. 
The burst also heals 1 point of damage per round of duration remaining 
(maximum 15 points) for each creature of the same alignment in the area. Once 
this option is invoked, the spell ends immediately.
 
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 1/24/21
//:://////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_add_spell_dc"


void main()
{
	object oCreator = GetAreaOfEffectCreator();
        int nGood = GetAlignmentGoodEvil(oCreator);
        int nLaw = GetLawChaosValue(oCreator);
        int nCasterLvl = PRCGetCasterLevel(oCreator);
        float fDur = RoundsToSeconds(nCasterLvl);
	int nSpellID = PRCGetSpellId();
	int nSaveType;
	object oTarget = GetEnteringObject();
	effect eBuff;
	effect eDebuff;
	effect eVisHelp;
	effect eVisHarm;
	effect eLink;
	
	if(nSpellID == SPELL_ALIGNED_AURA_CHAOS)
	{
		eBuff = EffectAttackIncrease(1);
		eDebuff = EffectSavingThrowDecrease(SAVING_THROW_ALL, 1, SAVING_THROW_TYPE_ALL);
		eVisHelp = EffectVisualEffect(VFX_IMP_DESTRUCTION);
		eVisHarm = EffectVisualEffect(VFX_IMP_HEAD_ODD);
		nSaveType = SAVING_THROW_TYPE_CHAOS;
	}	
	if(nSpellID == SPELL_ALIGNED_AURA_EVIL)
	{
		eBuff = EffectDamageIncrease(DAMAGE_BONUS_1);
		eDebuff = EffectACDecrease(1);
		eVisHelp = EffectVisualEffect(VFX_IMP_EVIL_HELP);
		eVisHarm = EffectVisualEffect(VFX_IMP_HEAD_EVIL);
		nSaveType = SAVING_THROW_TYPE_EVIL;
	}	
	if(nSpellID == SPELL_ALIGNED_AURA_GOOD)
	{
		eBuff = EffectSavingThrowIncrease(SAVING_THROW_ALL, 1, SAVING_THROW_TYPE_ALL;
		eDebuff = EffectAttackDecrease(1);
		eVisHelp = EffectVisualEffect(VFX_IMP_GOOD_HELP);
		eVisHarm = EffectVisualEffect(VFX_IMP_HEAD_HOLY);
		nSaveType = SAVING_THROW_TYPE_GOOD;
	}
	if(nSpellID == SPELL_ALIGNED_AURA_LAW)
	{
		eBuff = EffectACIncrease(1);
		eDebuff = EffectDamageDecrease(DAMAGE_BONUS_1, DAMAGE_TYPE_BLUDGEONING|DAMAGE_TYPE_PIERCING|DAMAGE_TYPE_SLASHING);
		eVisHelp = EffectVisualEffect(VFX_IMP_AC_BONUS);
		eVisHarm = EffectVisualEffect(VFX_IMP_HEAD_COLD);
		nSaveType = SAVING_THROW_TYPE_LAW;
	}	
	if(GetIsReactionTypeFriendly(oTarget) || GetFactionEqual(oTarget))
	{
		SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBuff, oTarget, fDur);
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVisHelp, oTarget);
	}
	
	else
	{	//Spell Resist
		if(!PRCDoResistSpell(oCaster, oTarget,nCasterLvl + SPGetPenetr()))
		{
			//Save
			if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, (PRCGetSaveDC(oTarget,oCreator)), nSaveType))
		 	{
		 		SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDebuff, oTarget, fDur);
		 		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVisHarm, oTarget);
		 	}
		 }	
	}	 		
	PRCSetSchool();
}