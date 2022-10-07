/*
1/03/21 by Stratovarius

Malphas, the Turnfeather
  
Malphas allows his summoners to see without being seen, to pass through surroundings without leaving any sign, to vanish from sight, and to poison their enemies.

Vestige Level: 2nd
Binding DC: 15
Special Requirement: No

Influence: While influenced by Malphas, you fall in love too easily. A kind word or a friendly gesture can cause you to devote yourself entirely to another person. 
Should that person reject your affection, your broken heart mends the moment another attractive person shows you some kindness. In addition, if you have access to 
poison, Malphas requires that you employ it against your foes at every opportunity.

Granted Abilities: 
Malphas grants you the ability to spy without detection, to disappear, to use poison safely, and to strike vicious blows against vulnerable foes.

Arcane Eye: At will, you can cast Arcane Eye as a wizard of your effective binder level.

Invisibility: As a standard action, you can make yourself invisible. Making an attack ends the invisibility (as normal), but otherwise, the effect lasts a number of rounds equal to your effective
binder level. You can invoke this ability as a swift action at 15th level. Once you return to visibility, you cannot use this ability again for 5 rounds.

Poison Use: You are not at risk of poisoning yourself when handling poison or applying it to a weapon.

Sneak Attack: You deal an extra 1d6 points of damage plus 1d6 points per four effective binder levels.
*/

#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = PRCGetSpellTargetObject(); 
    int nBinderLevel = GetBinderLevel(oBinder, VESTIGE_MALPHAS);

    effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_SHADOWS_ANTILIGHT), EffectPact(oBinder));
    if (!GetIsVestigeExploited(oBinder, VESTIGE_MALPHAS_POISON_USE)) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_USE_POISON), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    
    // We get this with the Practiced Binder feat
    if (GetLevelByClass(CLASS_TYPE_BINDER, oBinder) || GetHasFeat(FEAT_PRACTICED_BINDER, oBinder))
    {
		if (!GetIsVestigeExploited(oBinder, VESTIGE_MALPHAS_ARCANE_EYE)) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_MALPHAS_EYE), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }	
	
    // Binders only down here
    if (GetLevelByClass(CLASS_TYPE_BINDER, oBinder)) 
    {
    	if (!GetIsVestigeExploited(oBinder, VESTIGE_MALPHAS_INVIS)) 
    	{
    		if (nBinderLevel >= 15) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_MALPHAS_INVIS_SW), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    		else                    IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_MALPHAS_INVIS_ST), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    	}
    	if (!GetIsVestigeExploited(oBinder, VESTIGE_MALPHAS_SNEAK_ATTACK)) 
    	{
    		SetLocalInt(oBinder, "MalphasSneak", 1+(nBinderLevel/4));
    		DelayCommand(0.1, ExecuteScript("prc_sneak_att", oBinder));
    	}	
    }	
    
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oBinder, HoursToSeconds(24));      
}