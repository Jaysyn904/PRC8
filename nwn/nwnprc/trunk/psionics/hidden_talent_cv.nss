//:://////////////////////////////////////////////  
//:: Hidden Talent Power Conversation  
//:: hidden_talent_cv  
//:://////////////////////////////////////////////  
/** @file  
    This allows you to choose a psionic power for Hidden Talent feat  
  
    @author Modified from prc_favsoulweap.nss  
    @date   Created - 2025.12.14  
*/  
//:://////////////////////////////////////////////  
//:://////////////////////////////////////////////  
  
#include "prc_inc_fork"  
#include "inc_item_props"  
#include "prc_x2_itemprop"  
#include "inc_dynconv"  
#include "psi_inc_psifunc"  
  
//////////////////////////////////////////////////  
/* Constant defintions                          */  
//////////////////////////////////////////////////  
  
const int STAGE_POWER_CHOICE = 0;  
const int STAGE_CONFIRMATION = 1;  
  
//////////////////////////////////////////////////  
/* Aid functions                                */  
//////////////////////////////////////////////////  
  
//////////////////////////////////////////////////  
/* Main function                                */  
//////////////////////////////////////////////////  
  
void main()  
{  
    //object oPC = GetPCSpeaker();  
	object oPC = OBJECT_SELF;
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
	
	if(DEBUG) DoDebug("hidden_talent_cv: Entering Hidden Talent conversation");
  
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
            if(nStage == STAGE_POWER_CHOICE)  
            {  
                string sHeader1 = "Select a 1st-level psionic power for Hidden Talent.\n";  
                sHeader1 += "This will grant you the ability to manifest this power as a psionic-like ability.";  
                SetHeader(sHeader1);  
  
                // Loop through all Hidden Talent feats (25901-25946)  
                int added = 0;  
                int i;  
                string sFeatName;  
                  
                for(i = 25901; i <= 25946; i++)  
                {  
                    // Get the feat name from the feats.2da  
                    sFeatName = Get2DACache("feats", "NAME", i);  
                    if(sFeatName != "" && sFeatName != "****")  
                    {  
                        // Convert the feat constant name to display name  
                        // Remove "FEAT_HIDDEN_TALENT_" and replace underscores with spaces  
                        string sDisplayName = GetStringByStrRef(StringToInt(sFeatName));  
                        if(sDisplayName == "") sDisplayName = "Power " + IntToString(i);  
                          
                        AddChoice(sDisplayName, i, oPC);  
                        added++;  
                    }  
                }  
                  
                if(added == 0)  
                {  
                    AddChoice("No valid powers found.", 0, oPC);  
                }  
  
                MarkStageSetUp(STAGE_POWER_CHOICE, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it  
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values  
            }  
            else if(nStage == STAGE_CONFIRMATION)//confirmation  
            {  
                int nChoice = GetLocalInt(oPC, "HiddenTalentPower");  
                AddChoice(GetStringByStrRef(4752), TRUE); // "Yes"  
                AddChoice(GetStringByStrRef(4753), FALSE); // "No"  
  
                string sText = "You have selected the Hidden Talent power.\n";  
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
        DeleteLocalInt(oPC, "HiddenTalentPower");  
    }  
    // Abort conversation cleanup.  
    // NOTE: This section is only run when the conversation is aborted  
    // while aborting is allowed. When it isn't, the dynconvo infrastructure  
    // handles restoring the conversation in a transparent manner  
    else if(nValue == DYNCONV_ABORTED)  
    {  
        // End of conversation cleanup  
        DeleteLocalInt(oPC, "HiddenTalentPower");  
    }  
    // Handle PC responses  
    else  
    {  
        // variable named nChoice is the value of the player's choice as stored when building the choice list  
        // variable named nStage determines the current conversation node  
        int nChoice = GetChoice(oPC);  
        if(nStage == STAGE_POWER_CHOICE)  
        {  
            // Go to this stage next  
            nStage = STAGE_CONFIRMATION;  
            SetLocalInt(oPC, "HiddenTalentPower", nChoice);  
        }  
        else if(nStage == STAGE_CONFIRMATION)//confirmation  
        {  
            if(nChoice == TRUE)  
            {  
                int nFeatID = GetLocalInt(oPC, "HiddenTalentPower");  
                  
                // Grant the Hidden Talent feat directly  
                AddSkinFeat(nFeatID, nFeatID, GetPCSkin(oPC), oPC);  
                  
                // Mark that Hidden Talent has been chosen  
                SetPersistantLocalInt(oPC, "HiddenTalentChosen", TRUE);  
  
                // And we're all done  
                AllowExit(DYNCONV_EXIT_FORCE_EXIT);  
            }  
            else  
            {  
                nStage = STAGE_POWER_CHOICE;  
                MarkStageNotSetUp(STAGE_POWER_CHOICE, oPC);  
                MarkStageNotSetUp(STAGE_CONFIRMATION, oPC);  
            }  
  
            DeleteLocalInt(oPC, "HiddenTalentPower");  
        }  
  
        // Store the stage value. If it has been changed, this clears out the choices  
        SetStage(nStage, oPC);  
    }  
}