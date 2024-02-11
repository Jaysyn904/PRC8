#include "inc_constants"
#include "nw_o0_itemmaker"
#include "inc_campgnarrays"

/*
    endgame.nss. Contains functions to end the game.

    This script is on its own to prevent a possible TMI.. I'm not taking a risk there.

    There are a few references to OBJECT_SELF, since this is called by ExecuteScript.
    This is supposed to be executed on the Statistics counter.
*/

//Function prototypes

//Set the "game won" condition. Prevents all further actions until board
//has been reset
void WinGame();

//Set the "game lost" condition. Prevents all further actions until board
//has been reset. Also explodes all mines.
void LoseGame();

//Set the proper statistics for nice displaying.
// - oStatCounter:  The object which will store the statistics.
void SetStatistics(object oCounter, int iWon);

//Private function - check where the current player's stats would be in the list
int GetStatsListPosition(int iSeconds);

//Private function - adds player to statistics list, at a certain position
void AddToStatsList(int iPos, string sPCName, int iSeconds);

//One variable that's REALLY global to this script.
int nGridSize = GridSize();
int MINE_AMOUNT = MineAmount(nGridSize);

//Function bodies

void main()
{
    //This if...else block has a final else which should catch any potential errors.
    //It should never have to fire, though.

    if (GetLocalInt(OBJECT_SELF, "game_status") == -2)
        DelayCommand(2.0, LoseGame());
    else if (GetLocalInt(OBJECT_SELF, "game_status") == -1)
        DelayCommand(2.0, WinGame());
    else
        SpeakString("ERROR in endgame.nss -> Endgame condition not satisfied");
}

void WinGame()
{
    int nCol, nRow;
    object oTile, oStatCounter = GetObjectByTag("StatisticsCounter_" + IntToString(nGridSize));
    effect eMineHere;

    //Give a flag effect to all tiles that aren't flagged already!
    for (nCol = 1; nCol <= nGridSize; nCol++) //y coordinates
    {
        for (nRow = 1; nRow <= nGridSize; nRow++) //x coordinates
        {
            oTile = GetObjectByTag("Tile_" + IntToString(nGridSize) + "_" +
                                   IntToString(nRow) + "_" + IntToString(nCol));

            if (GetIsObjectValid(oTile))
            {
                if (GetLocalInt(oTile, "mine_status") == -1) //tile has a mine
                {
                    if (GetLocalInt(oTile, "tile_state") == 0) //but tile isn't flagged
                    {
                        eMineHere = SupernaturalEffect(EffectVisualEffect(VFX_DUR_FLAG_RED));
                        SetLocalInt(oTile, "tile_state", 2);
                        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eMineHere, oTile);
                    }
                    eMineHere = SupernaturalEffect(EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MAJOR));
                    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eMineHere, oTile);
                }
            }
        }
    }

    SetStatistics(oStatCounter, 1);

}

void LoseGame()
{
    int nCol, nRow;
    location lTile;
    object oTile, oStatCounter = GetObjectByTag("StatisticsCounter_" + IntToString(nGridSize));
    string sNewTag = "Mark_" + IntToString(nGridSize) + "_MineX";

    //Explode all tiles that aren't exploded!
    for (nCol = 1; nCol <= nGridSize; nCol++) //y coordinates
    {
        for (nRow = 1; nRow <= nGridSize; nRow++) //x coordinates
        {
            oTile = GetObjectByTag("Tile_" + IntToString(nGridSize) + "_" +
                                   IntToString(nRow) + "_" + IntToString(nCol));

            if (GetIsObjectValid(oTile))
            {
                if (GetLocalInt(oTile, "mine_status") == -1) //tile has a mine
                {
                    if (GetLocalInt(oTile, "tile_state") == 0) //but tile isn't flagged - IMPORTANT
                    {                                                //if a mine has a flag, it doesn't go boom!
                        lTile = GetLocation(oTile);
                        CreateObject(OBJECT_TYPE_PLACEABLE, "mark_minex", lTile, FALSE, sNewTag);
                        DestroyObject(oTile);

                        effect eExplosion = EffectVisualEffect(VFX_FNF_FIREBALL);
                        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplosion, lTile);

                    }
                }
            }
        }
    }

    SetStatistics(oStatCounter, 0);

}

void SetStatistics(object oCounter, int iWon)
{

    int iTemp, iSeconds;
    string sWinnerName, sDB = "NeverSweeperDB";
    string sNames = "WinnerList_Names_" + IntToString(nGridSize);
    string sTime = "WinnerList_Time_" + IntToString(nGridSize);

    sWinnerName = GetLocalString(oCounter, "current_player");

    //Hey, for the heck of it... add the number of mines the player played with to his name.
    sWinnerName += " (" + IntToString(MINE_AMOUNT) + " mines)";

    //Update some local variables in a pseudoarray, to keep track of those last
    //5 players who played on THIS grid
    SetLocalArrayString(oCounter, "last_name_list", 5,
                          GetLocalArrayString(oCounter, "last_name_list", 4));
    SetLocalArrayString(oCounter, "last_name_list", 4,
                          GetLocalArrayString(oCounter, "last_name_list", 3));
    SetLocalArrayString(oCounter, "last_name_list", 3,
                          GetLocalArrayString(oCounter, "last_name_list", 2));
    SetLocalArrayString(oCounter, "last_name_list", 2,
                          GetLocalArrayString(oCounter, "last_name_list", 1));
    SetLocalArrayString(oCounter, "last_name_list", 1, sWinnerName);


    //If the player didn't win, we just want to update the "last played" list.
    if (!iWon)
        return;


    //Find the Hours, Seconds and minutes passed since started.
    iSeconds  = GetTimeSecond() - GetLocalArrayInt(oCounter, "time", 6);
    iSeconds += (GetTimeMinute() * 60) - (GetLocalArrayInt(oCounter, "time", 5) * 60);
    iSeconds += FloatToInt(HoursToSeconds(GetTimeHour())) -
                FloatToInt(HoursToSeconds(GetLocalArrayInt(oCounter, "time", 4)));


    //Find the days, months and years passed since started. Why? Just in case.
    iTemp = GetCalendarDay() - GetLocalArrayInt(oCounter, "time", 3);
    iSeconds += FloatToInt(HoursToSeconds(iTemp * 24));

    iTemp = GetCalendarMonth() - GetLocalArrayInt(oCounter, "time", 2);
    iSeconds += FloatToInt(HoursToSeconds(iTemp * 28 * 24));

    iTemp = GetCalendarYear() - GetLocalArrayInt(oCounter, "time", 1);
    iSeconds += FloatToInt(HoursToSeconds(iTemp * 12 * 28 * 24));



    //Find what position in the high score table the current player would be
    iTemp = GetStatsListPosition(iSeconds);
    //if the position is 11, that means the player is OFF the list. Stop now.
    if (iTemp == 11)
        return;

    AddToStatsList(iTemp, sWinnerName, iSeconds);

}

int GetStatsListPosition(int iSeconds)
{
    int iTemp, i;
    string sDB = "NeverSweeperDB";
    string sNames = "WinnerList_Names_" + IntToString(nGridSize);
    string sTime = "WinnerList_Time_" + IntToString(nGridSize);

    /* Loop through the NeverSweeper database. At every position in our hiscore
    list, check if the current player has a HIGHER score than the current position.
    If he does, return that position.
    If the loop doesn't return anything, the player isn't worthy of the list! :)
    So 11 is returned at the bottom.
    Note the if/else. The "else" will fire if we meet an empty entry in the database
    -- if we meet that empty entry, we assume to automatically fill it.
    */
    for (i = 1; i <= 10; i++)
    {
        if (GetCampaignArrayInt(sDB, sTime, i))
        {
            iTemp = 0 + (GetCampaignArrayInt(sDB, sTime, i));

            if (iSeconds < iTemp)
                return i;
        }
        else
            return i;
    }

    return 11;
}

void AddToStatsList(int iPos, string sPCName, int iSeconds)
{

    int i;
    string sDB = "NeverSweeperDB";
    string sNames = "WinnerList_Names_" + IntToString(nGridSize);
    string sTime = "WinnerList_Time_" + IntToString(nGridSize);

    //If we need to add the player to hi-score position 10, it's easy
    if (iPos == 10)
    {

        SetCampaignArrayString(sDB, sNames, iPos, sPCName);
        SetCampaignArrayInt(sDB, sTime, iPos, iSeconds);

        return;
    }

    //Bit more complex. Loop from positions 9 to 1 in the DB array
    // - if the position actually contains data, shift it down 1 position.
    //This stops after we shifted away data at the position we plan to insert
    //new data.
    i = 9;
    do {

        if (GetCampaignArrayInt(sDB, sTime, i))
        {
            SetCampaignArrayString(sDB, sNames, (i + 1),
                                   GetCampaignArrayString(sDB, sNames, i));
            SetCampaignArrayInt(sDB, sTime, (i + 1),
                                   GetCampaignArrayInt(sDB, sTime, i));
        }

        i--;
    } while (i != iPos);

    //Now insert the new high score.
    SetCampaignArrayString(sDB, sNames, iPos, sPCName);
    SetCampaignArrayInt(sDB, sTime, iPos, iSeconds);

}
