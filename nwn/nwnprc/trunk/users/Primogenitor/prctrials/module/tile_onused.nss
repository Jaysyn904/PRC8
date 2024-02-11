#include "inc_constants"

void main()
{
    int nGridSize = GridSize();
    object oStatCounter = GetObjectByTag("StatisticsCounter_" + IntToString(nGridSize));
    object oPC = GetLastUsedBy();

    if (!GetIsPC(oPC))
        return;

    /* If the tile is in a ready state, it will signal event 7051 (Uncover event)
     * at itself.
     * A non-ready state consists of
       1. Being used by the wrong player.
       2. The board is still being set up (on large boards)
       3. The tile is already being uncovered, just in case
       4. The game has stopped.
     */
    if (GetLocalString(oStatCounter, "current_player") != GetName(oPC))
    {
        FloatingTextStringOnCreature("You are not the right player!", oPC, FALSE);
    }

    if (GetLocalInt(oStatCounter, "setup_state") != 0)
    {
        FloatingTextStringOnCreature("The board is being set up, please wait!", oPC, FALSE);
    }

    if (GetLocalInt(OBJECT_SELF, "tile_state") != 1||
        GetLocalInt(oStatCounter, "game_status") <= 0)

        SignalEvent(OBJECT_SELF, EventUserDefined(7051));
}
