/*
02/03/21 by Stratovarius

Focalor, Prince of Tears
  
Focalor has power over storms and seas. He gives those who bind him the power to drown souls in sadness and sink ships in an ocean of tears.

Vestige Level: 3rd
Binding DC: 20
Special Requirement: No

Influence: While influenced by Focalor, you feel some of his inestimable grief and act morose, rarely smiling or finding cause to laugh. Whenever you kill a creature, 
Focalor demands that as soon as you have a peaceful moment, you take a round to say a few words of sorrow and regret for the life cut short by your actions.

Granted Abilities: 
Focalor gives you the ability to breathe water, strike foes down with lightning, blind enemies with a puff of your breath, and cause creatures to be stricken with grief in your presence.

Aura of Sadness: You emit an aura of depression and anguish that overtakes even the strongest-willed creatures. Every adjacent creature is overcome with grief, which manifests as a 
–2 penalty on attack rolls, saving throws, and skill checks, for as long as it remains adjacent to you. You can suppress or activate this ability as a standard action. Aura of sadness is a mind-affecting ability.

Focalor’s Breath: As a standard action, you can exhale toward a single living target within 30 feet. That target is blinded for 1 round unless it succeeds on a Fortitude save. 
Once you have used this ability, you cannot do so again for 5 rounds.

Lightning Strike: Once per round as a standard action, you can call down a bolt of lightning that strikes any target you designate, as long as it is within 10 feet per effective 
binder level of your position. The lightning bolt deals 3d6 points of electricity damage, plus an additional 1d6 points of electricity damage for every three effective binder 
levels you possess above 5th. A successful Reflex save halves this damage. 

Water Breathing: You can breathe both water and air easily
*/

#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = PRCGetSpellTargetObject(); 

    effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_PROTECTION_ENERGY_ELECT), EffectPact(oBinder));
    
    if (!GetIsVestigeExploited(oBinder, VESTIGE_FOCALOR_AURA)) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_FOCALOR_AURA), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    
    // We get this with the Practiced Binder feat
    if (GetLevelByClass(CLASS_TYPE_BINDER, oBinder) || GetHasFeat(FEAT_PRACTICED_BINDER, oBinder))
    {
		if (!GetIsVestigeExploited(oBinder, VESTIGE_FOCALOR_BREATHING)) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_WATER_BREATHING), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }	
	
    // Binders only down here
    if (GetLevelByClass(CLASS_TYPE_BINDER, oBinder)) 
    {
    	if (!GetIsVestigeExploited(oBinder, VESTIGE_FOCALOR_LIGHTNING)) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_FOCALOR_BOLT), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    	if (!GetIsVestigeExploited(oBinder, VESTIGE_FOCALOR_BREATH)) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_FOCALOR_BREATH), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }	
    
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oBinder, HoursToSeconds(24));      
}