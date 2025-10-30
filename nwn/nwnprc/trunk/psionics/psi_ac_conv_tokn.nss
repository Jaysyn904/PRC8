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

PRC8 token pre-fix = 161838
*/
void main()
{
	object oPC = GetPCSpeaker();
	int nACLevel = GetLocalInt(oPC, ASTRAL_CONSTRUCT_LEVEL + EDIT);
	int nFlags = GetLocalInt(oPC, ASTRAL_CONSTRUCT_OPTION_FLAGS + EDIT);
	
	SetCustomToken(161838200, IntToString(nACLevel) + "  (Base PP cost " + IntToString(nACLevel * 2 - 1) + ")");
	SetCustomToken(161838201, GetSizeAsString(nACLevel));
	SetCustomToken(161838202, GetHPAsString(nACLevel, nFlags));
	SetCustomToken(161838203, GetSpeedAsString(nACLevel, nFlags));
	SetCustomToken(161838204, IntToString(GetMaxSlotsForLevel(nACLevel, oPC) - GetTotalNumberOfSlotsUsed(oPC)));
	SetCustomToken(161838205, GetMenuASelectionsAsString(oPC));
	SetCustomToken(161838206, GetMenuBSelectionsAsString(oPC));
	SetCustomToken(161838207, GetMenuCSelectionsAsString(oPC));
}
	
	
	