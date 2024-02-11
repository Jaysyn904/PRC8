/*
16/03/21 by Stratovarius

Desharis, the Sprawling Soul
  
The first of the "city-born fey," represented today by such creatures as the zeitgeist and the gray jester, Desharis is a boon to those who work to spread civilization, and 
anathema to most fey and worshipers of the wild. He grants binders shelter against the dangers of the wild, and he provides powers to carve out their own niche against nature.

Vestige Level: 6th
Binding DC: 27
Special Requirement: Desharis will not answer your call in a natural environment, only responding in the worked landscapes of urban areas. 

Influence: Under Desharis's influence, you cannot stand to be alone, and the more people you have around you, the better. You never voluntarily accept any 
task that requires you to be alone, and you argue vigorously against options that would split the party. If you have the opportunity to socialize with large groups of people 
(such as entering a boisterous tavern), you must take it unless doing so is overtly harmful, or you have reason to suspect the individuals are hostile to you.

Granted Abilities: 
Desharis grants abilities that reflect his desire to protect the civilized peoples of the world, plus provides a few that show his anger at the fey and other creatures of nature.

City-Dweller: While hosting Desharis, you gain a +10 ft. bonus to move speed when in urban areas. In addition, you gain a +6 competence bonus on Lore checks.

Infinite Doors: Once per day, you may teleport, as per the spell, as a caster of your binder level.

Smite Natural Soul: You may attempt to smite an animal, elemental, fey, or plant with a single melee attack. You add your Charisma bonus (if any) to the attack roll and deal 
1 extra point of damage per effective binder level. If you accidentally smite a creature that is not one of the above types, the attempt has no effect. 
Once you have used this ability, you cannot do so again for 5 rounds.

Spirits of the City: You can animate objects, as the spell, as a caster of your binder level. Once you have used this ability, you must wait 5 rounds after the effect has expired before you can do so again.
*/

#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = PRCGetSpellTargetObject(); 
    
    effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_PROT_PRC_CIRCLEROCK), EffectPact(oBinder));
    
	if (!GetIsVestigeExploited(oBinder, VESTIGE_DESHARIS_CITY_DWELLER)) eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_LORE, 6));
	if (!GetIsVestigeExploited(oBinder, VESTIGE_DESHARIS_TELEPORT))     IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_DESHARIS_TELEPORT), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
	if (!GetIsVestigeExploited(oBinder, VESTIGE_DESHARIS_SMITE))        IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_DESHARIS_SMITE),    HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
	if (!GetIsVestigeExploited(oBinder, VESTIGE_DESHARIS_ANIMATE))   	IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_DESHARIS_ANIMATE),  HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
	
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oBinder, HoursToSeconds(24));      
}