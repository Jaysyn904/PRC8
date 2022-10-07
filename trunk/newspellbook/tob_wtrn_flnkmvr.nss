/*
   ----------------
   Flanking Maneuver

   tob_wtrn_flnkmvr.nss
   ----------------

   29/09/07 by Stratovarius
*/ /** @file

    Flanking Maneuver

    White Raven (Strike)
    Level: Crusader 5, Warblade 5
    Prerequisite: Two White Raven maneuvers
    Initiation Action: 1 Standard Action
    Range: Melee Attack
    Target: One Creature

    Your keen leadership grants you and your allies a sudden advantage in combat.
    When you flank an opponent, you attack in such a way as to maximize your
    allies's openings. By the same token, your friends's ferocious, accurate
    attacks give you multiple opportunities to pierce your foe's defences.
    
    If you strike your foe and are flanking him, all allies in melee range and
    flanking your foe make a single attack against the struck creature.
*/

#include "tob_inc_move"
#include "tob_movehook"
//#include "prc_alterations"

void TOBAttack(object oTarget, object oInitiator)
{
    	effect eNone;
	PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, 0, 0, "Flanking Maneuver Hit", "Flanking Maneuver Miss");
	if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack") && GetIsFlanked(oTarget, oInitiator))
    	{
		location lTarget = GetLocation(oTarget);
		// Use the function to get the closest creature as a target
        	object oAreaTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
        	while(GetIsObjectValid(oAreaTarget))
        	{
        	    // Get Allies, make sure flanking
        	    if(GetIsFriend(oAreaTarget, oInitiator) && GetIsFlanked(oTarget, oAreaTarget))
        	    {
        	    	// The free attack
			PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, 0, 0, "Flanking Maneuver Hit", "Flanking Maneuver Miss");
        	    }
	
        	    //Select the next target within the spell shape.
        	    oAreaTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
        	}
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
    	DelayCommand(0.0, TOBAttack(oTarget, oInitiator));
    }
}