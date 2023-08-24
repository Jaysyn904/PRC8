//::///////////////////////////////////////////////
//:: Name      Otiluke's Resilient Sphere On Enter
//:: FileName  sp_otiluke_rsA.nss
//:://////////////////////////////////////////////
/**@file Otiluke's Resilient Sphere
Evocation [Force]
Level: Sor/Wiz 4
Components: V, S, M
Range: Short
Effect: Sphere, centered around a creature
Duration:       1 min./level (D)
Saving Throw:   Reflex negates
Spell Resistance:       Yes

A globe of shimmering force encloses a creature within
the diameter of the sphere. The sphere contains its 
subject for the spell’s duration. The sphere is not
subject to damage of any sort except from a rod of
cancellation, a rod of negation, a disintegrate spell,
or a targeted dispel magic spell. These effects destroy
the sphere without harm to the subject. Nothing can
pass through the sphere, inside or out, though the 
subject can breathe normally.

Author:    Tenjac
Created:   7/6/07
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_add_spell_dc"
void DoPush(object oTarget, object oCreator, int nReverse = FALSE);

void main()
{
    object oCaster = GetAreaOfEffectCreator();
    object oTarget = GetEnteringObject();

    //Look to see if it is for some reason the target
    if(GetLocalInt(oTarget, "PRC_OTILUKES_RS_TARGET"))
    {
        return;
    }
    else
        DoPush(oTarget, oCaster);
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

                do
                {
                        // Create test vector for this iteration
                        vTarget = vTargetOrigin + (vAngle * fDistance);
                        
                        // Determine which bound to move.
                        if(LineOfSightVector(vTargetOrigin, vTarget))
                        fLowerBound = fDistance;
                        else
                        fUpperBound = fDistance;
                        
                        // Get the new middle point
                        fDistance = (fUpperBound + fLowerBound) / 2;
                }
                while(fabs(fUpperBound - fLowerBound) > fEpsilon);
        }
        
        // Create the final target vector
        vTarget = vTargetOrigin + (vAngle * fDistance);
        
        // Move the target
        location lTargetDestination = Location(GetArea(oTarget), vTarget, GetFacing(oTarget));
        AssignCommand(oTarget, ClearAllActions(TRUE));
        AssignCommand(oTarget, JumpToLocation(lTargetDestination));
}