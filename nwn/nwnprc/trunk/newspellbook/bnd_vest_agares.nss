/*
03/03/21 by Stratovarius

Agares, Truth Betrayed
  
Agares died at the hands of his allies for a wrong he did not commit. As a vestige, not only does he give binders the ability to weaken foes and knock them prone, but he also makes his summoner fearless.

Vestige Level: 4th
Binding DC: 22
Special Requirement: You must draw Agares’s seal upon either the earth or an expanse of unworked stone.

Influence: Agares’s loyalty in life and his anger at the betrayal perpetrated by his lieutenants has become a hatred of falsehood. When influenced
by Agares, you speak forthrightly and with confidence. You cannot use the Bluff skill, and when asked a direct question, you must answer truthfully and directly.

Granted Abilities: 
Agares gives you the power to exalt yourself and your allies, to make the earth tremble beneath your feet, and to render foes weak.

Earth and Air Mastery: You gain a +1 bonus on attack rolls and weapon damage rolls.

Earthshaking Step: As a standard action, you can stomp on the ground, causing every creature within 10 feet of you to make a Reflex save or fall prone. 
Once you have used this ability, you cannot do so again for 5 rounds. You and your summoned earth elemental (see below) are never knocked prone by the use of this ability.

Elemental Companion: You can summon an earth elemental to accompany you and fight for you. If you lose your elemental, you cannot summon it again for 1 hour. 
The size of the earth elemental you can summon depends on your effective binder level. Below 11th, small. Below 15th, medium. Below 19th, large. 19th and above, huge.

Fear Immunity: You have immunity to fear.
*/

#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = PRCGetSpellTargetObject(); 

    effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_AOE_ZONE_OF_TRUTH), EffectPact(oBinder));
    if (!GetIsVestigeExploited(oBinder, VESTIGE_AGARES_FEAR)) eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_FEAR));
    if (!GetIsVestigeExploited(oBinder, VESTIGE_AGARES_EARTH_MASTERY)) 
    {
    	eLink = EffectLinkEffects(eLink, EffectAttackIncrease(1));
    	eLink = EffectLinkEffects(eLink, EffectDamageIncrease(DAMAGE_BONUS_1, DAMAGE_TYPE_MAGICAL));
    }	
    
    // Can't lie or use bluff
    if (!GetLocalInt(oBinder, "PactQuality"+IntToString(VESTIGE_AGARES))) 
    {
    	FloatingTextStringOnCreature("You have made a poor pact, and Agares enjoins you from being untruthful!", oBinder, FALSE);    
    	eLink = EffectLinkEffects(eLink, EffectSkillDecrease(SKILL_BLUFF, 50));
    }	
    
    if (!GetIsVestigeExploited(oBinder, VESTIGE_AGARES_EARTHSHAKING)) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_AGARES_STEP), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (!GetIsVestigeExploited(oBinder, VESTIGE_AGARES_COMPANION)) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_AGARES_ELEMENTAL), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
   
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oBinder, HoursToSeconds(24));      
}