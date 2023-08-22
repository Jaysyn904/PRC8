/*
   ----------------
   Tide of Chaos

   tob_dvsp_tdchs.nss
   ----------------

    31/08/07 by Stratovarius
*/ /** @file

    Tide of Chaos

    Devoted Spirit (Strike) [Chaos]
    Level: Crusader 5
    Prerequisite: One Devoted Spirit maneuver
    Initiation Action: 1 Full-round action
    Range: Melee
    Target: One creature
    Duration: 1 round

    The power of chaos swirls around you, lending strength to
    your attacks as you cast your fate to the whims of luck.
    
    You make a charge attack. If the target is law aligned, you gain a +8 bonus on your attack
    and 4d6 damage. If it hits, you gain total concealment for one round.
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
    	int nAtk = 0;
    	int nDam = 0;
    	if (GetAlignmentLawChaos(oTarget) == ALIGNMENT_CHAOTIC)
    	{
    		nAtk = 8;
    		nDam = d6(4);
    	}
    	
        // Now the Charge. Post-charge effects are handled in prc_inc_combmove
	    DoCharge(oInitiator, oTarget, TRUE, TRUE, nDam, DAMAGE_TYPE_DIVINE, FALSE, 0, FALSE, FALSE, nAtk);
    }
}