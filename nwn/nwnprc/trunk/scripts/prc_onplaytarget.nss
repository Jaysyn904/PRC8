//::///////////////////////////////////////////////
//:: PRC Spellbook OnTrigger Event
//:: prc_onplaytarget
//:://////////////////////////////////////////////
/*
    This is the OnTarget event used set up spell 
	attacks with the selected spell from the PRC 
	Spellbook NUI
*/
//:://////////////////////////////////////////////
//:: Updated By: Rakiov
//:: Created On: 24.05.2005
//:://////////////////////////////////////////////
#include "prc_inc_skills"
#include "prc_nui_consts"

void DoJump(object oPC, location lTarget, int bDoKnockdown);

//
// DoSpellbookAction
// This is a OnTarget event action handling the use of the NUI Spellbook's spell.
// All this should do is take the manual targeting information and send it to the
// prc_nui_sc_trggr to handle the use of the spell.
//
// Arguments:
//   oPC:object the player executing the action
//   oTarget:object the object target of the spell
//   lTarget:location the location the spell is being cast at.
//
void DoSpellbookAction(object oPC, object oTarget, location lTarget);

//
// ClearEventVariables
// Clears all the event variables used by the NUI Spellbook that coordinates with
// the OnTarget script to make sure it doesn't leave weird behavior for the next run.
//
// Arguments:
//   oPC:object the player we are removing the info from.
//
void ClearEventVariables(object oPC);

void DoJump(object oPC, location lTarget, int bDoKnockdown)
{
    object oTarget;

    location lSource    = GetLocation(oPC);
    vector vSource      = GetPositionFromLocation(lSource);
    float fDistance     = GetDistanceBetweenLocations(lTarget, lSource);

    string sMessage     = "You cannot jump through a closed door.";

    oTarget = GetFirstObjectInShape(SHAPE_SPELLCYLINDER, fDistance, lTarget, TRUE, OBJECT_TYPE_DOOR, vSource);

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

void DoSpellbookAction(object oPC, object oTarget, location lTarget)
{
    object currentTarget = oTarget;

    if (GetIsObjectValid(currentTarget))
    {
        SetLocalObject(oPC, "TARGETING_OBJECT", currentTarget);
    }
    else
    {
        SetLocalLocation(oPC, "TARGETING_POSITION", lTarget);
    }

    ExecuteScript("prc_nui_sc_trggr", oPC);
    ClearEventVariables(oPC);
}

void ClearEventVariables(object oPC)
{
    DeleteLocalObject(oPC, "TARGETING_OBJECT");
    DeleteLocalLocation(oPC, "TARGETING_POSITION");
    DeleteLocalString(oPC, "ONPLAYERTARGET_ACTION");
    DeleteLocalInt(oPC, NUI_SPELLBOOK_ON_TARGET_IS_PERSONAL_FEAT);
    DeleteLocalInt(oPC, NUI_SPELLBOOK_SELECTED_SUBSPELL_SPELLID_VAR);
}

void main()
{
    // Get the last player to use targeting mode
    object oPC = GetLastPlayerToSelectTarget();

    string sAction = GetLocalString(oPC, "ONPLAYERTARGET_ACTION");

    // Get the targeting mode data
    object oTarget      = GetTargetingModeSelectedObject();
    vector vTarget      = GetTargetingModeSelectedPosition();
    float fOrientation  = GetFacing(oPC);

    // If the user manually exited targeting mode without selecting a target, return
    // we also want to clear any existing targeting information we are sending to the script
    // so clear all event variables.
    if (!GetIsObjectValid(oTarget) && vTarget == Vector())
    {
        ClearEventVariables(oPC);
        return;
    }

    // Save the targeting data to the PC object for later use
    location lTarget = Location(GetArea(oTarget), vTarget, fOrientation);

    SetLocalObject(oPC, "TARGETING_OBJECT", oTarget);
    SetLocalLocation(oPC, "TARGETING_POSITION", lTarget);

    if (sAction == "PRC_JUMP")
    {
        AssignCommand(oPC, SetFacingPoint(vTarget));
        DelayCommand(0.0f, DoJump(oPC, lTarget, TRUE));
    }

    // this is being called by the NUI Spellbook, perform the spell action
    if (sAction == "PRC_NUI_SPELLBOOK")
    {
        DoSpellbookAction(oPC, oTarget, lTarget);
    }

}

    /* object oTarget;

    location lTarget    = GetLocalLocation(oPC, "TARGETING_POSITION");
    location lSource    = GetLocation(oPC);
    float fDistance     = GetDistanceBetweenLocations(lTarget, lSource);



    string sMessage     = "You cannot jump through a closed door.";

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

    DelayCommand(0.0f, DoJump(oPC, lTarget, TRUE));  */

