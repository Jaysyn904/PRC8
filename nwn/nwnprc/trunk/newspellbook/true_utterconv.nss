//:://////////////////////////////////////////////
//:: Truenaming Utterance gain conversation script
//:: true_utterconv
//:://////////////////////////////////////////////
/** @file
    This script controls the truenaming utterance selection
    conversation.


    @author Stratovarius - 2006.07.19
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_function"
#include "true_inc_trufunc"
#include "inc_dynconv"


//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_SELECT_LEXICON      = 0;
const int STAGE_SELECT_LEVEL        = 1;
const int STAGE_SELECT_UTTERANCE    = 2;
const int STAGE_CONFIRM_SELECTION   = 3;
const int STAGE_ALL_UTTERS_SELECTED = 4;

const int CHOICE_BACK_TO_LSELECT    = -1;

const int STRREF_BACK_TO_LSELECT    = 16828472; // "Return to lexicon selection."
const int STRREF_LEVELLIST_HEADER   = 16828473; // "Select level of utterance to gain.\n\nNOTE:\nThis may take a while when first browsing a particular level's powers."
const int STRREF_UTTERLIST_HEADER1  = 16828474; // "Select an utterance to gain.\nYou can select"
const int STRREF_UTTERLIST_HEADER2  = 16828475; // "more utterances"
const int STRREF_SELECTED_HEADER1   = 16824209; // "You have selected:"
const int STRREF_SELECTED_HEADER2   = 16824210; // "Is this correct?"
const int STRREF_END_HEADER         = 16828476; // "You will be able to select more utterances after you gain another level in a truenaming caster class."
const int STRREF_LEXICONLIST_HEADER = 16828477; // "Select Lexicon to choose utterances in."
const int STRREF_END_CONVO_SELECT   = 16824212; // "Finish"
const int LEVEL_STRREF_START        = 16824809;
const int STRREF_EVOLVING_MIND      = 16828478; // "Lexicon of the Evolving Mind."
const int STRREF_CRAFTED_TOOL       = 16828479; // "Lexicon of the Crafted Tool."
const int STRREF_PERFECTED_MAP      = 16828480; // "Lexicon of the Perfected Map."
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
    string s = GetLocalString(oPC, "PRC_UtterConvo_List_Head");
    if(s == ""){
        tp += "Empty\n";
    }
    else{
        tp += s + "\n";
        s = GetLocalString(oPC, "PRC_UtterConvo_List_Next_" + s);
        while(s != ""){
            tp += "=> " + s + "\n";
            s = GetLocalString(oPC, "PRC_UtterConvo_List_Next_" + s);
        }
    }

    DoDebug(tp);
}

/**
 * Creates a linked list of entries that is sorted into alphabetical order
 * as it is built.
 * Assumption: utterance names are unique.
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
    if(!GetLocalInt(oPC, "PRC_UtterConvo_ListInited"))
    {
        SetLocalString(oPC, "PRC_UtterConvo_List_Head", sChoice);
        SetLocalInt(oPC, "PRC_UtterConvo_List_" + sChoice, nChoice);

        SetLocalInt(oPC, "PRC_UtterConvo_ListInited", TRUE);
    }
    else
    {
        // Find the location to instert into
        string sPrev = "", sNext = GetLocalString(oPC, "PRC_UtterConvo_List_Head");
        while(sNext != "" && StringCompare(sChoice, sNext) >= 0)
        {
            if(DEBUG_LIST) DoDebug("Comparison between '" + sChoice + "' and '" + sNext + "' = " + IntToString(StringCompare(sChoice, sNext)));
            sPrev = sNext;
            sNext = GetLocalString(oPC, "PRC_UtterConvo_List_Next_" + sNext);
        }

        /* Insert the new entry */
        // Does it replace the head?
        if(sPrev == "")
        {
            if(DEBUG_LIST) DoDebug("New head");
            SetLocalString(oPC, "PRC_UtterConvo_List_Head", sChoice);
        }
        else
        {
            if(DEBUG_LIST) DoDebug("Inserting into position between '" + sPrev + "' and '" + sNext + "'");
            SetLocalString(oPC, "PRC_UtterConvo_List_Next_" + sPrev, sChoice);
        }

        SetLocalString(oPC, "PRC_UtterConvo_List_Next_" + sChoice, sNext);
        SetLocalInt(oPC, "PRC_UtterConvo_List_" + sChoice, nChoice);
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
    string sChoice = GetLocalString(oPC, "PRC_UtterConvo_List_Head");
    int    nChoice = GetLocalInt   (oPC, "PRC_UtterConvo_List_" + sChoice);

    DeleteLocalString(oPC, "PRC_UtterConvo_List_Head");
    string sPrev;

    if(DEBUG_LIST) DoDebug("Head is: '" + sChoice + "' - " + IntToString(nChoice));

    while(sChoice != "")
    {
        // Add the choice
        AddChoice(sChoice, nChoice, oPC);

        // Get next
        sChoice = GetLocalString(oPC, "PRC_UtterConvo_List_Next_" + (sPrev = sChoice));
        nChoice = GetLocalInt   (oPC, "PRC_UtterConvo_List_" + sChoice);

        if(DEBUG_LIST) DoDebug("Next is: '" + sChoice + "' - " + IntToString(nChoice) + "; previous = '" + sPrev + "'");

        // Delete the already handled data
        DeleteLocalString(oPC, "PRC_UtterConvo_List_Next_" + sPrev);
        DeleteLocalInt   (oPC, "PRC_UtterConvo_List_" + sPrev);
    }

    DeleteLocalInt(oPC, "PRC_UtterConvo_ListInited");
}


void main()
{
    object oPC = GetPCSpeaker();
    int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);
    int nStage = GetStage(oPC);

    // For this conversation, this is always Truenamer, although that may change in the future.
    int nClass = GetLocalInt(oPC, "nClass");
    string sPowerFile = GetAMSDefinitionFileName(nClass);

    // Check which of the conversation scripts called the scripts
    if(nValue == 0) // All of them set the DynConv_Var to non-zero value, so something is wrong -> abort
        return;

    if(nValue == DYNCONV_SETUP_STAGE)
    {
        if(DEBUG) DoDebug("true_utterconv: Running setup stage for stage " + IntToString(nStage));
        // Check if this stage is marked as already set up
        // This stops list duplication when scrolling
        if(!GetIsStageSetUp(nStage, oPC))
        {
            if(DEBUG) DoDebug("true_utterconv: Stage was not set up already");
            // Level selection stage
            if(nStage == STAGE_SELECT_LEXICON)
            {
                if(DEBUG) DoDebug("true_utterconv: Building lexicon selection");
                SetHeader(GetStringByStrRef(STRREF_LEXICONLIST_HEADER));

                // Determine which Lexicons they're missing utterances in.
                int nTrueSpeakLevel = GetLevelByClass(nClass, oPC);
                int nMaxEM = GetMaxUtteranceCount(oPC, UTTERANCE_LIST_TRUENAMER, LEXICON_EVOLVING_MIND);
                int nMaxCT = GetMaxUtteranceCount(oPC, UTTERANCE_LIST_TRUENAMER, LEXICON_CRAFTED_TOOL);
                int nMaxPM = GetMaxUtteranceCount(oPC, UTTERANCE_LIST_TRUENAMER, LEXICON_PERFECTED_MAP);
                int nCountEM = GetUtteranceCount(oPC, UTTERANCE_LIST_TRUENAMER, LEXICON_EVOLVING_MIND);
                int nCountCT = GetUtteranceCount(oPC, UTTERANCE_LIST_TRUENAMER, LEXICON_CRAFTED_TOOL);
                int nCountPM = GetUtteranceCount(oPC, UTTERANCE_LIST_TRUENAMER, LEXICON_PERFECTED_MAP);

                if(DEBUG)
                {
                	DoDebug("true_utterconv: Truenamer Level: " + IntToString(nTrueSpeakLevel));
                	DoDebug("true_utterconv: Max Crafted Tool Known: " + IntToString(nMaxCT));
                	DoDebug("true_utterconv: Max Perfected Map Known: " + IntToString(nMaxPM));
                	DoDebug("true_utterconv: Utterance Count Crafted Tool: " + IntToString(nCountCT));
                	DoDebug("true_utterconv: Utterance Count Perfected Map: " + IntToString(nCountPM));
                }

                // Set the tokens
                // If the max they should have is greater than the amount they do have, add the choice.
                if (nMaxEM > nCountEM)
                    AddChoice(GetStringByStrRef(STRREF_EVOLVING_MIND), 1);
                if (nMaxCT > nCountCT)
                	AddChoice(GetStringByStrRef(STRREF_CRAFTED_TOOL), 2);
                if (nMaxPM > nCountPM)
                	AddChoice(GetStringByStrRef(STRREF_PERFECTED_MAP), 3);

                // Set the next, previous and wait tokens to default values
                SetDefaultTokens();
                // Set the convo quit text to "Abort"
                SetCustomToken(DYNCONV_TOKEN_EXIT, GetStringByStrRef(DYNCONV_STRREF_ABORT_CONVO));
            }
            // Level selection stage
            if(nStage == STAGE_SELECT_LEVEL)
            {
                if(DEBUG) DoDebug("true_utterconv: Building level selection");
                SetHeader(GetStringByStrRef(STRREF_LEVELLIST_HEADER));

                // Set the first choice to be return to lexicon selection stage
                AddChoice(GetStringByStrRef(STRREF_BACK_TO_LSELECT), CHOICE_BACK_TO_LSELECT, oPC);
                string sLexicon;
                int nLexicon = GetLocalInt(oPC, "nLexiconToBrowse");
                if      (nLexicon == LEXICON_EVOLVING_MIND) sLexicon = "EvolvingMind";
                else if (nLexicon == LEXICON_CRAFTED_TOOL)  sLexicon = "CraftedTool";
                else if (nLexicon == LEXICON_PERFECTED_MAP) sLexicon = "PerfectedMap";


                // Determine maximum utterance level
                int nTrueSpeakLevel = GetLevelByClass(nClass, oPC);
                int nMaxLevel = StringToInt(Get2DACache("cls_true_maxlvl", sLexicon, nTrueSpeakLevel - 1));

                if(DEBUG)
                {
                	DoDebug("true_utterconv: Truenamer Level: " + IntToString(nTrueSpeakLevel));
                	DoDebug("true_utterconv: Max " + sLexicon + " Level: " + IntToString(nMaxLevel));
                }

                // Set the tokens
                int i;
                for(i = 0; i < nMaxLevel; i++){
                    AddChoice(GetStringByStrRef(LEVEL_STRREF_START - i), // The minus is correct, these are stored in inverse order in the TLK. Whoops
                              i + 1
                              );
                }

                // Set the next, previous and wait tokens to default values
                SetDefaultTokens();
                // Set the convo quit text to "Abort"
                SetCustomToken(DYNCONV_TOKEN_EXIT, GetStringByStrRef(DYNCONV_STRREF_ABORT_CONVO));
            }
            // utterance selection stage
            if(nStage == STAGE_SELECT_UTTERANCE)
            {
                if(DEBUG) DoDebug("true_utterconv: Building utterance selection");

		        string sLexicon;
                int nLexicon = GetLocalInt(oPC, "nLexiconToBrowse");
                if      (nLexicon == LEXICON_EVOLVING_MIND) sLexicon = "EvolvingMind";
                else if (nLexicon == LEXICON_CRAFTED_TOOL)  sLexicon = "CraftedTool";
                else if (nLexicon == LEXICON_PERFECTED_MAP) sLexicon = "PerfectedMap";

                int nCurrentUtters = GetUtteranceCount(oPC, nClass, nLexicon);
                int nMaxUtters = GetMaxUtteranceCount(oPC, nClass, nLexicon);
                string sToken = GetStringByStrRef(STRREF_UTTERLIST_HEADER1) + " " + //"Select a utterance to gain.\n You can select "
                                IntToString(nMaxUtters-nCurrentUtters) + " " +
                                GetStringByStrRef(STRREF_UTTERLIST_HEADER2);        //" more utterances"
                SetHeader(sToken);

                // Set the first choice to be return to lexicon selection stage
                AddChoice(GetStringByStrRef(STRREF_BACK_TO_LSELECT), CHOICE_BACK_TO_LSELECT, oPC);

                // Determine maximum utterance level
                int nTrueSpeakLevel = GetLevelByClass(nClass, oPC);
                int nMaxLevel = StringToInt(Get2DACache("cls_true_maxlvl", sLexicon, nTrueSpeakLevel - 1));


                int nUtterLevelToBrowse = GetLocalInt(oPC, "nUtterLevelToBrowse");

                if(DEBUG)
                {
                	DoDebug("true_utterconv: Current Utterances: " + IntToString(nCurrentUtters));
                	DoDebug("true_utterconv: Max Utterances: " + IntToString(nMaxUtters));
                	DoDebug("true_utterconv: Truenamer Level: " + IntToString(nTrueSpeakLevel));
                	DoDebug("true_utterconv: Max " + sLexicon + " Level: " + IntToString(nMaxLevel));
                	DoDebug("true_utterconv: Utterance Level To Browse: " + IntToString(nUtterLevelToBrowse));
                }


                int i, nUtterLevel;
                string sFeatID;
                for(i = 0; i < GetPRCSwitch(FILE_END_CLASS_POWER) ; i++)
                {
                    nUtterLevel = StringToInt(Get2DACache(sPowerFile, "Level", i));
                    // Skip any powers of too low level
                    if(nUtterLevel < nUtterLevelToBrowse){
                        continue;
                    }
                    /* Due to the way the utterance list 2das are structured, we know that once
                     * the level of a read utterance is greater than the maximum manifestable
                     * it'll never be lower again. Therefore, we can skip reading the
                     * powers that wouldn't be shown anyway.
                     */
                    if(nUtterLevel > nUtterLevelToBrowse){
                        break;
                    }
                    sFeatID = Get2DACache(sPowerFile, "FeatID", i);
                    if(sFeatID != ""                                                   // Non-blank row
                     && !GetHasFeat(StringToInt(sFeatID), oPC)                         // PC does not already posses the power
                     && (StringToInt(Get2DACache(sPowerFile, "Lexicon", i)) == nLexicon)// its part of the Lexicon we're browsing
                       )
                    {
                        if(SORT) AddToTempList(oPC, GetStringByStrRef(StringToInt(Get2DACache(sPowerFile, "Name", i))), i);
                        else     AddChoice(GetStringByStrRef(StringToInt(Get2DACache(sPowerFile, "Name", i))), i, oPC);
                    }
                }

                if(SORT) TransferTempList(oPC);

                /* Hack - In the utterance selection stage, on returning from
                 * confirmation dialog where the answer was "No", restore the
                 * offset to be the same as on entering the confirmation dialog.
                 */
                if(GetLocalInt(oPC, "UTTERLISTChoiceOffset"))
                {
                    if(DEBUG) DoDebug("true_utterconv: Running offset restoration hack");
                    SetLocalInt(oPC, DYNCONV_CHOICEOFFSET, GetLocalInt(oPC, "UTTERLISTChoiceOffset") - 1);
                    DeleteLocalInt(oPC, "UTTERLISTChoiceOffset");
                }

                MarkStageSetUp(STAGE_SELECT_UTTERANCE, oPC);
            }
            // Selection confirmation stage
            else if(nStage == STAGE_CONFIRM_SELECTION)
            {
                if(DEBUG) DoDebug("true_utterconv: Building selection confirmation");
                // Build the confirmantion query
                string sToken = GetStringByStrRef(STRREF_SELECTED_HEADER1) + "\n\n"; // "You have selected:"
                int nUtter = GetLocalInt(oPC, "nUtter");
                int nFeatID = StringToInt(Get2DACache(sPowerFile, "FeatID", nUtter));
                sToken += GetStringByStrRef(StringToInt(Get2DACache(sPowerFile, "Name", nUtter)))+"\n";
                sToken += GetStringByStrRef(StringToInt(Get2DACache("feat", "DESCRIPTION", nFeatID)))+"\n\n";
                sToken += GetStringByStrRef(STRREF_SELECTED_HEADER2); // "Is this correct?"
                SetHeader(sToken);

                AddChoice(GetStringByStrRef(STRREF_YES), TRUE, oPC); // "Yes"
                AddChoice(GetStringByStrRef(STRREF_NO), FALSE, oPC); // "No"
            }
            // Conversation finished stage
            else if(nStage == STAGE_ALL_UTTERS_SELECTED)
            {
                if(DEBUG) DoDebug("true_utterconv: Building finish note");
                SetHeader(GetStringByStrRef(STRREF_END_HEADER));
                // Set the convo quit text to "Finish"
                SetCustomToken(DYNCONV_TOKEN_EXIT, GetStringByStrRef(STRREF_END_CONVO_SELECT));
                AllowExit(DYNCONV_EXIT_ALLOWED_SHOW_CHOICE, FALSE, oPC);
            }
        }

        // Do token setup
        SetupTokens();
    }
    else if(nValue == DYNCONV_EXITED)
    {
        if(DEBUG) DoDebug("true_utterconv: Running exit handler");
        // End of conversation cleanup
        DeleteLocalInt(oPC, "nClass");
        DeleteLocalInt(oPC, "nUtter");
        DeleteLocalInt(oPC, "nUtterLevelToBrowse");
        DeleteLocalInt(oPC, "nLexiconToBrowse");
        DeleteLocalInt(oPC, "UTTERLISTChoiceOffset");

        // Restart the convo to pick next utterance if needed
        // done via EvalPRCFFeats to avoid convlicts with new spellbooks
        //ExecuteScript("psi_powergain", oPC);
        DelayCommand(1.0, EvalPRCFeats(oPC));
    }
    else if(nValue == DYNCONV_ABORTED)
    {
        // This section should never be run, since aborting this conversation should
        // always be forbidden and as such, any attempts to abort the conversation
        // should be handled transparently by the system
        if(DEBUG) DoDebug("true_utterconv: ERROR: Conversation abort section run");
        DelayCommand(1.0, EvalPRCFeats(oPC));
    }
    // Handle PC response
    else
    {
        int nChoice = GetChoice(oPC);
        if(DEBUG) DoDebug("true_utterconv: Handling PC response, stage = " + IntToString(nStage) + "; nChoice = " + IntToString(nChoice) + "; choice text = '" + GetChoiceText(oPC) +  "'");
        if(nStage == STAGE_SELECT_LEXICON)
        {
            if(DEBUG) DoDebug("true_utterconv: Lexicon selected");
            SetLocalInt(oPC, "nLexiconToBrowse", nChoice);
            nStage = STAGE_SELECT_LEVEL;
        }
        else if(nStage == STAGE_SELECT_LEVEL)
        {
            if(nChoice == CHOICE_BACK_TO_LSELECT)
            {
                if(DEBUG) DoDebug("true_utterconv: Returning to lexicon selection");
                nStage = STAGE_SELECT_LEXICON;
                DeleteLocalInt(oPC, "nLexiconToBrowse");
            }
            else
            {
            	if(DEBUG) DoDebug("true_utterconv: Level selected");
            	SetLocalInt(oPC, "nUtterLevelToBrowse", nChoice);
            	nStage = STAGE_SELECT_UTTERANCE;
            }
            MarkStageNotSetUp(STAGE_SELECT_LEVEL, oPC);
        }
        else if(nStage == STAGE_SELECT_UTTERANCE)
        {
            if(nChoice == CHOICE_BACK_TO_LSELECT)
            {
                if(DEBUG) DoDebug("true_utterconv: Returning to lexicon selection");
                nStage = STAGE_SELECT_LEXICON;
                // Clean out both.
                DeleteLocalInt(oPC, "nUtterLevelToBrowse");
                DeleteLocalInt(oPC, "nLexiconToBrowse");
            }
            else
            {
                if(DEBUG) DoDebug("true_utterconv: Entering utterance confirmation");
                SetLocalInt(oPC, "nUtter", nChoice);
                // Store offset so that if the user decides not to take the power,
                // we can return to the same page in the utterance list instead of resetting to the beginning
                // Store the value +1 in order to be able to differentiate between offset 0 and undefined
                SetLocalInt(oPC, "UTTERLISTChoiceOffset", GetLocalInt(oPC, DYNCONV_CHOICEOFFSET) + 1);
                nStage = STAGE_CONFIRM_SELECTION;
            }
            MarkStageNotSetUp(STAGE_SELECT_UTTERANCE, oPC);
        }
        else if(nStage == STAGE_CONFIRM_SELECTION)
        {
            if(DEBUG) DoDebug("true_utterconv: Handling utterance confirmation");
            if(nChoice == TRUE)
            {
                if(DEBUG) DoDebug("true_utterconv: Adding power");
                int nUtter = GetLocalInt(oPC, "nUtter");
                int nLexicon = GetLocalInt(oPC, "nLexiconToBrowse");

                AddUtteranceKnown(oPC, nClass, nUtter, nLexicon, GetHitDice(oPC));

                // Delete the stored offset
                DeleteLocalInt(oPC, "UTTERLISTChoiceOffset");
            }

            int nEM = GetUtteranceCount(oPC, nClass, LEXICON_EVOLVING_MIND);
            int nMaxEM = GetMaxUtteranceCount(oPC, nClass, LEXICON_EVOLVING_MIND);
            int nCT = GetUtteranceCount(oPC, nClass, LEXICON_CRAFTED_TOOL);
            int nMaxCT = GetMaxUtteranceCount(oPC, nClass, LEXICON_CRAFTED_TOOL);
            int nPM = GetUtteranceCount(oPC, nClass, LEXICON_PERFECTED_MAP);
            int nMaxPM = GetMaxUtteranceCount(oPC, nClass, LEXICON_PERFECTED_MAP);

            if(DEBUG)
            {
            	DoDebug("true_utterconv: Checking all Lexicons for being full");
            	DoDebug("true_utterconv: Evolving Mind Count: " + IntToString(nEM));
            	DoDebug("true_utterconv: Evolving Mind Max: " + IntToString(nMaxEM));
            	DoDebug("true_utterconv: Crafted Tool Count: " + IntToString(nCT));
            	DoDebug("true_utterconv: Crafted Tool Max: " + IntToString(nMaxCT));
            	DoDebug("true_utterconv: Perfected Map Count: " + IntToString(nPM));
            	DoDebug("true_utterconv: Perfected Map Max: " + IntToString(nMaxPM));
            }

	        //Check all three lexicons for being full
    	    if(nEM >= nMaxEM && nCT >= nMaxCT && nPM >= nMaxPM)
                nStage = STAGE_ALL_UTTERS_SELECTED;
            else
                nStage = STAGE_SELECT_LEXICON;
        }

        if(DEBUG) DoDebug("true_utterconv: New stage: " + IntToString(nStage));

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
