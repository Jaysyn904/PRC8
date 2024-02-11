//:://////////////////////////////////////////////
//:: Factotum Cunning Knowledge choice script
//:: prc_fact_sklconv
//:://////////////////////////////////////////////
/*
    @author Stratovarius - 2019.12.21
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_factotum"
#include "inc_dynconv"

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_SELECT_SKILL        = 0;
const int STAGE_SELECT_SPELL        = 1;
const int STAGE_CONFIRM_SELECTION   = 2;

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
        if(DEBUG) DoDebug("prc_fact_sklconv: Running setup stage for stage " + IntToString(nStage));
        // Check if this stage is marked as already set up
        // This stops list duplication when scrolling
        if(!GetIsStageSetUp(nStage, oPC))
        {
            if(DEBUG) DoDebug("prc_fact_sklconv: Stage was not set up already");
            // Level selection stage
            if(nStage == STAGE_SELECT_SKILL)
            {
                if(DEBUG) DoDebug("prc_fact_sklconv: Building skill selection");
                SetHeader("Choose the skill to boost");

                // Set the tokens. 
                int i, nDumbAss;
                for(i = 0; i < 50; i++)
                {	// Can only boost a skill once a day
                    if (GetSkillRank(i, oPC, TRUE) && !GetLocalInt(oPC, "CunningKnowledge"+IntToString(i)))
                    {
                    	AddChoice(GetStringByStrRef(StringToInt(Get2DACache("skills", "Name", i))), i);
                    	nDumbAss = TRUE; // This stops people being trapped who don't have a single skill point to their name
                    }  	
                }
                
                // No skill points at all
                if (!nDumbAss) AllowExit(DYNCONV_EXIT_FORCE_EXIT); 

                // Set the next, previous and wait tokens to default values
                SetDefaultTokens();
                // Set the convo quit text to "Abort"
                SetCustomToken(DYNCONV_TOKEN_EXIT, GetStringByStrRef(DYNCONV_STRREF_ABORT_CONVO));
            }
        }

        // Do token setup
        SetupTokens();
    }
    else if(nValue == DYNCONV_EXITED)
    {
        if(DEBUG) DoDebug("prc_fact_sklconv: Running exit handler");
        // End of conversation cleanup
        DeleteLocalInt(oPC, "ArcDilChoiceOffset");
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
        if(DEBUG) DoDebug("prc_fact_sklconv: Handling PC response, stage = " + IntToString(nStage) + "; nChoice = " + IntToString(nChoice) + "; choice text = '" + GetChoiceText(oPC) +  "'");
        if(nStage == STAGE_SELECT_SKILL)
        {
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSkillIncrease(nChoice, GetLevelByClass(CLASS_TYPE_FACTOTUM, oPC)), oPC, 6.0); 
			SetLocalInt(oPC, "CunningKnowledge"+IntToString(nChoice), TRUE);
            // And we're all done
            AllowExit(DYNCONV_EXIT_FORCE_EXIT); 
        }

        if(DEBUG) DoDebug("prc_fact_sklconv: New stage: " + IntToString(nStage));

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
