/*
15/03/21 by Stratovarius

The Triad
  
The Triad is a gestalt of three forgotten gods of a lost civilization of mystics, consumed by the Plane of Shadow. They give binders access to both martial abilities and lore-seeking traits.

Vestige Level: 6th
Binding DC: 26
Special Requirement: The Triad will not bind with someone with any connection to the Plane of Shadow, whether that's by feat, class abilities, or any other association.

Influence: Your mental aspect shifts to match the face that is currently your sign. As Gorn, you are inquisitive and use many words -- some would say too many. As Rujsha, you are caring and motherly, speaking to others as if they were children. As Mintar, you are honor-bound and slightly combative in manner. When your path crosses that of one influenced by shadow, the gestalt insists that you either face that being first when in combat or avoid that being (and any effects or assistance the being may wish to provide) outside of combat.

Granted Abilities: 
While bound to the Triad, you gain a range of abilities that represents the essence of their former separate beings.

Psionic Boon: You gain 15 power points when you bind to the Triad. These are added to your pool of power if you already possess psionic power, or they create a pool and you become a psionic creature for the duration of this binding.

Gorn's Knowledge

Call to Mind: You gain access to the psionic power call to mind for the duration of the binding.

Psicraft Bonus: You gain a +5 bonus on Psicraft checks.

Bardic Knowledge: You gain a bonus to Lore equal to your binder level.

Rujsha's Justice

Empathy: You gain access to the psionic power empathy for the duration of the binding. 

Diplomacy Bonus: You gain a +5 bonus on Persuade checks.

Smite Evil: Three times per day, you can attempt to smite an evil creature with a single melee attack. You add your Charisma bonus (if any) to the attack roll and deal 1 extra point of damage per effective binder level. If you accidentally smite a creature that is not evil, the attempt has no effect. Once you have used this ability, you cannot do so again for 5 rounds.

Mintar's Honor

Detect Hostile Intent: You gain access to the psionic power mental disruption for the duration of the binding.

Sense Motive Bonus: You gain a +5 bonus on Sense Motive checks.

Weapon Proficiency: You gain proficiency in all simple, martial, and exotic weapons.
*/

#include "bnd_inc_bndfunc"
#include "psi_inc_psifunc"

void main()
{
    object oBinder = PRCGetSpellTargetObject(); 
	int nBinderLevel = GetBinderLevel(oBinder, VESTIGE_THETRIAD);
	SetLocalInt(oBinder, "TheTriadPsion", nBinderLevel);
    effect eLink = EffectLinkEffects(EffectVisualEffect(PSI_DUR_TIMELESS_BODY), EffectPact(oBinder));
    
    if (!GetIsVestigeExploited(oBinder, VESTIGE_THE_TRIAD_PSIONIC_BOON)) 
    {
    	GainPowerPoints(oBinder, 15, TRUE);
    	IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_PSIONIC_FOCUS),    HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    }	
	if (!GetIsVestigeExploited(oBinder, VESTIGE_THE_TRIAD_GORN  )) 
	{
		// Call to mind
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(12055),      HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
		eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_PSICRAFT, 5)); 
		eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_LORE, nBinderLevel)); 
	}	
	if (!GetIsVestigeExploited(oBinder, VESTIGE_THE_TRIAD_RUJSHA          )) 
	{
		// Empathy
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(12072),    HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    	eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_PERSUADE, 5)); 	
    	IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_THE_TRIAD_SMITE),    HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
	}
	if (!GetIsVestigeExploited(oBinder, VESTIGE_THE_TRIAD_MINTAR   )) 
	{
		// Psion Mental Disruption
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(12127),    HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
		eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_SENSE_MOTIVE, 5)); 
		
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROFICIENCY_SHORTSWORD      ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROFICIENCY_LONGSWORD       ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROFICIENCY_BATTLEAXE       ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROFICIENCY_BASTARD_SWORD   ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROFICIENCY_LIGHT_FLAIL     ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROFICIENCY_WARHAMMER       ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROFICIENCY_LONGBOW         ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROFICIENCY_LIGHT_MACE      ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROFICIENCY_HALBERD         ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROFICIENCY_SHORTBOW        ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROFICIENCY_TWO_BLADED_SWORD), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROFICIENCY_GREATSWORD      ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROFICIENCY_GREATAXE        ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROFICIENCY_DART            ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROFICIENCY_DIRE_MACE       ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROFICIENCY_DOUBLE_AXE      ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROFICIENCY_HEAVY_FLAIL     ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROFICIENCY_LIGHT_HAMMER    ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROFICIENCY_HANDAXE         ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROFICIENCY_KAMA            ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROFICIENCY_KATANA          ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROFICIENCY_KUKRI           ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROFICIENCY_MORNINGSTAR     ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROFICIENCY_RAPIER          ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROFICIENCY_SCIMITAR        ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROFICIENCY_SCYTHE          ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROFICIENCY_SHORTSPEAR      ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROFICIENCY_SHURIKEN        ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROFICIENCY_SICKLE          ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROFICIENCY_SLING           ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROFICIENCY_THROWING_AXE    ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROFICIENCY_TRIDENT         ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROFICIENCY_DWARVEN_WARAXE  ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROFICIENCY_WHIP            ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROFICIENCY_ELVEN_LIGHTBLADE), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROFICIENCY_ELVEN_THINBLADE ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);    
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROFICIENCY_ELVEN_COURTBLADE), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING); 
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROF_MARTIAL), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING); 
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROF_SIMPLE), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING); 		
		IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROF_EXOTIC), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING); 		
	}	
    
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oBinder, HoursToSeconds(24));     
}