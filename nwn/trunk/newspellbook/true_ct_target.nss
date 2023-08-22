//:://////////////////////////////////////////////
//:: Truenaming Crafted Tool Conversation
//:: true_ct_target
//:://////////////////////////////////////////////
/** @file
    This allows you to pick the target for the Crafted Tool utterances


    @author Stratovarius
    @date   Created  - 5.8.2006
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

//#include "prc_alterations"
#include "inc_dynconv"
#include "true_inc_trufunc"

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_QUICKSLOT_CHOICE = 0;
const int STAGE_TARGET = 1;
const int STAGE_CONFIRMATION  = 2;

//////////////////////////////////////////////////
/* Aid functions                                */
//////////////////////////////////////////////////

// Just takes the slot and returns the name
string SlotToName(int nSlot)
{
    if      (nSlot == INVENTORY_SLOT_ARMS)      return "Gloves";
    else if (nSlot == INVENTORY_SLOT_BELT)      return "Belt";
    else if (nSlot == INVENTORY_SLOT_BOOTS)     return "Boots";
    else if (nSlot == INVENTORY_SLOT_CHEST)     return "Armour";
    else if (nSlot == INVENTORY_SLOT_CLOAK)     return "Cloak";
    else if (nSlot == INVENTORY_SLOT_HEAD)      return "Helmet";
    else if (nSlot == INVENTORY_SLOT_LEFTHAND)  return "Left Hand";
    else if (nSlot == INVENTORY_SLOT_LEFTRING)  return "Left Ring";
    else if (nSlot == INVENTORY_SLOT_NECK)      return "Amulet";
    else if (nSlot == INVENTORY_SLOT_RIGHTHAND) return "Right Hand";
    else if (nSlot == INVENTORY_SLOT_RIGHTRING) return "Right Ring";
    
    // if its not a slot
    return "";
}

//////////////////////////////////////////////////
/* Main function                                */
//////////////////////////////////////////////////

void main()
{
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
    if (DEBUG) DoDebug("Dynaconvo Var: " + IntToString(nValue));

    // Check which of the conversation scripts called the scripts
    if(nValue == 0) // All of them set the DynConv_Var to non-zero value, so something is wrong -> abort
        return;

    if(nValue == DYNCONV_SETUP_STAGE)
    {
        // Check if this stage is marked as already set up
        // This stops list duplication when scrolling
        if(!GetIsStageSetUp(nStage, oPC))
        {
            // variable named nStage determines the current conversation node
            // Function SetHeader to set the text displayed to the PC
            // Function AddChoice to add a response option for the PC. The responses are show in order added
            if(nStage == STAGE_QUICKSLOT_CHOICE)
            {
                // Set the header
                SetHeader("Select the Quickslot you would like to fill.");

                // Add responses for the PC
                AddChoice("Quickslot #1", 1);
                AddChoice("Quickslot #2", 2);
                AddChoice("Quickslot #3", 3);
                AddChoice("Quickslot #4", 4);

                MarkStageSetUp(STAGE_QUICKSLOT_CHOICE, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_TARGET)
            {
                // Set the header
                SetHeader("Which inventory slot would you like to fill the quickslot with?");

                // Add responses for the PC
                AddChoice(SlotToName(INVENTORY_SLOT_ARMS)     , INVENTORY_SLOT_ARMS     );
                AddChoice(SlotToName(INVENTORY_SLOT_BELT)     , INVENTORY_SLOT_BELT     );
                AddChoice(SlotToName(INVENTORY_SLOT_BOOTS)    , INVENTORY_SLOT_BOOTS    );
                AddChoice(SlotToName(INVENTORY_SLOT_CHEST)    , INVENTORY_SLOT_CHEST    );
                AddChoice(SlotToName(INVENTORY_SLOT_CLOAK)    , INVENTORY_SLOT_CLOAK    );
		AddChoice(SlotToName(INVENTORY_SLOT_HEAD)     , INVENTORY_SLOT_HEAD     );
		AddChoice(SlotToName(INVENTORY_SLOT_LEFTHAND) , INVENTORY_SLOT_LEFTHAND );
                AddChoice(SlotToName(INVENTORY_SLOT_LEFTRING) , INVENTORY_SLOT_LEFTRING );
                AddChoice(SlotToName(INVENTORY_SLOT_NECK)     , INVENTORY_SLOT_NECK     );
		AddChoice(SlotToName(INVENTORY_SLOT_RIGHTHAND), INVENTORY_SLOT_RIGHTHAND);
		AddChoice(SlotToName(INVENTORY_SLOT_RIGHTRING), INVENTORY_SLOT_RIGHTRING);

                MarkStageSetUp(STAGE_TARGET, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }            
            else if(nStage == STAGE_CONFIRMATION)//confirmation
            {
                int nChoice = GetLocalInt(oPC, "TrueQuickSlotToFill");
                int nSlot = GetLocalInt(oPC, "TrueInventorySlotToTarget");
                AddChoice(GetStringByStrRef(4752), TRUE); // "Yes"
                AddChoice(GetStringByStrRef(4753), FALSE); // "No"

                string sText = "You have selected Quickslot #" + IntToString(nChoice) + ".\n";
                sText += "The inventory slot to fill the quickslot with is " + SlotToName(nSlot) + ".\n";
                sText += "Is this correct?";

                SetHeader(sText);
                MarkStageSetUp(STAGE_CONFIRMATION, oPC);
            }
        }

        // Do token setup
        SetupTokens();
    }
    // End of conversation cleanup
    else if(nValue == DYNCONV_EXITED)
    {
        // End of conversation cleanup
        DeleteLocalInt(oPC, "TrueQuickSlotToFill");
        DeleteLocalInt(oPC, "TrueInventorySlotToTarget");
    }
    // Abort conversation cleanup.
    // NOTE: This section is only run when the conversation is aborted
    // while aborting is allowed. When it isn't, the dynconvo infrastructure
    // handles restoring the conversation in a transparent manner
    else if(nValue == DYNCONV_ABORTED)
    {
        // End of conversation cleanup
        DeleteLocalInt(oPC, "TrueQuickSlotToFill");
        DeleteLocalInt(oPC, "TrueInventorySlotToTarget");
    }
    // Handle PC responses
    else
    {
        // variable named nChoice is the value of the player's choice as stored when building the choice list
        // variable named nStage determines the current conversation node
        int nChoice = GetChoice(oPC);
        if(nStage == STAGE_QUICKSLOT_CHOICE)
        {
            nStage = STAGE_TARGET;
            SetLocalInt(oPC, "TrueQuickSlotToFill", nChoice);
        }
        else if(nStage == STAGE_TARGET)
        {
            nStage = STAGE_CONFIRMATION;
            SetLocalInt(oPC, "TrueInventorySlotToTarget", nChoice);
        }        
        else if(nStage == STAGE_CONFIRMATION)//confirmation
        {
            if(nChoice == TRUE)
            {
            	// Final target choice. Fill the chosen quickslot with the chosen inventory slot
                SetLocalInt(oPC, "TrueQuickSlot" + IntToString(GetLocalInt(oPC, "TrueQuickSlotToFill")), GetLocalInt(oPC, "TrueInventorySlotToTarget"));
                // And we're all done
                AllowExit(DYNCONV_EXIT_FORCE_EXIT);

            }
            else
            {
                nStage = STAGE_QUICKSLOT_CHOICE;

                MarkStageNotSetUp(STAGE_QUICKSLOT_CHOICE, oPC);
                MarkStageNotSetUp(STAGE_TARGET, oPC);
                MarkStageNotSetUp(STAGE_CONFIRMATION, oPC);
            }
        }

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
