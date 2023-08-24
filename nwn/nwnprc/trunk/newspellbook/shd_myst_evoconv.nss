//:://////////////////////////////////////////////
//:: Shadow Evocation choice script
//:: shd_myst_evoconv
//:://////////////////////////////////////////////
/** @file
    @author Stratovarius - 2019.02.14
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
const int STAGE_SELECT_EVOCATION       = 1;
const int STAGE_CONFIRM_SELECTION      = 2;

const int CHOICE_BACK_TO_LSELECT    = -1;

const int STRREF_BACK_TO_LSELECT    = 16836035; // "Return to level selection."
const int STRREF_MYSTLIST_HEADER2   = 16836038; // "more mysteries"
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

void PrintList(object oShadow)
{
    string tp = "Printing list:\n";
    string s = GetLocalString(oShadow, "PRC_MystConvo_List_Head");
    if(s == ""){
        tp += "Empty\n";
    }
    else{
        tp += s + "\n";
        s = GetLocalString(oShadow, "PRC_MystConvo_List_Next_" + s);
        while(s != ""){
            tp += "=> " + s + "\n";
            s = GetLocalString(oShadow, "PRC_MystConvo_List_Next_" + s);
        }
    }

    DoDebug(tp);
}

/**
 * Creates a linked list of entries that is sorted into alphabetical order
 * as it is built.
 * Assumption: mystery names are unique.
 *
 * @param oShadow     The storage object aka whomever is gaining powers in this conversation
 * @param sChoice The choice string
 * @param nChoice The choice value
 */
void AddToTempList(object oShadow, string sChoice, int nChoice)
{
    if(DEBUG_LIST) DoDebug("\nAdding to temp list: '" + sChoice + "' - " + IntToString(nChoice));
    if(DEBUG_LIST) PrintList(oShadow);
    // If there is nothing yet
    if(!GetLocalInt(oShadow, "PRC_MystConvo_ListInited"))
    {
        SetLocalString(oShadow, "PRC_MystConvo_List_Head", sChoice);
        SetLocalInt(oShadow, "PRC_MystConvo_List_" + sChoice, nChoice);

        SetLocalInt(oShadow, "PRC_MystConvo_ListInited", TRUE);
    }
    else
    {
        // Find the location to instert into
        string sPrev = "", sNext = GetLocalString(oShadow, "PRC_MystConvo_List_Head");
        while(sNext != "" && StringCompare(sChoice, sNext) >= 0)
        {
            if(DEBUG_LIST) DoDebug("Comparison between '" + sChoice + "' and '" + sNext + "' = " + IntToString(StringCompare(sChoice, sNext)));
            sPrev = sNext;
            sNext = GetLocalString(oShadow, "PRC_MystConvo_List_Next_" + sNext);
        }

        // Insert the new entry
        // Does it replace the head?
        if(sPrev == "")
        {
            if(DEBUG_LIST) DoDebug("New head");
            SetLocalString(oShadow, "PRC_MystConvo_List_Head", sChoice);
        }
        else
        {
            if(DEBUG_LIST) DoDebug("Inserting into position between '" + sPrev + "' and '" + sNext + "'");
            SetLocalString(oShadow, "PRC_MystConvo_List_Next_" + sPrev, sChoice);
        }

        SetLocalString(oShadow, "PRC_MystConvo_List_Next_" + sChoice, sNext);
        SetLocalInt(oShadow, "PRC_MystConvo_List_" + sChoice, nChoice);
    }
}

/**
 * Reads the linked list built with AddToTempList() to AddChoice() and
 * deletes it.
 *
 * @param oShadow A PC gaining powers at the moment
 */
void TransferTempList(object oShadow)
{
    string sChoice = GetLocalString(oShadow, "PRC_MystConvo_List_Head");
    int    nChoice = GetLocalInt   (oShadow, "PRC_MystConvo_List_" + sChoice);

    DeleteLocalString(oShadow, "PRC_MystConvo_List_Head");
    string sPrev;

    if(DEBUG_LIST) DoDebug("Head is: '" + sChoice + "' - " + IntToString(nChoice));

    while(sChoice != "")
    {
        // Add the choice
        AddChoice(sChoice, nChoice, oShadow);

        // Get next
        sChoice = GetLocalString(oShadow, "PRC_MystConvo_List_Next_" + (sPrev = sChoice));
        nChoice = GetLocalInt   (oShadow, "PRC_MystConvo_List_" + sChoice);

        if(DEBUG_LIST) DoDebug("Next is: '" + sChoice + "' - " + IntToString(nChoice) + "; previous = '" + sPrev + "'");

        // Delete the already handled data
        DeleteLocalString(oShadow, "PRC_MystConvo_List_Next_" + sPrev);
        DeleteLocalInt   (oShadow, "PRC_MystConvo_List_" + sPrev);
    }

    DeleteLocalInt(oShadow, "PRC_MystConvo_ListInited");
}

void main()
{
    object oShadow = GetPCSpeaker();
    int nValue = GetLocalInt(oShadow, DYNCONV_VARIABLE);
    int nStage = GetStage(oShadow);

    string sPowerFile = "cls_spell_sorc"; 

    // Check which of the conversation scripts called the scripts
    if(nValue == 0) // All of them set the DynConv_Var to non-zero value, so something is wrong -> abort
        return;

    if(nValue == DYNCONV_SETUP_STAGE)
    {
        if(DEBUG) DoDebug("shd_myst_evoconv: Running setup stage for stage " + IntToString(nStage));
        // Check if this stage is marked as already set up
        // This stops list duplication when scrolling
        if(!GetIsStageSetUp(nStage, oShadow))
        {
            if(DEBUG) DoDebug("shd_myst_evoconv: Stage was not set up already");
            // Level selection stage
            if(nStage == STAGE_SELECT_LEVEL)
            {
                if(DEBUG) DoDebug("shd_myst_evoconv: Building level selection");
                SetHeader("Choose the level of evocation to shadowcast");


                // Set the tokens. Max 5th level spell, currently.
                int nMax = GetLocalInt(oShadow, "ShadowEvoMax");
                int i;
                for(i = 0; i < nMax; i++){
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
            if(nStage == STAGE_SELECT_EVOCATION)
            {
                if(DEBUG) DoDebug("shd_myst_evoconv: Building mystery selection");

                SetHeader("Select an evocation to store for Shadow Evocation");

                // Set the first choice to be return to level selection stage
                AddChoice(GetStringByStrRef(STRREF_BACK_TO_LSELECT), CHOICE_BACK_TO_LSELECT, oShadow);

                int nEvoLevelToBrowse = GetLocalInt(oShadow, "nEvoLevelToBrowse");

                if(DEBUG)
                {
                	DoDebug("shd_myst_evoconv: Evocation Level To Browse: " + IntToString(nEvoLevelToBrowse));
                }


                int i, nEvoLevel;
                string sFeatID;
                for(i = 0; i < 440 ; i++)
                {
                    nEvoLevel = StringToInt(Get2DACache(sPowerFile, "Level", i));
                    // Skip any powers of too low level
                    if(nEvoLevel < nEvoLevelToBrowse){
                        continue;
                    }
                     //Due to the way the 2das are structured, we know that once
                     //the level of a read evocation is greater than the maximum castable
                     //it'll never be lower again. Therefore, we can skip reading the
                     //evocations that wouldn't be shown anyway.
                     
                    if(nEvoLevel > nEvoLevelToBrowse){
                        break;
                    }
                    sFeatID = Get2DACache(sPowerFile, "FeatID", i);
                    int nSpellId = StringToInt(Get2DACache(sPowerFile, "RealSpellID", i));
                    if(sFeatID != "") // Non-blank row
                    {
                        if ("V" == Get2DACache("spells", "School", nSpellId))
                        {
                            if(SORT) AddToTempList(oShadow, GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSpellId))), nSpellId);
                            else     AddChoice(GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSpellId))), nSpellId, oShadow);
                        }    
                    }
                }

                if(SORT) TransferTempList(oShadow);

                // Hack - In the mystery selection stage, on returning from
                // confirmation dialog where the answer was "No", restore the
                // offset to be the same as on entering the confirmation dialog.
                if(GetLocalInt(oShadow, "MYSTLISTChoiceOffset"))
                {
                    if(DEBUG) DoDebug("shd_myst_evoconv: Running offset restoration hack");
                    SetLocalInt(oShadow, DYNCONV_CHOICEOFFSET, GetLocalInt(oShadow, "MYSTLISTChoiceOffset") - 1);
                    DeleteLocalInt(oShadow, "MYSTLISTChoiceOffset");
                }

                MarkStageSetUp(STAGE_SELECT_EVOCATION, oShadow);
            }
            // Selection confirmation stage
            else if(nStage == STAGE_CONFIRM_SELECTION)
            {
                if(DEBUG) DoDebug("shd_myst_evoconv: Building selection confirmation");
                // Build the confirmantion query
                string sToken = GetStringByStrRef(STRREF_SELECTED_HEADER1) + "\n\n"; // "You have selected:"
                int nSpellId = GetLocalInt(oShadow, "nEvo");
                sToken += GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSpellId)))+"\n";
                sToken += GetStringByStrRef(StringToInt(Get2DACache("spells", "SpellDesc", nSpellId)))+"\n\n";
                sToken += GetStringByStrRef(STRREF_SELECTED_HEADER2); // "Is this correct?"
                SetHeader(sToken);

                AddChoice(GetStringByStrRef(STRREF_YES), TRUE, oShadow); // "Yes"
                AddChoice(GetStringByStrRef(STRREF_NO), FALSE, oShadow); // "No"
            }
        }

        // Do token setup
        SetupTokens();
    }
    else if(nValue == DYNCONV_EXITED)
    {
        if(DEBUG) DoDebug("shd_myst_evoconv: Running exit handler");
        // End of conversation cleanup
        DeleteLocalInt(oShadow, "nClass");
        DeleteLocalInt(oShadow, "nEvo");
        DeleteLocalInt(oShadow, "nEvoLevelToBrowse");
        DeleteLocalInt(oShadow, "MYSTLISTChoiceOffset");
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
        int nChoice = GetChoice(oShadow);
        if(DEBUG) DoDebug("shd_myst_evoconv: Handling PC response, stage = " + IntToString(nStage) + "; nChoice = " + IntToString(nChoice) + "; choice text = '" + GetChoiceText(oShadow) +  "'");
        if(nStage == STAGE_SELECT_LEVEL)
        {
           	if(DEBUG) DoDebug("shd_myst_evoconv: Level selected");
           	SetLocalInt(oShadow, "nEvoLevelToBrowse", nChoice);
           	nStage = STAGE_SELECT_EVOCATION;

            MarkStageNotSetUp(STAGE_SELECT_LEVEL, oShadow);
        }
        else if(nStage == STAGE_SELECT_EVOCATION)
        {
            if(nChoice == CHOICE_BACK_TO_LSELECT)
            {
                if(DEBUG) DoDebug("shd_myst_evoconv: Returning to level selection");
                nStage = STAGE_SELECT_LEVEL;
                // Clean up
                DeleteLocalInt(oShadow, "nEvoLevelToBrowse");
            }
            else
            {
                if(DEBUG) DoDebug("shd_myst_evoconv: Entering mystery confirmation");
                SetLocalInt(oShadow, "nEvo", nChoice);
                // Store offset so that if the user decides not to take the mystery,
                // we can return to the same page in the mystery list instead of resetting to the beginning
                // Store the value +1 in order to be able to differentiate between offset 0 and undefined
                SetLocalInt(oShadow, "MYSTLISTChoiceOffset", GetLocalInt(oShadow, DYNCONV_CHOICEOFFSET) + 1);
                nStage = STAGE_CONFIRM_SELECTION;
            }
            MarkStageNotSetUp(STAGE_SELECT_EVOCATION, oShadow);
        }
        else if(nStage == STAGE_CONFIRM_SELECTION)
        {
            SetLocalInt(oShadow, "ShadowEvocation", GetLocalInt(oShadow, "nEvo"));
            // And we're all done
            AllowExit(DYNCONV_EXIT_FORCE_EXIT); 
        }

        if(DEBUG) DoDebug("shd_myst_evoconv: New stage: " + IntToString(nStage));

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oShadow);
    }
}
