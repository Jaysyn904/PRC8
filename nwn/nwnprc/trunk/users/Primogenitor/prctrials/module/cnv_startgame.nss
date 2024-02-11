#include "inc_constants"
#include "nw_o0_itemmaker"
/*
    Until I get my act together and write a proper intro, this script starts
    Neversweeper from a lever.

    ~Gaia_Werewolf
 */

void main()
{
    //Variables.
    int nGridSize = GridSize();
    string sGridSize = IntToString(nGridSize);
    object oStatCounter = GetObjectByTag("StatisticsCounter_" + sGridSize);

    if (GetLocalInt(oStatCounter, "game_status") < 0)
        ExecuteScript("cnv_clearboard", oStatCounter);

    //Some localint initialization.. to tell NWN a game has started.
    SetLocalInt(oStatCounter, "game_status", (nGridSize * nGridSize));

    //Record: Name of player and time the game started, for statistics
    SetLocalString(oStatCounter, "current_player", GetName(GetPCSpeaker()));
    SetLocalArrayInt(oStatCounter, "time", 1, GetCalendarYear());
    SetLocalArrayInt(oStatCounter, "time", 2, GetCalendarMonth());
    SetLocalArrayInt(oStatCounter, "time", 3, GetCalendarDay());
    SetLocalArrayInt(oStatCounter, "time", 4, GetTimeHour());
    SetLocalArrayInt(oStatCounter, "time", 5, GetTimeMinute());
    SetLocalArrayInt(oStatCounter, "time", 6, GetTimeSecond());

    //Update a custom token so anyone in a conversation sees the new game status.
    SetCustomToken(StringToInt(sGridSize+sGridSize), "A game is currently running, played by "
                                                                 + GetLocalString(OBJECT_SELF, "current_player"));

    //Aaand here we start setting up the board.
    ExecuteScript("mod_startgame", oStatCounter);

}
