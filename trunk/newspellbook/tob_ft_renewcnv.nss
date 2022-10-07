//:://////////////////////////////////////////////
//:: Psychic Renewal Conversation
//:: tob_ft_renewcnv
//:://////////////////////////////////////////////
/** @file
    As a swift action, you can recover any 
    expended maneuver by expending your 
    psionic focus and spending power points 
    equal to the maneuver's level.


    @author Stratovarius
    @date   Created  - 7.11.2018
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_dynconv"
#include "tob_inc_recovery"
#include "psi_inc_ppoints"

//////////////////////////////////////////////////
/* Constant definitions                          */
//////////////////////////////////////////////////

const int STAGE_SELECT_MANEUVER        = 0;

void main()
{
    object oPC = GetPCSpeaker();
    int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);
    int nStage = GetStage(oPC);

    int nClass = GetPrimaryBladeMagicClass(oPC);
    int nPP = GetCurrentPowerPoints(oPC);

    // Check which of the conversation scripts called the scripts
    if(nValue == 0) // All of them set the DynConv_Var to non-zero value, so something is wrong -> abort
    {
    	if(DEBUG) DoDebug("tob_ft_renewcnv: Aborting due to error.");
        return;
    }

    if(nValue == DYNCONV_SETUP_STAGE)
    {
        if(DEBUG) DoDebug("tob_ft_renewcnv: Running setup stage for stage " + IntToString(nStage));
        // Check if this stage is marked as already set up
        // This stops list duplication when scrolling
        if(!GetIsStageSetUp(nStage, oPC))
        {
            if(DEBUG) DoDebug("tob_ft_renewcnv: Stage was not set up already. nStage: " + IntToString(nStage));
            // Maneuver selection stage
            if(nStage == STAGE_SELECT_MANEUVER)
            {
                if(DEBUG) DoDebug("tob_ft_renewcnv: Building maneuver selection");
            	int nMoveId;
                string sToken = "Select a Maneuver to recover.";
                SetHeader(sToken);
                
                // Max number of expended maneuvers. Storing starts at 1
                int i;
		        for(i = 1; i < 13; i++)
		        {	
			        nMoveId = GetLocalInt(oPC, "ManeuverExpended" + IntToString(nClass) + IntToString(i));
			        // If it is not 0, it is a MoveId
			        if (nMoveId != 0)
			        {
                        if (nPP >= GetManeuverLevel(oPC, nMoveId)) // PC needs enough power points to recover the maneuver
                        {
				            AddChoice(GetManeuverName(nMoveId), i, oPC);
                            SetLocalInt(oPC, "PsychicRecover" + IntToString(i), nMoveId);
				            if(DEBUG) DoDebug("tob_ft_renewcnv: Expended Maneuvers: " + GetManeuverName(nMoveId));
                        }    
			        }
                }
                AddChoice("Exit Conversation", -1, oPC);

                MarkStageSetUp(STAGE_SELECT_MANEUVER, oPC);
            }
        }

        // Do token setup
        SetupTokens();
    }
    else if(nValue == DYNCONV_EXITED)
    {
        if(DEBUG) DoDebug("tob_ft_renewcnv: Running exit handler");
        // End of conversation cleanup
        DeleteLocalInt(oPC, "nClass");
        DeleteLocalInt(oPC, "nManeuver");
        DeleteLocalInt(oPC, "nManeuverLevelToBrowse");
        DeleteLocalInt(oPC, "ManeuverListChoiceOffset");
        
        // Delete any stored recovery variables
        int i;
        for(i = 1; i < 13; i++)
        {   
            DeleteLocalInt(oPC, "PsychicRecover" + IntToString(i));
        }         
    }
    else if(nValue == DYNCONV_ABORTED)
    {
        // This section should never be run, since aborting this conversation should
        // always be forbidden and as such, any attempts to abort the conversation
        // should be handled transparently by the system
        if(DEBUG) DoDebug("tob_ft_renewcnv: ERROR: Conversation abort section run");
    }
    // Handle PC response
    else
    {
        int nChoice = GetChoice(oPC);
        if(DEBUG) DoDebug("tob_ft_renewcnv: Handling PC response, stage = " + IntToString(nStage) + "; nChoice = " + IntToString(nChoice) + "; choice text = '" + GetChoiceText(oPC) +  "'");
	    if(nStage == STAGE_SELECT_MANEUVER)
        {
                int nMoveId = GetLocalInt(oPC, "PsychicRecover" + IntToString(nChoice));
                if(DEBUG) DoDebug("tob_ft_renewcnv: nReadyMoveId: " + IntToString(nMoveId));
                RecoverManeuver(oPC, nClass, nMoveId);
                LosePowerPoints(oPC, GetManeuverLevel(oPC, nMoveId));

                // Delete the stored offset
                DeleteLocalInt(oPC, "ManeuverListChoiceOffset");
                DeleteLocalInt(oPC, "nClass");
                DeleteLocalInt(oPC, "nManeuver");
                DeleteLocalInt(oPC, "nManeuverLevelToBrowse");
                
                // Delete all other expended maneuvers
                int i;
                for(i = 1; i < 13; i++)
                {   
                    DeleteLocalInt(oPC, "PsychicRecover" + IntToString(i));
                }                
              
                // And we're all done
                AllowExit(DYNCONV_EXIT_FORCE_EXIT); 
         }
         else
         {
                nStage = STAGE_SELECT_MANEUVER;
         }

         if(DEBUG) DoDebug("tob_ft_renewcnv: New stage: " + IntToString(nStage));

         // Store the stage value. If it has been changed, this clears out the choices
         SetStage(nStage, oPC);
    }
}
