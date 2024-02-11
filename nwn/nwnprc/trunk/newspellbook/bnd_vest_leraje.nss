/*
03/02/21 by Stratovarius

Leraje, the Green Herald
  
Once a favored servant of the primary deity of the elves, Leraje allowed her pride to become her downfall. 
Leraje gives her summoners the ability to bring a bow to hand at will, to fire it with accuracy, and to 
damage a foe’s sense of self with it. In addition, she gives her hosts keen vision in darkness and skill at hiding.

Vestige Level: 1st
Binding DC: 15
Special Requirement: Leraje hates Amon for some unknown reason and will not answer your call if you are already bound to him.

Influence: While influenced by Leraje, she requires that you not attack any elf or creature of elven blood, including half-elves and members of the various elf subraces, such as drow.

Granted Abilities: 
You gain supernatural powers related to Leraje’s skills in life, as well as the ability to fire arrows that literally wound your target’s pride.

Hide Bonus: You gain a +4 competence bonus on Hide checks.

Low-Light Vision: You gain low-light vision. 

Point Blank Shot: You gain the benefit of the Point Blank Shot feat.

Ricochet: As a standard action, you can make a ranged attack against two adjacent targets. 

Weapon Proficiency: While bound to Leraje, you are proficient with the longbow and shortbow. If you were already proficient 
with any of these weapons, you instead gain a +1 competence bonus on attack rolls with them.
*/

#include "bnd_inc_bndfunc"
#include "prc_inc_wpnrest"

void main()
{
    object oBinder = PRCGetSpellTargetObject(); 

    effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_MARK_OF_THE_HUNTER), EffectPact(oBinder));
    if (!GetIsVestigeExploited(oBinder, VESTIGE_LERAJE_HIDE_BONUS)) eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_HIDE, 4));
    
    // If she gets influence, you can't hurt an elf
    if (!GetLocalInt(oBinder, "PactQuality"+IntToString(VESTIGE_LERAJE)))
    {
    	FloatingTextStringOnCreature("You have made a poor pact, and Leraje enjoins you not to harm those of elven blood!", oBinder, FALSE);
        eLink = EffectLinkEffects(eLink, VersusRacialTypeEffect(EffectAttackDecrease(50), RACIAL_TYPE_ELF));
        eLink = EffectLinkEffects(eLink, VersusRacialTypeEffect(EffectDamageDecrease(50,DAMAGE_TYPE_BLUDGEONING|DAMAGE_TYPE_PIERCING|DAMAGE_TYPE_SLASHING), RACIAL_TYPE_ELF));
        eLink = EffectLinkEffects(eLink, VersusRacialTypeEffect(EffectAttackDecrease(50), RACIAL_TYPE_HALFELF));
    	eLink = EffectLinkEffects(eLink, VersusRacialTypeEffect(EffectDamageDecrease(50,DAMAGE_TYPE_BLUDGEONING|DAMAGE_TYPE_PIERCING|DAMAGE_TYPE_SLASHING), RACIAL_TYPE_HALFELF));           
    }       
    
    // We get this with the Practiced Binder feat
    if (GetLevelByClass(CLASS_TYPE_BINDER, oBinder) || GetHasFeat(FEAT_PRACTICED_BINDER, oBinder))
    {
    	if (!GetIsVestigeExploited(oBinder, VESTIGE_LERAJE_WEAPON_PROF)) 
    	{
			if (IsProficient(oBinder, BASE_ITEM_LONGBOW))
				EffectLinkEffects(eLink, EffectAttackIncrease(1));
			else 
			{
				// For some reason these don't have constants. Longbow first, Shortbow second
				IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(4607), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
				IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(4610), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
			}	
		}	
    }	
    // Binders only down here
    if (GetLevelByClass(CLASS_TYPE_BINDER, oBinder)) 
    {
    	if (!GetIsVestigeExploited(oBinder, VESTIGE_LERAJE_RICOCHET)) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_LERAJE_RICOCHET), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    	if (!GetIsVestigeExploited(oBinder, VESTIGE_LERAJE_PBSHOT)) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_POINTBLANK), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    	if (!GetIsVestigeExploited(oBinder, VESTIGE_LERAJE_LOW_LIGHT_VISION)) EffectLinkEffects(eLink, EffectUltravision());
    }	
    
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oBinder, HoursToSeconds(24));  
}