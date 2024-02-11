//Sets the number of mines for the next game to be 40.
//This is in a conditional script for synchronization purposes.

int StartingConditional()
{
    SetLocalInt(OBJECT_SELF, "mine_amount", 40);

    return TRUE;
}
