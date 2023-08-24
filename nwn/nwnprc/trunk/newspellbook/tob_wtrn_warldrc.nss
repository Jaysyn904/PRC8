/*
   ----------------
   War Leader's Charge

   tob_wtrn_warldrc.nss
   ----------------

   08/06/07 by Stratovarius
*/ /** @file

    War Leader's Charge

    White Raven (Strike)
    Level: Crusader 6, Warblade 6
    Prerequisite: Two White Raven maneuvers
    Initiation Action: 1 Full-round Action
    Range: Melee Attack
    Target: One Creature

    You summon a great fury within your lungs, releasing it in a titantic shout
    as you charge forward. Your reckless move startles your foes and puts greater
    force behind your attack.
    
    You charge your opponent, dealing an extra 35 damage if you hit. You take no
    AoOs from the movement.
*/

#include "tob_inc_move"
#include "tob_movehook"
#include "prc_inc_combmove"

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
	DoCharge(oInitiator, oTarget, TRUE, FALSE, 35);
    }
}