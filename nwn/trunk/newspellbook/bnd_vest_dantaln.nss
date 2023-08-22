/*
09/03/21 by Stratovarius

Dantalion, the Star Emperor
  
Dantalion, called the Star Emperor for his legend and appearance, is a composite of many souls. He grants binders the ability to teleport short distances, read thoughts, and stop foes.

Vestige Level: 5th
Binding DC: 25
Special Requirement: No

Influence: Dantalion’s influence causes you to be aloof and use stately gestures. Dantalion can’t help but be curious about the leaders of the day, 
so anytime you are within 100 feet of someone who clearly is (or professes to be) a leader of others, Dantalion requires that you try to read that 
person’s thoughts. Once you have made the attempt, regardless of success or failure, you need not try to read that person’s thoughts again.

Granted Abilities: 
Pact magic grimoires attest to Dantalion’s profound wisdom and his extensive knowledge about all subjects. Because he knows all thoughts, he can grant 
you a portion of that power, as well as the ability to travel just by thinking. You also gain a portion of his commanding presence, which many binders 
ascribe to his royal origins.

Awe of Dantalion: When you invoke this ability (a move action), any creature that sees you is unable to attack you or target you with a hostile spell 
for 1 round. If you attempt any hostile action, such as making an attack roll or casting an offensive spell against the affected creature or its allies, 
the effect ends. Once you have used this ability, you cannot do so again for 5 rounds.

Dantalion Knows: While bound to Dantalion, you have a +8 bonus on Lore checks.

Read Thoughts: At will as a full-round action, you can attempt to read the surface thoughts of any creature you can see. If the target makes a successful 
Will save, you cannot read its thoughts for 1 minute. If you attempt to read the thoughts of a creature with an Intelligence score 10 points higher than 
your own, you automatically fail and are stunned for 1 round.

Thought Travel: As a standard action, you can instantly transport yourself to any location you can see that is within 5 feet per effective binder level 
you possess. Thought travel is a teleportation effect and is usable a number of times per day equal to your effective binder level. Once you have used 
this ability, you cannot do so again for 5 rounds.
*/

#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = PRCGetSpellTargetObject(); 

    effect eLink = EffectLinkEffects(EffectVisualEffect(PSI_DUR_INTELLECT_FORTRESS), EffectPact(oBinder));
    
    if (!GetIsVestigeExploited(oBinder, VESTIGE_DANTALION_AWE   )) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_DANTALION_AWE   ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (!GetIsVestigeExploited(oBinder, VESTIGE_DANTALION_KNOWS )) eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_LORE, 8));
	if (!GetIsVestigeExploited(oBinder, VESTIGE_DANTALION_READ  )) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_DANTALION_READ  ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
	if (!GetIsVestigeExploited(oBinder, VESTIGE_DANTALION_TRAVEL)) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_DANTALION_TRAVEL), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
     
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oBinder, HoursToSeconds(24));      
}