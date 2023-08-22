/*
13/03/21 by Stratovarius

Arete, the First Elan
  
Arete, a powerful psion who sought immortality, created a new race but doomed himself to never-ending rebirths. His granted abilities provide binders with access to several qualities that toughen the body and mind.

Vestige Level: 4th
Binding DC: 21
Special Requirement: Arete does not like to be reminded that the elan are considered abominations by some, and he does not answer your summons if you are already bound to Chupoclops or Eurynome.

Influence: You do not get hungry or tired while bound to Arete, but you do suffer negative effects if you do not eat or sleep for the duration that the vestige is bound. 
If faced with a need to do research, Arete insists that you seek out lore regarding him and his research into immortality as well, which can often double or even triple the time you spend seeking information.

Granted Abilities: 
While bound to Arete, you gain powers that Arete had at some point in his search for immortality.

Psionic Boon: You gain 13 power points when you bind to Arete. These are added to your pool of power if you already possess psionic power, or they create a pool and you become
a psionic creature for the duration of this binding.

Resistance: Your gain a +4 bonus on a saving throw of your choice. You may change this to another saving throw as a move action.

Damage Reduction: Your body becomes unnaturally tough as you gain damage reduction 5/-.

Repletion: You gain access to the psionic powers body adjustment and body purification for the duration of the binding. You may manifest each power as a psion would and 
as if it is a power known by you. You may augment each power as a psion normally could, substituting your effective binder level in place of manifester level.
*/

#include "bnd_inc_bndfunc"
#include "psi_inc_psifunc"

void main()
{
    object oBinder = PRCGetSpellTargetObject(); 

    effect eLink = EffectLinkEffects(EffectVisualEffect(PSI_DUR_TIMELESS_BODY), EffectPact(oBinder));
    
    if (!GetIsVestigeExploited(oBinder, VESTIGE_ARETE_PSIONIC_BOON)) 
    {
    	GainPowerPoints(oBinder, 13, TRUE);
    	IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_PSIONIC_FOCUS),    HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }	
	if (!GetIsVestigeExploited(oBinder, VESTIGE_ARETE_RESISTANCE  )) 
	{
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_ARETE_RESISTANCE),      HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
		SetLocalInt(oBinder, "AreteResist", SAVING_THROW_FORT);
		DelayCommand(1.0, ActionCastSpellOnSelf(VESTIGE_ARETE_RESIST, METAMAGIC_NONE, oBinder));
	}	
	if (!GetIsVestigeExploited(oBinder, VESTIGE_ARETE_DR          )) 
	{
    	eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING, 5)); 
    	eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_PIERCING, 5)); 
    	eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_SLASHING, 5)); 	
	}
	if (!GetIsVestigeExploited(oBinder, VESTIGE_ARETE_REPLETION   )) 
	{
		// Psion Body Adjustment and Body Purification
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(12134),    HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(12135),    HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
		SetLocalInt(oBinder, "AretePsion", GetBinderLevel(oBinder, VESTIGE_ARETE));
	}	
    
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oBinder, HoursToSeconds(24));     
}