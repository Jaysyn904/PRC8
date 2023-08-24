/*
   ----------------
   Soaring Throw

   tob_stsn_srnthr.nss
   ----------------

    05/12/07 by Stratovarius
*/ /** @file

    Soaring Throw

    Setting Sun (Strike)
    Level: Swordsage 5
    Prerequisite: Two Setting Sun maneuvers
    Initiation Action: 1 Standard Action
    Range: Melee Attack.
    Target: One creature

    With a great shout, you send your opponent soaring through the air in a high arc.
    He slams back into the ground with a bone-crushing thud.
    
    Make a trip attempt against your target. You get a +4 bonus on this attempt and cannot be tripped
    if you fail on this attempt. If you succeed on the check, your enemy is thrown 20 feet away plus 
    5 feet for every 5 you succeed on the trip check by. The target takes 8d6 damage.
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
    	// Trip attempt
	int nSucceed = DoTrip(oInitiator, oTarget, 4, FALSE, FALSE);
	// If you succeed, toss em away 10 feet and knock em down
	if (nSucceed)
	{
		int nSkill = GetLocalInt(oInitiator, "TripDifference")/5;
		// Another five feet of distance for every 5 you succeed the check by
		float fDist = 20.0 + (nSkill * 5.0);
		_DoBullRushKnockBack(oTarget, oInitiator, fDist);
		// Knock em down
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectKnockdown()), oTarget, 6.0);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6(8)), oTarget);
	}
    }
}