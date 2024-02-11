/*
08/03/21 by Stratovarius

Acererak, the Devourer
  
Acererak, a half-human lich, grasped at godlike power only to lose his grip on reality. As a vestige, he grants abilities that are similar to a lich’s powers.

Vestige Level: 5th
Binding DC: 25
Special Requirement: None

Influence: As a vestige, Acererak possesses the immortality he desired but none of the power that should accompany it. If you fall under his influence, 
you evince a strong hunger for influence and primacy. If you are presented with an opportunity to fill a void in power over a group of creatures, Acererak 
requires that you attempt to seize that power. You might impersonate a missing city offi cial, take command of a leaderless unit of soldiers, or even grab the reins of runaway horses to establish your supremacy.

Granted Abilities: 
While bound to Acererak, you gain powers that the great lich held in his legendary unlife.

Detect Undead: You can use detect undead as the spell at will (caster level equals your effective binder level).

Hide from Undead: At will as a standard action, you can cast hide from undead.

Lich’s Energy Immunities: You gain immunity to cold and electricity damage.

Paralyzing Touch: As a standard action, you can make a touch attack to paralyze a living foe. The touched creature must succeed on a Fortitude save or be 
paralyzed for a number of rounds equal to one-half your effective binder level. Each round on its turn, the paralyzed creature can attempt a new saving 
throw as a full-round action, with success ending the effect immediately. Once you have used this ability, you cannot do so again for 5 rounds.

Undead Healing: Negative energy (such as that of an inflict spell) heals you rather than damaging you. If you are a living creature, positive energy (such as a cure spell) still heals you as well.
*/

#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = PRCGetSpellTargetObject(); 

    effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_SYMB_DEATH), EffectPact(oBinder));
    
    if (!GetIsVestigeExploited(oBinder, VESTIGE_ACERERAK_DETECT )) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_ACERERAK_DETECT), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (!GetIsVestigeExploited(oBinder, VESTIGE_ACERERAK_HIDE   )) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_ACERERAK_HIDE  ),       HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
	if (!GetIsVestigeExploited(oBinder, VESTIGE_ACERERAK_LICH   )) 
	{
		eLink = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD,        100));	
		eLink = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL,  100));	
	}
	if (!GetIsVestigeExploited(oBinder, VESTIGE_ACERERAK_TOUCH  )) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_ACERERAK_TOUCH ),     HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
	if (!GetIsVestigeExploited(oBinder, VESTIGE_ACERERAK_HEALING)) SetLocalInt(oBinder, "AcererakHealing", TRUE);
     
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oBinder, HoursToSeconds(24));      
}