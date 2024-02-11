/*
   ----------------
   Radiant Charge

   tob_dvsp_rdtchrg.nss
   ----------------

    31/08/07 by Stratovarius
*/ /** @file

    Radiant Charge

    Devoted Spirit (Strike) [Good]
    Level: Crusader 5
    Prerequisite: One Devoted Spirit maneuver
    Initiation Action: 1 Full-round action
    Range: Melee
    Target: One creature
    Duration: 1 round

    You gather the power of your faith and discipline, 
    surrounding yourself in an aura of blinding glory.
    
    You make a charge attack. If the target is evil aligned, you gain 6d6 damage on the attack,
    and damage reduction of 10/- for one round.
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
    	int nDam = 0;
    	if (GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL)
    	{
    		nDam = d6(6);
    	}
    	
        // Now the Charge. Post-charge effects are handled in prc_inc_combmove
	    DoCharge(oInitiator, oTarget, TRUE, TRUE, nDam, DAMAGE_TYPE_DIVINE);
    }
}