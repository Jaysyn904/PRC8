/*
  001_testcut

  Cutscene test

*/

#include "PHS_INC_SPELLS"

void Debug(string sString)
{
    SendMessageToPC(GetFirstPC(), sString);
}

void main()
{
    // Set cutscene mode
    Debug("Setting cutscene mode - using the special spells function");

    location lLoc = GetStartingLocation();


    PHS_ForceMovementToLocation(lLoc, VFX_FNF_TELEPORT_OUT, VFX_FNF_TELEPORT_IN);

    /*

    SetCutsceneMode(OBJECT_SELF, TRUE);

    // Attempt to make them cast a spell first
    Debug("Attempting to jump to the start point");

    if(GetCommandable(OBJECT_SELF) == FALSE)
    {
        SetCommandable(TRUE, OBJECT_SELF);
        ClearAllActions();
        ActionJumpToLocation(lLoc);
        Debug("Attempting to set back to normal 1");
        ActionDoCommand(SetCutsceneMode(OBJECT_SELF, FALSE));
        SetCommandable(FALSE, OBJECT_SELF);
    }
    else
    {
        ClearAllActions();
        JumpToLocation(lLoc);
        Debug("Attempting to set back to normal 2");
        SetCutsceneMode(OBJECT_SELF, FALSE);
    }
    */
}
