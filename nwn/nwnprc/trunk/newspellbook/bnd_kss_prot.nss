/*
07/03/21 by Barmlot

bnd_kss_prot.nss
Knight of the Sacred Vestige's Protection & Aura

Vestige's Protection (CHA to AC for 1 round, 5 round cooldown)
Vestige's Protection Aura (as above, but affects all adjacent friends)
*/

#include "bnd_inc_bndfunc"
#include "prc_inc_combat"

void main()
{
	object oBinder = OBJECT_SELF;
	int nKSSLvl = GetLevelByClass(CLASS_TYPE_KNIGHT_SACRED_SEAL, oBinder);
	int nCHAmod = PRCMax(1, GetAbilityModifier(ABILITY_CHARISMA, oBinder));
	int nSpellID = PRCGetSpellId();
	
	if(GetIsPatronVestigeBound(oBinder))
	{
		if(!BindAbilCooldown(oBinder, GetSpellId(), -1)) return; 
		if(!TakeSwiftAction(oBinder)) return;
		
		if (nKSSLvl >= 3)//Vestige Protection Aura
		{
			location lTarget = GetLocation(oBinder);
			
			object oAreaTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
			while(GetIsObjectValid(oAreaTarget))
			{
				if(oAreaTarget != oBinder && // Not you
				GetIsInMeleeRange(oBinder, oAreaTarget) && // They must be in melee range
				GetIsFriend(oAreaTarget, oBinder)) // Only allies
				{
					//Apply bonuses to oAreaTarget
					effect eLink = EffectACIncrease(nCHAmod, AC_DODGE_BONUS);
					eLink = EffectLinkEffects(EffectSavingThrowIncrease(SAVING_THROW_REFLEX, nCHAmod), eLink);
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oAreaTarget, RoundsToSeconds(1));
				}
				//Select the next target within the spell shape.
				oAreaTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
			}
		}
		
		effect eLink = EffectACIncrease(nCHAmod, AC_DODGE_BONUS);
		eLink = EffectLinkEffects(EffectSavingThrowIncrease(SAVING_THROW_REFLEX, nCHAmod), eLink);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oBinder, RoundsToSeconds(1));
	}
}