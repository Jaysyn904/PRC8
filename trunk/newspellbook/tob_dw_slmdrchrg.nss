/*
   ----------------
   Salamander Charge

   tob_dw_slmdrchrg.nss
   ----------------

    19/08/07 by Stratovarius
*/ /** @file

    Salamander Charge

    Desert Wind (Strike) [Fire]
    Level: Swordsage 7
    Prerequisite: Three Desert Wind maneuvers
    Initiation Action: 1 Full-round action
    Range: Personal
    Target: You
    Duration: Instantaneous, see text

    You spin and tumble about the battlefield, a wall of raging flame marking your steps.
    
    You charge your foe. In the space across which you charge, a wall of fire appears, dealing 6d6 damage to all who enter.
    This wall lasts for 5 rounds.
    This is a supernatural maneuver.
*/

#include "tob_inc_move"
#include "tob_movehook"
#include "prc_inc_combmove"

location FindLocation(object oTarget, object oInitiator);

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
        int nDamage;
        if (GetLocalInt(oInitiator, "DesertFire")) nDamage += d6();        
	    DoCharge(oInitiator, oTarget, TRUE, TRUE, nDamage);
	    effect eAOE = EffectAreaOfEffect(AOE_PER_SALAMANDER_CHARGE);
	    location lTarget = FindLocation(oTarget, oInitiator);
	    // So you run over it first
	    DelayCommand(3.0, ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, 30.0));
    }
}

location FindLocation(object oTarget, object oInitiator)
{
            // Calculate location 
            float fDistance        = GetDistanceBetween(oTarget, oInitiator);
            location lInitiator    = GetLocation(oInitiator);
            location lTargetOrigin = GetLocation(oTarget);
            vector vAngle          = AngleToVector(GetRelativeAngleBetweenLocations(lInitiator, lTargetOrigin));
            vector vTargetOrigin   = GetPosition(oTarget); 
            // Half the distance
            vector vTarget         = vTargetOrigin + (vAngle * (fDistance/2));

            return lTargetOrigin = Location(GetArea(oTarget), vTarget, GetFacing(oTarget));
}