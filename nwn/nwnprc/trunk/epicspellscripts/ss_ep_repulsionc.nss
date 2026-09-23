//::////////////////////////////////////////////////////////
//:: Name      Epic Repulsion
//:: FileName  ss_ep_repulsionc.nss
//::////////////////////////////////////////////////////////
/** @file Epic Repulsion
School: Abjuration
Components: V,S
Range: Touch
Target: Creature or object touched
Duration: 24 hours
Saving Throw: None
Spell Resistance: Yes, see text

You can create a ward against a specific type of creature for 
the duration. Any creature of the specific type cannot come 
within the aura of the warded creature or object. Spell 
resistance can allow a creature to overcome this protection 
and enter the aura of the warded subject.

Heartbeat script
**/
//::////////////////////////////////////////////////////////
//:: Author: fluffyamoeba
//:: Date:   2008-09-05
//::
//:: Fixed By: Jaysyn
//:: Date: 2026-09-20 18:21:40
//::
//::////////////////////////////////////////////////////////

void DoPush(object oTarget, object oCaster);

#include "prc_alterations"
#include "prc_inc_spells"

void main()
{
    object oCaster = GetAreaOfEffectCreator();
    object oTarget = GetFirstInPersistentObject(OBJECT_SELF);
    while(GetIsObjectValid(oTarget))
    {
        if(oTarget != oCaster)
        {
            // check if they're supposed to be there
            if(GetLocalInt(oTarget,"EpicRepulsive"))
                DoPush(oTarget, oCaster);
        }
        //Get next target.
        oTarget = GetNextInPersistentObject(OBJECT_SELF);
    }
}

void DoPush(object oTarget, object oCaster)
{
        // Calculate how far the creature gets pushed
        float fDistance = FeetToMeters(50.0f);
        // Determine if they hit a wall on the way
        location lTrueSpeaker   = GetLocation(oCaster);
        location lTargetOrigin = GetLocation(oTarget);
        vector vAngle          = AngleToVector(GetRelativeAngleBetweenLocations(lTrueSpeaker, lTargetOrigin));
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