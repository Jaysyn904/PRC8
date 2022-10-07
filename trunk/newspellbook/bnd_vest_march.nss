/*
18/03/21 by Stratovarius

Marchosias, King of Killers
    
A legendary assassin in life, Marchosias now grants his summoners his supernatural charm, plus the ability to kill or paralyze with one startling attack and to disappear in a puff of smoke.
  
Vestige Level: 7th
Binding DC: 30
Special Requirement: No
  
Influence: Marchosias’s influence makes you debonair and sly, as though you have some trick up your sleeve and the knowledge of it makes you confident. 
In addition, Marchosias requires that you use the death attack he grants you against any foe you catch unawares.
  
Granted Abilities: 
Marchosias gives you an assassin’s skill at killing, plus the ability to assume gaseous form and the power to charm foes.

Death Attack: If you have sneak attack, you gain the Death Attack ability, as per the assassin class.

Fiery Retribution: You deal an extra 3d6 points of fire damage when you strike an opponent who can deal extra damage through a sneak attack, sudden strike, 
or skirmish attack. This extra damage applies to ranged attacks only if the opponent is within 30 feet.

Smoke Form: You can assume the form of a smoke cloud at will, like the gaseous form spell. You can suppress or activate this ability as a standard action. 
Once you have returned to your normal form from smoke form, you cannot do so again for 5 rounds.

Silent and Sure: You gain a +16 competence bonus on Hide and Move Silently checks.
*/

#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = PRCGetSpellTargetObject(); 

    effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_FLAMING_SPHERE), EffectPact(oBinder));
    if (!GetIsVestigeExploited(oBinder, VESTIGE_MARCHOSIAS_DEATH_ATTACK)) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_FEAT_PRC_DEATH_ATTACK), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
	if (!GetIsVestigeExploited(oBinder, VESTIGE_MARCHOSIAS_RETRIBUTION))
	{
		object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oBinder);
        if (GetWeaponRanged(oItem))
        {	    
	        // Add eventhook to the ranged weapons like darts
	        IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            AddEventScript(oItem, EVENT_ITEM_ONHIT, "bnd_events", TRUE, FALSE);
        
            object oAmmo = GetItemInSlot(INVENTORY_SLOT_BOLTS, oBinder);
            IPSafeAddItemProperty(oAmmo, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            AddEventScript(oAmmo, EVENT_ITEM_ONHIT, "bnd_events", TRUE, FALSE);
        
            oAmmo = GetItemInSlot(INVENTORY_SLOT_BULLETS, oBinder);
            IPSafeAddItemProperty(oAmmo, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            AddEventScript(oAmmo, EVENT_ITEM_ONHIT, "bnd_events", TRUE, FALSE);

            oAmmo = GetItemInSlot(INVENTORY_SLOT_ARROWS, oBinder);
            IPSafeAddItemProperty(oAmmo, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            AddEventScript(oAmmo, EVENT_ITEM_ONHIT, "bnd_events", TRUE, FALSE);
        }
        else if (IPGetIsMeleeWeapon(oItem))
        {            
            // Add eventhook to the item
            AddEventScript(oItem, EVENT_ITEM_ONHIT, "bnd_events", TRUE, FALSE);

            // Add the OnHitCastSpell: Unique needed to trigger the event
            // Makes sure to get ammo if its a ranged weapon
            IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        }
	}    
    if (!GetIsVestigeExploited(oBinder, VESTIGE_MARCHOSIAS_SMOKE)) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_MARCHOSIAS_SMOKE), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    if (!GetIsVestigeExploited(oBinder, VESTIGE_MARCHOSIAS_SILENT))   
    {
    	eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_HIDE, 16));
    	eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_MOVE_SILENTLY, 16));
    }	
   
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oBinder, HoursToSeconds(24));      
}