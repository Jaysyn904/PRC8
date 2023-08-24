/*
03/02/21 by Stratovarius

Leraje, the Green Herald
  
Once a favored servant of the primary deity of the elves, Leraje allowed her pride to become her downfall. 
Leraje gives her summoners the ability to bring a bow to hand at will, to fire it with accuracy, and to 
damage a foe’s sense of self with it. In addition, she gives her hosts keen vision in darkness and skill at hiding.

Vestige Level: 1st
Binding DC: 15
Special Requirement: Leraje hates Amon for some unknown reason and will not answer your call if you are already bound to him.

Ricochet: As a standard action, you can make a ranged attack against two adjacent targets. 
*/

#include "prc_inc_combat"

void main()
{
    object oBinder    = OBJECT_SELF;
    object oTarget       = PRCGetSpellTargetObject();
	object oWeapon       = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oBinder);
	effect eNone;

    if(GetWeaponRanged(oWeapon))
    {
		PerformAttack(oTarget, oBinder, eNone, 0.0, 0, 0, 0, "Ricochet Hit", "Ricochet Miss");
		location lTarget = GetLocation(oTarget);
		// Use the function to get the closest creature as a target
		object oAreaTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
		while(GetIsObjectValid(oAreaTarget))
		{
		    // Don't hit yourself
		    // Make sure the target is within melee range of the initiator
		    // Don't hit the one already struck
		    if(oAreaTarget != oBinder &&
		       GetIsInMeleeRange(oAreaTarget, oTarget) &&
		       GetIsEnemy(oTarget) && 
		       oAreaTarget != oTarget)
		    {
		        // Perform the Attack
				PerformAttack(oAreaTarget, oBinder, eNone, 0.0, 0, 0, 0, "Ricochet Hit", "Ricochet Miss");
				// Break when target is found
				break;
		    }
	
		//Select the next target within the spell shape.
		oAreaTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
        }
    }
}