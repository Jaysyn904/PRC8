//:://////////////////////////////////////////////
//:: True Resurrection Conversation
//:: sp_cnv_trures
//:://////////////////////////////////////////////
/** @file
    This lets you choose which party member to res


    @author Stratovarius
    @date   Created  - 11.10.2006
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "inc_dynconv"

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_CHOOSE_TARGET     = 0;
const int STAGE_CONFIRMATION      = 1;

//////////////////////////////////////////////////
/* Aid functions                                */
//////////////////////////////////////////////////


void StorePCForRecovery(object oPC, object oChoice, int nChoice)
{
	SetLocalObject(oPC, "TrueResTarget" + IntToString(nChoice), oChoice);
}

object RetrievePC(object oPC, int nChoice)
{
	return GetLocalObject(oPC, "TrueResTarget" + IntToString(nChoice));
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
	    if(nStage == STAGE_CHOOSE_TARGET)
            {
               	// Set the header
               	string sAmount = "Which ally would you like to resurrect?";
                SetHeader(sAmount);

                // This reads all of the legal choices 
                object oChoice = GetFirstFactionMember(oPC);
                int nChoice = 1;
		while (GetIsObjectValid(oChoice)) // People in party
		{
			// If the selection is a PC
			if (GetIsPC(oChoice) && oChoice != oPC && GetIsDead(oChoice))
			{
				AddChoice(GetName(oChoice), nChoice, oPC);
				StorePCForRecovery(oPC, oChoice, nChoice);
			}
			nChoice += 1;
			oChoice = GetNextFactionMember(oPC);
                }

                MarkStageSetUp(STAGE_CHOOSE_TARGET, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_CONFIRMATION)//confirmation
            {
                object oChoice = RetrievePC(oPC, GetLocalInt(oPC, "TrueResChoice"));
                AddChoice(GetStringByStrRef(4752), TRUE); // "Yes"
                AddChoice(GetStringByStrRef(4753), FALSE); // "No"

                string sText = "You have selected " + GetName(oChoice) + " as the ally to resurrect.\n";
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
        DeleteLocalObject(oPC, "TrueResTarget" + IntToString(GetLocalInt(oPC, "TrueResChoice")));
        DeleteLocalInt(oPC, "TrueResChoice");
    }
    // Abort conversation cleanup.
    // NOTE: This section is only run when the conversation is aborted
    // while aborting is allowed. When it isn't, the dynconvo infrastructure
    // handles restoring the conversation in a transparent manner
    else if(nValue == DYNCONV_ABORTED)
    {
        // End of conversation cleanup
        DeleteLocalObject(oPC, "TrueResTarget" + IntToString(GetLocalInt(oPC, "TrueResChoice")));
        DeleteLocalInt(oPC, "TrueResChoice");
    }
    // Handle PC responses
    else
    {
        // variable named nChoice is the value of the player's choice as stored when building the choice list
        // variable named nStage determines the current conversation node
        int nChoice = GetChoice(oPC);
        if(nStage == STAGE_CHOOSE_TARGET)
        {
        	SetLocalInt(oPC, "TrueResChoice", nChoice);
            	nStage = STAGE_CONFIRMATION;
        }
        else if(nStage == STAGE_CONFIRMATION)//confirmation
        {
            // Res and Exit
            if(nChoice == TRUE)
            {
            	object oChoice = RetrievePC(oPC, GetLocalInt(oPC, "TrueResChoice"));
            	// Res the target
            	SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oChoice);
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectHeal(GetMaxHitPoints(oChoice) + 10, oChoice), oChoice);
		ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_RAISE_DEAD), GetLocation(oChoice));
		
		ExecuteScript("prc_pw_res", oChoice);
		if (GetPRCSwitch(PRC_PW_DEATH_TRACKING) && GetIsPC(oChoice))
                	SetPersistantLocalInt(oChoice, "persist_dead", FALSE);
            	AssignCommand(oChoice, ActionJumpToObject(oPC));

                // And we're all done
               	AllowExit(DYNCONV_EXIT_FORCE_EXIT);

            }
            else
            {
                nStage = STAGE_CHOOSE_TARGET;
                MarkStageNotSetUp(STAGE_CHOOSE_TARGET, oPC);
                MarkStageNotSetUp(STAGE_CONFIRMATION, oPC);
            }
	    DeleteLocalObject(oPC, "TrueResTarget" + IntToString(GetLocalInt(oPC, "TrueResChoice")));
            DeleteLocalInt(oPC, "TrueResChoice");
        }

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
