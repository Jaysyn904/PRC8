/*
13/03/21 by Stratovarius

Astaroth, Unjustly Fallen
  
A fallen angel who would never accept responsibility for his own transgressions, Astaroth grants his summoners influence over the behavior of others, knowledge of hidden things, and the ability to sicken enemies.

Vestige Level: 4th
Binding DC: 22
Special Requirement: No

Influence: Astaroth's influence renders you incapable of taking responsibility for your own actions. You cannot admit any fault, acknowledge any mistake, or make reparations or apologies for any wrong, no matter the consequences or the evidence against you.

Granted Abilities: 
Astaroth guided mortals, and he still grants abilities based in knowledge and education. As a fallen angel, and then a vestige, his magics have grown ever grimmer and more distasteful; he also grants powers based on directly controlling and offending others.

Angelic Lore: Astaroth constantly whispers the secrets of reality in the back of your mind, allowing you to draw on his own nigh-infinite knowledge. This grants a bonus to Lore equal to your effective binder level.

Astaroth's Breath: Once every 5 rounds, you can exhale a 60-foot cone of foul-smelling gas. Creatures within the cone must make a Fortitude save or be nauseated for 1 round and sickened for an additional 1d4 rounds. Those who make the save are merely sickened for 1 round. Creatures immune to poison or disease are immune to this effect.

Honeyed Tongue: You gain a +4 competence bonus on Bluff, Persuade, and Intimidate checks.

Master Craftsman: While bound to Astaroth, you gain a +4 competence bonus on all Craft checks. In addition, each time you bind with Astaroth, you may select one item creation feat as a temporary bonus feat. So long as you continue to bind with Astaroth, you may use that feat as though you possessed it normally; you must still spend all standard gold and XP for any item you create, and you must still provide all necessary spells for a given item. If your effective binder level is not at least as high as the necessary caster level to take a specific item creation feat, you cannot choose that feat. For instance, a 4th-level binder could not choose any item creation feat with a prerequisite of caster level 5th or higher.

Word of Astaroth: You may charm a single creature with your glowing words. You must wait 5 rounds before making another attempt.
*/

#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = PRCGetSpellTargetObject(); 
	int nBinderLevel = GetBinderLevel(oBinder, VESTIGE_ASTAROTH);
	
    effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_SYMB_PERS), EffectPact(oBinder));
    
    if (!GetIsVestigeExploited(oBinder, VESTIGE_ASTAROTH_LORE))   eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_LORE, nBinderLevel));
	if (!GetIsVestigeExploited(oBinder, VESTIGE_ASTAROTH_BREATH)) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_ASTAROTH_BREATH), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
	if (!GetIsVestigeExploited(oBinder, VESTIGE_ASTAROTH_TONGUE)) 
	{
    	eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_BLUFF, 4)); 	
    	eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_PERSUADE, 4)); 	
    	eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_INTIMIDATE, 4)); 	
	}
	if (!GetIsVestigeExploited(oBinder, VESTIGE_ASTAROTH_CRAFT)) 
	{
        eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_CRAFT_WEAPON, 4));
        eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_CRAFT_TRAP, 4));
        eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_CRAFT_ARMOR, 4));
        eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_CRAFT_GENERAL, 4));
        eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_CRAFT_ALCHEMY, 4));
        eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_CRAFT_POISON, 4));
	}	
    if (!GetIsVestigeExploited(oBinder, VESTIGE_ASTAROTH_WORD)) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_ASTAROTH_WORD), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oBinder, HoursToSeconds(24));     
}