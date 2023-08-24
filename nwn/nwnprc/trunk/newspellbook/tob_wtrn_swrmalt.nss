/*
   ----------------
   Swarming Assault

   tob_wtrn_swrmalt.nss
   ----------------

   29/09/07 by Stratovarius
*/ /** @file

    Swarming Assault

    White Raven (Strike)
    Level: Crusader 7, Warblade 7
    Prerequisite: Three White Raven maneuvers
    Initiation Action: 1 Standard Action
    Range: Melee Attack
    Target: One Creature

    You attack an opponent with brutal force, ruining his defenses. As you strike
    you call out sharp commands to your allies, spurring them to action and allowing
    them to take advantage of the opening.
    
    If you strike your foe, all allies in melee range make a single attack against the struck creature.
*/

#include "tob_inc_move"
#include "tob_movehook"
//#include "prc_alterations"

void TOBAttack(object oTarget, object oInitiator)
{
    	effect eNone;
	PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, 0, 0, "Swarming Assault Hit", "Swarming Assault Miss");
	if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
    	{
		location lTarget = GetLocation(oTarget);
		// Loop the allies
        	object oAreaTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
        	while(GetIsObjectValid(oAreaTarget))
        	{
        	    // Get Allies, make sure range
        	    if(GetIsFriend(oAreaTarget, oInitiator) && GetIsInMeleeRange(oTarget, oAreaTarget))
        	    {
        	    	// The free attack
			PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, 0, 0, "Swarming Assault Hit", "Swarming Assault Miss");
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