//::///////////////////////////////////////////////
//:: Name      Repel Vermin
//:: FileName  sp_repel_vermin.nss
//:://////////////////////////////////////////////
/**@file Repel Vermin
Abjuration
Level: Brd 4, Clr 4, Drd 4, Rgr 3, Hexblade 3
Components: V, S, DF
Casting Time: 1 standard action
Range: 10 ft.
Area: 10-ft.-radius emanation centered on you
Duration: 10 min./level (D)
Saving Throw: None or Will negates; see text
Spell Resistance: Yes

An invisible barrier holds back vermin. A vermin 
with Hit Dice of less than one-third your level 
cannot penetrate the barrier. A vermin with Hit 
Dice of one-third your level or more can penetrate
the barrier if it succeeds on a Will save. Even so,
crossing the barrier deals the vermin 2d6 points 
of damage, and pressing against the barrier causes
pain, which deters most vermin.

**/

//////////////////////////////////////////////////
//:: Author: Tenjac
//:: Date:   No, thanks. I'm married now.
//////////////////////////////////////////////////

#include "prc_alterations"
#include "prc_inc_spells"

void DoPush(object oTarget, object oCreator, int nReverse = FALSE);

void main()
{
    object oTarget = GetEnteringObject();
    object oCreator = GetAreaOfEffectCreator();

    // Only affect vermin
    if(MyPRCGetRacialType(oTarget) == RACIAL_TYPE_VERMIN)
    {
   	//Fire cast spell at event for the target
    	SignalEvent(oTarget, EventSpellCastAt(oCreator, SPELL_REPEL_VERMIN));
    	
    	// Punt them out of the area
	DoPush(oTarget, oCreator);
    }
}

void DoPush(object oTarget, object oCreator, int nReverse = FALSE)
{
            // Calculate how far the creature gets pushed
            float fDistance = FeetToMeters(6.096);
            // Determine if they hit a wall on the way
            location lCreator   = GetLocation(oCreator);
            location lTargetOrigin = GetLocation(oTarget);
            vector vAngle          = AngleToVector(GetRelativeAngleBetweenLocations(lCreator, lTargetOrigin));
            vector vTargetOrigin   = GetPosition(oTarget);
            vector vTarget         = vTargetOrigin + (vAngle * fDistance);

            if(!LineOfSightVector(vTargetOrigin, vTarget))
            {
                // Hit a wall, binary search for the wall
                float fEpsilon    = 1.0f;          // Search precision
                float fLowerBound = 0.0f;          // The lower search bound, initialise to 0
                float fUpperBound = fDistance;     // The upper search bound, initialise to the initial distance
                fDistance         = fDistance / 2; // The search position, set to middle of the range

                do{
                    // Create test vector for this iteration
                    vTarget = vTargetOrigin + (vAngle * fDistance);

                    // Determine which bound to move.
                    if(LineOfSightVector(vTargetOrigin, vTarget))
                        fLowerBound = fDistance;
                    else
                        fUpperBound = fDistance;

                    // Get the new middle point
                    fDistance = (fUpperBound + fLowerBound) / 2;
                }while(fabs(fUpperBound - fLowerBound) > fEpsilon);
            }

            // Create the final target vector
            vTarget = vTargetOrigin + (vAngle * fDistance);

            // Move the target
            location lTargetDestination = Location(GetArea(oTarget), vTarget, GetFacing(oTarget));
            AssignCommand(oTarget, ClearAllActions(TRUE));
            AssignCommand(oTarget, JumpToLocation(lTargetDestination));
            
            int nDam = d6(2);
            nDam += SpellDamagePerDice(oCreator, 2);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_MAGICAL), oTarget);
}
	
	
	