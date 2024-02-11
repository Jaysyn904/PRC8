/*
09/03/21 by Stratovarius

Balam, the Bitter Angel
  
Once a being of extreme goodness, Balam became a wrathful vestige after taking on an impossible task that ended in failure. She grants her summoners the ability to foresee future difficulties and the intellect to interpret what they see, as well as skill with light arms and a stare that chills flesh.

Vestige Level: 5th
Binding DC: 25
Special Requirement: Balam requires a sacrifice of her summoner. In the process of calling her, you must deal 1 point of slashing damage to yourself.

Influence: Balam’s influence causes you to distrust clerics, paladins, and other devotees of deities. Whenever you enter a temple or some other holy or unholy site, Balam requires that you spit on the floor and utter an invective about the place.

Granted Abilities: 
Balam grants you the power to predict future events. She also teaches cunning and finesse, and gives you the ability to freeze foes with a glance.

Balam’s Cunning: You reroll your next failed saving throw. Once you have used this ability, you cannot do so again for 5 rounds.

Icy Glare: You gain a gaze attack that deals 2d6 points of cold damage to the target. A successful Will save negates this damage.

Prescience: You get a glimpse of the future a moment before it happens. This knowledge manifests as an insight bonus equal to +1 per four effective binder levels on initiative checks, Reflex saves, and AC.

Weapon Finesse: You gain the benefit of the Weapon Finesse feat.
*/

#include "bnd_inc_bndfunc"

void BalamInit(object oBinder, int nBinderLevel)
{
	if (nBinderLevel/4 >= 6) 
	{
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_INIT  ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_THUG  ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
	}
	else if (nBinderLevel/4 >= 4) 
	{
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_INIT  ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
	}
	else if (nBinderLevel/4 >= 2) 
	{
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_THUG  ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
	}	
}

void main()
{
    object oBinder = PRCGetSpellTargetObject(); 
    int nBinderLevel = GetBinderLevel(oBinder, VESTIGE_BALAM);

    effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_GLYPH_OF_WARDING_BLUE), EffectPact(oBinder));
    
    if (!GetIsVestigeExploited(oBinder, VESTIGE_BALAM_CUNNING   )) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_BALAM_CUNNING), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (!GetIsVestigeExploited(oBinder, VESTIGE_BALAM_GLARE     )) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_BALAM_GLARE  ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
	if (!GetIsVestigeExploited(oBinder, VESTIGE_BALAM_PRESCIENCE)) 
	{
		eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_REFLEX, nBinderLevel/4, SAVING_THROW_TYPE_ALL));	
		eLink = EffectLinkEffects(eLink, EffectACIncrease(nBinderLevel/4));	
		BalamInit(oBinder, nBinderLevel);
	}
	if (!GetIsVestigeExploited(oBinder, VESTIGE_BALAM_FINESSE   )) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_FINESSE  ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
     
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oBinder, HoursToSeconds(24));      
}