#include "inc_constants"

/*
    If a player leaves the grid area and he was the player currently in a game,
    the game board is cleared and the game is reset.

    If you wanted to play, why'd you leave the board, hm?
*/

void main()
{
    object oPC = GetEnteringObject();

    //Stop now if this isn't a player.
    if (!GetIsPC(oPC))
        return;

    int nGridSize = GridSize();
    object oStatCounter = GetObjectByTag("StatisticsCounter_" + IntToString(nGridSize));

    //If the names match, then clear the board.
    //Duplicate names would bork this. Let's hope it doesn't happen.
    if (GetLocalString(oStatCounter, "current_player") == GetName(oPC))
    {
        ExecuteScript("cnv_clearboard", oStatCounter);
    }
}
