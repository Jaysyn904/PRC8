//::///////////////////////////////////////////////
//:: Maze area entry trigger onenter
//:: prc_maze_en_trig
//:://////////////////////////////////////////////
/** @file
    This script is used with the Maze spell's maze
    area movement control triggers. It determines
    the directions the PC can go and randomly
    selects one. If possible, it avoids moving
    to the same direction the PC came from.

    The directions possible are stored as bit flags
    on a local integer called "directions" on the
    trigger.
    The non-preferred direction is stored as
    local integer "PRC_Maze_Direction" on the creature.


    @author Ornedan
    @date   Created - 2005.10.6
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "spinc_maze"

void main()
{if(DEBUG) DoDebug("prc_maze_en_trig running");

    object oCreature = GetEnteringObject();
    int nDirection   = GetLocalInt(OBJECT_SELF, "directions"); // Assume that entries have only one exit direction

    // On triggerings other than the first, behave as a normal directing trigger
    if(GetLocalInt(oCreature, "PRC_Maze_EntryDone"))
    {
        GoDirection(oCreature, nDirection);
        return;
    }

    // Set the marker
    SetLocalInt(oCreature, "PRC_Maze_EntryDone", TRUE);

    // Store old commandability and set it to true
    SetLocalInt(oCreature, "PRC_Maze_EnteringCommandability", GetCommandable(oCreature));
    SetCommandable(TRUE, oCreature);

    // Enter cutscene mode
    SetCutsceneMode(oCreature, TRUE);

    // Start the escape HB for everyone
    AssignCommand(oCreature, MazeEscapeHB(oCreature, 100)); // Start the HB with full 10 mins (100 rounds)left

    // Is it an NPC? If so, just send it on it's way
    if(!GetIsPC(oCreature))
    {
        GoDirection(oCreature, nDirection);
    }
    // For PCs, start a conversation where they can determine whether they attempt escape or not
    else
    {
        StartDynamicConversation("prc_maze_convo", oCreature, DYNCONV_EXIT_NOT_ALLOWED, TRUE, TRUE, oCreature);
        SetLocalInt(oCreature, "PRC_Maze_PC_Waiting", TRUE);
        SetLocalInt(oCreature, "PRC_Maze_EntryHour", GetTimeHour());
        SetLocalInt(oCreature, "PRC_Maze_EntryMinute", GetTimeMinute());
        SetLocalInt(oCreature, "PRC_Maze_EntrySecond", GetTimeSecond());
        SetLocalInt(oCreature, "PRC_Maze_Entry_Direction", nDirection);
    }
}