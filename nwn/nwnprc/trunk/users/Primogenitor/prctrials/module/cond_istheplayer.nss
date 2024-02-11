//TRUE if the person in the conversation is the current player.
//this implies a game is running.

int StartingConditional()
{
    if (GetLocalInt(OBJECT_SELF, "game_status") !=  0 &&
        GetLocalInt(OBJECT_SELF, "game_status") != -1 &&
        GetLocalInt(OBJECT_SELF, "game_status") != -2 &&
        GetLocalString(OBJECT_SELF, "current_player") == GetName(GetPCSpeaker()))
    {
        return TRUE;
    }

    return FALSE;
}
