//:://////////////////////////////////////////////
//:: Psionic Power gain conversation script
//:: psi_powconv
//:://////////////////////////////////////////////
/** @file
    This script controls the psionic power selection
    conversation.


    @author Primogenitor - Orinigal
    @author Ornedan - Modifications
    @date   Modified - 2005.03.13
    @date   Modified - 2005.09.23
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "psi_inc_psifunc"
#include "prc_inc_function"
#include "inc_dynconv"


//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_SELECT_CLASS        = 0;
const int STAGE_SELECT_LEVEL        = 1;
const int STAGE_SELECT_POWER        = 2;
const int STAGE_CONFIRM_SELECTION   = 3;
const int STAGE_ALL_POWERS_SELECTED = 4;

const int CHOICE_BACK_TO_LSELECT    = -1;

const int STRREF_BACK_TO_LSELECT    = 16824205; // "Return to power level selection."
const int STRREF_LEVELLIST_HEADER   = 16824206; // "Select level of power to gain.\n\nNOTE:\nThis may take a while when first browsing a particular level's powers."
const int STRREF_POWERLIST_HEADER1  = 16824207; // "Select a power to gain.\nYou can select"
const int STRREF_POWERLIST_HEADER2  = 16824208; // "more powers"
const int STRREF_SELECTED_HEADER1   = 16824209; // "You have selected:"
const int STRREF_SELECTED_HEADER2   = 16824210; // "Is this correct?"
const int STRREF_END_HEADER         = 16824211; // "You will be able to select more powers after you gain another level in a psionic caster class."
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
    string s = GetLocalString(oPC, "PRC_PowConvo_List_Head");
    if(s == ""){
        tp += "Empty\n";
    }
    else{
        tp += s + "\n";
        s = GetLocalString(oPC, "PRC_PowConvo_List_Next_" + s);
        while(s != ""){
            tp += "=> " + s + "\n";
            s = GetLocalString(oPC, "PRC_PowConvo_List_Next_" + s);
        }
    }

    DoDebug(tp);
}

/**
 * Creates a linked list of entries that is sorted into alphabetical order
 * as it is built.
 * Assumption: Power names are unique.
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
    if(!GetLocalInt(oPC, "PRC_PowConvo_ListInited"))
    {
        SetLocalString(oPC, "PRC_PowConvo_List_Head", sChoice);
        SetLocalInt(oPC, "PRC_PowConvo_List_" + sChoice, nChoice);

        SetLocalInt(oPC, "PRC_PowConvo_ListInited", TRUE);
    }
    else
    {
        // Find the location to instert into
        string sPrev = "", sNext = GetLocalString(oPC, "PRC_PowConvo_List_Head");
        while(sNext != "" && StringCompare(sChoice, sNext) >= 0)
        {
            if(DEBUG_LIST) DoDebug("Comparison between '" + sChoice + "' and '" + sNext + "' = " + IntToString(StringCompare(sChoice, sNext)));
            sPrev = sNext;
            sNext = GetLocalString(oPC, "PRC_PowConvo_List_Next_" + sNext);
        }

        /* Insert the new entry */
        // Does it replace the head?
        if(sPrev == "")
        {
            if(DEBUG_LIST) DoDebug("New head");
            SetLocalString(oPC, "PRC_PowConvo_List_Head", sChoice);
        }
        else
        {
            if(DEBUG_LIST) DoDebug("Inserting into position between '" + sPrev + "' and '" + sNext + "'");
            SetLocalString(oPC, "PRC_PowConvo_List_Next_" + sPrev, sChoice);
        }

        SetLocalString(oPC, "PRC_PowConvo_List_Next_" + sChoice, sNext);
        SetLocalInt(oPC, "PRC_PowConvo_List_" + sChoice, nChoice);
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
    string sChoice = GetLocalString(oPC, "PRC_PowConvo_List_Head");
    int    nChoice = GetLocalInt   (oPC, "PRC_PowConvo_List_" + sChoice);

    DeleteLocalString(oPC, "PRC_PowConvo_List_Head");
    string sPrev;

    if(DEBUG_LIST) DoDebug("Head is: '" + sChoice + "' - " + IntToString(nChoice));

    while(sChoice != "")
    {
        // Add the choice
        AddChoice(sChoice, nChoice, oPC);

        // Get next
        sChoice = GetLocalString(oPC, "PRC_PowConvo_List_Next_" + (sPrev = sChoice));
        nChoice = GetLocalInt   (oPC, "PRC_PowConvo_List_" + sChoice);

        if(DEBUG_LIST) DoDebug("Next is: '" + sChoice + "' - " + IntToString(nChoice) + "; previous = '" + sPrev + "'");

        // Delete the already handled data
        DeleteLocalString(oPC, "PRC_PowConvo_List_Next_" + sPrev);
        DeleteLocalInt   (oPC, "PRC_PowConvo_List_" + sPrev);
    }

    DeleteLocalInt(oPC, "PRC_PowConvo_ListInited");
}


void main()
{
    object oPC = GetPCSpeaker();
    int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);
    int nStage = GetStage(oPC);

    int nClass = GetLocalInt(oPC, "nClass");
    int nExpKnow = GetLocalInt(oPC, "nExpKnow");
    string sPsiFile = GetAMSKnownFileName(nClass);
    string sPowerFile = GetAMSDefinitionFileName(nClass);

    // Check which of the conversation scripts called the scripts
    if(nValue == 0) // All of them set the DynConv_Var to non-zero value, so something is wrong -> abort
        return;

    if(nValue == DYNCONV_SETUP_STAGE)
    {
        if(DEBUG) DoDebug("psi_powconv: Running setup stage for stage " + IntToString(nStage));
        // Check if this stage is marked as already set up
        // This stops list duplication when scrolling
        if(!GetIsStageSetUp(nStage, oPC))
        {
            if(DEBUG) DoDebug("psi_powconv: Stage was not set up already");
            if(nStage == STAGE_SELECT_CLASS)
            {
                //expanded knowledge - select class
                if(nClass == -1 || nClass == -2)
                {
                    SetLocalInt(oPC, "nExpKnow", nClass);

                    SetHeader("Select class");
                    int i, nTest, nPrev;
                    for(i = 1; i <= 8; i++)
                    {
                        nTest = GetClassByPosition(i, oPC);
                        if(GetIsPsionicClass(nTest))
                        {
                            string sClassName = GetStringByStrRef(StringToInt(Get2DACache("classes", "Name", nTest)));
                            AddChoice(sClassName, nTest, oPC);
                        }
                    }
                }
                else
                {
                    // advance to next stage
                    SetStage(++nStage, oPC);
                }

                MarkStageSetUp(STAGE_SELECT_CLASS, oPC);
            }
            // Level selection stage
            if(nStage == STAGE_SELECT_LEVEL)
            {
                if(DEBUG) DoDebug("psi_powconv: Building level selection");
                SetHeader(GetStringByStrRef(STRREF_LEVELLIST_HEADER));

                // Determine maximum power level
                int nManifestLevel = GetManifesterLevel(oPC, nClass, TRUE);
                int nMaxLevel = StringToInt(Get2DACache(sPsiFile, "MaxPowerLevel", nManifestLevel - 1));

                if(nExpKnow == -1)
                    nMaxLevel--;

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
            // Power selection stage
            if(nStage == STAGE_SELECT_POWER)
            {
                if(DEBUG) DoDebug("psi_powconv: Building power selection");
                if(nExpKnow < 0) nClass = nExpKnow;
                int nCurrentPowers = GetPowerCount(oPC, nClass);
                int nMaxPowers = GetMaxPowerCount(oPC, nClass);

                string sToken = GetStringByStrRef(STRREF_POWERLIST_HEADER1) + " " + //"Select a power to gain.\n You can select "
                                IntToString(nMaxPowers-nCurrentPowers) + " " +
                                GetStringByStrRef(STRREF_POWERLIST_HEADER2);        //" more powers"
                SetHeader(sToken);

                // Set the first choice to be return to level selection stage
                AddChoice(GetStringByStrRef(STRREF_BACK_TO_LSELECT), CHOICE_BACK_TO_LSELECT, oPC);

                // Determine maximum power level
                int nManifestLevel = GetManifesterLevel(oPC, nClass, TRUE);
                int nMaxLevel = StringToInt(Get2DACache(sPsiFile, "MaxPowerLevel", nManifestLevel-1));

                int nPowerLevelToBrowse = GetLocalInt(oPC, "nPowerLevelToBrowse");
                int i, nPowerLevel;
                string sFeatID;
                for(i = 0; i < GetPRCSwitch(FILE_END_CLASS_POWER) ; i++)
                {
                    nPowerLevel = StringToInt(Get2DACache(sPowerFile, "Level", i));
                    // Skip any powers of too low level
                    if(nPowerLevel < nPowerLevelToBrowse){
                        continue;
                    }
                    /* Due to the way the power list 2das are structured, we know that once
                     * the level of a read power is greater than the maximum manifestable
                     * it'll never be lower again. Therefore, we can skip reading the
                     * powers that wouldn't be shown anyway.
                     */
                    if(nPowerLevel > nPowerLevelToBrowse){
                        break;
                    }
                    sFeatID = Get2DACache(sPowerFile, "FeatID", i);
                    int nSpellID = StringToInt(Get2DACache(sPowerFile, "RealSpellID", i));
                    if(sFeatID != ""                                           // Non-blank row
                     && !GetHasFeat(StringToInt(sFeatID), oPC)                 // PC does not already posses the power
                     && ((nExpKnow > -1 && !StringToInt(Get2DACache(sPowerFile, "Exp", i)) // check expanded knowledge power
                     && CheckPowerPrereqs(StringToInt(sFeatID), oPC)) || nExpKnow < 0)     // and the PC possess the prerequisites
                       )
                    {
                        if(SORT) AddToTempList(oPC, GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSpellID))), i);
                        else     AddChoice(GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSpellID))), i, oPC);
                    }
                }

                if(SORT) TransferTempList(oPC);

                /* Hack - In the power selection stage, on returning from
                 * confirmation dialog where the answer was "No", restore the
                 * offset to be the same as on entering the confirmation dialog.
                 */
                if(GetLocalInt(oPC, "PowerListChoiceOffset"))
                {
                    if(DEBUG) DoDebug("psi_powconv: Running offset restoration hack");
                    SetLocalInt(oPC, DYNCONV_CHOICEOFFSET, GetLocalInt(oPC, "PowerListChoiceOffset") - 1);
                    DeleteLocalInt(oPC, "PowerListChoiceOffset");
                }

                MarkStageSetUp(STAGE_SELECT_POWER, oPC);
            }
            // Selection confirmation stage
            else if(nStage == STAGE_CONFIRM_SELECTION)
            {
                if(DEBUG) DoDebug("psi_powconv: Building selection confirmation");
                // Build the confirmantion query
                string sToken = GetStringByStrRef(STRREF_SELECTED_HEADER1) + "\n\n"; // "You have selected:"
                int nPower = GetLocalInt(oPC, "nPower");
                int nFeatID = StringToInt(Get2DACache(sPowerFile, "FeatID", nPower));
                int nSpellID = StringToInt(Get2DACache(sPowerFile, "RealSpellID", nPower));
                sToken += GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSpellID)))+"\n";
                sToken += GetStringByStrRef(StringToInt(Get2DACache("feat", "DESCRIPTION", nFeatID)))+"\n\n";
                sToken += GetStringByStrRef(STRREF_SELECTED_HEADER2); // "Is this correct?"
                SetHeader(sToken);

                AddChoice(GetStringByStrRef(STRREF_YES), TRUE, oPC); // "Yes"
                AddChoice(GetStringByStrRef(STRREF_NO), FALSE, oPC); // "No"
            }
            // Conversation finished stage
            else if(nStage == STAGE_ALL_POWERS_SELECTED)
            {
                if(DEBUG) DoDebug("psi_powconv: Building finish note");
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
        if(DEBUG) DoDebug("psi_powconv: Running exit handler");
        // End of conversation cleanup
        DeleteLocalInt(oPC, "nClass");
        DeleteLocalInt(oPC, "nPower");
        DeleteLocalInt(oPC, "nExpKnow");
        DeleteLocalInt(oPC, "nPowerLevelToBrowse");
        DeleteLocalInt(oPC, "PowerListChoiceOffset");

        // Restart the convo to pick next power if needed
        // done via EvalPRCFFeats to avoid convlicts with new spellbooks
        //ExecuteScript("psi_powergain", oPC);
        DelayCommand(1.0, EvalPRCFeats(oPC));
    }
    else if(nValue == DYNCONV_ABORTED)
    {
        // This section should never be run, since aborting this conversation should
        // always be forbidden and as such, any attempts to abort the conversation
        // should be handled transparently by the system
        if(DEBUG) DoDebug("psi_powconv: ERROR: Conversation abort section run");
    }
    // Handle PC response
    else
    {
        int nChoice = GetChoice(oPC);
        if(DEBUG) DoDebug("psi_powconv: Handling PC response, stage = " + IntToString(nStage) + "; nChoice = " + IntToString(nChoice) + "; choice text = '" + GetChoiceText(oPC) +  "'");
        if(nStage == STAGE_SELECT_CLASS)
        {
            SetLocalInt(oPC, "nClass", nChoice);
            nStage = STAGE_SELECT_LEVEL;
            MarkStageNotSetUp(STAGE_SELECT_CLASS, oPC);
        }
        else if(nStage == STAGE_SELECT_LEVEL)
        {
            if(DEBUG) DoDebug("psi_powconv: Level selected");
            SetLocalInt(oPC, "nPowerLevelToBrowse", nChoice);
            nStage = STAGE_SELECT_POWER;
        }
        else if(nStage == STAGE_SELECT_POWER)
        {
            if(nChoice == CHOICE_BACK_TO_LSELECT)
            {
                if(DEBUG) DoDebug("psi_powconv: Returning to level selection");
                nStage = STAGE_SELECT_LEVEL;
                DeleteLocalInt(oPC, "nPowerLevelToBrowse");
            }
            else
            {
                if(DEBUG) DoDebug("psi_powconv: Entering power confirmation");
                SetLocalInt(oPC, "nPower", nChoice);
                // Store offset so that if the user decides not to take the power,
                // we can return to the same page in the power list instead of resetting to the beginning
                // Store the value +1 in order to be able to differentiate between offset 0 and undefined
                SetLocalInt(oPC, "PowerListChoiceOffset", GetLocalInt(oPC, DYNCONV_CHOICEOFFSET) + 1);
                nStage = STAGE_CONFIRM_SELECTION;
            }
            MarkStageNotSetUp(STAGE_SELECT_POWER, oPC);
        }
        else if(nStage == STAGE_CONFIRM_SELECTION)
        {
            if(DEBUG) DoDebug("psi_powconv: Handling power confirmation");
            if(nChoice == TRUE)
            {
                if(DEBUG) DoDebug("psi_powconv: Adding power");
                int nPower = GetLocalInt(oPC, "nPower");

                AddPowerKnown(oPC, nClass, nPower, TRUE, GetHitDice(oPC), nExpKnow);

                /*
                object oSkin = GetPCSkin(oPC);

                // Add the power feat(s) to the PC's hide
                // First power feat
                int nPowerFeatIP = StringToInt(Get2DACache(sPowerFile, "IPFeatID", nPower));
                itemproperty ipFeat = PRCItemPropertyBonusFeat(nPowerFeatIP);
                IPSafeAddItemProperty(oSkin, ipFeat);
                // Second power feat
                string sPowerFeat2IP = Get2DACache(sPowerFile, "IPFeatID2", nPower);
                if(sPowerFeat2IP != "")
                {
                    ipFeat = PRCItemPropertyBonusFeat(StringToInt(sPowerFeat2IP));
                    IPSafeAddItemProperty(oSkin, ipFeat);
                }
                // Raise the power count
                if(!persistant_array_exists(oPC, "PsiPowerCount"))
                    persistant_array_create(oPC, "PsiPowerCount");
                persistant_array_set_int(oPC, "PsiPowerCount", nClass, persistant_array_get_int(oPC, "PsiPowerCount", nClass) + 1);
                */
                // Delete the stored offset
                DeleteLocalInt(oPC, "PowerListChoiceOffset");
            }

            int nCurrentPowers = GetPowerCount(oPC, nClass);
            int nMaxPowers = GetMaxPowerCount(oPC, nClass);
            if(nCurrentPowers >= nMaxPowers)
                nStage = STAGE_ALL_POWERS_SELECTED;
            else
                nStage = STAGE_SELECT_POWER;
        }

        if(DEBUG) DoDebug("psi_powconv: New stage: " + IntToString(nStage));

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
