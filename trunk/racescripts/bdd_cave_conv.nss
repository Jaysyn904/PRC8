//:://////////////////////////////////////////////
//:: Cave Entrance Conversation
//:: bdd_cave_conv
//:://////////////////////////////////////////////
/** @file
    This allows the PC to attempt to climb down to the cave

    @author Stratovarius
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_dynconv"
#include "prc_misc_const"

//////////////////////////////////////////////////
/* Constant definitions                          */
//////////////////////////////////////////////////

const int STAGE_BEGIN        = 0;

//////////////////////////////////////////////////
/* Function definitions                          */
//////////////////////////////////////////////////

void main()
{
    object oPC = GetPCSpeaker();
    int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);
    int nStage = GetStage(oPC);

    // Check which of the conversation scripts called the scripts
    if(nValue == 0) // All of them set the DynConv_Var to non-zero value, so something is wrong -> abort
    {
    	if(DEBUG) DoDebug("bdd_cave_conv: Aborting due to error.");
        return;
    }

    if(nValue == DYNCONV_SETUP_STAGE)
    {
        if(DEBUG) DoDebug("bdd_cave_conv: Running setup stage for stage " + IntToString(nStage));
        // Check if this stage is marked as already set up
        // This stops list duplication when scrolling
        if(!GetIsStageSetUp(nStage, oPC))
        {
            if(DEBUG) DoDebug("bdd_cave_conv: Stage was not set up already. nStage: " + IntToString(nStage));
            // Maneuver selection stage
            if(nStage == STAGE_BEGIN)
            {
                SetHeader("As you stand on the rim of the basin, you notice a strange feature in the edge of the crater. It appears that the wide crack in the wall of the crater opens into a sand-lined cleft, and perhaps even a far deeper cave or tunnel.");
                
                AddChoice("Climb Down (Climb DC 10)", 1, oPC);
                AddChoice("Exit Conversation", -1, oPC);

                MarkStageSetUp(STAGE_BEGIN, oPC);
            }
        }

        // Do token setup
        SetupTokens();
    }
    else if(nValue == DYNCONV_EXITED)
    {
        if(DEBUG) DoDebug("bdd_cave_conv: Running exit handler");
    }
    else if(nValue == DYNCONV_ABORTED)
    {
        // This section should never be run, since aborting this conversation should
        // always be forbidden and as such, any attempts to abort the conversation
        // should be handled transparently by the system
        if(DEBUG) DoDebug("bdd_cave_conv: ERROR: Conversation abort section run");
    }
    // Handle PC response
    else
    {
        int nChoice = GetChoice(oPC);
        if(DEBUG) DoDebug("bdd_cave_conv: Handling PC response, stage = " + IntToString(nStage) + "; nChoice = " + IntToString(nChoice) + "; choice text = '" + GetChoiceText(oPC) +  "'");
	    if(nStage == STAGE_BEGIN)
        {
            if (nChoice == 1)
            {
                if (GetIsSkillSuccessful(oPC, SKILL_CLIMB, 10))
                {
                    JumpToLocation(GetLocation(GetWaypointByTag("bdd_cave_ent")));
                }
                else
                {
                    AssignCommand(oPC, SpeakString("Your attempt to clamber down to the cave has gone poorly. Sliding, losing traction, and eventually tumbling, you splash into the thick dust of basin. Moments later, hands drag you deep into the dust."));
                    DelayCommand(6.0, PopUpDeathGUIPanel(oPC, TRUE, FALSE, 0, "Your attempt to clamber down to the cave has gone poorly. Sliding, losing traction, and eventually tumbling, you splash into the thick dust of basin. Moments later, hands drag you deep into the dust."));
                }
            }
              
            // And we're all done
            AllowExit(DYNCONV_EXIT_FORCE_EXIT); 
        }
        else
        {
               nStage = STAGE_BEGIN;
        }

        if(DEBUG) DoDebug("bdd_cave_conv: New stage: " + IntToString(nStage));

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
