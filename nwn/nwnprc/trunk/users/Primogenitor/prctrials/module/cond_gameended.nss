//TRUE if a game recently ended, but the
//board isn't clear.

int StartingConditional()
{
    if (GetLocalInt(OBJECT_SELF, "game_status") == -1 ||
        GetLocalInt(OBJECT_SELF, "game_status") == -2)
    {
        return TRUE;
    }

    return FALSE;
}
