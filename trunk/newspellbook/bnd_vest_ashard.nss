/*
24/03/21 by Stratovarius

Ashardalon, Pyre of the Unborn
    
A seeker of pure power and wealth, the fiendish red dragon Ashardalon was among the toughest creatures of his era. Having escaped death more than once, he grants binders some of his 
powers as a dragon and fiend, as well as a portion of his great resilience.
  
Vestige Level: 8th
Binding DC: 35
Special Requirement: No
  
Influence: You greatly hunger for vengeance against those who harm or slight you. Ashardalon requires you to accept any opportunity to strike a foe who damages or insults you in preference over any other target. 
  
Granted Abilities: 
Ashardalon grants you some of the vast power he collected during his life as a dragon and a fiendish creature.

Ashardalon's Creed: You gain a bonus on Appraise checks and Search checks equal to your binder level. You can also locate objects near you, as the spell locate object at will.

Ashardalon's Presence: You can strike fear into the hearts of your foes. This acts as the fear spell. Once you have used this ability, you cannot use it again for 5 rounds.

Ashardalon's Vigor: Ashardalon grants you some of the vast resilience he enjoyed in life. When you bind this vestige, you gain temporary hit points equal to twice your binder level. 
These temporary hit points last for up to 24 hours.

Fiend's Heart: You share some of the defensive benefits of the balor once bound to Ashardalon's body. This effect grants you damage reduction 10/+3 and resistance to fire 30.
*/

#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = PRCGetSpellTargetObject(); 
	int nBinderLevel = GetBinderLevel(oBinder, VESTIGE_ASHARDALON);
    effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_PROTECTION_ENERGY_FIRE), EffectPact(oBinder));
    if (!GetIsVestigeExploited(oBinder, VESTIGE_ASHARDALON_CREED)) 
    {
    	eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_APPRAISE, nBinderLevel));
    	eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_SEARCH, nBinderLevel));
    	IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_ASHARDALON_LOCATE), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }    
	if (!GetIsVestigeExploited(oBinder, VESTIGE_ASHARDALON_PRESENCE)) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_ASHARDALON_PRESENCE), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (!GetIsVestigeExploited(oBinder, VESTIGE_ASHARDALON_VIGOR)) ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectTemporaryHitpoints(nBinderLevel*2)), oBinder, HoursToSeconds(24));      
    if (!GetIsVestigeExploited(oBinder, VESTIGE_ASHARDALON_HEART))   
    {
    	eLink = EffectLinkEffects(eLink, EffectDamageReduction(10, DAMAGE_POWER_PLUS_THREE));
    	eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_FIRE, 30));
    }	
   
    eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_PRISMATIC_SPHERE));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oBinder, HoursToSeconds(24));      
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DRAGONBLAST), oBinder);
}