/*
13/03/21 by Stratovarius

Chupoclops, Harbinger of Forever
  
A great monster believed to be a harbinger of the apocalypse, Chupoclops became a vestige when slain by mortals. Chupoclops grants its summoner a bite attack and
unnatural senses, plus the ability to pounce on foes, to exist ethereally, and to make enemies despair.

Vestige Level: 6th
Binding DC: 25
Special Requirement: Chupoclops hates Amon for some unknown reason and will not answer your call if you are already bound to him.

Influence: While under the influence of Chupoclops, you can’t help but be pessimistic. At best, you are quietly resigned to your own failure, and at 
worst, you spread your doubts to others, trying to convince them of the hopelessness of their goals. In addition, Chupoclops requires that you voluntarily fail all saving throws against fear effects.

Granted Abilities: 
Chupoclops gives you the power to linger on the Ethereal Plane, sense the living and undead, demoralize foes, and bite enemies.

Ethereal Watcher: At will as a move action, you can become ethereal. You can remain on the Ethereal Plane indefinitely if you take no actions, but any movement or
combat causes you to return to the Material Plane. Once you have returned to the Material Plane, you cannot use this ability again for 5 rounds.
*/

#include "bnd_inc_bndfunc"

void main()
{
	object oBinder = OBJECT_SELF;
	if(!TakeMoveAction(oBinder)) return;
	effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_SANCTUARY), EffectEthereal());
	SPApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(eLink), oBinder);	
}
