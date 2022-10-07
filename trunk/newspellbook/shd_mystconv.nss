//:://////////////////////////////////////////////
//:: Shadowcasting Mystery gain conversation script
//:: shd_mystconv
//:://////////////////////////////////////////////
/** @file
    @author Stratovarius - 2019.02.08
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_function"
#include "shd_inc_shdfunc"
#include "inc_dynconv"

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_SELECT_LEVEL           = 0;
const int STAGE_SELECT_MYSTERY         = 1;
const int STAGE_CONFIRM_SELECTION      = 2;
const int STAGE_ALL_MYSTERIES_SELECTED = 3;

const int CHOICE_BACK_TO_LSELECT    = -1;

const int STRREF_BACK_TO_LSELECT    = 16836035; // "Return to level selection."
const int STRREF_LEVELLIST_HEADER   = 16836036; // "Select level of mystery to gain.\n\nNOTE:\nThis may take a while when first browsing a particular level's mysteries."
const int STRREF_MYSTLIST_HEADER1   = 16836037; // "Select a mystery to gain.\nYou can select"
const int STRREF_MYSTLIST_HEADER2   = 16836038; // "more mysteries"
const int STRREF_SELECTED_HEADER1   = 16824209; // "You have selected:"
const int STRREF_SELECTED_HEADER2   = 16824210; // "Is this correct?"
const int STRREF_END_HEADER         = 16836039; // "You will be able to select more mysteries after you gain another level in a shadowcasting class."
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
    string s = GetLocalString(oPC, "PRC_MystConvo_List_Head");
    if(s == ""){
        tp += "Empty\n";
    }
    else{
        tp += s + "\n";
        s = GetLocalString(oPC, "PRC_MystConvo_List_Next_" + s);
        while(s != ""){
            tp += "=> " + s + "\n";
            s = GetLocalString(oPC, "PRC_MystConvo_List_Next_" + s);
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
    if(!GetLocalInt(oPC, "PRC_MystConvo_ListInited"))
    {
        SetLocalString(oPC, "PRC_MystConvo_List_Head", sChoice);
        SetLocalInt(oPC, "PRC_MystConvo_List_" + sChoice, nChoice);

        SetLocalInt(oPC, "PRC_MystConvo_ListInited", TRUE);
    }
    else
    {
        // Find the location to instert into
        string sPrev = "", sNext = GetLocalString(oPC, "PRC_MystConvo_List_Head");
        while(sNext != "" && StringCompare(sChoice, sNext) >= 0)
        {
            if(DEBUG_LIST) DoDebug("Comparison between '" + sChoice + "' and '" + sNext + "' = " + IntToString(StringCompare(sChoice, sNext)));
            sPrev = sNext;
            sNext = GetLocalString(oPC, "PRC_MystConvo_List_Next_" + sNext);
        }

        // Insert the new entry
        // Does it replace the head?
        if(sPrev == "")
        {
            if(DEBUG_LIST) DoDebug("New head");
            SetLocalString(oPC, "PRC_MystConvo_List_Head", sChoice);
        }
        else
        {
            if(DEBUG_LIST) DoDebug("Inserting into position between '" + sPrev + "' and '" + sNext + "'");
            SetLocalString(oPC, "PRC_MystConvo_List_Next_" + sPrev, sChoice);
        }

        SetLocalString(oPC, "PRC_MystConvo_List_Next_" + sChoice, sNext);
        SetLocalInt(oPC, "PRC_MystConvo_List_" + sChoice, nChoice);
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
    string sChoice = GetLocalString(oPC, "PRC_MystConvo_List_Head");
    int    nChoice = GetLocalInt   (oPC, "PRC_MystConvo_List_" + sChoice);

    DeleteLocalString(oPC, "PRC_MystConvo_List_Head");
    string sPrev;

    if(DEBUG_LIST) DoDebug("Head is: '" + sChoice + "' - " + IntToString(nChoice));

    while(sChoice != "")
    {
        // Add the choice
        AddChoice(sChoice, nChoice, oPC);

        // Get next
        sChoice = GetLocalString(oPC, "PRC_MystConvo_List_Next_" + (sPrev = sChoice));
        nChoice = GetLocalInt   (oPC, "PRC_MystConvo_List_" + sChoice);

        if(DEBUG_LIST) DoDebug("Next is: '" + sChoice + "' - " + IntToString(nChoice) + "; previous = '" + sPrev + "'");

        // Delete the already handled data
        DeleteLocalString(oPC, "PRC_MystConvo_List_Next_" + sPrev);
        DeleteLocalInt   (oPC, "PRC_MystConvo_List_" + sPrev);
    }

    DeleteLocalInt(oPC, "PRC_MystConvo_ListInited");
}

void main()
{
    object oPC = GetPCSpeaker();
    int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);
    int nStage = GetStage(oPC);

    // This can be Shadowcaster or Shadowsmith
    int nClass = GetLocalInt(oPC, "nClass");
    string sPowerFile = GetAMSDefinitionFileName(nClass);

    // Check which of the conversation scripts called the scripts
    if(nValue == 0) // All of them set the DynConv_Var to non-zero value, so something is wrong -> abort
        return;

    if(nValue == DYNCONV_SETUP_STAGE)
    {
        if(DEBUG) DoDebug("shd_mystconv: Running setup stage for stage " + IntToString(nStage));
        // Check if this stage is marked as already set up
        // This stops list duplication when scrolling
        if(!GetIsStageSetUp(nStage, oPC))
        {
            if(DEBUG) DoDebug("shd_mystconv: Stage was not set up already");
            // Level selection stage
            if(nStage == STAGE_SELECT_LEVEL)
            {
                if(DEBUG) DoDebug("shd_mystconv: Building level selection");
                SetHeader(GetStringByStrRef(STRREF_LEVELLIST_HEADER));

                // Determine maximum mystery level that we should display
                // We do this three times for Apprentice, Initiate, and Master mysteries
                int nMaxLevel = GetMaxMysteryLevelLearnable(oPC, nClass, 1);

                // Set the tokens
                int i;
                for(i = 0; i < nMaxLevel; i++){
                    AddChoice(GetStringByStrRef(LEVEL_STRREF_START - i), // The minus is correct, these are stored in inverse order in the TLK. Whoops
                              i + 1
                              );
                }
                
                nMaxLevel = GetMaxMysteryLevelLearnable(oPC, nClass, 2);

                // Set the tokens
                for(i = 3; i < nMaxLevel; i++){
                    AddChoice(GetStringByStrRef(LEVEL_STRREF_START - i), // The minus is correct, these are stored in inverse order in the TLK. Whoops
                              i + 1
                              );
                } 
                
                nMaxLevel = GetMaxMysteryLevelLearnable(oPC, nClass, 3);

                // Set the tokens
                for(i = 6; i < nMaxLevel; i++){
                    AddChoice(GetStringByStrRef(LEVEL_STRREF_START - i), // The minus is correct, these are stored in inverse order in the TLK. Whoops
                              i + 1
                              );
                }                 

                // Set the next, previous and wait tokens to default values
                SetDefaultTokens();
                // Set the convo quit text to "Abort"
                SetCustomToken(DYNCONV_TOKEN_EXIT, GetStringByStrRef(DYNCONV_STRREF_ABORT_CONVO));
            }
            // mystery selection stage
            if(nStage == STAGE_SELECT_MYSTERY)
            {
                if(DEBUG) DoDebug("shd_mystconv: Building mystery selection");

                int nCurrentMysts = GetMysteryCount(oPC, nClass);
                int nMaxMysts = GetMaxMysteryCount(oPC, nClass);
                string sToken = GetStringByStrRef(STRREF_MYSTLIST_HEADER1) + " " + //"Select a mystery to gain.\n You can select "
                                IntToString(nMaxMysts-nCurrentMysts) + " " +
                                GetStringByStrRef(STRREF_MYSTLIST_HEADER2);        //" more mysteries"
                SetHeader(sToken);

                // Set the first choice to be return to level selection stage
                AddChoice(GetStringByStrRef(STRREF_BACK_TO_LSELECT), CHOICE_BACK_TO_LSELECT, oPC);

                int nMystLevelToBrowse = GetLocalInt(oPC, "nMystLevelToBrowse");

                if(DEBUG)
                {
                	DoDebug("shd_mystconv: Current Mysterys: " + IntToString(nCurrentMysts));
                	DoDebug("shd_mystconv: Max Mysterys: " + IntToString(nMaxMysts));
                	DoDebug("shd_mystconv: Mystery Level To Browse: " + IntToString(nMystLevelToBrowse));
                }


                int i, nMystLevel;
                string sFeatID;
                for(i = 0; i < GetPRCSwitch(FILE_END_CLASS_POWER) ; i++)
                {
                    nMystLevel = StringToInt(Get2DACache(sPowerFile, "Level", i));
                    // Skip any powers of too low level
                    if(nMystLevel < nMystLevelToBrowse){
                        continue;
                    }
                     //Due to the way the mystery list 2das are structured, we know that once
                     //the level of a read mystery is greater than the maximum castable
                     //it'll never be lower again. Therefore, we can skip reading the
                     //mysteries that wouldn't be shown anyway.
                     
                    if(nMystLevel > nMystLevelToBrowse){
                        break;
                    }
                    sFeatID = Get2DACache(sPowerFile, "FeatID", i);
                    if(sFeatID != ""                                                   // Non-blank row
                     && !GetHasFeat(StringToInt(sFeatID), oPC)                         // PC does not already posses the power
                       )
                    {
                        if(SORT) AddToTempList(oPC, GetStringByStrRef(StringToInt(Get2DACache(sPowerFile, "Name", i))), i);
                        else     AddChoice(GetStringByStrRef(StringToInt(Get2DACache(sPowerFile, "Name", i))), i, oPC);
                    }
                }

                if(SORT) TransferTempList(oPC);

                // Hack - In the mystery selection stage, on returning from
                // confirmation dialog where the answer was "No", restore the
                // offset to be the same as on entering the confirmation dialog.
                if(GetLocalInt(oPC, "MYSTLISTChoiceOffset"))
                {
                    if(DEBUG) DoDebug("shd_mystconv: Running offset restoration hack");
                    SetLocalInt(oPC, DYNCONV_CHOICEOFFSET, GetLocalInt(oPC, "MYSTLISTChoiceOffset") - 1);
                    DeleteLocalInt(oPC, "MYSTLISTChoiceOffset");
                }

                MarkStageSetUp(STAGE_SELECT_MYSTERY, oPC);
            }
            // Selection confirmation stage
            else if(nStage == STAGE_CONFIRM_SELECTION)
            {
                if(DEBUG) DoDebug("shd_mystconv: Building selection confirmation");
                // Build the confirmantion query
                string sToken = GetStringByStrRef(STRREF_SELECTED_HEADER1) + "\n\n"; // "You have selected:"
                int nMyst = GetLocalInt(oPC, "nMyst");
                int nFeatID = StringToInt(Get2DAString(sPowerFile, "FeatID", nMyst));
                if(DEBUG) DoDebug("STAGE_CONFIRM_SELECTION nMyst: " + IntToString(nMyst));
                if(DEBUG) DoDebug("STAGE_CONFIRM_SELECTION nFeatID: " + IntToString(nFeatID));
                sToken += GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", nFeatID)))+"\n";
                sToken += GetStringByStrRef(StringToInt(Get2DACache("feat", "DESCRIPTION", nFeatID)))+"\n\n";
                sToken += GetStringByStrRef(STRREF_SELECTED_HEADER2); // "Is this correct?"
                SetHeader(sToken);

                AddChoice(GetStringByStrRef(STRREF_YES), TRUE, oPC); // "Yes"
                AddChoice(GetStringByStrRef(STRREF_NO), FALSE, oPC); // "No"
            }
            // Conversation finished stage
            else if(nStage == STAGE_ALL_MYSTERIES_SELECTED)
            {
                if(DEBUG) DoDebug("shd_mystconv: Building finish note");
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
        if(DEBUG) DoDebug("shd_mystconv: Running exit handler");
        // End of conversation cleanup
        DeleteLocalInt(oPC, "nClass");
        DeleteLocalInt(oPC, "nMyst");
        DeleteLocalInt(oPC, "nMystLevelToBrowse");
        DeleteLocalInt(oPC, "MYSTLISTChoiceOffset");

        // Restart the convo to pick next mystery if needed
        // done via EvalPRCFeats to avoid conflicts with new spellbooks
        DelayCommand(1.0, EvalPRCFeats(oPC));
        
        if (GetCompletedPaths(oPC) > GetPathBonusFeats(oPC))
            DelayCommand(1.0, StartDynamicConversation("shd_pathconv", oPC, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oPC));        
    }
    else if(nValue == DYNCONV_ABORTED)
    {
        // This section should never be run, since aborting this conversation should
        // always be forbidden and as such, any attempts to abort the conversation
        // should be handled transparently by the system
        if(DEBUG) DoDebug("shd_mystconv: ERROR: Conversation abort section run");
        DelayCommand(1.0, EvalPRCFeats(oPC));
        
        if (GetCompletedPaths(oPC) > GetPathBonusFeats(oPC))
            DelayCommand(1.0, StartDynamicConversation("shd_pathconv", oPC, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oPC));
    }
    // Handle PC response
    else
    {
        int nChoice = GetChoice(oPC);
        if(DEBUG) DoDebug("shd_mystconv: Handling PC response, stage = " + IntToString(nStage) + "; nChoice = " + IntToString(nChoice) + "; choice text = '" + GetChoiceText(oPC) +  "'");
        if(nStage == STAGE_SELECT_LEVEL)
        {
           	if(DEBUG) DoDebug("shd_mystconv: Level selected");
           	SetLocalInt(oPC, "nMystLevelToBrowse", nChoice);
           	nStage = STAGE_SELECT_MYSTERY;

            MarkStageNotSetUp(STAGE_SELECT_LEVEL, oPC);
        }
        else if(nStage == STAGE_SELECT_MYSTERY)
        {
            if(nChoice == CHOICE_BACK_TO_LSELECT)
            {
                if(DEBUG) DoDebug("shd_mystconv: Returning to level selection");
                nStage = STAGE_SELECT_LEVEL;
                // Clean up
                DeleteLocalInt(oPC, "nMystLevelToBrowse");
            }
            else
            {
                if(DEBUG) DoDebug("shd_mystconv: Entering mystery confirmation");
                SetLocalInt(oPC, "nMyst", nChoice);
                // Store offset so that if the user decides not to take the mystery,
                // we can return to the same page in the mystery list instead of resetting to the beginning
                // Store the value +1 in order to be able to differentiate between offset 0 and undefined
                SetLocalInt(oPC, "MYSTLISTChoiceOffset", GetLocalInt(oPC, DYNCONV_CHOICEOFFSET) + 1);
                nStage = STAGE_CONFIRM_SELECTION;
            }
            MarkStageNotSetUp(STAGE_SELECT_MYSTERY, oPC);
        }
        else if(nStage == STAGE_CONFIRM_SELECTION)
        {
            if(DEBUG) DoDebug("shd_mystconv: Handling mystery confirmation");
            if(nChoice == TRUE)
            {
                if(DEBUG) DoDebug("shd_mystconv: Adding power");
                int nMyst = GetLocalInt(oPC, "nMyst");

                AddMysteryKnown(oPC, nClass, nMyst, GetHitDice(oPC));

                // Delete the stored offset
                DeleteLocalInt(oPC, "MYSTLISTChoiceOffset");
            }

            int nMyst = GetMysteryCount(oPC, nClass);
            int nMaxMyst = GetMaxMysteryCount(oPC, nClass);

            if(DEBUG)
            {
            	DoDebug("shd_mystconv: Checking for being full");
            	DoDebug("shd_mystconv: Mystery Count: " + IntToString(nMyst));
            	DoDebug("shd_mystconv: Mystery Max: " + IntToString(nMaxMyst));
            }

	        //Check all three lexicons for being full
    	    if(nMyst >= nMaxMyst)
                nStage = STAGE_ALL_MYSTERIES_SELECTED;
            else
                nStage = STAGE_SELECT_LEVEL;
        }

        if(DEBUG) DoDebug("shd_mystconv: New stage: " + IntToString(nStage));

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
