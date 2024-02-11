//TRUE if a game is running.

int StartingConditional()
{
    if (GetLocalInt(OBJECT_SELF, "game_status") !=  0 &&
        GetLocalInt(OBJECT_SELF, "game_status") != -1 &&
        GetLocalInt(OBJECT_SELF, "game_status") != -2)
    {
        return TRUE;
    }

    return FALSE;
}
