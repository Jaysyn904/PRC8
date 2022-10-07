//::///////////////////////////////////////////////
//:: Name      Repulsion
//:: FileName  sp_repulsionA.nss
//:://////////////////////////////////////////////7
/** @file Repulsion
Abjuration
Level:  Clr 7, Protection 7, Sor/Wiz 6
Components:     V, S, F/DF
Casting Time:   1 standard action
Range:  Up to 10 ft./level
Area:   Up to 10-ft.-radius/level emanation centered on you
Duration:       1 round/level (D)
Saving Throw:   Will negates
Spell Resistance:       Yes

An invisible, mobile field surrounds you and prevents
creatures from approaching you. You decide how big 
the field is at the time of casting (to the limit 
your level allows). Any creature within or entering 
the field must attempt a save. If it fails, it becomes 
unable to move toward you for the duration of the 
spell. Repelled creatures’ actions are not otherwise 
restricted.

They can fight other creatures and can cast spells and 
attack you with ranged weapons. If you move closer to 
an affected creature, nothing happens. (The creature is
not forced back.) The creature is free to make melee 
attacks against you if you come within reach. If a 
repelled creature moves away from you and then tries to
turn back toward you, it cannot move any closer if it 
is still within the spell’s area.

Arcane Focus: A pair of small iron bars attached to two
small canine statuettes, one black and one white, the 
whole array worth 50 gp. 

On Enter script
**/
//////////////////////////////////////////////////////
// Author: Tenjac
// Date:   7.10.06
//////////////////////////////////////////////////////

void DoPush(object oTarget, object oCaster);


#include "prc_inc_spells"
#include "prc_add_spell_dc"
void main()
{
        object oCaster = GetAreaOfEffectCreator();
        object oTarget = GetEnteringObject();
        int nDC = PRCGetSaveDC(oTarget, oCaster);
        
        
        if(oTarget != oCaster && (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE))
        {
                //SR
                if(!PRCDoResistSpell(oCaster, oTarget, PRCGetCasterLevel(oCaster) + SPGetPenetr()))
                {
                        //Saving Throw
                        if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
                        {
                            SetLocalInt(oTarget,"repulsive",1);
                            DoPush(oTarget, oCaster);
                        }
                }
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