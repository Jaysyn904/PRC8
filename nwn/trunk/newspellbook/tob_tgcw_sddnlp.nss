/*
   ----------------
   Sudden Leap

   tob_tgcw_sddnlp.nss
   ----------------

    27/04/07 by Stratovarius
*/ /** @file

    Sudden Leap

    Tiger Claw (Boost)
    Level: Swordsage 1, Warblade 1
    Initiation Action: 1 Swift Action
    Range: Personal.
    Target: You.
    Duration: Instantaneous.

    You leap to a new position in the blink of an eye, leaving your opponents baffled.
    
    You jump as a swift action.
*/

#include "tob_inc_move"
#include "tob_movehook"
//#include "prc_alterations"
#include "prc_inc_skills"

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
    	// Jump time
	PerformJump(oInitiator, PRCGetSpellTargetLocation(), FALSE);	
    }
}