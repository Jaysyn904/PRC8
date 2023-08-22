/*
14/03/21 by Stratovarius

Haures, the Dreaming Duke
  
Haures grants his summoners the power to create illusions, protect their thoughts, and move through objects like a ghost.

Vestige Level: 6th
Binding DC: 25
Special Requirement: No

Influence: When influenced by Haures, you become an eccentric, often speaking to yourself and to imaginary friends. In addition, Haures requires that if you 
encounter and disbelieve an illusion not of your own making, you must not voluntarily enter its area.

Granted Abilities: 
Haures shields your mind with his madness, allows you to move like a ghost, gives you the power to fool the senses, and grants you the ability to kill others with their deepest fears.

Inaccessible Mind: You are protected from any effort to detect, influence, or read your emotions or thoughts, and you have immunity to any mind-affecting spells and abilities.

Incorporeal Movement: When moving, you become nearly incorporeal and can ignore the effects of difficult terrain. You can even move through an enemy’s space, but not through walls or other solid barriers. 

Major Image: You can create an illusion at will, as though you had cast mislead (caster level equals your effective binder level). Once you have used this ability, you cannot do so again for 5 rounds.

Phantasmal Killer: This ability functions like the phantasmal killer spell. Once you have used this ability, you cannot do so again for 5 rounds.
*/

#include "bnd_inc_bndfunc"
#include "prc_inc_natweap"

void main()
{
    object oBinder = PRCGetSpellTargetObject(); 

    effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_RAINBOW_PATTERN), EffectPact(oBinder));
    
    if (!GetIsVestigeExploited(oBinder, VESTIGE_HAURES_MIND))   eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS));  
    if (!GetIsVestigeExploited(oBinder, VESTIGE_HAURES_MOVE))  
    {
    	eLink = EffectLinkEffects(eLink, EffectCutsceneGhost());
    	eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE));
    }	
	if (!GetIsVestigeExploited(oBinder, VESTIGE_HAURES_IMAGE))  IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_HAURES_IMAGE ),   HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
	if (!GetIsVestigeExploited(oBinder, VESTIGE_HAURES_KILLER)) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_HAURES_KILLER),   HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
	    
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oBinder, HoursToSeconds(24));      
}