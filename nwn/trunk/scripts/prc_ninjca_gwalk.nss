/*****************************************************
* Feat: Ghost Walk
* Description: 1 round per Ninja level
* (spell: etheralness). Uses up 2 ki points
*
* by Ryan Smith
*****************************************************/

#include "prc_inc_clsfunc"

void main()
{
     	if (GetLocalInt(OBJECT_SELF, "prc_ninja_ki") < 2)
     	{
		IncrementRemainingFeatUses(OBJECT_SELF, FEAT_KI_DODGE);
		SendMessageToPC(OBJECT_SELF, "You don't have enough ki to perform this action");
		return;
     	}
	if (!Ninja_AbilitiesEnabled(OBJECT_SELF))
	{
		IncrementRemainingFeatUses(OBJECT_SELF, FEAT_GHOST_WALK);
		SendMessageToPC(OBJECT_SELF, "Your ki powers will not function while encumbered or wearing armor");
		return;
	}
	Ninja_DecrementKi(OBJECT_SELF, FEAT_GHOST_WALK);
	Ninja_DecrementKi(OBJECT_SELF);

	float fDuration = RoundsToSeconds(GetLevelByClass(CLASS_TYPE_NINJA,OBJECT_SELF));
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectEthereal(), OBJECT_SELF, fDuration);
}
