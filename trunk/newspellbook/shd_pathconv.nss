//:://////////////////////////////////////////////
//:: Shadowcasting Mystery gain conversation script
//:: shd_pathconv
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
        if(DEBUG) DoDebug("shd_pathconv: Running setup stage for stage " + IntToString(nStage));
        // Check if this stage is marked as already set up
        // This stops list duplication when scrolling
        if(!GetIsStageSetUp(nStage, oPC))
        {
            if(DEBUG) DoDebug("shd_pathconv: Stage was not set up already");
            // Level selection stage
            if(nStage == STAGE_SELECT_LEVEL)
            {
                if(DEBUG) DoDebug("shd_pathconv: Building feat selection");
                SetHeader("Choose the bonus feat to gain");

                // Set the tokens
                int i;
                for(i = 23673; i < 23793; i++)
                {
                    int nPrereq = TRUE;
                    int nPreFeat = StringToInt(Get2DACache("feat", "PREREQFEAT1", i));
                    if (!GetHasFeat(nPreFeat, oPC) && nPreFeat > 0)
                        nPrereq = FALSE;
                    if (!GetHasFeat(i, oPC) && nPrereq) 
                        AddChoice(GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", i))), i);
                }
                for(i = 23851; i < 23869; i++)
                {
                    int nPrereq = TRUE;
                    int nPreFeat = StringToInt(Get2DACache("feat", "PREREQFEAT1", i));
                    if (!GetHasFeat(nPreFeat, oPC) && nPreFeat > 0)
                        nPrereq = FALSE;
                    if (!GetHasFeat(i, oPC) && nPrereq) 
                        AddChoice(GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", i))), i);
                }                 
                
                if (GetLevelByClass(CLASS_TYPE_SHADOWCASTER, oPC) && GetSkillRank(SKILL_CONCENTRATION, oPC, TRUE))
                    AddChoice(GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", 23793))), 23793);
                    
                /*int nMeta  = GetHasFeat(FEAT_EMPOWER_MYSTERY)
                           + GetHasFeat(FEAT_EXTEND_MYSTERY)
                           + GetHasFeat(FEAT_MAXIMIZE_MYSTERY)
                           + GetHasFeat(FEAT_QUICKEN_MYSTERY)
                           + GetHasFeat(FEAT_STILL_MYSTERY); 
                           
                if (nMeta >= 1)
                    AddChoice(GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", 23794))), 23794);  
                if (nMeta >= 2)
                    AddChoice(GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", 23796))), 23796);   
                if (nMeta >= 3)
                    AddChoice(GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", 23797))), 23797);                       
                    
                    AddChoice(GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", 23795))), 23795);                     
                    AddChoice(GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", 23798))), 23798); */                     

                // Set the next, previous and wait tokens to default values
                SetDefaultTokens();
                // Set the convo quit text to "Abort"
                SetCustomToken(DYNCONV_TOKEN_EXIT, GetStringByStrRef(DYNCONV_STRREF_ABORT_CONVO));
            }
            // Selection confirmation stage
            else if(nStage == STAGE_CONFIRM_SELECTION)
            {
                if(DEBUG) DoDebug("shd_pathconv: Building selection confirmation");
                // Build the confirmantion query
                string sToken = GetStringByStrRef(STRREF_SELECTED_HEADER1) + "\n\n"; // "You have selected:"
                int nFeat = GetLocalInt(oPC, "nFeat");
                if(DEBUG) DoDebug("STAGE_CONFIRM_SELECTION nFeat: " + IntToString(nFeat));
                sToken += GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", nFeat)))+"\n";
                sToken += GetStringByStrRef(StringToInt(Get2DACache("feat", "DESCRIPTION", nFeat)))+"\n\n";
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
        if(DEBUG) DoDebug("shd_pathconv: Running exit handler");
        // End of conversation cleanup
        DeleteLocalInt(oPC, "nClass");
        DeleteLocalInt(oPC, "nFeat");
        DeleteLocalInt(oPC, "nFeatLevelToBrowse");
        DeleteLocalInt(oPC, "MYSTLISTChoiceOffset");

        // Restart the convo to pick next mystery if needed
        // done via EvalPRCFeats to avoid conflicts with new spellbooks
        DelayCommand(1.0, EvalPRCFeats(oPC));
    }
    else if(nValue == DYNCONV_ABORTED)
    {
        // This section should never be run, since aborting this conversation should
        // always be forbidden and as such, any attempts to abort the conversation
        // should be handled transparently by the system
        if(DEBUG) DoDebug("shd_pathconv: ERROR: Conversation abort section run");
        DelayCommand(1.0, EvalPRCFeats(oPC));
        
        if (GetCompletedPaths(oPC) > GetPathBonusFeats(oPC))
            DelayCommand(1.0, StartDynamicConversation("shd_pathconv", oPC, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oPC));
    }
    // Handle PC response
    else
    {
        int nChoice = GetChoice(oPC);
        if(DEBUG) DoDebug("shd_pathconv: Handling PC response, stage = " + IntToString(nStage) + "; nChoice = " + IntToString(nChoice) + "; choice text = '" + GetChoiceText(oPC) +  "'");
        if(nStage == STAGE_SELECT_LEVEL)
        {
           	if(DEBUG) DoDebug("shd_pathconv: Level selected");
            SetLocalInt(oPC, "nFeat", nChoice);
            nStage = STAGE_CONFIRM_SELECTION;

            MarkStageNotSetUp(STAGE_SELECT_LEVEL, oPC);
        }
        else if(nStage == STAGE_CONFIRM_SELECTION)
        {
            if(DEBUG) DoDebug("shd_pathconv: Handling feat confirmation");
            if(nChoice == TRUE)
            {
                if(DEBUG) DoDebug("shd_pathconv: Adding feat");
                int nFeat = GetLocalInt(oPC, "nFeat");

                AddPathBonusFeat(oPC, nFeat);

                // Delete the stored offset
                DeleteLocalInt(oPC, "MYSTLISTChoiceOffset");
                // And we're all done
                AllowExit(DYNCONV_EXIT_FORCE_EXIT);                 
            }
            else
                nStage = STAGE_SELECT_LEVEL;
        }

        if(DEBUG) DoDebug("shd_pathconv: New stage: " + IntToString(nStage));

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
