/*
   ----------------
   Devastating Throw

   tob_stsn_devthr.nss
   ----------------

    15/07/07 by Stratovarius
*/ /** @file

    Devastating Throw

    Setting Sun (Strike)
    Level: Swordsage 3
    Prerequisite: One Setting Sun maneuver.
    Initiation Action: 1 Standard Action
    Range: Melee Attack.
    Target: One Creature.

    Seizing your foe by the arm, you spin in a quick half-circle and hurl him headlong away from you.
    
    Make a trip attempt against your target. You get a +4 bonus on this attempt and cannot be tripped
    if you fail on this attempt. If you succeed on the check, your enemy is thrown 10 feet away plus 
    5 feet for every 5 you succeed on the trip check by. The target takes 2d6 damage.
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
		float fDist = 10.0 + (nSkill * 5.0);
		_DoBullRushKnockBack(oTarget, oInitiator, fDist);
		// Knock em down
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectKnockdown()), oTarget, 6.0);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6(2)), oTarget);
	}
    }
}