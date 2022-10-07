/*
   ----------------
   Swarm Tactics

   tob_wtrn_swarmt.nss
   ----------------

    29/09/07 by Stratovarius
*/ /** @file

    Swarm Tactics

    Devoted Spirit (Stance)
    Level: Crusader 5, Warblade 5
    Prerequisite: One White Raven maneuver
    Initiation Action: 1 Swift Action
    Range: 10 ft.
    Area: 10 ft.
    Duration: Stance.

    Your quick directions enable close teamwork between you and an ally.
    At your urging, your allies seize the initiative and work in close
    coordination with you to defeat an enemy.
    
    Any creature you threaten takes a -5 penalty to armour class.
*/

#include "tob_inc_move"
#include "tob_movehook"
//#include "prc_alterations"

void main()
{
    if (!PreManeuverCastCode())
    {
    // If code within the PreManeuverCastCode (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    object oInitiator    = OBJECT_SELF;
    object oTarget       = PRCGetSpellTargetObject();
    struct maneuver move = EvaluateManeuver(oInitiator, oTarget);

    if(move.bCanManeuver)
    {
	SPApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(EffectAreaOfEffect(AOE_PER_SWARM_TACTICS)), oTarget);
    }
}