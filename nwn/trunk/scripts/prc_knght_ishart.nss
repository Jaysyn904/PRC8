//::///////////////////////////////////////////////
//:: Knight - Improved Shield Ally, Return Value
//:: prc_knght_ishart.nss
//:://////////////////////////////////////////////
//:: Share Pain for one round
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: July 1, 2007
//:://////////////////////////////////////////////
#include "x2_inc_spellhook"
void main()
{
	// We want the damage dealt
	SetLocalInt(OBJECT_SELF, "ShieldAllyDamage", GetTotalDamageDealt());
}