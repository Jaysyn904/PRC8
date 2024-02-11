/*
28/02/21 by Stratovarius

Ronove, the Iron Maiden
  
Ronove remained a mystery for ages, but binder scholars now believe her to have been a human ascetic who lived more than two thousand years ago. As a vestige, she 
grants her summoners the power to move objects at a distance, to strike with the skill of a monk, and to run like the wind.

Vestige Level: 1st
Binding DC: 15
Special Requirement: Ronove’s seal must be drawn in the soil under the open sky.

Influence: Ronove’s influence makes you think that others doubt your abilities and competence. Despite what anyone says, you feel the constant need to prove your worth. 
In addition, Ronove requires that you consume neither food nor beverages (including potions) for the entire time you remain bound to her.

Granted Abilities: 
Ronove gives you the power to strike like iron, lift objects without touching them, and run like the wind.

Cold Iron and Magic Attacks: Your melee attacks count as +1 for the purpose of overcoming damage reduction. When you attain an effective binder level of 7th, your melee attacks also 
count as +3 for the purpose of overcoming damage reduction.

Far Hand: As a swift action, you can lift and move an unattended object as per the Far Hand psionic power. Alternatively, you can use the telekinetic force to
push a creature as a standard action. The force deals 1d6 points of damage to the target and initiates a bull rush, using the force’s Strength modifier and adding a +2 bonus. 
Once you have used your far hand in this way, you cannot use it again for 5 rounds. The force is considered Medium in size, and it has a Strength score equal to your effective binder level.

Ronove’s Fists: You gain the benefit of the Improved Unarmed Strike feat. Your unarmed strikes deal damage as those of a monk of a level equal to your effective binder level. 
This ability does not grant you any other abilities of a monk, such as flurry of blows.

Sprint: You gain a +10-foot enhancement bonus to your base land speed.
*/

#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = PRCGetSpellTargetObject(); 

    effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_PROT_IRON_SKIN), EffectPact(oBinder));
    
    // If she gets influence, you can't drink potions
    if (!GetLocalInt(oBinder, "PactQuality"+IntToString(VESTIGE_RONOVE))) FloatingTextStringOnCreature("You have made a poor pact, and Ronove enjoins you from drinking potions!", oBinder, FALSE);    
    
    // Cold Iron and Magic Attacks is in bnd_events
    
    // We get this with the Practiced Binder feat
    if (GetLevelByClass(CLASS_TYPE_BINDER, oBinder) || GetHasFeat(FEAT_PRACTICED_BINDER, oBinder))
    {
		// Done in prc_speed
		DelayCommand(0.25, ExecuteScript("prc_speed", oBinder));
    }	
	
    // Binders only down here
    if (GetLevelByClass(CLASS_TYPE_BINDER, oBinder)) 
    {
    	if (!GetIsVestigeExploited(oBinder, VESTIGE_RONOVE_FAR_HAND))
    	{
    		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_RONOVE_FARHAND), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_RONOVE_BULLRUSH), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    	}	
		if (!GetIsVestigeExploited(oBinder, VESTIGE_RONOVE_FISTS))
		{
			SetLocalInt(oBinder, "RonovesFists", GetBinderLevel(oBinder, VESTIGE_RONOVE));   	
			IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_UNARMED_STRIKE), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
		}
    }	
    
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oBinder, HoursToSeconds(24));      
}