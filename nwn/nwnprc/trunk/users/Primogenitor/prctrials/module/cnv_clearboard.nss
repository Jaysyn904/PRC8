#include "inc_constants"

/*
    cnv_clearboard.nss

    Clears the gameboard, removing all tiles, marks and number points.
    It's supposed to be called from a conversation, but can at some points be
    called from other places... like when the player leaves the area.

    This script is Executed onto the Statistics object.
*/

void main()
{
    int nCol, nRow, i, nGridSize = GridSize();
    object oTile, oOrigin = GetObjectByTag("WP_Origin_" + IntToString(nGridSize));
    object oStatCounter = GetObjectByTag("StatisticsCounter_" + IntToString(nGridSize));
    string sXTag = "Mark_" + IntToString(nGridSize) + "_MineX";
    string sNumberPointTag = "Mark_" + IntToString(nGridSize) + "_NumberPoint";

    //Loop through all possible tiles on the gameboard. Destroy them
    //if they're valid.
    for (nCol = 1; nCol <= nGridSize; nCol++) //y coordinates
    {
        for (nRow = 1; nRow <= nGridSize; nRow++) //x coordinates
        {
            oTile = GetObjectByTag("Tile_" + IntToString(nGridSize) + "_" +
                                   IntToString(nRow) + "_" + IntToString(nCol));

            if (GetIsObjectValid(oTile))
            {
                DestroyObject(oTile);
            }
        }
    }

   //reuse oTile, to find and destroy all "X" marks left by mine explosions.
    i = 0;

    do
    {
        oTile = GetObjectByTag(sXTag, i++);
        DestroyObject(oTile);
    }while (GetIsObjectValid(oTile));

    //reuse oTile, to find and destroy all 'number' marks
    i = 0;

    do
    {
        oTile = GetObjectByTag(sNumberPointTag, i++);
        DestroyObject(oTile);
    }while (GetIsObjectValid(oTile));

    //and now, reset the local variable which affects the game status.
    SetLocalInt(oStatCounter, "game_status", 0);


}
