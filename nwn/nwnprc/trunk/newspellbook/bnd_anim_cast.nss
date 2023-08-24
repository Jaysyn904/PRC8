/*
04/03/21 by Stratovarius

Anima Mage Exploit Vestige Cast Spell

Cast a spell from an exploited vestige
*/

#include "bnd_inc_bndfunc"

void main()
{
	object oBinder = OBJECT_SELF;
	if (GetLocalInt(oBinder, "ExploitVestige"))
	{
		ActionCastSpell(GetLocalInt(oBinder, "ExploitVestigeSpell"), 0, 0, 0, METAMAGIC_NONE, GetPrimaryArcaneClass(oBinder), 0, 0, OBJECT_INVALID, FALSE);
	}
	else
	{
		IncrementRemainingFeatUses(oBinder, 9259);
		FloatingTextStringOnCreature("You are not exploiting a vestige!", oBinder, FALSE);
	}
}