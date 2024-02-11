/*
   ----------------
   Searing Blade

   tob_dw_searbld.nss
   ----------------

    19/08/07 by Stratovarius
*/ /** @file

    Searing Blade

    Desert Wind (Boost) [Fire]
    Level: Swordsage 4
    Prerequisite: Two Desert Wind Maneuvers
    Initiation Action: 1 Swift Action
    Range: Personal.
    Target: You.
    Duration: 1 Round.

    Your weapon transforms into a raging torrent of flame,
    causing those around you to recoil slightly from the tremendous heat.
    
    Your strikes deal 2d6 + Initiator level fire damage.
    This is a supernatural maneuver.
*/

#include "tob_inc_move"
#include "tob_movehook"
////#include "prc_alterations"

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
	DoDesertWindBoost(oInitiator);	
    }
}