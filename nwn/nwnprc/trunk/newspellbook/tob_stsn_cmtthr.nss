/*
   ----------------
   Comet Throw

   tob_stsn_cmtthr.nss
   ----------------

    19/08/07 by Stratovarius
*/ /** @file

    Comet Throw

    Setting Sun (Strike)
    Level: Swordsage 4
    Prerequisite: One Setting Sun maneuver.
    Initiation Action: 1 Standard Action
    Range: Melee Attack.
    Target: One Creature.
    Save: Reflex partial; see text

    You use your foe's momentum against him, throwing him through the air to crash into a second enemy.
    
    Make a trip attempt against your target. You get a +4 bonus on this attempt and cannot be tripped
    if you fail on this attempt. If you succeed on the check, your enemy is thrown 10 feet away plus 
    5 feet for every 5 you succeed on the trip check by. The target takes 4d6 damage. If there is a second
    foe within the range of the throw, he is struck by the thrown foe and takes 4d6, reflex half.
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
    	int nBonus = 4;
		if(GetItemPossessedBy(oInitiator, "WOL_Eventide") == GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator) && GetHasManeuver(MOVE_SS_COMET_THROW, CLASS_TYPE_SWORDSAGE, oInitiator)) nBonus += 2;    
    	// Trip attempt
		int nSucceed = DoTrip(oInitiator, oTarget, nBonus, FALSE, FALSE);
		// If you succeed, toss em away 10 feet and knock em down
		if (nSucceed)
		{
			int nSkill = GetLocalInt(oInitiator, "TripDifference")/5;
			// Another five feet of distance for every 5 you succeed the check by
			float fDist = 10.0 + (nSkill * 5.0);
	
			// Find the target to be tossed into		
			int nStop = FALSE;
			location lTarget;
            	object oAreaTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(fDist), GetLocation(oInitiator), TRUE, OBJECT_TYPE_CREATURE);
                while(GetIsObjectValid(oAreaTarget) && !nStop)
            	{
            		// No hitting yourself or your friends, and they need to be within hitting range.
                	if(oTarget != oAreaTarget && GetIsEnemy(oAreaTarget, oInitiator))
                	{
				lTarget = GetLocation(oAreaTarget);
				// End on the first legal target
				nStop = TRUE;
				AssignCommand(oTarget, ClearAllActions(TRUE));
				AssignCommand(oTarget, JumpToLocation(lTarget));
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectKnockdown()), oTarget, 6.0);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6(4)), oTarget);
    				
    				// Saving Throw for area target
                        	int nDamage = d6(4);
                        	// Adjust damage according to Reflex Save, Evasion or Improved Evasion
							int nDC = 13 + GetAbilityModifier(ABILITY_STRENGTH, oInitiator);
							int nBladeMed = HasBladeMeditationForDiscipline(oInitiator, GetDisciplineByManeuver(PRCGetSpellId()));;
							if (nBladeMed)
							{
								nDC += 1;
							}							
                        	nDamage = PRCGetReflexAdjustedDamage(nDamage, oAreaTarget, nDC, SAVING_THROW_TYPE_NONE);
	
                        	if(nDamage > 0)
                        	{
                        	    effect eDam = EffectDamage(nDamage);
                        	    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectKnockdown()), oAreaTarget, 6.0);
				    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oAreaTarget);
                        	}				
                	}// end if - Target validity check

                	// Get next target
                	oAreaTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(fDist), GetLocation(oInitiator), TRUE, OBJECT_TYPE_CREATURE);
            	}// end while - Target loop			
		
		
		// There were no valid targets
		if (!nStop)
		{
			// Knock em down
			_DoBullRushKnockBack(oTarget, oInitiator, fDist);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectKnockdown()), oTarget, 6.0);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6(4)), oTarget);
		}
	}
    }
}