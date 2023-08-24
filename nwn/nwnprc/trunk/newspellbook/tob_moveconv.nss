//:://////////////////////////////////////////////
//:: Tome of Battle Maneuver gain conversation script
//:: tob_moveconv
//:://////////////////////////////////////////////
/** @file
    This script controls the Tome of Battle maneuver selection
    conversation.


    @author Stratovarius - 2006.07.19
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "tob_inc_tobfunc"
#include "inc_dynconv"
#include "prc_inc_function"

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_SELECT_STANCE_MOVE     = 0;
const int STAGE_SELECT_LEVEL           = 1;
const int STAGE_SELECT_MANEUVER        = 2;
const int STAGE_CONFIRM_SELECTION      = 3;
const int STAGE_ALL_MANEUVERS_SELECTED = 4;

const int CHOICE_BACK_TO_LSELECT    = -1;

const int STRREF_BACK_TO_LSELECT    = 16829723; // "Return to maneuver level selection."
const int STRREF_LEVELLIST_HEADER   = 16829724; // "Select level of maneuver to gain.\n\nNOTE:\nThis may take a while when first browsing a particular level's maneuvers."
const int STRREF_MOVELIST_HEADER1   = 16829725; // "Select a maneuver to gain.\nYou can select"
const int STRREF_MOVELIST_HEADER2   = 16829726; // "more maneuvers"
const int STRREF_SELECTED_HEADER1   = 16824209; // "You have selected:"
const int STRREF_SELECTED_HEADER2   = 16824210; // "Is this correct?"
const int STRREF_END_HEADER         = 16829727; // "You will be able to select more maneuvers after you gain another level in a blade magic initiator class."
const int STRREF_END_CONVO_SELECT   = 16824212; // "Finish"
const int LEVEL_STRREF_START        = 16824809;
const int STRREF_YES                = 4752;     // "Yes"
const int STRREF_NO                 = 4753;     // "No"
const int STRREF_MOVESTANCE_HEADER  = 16829729; // "Choose Maneuver or Stances."
const int STRREF_STANCE             = 16829730; // "Stances"
const int STRREF_MANEUVER           = 16829731; // "Maneuvers"


const int SORT       = TRUE; // If the sorting takes too much CPU, set to FALSE
const int DEBUG_LIST = FALSE;

//////////////////////////////////////////////////
/* Function defintions                          */
//////////////////////////////////////////////////

void PrintList(object oInitiator)
{
    string tp = "Printing list:\n";
    string s = GetLocalString(oInitiator, "PRC_MoveConvo_List_Head");
    if(s == ""){
        tp += "Empty\n";
    }
    else{
        tp += s + "\n";
        s = GetLocalString(oInitiator, "PRC_MoveConvo_List_Next_" + s);
        while(s != ""){
            tp += "=> " + s + "\n";
            s = GetLocalString(oInitiator, "PRC_MoveConvo_List_Next_" + s);
        }
    }

    DoDebug(tp);
}

int GetDisciplineFromConv(int nMove, int nClass)
{
    string sFile = Get2DACache("classes", "FeatsTable", nClass);
    sFile = "cls_move" + GetStringRight(sFile, GetStringLength(sFile) - 8);

    return StringToInt(Get2DACache(sFile, "Discipline", nMove));
}

void AddShadowSunNinjaPrereq(object oInitiator, int nMove)
{
    if(GetLocalInt(oInitiator, "nSSNLevel") == 2)
    {
        int nDiscipline = GetDisciplineFromConv(nMove, GetLocalInt(oInitiator, "nClass"));
        if(DEBUG) DoDebug("nDiscipline: " + IntToString(nDiscipline));
        int nTest = GetPersistantLocalInt(oInitiator, "ShadowSunNinjaLv2Req");
        if(DEBUG) DoDebug("ShadowSunNinjaLv2Req: " + IntToString(nTest));
        if(!nTest && (nDiscipline == DISCIPLINE_SETTING_SUN || nDiscipline == DISCIPLINE_SHADOW_HAND))
        {
            SetPersistantLocalInt(oInitiator, "ShadowSunNinjaLv2Req", TRUE);
        }
    }
    DeleteLocalInt(oInitiator, "nSSNLevel");
}

/**
 * Creates a linked list of entries that is sorted into alphabetical order
 * as it is built.
 * Assumption: Maneuver names are unique.
 *
 * @param oInitiator     The storage object aka whomever is gaining maneuvers in this conversation
 * @param sChoice The choice string
 * @param nChoice The choice value
 */
void AddToTempList(object oInitiator, string sChoice, int nChoice)
{
    if(DEBUG_LIST) DoDebug("\nAdding to temp list: '" + sChoice + "' - " + IntToString(nChoice));
    if(DEBUG_LIST) PrintList(oInitiator);
    // If there is nothing yet
    if(!GetLocalInt(oInitiator, "PRC_MoveConvo_ListInited"))
    {
        SetLocalString(oInitiator, "PRC_MoveConvo_List_Head", sChoice);
        SetLocalInt(oInitiator, "PRC_MoveConvo_List_" + sChoice, nChoice);

        SetLocalInt(oInitiator, "PRC_MoveConvo_ListInited", TRUE);
    }
    else
    {
        // Find the location to instert into
        string sPrev = "", sNext = GetLocalString(oInitiator, "PRC_MoveConvo_List_Head");
        while(sNext != "" && StringCompare(sChoice, sNext) >= 0)
        {
            if(DEBUG_LIST) DoDebug("Comparison between '" + sChoice + "' and '" + sNext + "' = " + IntToString(StringCompare(sChoice, sNext)));
            sPrev = sNext;
            sNext = GetLocalString(oInitiator, "PRC_MoveConvo_List_Next_" + sNext);
        }

        /* Insert the new entry */
        // Does it replace the head?
        if(sPrev == "")
        {
            if(DEBUG_LIST) DoDebug("New head");
            SetLocalString(oInitiator, "PRC_MoveConvo_List_Head", sChoice);
        }
        else
        {
            if(DEBUG_LIST) DoDebug("Inserting into position between '" + sPrev + "' and '" + sNext + "'");
            SetLocalString(oInitiator, "PRC_MoveConvo_List_Next_" + sPrev, sChoice);
        }

        SetLocalString(oInitiator, "PRC_MoveConvo_List_Next_" + sChoice, sNext);
        SetLocalInt(oInitiator, "PRC_MoveConvo_List_" + sChoice, nChoice);
    }
}

/**
 * Reads the linked list built with AddToTempList() to AddChoice() and
 * deletes it.
 *
 * @param oInitiator A PC gaining maneuvers at the moment
 */
void TransferTempList(object oInitiator)
{
    string sChoice = GetLocalString(oInitiator, "PRC_MoveConvo_List_Head");
    int    nChoice = GetLocalInt   (oInitiator, "PRC_MoveConvo_List_" + sChoice);

    DeleteLocalString(oInitiator, "PRC_MoveConvo_List_Head");
    string sPrev;

    if(DEBUG_LIST) DoDebug("Head is: '" + sChoice + "' - " + IntToString(nChoice));

    while(sChoice != "")
    {
        // Add the choice
        AddChoice(sChoice, nChoice, oInitiator);

        // Get next
        sChoice = GetLocalString(oInitiator, "PRC_MoveConvo_List_Next_" + (sPrev = sChoice));
        nChoice = GetLocalInt   (oInitiator, "PRC_MoveConvo_List_" + sChoice);

        if(DEBUG_LIST) DoDebug("Next is: '" + sChoice + "' - " + IntToString(nChoice) + "; previous = '" + sPrev + "'");

        // Delete the already handled data
        DeleteLocalString(oInitiator, "PRC_MoveConvo_List_Next_" + sPrev);
        DeleteLocalInt   (oInitiator, "PRC_MoveConvo_List_" + sPrev);
    }

    DeleteLocalInt(oInitiator, "PRC_MoveConvo_ListInited");
}


void main()
{
    object oInitiator = GetPCSpeaker();
    int nValue = GetLocalInt(oInitiator, DYNCONV_VARIABLE);
    int nStage = GetStage(oInitiator);

    int nClass = GetLocalInt(oInitiator, "nClass");
    string sPsiFile = GetAMSKnownFileName(nClass);
    string sManeuverFile = GetAMSDefinitionFileName(nClass);

    // Check which of the conversation scripts called the scripts
    if(nValue == 0) // All of them set the DynConv_Var to non-zero value, so something is wrong -> abort
        return;

    if(nValue == DYNCONV_SETUP_STAGE)
    {
        if(DEBUG) DoDebug("tob_moveconv: Running setup stage for stage " + IntToString(nStage));
        // Check if this stage is marked as already set up
        // This stops list duplication when scrolling
        if(!GetIsStageSetUp(nStage, oInitiator))
        {
            if(DEBUG) DoDebug("tob_moveconv: Stage was not set up already");
            // Level selection stage
	    if(nStage == STAGE_SELECT_STANCE_MOVE)
            {
                if(DEBUG) DoDebug("tob_moveconv: Building maneuver or stance selection");
                SetHeader(GetStringByStrRef(STRREF_MOVESTANCE_HEADER));

                // Determine whether they're missing maneuvers or stances
                int nMaxMove = GetMaxManeuverCount(oInitiator, nClass, MANEUVER_TYPE_MANEUVER);
                int nMaxStance = GetMaxManeuverCount(oInitiator, nClass, MANEUVER_TYPE_STANCE);
                int nCountMove = GetManeuverCount(oInitiator, nClass, MANEUVER_TYPE_MANEUVER);
                int nCountStance = GetManeuverCount(oInitiator, nClass, MANEUVER_TYPE_STANCE);

                // Set the tokens
                // If the max they should have is greater than the amount they do have, add the choice.
                if (nMaxMove > nCountMove)
                	AddChoice(GetStringByStrRef(STRREF_MANEUVER), MANEUVER_TYPE_MANEUVER);
                if (nMaxStance > nCountStance)
                	AddChoice(GetStringByStrRef(STRREF_STANCE), MANEUVER_TYPE_STANCE);

                // Set the next, previous and wait tokens to default values
                SetDefaultTokens();
                // Set the convo quit text to "Abort"
                SetCustomToken(DYNCONV_TOKEN_EXIT, GetStringByStrRef(DYNCONV_STRREF_ABORT_CONVO));
            }
            if(nStage == STAGE_SELECT_LEVEL)
            {
                if(DEBUG) DoDebug("tob_moveconv: Building level selection");
                SetHeader(GetStringByStrRef(STRREF_LEVELLIST_HEADER));

                // Determine maximum maneuver level
                // Initiators get new maneuvers at the same levels as wizards
                // See ToB p39, table 3-1
                int nMaxLevel = min(9, (GetInitiatorLevel(oInitiator, nClass) + 1)/2);

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
            // Maneuver selection stage
            if(nStage == STAGE_SELECT_MANEUVER)
            {
                if(DEBUG) DoDebug("tob_moveconv: Building maneuver selection");
                int nMoveStance = GetLocalInt(oInitiator, "nStanceOrManeuver");

                int nCurrentManeuvers = GetManeuverCount(oInitiator, nClass, nMoveStance);
                int nMaxManeuvers = GetMaxManeuverCount(oInitiator, nClass, nMoveStance);
                string sToken = GetStringByStrRef(STRREF_MOVELIST_HEADER1) + " " + //"Select a maneuver to gain.\n You can select "
                                IntToString(nMaxManeuvers-nCurrentManeuvers) + " " +
                                GetStringByStrRef(STRREF_MOVELIST_HEADER2);        //" more maneuvers"
                SetHeader(sToken);

                // Set the first choice to be return to level selection stage
                AddChoice(GetStringByStrRef(STRREF_BACK_TO_LSELECT), CHOICE_BACK_TO_LSELECT, oInitiator);

                // Determine maximum maneuver level
                int nInitiatorLevel = GetInitiatorLevel(oInitiator, nClass);
                int nManeuverLevelToBrowse = GetLocalInt(oInitiator, "nManeuverLevelToBrowse");
                int i, nManeuverLevel, nDiscipline, nFeatID, nPrereqs;
                for(i = 1; i < GetPRCSwitch(FILE_END_CLASS_POWER) ; i++)
                {
                    nManeuverLevel = StringToInt(Get2DACache(sManeuverFile, "Level", i));
                    // Skip any maneuvers of too low or too high level
                    if(nManeuverLevel != nManeuverLevelToBrowse){
                        continue;
                    }
                    // If looking for stances, skip maneuvers, else reverse
                    if(nMoveStance == MANEUVER_TYPE_STANCE && Get2DACache(sManeuverFile, "Type", i) != "1"){
                        continue;
                    }  // Skip stances when looking for maneuvers
                    else if(nMoveStance == MANEUVER_TYPE_MANEUVER && Get2DACache(sManeuverFile, "Type", i) == "1"){
                        continue;
                    }
                    nDiscipline = StringToInt(Get2DACache(sManeuverFile, "Discipline", i));
                    if(nDiscipline)// Non-blank row
                    {
                        nFeatID = StringToInt(Get2DACache(sManeuverFile, "FeatID", i));
                        nPrereqs = StringToInt(Get2DACache(sManeuverFile, "Prereqs", i));
                        if(!GetHasFeat(nFeatID, oInitiator)  // PC does not already possess the maneuver
                        && CheckManeuverPrereqs(nClass, nPrereqs, nDiscipline, oInitiator)) // PC possess the prerequisites
                        {
                            if(SORT) AddToTempList(oInitiator, GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", nFeatID))), i);
                            else     AddChoice(GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", nFeatID))), i, oInitiator);
                        }
                    }
                }

                if(SORT) TransferTempList(oInitiator);

                /* Hack - In the maneuver selection stage, on returning from
                 * confirmation dialog where the answer was "No", restore the
                 * offset to be the same as on entering the confirmation dialog.
                 */
                if(GetLocalInt(oInitiator, "ManeuverListChoiceOffset"))
                {
                    if(DEBUG) DoDebug("tob_moveconv: Running offset restoration hack");
                    SetLocalInt(oInitiator, DYNCONV_CHOICEOFFSET, GetLocalInt(oInitiator, "ManeuverListChoiceOffset") - 1);
                    DeleteLocalInt(oInitiator, "ManeuverListChoiceOffset");
                }

                MarkStageSetUp(STAGE_SELECT_MANEUVER, oInitiator);
            }
            // Selection confirmation stage
            else if(nStage == STAGE_CONFIRM_SELECTION)
            {
                if(DEBUG) DoDebug("tob_moveconv: Building selection confirmation");
                // Build the confirmantion query
                string sToken = GetStringByStrRef(STRREF_SELECTED_HEADER1) + "\n \n"; // "You have selected:"
                int nManeuver = GetLocalInt(oInitiator, "nManeuver");
                int nFeatID = StringToInt(Get2DACache(sManeuverFile, "FeatID", nManeuver));
                sToken += GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", nFeatID)))+"\n";
                sToken += GetStringByStrRef(StringToInt(Get2DACache("feat", "DESCRIPTION", nFeatID)))+"\n \n";
                sToken += GetStringByStrRef(STRREF_SELECTED_HEADER2); // "Is this correct?"
                SetHeader(sToken);

                AddChoice(GetStringByStrRef(STRREF_YES), TRUE, oInitiator); // "Yes"
                AddChoice(GetStringByStrRef(STRREF_NO), FALSE, oInitiator); // "No"
            }
            // Conversation finished stage
            else if(nStage == STAGE_ALL_MANEUVERS_SELECTED)
            {
                if(DEBUG) DoDebug("tob_moveconv: Building finish note");
                SetHeader(GetStringByStrRef(STRREF_END_HEADER));
                // Set the convo quit text to "Finish"
                SetCustomToken(DYNCONV_TOKEN_EXIT, GetStringByStrRef(STRREF_END_CONVO_SELECT));
                AllowExit(DYNCONV_EXIT_ALLOWED_SHOW_CHOICE, FALSE, oInitiator);
            }
        }

        // Do token setup
        SetupTokens();
    }
    else if(nValue == DYNCONV_EXITED)
    {
        if(DEBUG) DoDebug("tob_moveconv: Running exit handler");
        // End of conversation cleanup
        DeleteLocalInt(oInitiator, "nClass");
        DeleteLocalInt(oInitiator, "nManeuver");
        DeleteLocalInt(oInitiator, "nStanceOrManeuver");
        DeleteLocalInt(oInitiator, "nManeuverLevelToBrowse");
        DeleteLocalInt(oInitiator, "ManeuverListChoiceOffset");

        // Restart the convo to pick next maneuver if needed
        // done via EvalPRCFFeats to avoid convlicts with new spellbooks
        //ExecuteScript("psi_maneuvergain", oInitiator);
        DelayCommand(1.0, EvalPRCFeats(oInitiator));
    }
    else if(nValue == DYNCONV_ABORTED)
    {
        // This section should never be run, since aborting this conversation should
        // always be forbidden and as such, any attempts to abort the conversation
        // should be handled transparently by the system
        if(DEBUG) DoDebug("tob_moveconv: ERROR: Conversation abort section run");
    }
    // Handle PC response
    else
    {
        int nChoice = GetChoice(oInitiator);
        if(DEBUG) DoDebug("tob_moveconv: Handling PC response, stage = " + IntToString(nStage) + "; nChoice = " + IntToString(nChoice) + "; choice text = '" + GetChoiceText(oInitiator) +  "'");
        if(nStage == STAGE_SELECT_STANCE_MOVE)
        {
            if(DEBUG) DoDebug("tob_moveconv: Stance or Maneuver selected");
            SetLocalInt(oInitiator, "nStanceOrManeuver", nChoice);
            nStage = STAGE_SELECT_LEVEL;
        }
        else if(nStage == STAGE_SELECT_LEVEL)
        {
            if(DEBUG) DoDebug("tob_moveconv: Level selected");
            SetLocalInt(oInitiator, "nManeuverLevelToBrowse", nChoice);
            SetLocalInt(oInitiator, "nSSNLevel", nChoice);
            nStage = STAGE_SELECT_MANEUVER;
        }
        else if(nStage == STAGE_SELECT_MANEUVER)
        {
            if(nChoice == CHOICE_BACK_TO_LSELECT)
            {
                if(DEBUG) DoDebug("tob_moveconv: Returning to level selection");
                nStage = STAGE_SELECT_STANCE_MOVE;
                DeleteLocalInt(oInitiator, "nManeuverLevelToBrowse");
            }
            else
            {
                if(DEBUG) DoDebug("tob_moveconv: Entering maneuver confirmation");
                SetLocalInt(oInitiator, "nManeuver", nChoice);
                // Store offset so that if the user decides not to take the maneuver,
                // we can return to the same page in the maneuver list instead of resetting to the beginning
                // Store the value +1 in order to be able to differentiate between offset 0 and undefined
                SetLocalInt(oInitiator, "ManeuverListChoiceOffset", GetLocalInt(oInitiator, DYNCONV_CHOICEOFFSET) + 1);
                nStage = STAGE_CONFIRM_SELECTION;
            }
            MarkStageNotSetUp(STAGE_SELECT_MANEUVER, oInitiator);
        }
        else if(nStage == STAGE_CONFIRM_SELECTION)
        {
            if(DEBUG) DoDebug("tob_moveconv: Handling maneuver confirmation");
            int nMoveStance = GetLocalInt(oInitiator, "nStanceOrManeuver");
            if(nChoice == TRUE)
            {
                if(DEBUG) DoDebug("tob_moveconv: Adding maneuver");
                int nManeuver = GetLocalInt(oInitiator, "nManeuver");

                // This triggers regardless of PC being Shadow Sun Ninja
                AddShadowSunNinjaPrereq(oInitiator, nManeuver);

                AddManeuverKnown(oInitiator, nClass, nManeuver, nMoveStance, TRUE, GetHitDice(oInitiator));

                // Delete the stored offset
                DeleteLocalInt(oInitiator, "ManeuverListChoiceOffset");
            }

            // Determine whether they're missing maneuvers or stances
            int nMaxMove = GetMaxManeuverCount(oInitiator, nClass, MANEUVER_TYPE_MANEUVER);
            int nMaxStance = GetMaxManeuverCount(oInitiator, nClass, MANEUVER_TYPE_STANCE);
            int nCountMove = GetManeuverCount(oInitiator, nClass, MANEUVER_TYPE_MANEUVER);
            int nCountStance = GetManeuverCount(oInitiator, nClass, MANEUVER_TYPE_STANCE);
            if(DEBUG) DoDebug("tob_moveconv: nCountMove: " + IntToString(nCountMove));
            if(DEBUG) DoDebug("tob_moveconv: nMaxMove: " + IntToString(nMaxMove));
            if(DEBUG) DoDebug("tob_moveconv: nCountStance: " + IntToString(nCountStance));
            if(DEBUG) DoDebug("tob_moveconv: nMaxStance: " + IntToString(nMaxStance));
            if(nCountStance >= nMaxStance && nCountMove >= nMaxMove)
            {
                nStage = STAGE_ALL_MANEUVERS_SELECTED;
                // Clean up all of these
                DeletePersistantLocalInt(oInitiator, "AllowedDisciplines");
                if(DEBUG) DoDebug("tob_moveconv: AllowedDisciplines: " + IntToString(GetPersistantLocalInt(oInitiator, "AllowedDisciplines")));
            }
            else
                nStage = STAGE_SELECT_STANCE_MOVE;
        }

        if(DEBUG) DoDebug("tob_moveconv: New stage: " + IntToString(nStage));

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oInitiator);
    }
}
