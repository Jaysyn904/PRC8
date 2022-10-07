/*
   ----------------
   Searing Charge

   tob_dw_searchrg.nss
   ----------------

    19/08/07 by Stratovarius
*/ /** @file

    Searing Charge

    Desert Wind (Strike) [Fire]
    Level: Swordsage 4
    Prerequisite: One Desert Wind maneuver
    Initiation Action: 1 Full-round action
    Range: Personal.
    Target: You.
    Duration: Instantaneous.

    You rush through the air towards your foe, fire streaming in your wake.
    
    You charge your foe, gaining 5d6 fire damage. You generate no Attacks of Opportunity.
    This is a supernatural maneuver.
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
    	// Yup, thats it.
        int nDamage = d6(5);
        if (GetLocalInt(oInitiator, "DesertFire")) nDamage += d6();
	    DoCharge(oInitiator, oTarget, TRUE, FALSE, nDamage, DAMAGE_TYPE_FIRE);
    }
}