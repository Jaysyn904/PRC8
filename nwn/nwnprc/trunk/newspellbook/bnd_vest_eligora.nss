/*
18/03/21 by Stratovarius

Eligor, Dragon's Slayer
    
A champion both against and for evil dragons, Eligor grants martial prowess both in and out of the saddle, as well as supernatural strength.
  
Vestige Level: 7th
Binding DC: 30
Special Requirement: No
  
Influence: You feel pity for all outcasts, particularly halfelves and half-orcs, and you make every effort to befriend any such beings you meet. Because Eligor 
desires revenge on the deities who abandoned him, he requires that you attack a human, elf, or dragon foe in preference to all others whenever you enter combat.
  
Granted Abilities: 
In his first life, Eligor was a skilled horseman, and in his second, he served the primary deity of chromatic dragons. Thus, the powers he grants tend to reflect those associations.
 
Chromatic Strike: As a free action, you can charge a melee attack with acid, cold, electricity, or fire. Your next melee attack deals an extra 1d6 points of damage of the 
chosen energy type. You can charge a single melee attack only once.
*/

#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = OBJECT_SELF;
   	// The OnHit
   	object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oBinder);
   	SetLocalInt(oBinder, "EligorStrike", DAMAGE_TYPE_ACID);
   	IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 6.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
   	AddEventScript(oItem, EVENT_ITEM_ONHIT, "bnd_events", FALSE, FALSE);
}