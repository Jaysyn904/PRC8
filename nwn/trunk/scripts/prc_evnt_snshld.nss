//::///////////////////////////////////////////////
//:: Name      Sonic Shield: OnEnter
//:: FileName  sp_sonic_shldA.nss
//:://////////////////////////////////////////////
/**@file Sonic Shield
Evocation
Level: Bard 3, duskblade 5, sorcerer/wizard 5
Components: V,S
Casting Time: 1 standard action
Range: Personal
Target: You
Duration: 1 round/level

This spell grants you a +4 deflection bonus to AC.
In addition, anyone who successfully hits you with
a melee attack takes 1d8 points of sonic damage 
and must make a Fortitude saving throw or be
knocked 5 feet away from you into an unoccupied
space of your choice. If no space of sufficient
size is available for it to enter, it instead
takes an extra 1d8 points of sonic damage.
**/

#include "prc_inc_spells"
#include "prc_add_spell_dc"

void DoPush(object oTarget, object oPC, int nReverse = FALSE);

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nDC = PRCGetSaveDC(oTarget, oPC);
    
    if(GetHasSpellEffect(SPELL_SONIC_SHIELD, oPC))
    {
	    // Make Save
	    if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
	    {
	        //Fire cast spell at event for the target
	        SignalEvent(oTarget, EventSpellCastAt(oPC, SPELL_SONIC_SHIELD));
	
	        // Punt them out of the area
	        DoPush(oTarget, oPC);
	    }
	}
	else
	{
		RemoveEventScript(GetItemInSlot(INVENTORY_SLOT_CHEST, oPC), EVENT_ITEM_ONHIT, "prc_evnt_snshld", TRUE, FALSE);
		RemoveEventScript(GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC), EVENT_ITEM_ONHIT, "prc_evnt_snshld", TRUE, FALSE);
	}
}

void DoPush(object oTarget, object oPC, int nReverse = FALSE)
{
    // Calculate how far the creature gets pushed
    float fDistance = FeetToMeters(5.0f);
    // Determine if they hit a wall on the way
    location lCreator   = GetLocation(oPC);
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
