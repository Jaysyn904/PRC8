//::///////////////////////////////////////////////
//:: Astral Construct conversation custom token initializer
//:: psi_ac_conv_tokn
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 25.01.2005
//:://////////////////////////////////////////////

#include "psi_inc_ac_const"
#include "psi_inc_ac_convo"

/*
Level: <CUSTOM100>
Size: <CUSTOM101>
HP: <CUSTOM102>
Speed: <CUSTOM103>

Option slots left: <CUSTOM104>
Options selected:
Category A: <CUSTOM105>
Category B: <CUSTOM106>
Category C: <CUSTOM107>
*/
void main()
{
	object oPC = GetPCSpeaker();
	int nACLevel = GetLocalInt(oPC, ASTRAL_CONSTRUCT_LEVEL + EDIT);
	int nFlags = GetLocalInt(oPC, ASTRAL_CONSTRUCT_OPTION_FLAGS + EDIT);
	
	SetCustomToken(100, IntToString(nACLevel) + "  (Base PP cost " + IntToString(nACLevel * 2 - 1) + ")");
	SetCustomToken(101, GetSizeAsString(nACLevel));
	SetCustomToken(102, GetHPAsString(nACLevel, nFlags));
	SetCustomToken(103, GetSpeedAsString(nACLevel, nFlags));
	SetCustomToken(104, IntToString(GetMaxSlotsForLevel(nACLevel, oPC) - GetTotalNumberOfSlotsUsed(oPC)));
	SetCustomToken(105, GetMenuASelectionsAsString(oPC));
	SetCustomToken(106, GetMenuBSelectionsAsString(oPC));
	SetCustomToken(107, GetMenuCSelectionsAsString(oPC));
}
	
	
	