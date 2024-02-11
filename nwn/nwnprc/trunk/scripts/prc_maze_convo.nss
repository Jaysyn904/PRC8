//:://////////////////////////////////////////////
//:: Maze: Behaviour selection convo for PCs
//:: prc_maze_convo
//:://////////////////////////////////////////////
/** @file
    This convo displays a timer for the PC
    and a choice of whether to start attempting
    escape from the maze or to wait it out.


    @author Ornedan
    @date   Created  - 2005.10.20
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "spinc_maze"

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_ENTRY = 0;
const int STAGE_EXIT  = 1;

const int SELECTION_ESCAPE = 1;
const int SELECTION_WAIT   = 2;

const int ERROR_CODE_5_FIX = 1;

//////////////////////////////////////////////////
/* Aid functions                                */
//////////////////////////////////////////////////

string GetTimeLeft(object oPC)
{
    int nSH = GetLocalInt(oPC, "PRC_Maze_EntryHour"),
        nSM = GetLocalInt(oPC, "PRC_Maze_EntryMinute"),
        nSS = GetLocalInt(oPC, "PRC_Maze_EntrySecond");
    int nCH = GetTimeHour(),
        nCM = GetTimeMinute(),
        nCS = GetTimeSecond();

    // Calculate ingame hour diff
    int nHDiff = nCH < nSH ? // Has the day changed? Since the time is 10 mins, day cannot change twice even at the fastest scale
                  (24 + nCH - nSH) : // Yes
                  (nCH - nSH)        // No
                  ;
    // Calculate real minute diff
    int nMDiff = nHDiff ? // Have full hours passed?
                  (FloatToInt(HoursToSeconds(nHDiff) / 60) + nCM - nSM) : // Yes
                  (nCM - nSM)                                        // No
                  ;
    // Calculate real second diff
    int nSDiff = nMDiff ? // Have full minutes passed?
                  ((nMDiff * 60) + nCS - nSS) : // Yes
                  (nCS - nSS)                   // No
                  ;

    // Convert the second diff to a string
    return IntToString((600 - nSDiff) / 60) + ":" + IntToPaddedString((600 - nSDiff) % 60, 2, FALSE);
}


//////////////////////////////////////////////////
/* Main function                                */
//////////////////////////////////////////////////

void main()
{if(DEBUG) DoDebug("prc_maze_convo running");
    object oPC = GetPCSpeaker();
    /* Get the value of the local variable set by the conversation script calling
     * this script. Values:
     * DYNCONV_ABORTED     Conversation aborted
     * DYNCONV_EXITED      Conversation exited via the exit node
     * DYNCONV_SETUP_STAGE System's reply turn
     * 0                   Error - something else called the script
     * Other               The user made a choice
     */
   int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);
    // The stage is used to determine the active conversation node.
    // 0 is the entry node.
    int nStage = GetStage(oPC);

    // Check which of the conversation scripts called the scripts
    if(nValue == 0) // All of them set the DynConv_Var to non-zero value, so something is wrong -> abort
        return;

    if(nValue == DYNCONV_SETUP_STAGE)
    {

        if(nStage == STAGE_ENTRY)
        {
            // Set the header
            SetHeader(GetStringByStrRef(16825700) // Do you want to attempt to escape the maze?\nIf you choose to escape, you will make a DC20 Intellicence check each round until you succeed and escape or 10 minutes pass. If you choose to wait, you will be automatically removed from the maze after 10 minutes have passed.\n\nTime left - min:sec
                    + " - " + GetTimeLeft(oPC)
                      );

            // Only add the responses once
            if(!GetIsStageSetUp(nStage, oPC))
            {
                // Add responses for the PC
                AddChoice(GetStringByStrRef(16825698), SELECTION_ESCAPE, oPC); // Attempt to escape.
                AddChoice(GetStringByStrRef(16825699), SELECTION_WAIT, oPC); // Wait here.

                MarkStageSetUp(nStage, oPC);
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
        }
        else if(nStage == STAGE_EXIT)
        {
            // Blank header and no choices
            SetHeader("");
        }

        // Do token setup
        SetupTokens();
    }
    // End of conversation cleanup
    else if(nValue == DYNCONV_EXITED)
    {
        if(DEBUG) DoDebug("prc_maze_convo: Conversation exited");

        GoDirection(oPC, GetLocalInt(oPC, "PRC_Maze_Entry_Direction"));
        // Mark the creature as having made the choice, so the HB will know to start making checks
        DeleteLocalInt(oPC, "PRC_Maze_PC_Waiting");
    }
    // Abort conversation cleanup.
    else if(nValue == DYNCONV_ABORTED)
    {
        if(DEBUG) DoDebug("prc_maze_convo: Conversation aborted");

        // The PC chose to escape by moving (technically not possible, they should be in cutscene, but eh..
        GoDirection(oPC, GetLocalInt(oPC, "PRC_Maze_Entry_Direction"));
        // Mark the creature as having made the choice, so the HB will know to start making checks
        DeleteLocalInt(oPC, "PRC_Maze_PC_Waiting");
    }
    // Handle PC responses
    else
    {
        int nChoice = GetChoice(oPC);
        if(nChoice == SELECTION_ESCAPE)
        {
            //AssignCommand(oPC, ClearAllActions(TRUE)); // Abort the convo, triggering the movement
            //nStage = STAGE_EXIT;
            AllowExit(DYNCONV_EXIT_FORCE_EXIT);
        }

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
