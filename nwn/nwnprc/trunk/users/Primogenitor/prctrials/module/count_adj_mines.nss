#include "inc_constants"
/*
    This function returns the number of mines present around a certain specific
    location. It's a bit clunky for my tastes but I'm not quite sure how to do
    it otherwise.

    This is meant to be called by ExecuteScript, directly on a tile. This means
    that the first two references to OBJECT_SELF are references to that tile.
*/
void main()
{
    object oTile;
    int xpos = GetLocalInt(OBJECT_SELF, "xpos");
    int ypos = GetLocalInt(OBJECT_SELF, "ypos");
    int nCol, nRow, nNumber = 0;
    string sGridSize = IntToString(GridSize());


    /* Okay, here's how it works. I have a central (x,y) position.
     * I get EVERY one of the 8 tiles around it as oTile, look to see if oTile has a mine
     * and if yes, increment nNumber by 1 (nNumber will be the return value at the end).
     * Brief reminder, "mine_status" set to -1 denotes the presence of a mine.
     *
     * I retrieve oTile using the tile tag, which is the reason why unique tags with the
     * (x,y) position written inside makes sense. The Grid size is also unique to a single
     * area, so we can have games of different sizes running simultaneously and we can
     * still retrieve the correct tile.
     *
     */

    for (nCol = ypos - 1; nCol <= (ypos + 1); nCol++)
    {
        for (nRow = xpos - 1; nRow <= (xpos + 1); nRow++)
        {
            if (nCol != ypos || nRow != xpos) //Gotcha! (nCol == ypos && nRow == xpos) is the middle position.
            {                                 //We don't want to count it.
                oTile = GetObjectByTag("Tile_" + sGridSize + "_" +
                                       IntToString(nRow) + "_" + IntToString(nCol));

                //Quick check to see if oTile is valid, it might not be if we're at the borders.
                if (GetIsObjectValid(oTile))
                {
                    if (GetLocalInt(oTile, "mine_status") == -1)
                        nNumber++;
                }
            }
        }
    }

    SetLocalInt(OBJECT_SELF, "mine_status", nNumber);
}
