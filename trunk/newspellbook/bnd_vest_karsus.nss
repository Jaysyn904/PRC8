/*
02/03/21 by Stratovarius

Karsus, Hubris in the Blood
  
Karsus lived and died by magic, so he grants binders power over that force.

Vestige Level: 3rd
Binding DC: 25
Special Requirement: Karsus refuses to answer the call of a binder who attempts to summon him within the area of an active spell. 
In addition, he appears only to a summoner who has at least 5 ranks in either Lore or Spellcraft. He also hates Amon for some unknown
reason and will not answer your call if you are already bound to that vestige.

Influence: You take on some of the arrogance for which Karsus was famous in his mortal life. He requires that you make Bluff or 
Intimidate checks rather than Diplomacy checks to influence others.

Granted Abilities: 
In life, Karsus was obsessed with magic, and his obsession continues unabated in his current state. He grants you the ability to see magic, 
destroy it with a touch, and use any magic item with ease. He even provides increased spellcasting power.

Heavy Magic: The save DC for each effect of every magic item you use increases by 2.

Karsus’s Senses: You can cast detect magic at will.

Karsus’s Touch: You can produce a dispel magic effect with a touch. To do so, you must make a successful melee touch attack that does not 
provoke attacks of opportunity. You can then make a dispel check (1d20 + your effective binder level, maximum +20) against each ongoing 
spell currently in effect on the target. You can use Karsus’s touch a number of times per day equal to your effective binder level. 
Once you have used this ability, you cannot do so again for 5 rounds.

Karsus’s Will: You can use wands and staves as if you were a wizard.
*/

#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = PRCGetSpellTargetObject(); 

    effect eLink = EffectLinkEffects(EffectVisualEffect(PSI_DUR_DISPELLING_BUFFER), EffectPact(oBinder));
    
    // If she gets influence, you can't drink potions
    if (!GetLocalInt(oBinder, "PactQuality"+IntToString(VESTIGE_KARSUS))) 
    {
    	FloatingTextStringOnCreature("You have made a poor pact, and Karsus enjoins you from being diplomatic!", oBinder, FALSE);    
    	eLink = EffectLinkEffects(eLink, EffectSkillDecrease(SKILL_PERSUADE, 50));
    }	
    
    if (!GetIsVestigeExploited(oBinder, VESTIGE_KARSUS_SENSES_ABIL)) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_KARSUS_SENSES), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    
    // We get this with the Practiced Binder feat
    if (GetLevelByClass(CLASS_TYPE_BINDER, oBinder) || GetHasFeat(FEAT_PRACTICED_BINDER, oBinder))
    {
		// Heavy Magic is in prc_add_spell_dc
    }	
	
    // Binders only down here
    if (GetLevelByClass(CLASS_TYPE_BINDER, oBinder)) 
    {
    	if (!GetIsVestigeExploited(oBinder, VESTIGE_KARSUS_TOUCH)) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_KARSUS_TOUCH), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    	// Karsus's Will in bnd_events onacquire
    }	
    
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oBinder, HoursToSeconds(24));      
}