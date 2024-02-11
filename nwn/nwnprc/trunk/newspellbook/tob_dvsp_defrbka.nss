/*
   ----------------
   Defensive Rebuke, OnHit

   tob_dvsp_defrbka
   ----------------

   15/07/07 by Stratovarius
*/ /** @file

    Defensive Rebuke

    Devoted Spirit (Boost)
    Level: Crusader 3
    Prerequisite: One Devoted Spirit maneuver.
    Initiation Action: 1 Swift Action
    Range: Personal
    Target: You
    Duration: 1 round

    You sweep your weapon in a wide, deadly arc. When your blows strike home, you
    send your foe tumbling back on the defensive. He must deal with you first, or 
    leave himself open to your deadly counter.
    
    You make an attack of opportunity against any foe you strike this round
    who targets your allies instead of attacking you.
*/

#include "tob_inc_tobfunc"
#include "tob_movehook"
////#include "prc_alterations"

void main()
{
    object oTarget       = OBJECT_SELF; //The Script is run on the target
    object oInitiator    = GetLocalObject(oTarget, "DefensiveRebuke");
    
    // Deaders are useless.
    if (GetIsDead(oTarget) || GetIsDead(oInitiator)) return;
    
    // Check to see if they're still targetting you.
    if (GetAttackTarget(oTarget) != oInitiator)
    {
    	effect eNone;
    	DelayCommand(0.0, PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, 0, 0, "Defensive Rebuke Hit", "Defensive Rebuke Miss"));
    }
}