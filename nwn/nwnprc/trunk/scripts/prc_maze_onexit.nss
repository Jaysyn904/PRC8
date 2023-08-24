//::///////////////////////////////////////////////
//:: Maze area OnExit
//:: prc_maze_onexit
//:://////////////////////////////////////////////
/** @file
    This script is the Maze spell's maze area
    OnExit script. It will stop the cutscene mode
    and restore old commandability setting.


    @author Ornedan
    @date   Created - 2005.10.6
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "spinc_maze"


void main()
{if(DEBUG) DoDebug("prc_maze_onexit running");

    object oCreature = GetExitingObject();

    // Kill any commands the creature might have
    AssignCommand(oCreature, ClearAllActions(TRUE));

    // Restore old commandability
    int nCommandable = GetLocalInt(oCreature, "PRC_Maze_EnteringCommandability");
    AssignCommand(oCreature, SetCommandable(nCommandable, oCreature));

    // Exit cutscene mode
    SetCutsceneMode(oCreature, FALSE);

    // Clean up locals
    DeleteLocalInt(oCreature, "PRC_Maze_EnteringCommandability");
    DeleteLocalInt(oCreature, "PRC_Maze_Direction");
    DeleteLocalInt(oCreature, "PRC_Maze_EntryDone");
    DeleteLocalInt(oCreature, "PRC_Maze_PC_Waiting");
    DeleteLocalInt(oCreature, "PRC_Maze_Entry_Direction");
    DeleteLocalInt(oCreature, "PRC_Maze_EntryHour");
    DeleteLocalInt(oCreature, "PRC_Maze_EntryMinute");
    DeleteLocalInt(oCreature, "PRC_Maze_EntrySecond");
    DeleteLocalLocation(oCreature, "PRC_Maze_Return_Location");

    // Remove the cutscene ghost applied in spellscript
    effect e = GetFirstEffect(oCreature);
    while(GetIsEffectValid(e))
    {
        if(GetEffectSpellId(e) == 2888 && /// FIXME
           GetEffectType(e) == EFFECT_TYPE_CUTSCENEGHOST
           )
            RemoveEffect(oCreature, e);

        e = GetNextEffect(oCreature);
    }
}
