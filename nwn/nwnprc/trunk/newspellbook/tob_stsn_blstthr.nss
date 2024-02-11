/*
   ----------------
   Ballista Throw

   tob_stsn_blstthr.nss
   ----------------

    05/12/07 by Stratovarius
*/ /** @file

    Ballista Throw

    Setting Sun (Strike)
    Level: Swordsage 6
    Prerequisite: Two Setting Sun maneuvers
    Initiation Action: 1 Standard Action
    Range: Melee Attack.
    Target: One Creature.

    You grab your opponent and spin him like a top, swinging him around before throwing him
    at your opponents like a bolt from a ballista
    
    Make a trip attempt against your target. You get a +4 bonus on this attempt and cannot be tripped
    if you fail on this attempt. If you succeed on the check, your enemy is thrown in a 60 foot line. The target
    and all creatures in the line take 6d6 damage.
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
	// If you succeed, toss em away 60 feet and knock em down
	if (nSucceed)
	{
		float fDist = 60.0;

		// Find the target to be tossed into		
		int nStop = FALSE;
		location lTarget = GetLocation(oTarget);
		vector vOrigin       = GetPosition(oInitiator);
            	object oAreaTarget = MyFirstObjectInShape(SHAPE_SPELLCYLINDER, FeetToMeters(60.0), lTarget, TRUE, OBJECT_TYPE_CREATURE, vOrigin);
            	while(GetIsObjectValid(oAreaTarget) && !nStop)
            	{
            		// No hitting yourself or your friends, and they need to be within hitting range.
                	if(oTarget != oAreaTarget && GetIsEnemy(oAreaTarget, oInitiator))
                	{
    				ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6(6)),oAreaTarget);
                	}// end if - Target validity check

                	// Get next target
                	oAreaTarget = MyNextObjectInShape(SHAPE_SPELLCYLINDER, FeetToMeters(60.0), lTarget, TRUE, OBJECT_TYPE_CREATURE, vOrigin);
            	}// end while - Target loop			
		
		// Knock em down
		_DoBullRushKnockBack(oTarget, oInitiator, fDist);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectKnockdown()), oTarget, 6.0);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6(6)), oTarget);
	}
    }
}