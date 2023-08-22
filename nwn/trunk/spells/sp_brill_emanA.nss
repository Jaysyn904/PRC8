//::///////////////////////////////////////////////
//:: Name      Brilliant Emanation - On Enter
//:: FileName  sp_brill_emanA.nss
//:://////////////////////////////////////////////
/**@file Brilliant Emanation
Evocation [Good] 
Level: Sanctified 3 
Components: Sacrifice 
Casting Time: 1 standard action 
Range: 100 ft. + 10 ft./level
Area: 100-ft.-radius emanation + 10-ft. radius per level
Duration: 1d4 rounds
Saving Throw: Fortitude partial 
Spell Resistance: Yes

This spell causes a divine glow to radiate from 
any reflective objects worn or carried by the 
caster, including metal armor. Evil creatures 
within the spell's area are blinded unless they 
succeed on a Fortitude saving throw. Non-evil 
characters perceive the brilliant light emanating 
from the caster, but are not blinded by it and do 
not suffer any negative effects from it. Evil 
characters that make their saving throw are not 
blinded, but are distracted, taking a -1 penalty 
on any attacks made within the spell's area for 
the duration of the spell. Creatures must be able 
to see visible light to be affected by this spell.

Sacrifice: 1d3 points of Strength damage. 

Author:    Tenjac
Created:   6/8/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{	
	PRCSetSchool(SPELL_SCHOOL_EVOCATION);
		
	object oTarget = GetEnteringObject();
	object oPC = GetAreaOfEffectCreator();
	int nDC = PRCGetSaveDC(oTarget, oPC);
	int nCasterLvl = PRCGetCasterLevel(oPC);	
	
	//if valid                    
	if(GetIsObjectValid(oTarget))
	{
		//and evil
		if((GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL) && !PRCGetHasEffect(EFFECT_TYPE_BLINDNESS, oTarget) && (GetRacialType(oTarget) != RACIAL_TYPE_OOZE))
		{
			//Spell resistance
			if(!PRCDoResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
			{
				if(PRCGetIsAliveCreature(oTarget))
				{
					//Save
					if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
					{
						SPApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectBlindness(), oTarget);
					}
				}
				
				//if saved, just -1 to attacks
				else
				{
					if(!GetHasMettle(oTarget, SAVING_THROW_FORT))
					{
						SPApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAttackDecrease(1), oTarget);
					}
					
				}
			}
		}
	}
	PRCSetSchool();
}
					
				
	
		