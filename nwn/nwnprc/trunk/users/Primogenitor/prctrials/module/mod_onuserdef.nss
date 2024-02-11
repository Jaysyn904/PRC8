#include "prc_alterations"

#include "inc_createnumber"
#include "inc_constants"

/* This scripts runs on the OnUserDefined event of a mine tile. I'm putting the main
 * playing logic in here to make some things easy

 If this is run on a tile, here is what the different states of "tile_state" means
 0 = Not flagged, not triggered
 1 = triggered
 2 = flagged   */

//-------Function prototypes here-------
//Explode() - destroys this tile after creating an explosion effect
//A red X should be created before Explode() is called
void Explosion(location lTarget);

//Signals an event to the 8 tiles around an (x,y) position in a grid
void SignalEventToSurroundingTiles(int nEventID, int xpos, int ypos);

//Variable that's really global to this script.
int nGridSize = GridSize();
int MINE_AMOUNT = MineAmount(nGridSize);


void main()
{
    int nEvent = GetUserDefinedEventNumber(), nTileNumber, nRowPosition, nColPosition;
    int nTemp; //general purpose temporary integer
    location lSelf;
    object oObject; //Generic object for temporary data
    object oStatCounter = GetObjectByTag("StatisticsCounter_" + IntToString(nGridSize));
    object oFlagger = GetObjectByTag("Flagger_" + IntToString(nGridSize));
    effect eMineHere;
    string sNewTag = "Mark_" + IntToString(nGridSize) + "_MineX";

    //The main switch statements, we have 3 different events that can happen.
    //I use numbers 7051+ because I happen to like them.
    switch (nEvent){

    //Case 7051 USED ON: Tile. Uncover a tile. Displays a number if there is one, and explodes
    //if a mine is there. If the mine is flagged, NOTHING SHOULD HAPPEN! Likewise,
    //this should set a LocalInt on the tile to prevent this from running more than once.
    //If a tile is destroyed and there is no mine, the Statistics counter makes a note of it.
    //(we use event 7057 for that)
    case 7051:
                if (GetLocalInt(OBJECT_SELF, "tile_state") == 1) //stop if the tile is
                    return;                                      //in a non-default state
                else if (GetLocalInt(oStatCounter, "game_status") <= 0)
                {
                    return;
                }
                else if (GetLocalInt(oFlagger, "flag_mode"))
                {
                    SignalEvent(OBJECT_SELF, EventUserDefined(7052));
                    return;
                }

                SetLocalInt(OBJECT_SELF, "tile_state", 1);
                nTileNumber = GetLocalInt(OBJECT_SELF, "mine_status");

                if (!nTileNumber) //tile's mine status is 0 - tile has nothing at all
                {
                    nRowPosition = GetLocalInt(OBJECT_SELF, "xpos");
                    nColPosition = GetLocalInt(OBJECT_SELF, "ypos");
                    SignalEventToSurroundingTiles(7051, nRowPosition, nColPosition);
                    SignalEvent(oStatCounter, EventUserDefined(7054));
                }
                else if (nTileNumber == -1) //mine status is -1 - Mine is present!
                {
                    lSelf = GetLocation(OBJECT_SELF);
                    CreateObject(OBJECT_TYPE_PLACEABLE, "mark_minex", lSelf, FALSE, sNewTag);
                    Explosion(lSelf);

                    oObject = GetLastUsedBy();
                    AssignCommand(oObject, ClearAllActions());
                    AssignCommand(oObject, ActionPlayAnimation(
                           ANIMATION_LOOPING_DEAD_BACK, 1.0, 3.0));

                    SignalEvent(oStatCounter, EventUserDefined(7057));

                }
                else
                {
                    lSelf = GetLocation(OBJECT_SELF);
                    CreateNumber(nTileNumber, lSelf);
                    SignalEvent(oStatCounter, EventUserDefined(7054));
                }

                //Whether there was a mine, a number or neither under this tile, the tile
                //vanishes, having been doomed to destruction by the fatal mouseclick...
                //Oh, the drama!
                //EDIT: Unless it has a flag.
                if (GetLocalInt(OBJECT_SELF, "tile_state") != 2)
                    DestroyObject(OBJECT_SELF, 0.1);

                break;

    //Case 7052 USED ON: Tile. Create a flag on the mine. The flag should be a visual effect.
    //Like the case above, this should set a LocalInt - maybe the same name as above.
    case 7052:
                if (GetLocalInt(OBJECT_SELF, "tile_state") == 2) //flagged
                {
                    //Tile was already flagged. Remove the flag.
                    SetLocalInt(OBJECT_SELF, "tile_state", 0);

                    eMineHere = GetFirstEffect(OBJECT_SELF);
                    while (GetIsEffectValid(eMineHere))
                    {
                        RemoveEffect(OBJECT_SELF, eMineHere);

                        eMineHere = GetNextEffect(OBJECT_SELF);
                    }
                }
                else //if (GetLocalInt(OBJECT_SELF, "tile_state") == 0) //not flagged
                {
                    //Tile was not flagged. Add one.
                    eMineHere = SupernaturalEffect(EffectVisualEffect(VFX_DUR_FLAG_RED));
                    SetLocalInt(OBJECT_SELF, "tile_state", 2);
                    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eMineHere, OBJECT_SELF);
                }

                break;

    //Case 7053 USED ON: Tile. Destroys the object with no fuss, except a mine explosion
    case 7053:
                nTileNumber = GetLocalInt(OBJECT_SELF, "mine_status");

                if (nTileNumber == -1) //mine status is -1 - Mine is present!
                {
                    lSelf = GetLocation(OBJECT_SELF);
                    CreateObject(OBJECT_TYPE_PLACEABLE, "mark_minex", lSelf, FALSE, sNewTag);
                    Explosion(lSelf);
                }

                break;

    //Case 7054 USED ON: Module Stats Counter. Tells the stat counter to decrement
    //the remaining number of tiles by 1.
    case 7054:
                nTemp = GetLocalInt(OBJECT_SELF, "game_status");
                nTemp--;
                //if we have as many tiles left as there are mines...
                if (nTemp == MINE_AMOUNT)
                {
                    SignalEvent(oStatCounter, EventUserDefined(7058));
                }
                else //keep playing
                    SetLocalInt(OBJECT_SELF, "game_status", nTemp);

                break;

    //Case 7057 USED ON: Module Stats Counter. Explodes all tiles and clears all tiles.
    //This is fairly intensive, I believe. This is the "YOU HAVE LOST!" event!
    case 7057:
                SetLocalInt(OBJECT_SELF, "game_status", -2);

                ExecuteScript("game_end", OBJECT_SELF);
                AssignCommand(OBJECT_SELF, SpeakString("Ooh, that was a live one."));

                break;
    //Case 7058 USED ON: Module Stats Counter. The "YOU HAVE WON!" event
    case 7058:
                SetLocalInt(OBJECT_SELF, "game_status", -1);

                ExecuteScript("game_end", OBJECT_SELF);
                AssignCommand(OBJECT_SELF, SpeakString("You've won!"));

                break;

    }
}

void Explosion(location lTarget)
{
    effect eExplosion = EffectVisualEffect(VFX_FNF_FIREBALL);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplosion, lTarget);

}

void SignalEventToSurroundingTiles(int nEventID, int xpos, int ypos)
{
    int nCol, nRow;
    object oTile;

    /* This works similarly to GetNumberOfAdjacentMines() in one of the other scripts.
     * but here it is reexplained.
     * I have a central (x,y) position, passed as parameters. I get EVERY one of the
     * 8 tiles around it as oTile (one at a time) and signal event 'nEventID' to it.
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
            {                                   //We don't want to count it.
                oTile = GetObjectByTag("Tile_" + IntToString(nGridSize) + "_" +
                                       IntToString(nRow) + "_" + IntToString(nCol));

                //Quick check to see if oTile is valid, it might not be if we're at the borders.
                if (GetIsObjectValid(oTile))
                {
                    SignalEvent(oTile, EventUserDefined(nEventID));
                }
            }
        }
    }
}
