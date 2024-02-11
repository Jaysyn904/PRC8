/*
25/03/21 by Stratovarius

Halphax, the Angel in the Angle
    
Gnomes rarely earn a reputation for their military might, but Halphax is one of the few exceptions to that rule. He grants his summoners the ability to defend a fortress and imprison foes, as well as the hardness of stone.
  
Vestige Level: 8th
Binding DC: 32
Special Requirement: Halphax’s sign must be drawn inside a building.
  
Influence: In his time as a vestige, Halphax seems to have lost all memory of his life as well as any feeling of guilt or shame for his actions. Thus, when you are under his influence, 
you lose any normal sense of shame or embarrassment. However, if someone threatens a hostage you care about—be it a creature or an item—Halphax requires that you accede to the hostage taker’s demands.
  
Granted Abilities: 
Halphax grants you great knowledge of mechanical arts as well as the power to imprison foes, build defenses, and gird your body with the hardness of stone.

Damage Reduction: You gain damage reduction 10/+5. 

Halphax’s Knowledge: You gain a +16 bonus on Lore checks.

Imprison: As a standard action, you can make a melee touch attack to imprison your target. If you hit, the target must make a Fortitude saving throw or be imprisoned. 
This ability functions like the imprisonment spell, except that the imprisonment lasts for a number of rounds equal to your effective binder level. If a target makes 
its save, you must wait 1d4 rounds before using the ability again. You cannot imprison a creature while you already have another imprisoned from the use of this ability.

Iron Defenses: As a standard action, you can cause a series of gnashing defenses to spring into place. This functions as a blade barrier spell. Once you have used this ability, you cannot do so again for 5 rounds.

Secure Shelter: At will as a standard action, you can cast Mordenkainen's Magnificient Mansion.
*/

#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = PRCGetSpellTargetObject(); 
	
    effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_STONE5), EffectPact(oBinder));
           eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_PROT_PRC_STONESKIN));
    
    if (!GetIsVestigeExploited(oBinder, VESTIGE_HALPHAX_DR))        eLink = EffectLinkEffects(eLink, EffectDamageReduction(10, DAMAGE_POWER_PLUS_FIVE));
    if (!GetIsVestigeExploited(oBinder, VESTIGE_HALPHAX_KNOWLEDGE)) eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_LORE, 16));
	if (!GetIsVestigeExploited(oBinder, VESTIGE_HALPHAX_IMPRISON))  IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_HALPHAX_IMPRISON), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (!GetIsVestigeExploited(oBinder, VESTIGE_HALPHAX_BARRIER))   IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_HALPHAX_BARRIER ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (!GetIsVestigeExploited(oBinder, VESTIGE_HALPHAX_SHELTER))   IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_HALPHAX_SHELTER ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);  
   
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oBinder, HoursToSeconds(24));      
}