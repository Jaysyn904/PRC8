//:://////////////////////////////////////////////
//:: Factotum Cunning Brilliance choice script
//:: prc_fact_cunconv
//:://////////////////////////////////////////////
/*
    @author Stratovarius - 2021.11.04
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_factotum"
#include "inc_dynconv"

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_SELECT_ABILITIES    = 0;
const int STAGE_CONFIRM_SELECTION   = 1;

const int CHOICE_BACK_TO_LSELECT    = -1;

const int STRREF_BACK_TO_LSELECT    = 16836035; // "Return to level selection."
const int STRREF_SELECTED_HEADER1   = 16824209; // "You have selected:"
const int STRREF_SELECTED_HEADER2   = 16824210; // "Is this correct?"
const int STRREF_END_CONVO_SELECT   = 16824212; // "Finish"
const int LEVEL_STRREF_START        = 16824809;
const int STRREF_YES                = 4752;     // "Yes"
const int STRREF_NO                 = 4753;     // "No"

const int SORT       = TRUE; // If the sorting takes too much CPU, set to FALSE
const int DEBUG_LIST = FALSE;

//////////////////////////////////////////////////
/* Function defintions                          */
//////////////////////////////////////////////////

void PrintList(object oPC)
{
    string tp = "Printing list:\n";
    string s = GetLocalString(oPC, "PRC_FactotumConvo_List_Head");
    if(s == ""){
        tp += "Empty\n";
    }
    else{
        tp += s + "\n";
        s = GetLocalString(oPC, "PRC_FactotumConvo_List_Next_" + s);
        while(s != ""){
            tp += "=> " + s + "\n";
            s = GetLocalString(oPC, "PRC_FactotumConvo_List_Next_" + s);
        }
    }

    DoDebug(tp);
}

/**
 * Creates a linked list of entries that is sorted into alphabetical order
 * as it is built.
 * Assumption: mystery names are unique.
 *
 * @param oPC     The storage object aka whomever is gaining powers in this conversation
 * @param sChoice The choice string
 * @param nChoice The choice value
 */
void AddToTempList(object oPC, string sChoice, int nChoice)
{
    if(DEBUG_LIST) DoDebug("\nAdding to temp list: '" + sChoice + "' - " + IntToString(nChoice));
    if(DEBUG_LIST) PrintList(oPC);
    // If there is nothing yet
    if(!GetLocalInt(oPC, "PRC_FactotumConvo_ListInited"))
    {
        SetLocalString(oPC, "PRC_FactotumConvo_List_Head", sChoice);
        SetLocalInt(oPC, "PRC_FactotumConvo_List_" + sChoice, nChoice);

        SetLocalInt(oPC, "PRC_FactotumConvo_ListInited", TRUE);
    }
    else
    {
        // Find the location to instert into
        string sPrev = "", sNext = GetLocalString(oPC, "PRC_FactotumConvo_List_Head");
        while(sNext != "" && StringCompare(sChoice, sNext) >= 0)
        {
            if(DEBUG_LIST) DoDebug("Comparison between '" + sChoice + "' and '" + sNext + "' = " + IntToString(StringCompare(sChoice, sNext)));
            sPrev = sNext;
            sNext = GetLocalString(oPC, "PRC_FactotumConvo_List_Next_" + sNext);
        }

        // Insert the new entry
        // Does it replace the head?
        if(sPrev == "")
        {
            if(DEBUG_LIST) DoDebug("New head");
            SetLocalString(oPC, "PRC_FactotumConvo_List_Head", sChoice);
        }
        else
        {
            if(DEBUG_LIST) DoDebug("Inserting into position between '" + sPrev + "' and '" + sNext + "'");
            SetLocalString(oPC, "PRC_FactotumConvo_List_Next_" + sPrev, sChoice);
        }

        SetLocalString(oPC, "PRC_FactotumConvo_List_Next_" + sChoice, sNext);
        SetLocalInt(oPC, "PRC_FactotumConvo_List_" + sChoice, nChoice);
    }
}

/**
 * Reads the linked list built with AddToTempList() to AddChoice() and
 * deletes it.
 *
 * @param oPC A PC gaining powers at the moment
 */
void TransferTempList(object oPC)
{
    string sChoice = GetLocalString(oPC, "PRC_FactotumConvo_List_Head");
    int    nChoice = GetLocalInt   (oPC, "PRC_FactotumConvo_List_" + sChoice);

    DeleteLocalString(oPC, "PRC_FactotumConvo_List_Head");
    string sPrev;

    if(DEBUG_LIST) DoDebug("Head is: '" + sChoice + "' - " + IntToString(nChoice));

    while(sChoice != "")
    {
        // Add the choice
        AddChoice(sChoice, nChoice, oPC);

        // Get next
        sChoice = GetLocalString(oPC, "PRC_FactotumConvo_List_Next_" + (sPrev = sChoice));
        nChoice = GetLocalInt   (oPC, "PRC_FactotumConvo_List_" + sChoice);

        if(DEBUG_LIST) DoDebug("Next is: '" + sChoice + "' - " + IntToString(nChoice) + "; previous = '" + sPrev + "'");

        // Delete the already handled data
        DeleteLocalString(oPC, "PRC_FactotumConvo_List_Next_" + sPrev);
        DeleteLocalInt   (oPC, "PRC_FactotumConvo_List_" + sPrev);
    }

    DeleteLocalInt(oPC, "PRC_FactotumConvo_ListInited");
}

void main()
{
    object oPC = GetPCSpeaker();
    int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);
    int nStage = GetStage(oPC);

    string sPowerFile = "cls_spell_sorc"; 

    // Check which of the conversation scripts called the scripts
    if(nValue == 0) // All of them set the DynConv_Var to non-zero value, so something is wrong -> abort
        return;

    if(nValue == DYNCONV_SETUP_STAGE)
    {
        if(DEBUG) DoDebug("prc_fact_cunconv: Running setup stage for stage " + IntToString(nStage));
        // Check if this stage is marked as already set up
        // This stops list duplication when scrolling
        if(!GetIsStageSetUp(nStage, oPC))
        {
            if(DEBUG) DoDebug("prc_fact_cunconv: Stage was not set up already");
            // Level selection stage
            if(nStage == STAGE_SELECT_ABILITIES)
            {
                if(DEBUG) DoDebug("prc_fact_cunconv: Building level selection");
                SetHeader("Choose the class abilities you would like to learn. You can only learn three for today.");
                	
                if (!GetIsAbilitySaved(oPC, FEAT_BARBARIAN_ENDURANCE)) AddChoice("Barbarian Fast Movement", FEAT_BARBARIAN_ENDURANCE);
                if (!GetIsAbilitySaved(oPC, FEAT_BARBARIAN_RAGE)) AddChoice("Barbarian Rage", FEAT_BARBARIAN_RAGE);
                if (!GetIsAbilitySaved(oPC, FEAT_SNEAK_ATTACK)) AddChoice("Sneak Attack", FEAT_SNEAK_ATTACK);
                if (!GetIsAbilitySaved(oPC, 3665)) AddChoice("Mettle", 3665);                         
				if (!GetIsAbilitySaved(oPC, FEAT_CRUSADER_SMITE)) AddChoice("Crusader Smite", FEAT_CRUSADER_SMITE);
				
                // Set the next, previous and wait tokens to default values
                SetDefaultTokens();
                // Set the convo quit text to "Abort"
                SetCustomToken(DYNCONV_TOKEN_EXIT, GetStringByStrRef(DYNCONV_STRREF_ABORT_CONVO));
            }
            // Selection confirmation stage
            else if(nStage == STAGE_CONFIRM_SELECTION)
            {
                if(DEBUG) DoDebug("prc_fact_cunconv: Building selection confirmation");
                // Build the confirmation query
                string sToken = GetStringByStrRef(STRREF_SELECTED_HEADER1) + "\n\n"; // "You have selected:"
                int nSpellId = GetLocalInt(oPC, "CunningBrilliance");
                sToken += GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", nSpellId)))+"\n";
                sToken += GetStringByStrRef(StringToInt(Get2DACache("feat", "DESCRIPTION", nSpellId)))+"\n\n";
                sToken += GetStringByStrRef(STRREF_SELECTED_HEADER2); // "Is this correct?"
                SetHeader(sToken);

                AddChoice(GetStringByStrRef(STRREF_YES), TRUE, oPC); // "Yes"
                AddChoice(GetStringByStrRef(STRREF_NO), FALSE, oPC); // "No"
            }
        }

        // Do token setup
        SetupTokens();
    }
    else if(nValue == DYNCONV_EXITED)
    {
        if(DEBUG) DoDebug("prc_fact_cunconv: Running exit handler");
        // End of conversation cleanup
    }
    else if(nValue == DYNCONV_ABORTED)
    {
        // This section should never be run, since aborting this conversation should
        // always be forbidden and as such, any attempts to abort the conversation
        // should be handled transparently by the system
    }
    // Handle PC response
    else
    {
        int nChoice = GetChoice(oPC);
        if(DEBUG) DoDebug("prc_fact_cunconv: Handling PC response, stage = " + IntToString(nStage) + "; nChoice = " + IntToString(nChoice) + "; choice text = '" + GetChoiceText(oPC) +  "'");
        if(nStage == STAGE_SELECT_ABILITIES)
        {
           	if(DEBUG) DoDebug("prc_fact_cunconv: Level selected");
           	SetLocalInt(oPC, "CunningBrilliance", nChoice);
           	nStage = STAGE_CONFIRM_SELECTION;

            MarkStageNotSetUp(STAGE_SELECT_ABILITIES, oPC);
        }
        else if(nStage == STAGE_CONFIRM_SELECTION)
        {     
        	if (nChoice)
        	{
        		int nSpellId = GetLocalInt(oPC, "CunningBrilliance");
        		MarkAbilitySaved(oPC, nSpellId);
        		SetLocalInt(oPC, "CunningBrillianceCount", GetLocalInt(oPC, "CunningBrillianceCount")+1);
        	}		
        	
        	// We have more to go
            if(3 > GetLocalInt(oPC, "CunningBrillianceCount"))
            {
                nStage = STAGE_SELECT_ABILITIES;
            }
            else
            {
           	 	// And we're all done
           	 	DelayCommand(0.5, CheckBrillianceSlots(oPC));
            	AllowExit(DYNCONV_EXIT_FORCE_EXIT); 
            }
            MarkStageNotSetUp(STAGE_CONFIRM_SELECTION, oPC);        
        }

        if(DEBUG) DoDebug("prc_fact_cunconv: New stage: " + IntToString(nStage));

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
