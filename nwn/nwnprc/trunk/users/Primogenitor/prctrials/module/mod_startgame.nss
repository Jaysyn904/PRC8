#include "inc_constants"
/*
    When a "start game" conversation option is chosen, it ExecuteScripts this script.
    The ExecuteScript call uses the statistics object as target.
    This means this script runs on the statistics object!

    This script will set up a game board.

    Author: Gaia_Werewolf, with lots of help from Deva Winblood!
*/

//Private function
//Part 1 of the board setup.
void fnLoop1(int nCol = 0);

//Private function
//Part 2 of the board setup.
void fnLoop2(int nCurrentMine = 0);

//Private function
//Part 3 of the board setup.
void fnLoop3(int nCol = 0);

//Variables I can define global to the script. Lots of 'em. Only explicity
// intialized ones, though.
//These are, in order: The grid size, the amount of mines, the grid size as a string,
//the origin waypoint, the area of the origin and the position (vectorized) of origin.
int nGridSize    = GridSize() ,
    nMineAmount  = MineAmount(nGridSize);
string sGridSize = IntToString(nGridSize);
object oOrigin   = GetObjectByTag("WP_Origin_"+sGridSize) ,
       oArea     = GetArea(oOrigin);
vector vOrigin   = GetPosition(oOrigin);

//here for cleanliness.
const float DEFAULT_DELAY_INTERVAL = 0.01;

/* The main() function will get a local integer off OBJECT_SELF - the statistics counter.
 * If the localint is 0, the board is ready to set up.
 * If the localint is not 0, the board is already in one of the other stages of setup
 * and main() will call the appropriate function to handle the next setup stage, or
 * recurse while waiting for the localint to change.
 *
 * Possible states:
 * 0: Base state, nothing happening
 * 1: Currently working
 * 2: Tile placement done
 * 3: Mine placement done
 * 4: Mine counting done, finished (main() should stop then)
 */
void main()
{
    int nState = GetLocalInt(OBJECT_SELF, "setup_state");
    effect eBusyVFX = EffectVisualEffect(VFX_DUR_SMOKE);

    switch (nState)
    {
        case 0: SpeakString("Setting up board, please wait!");
                fnLoop1();
                break;

        //case 1:  break; //Not needed. default case will process this.

        case 2: fnLoop2();
                break;

        case 3: fnLoop3();
                break;

        default:break;
    }

    if (nState < 4)
    {
        DelayCommand(0.02, main());
    }
    else
    {
        SpeakString("Board setup is complete.");
        SetLocalInt(OBJECT_SELF, "setup_state", 0);
        SetLocalInt(OBJECT_SELF, "game_status", (nGridSize * nGridSize));
    }
}

//=============NON-MAIN FUNCTIONS============

void fnLoop1(int nCol = 0)
{
    //We have two loops, one nested in the other, to create an ?x? grid of
    //minesweeper tiles. First one row is created (inner loop does rows) then
    //gradually the other rows get filled up.

    int nRow;
    vector vTile;
    object oTile;
    location lTile;
    string sTileTag;

    nCol += 1;

    //This if statement is actually a recursive outer loop, judiciously placed to prevent TMIs.
    if (nCol <= nGridSize) // valid grid position
    {
        SetLocalInt(OBJECT_SELF, "setup_state", 1); //main() wait state

        //Every time the loop iterates, we move up a column - in physical terms, 2.5m
        vTile.y = vOrigin.y + (nCol * 2.5);

        for (nRow = 1; nRow <= nGridSize; nRow++)
        {
            //Every time the loop iterates, we move forward a row - in physical terms, 2.5m
            vTile.x = vOrigin.x + (nRow * 2.5);

            //We find the right location for a tile to be put down and create it with
            //A tag containing the grid size (for area uniqueness), x position and y position.
            lTile = Location(oArea, vTile, 0.0);
            sTileTag = "Tile_" + sGridSize + "_" + IntToString(nRow) + "_" + IntToString(nCol);
            oTile = CreateObject(OBJECT_TYPE_PLACEABLE, "base_tile", lTile, FALSE, sTileTag);

            //Now we set local integers to be able to retrieve the (x,y) position
            //of the tile in different circumstances easily. Not needed in many
            //cases but still useful.
            SetLocalInt(oTile, "xpos", nRow);
            SetLocalInt(oTile, "ypos", nCol);
        }

        //recurse this function to move up one column.
        DelayCommand(DEFAULT_DELAY_INTERVAL, fnLoop1(nCol)); // outer loop
    }
    else
    {
        //If this condition fires, we're done placing tiles and can
        //return to the main() function after setting the appropriate localint.
        DelayCommand(DEFAULT_DELAY_INTERVAL, SetLocalInt(OBJECT_SELF, "setup_state", 2));
    }
} // fnLoop1()



void fnLoop2(int nCurrentMine=0)
{
    //Now we have to create the mines. This relies on getting a random location
    //over and over again and putting mines in whatever place we find until no mines are left.
    //There's a chance we'll get a position more than once, so we keep generating
    //random positions until we find a free position to place a mine on.

    int nRow, nCol;
    object oTile;

    nCurrentMine += 1;
    Random(GetTimeMillisecond()); //randomness maker

    //This if statement is actually a recursive outer loop, judiciously placed to prevent TMIs.
    if (nCurrentMine <= nMineAmount)
    {
        SetLocalInt(OBJECT_SELF, "setup_state", 1); //main() wait state

        //This loop finds the random location until a mine-less tile is found
        //and places the mine on it.
        do {
            nRow = Random(nGridSize) + 1;
            nCol = Random(nGridSize) + 1;
            oTile = GetObjectByTag("Tile_" + sGridSize + "_" + IntToString(nRow) + "_" + IntToString(nCol));
        } while (GetLocalInt(oTile, "mine_status") == -1);

        SetLocalInt(oTile, "mine_status", -1);

        //recurse this function to move to the next mine.
        DelayCommand(DEFAULT_DELAY_INTERVAL, fnLoop2(nCurrentMine));
    }
    else
    {
        //If this condition fires, we're done placing the mines and can
        //return to the main() function after setting the appropriate localint.
        DelayCommand(DEFAULT_DELAY_INTERVAL, SetLocalInt(OBJECT_SELF, "setup_state", 3));
    }
} // fnLoop2()



void fnLoop3(int nCol = 0)
{
    int nRow;
    object oTile;

    nCol += 1;

    if (nCol <= nGridSize)
    {
        SetLocalInt(OBJECT_SELF, "setup_state", 1); //main() wait state

        for (nRow = 1; nRow <= nGridSize; nRow++)
        {
            oTile = GetObjectByTag("Tile_" + sGridSize + "_" + IntToString(nRow) + "_" + IntToString(nCol));
            //This condition below will check if the tile has a mine. If not, it will insert
            //the number of mines around it.
            if (GetLocalInt(oTile, "mine_status") != -1)
            {
                ExecuteScript("count_adj_mines", oTile);
            }
        }

        //recurse this function to move to the next tile.
        DelayCommand(DEFAULT_DELAY_INTERVAL, fnLoop3(nCol));
    }
    else
    {
        //If this condition fires, we're done counting the mines and can
        //return to the main() function after setting the appropriate localint.
        DelayCommand(DEFAULT_DELAY_INTERVAL, SetLocalInt(OBJECT_SELF, "setup_state", 4));
    }
} // fnLoop3()
