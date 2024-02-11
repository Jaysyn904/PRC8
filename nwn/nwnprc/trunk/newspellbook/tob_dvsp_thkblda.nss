/*
   ----------------
   Thicket of Blades, Enter

   tob_dvsp_thckbld.nss
   ----------------

    15/07/07 by Stratovarius
*/ /** @file

    Thicket of Blades

    Devoted Spirit (Stance)
    Level: Crusader 3
    Prerequisite: One Devoted Spirit maneuver.
    Initiation Action: 1 Swift Action
    Range: Personal.
    Target: You.
    Duration: Stance.

    You maintain a careful guard as you search for any gaps in your opponent's
    awarness. Even the slightest move provokes a stinging counter from you.
    
    Any creature who attempts to move near you provokes an AoO.
*/

#include "tob_inc_tobfunc"
#include "tob_movehook"
////#include "prc_alterations"

void main()
{
    //Declare major variables
    object oTarget = GetEnteringObject();
    // Targets it can apply to
    if (oTarget != GetAreaOfEffectCreator() && GetIsEnemy(oTarget, GetAreaOfEffectCreator()) && !GetLocalInt(GetAreaOfEffectCreator(), "ThicketOfBladesDelay"))
    {
	// Slap upside the head, only one AoO per round.
	effect eNone;
	DelayCommand(0.0, PerformAttack(oTarget, GetAreaOfEffectCreator(), eNone, 0.0, 0, 0, 0, "Thicket of Blades Hit", "Thicket of Blades Miss"));
	SetLocalInt(GetAreaOfEffectCreator(), "ThicketOfBladesDelay", TRUE);
	DelayCommand(6.0, DeleteLocalInt(GetAreaOfEffectCreator(), "ThicketOfBladesDelay"));
    }
}