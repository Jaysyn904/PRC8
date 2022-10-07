//:://////////////////////////////////////////////
//:: Teleport location selection conversation
//:: prc_teleprt_conv
//:://////////////////////////////////////////////
/** @file
    This file builds the entries for a teleport
    target selection dialog when used with the
    dynamic conversation system.

    @author Ornedan
    @date   Created  - 2005.05.29
    @date   Modified - 2005.09.23
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_inc_teleport"


//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_MAIN           = 0;
const int STAGE_SELECTION_MADE = 1;

const int ERROR_CODE_5_again =1 ;


//////////////////////////////////////////////////
/* Aid functions                                */
//////////////////////////////////////////////////



//////////////////////////////////////////////////
/* Main function                                */
//////////////////////////////////////////////////

void main()
{
    object oPC = OBJECT_SELF;
    int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);
    int nStage = GetStage(oPC);
    int bTransViaPlants = GetLocalInt(oPC, "PRC_TransportViaPlants");

    // Check which of the conversation scripts called the scripts
    if(nValue == 0) // All of them set the DynConv_Var to non-zero value, so something is wrong -> abort
        return;

    // Build system reply
    if(nValue == DYNCONV_SETUP_STAGE)
    {
        // Check if this stage is marked as already set up
        // This stops list duplication when scrolling
        if(!GetIsStageSetUp(nStage, oPC))
        {
            // Build the list of choices
            if(nStage == STAGE_MAIN)
            {
                // Set the header text
                string sToken = GetStringByStrRef(16825270); // "Select location to use"
                SetHeader(sToken);

                int i;
                struct metalocation mlocL;
                object oArea;
                // Print the quickselections up front
                for(i = 1; i <= PRC_NUM_TELEPORT_QUICKSELECTS; i++)
                {//          Quickselection
                    sToken = GetStringByStrRef(16825271) + " " + IntToString(i) + ": ";
                    //if(GetLocalInt(oPC, "PRC_Teleport_QuickSelection_" + IntToString(i)))
                    if(GetHasTeleportQuickSelection(oPC, i))
                    {
                        //mlocL = GetLocalMetalocation(oPC, "PRC_Teleport_QuickSelection_" + IntToString(i));
                        mlocL = GetTeleportQuickSelection(oPC, i);
                        oArea = GetAreaFromMetalocation(mlocL);
                        if((bTransViaPlants && GetIsAreaNatural(oArea) && !GetIsAreaInterior(oArea))
                        || !bTransViaPlants)
                        {
                            sToken += MetalocationToString(mlocL);
                            AddChoice(sToken, -i, oPC);
                        }
                    }
                }

                // Print the contents of the array, skipping any locations not in the current module
                int nMax = GetNumberOfStoredTeleportTargetLocations(oPC);
                for(i = 0; i < nMax; i++)
                {
                    mlocL = GetNthStoredTeleportTargetLocation(oPC, i);
                    oArea = GetAreaFromMetalocation(mlocL);
                    if(oArea != OBJECT_INVALID)
                    {
                        if((bTransViaPlants && GetIsAreaNatural(oArea) && !GetIsAreaInterior(oArea))
                        || !bTransViaPlants)
                            AddChoice(MetalocationToString(mlocL), i, oPC);
                    }
                }
                
                if (nMax == 0) // This ejects people from the conversation for having no locations
                {
                    FloatingTextStringOnCreature("You do not have any teleport locations stored, aborting teleport.", oPC, FALSE);
                    // Mark the conversation as finished and allow exiting
                    AllowExit(DYNCONV_EXIT_FORCE_EXIT);
                }

                MarkStageSetUp(STAGE_MAIN, oPC);
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            // The user made their selection
            else if(nStage == STAGE_SELECTION_MADE)
            {
                // Set the header text
                string sToken = GetStringByStrRef(16825306); // "Selection made. Select finish to continue."
                SetHeader(sToken);

                // Get the metalocation to store
                int nReturn = GetLocalInt(oPC, "PRC_TeleportSelectionConvo_Selection");
                struct metalocation mlocL = nReturn < 0 ? // Is it a quickselection?
                                            GetTeleportQuickSelection(oPC, -nReturn) :
                                            GetNthStoredTeleportTargetLocation(oPC, nReturn);
                // Store the return value
                if(GetLocalInt(oPC, "PRC_TeleportTargetSelection_ReturnAsMetalocation"))
                    SetLocalMetalocation(oPC,
                                         GetLocalString(oPC, "PRC_TeleportTargetSelection_ReturnStoreName"),
                                         mlocL);
                else
                    SetLocalLocation(oPC,
                                     GetLocalString(oPC, "PRC_TeleportTargetSelection_ReturnStoreName"),
                                     MetalocationToLocation(mlocL));
                // Mark the conversation as finished and allow exiting
                //AllowExit();
                AllowExit(DYNCONV_EXIT_FORCE_EXIT);
            }
        }
        // Do token setup
        SetupTokens();
    }
    // Conversation ended normally
    else if(nValue == DYNCONV_EXITED)
    {
        // Schedule the callback script to be run
        string sScript = GetLocalString(oPC, "PRC_TeleportTargetSelection_CallbackScript");
        DelayCommand(0.3f, ExecuteScript(sScript, oPC));

        if(DEBUG) SendMessageToPC(oPC, "prc_teleprt_conv: Got target location, running script " + sScript);

        DeleteLocalInt(oPC, "PRC_TeleportSelectionConvo_Selection");
        DeleteLocalString(oPC, "PRC_TeleportTargetSelection_CallbackScript");
        DeleteLocalString(oPC, "PRC_TeleportTargetSelection_ReturnStoreName");
        DeleteLocalInt(oPC, "PRC_TeleportTargetSelection_ReturnAsMetalocation");
        DeleteLocalInt(oPC, "PRC_TransportViaPlants");
    }
    // Conversation aborted
    else if(nValue == DYNCONV_ABORTED)
    {
        DeleteLocalInt(oPC, "PRC_TeleportSelectionConvo_Selection");
        DeleteLocalString(oPC, "PRC_TeleportTargetSelection_CallbackScript");
        DeleteLocalString(oPC, "PRC_TeleportTargetSelection_ReturnStoreName");
        DeleteLocalInt(oPC, "PRC_TeleportTargetSelection_ReturnAsMetalocation");
        DeleteLocalInt(oPC, "PRC_TransportViaPlants");
    }
    else
    {
        int nChoice = GetChoice(oPC);
        if(nStage == STAGE_MAIN)
        {
            nStage = STAGE_SELECTION_MADE;
            SetLocalInt(oPC, "PRC_TeleportSelectionConvo_Selection", nChoice);
        }

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
