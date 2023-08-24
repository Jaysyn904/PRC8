/*
05/03/21 by Stratovarius

Tenebrous, the Shadow That Was
  
Tenebrous, once a powerful demon prince, offers dominion over darkness and death.

Vestige Level: 4th
Binding DC: 21
Special Requirement: You must draw Tenebrous’s seal at night.

Influence: While influenced by Tenebrous, you are filled with a sense of detachment and an aching feeling of loss and abandonment. 
Tenebrous requires that you never be the first to act in combat. If your initiative check result is the highest, you must delay until someone else takes a turn.

Granted Abilities: 
Tenebrous grants you power over undead and shadows. He gives you the ability to chill your foes.

Touch of the Void: As a swift action, you can charge a melee attack with cold energy. Your next melee attack deals an extra 1d8 points of cold 
damage, plus 1d8 points of cold damage for every four effective binder levels beyond 7th that you possess. When you attain an effective binder level of 11th, you 
can charge your weapon for an entire round. Once you have used this ability, you cannot do so again for 5 rounds.
*/

#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = OBJECT_SELF;
    if(!TakeSwiftAction(oBinder)) return;
    if(!BindAbilCooldown(oBinder, GetSpellId(), VESTIGE_TENEBROUS)) return;
    
    int nBinderLevel = GetBinderLevel(oBinder, VESTIGE_TENEBROUS);

	if (nBinderLevel >= 11)
	{
		int nDam = DAMAGE_BONUS_1d8;
		if ((nBinderLevel-7)/4 >= 3) nDam = 42; //4d8
		else if ((nBinderLevel-7)/4 >= 2) nDam = 41; //3d8
		else if ((nBinderLevel-7)/4 >= 1) nDam = DAMAGE_BONUS_2d8;
		
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDamageIncrease(nDam, DAMAGE_TYPE_COLD), oBinder, 6.0);
	}
	else
	{
    	// The OnHit
    	object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oBinder);
    	IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 6.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    	AddEventScript(oItem, EVENT_ITEM_ONHIT, "bnd_events", FALSE, FALSE);
    }	
}