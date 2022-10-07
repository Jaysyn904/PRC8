/*
   ----------------
   Order Forged From Chaos

   tob_wtrn_ordchs.nss
   ----------------

   29/09/07 by Stratovarius
*/ /** @file

    Order Forged From Chaos

    White Raven (Boost)
    Level: Crusader 6, Warblade 6
    Prerequisite: Two White Raven maneuvers
    Initiation Action: 1 Standard Action
    Range: 30 ft.
    Area: 30 ft radius.

    You bark a series of stern orders, directing your comrades to shift formation.
    The power of your presence is such that they obey without consciously thinking about it.
    
    All allies within range double their movement speed for one round.
*/

#include "tob_inc_move"
#include "tob_movehook"
//#include "prc_alterations"

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
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        effect eFast = EffectMovementSpeedIncrease(199);
    	effect eLink = ExtraordinaryEffect(EffectLinkEffects(eFast, eDur));
	location lTarget = GetLocation(oTarget);
	// Affect allies
       	object oAreaTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), lTarget, TRUE, OBJECT_TYPE_CREATURE);
       	while(GetIsObjectValid(oAreaTarget))
       	{
       	    // Get Allies
       	    if(GetIsFriend(oAreaTarget, oInitiator))
       	    {
       	    	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oAreaTarget, 6.0);
       	    }

       	    //Select the next target within the spell shape.
       	    oAreaTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), lTarget, TRUE, OBJECT_TYPE_CREATURE);
       	}
    }
}