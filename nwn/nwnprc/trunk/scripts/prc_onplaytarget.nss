//::
//:: prc_onplaytarget.nss
//::
//::

#include "prc_inc_skills"

void DoJump(object oPC, location lTarget, int bDoKnockdown);

void DoJump(object oPC, location lTarget, int bDoKnockdown)
{
	object oTarget;
	
	location lSource 	= GetLocation(oPC);
	vector vSource		= GetPositionFromLocation(lSource);
	float fDistance		= GetDistanceBetweenLocations(lTarget, lSource);
	
	string sMessage		= "You cannot jump through a closed door.";
	
	oTarget = GetFirstObjectInShape(SHAPE_SPELLCYLINDER, fDistance, lTarget, TRUE, OBJECT_TYPE_DOOR,vSource);

	//:: Check if the first object found is a door.
	while (oTarget != OBJECT_INVALID) 
	{
		//:: Check if the door is closed.
		if (!GetIsOpen(oTarget)) 
		{
			FloatingTextStringOnCreature(sMessage, oPC, FALSE);
			DeleteLocalLocation(oPC, "TARGETING_POSITION");
			return;			
		}

		//:: Select the next target within the spell shape.	
		oTarget = GetNextObjectInShape(SHAPE_SPELLCYLINDER, fDistance, lTarget, TRUE, OBJECT_TYPE_DOOR,vSource);	
	}
	
	PerformJump(oPC, lTarget, TRUE);
	
	DeleteLocalLocation(oPC, "TARGETING_POSITION");
	
}

void main()
{
    // Get the last player to use targeting mode
    object oPC = GetLastPlayerToSelectTarget();

	string sAction = GetLocalString(oPC, "ONPLAYERTARGET_ACTION");

    // Get the targeting mode data
    object oTarget 		= GetTargetingModeSelectedObject();
    vector vTarget 		= GetTargetingModeSelectedPosition();
	float fOrientation 	= GetFacing(oPC);

    // If the user manually exited targeting mode without selecting a target, return
    if (!GetIsObjectValid(oTarget) && vTarget == Vector())
        return;

    // Save the targeting data to the PC object for later use
    location lTarget = Location(GetArea(oTarget), vTarget, fOrientation);
   
    SetLocalObject(oPC, "TARGETING_OBJECT", oTarget);
    SetLocalLocation(oPC, "TARGETING_POSITION", lTarget);

	if (sAction == "PRC_JUMP")
	{
		AssignCommand(oPC, SetFacingPoint(vTarget));
		DelayCommand(0.0f, DoJump(oPC, lTarget, TRUE));	
	}
		
}

	/* object oTarget;
	
	location lTarget 	= GetLocalLocation(oPC, "TARGETING_POSITION");
	location lSource 	= GetLocation(oPC);
	float fDistance		= GetDistanceBetweenLocations(lTarget, lSource);
	

	
	string sMessage		= "You cannot jump through a closed door.";
	
	oTarget = GetFirstObjectInShape(SHAPE_SPELLCYLINDER, fDistance, lTarget, TRUE, OBJECT_TYPE_DOOR);

	// Check if the first object found is a door.
	while (GetIsObjectValid(oTarget)) 
	{
		// Check if the door is closed.
		if (!GetIsOpen(oTarget)) 
		{
			SpeakString(sMessage);
			break;			
		}
    //Select the next target within the spell shape.
    oTarget = GetNextObjectInShape(SHAPE_SPELLCYLINDER, fDistance, lTarget, TRUE, OBJECT_TYPE_DOOR);
	}
    //location lTarget = PRCGetSpellTargetLocation();	
	
    //PerformJump(oPC, lLoc, TRUE));
	
	DelayCommand(0.0f, DoJump(oPC, lTarget, TRUE));	 */