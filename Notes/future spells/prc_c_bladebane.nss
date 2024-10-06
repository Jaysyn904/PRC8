//:://////////////////////////////////////////////
//:: Short description Bladebane Conversation
//:: filename   prc_c_bladebane.nss
//:://////////////////////////////////////////////
/** @file
    

    @author Tenjac
    @date   Created  - 7/29/22
	@updater Jaysyn
	@updated 2024-10-02 10:47:03
//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_ENTRY = 0;


//////////////////////////////////////////////////
/* Aid functions                                */
//////////////////////////////////////////////////



//////////////////////////////////////////////////
/* Main function                                */
//////////////////////////////////////////////////
#include "inc_dynconv"
#include "prc_inc_racial"
#include "inc_2dacache"
#include "inc_addragebonus"

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
            if(nStage == STAGE_ENTRY)
            {
				// Set the header
				SetHeader("Choose racial type.");
				object oPC = GetPCSpeaker();  // The PC object
				string sName;  // Variable to hold the racial type name
				int racialType;  // Variable for the racial type

				// Loop through the specified racial types
				for (racialType = 0; racialType <= 52; racialType++)  // Covers all the default racialtypes + ooze & plant
				{
					// Only list specific racial groups
					if (racialType == 0 || racialType == 1 || racialType == 2 || racialType == 3 || racialType == 4 || 
						racialType == 5 || racialType == 6 || racialType == 7 || racialType == 8 || racialType == 9 || 
						racialType == 10 || racialType == 11 || racialType == 12 || racialType == 13 || racialType == 14 || 
						racialType == 15 || racialType == 16 || racialType == 17 || racialType == 18 || racialType == 19 || 
						racialType == 20 || racialType == 23 || racialType == 24 || racialType == 25 || racialType == 29 || 
						racialType == 52)
					{
						// Get the racial type name using the current racial type integer
						sName = Get2DACache("racialtypes", "Constant", racialType);  // Use racialType to get the name

						// Only add to the conversation if sName is not empty
						if (sName != "")
						{
							AddChoice(sName, racialType, oPC);  // Add the choice to the conversation
						}
					}
				}
/*             	// Set the header
            	SetHeader("Choose racial type.");
            	int i;
            	for (i=0; i <=254; i++)
            	{
            		string sName = Get2daCache("racialtypes", "Constant", i);
            		// Add responses for the PC
            		if(sName != "")
            		{
            			AddChoice(sName, i, oPC);
            		}
            	}   */             

                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            //add more stages for more nodes with Else If clauses
        }

        // Do token setup
        SetupTokens();
    }
    // End of conversation cleanup
    else if(nValue == DYNCONV_EXITED)
    {
        // Add any locals set through this conversation
    }
    // Abort conversation cleanup.
    // NOTE: This section is only run when the conversation is aborted
    // while aborting is allowed. When it isn't, the dynconvo infrastructure
    // handles restoring the conversation in a transparent manner
    else if(nValue == DYNCONV_ABORTED)
    {
        // Add any locals set through this conversation
    }
    // Handle PC responses
    else
    {
        // variable named nChoice is the value of the player's choice as stored when building the choice list
        // variable named nStage determines the current conversation node
        int nChoice = GetChoice(oPC);
        if(nStage == STAGE_ENTRY)
        {
        	int n2daLine = nChoice--;
        	SetLocalInt(oPC, "BladebaneRace", n2daLine);
            // Move to another stage based on response, for example
            //nStage = STAGE_QUUX;
        }

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}