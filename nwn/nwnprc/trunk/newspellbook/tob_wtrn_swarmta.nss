/*
   ----------------
   Swarm Tactics, Enter

   tob_wtrn_swarmt.nss
   ----------------

    29/09/07 by Stratovarius
*/ /** @file

    Swarm Tactics

    Devoted Spirit (Stance)
    Level: Crusader 5, Warblade 5
    Prerequisite: One White Raven maneuver
    Initiation Action: 1 Swift Action
    Range: 60 ft.
    Area: 60 ft.
    Duration: Stance.

    Your quick directions enable close teamwork between you and an ally.
    At your urging, your allies seize the initiative and work in close
    coordination with you to defeat an enemy.
    
    Any creature you threaten takes a -5 penalty to armour class.
*/

#include "tob_inc_tobfunc"
#include "tob_movehook"
//#include "prc_alterations"

void main()
{
    //Declare major variables
    object oTarget = GetEnteringObject();
    effect eAC = EffectACDecrease(5);
           eAC = ExtraordinaryEffect(eAC);
    // Targets it can apply to
    if (GetIsEnemy(oTarget, GetAreaOfEffectCreator()) && GetIsInMeleeRange(oTarget, GetAreaOfEffectCreator()))
    {
    	// Lasts until they leave the AoE
    	SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eAC, oTarget);
    }
}