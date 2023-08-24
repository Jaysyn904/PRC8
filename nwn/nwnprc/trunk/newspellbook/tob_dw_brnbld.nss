/*
   ----------------
   Burning Blade

   tob_dw_brnbld.nss
   ----------------

    28/03/07 by Stratovarius
*/ /** @file

    Burning Blade

    Desert Wind (Boost) [Fire]
    Level: Swordsage 1
    Initiation Action: 1 Swift Action
    Range: Personal.
    Target: You.
    Duration: 1 Round.

    Your blade bursts into flame as it sweeps towards your foe in an elegant arc.
    
    Your strikes deal 1d6 + Initiator level fire damage.
    This is a supernatural maneuver.
*/

#include "tob_inc_move"
#include "tob_movehook"

void main()
{
    if (!PreManeuverCastCode()) return;

    object oInitiator = OBJECT_SELF;
    struct maneuver move = EvaluateManeuver(oInitiator);

    if(move.bCanManeuver)
        DoDesertWindBoost(oInitiator);
}
