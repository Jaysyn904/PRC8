/*
02/03/21 by Stratovarius

Andromalius, the Repentant Rogue
  
Once the favorite of the god Olidammara, Andromalius now exists as a vestige. His granted abilities help his summoners beat rogues and ne’er-do-wells at their own game.

Vestige Level: 3rd
Binding DC: 20
Special Requirement: No

Influence: When influenced by Andromalius, you become a devious mischief-maker who delights in causing small calamities—especially misunderstandings between 
friends and incidents of mistaken identity. However, Andromalius cannot now abide acts of theft, so he forbids you to steal from a creature, take an item 
from a dead body, or remove someone else’s possession from a location without permission so long as you are under the jurisdiction of an authority whose 
laws expressly forbid such activities. By the same logic, you cannot take possession of any object that you know to be stolen.

Granted Abilities: 
The abilities that Andromalius grants help you catch thieves and return stolen goods, discover wickedness and underhanded dealings, and punish wrongdoers. 

Jester’s Mirth: As a standard action, you can cause an opponent to break into uncontrollable laughter. This ability functions like a Tasha’s hideous 
laughter spell (caster level equals your effective binder level). 

Locate Item: At will, you can cast locate object.

See the Unseen: At will, you can use see invisibility as the spell (caster level equals your effective binder level).

Sense Trickery: You gain a +4 bonus on Sense Motive checks, on Appraise checks, and on Spot checks.

Sneak Attack: You deal an extra 2d6 points of damage when flanking an opponent or at any time when the target would be denied its Dexterity bonus. 
For every five effective binder levels you possess beyond 5th, your sneak attack damage increases by an additional 1d6 points.
*/

#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = PRCGetSpellTargetObject();
    int nBinderLevel = GetBinderLevel(oBinder, VESTIGE_ANDROMALIUS);

    effect eLink = EffectLinkEffects(EffectVisualEffect(PSI_DUR_SYNESTHETE), EffectPact(oBinder));
    if (!GetIsVestigeExploited(oBinder, VESTIGE_ANDROMALIUS_SENSE))
    {
		eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_APPRAISE, 4));    
		eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_SPOT, 4));
		eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_SENSE_MOTIVE, 4));
	}	
    
    // We get this with the Practiced Binder feat
    if (GetLevelByClass(CLASS_TYPE_BINDER, oBinder) || GetHasFeat(FEAT_PRACTICED_BINDER, oBinder))
    {
		if (!GetIsVestigeExploited(oBinder, VESTIGE_ANDROMALIUS_SEE)) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_ANDRO_SEE), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }	
	
    // Binders only down here
    if (GetLevelByClass(CLASS_TYPE_BINDER, oBinder)) 
    {
    	if (!GetIsVestigeExploited(oBinder, VESTIGE_ANDROMALIUS_LOCATE)) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_ANDRO_LOCATE), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    	if (!GetIsVestigeExploited(oBinder, VESTIGE_ANDROMALIUS_JESTER)) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_ANDRO_MIRTH), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    	if (!GetIsVestigeExploited(oBinder, VESTIGE_ANDROMALIUS_SNEAK))
    	{
    		SetLocalInt(oBinder, "AndroSneak", 2+((nBinderLevel-5)/5));
    		DelayCommand(0.1, ExecuteScript("prc_sneak_att", oBinder));    	
    	}	
    }	
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oBinder, HoursToSeconds(24));      
}