/*
   ----------------
   Feigned Opening

   tob_stsn_fgnopn
   ----------------

   15/07/07 by Stratovarius
*/ /** @file

    Feigned Opening

    Setting Sun (Counter)
    Level: Swordsage 3
    Prerequisite: One Setting Sun maneuver.
    Initiation Action: 1 Swift Action
    Range: Melee.
    Target: One Creature.

    You show your opponent a seemingly fatal mistake in your defenses, but easily avoid
    the ensuing attack and simultaneously draw your foe into overextending. As she fights
    to regain her balance, you make a swift counterattack.
    
    You provoke an attack of opportunity from a creature. If it misses, you get an attack against
    the creature. If it hits, all of your allies who threaten that creature can make an attack against it.
*/

#include "tob_inc_move"
#include "tob_movehook"
//#include "prc_alterations"

void TOBAttack(object oTarget, object oInitiator)
{
    	effect eNone;
    	object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator);
    	// First attack, the monster's AoO
	PerformAttack(oInitiator, oTarget, eNone, 0.0, 0, 0, 0, "Feigned Opening Hit", "Feigned Opening Miss");
       
        if (GetLocalInt(oInitiator, "PRCCombat_StruckByAttack"))
    	{
		location lTarget = GetLocation(oTarget);
		// Use the function to get the closest creature as a target
        	object oAreaTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
        	while(GetIsObjectValid(oAreaTarget))
        	{
        	    // Don't hit yourself
        	    // Make sure the target is both next to the one struck and within melee range of the caster
        	    // Don't hit the one already struck
        	    if(oAreaTarget != oInitiator && // You don't get to attack
        	       GetIsInMeleeRange(oAreaTarget, oTarget) && // Have to be within range
        	       GetIsFriend(oAreaTarget, oInitiator) && // Only your allies get to attack
        	       oAreaTarget != oTarget) // Ensures the creature can't attack itself
        	    {
        	        // Perform the Attack
 			effect eVis = EffectVisualEffect(VFX_IMP_STUN);
 			oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oAreaTarget);
			PerformAttack(oTarget, oAreaTarget, eVis, 0.0, 0, 0, GetWeaponDamageType(oWeap), "Feigned Opening Hit", "Feigned Opening Miss");
        	    }
	
        	    //Select the next target within the spell shape.
        	    oAreaTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
        	}// end while - Target loop
    	}
    	else
    	{
    		PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, 0, 0, "Feigned Opening Hit", "Feigned Opening Miss");
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

