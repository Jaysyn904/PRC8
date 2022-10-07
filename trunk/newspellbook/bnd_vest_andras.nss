/*
03/03/21 by Stratovarius

Andras, the Gray Knight
  
A great warrior in life, Andras is an enigma as a vestige. He gives binders prowess in combat and skill in the saddle.

Vestige Level: 4th
Binding DC: 22
Special Requirement: No.

Influence: Andras’s influence causes you to become listless and emotionally remote. Because Andras wearies of combat quickly, you become exhausted after only 10 rounds of battle, and flee from the fight for 1d4 rounds. 

Granted Abilities: 
Andras lends you some of the skills he had in life, making you a strong combatant with or without a mount.

Weapon Proficiency: You are proficient with the greatsword, longsword, and rapier.

Mount: As a full-round action, you can summon a heavy warhorse. You can use this ability once per day.

Saddle Sure: You gain a +8 bonus on Ride checks.

Smite Good or Evil: You can attempt to smite an evil or good creature with a single melee attack. You add your Charisma bonus (if any) to the attack roll and deal 1 extra point of damage per effective binder level. Once you have used this ability, you cannot do so again for 5 rounds.

Sow Discord: Andras grants you the ability to sow discord among your enemies. As a standard action, you can force an enemy to attack a randomly determined ally within reach on his next action. Sow discord is a mind-affecting compulsion ability. Once you have used this ability, you cannot do so again for 5 rounds.

Sure Blows: You gain the benefit of the Improved Critical feat with any weapon you wield.
*/

#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = PRCGetSpellTargetObject(); 

    effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_SHIELD_OF_LAW), EffectPact(oBinder));
    if (!GetIsVestigeExploited(oBinder, VESTIGE_ANDRAS_SADDLE_SURE)) eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_RIDE, 8));
	if (!GetIsVestigeExploited(oBinder, VESTIGE_ANDRAS_WEAPON_PROF))
	{
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROFICIENCY_LONGSWORD), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROFICIENCY_GREATSWORD), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROFICIENCY_RAPIER), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
	}
	if (!GetIsVestigeExploited(oBinder, VESTIGE_ANDRAS_SURE_BLOWS))
	{
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_DAGGER          ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_DART            ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_HEAVY_CROSSBOW  ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_LIGHT_CROSSBOW  ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_LIGHT_MACE      ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_MORNING_STAR    ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_STAFF           ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_SPEAR           ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_SICKLE          ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_SLING           ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_LONGBOW         ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_SHORTBOW        ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_SHORT_SWORD     ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_RAPIER          ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_SCIMITAR        ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_LONG_SWORD      ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_GREAT_SWORD     ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_HAND_AXE        ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_THROWING_AXE    ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_BATTLE_AXE      ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_GREAT_AXE       ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_HALBERD         ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_LIGHT_HAMMER    ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_LIGHT_FLAIL     ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_WAR_HAMMER      ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_HEAVY_FLAIL     ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_KAMA            ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_KUKRI           ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_SHURIKEN        ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_SCYTHE          ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_KATANA          ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_BASTARD_SWORD   ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_DIRE_MACE       ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_DOUBLE_AXE      ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_TWO_BLADED_SWORD), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_CLUB            ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_DWAXE           ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING); 
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_WHIP            ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING); 
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_MINDBLADE       ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING); 
	}	
    
    if (!GetLocalInt(oBinder, "PactQuality"+IntToString(VESTIGE_ANDRAS))) FloatingTextStringOnCreature("You have made a poor pact, and Andras tires of combat easily!", oBinder, FALSE);    
	
    if (!GetIsVestigeExploited(oBinder, VESTIGE_ANDRAS_SMITE)) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_ANDRAS_SMITE), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (!GetIsVestigeExploited(oBinder, VESTIGE_ANDRAS_DISCORD)) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_ANDRAS_DISCORD), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (!GetIsVestigeExploited(oBinder, VESTIGE_ANDRAS_MOUNT)) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_ANDRAS_MOUNT), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
   
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oBinder, HoursToSeconds(24));      
}