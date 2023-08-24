/*
   ----------------
   Island of Blades

   tob_sdhd_islebld.nss
   ----------------

    01/04/07 by Stratovarius
*/ /** @file

    Island of Blades

    Shadow Hand (Stance)
    Level: Swordsage 1
    Initiation Action: 1 Swift Action
    Range: Personal.
    Target: You.
    Duration: Stance.

    You cloak yourself in a swirling nimbus of shadow energy. These shadows spin
    and flow around you, preventing any creature near you from being able to
    anticipate your attacks.
    
    If both you and an ally are in melee range of the same creature, you gain a 
    +2 bonus to attack rolls.
*/

#include "prc_inc_combat"
#include "tob_inc_move"
#include "tob_movehook"

void DoMeleeRangeCheck(object oPC, int nMoveId);

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
	// Apply a marker effect
	effect eLink = ExtraordinaryEffect(EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));   
	if (GetHasDefensiveStance(oInitiator, DISCIPLINE_SHADOW_HAND))
    		eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_ALL));
       	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
       	
      	DoMeleeRangeCheck(oInitiator, move.nMoveId);
    }
}

void DoMeleeRangeCheck(object oPC, int nMoveId)
{
	location lTarget = GetLocation(oPC);
	object oAreaTarget;
	// Flip through your enemies, seeing if there is one both in melee range of you and an ally
	object oAreaFriend = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	while(GetIsObjectValid(oAreaFriend))
	{
		// First, find the nearest ally
		if(oAreaFriend != oPC && // Can't be you
		   GetIsFriend(oAreaFriend, oPC)) // Gotta be a friend
		{
			// Now we need to loop through valid enemies
			oAreaTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
			while(GetIsObjectValid(oAreaTarget))
			{
				// Find the nearest valid target
				if(oAreaTarget != oPC && // Can't be you
				   oAreaTarget != oAreaFriend && // Can't be your friend
				   GetIsInMeleeRange(oPC, oAreaTarget) && // They must be in melee range
				   GetIsInMeleeRange(oAreaFriend, oAreaTarget) && // And with your friend
				   GetIsEnemy(oAreaTarget, oPC)) // Gotta be an enemy
				{
					// Now we apply the bonuses to both of you
					effect eVis = EffectVisualEffect(VFX_IMP_HEAD_HOLY);
       					SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
       					SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oAreaFriend);
       					effect eLink = ExtraordinaryEffect(EffectAttackIncrease(2));
       					SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, 6.0);
       					SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oAreaFriend, 6.0);
       					
		
				}
			//Select the next target within the spell shape.
			oAreaTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);				
			}
		}
	
	//Select the next target within the spell shape.
	oAreaFriend = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}
	
	// If they still have the spell, keep going
	if (GetHasSpellEffect(nMoveId, oPC))
	{
		DelayCommand(6.0, DoMeleeRangeCheck(oPC, nMoveId));
		if(DEBUG) DoDebug("DoMeleeRangeCheck: DelayCommand(6.0, DoMeleeRangeCheck(oPC, nMoveId)).");
	}
	
}