/*
18/03/21 by Stratovarius

Eligor, Dragon's Slayer
    
A champion both against and for evil dragons, Eligor grants martial prowess both in and out of the saddle, as well as supernatural strength.
  
Vestige Level: 7th
Binding DC: 30
Special Requirement: No
  
Influence: You feel pity for all outcasts, particularly halfelves and half-orcs, and you make every effort to befriend any such beings you meet. Because Eligor desires revenge on the deities who abandoned him, he requires that you attack a human, elf, or dragon foe in preference to all others whenever you enter combat.
  
Granted Abilities: 
In his first life, Eligor was a skilled horseman, and in his second, he served the primary deity of chromatic dragons. Thus, the powers he grants tend to reflect those associations.
 
Chromatic Strike: As a free action, you can charge a melee attack with acid, cold, electricity, or fire. Your next melee attack deals an extra 1d6 points of damage of the chosen energy type. You can charge a single melee attack only once.
 
Eligor’s Skill in the Saddle: You gain the benefits of the Mounted Combat and Mounted Archery feats.
 
Eligor’s Strength: You gain a +4 bonus to Strength.
 
Eligor’s Resilience: You gain a +3 enhancement bonus to natural armor. This bonus improves to +4 at 16th level and to +5 at 20th level.
 
Heavy Armor Proficiency: You are proficient with heavy armor.
*/

#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = PRCGetSpellTargetObject(); 
    int nBinderLevel = GetBinderLevel(oBinder, VESTIGE_ELIGOR);
    int nBonus = 3;
    if (nBinderLevel >= 20) nBonus = 5;
    else if (nBinderLevel >= 16) nBonus = 4;

    effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_PERM_ELEMENTAL_SAVANT_WATER), EffectPact(oBinder));
    if (!GetIsVestigeExploited(oBinder, VESTIGE_ELIGOR_STRIKE)) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_ELIGOR_STRIKE), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (!GetIsVestigeExploited(oBinder, VESTIGE_ELIGOR_SADDLE)) 
    {
    	IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_MOUNTED_COMBAT), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    	IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_MOUNTED_ARCHERY), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }	
    if (!GetIsVestigeExploited(oBinder, VESTIGE_ELIGOR_STRENGTH))   eLink = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_STRENGTH, 4));
    if (!GetIsVestigeExploited(oBinder, VESTIGE_ELIGOR_RESILIENCE)) eLink = EffectLinkEffects(eLink, EffectACIncrease(nBonus, AC_NATURAL_BONUS));
    if (!GetIsVestigeExploited(oBinder, VESTIGE_ELIGOR_ARMOR))      IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_ARMOR_PROF_HEAVY), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
   
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oBinder, HoursToSeconds(24));      
}