//:://////////////////////////////////////////////
//:: Say My Name and I am There Conversation
//:: true_saynam_conv
//:://////////////////////////////////////////////
/** @file
    This allows you to teleport to any party member


    @author Stratovarius
    @date   Created  - 4.9.2006
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

//#include "prc_alterations"
#include "true_inc_trufunc"
#include "inc_dynconv"

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_MEMBER_CHOICE = 0;
const int STAGE_CONFIRMATION  = 1;

//////////////////////////////////////////////////
/* Aid functions                                */
//////////////////////////////////////////////////


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
            if(nStage == STAGE_MEMBER_CHOICE)
            {
                // Set the header
                SetHeader("Select the party member you would like to teleport to.");

                // Add responses for the PC
                // This gets all PC party members
                object oParty = GetFirstFactionMember(oPC);
                // counter variable
                int i = 1;
		while (GetIsObjectValid(oParty)) // loop through faction
		{
			AddChoice(GetName(oParty), i, oPC);
			// Stores all the party members
			SetLocalObject(oPC, "TrueSayPartyChoice" + IntToString(i), oParty);
			i++;
			
			oParty = GetNextFactionMember(oPC);
                }
                if (DEBUG)
                {
                	object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, OBJECT_SELF, 1);
                	SetLocalObject(oPC, "TrueSayPartyChoice" + IntToString(i), oSummon);
                	AddChoice(GetName(oSummon), i, oPC);
                	i++;
                }
                SetLocalInt(oPC, "TrueSayPartyMax", i);

                MarkStageSetUp(STAGE_MEMBER_CHOICE, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_CONFIRMATION)//confirmation
            {
                object oChoice = GetLocalObject(oPC, "TrueSayPartyChoice" + IntToString(GetLocalInt(oPC, "TruePartyChoiceNum")));
                AddChoice(GetStringByStrRef(4752), TRUE); // "Yes"
                AddChoice(GetStringByStrRef(4753), FALSE); // "No"

                string sName = GetName(oChoice);
                string sText = "You have selected " + sName + " as the party member to teleport to.\n";

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
        int nCleanUp = GetLocalInt(oPC, "TrueSayPartyMax");
        int x;
	for(x = 0; x < nCleanUp; x++)
	{
		DeleteLocalObject(oPC, "TrueSayPartyChoice" + IntToString(x));
	}
        DeleteLocalInt(oPC, "TrueSayPartyMax");
        DeleteLocalInt(oPC, "TruePartyChoiceNum");
    }
    // Abort conversation cleanup.
    // NOTE: This section is only run when the conversation is aborted
    // while aborting is allowed. When it isn't, the dynconvo infrastructure
    // handles restoring the conversation in a transparent manner
    else if(nValue == DYNCONV_ABORTED)
    {
        // End of conversation cleanup
        int nCleanUp = GetLocalInt(oPC, "TrueSayPartyMax");
        int x;
	for(x = 0; x < nCleanUp; x++)
	{
		DeleteLocalObject(oPC, "TrueSayPartyChoice" + IntToString(x));
	}
        DeleteLocalInt(oPC, "TrueSayPartyMax");
        DeleteLocalInt(oPC, "TruePartyChoiceNum");
    }
    // Handle PC responses
    else
    {
        // variable named nChoice is the value of the player's choice as stored when building the choice list
        // variable named nStage determines the current conversation node
        int nChoice = GetChoice(oPC);
        if(nStage == STAGE_MEMBER_CHOICE)
        {
            nStage = STAGE_CONFIRMATION;
            SetLocalInt(oPC, "TruePartyChoiceNum", nChoice);
        }
        else if(nStage == STAGE_CONFIRMATION)//confirmation
        {
            if(nChoice == TRUE)
            {
            	if (!GetLocalInt(OBJECT_SELF, "DimAnchor"))
            	{
            		object oPM = GetLocalObject(oPC, "TrueSayPartyChoice" + IntToString(GetLocalInt(oPC, "TruePartyChoiceNum")));
            		if(DEBUG) DoDebug("Say My Name and I Am There: Target Name: " + GetName(oPM));
            		// Get Location of the target Party Member
            		location lPM   = GetLocation(oPM);
            
            		// Move the PC to the ally
            		effect eVis = EffectVisualEffect(PSI_FNF_PSYCHIC_CHIRURGY);
            		ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oPC));
            		DelayCommand(1.0, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPM));
            		AssignCommand(oPC, ClearAllActions(TRUE));
            		AssignCommand(oPC, JumpToLocation(lPM));
            		if(DEBUG) DoDebug("Say My Name and I Am There: Jumped");
                }
                else
                {
                	FloatingTextStringOnCreature("You are under a Dimensional Anchor and cannot teleport", oPC, FALSE);
                }
                
               	// And we're all done, because either they teleported or they aren't allowed to
               	AllowExit(DYNCONV_EXIT_FORCE_EXIT);                

            }
            else // Reset
            {
                nStage = STAGE_MEMBER_CHOICE;
                MarkStageNotSetUp(STAGE_MEMBER_CHOICE, oPC);
                MarkStageNotSetUp(STAGE_CONFIRMATION, oPC);
            }
        	// Clean up and start again
        	int nCleanUp = GetLocalInt(oPC, "TrueSayPartyMax");
        	int x;
		for(x = 0; x < nCleanUp; x++)
		{
			DeleteLocalObject(oPC, "TrueSayPartyChoice" + IntToString(x));
		}
        	DeleteLocalInt(oPC, "TrueSayPartyMax");
        	DeleteLocalInt(oPC, "TruePartyChoiceNum");
        }

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
