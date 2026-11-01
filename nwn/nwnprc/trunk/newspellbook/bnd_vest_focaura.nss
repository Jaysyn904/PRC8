/*
02/03/21 by Stratovarius

Focalor, Prince of Tears
  
Granted Abilities: 
Focalor gives you the ability to breathe water, strike foes down with lightning, blind enemies with a puff of your breath, and cause creatures to be stricken with grief in your presence.

Aura of Sadness: You emit an aura of depression and anguish that overtakes even the strongest-willed creatures. Every adjacent creature is overcome with grief, which manifests as a 
–2 penalty on attack rolls, saving throws, and skill checks, for as long as it remains adjacent to you. You can suppress or activate this ability as a standard action. Aura of sadness is a mind-affecting ability.
*/

#include "bnd_inc_bndfunc"

void main()
{
	object oBinder = OBJECT_SELF;
	int nSpellId = PRCGetSpellId();

    if (GetHasSpellEffect(nSpellId, oBinder) || GetLocalInt(oBinder, "FocalorAuraActive"))
    {
    	DeleteLocalInt(oBinder, "FocalorAuraActive");
    	PRCRemoveSpellEffects(nSpellId, oBinder, oBinder);
    	GZPRCRemoveSpellEffects(nSpellId, oBinder, FALSE);
    	effect eCheck = GetFirstEffect(oBinder);
    	while (GetIsEffectValid(eCheck))
    	{
    		if (GetEffectTag(eCheck) == "FocalorAuraSadnessEff" || GetEffectSpellId(eCheck) == nSpellId)
    			RemoveEffect(oBinder, eCheck);
    		eCheck = GetNextEffect(oBinder);
    	}
    	FloatingTextStringOnCreature("Focalor's Aura of Sadness suppressed.", oBinder, FALSE);
	}	
	else
	{
		effect eLink = EffectLinkEffects(EffectAreaOfEffect(AOE_PER_TELEPORTATIONCIRCLE, "bnd_vest_focaure", "", "bnd_vest_focaurx"), EffectVisualEffect(VFX_DUR_SYMB_SLEEP));
		eLink = TagEffect(SupernaturalEffect(eLink), "FocalorAuraSadnessEff");
		SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oBinder);
		SetLocalInt(oBinder, "FocalorAuraActive", TRUE);
		FloatingTextStringOnCreature("Focalor's Aura of Sadness activated.", oBinder, FALSE);
	}	
}
