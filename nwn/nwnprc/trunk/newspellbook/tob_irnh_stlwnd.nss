/*
   ----------------
   Steel Wind

   tob_irnh_stlwnd
   ----------------

   29/03/07 by Stratovarius
*/ /** @file

    Steel Wind

    Iron Heart (Strike)
    Level: Warblade 1
    Initiation Action: 1 Standard Action
    Range: Melee Attack
    Target: Two Creatures

    You swing your weapon in broad, deadly arc, striking two foes with a single, mighty blow.
    
    Make two melee attacks, each against a different foe within melee range.
*/

#include "tob_inc_move"
#include "tob_movehook"
////#include "prc_alterations"

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
    	effect eNone;
    	int nAB = 0;
    	// If holding Kamate and not initiating the stance from the free uses
        if(GetItemPossessedBy(oInitiator, "WOL_Kamate") == GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator) && GetHasManeuver(MOVE_IH_STEEL_WIND, CLASS_TYPE_WARBLADE, oInitiator)) nAB += 1;
		DelayCommand(0.0, PerformAttack(oTarget, oInitiator, eNone, 0.0, nAB, 0, 0, "Steel Wind Hit", "Steel Wind Miss"));
		location lTarget = GetLocation(oTarget);
		// Use the function to get the closest creature as a target
		object oAreaTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
		while(GetIsObjectValid(oAreaTarget))
		{
		    // Don't hit yourself
		    // Make sure the target is within melee range of the initiator
		    // Don't hit the one already struck
		    if(oAreaTarget != oInitiator &&
		       GetIsInMeleeRange(oAreaTarget, oInitiator) &&
		       GetIsEnemy(oTarget) && 
		       oAreaTarget != oTarget)
		    {
		        // Perform the Attack
				DelayCommand(0.0, PerformAttack(oAreaTarget, oInitiator, eNone, 0.0, nAB, 0, 0, "Steel Wind Hit", "Steel Wind Miss"));
				// Break when target is found
				break;
		    }
	
		//Select the next target within the spell shape.
		oAreaTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
        }
    }
}