#include "inc_constants"
#include "inc_campgnarrays"
#include "nw_o0_itemmaker"


/*
    Displays some game statistics when the Stats Counter is used.
*/

//Takes an integer. Adds a 0 in front if the int is less than 9.
//returns that as a string.
string FormatIntNicely(int iToFormat);

void main()
{
    int i, iTemp, nGridSize = GridSize();
    string sGridSize = IntToString(nGridSize);
    string sLastPlayers = "Last 5 players\n\n";
    string sHiScore = "Top 10 fastest (hh:mm:ss)\n\n";
    string sCTBase = sGridSize+sGridSize;
    string sDB = "NeverSweeperDB";
    string sNames = "WinnerList_Names_" + sGridSize;
    string sTime = "WinnerList_Time_" + sGridSize;
    object oPC = GetLastUsedBy();


    //Say whether the game is running or not. And if it's not running, AND the board
    //isn't clear, then say whether the last player won or lost.
    if (GetLocalInt(OBJECT_SELF, "game_status") == 0 )
    {
        SetCustomToken(StringToInt(sCTBase), "Game is not running, game board is clear.");
    }
    else if (GetLocalInt(OBJECT_SELF, "game_status") == -1)
    {
        SetCustomToken(StringToInt(sCTBase), "Current game finished: Last player won!");
    }
    else if (GetLocalInt(OBJECT_SELF, "game_status") == -2 )
    {
        SetCustomToken(StringToInt(sCTBase), "Current game finished: Last player lost.");
    }
    else
    {
        SetCustomToken(StringToInt(sCTBase), "A game is currently running, played by "
                                           + GetLocalString(OBJECT_SELF, "current_player"));
    }

    //Initialise Hiscore conversation token. Just one, though with line breaks
    for (i = 1; i <= 10; i++)
    {
        iTemp = GetCampaignArrayInt(sDB, sTime, i);
        if (iTemp)
        {
            sHiScore += IntToString(i) + ". " + GetCampaignArrayString(sDB, sNames, i) + ", in " +
                        FormatIntNicely(iTemp / 3600) + ":" +
                        FormatIntNicely((iTemp % 3600) / 60) + ":" +
                        FormatIntNicely((iTemp % 3600) % 60) + "\n";
        }
        else
            sHiScore += IntToString(i) + ". \n";
    }
    SetCustomToken(StringToInt(sCTBase + "1"), sHiScore);

    //Initialise 'last players' conversation token. Like above, just one.
    for (i = 1; i <= 5; i++)
    {
        sLastPlayers += IntToString(i) + ". " +
                       GetLocalArrayString(OBJECT_SELF, "last_name_list", i) + "\n";
    }
    SetCustomToken(StringToInt(sCTBase + "2"), sLastPlayers);

    AssignCommand(oPC, ClearAllActions());
    ActionStartConversation(oPC, ("stats_"+sGridSize), TRUE);

}

string FormatIntNicely(int iToFormat)
{
    if (iToFormat <= 9 && iToFormat >= 0)
        return "0" + IntToString(iToFormat);
    else
        return IntToString(iToFormat);
}
