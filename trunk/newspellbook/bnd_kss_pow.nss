/*
07/03/21 by Barmlot

bnd_kss_pow.nss
Knight of the Sacred Vestige's Power
Vestige's Power (+2 STR, CON, +10 speed, +4 will saves for 1 round, 5 round cooldown)
*/

#include "bnd_inc_bndfunc"

void main()
{
	object oBinder = OBJECT_SELF;
	
	if(GetIsPatronVestigeBound(oBinder))
	{
		if(!BindAbilCooldown(oBinder, GetSpellId(), -1)) return; 
		if(!TakeSwiftAction(oBinder)) return;		
		
		effect eLink = EffectAbilityIncrease(ABILITY_STRENGTH,2); //+2 STRENGTH
		eLink = EffectLinkEffects(EffectAbilityIncrease(ABILITY_CONSTITUTION,2), eLink); //+2 CONSTITUTION
		eLink = EffectLinkEffects(EffectMovementSpeedIncrease(33), eLink); // +10' land speed (assumes 30 base)
		eLink = EffectLinkEffects(EffectSavingThrowIncrease(SAVING_THROW_WILL, 4), eLink); // +4 Will saves
		
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oBinder, RoundsToSeconds(1));
	}
}