/*
    Recover all warblade maneuvers
    Only functions in combat, otherwise call delayed recovery
*/
#include "tob_inc_recovery"

void main()
{
	object oInitiator = OBJECT_SELF;
	if (GetIsInCombat(oInitiator))
	{
		SetLocalInt(oInitiator, "WarbladeRecoveryRound", TRUE);
		// One round recovery time
		DelayCommand(6.0, DeleteLocalInt(oInitiator, "WarbladeRecoveryRound"));
		RecoverExpendedManeuvers(oInitiator, MANEUVER_LIST_WARBLADE);
	}
	else
	{
		// Delayed Recovery Mechanics
		ExecuteScript("tob_gen_recover", oInitiator);
	}
}