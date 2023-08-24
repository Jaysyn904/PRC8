/*
    This is the delayed recovery script that the player has to manually fire outside of combat to recover maneuvers.
*/
#include "tob_inc_recovery"

// Counts down a minute, then recovers the maneuvers.
void Countdown(object oInitiator, int nTime)
{
	if (0 >= nTime)
	{
		RecoverExpendedManeuvers(oInitiator, MANEUVER_LIST_CRUSADER);
		RecoverExpendedManeuvers(oInitiator, MANEUVER_LIST_SWORDSAGE);
		RecoverExpendedManeuvers(oInitiator, MANEUVER_LIST_WARBLADE);
		RecoverPrCAbilities(oInitiator);
		FloatingTextStringOnCreature("You have recovered all expended maneuvers", oInitiator, FALSE);
		if (GetRacialType(oInitiator) == RACIAL_TYPE_RETH_DEKALA)
		{
			RecoverExpendedManeuvers(oInitiator, MANEUVER_LIST_RETH_DEKALA);
			// This readies the maneuvers as well
        	SetLocalInt(oInitiator, "ManeuverReadied" + IntToString(MANEUVER_LIST_RETH_DEKALA) + IntToString(1), MOVE_DS_DAUNTING_STRIKE);
        	SetLocalInt(oInitiator, "ManeuverReadied" + IntToString(MANEUVER_LIST_RETH_DEKALA) + IntToString(2), MOVE_TC_DEATH_FROM_ABOVE);
        	SetLocalInt(oInitiator, "ManeuverReadied" + IntToString(MANEUVER_LIST_RETH_DEKALA) + IntToString(3), MOVE_IH_DISARMING_STRIKE);
        	SetLocalInt(oInitiator, "ManeuverReadied" + IntToString(MANEUVER_LIST_RETH_DEKALA) + IntToString(4), MOVE_DS_ENTANGLING_BLADE);
        	SetLocalInt(oInitiator, "ManeuverReadied" + IntToString(MANEUVER_LIST_RETH_DEKALA) + IntToString(5), MOVE_IH_WALL_BLADES);
        	SetLocalInt(oInitiator, "ManeuverReadied" + IntToString(MANEUVER_LIST_RETH_DEKALA), 5);		
			FloatingTextStringOnCreature("You have recovered all expended Reth Dekala maneuvers", oInitiator, FALSE);		
		}
	}
	else if (!GetIsInCombat(oInitiator)) // Being in combat causes this to fail
	{
		FloatingTextStringOnCreature("You have " + IntToString(nTime) +" seconds until maneuvers are recovered", oInitiator, FALSE);
		DelayCommand(6.0, Countdown(oInitiator, nTime - 6));
	}
}

void main()
{
	object oInitiator = OBJECT_SELF;
	// One minute out of combat
	Countdown(oInitiator, 60);
}