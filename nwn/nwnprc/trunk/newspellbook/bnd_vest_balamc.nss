/*
09/03/21 by Stratovarius

Balam, the Bitter Angel
  
Once a being of extreme goodness, Balam became a wrathful vestige after taking on an impossible task that ended in failure. She grants her summoners the ability to foresee future difficulties and the intellect to interpret what they see, as well as skill with light arms and a stare that chills flesh.

Vestige Level: 5th
Binding DC: 25
Special Requirement: Balam requires a sacrifice of her summoner. In the process of calling her, you must deal 1 point of slashing damage to yourself.

Influence: Balam’s influence causes you to distrust clerics, paladins, and other devotees of deities. Whenever you enter a temple or some other holy or unholy site, Balam requires that you spit on the floor and utter an invective about the place.

Granted Abilities: 
Balam grants you the power to predict future events. She also teaches cunning and finesse, and gives you the ability to freeze foes with a glance.

Balam’s Cunning: You reroll your next failed saving throw. Once you have used this ability, you cannot do so again for 5 rounds.
*/

#include "bnd_inc_bndfunc"

void main()
{
	object oBinder = OBJECT_SELF;
	if(!BindAbilCooldown(oBinder, GetSpellId(), VESTIGE_BALAM)) return;

	SetLocalInt(oBinder, "BalamCunning", TRUE);
	DelayCommand(30.0, DeleteLocalInt(oBinder, "BalamCunning"));
}
