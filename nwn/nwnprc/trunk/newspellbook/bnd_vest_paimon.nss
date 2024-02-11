/*
02/03/21 by Stratovarius

Paimon, the Dancer
  
Paimon whirls into reality with grace and style. He gives his summoners the ability to see combat as a dance and makes them masters of its steps and hidden meter.

Vestige Level: 3rd
Binding DC: 20
Special Requirement: No

Influence: Paimon’s influence makes you lascivious and bold. In addition, Paimon requires that you dance (moving at half speed) whenever you hear music.

Granted Abilities: 
Paimon gives you the ability to dance in and out of combat, and to make whirling attacks against multiple foes.

Dance of Death: When you use this ability as a standard action, you move up to your speed in a line and make a single attack against any creature you move 
past, provoking attacks of opportunity normally. Once you have used this ability, you cannot do so again for 5 rounds.

Paimon’s Blades: You gain proficiency with the rapier and short sword, and the benefit of the Weapon Finesse feat when you wield such weapons.

Paimon’s Dexterity: You gain a +4 bonus to Dexterity.

Paimon’s Skills: You gain a +4 bonus on Tumble checks and Perform checks.

Uncanny Dodge: You retain your Dexterity bonus to AC (if any) even if caught flat-footed or struck by an invisible attacker.

Whirlwind Attack: You gain the benefit of the Whirlwind Attack feat.
*/

#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = PRCGetSpellTargetObject(); 

    effect eLink = EffectLinkEffects(EffectVisualEffect(PSI_DUR_BURST), EffectPact(oBinder));
    
    if (!GetIsVestigeExploited(oBinder, VESTIGE_PAIMON_SKILLS))
    {
		eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_TUMBLE, 4));
		eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_PERFORM, 4));    
	}	
    
    // We get this with the Practiced Binder feat
    if (GetLevelByClass(CLASS_TYPE_BINDER, oBinder) || GetHasFeat(FEAT_PRACTICED_BINDER, oBinder))
    {
		if (!GetIsVestigeExploited(oBinder, VESTIGE_PAIMON_DODGE)) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_UNCANNY_DODGE1), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }	
	
    // Binders only down here
    if (GetLevelByClass(CLASS_TYPE_BINDER, oBinder)) 
    {
    	if (!GetIsVestigeExploited(oBinder, VESTIGE_PAIMON_DANCE)) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_PAIMON_DANCE), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    	if (!GetIsVestigeExploited(oBinder, VESTIGE_PAIMON_WHIRLWIND)) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_WHIRLWIND), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    	if (!GetIsVestigeExploited(oBinder, VESTIGE_PAIMON_BLADES))
    	{
    		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROFICIENCY_RAPIER), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROFICIENCY_SHORTSWORD), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    	}	
    	if (!GetIsVestigeExploited(oBinder, VESTIGE_PAIMON_DEX)) eLink = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_DEXTERITY, 4));    
    }	
    
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oBinder, HoursToSeconds(24));      
}