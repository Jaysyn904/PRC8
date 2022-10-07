/*
   ----------------
   Tornado Throw

   tob_stsn_trnthr.nss
   ----------------

    10/10/18 by Stratovarius
*/ /** @file

    Tornado Throw

    Setting Sun (Strike)
    Level: Swordsage 9
    Prerequisite: Five Setting Sun maneuvers
    Initiation Action: 1 Standard Action
    Range: Melee Attack.
    Target: One Creature.

    Like a whirlwind, you twist and spin across the battlefield, tossing foes away left and right.
    
    Make a trip attempt against your target. You cannot be tripped if you fail on this attempt, and use Dexterity or Strength, whichever is better. 
    If you succeed on the check, your enemy is thrown 10 feet away plus 5 feet for every 5 you succeed on the trip check by. The target takes 2d6 damage plus 1d6 for every extra five feet thrown.
    You gain a +2 bonus on the trip check for every 5 feet moved after the first throw.
    
    Repeat until you have moved sixty feet or there are no more enemies within range.
*/

#include "tob_inc_move"
#include "tob_movehook"
#include "prc_inc_combmove"

void TornadoThrow(object oInitiator, object oTarget, int nBonus)
{
    // Trip attempt
    int nSucceed = DoTrip(oInitiator, oTarget, nBonus, FALSE, FALSE);
    // If you succeed, toss em away 10 feet and knock em down
    if (nSucceed)
    {
        int nSkill = GetLocalInt(oInitiator, "TripDifference")/5;
        // Another five feet of distance for every 5 you succeed the check by
        float fDist = 10.0 + (nSkill * 5.0);
        int nDam = FloatToInt(fDist) / 5;
        
        // Knock em down
        _DoBullRushKnockBack(oTarget, oInitiator, fDist);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectKnockdown()), oTarget, 6.0);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6(nDam)), oTarget);  
    }  
}

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
        int nBonus = 0;
        TornadoThrow(oInitiator, oTarget, nBonus);

	    // Find the next target
	    location lTarget;
        float fDist;
        object oAreaTarget = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE, oInitiator);
        while(GetIsObjectValid(oAreaTarget) && 60.0 > fDist) //Farthest Initiator can move in a round
        {
        	// No hitting yourself or your friends
           	if(GetIsEnemy(oAreaTarget, oInitiator))
         	{
                fDist += MetersToFeet(GetDistanceBetween(oInitiator, oAreaTarget));
                AssignCommand(oInitiator, ClearAllActions(TRUE));
                AssignCommand(oInitiator, JumpToLocation(GetLocation(oAreaTarget)));
                nBonus = (FloatToInt(fDist) / 5) * 2; // Bonus is +2 for every 5 feet moved
                TornadoThrow(oInitiator, oAreaTarget, nBonus);
            }// end if - Target validity check

            // Get next target
            oAreaTarget = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE, oInitiator);
        }// end while - Target loop			
    }
}