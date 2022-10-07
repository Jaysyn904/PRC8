/*
15/03/21 by Stratovarius

Vanus, the Reviled One
  
Hated out of proportion for his sins, the smiling Vanus remains an enigma to binders. Vanus provides binders with the ability to frighten and punish weaker foes, hear evil afoot with uncanny perception, and free allies from constraints.

Vestige Level: 6th
Binding DC: 29
Special Requirement: Vanus refuses to appear when summoned indoors, and will only answer the summoner's call when well away from buildings.

Influence: Under the influence of Vanus, you take every opportunity to revel. Even small victories seem like cause for grand celebrations, and if you’re happy, you want everyone around to share your joy. If you see others in the act of celebration, you must join in. If you achieve victory in combat, you must immediately spend a full-round action crowing about your triumph.

Granted Abilities: 
Vanus grants you tremendous hearing, the ability to foment fear by your presence alone, skill at fighting foes weaker than yourself, and the power to free allies from imprisonment.

Fear Aura: Enemies that you are aware of who come within 10 feet must succeed at a Will save. Those who fail are frightened. Foes remain frightened for a number of rounds equal to half your binder level. Creatures that fail the save must roll again if they again come within 10 feet. A creature that makes its save against this ability need not make another save for 24 hours. This is a mind-affecting fear effect.

Free Ally: You may designate any ally to gain the benefits of the freedom of movement spell for one round. You cannot use this ability on yourself. Once you have used this ability you cannot do so again for 5 rounds.

Noble Disdain: When attacking a foe of fewer Hit Dice than yourself with a ranged or melee weapon, you deal +1d6 points of damage.

Vanus’s Ears: Being bound to Vanus grants you a +10 bonus on Listen checks.
*/

#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = PRCGetSpellTargetObject(); 
	SetLocalObject(GetModule(), "VanusFear", oBinder);
    effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_ENTROPIC_SHIELD), EffectPact(oBinder));
    
	if (!GetIsVestigeExploited(oBinder, VESTIGE_VANUS_FEAR_AURA)) eLink = EffectLinkEffects(eLink, EffectAreaOfEffect(VFX_PER_SNARE, "bnd_vest_vanusen", "", ""));
	if (!GetIsVestigeExploited(oBinder, VESTIGE_VANUS_FREE_ALLY)) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_CONST_VESTIGE_VANUS_FREE_ALLY),  HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
	if (!GetIsVestigeExploited(oBinder, VESTIGE_VANUS_DISDAIN))
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
	if (!GetIsVestigeExploited(oBinder, VESTIGE_VANUS_EARS)) eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_LISTEN, 10));	
	
    if (!GetLocalInt(oBinder, "PactQuality"+IntToString(VESTIGE_VANUS)))
    {
    	FloatingTextStringOnCreature("You have made a poor pact, and Vanus requires you to celebrate your combats!", oBinder, FALSE);    
    }		
	
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oBinder, HoursToSeconds(24));      
}