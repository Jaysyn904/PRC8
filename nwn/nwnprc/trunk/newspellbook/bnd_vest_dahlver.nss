/*
1/03/21 by Stratovarius

Dahlver Nar, the Tortured One
  
Once a human binder, Dahlver-Nar now grants powers just as other vestiges do. He gives his summoners tough skin, a frightening moan, protections against madness, 
and the ability to share injuries with allies.

Vestige Level: 2nd
Binding DC: 17
Special Requirement: None

Influence: You shift quickly from distraction to extreme focus and back again. Sometimes you stare blankly off into space, and at other times you gaze intently at the 
person or task at hand. Since Dahlver-Nar dislikes any task that requires more than 1 round of concentration (such as some spellcasting, concentration on an effect, 
or any action that requires a Concentration check), he requires that you undertake no such activities while under his influence.

Granted Abilities: 
Dahlver-Nar armors you and blends his madness with your sanity, lending you some of his selfish powers.

Mad Soul: Binding to Dahlver-Nar grants you immunity to Wisdom damage, Wisdom drain, and confusion effects.

Maddening Moan: You can emit a frightful moan as a standard action. Every creature within a 30-foot spread must succeed on a Will save or be dazed for 1 round. 
Once you have used this ability, you cannot do so again for 5 rounds. Maddening moan is a mind-affecting sonic ability.

Natural Armor: You gain an enhancement bonus to your natural armor equal to one-half your Constitution bonus (if any).

Shield Self: At will as a standard action, you can designate one creature within 10 feet per effective binder level to share the damage you take. As long as the 
subject creature remains within range, you take only half damage from all effects that deal hit point damage, and it takes the rest. The effect ends immediately 
if you designate another creature or if either you or the subject dies. Any damage dealt to you after the effect ends is no longer split between you and the subject,
but damage already split is not reassigned to you. You can affect one creature at a time with this ability. An unwilling target of this ability 
can attempt a Will save to negate the effect.
*/

#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = PRCGetSpellTargetObject(); 

    effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_BLOOD_FOUNTAIN), EffectPact(oBinder));
    
    // If he gets influence, you can't concentrate
    if (!GetLocalInt(oBinder, "PactQuality"+IntToString(VESTIGE_DAHLVERNAR))) FloatingTextStringOnCreature("You have made a poor pact, and Dahlver Nar enjoins you from using concentration abilities!", oBinder, FALSE);    
    
    // Mad Soul is in prc_inc_damage and prc_effect_inc
    
    // We get this with the Practiced Binder feat
    if (GetLevelByClass(CLASS_TYPE_BINDER, oBinder) || GetHasFeat(FEAT_PRACTICED_BINDER, oBinder))
    {
		if (!GetIsVestigeExploited(oBinder, VESTIGE_DAHLVERNAR_NATURAL_ARMOR)) eLink = EffectLinkEffects(eLink, EffectACIncrease(GetAbilityModifier(ABILITY_CONSTITUTION, oBinder)/2, AC_NATURAL_BONUS));
    }	
	
    // Binders only down here
    if (GetLevelByClass(CLASS_TYPE_BINDER, oBinder)) 
    {
    	if (!GetIsVestigeExploited(oBinder, VESTIGE_DAHLVERNAR_MADDENING_MOAN)) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_DAHLVER_MOAN), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    	if (!GetIsVestigeExploited(oBinder, VESTIGE_DAHLVERNAR_SHIELD_SELF)) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_DAHLVER_SHARE), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }	
    
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oBinder, HoursToSeconds(24));      
}