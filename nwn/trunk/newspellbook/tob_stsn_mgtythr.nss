/*
   ----------------
   Mighty Throw

   tob_stsn_mgtythr.nss
   ----------------

    31/03/07 by Stratovarius
*/ /** @file

    Mighty Throw

    Setting Sun (Strike)
    Level: Swordsage 1
    Initiation Action: 1 Standard Action
    Range: Melee Attack.
    Target: One Creature.

    You use superior leverage and your Setting Sun training to send an opponent tumbling to the ground.
    
    Make a trip attempt against your target. You get a +4 bonus on this attempt and cannot be tripped
    if you fail on this attempt. If you succeed on the check, your enemy is thown 10 feet away and 
    lands prone on the ground.
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
		_DoBullRushKnockBack(oTarget, oInitiator, 10.0);
		// Knock em down
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectKnockdown()), oTarget, 6.0);
	}
    }
}