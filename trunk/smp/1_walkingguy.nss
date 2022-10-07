void main()
{
    // walks to the nearest waypoint ,if we are not already walking
    object oWP1 = GetWaypointByTag("MOVETO1");
    object oWP2 = GetWaypointByTag("MOVETO2");
    int nAction = GetCurrentAction();
    int nCommand = GetCommandable();

    // Get if we are moving
    if(nAction == ACTION_MOVETOPOINT)
    {
        SpeakString("Cannot do new move, we are moving [Action] " + IntToString(nAction) + " [Command] " + IntToString(nCommand));
    }
    else if(nCommand == FALSE)
    {
        SpeakString("Cannot do new move, uncommandable [Action] " + IntToString(nAction) + " [Command] " + IntToString(nCommand));
    }
    else
    {
        // Check distance
        if(GetDistanceToObject(oWP1) <= 1.5)
        {
            // Go to 2.
            ClearAllActions();
            SpeakString("Moving to waypoint 2 [Action] " + IntToString(nAction) + " [Command] " + IntToString(nCommand));
            ActionMoveToLocation(GetLocation(oWP2), FALSE);
        }
        else
        {
            // Else, go to 1
            ClearAllActions();
            SpeakString("Moving to waypoint 1 [Action] " + IntToString(nAction) + " [Command] " + IntToString(nCommand));
            ActionMoveToLocation(GetLocation(oWP1), FALSE);
        }
    }
}
