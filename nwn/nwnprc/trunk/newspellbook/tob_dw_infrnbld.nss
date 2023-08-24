/*
   ----------------
   Inferno Blade

   tob_dw_infrnbld.nss
   ----------------

    29/10/07 by Stratovarius
*/ /** @file

    Inferno Blade

    Desert Wind (Boost) [Fire]
    Level: Swordsage 7
    Initiation Action: 1 Swift Action
    Range: Personal
    Target: You
    Duration: 1 Round

    A blinding light flashes from your weapon, and for a split second, it transforms into burning magma.
    
    Your strikes deal 3d6 + Initiator level fire damage.
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