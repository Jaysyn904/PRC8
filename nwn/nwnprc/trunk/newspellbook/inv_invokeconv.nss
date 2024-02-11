//:://////////////////////////////////////////////
//:: Invocation gain conversation script
//:: inv_invokeconv
//:://////////////////////////////////////////////
/** @file
    This script controls the invocation selection
    conversation.


    @author Primogenitor - Orinigal
    @author Ornedan - Modifications
    @author Fox - ripped from Psionics convo
    @date   Modified - 2005.03.13
    @date   Modified - 2005.09.23
    @date   Modified - 2008.01.25
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_function"
#include "inv_inc_invfunc"
#include "inc_dynconv"

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_SELECT_LEVEL             = 0;
const int STAGE_SELECT_INVOCATION        = 1;
const int STAGE_CONFIRM_SELECTION        = 2;
const int STAGE_ALL_INVOCATIONS_SELECTED = 3;
const int STAGE_UNLEARN_INVOCATION       = 4;
const int STAGE_UNLEARN_CONFIRM          = 5;

const int CHOICE_BACK_TO_LSELECT         = -1;

const int STRREF_BACK_TO_LSELECT         = 16832971; // "Return to power level selection."
const int STRREF_LEVELLIST_HEADER        = 16832972; // "Select level of power to gain.\n\nNOTE:\nThis may take a while when first browsing a particular level's powers."
const int STRREF_POWERLIST_HEADER1       = 16832973; // "Select a power to gain.\nYou can select"
const int STRREF_POWERLIST_HEADER2       = 16832974; // "more powers"
const int STRREF_SELECTED_HEADER1        = 16824209; // "You have selected:"
const int STRREF_SELECTED_HEADER2        = 16824210; // "Is this correct?"
const int STRREF_END_HEADER              = 16832975; // "You will be able to select more powers after you gain another level in a psionic caster class."
const int STRREF_END_CONVO_SELECT        = 16824212; // "Finish"
const int LEVEL_STRREF_START             = 16832979;
const int STRREF_YES                     = 4752;     // "Yes"
const int STRREF_NO                      = 4753;     // "No"


const int SORT       = FALSE; // Sorting was causing TMIs
const int DEBUG_LIST = FALSE;

//////////////////////////////////////////////////
/* Function defintions                          */
//////////////////////////////////////////////////

void PrintList(object oPC)
{
    string tp = "Printing list:\n";
    string s = GetLocalString(oPC, "PRC_InvConvo_List_Head");
    if(s == ""){
        tp += "Empty\n";
    }
    else{
        tp += s + "\n";
        s = GetLocalString(oPC, "PRC_InvConvo_List_Next_" + s);
        while(s != ""){
            tp += "=> " + s + "\n";
            s = GetLocalString(oPC, "PRC_InvConvo_List_Next_" + s);
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
    if(!GetLocalInt(oPC, "PRC_InvConvo_ListInited"))
    {
        SetLocalString(oPC, "PRC_InvConvo_List_Head", sChoice);
        SetLocalInt(oPC, "PRC_InvConvo_List_" + sChoice, nChoice);

        SetLocalInt(oPC, "PRC_InvConvo_ListInited", TRUE);
    }
    else
    {
        // Find the location to instert into
        string sPrev = "", sNext = GetLocalString(oPC, "PRC_InvConvo_List_Head");
        while(sNext != "" && StringCompare(sChoice, sNext) >= 0)
        {
            if(DEBUG_LIST) DoDebug("Comparison between '" + sChoice + "' and '" + sNext + "' = " + IntToString(StringCompare(sChoice, sNext)));
            sPrev = sNext;
            sNext = GetLocalString(oPC, "PRC_InvConvo_List_Next_" + sNext);
        }

        /* Insert the new entry */
        // Does it replace the head?
        if(sPrev == "")
        {
            if(DEBUG_LIST) DoDebug("New head");
            SetLocalString(oPC, "PRC_InvConvo_List_Head", sChoice);
        }
        else
        {
            if(DEBUG_LIST) DoDebug("Inserting into position between '" + sPrev + "' and '" + sNext + "'");
            SetLocalString(oPC, "PRC_InvConvo_List_Next_" + sPrev, sChoice);
        }

        SetLocalString(oPC, "PRC_InvConvo_List_Next_" + sChoice, sNext);
        SetLocalInt(oPC, "PRC_InvConvo_List_" + sChoice, nChoice);
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
    string sChoice = GetLocalString(oPC, "PRC_InvConvo_List_Head");
    int    nChoice = GetLocalInt   (oPC, "PRC_InvConvo_List_" + sChoice);

    DeleteLocalString(oPC, "PRC_InvConvo_List_Head");
    string sPrev;

    if(DEBUG_LIST) DoDebug("Head is: '" + sChoice + "' - " + IntToString(nChoice));

    while(sChoice != "")
    {
        // Add the choice
        AddChoice(sChoice, nChoice, oPC);

        // Get next
        sChoice = GetLocalString(oPC, "PRC_InvConvo_List_Next_" + (sPrev = sChoice));
        nChoice = GetLocalInt   (oPC, "PRC_InvConvo_List_" + sChoice);

        if(DEBUG_LIST) DoDebug("Next is: '" + sChoice + "' - " + IntToString(nChoice) + "; previous = '" + sPrev + "'");

        // Delete the already handled data
        DeleteLocalString(oPC, "PRC_InvConvo_List_Next_" + sPrev);
        DeleteLocalInt   (oPC, "PRC_InvConvo_List_" + sPrev);
    }

    DeleteLocalInt(oPC, "PRC_InvConvo_ListInited");
}

void ListInvocationsKnown(object oPC, int nClass, int nMax)
{
    // Loop over levels
    string sBase = _INVOCATION_LIST_NAME_BASE + IntToString(nClass) + _INVOCATION_LIST_LEVEL_ARRAY;
    string sArray, sFile = GetAMSDefinitionFileName(nClass);
    int nHD = GetHitDice(oPC);
    int i, j, nSize, nSpellID, nInv, nTest;
    for(i = 1; i <= nHD; i++)
    {
        sArray = sBase + IntToString(i);
        if(persistant_array_exists(oPC, sArray))
        {
            nSize = persistant_array_get_size(oPC, sArray);
            for(j = 0; j < nSize; j++)
            {
                nSpellID = persistant_array_get_int(oPC, sArray, j);
                nTest = GetPowerfileIndexFromSpellID(nSpellID);
                if(nMax >= StringToInt(Get2DACache(sFile, "Level", nTest)))
                {
                    // For easy data retrival combine level and invocation id (can store up to 255 invocatinids)
                    nInv = ((i & 0x3F) << 8) | (nTest & 0xFF);
                    AddChoice(GetInvocationName(nSpellID), nInv, oPC);
                }
            }
        }
    }
}

void ReplaceInvocation(object oPC, int nClass, int nInvocation, int nUnlernInv, string sFile)
{
    DeleteLocalInt(oPC, "InvUnlearn");
    string sUnlearn = Get2DACache(sFile, "SpellID", nUnlernInv);
    string sLearn   = Get2DACache(sFile, "SpellID", nInvocation);
    int ipFeat = StringToInt(Get2DACache(sFile, "IPFeatID", nInvocation));
    int nLevel = GetLocalInt(oPC, "InvUnlearnLvl");
    string sArray = _INVOCATION_LIST_NAME_BASE + IntToString(nClass) + _INVOCATION_LIST_LEVEL_ARRAY + IntToString(nLevel);
    int nSize = persistant_array_get_size(oPC, sArray);
    int i;
    for(i = 0; i < nSize; i++)
    {
        if(persistant_array_get_string(oPC, sArray, i) == sUnlearn)
        {
            // Mark invocation as known
            persistant_array_set_string(oPC, sArray, i, sLearn);
            // Increment Invocations known total
            sArray = _INVOCATION_LIST_NAME_BASE + IntToString(nClass) + _INVOCATION_LIST_TOTAL_KNOWN;
            SetPersistantLocalInt(oPC, sArray, GetPersistantLocalInt(oPC, sArray) + 1);
            // Give the invocation's control feats
            object oSkin = GetPCSkin(oPC);
            itemproperty invFeat = PRCItemPropertyBonusFeat(ipFeat);
            IPSafeAddItemProperty(oSkin, invFeat, 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            break;
        }
    }
}

void main()
{
    object oPC = GetPCSpeaker();
    int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);
    int nStage = GetStage(oPC);

    int nClass = GetLocalInt(oPC, "nClass");
    string sInvFile = GetAMSKnownFileName(nClass);
    string sInvocationFile = GetAMSDefinitionFileName(nClass);
    if(nClass == -2 || nClass == CLASS_TYPE_INVALID)
    {
        sInvFile = GetAMSKnownFileName(GetPrimaryInvocationClass(oPC));
        sInvocationFile = GetAMSDefinitionFileName(GetPrimaryInvocationClass(oPC));
    }

    // Check which of the conversation scripts called the scripts
    if(nValue == 0) // All of them set the DynConv_Var to non-zero value, so something is wrong -> abort
        return;

    if(nValue == DYNCONV_SETUP_STAGE)
    {
        if(DEBUG) DoDebug("inv_invokeconv: Running setup stage for stage " + IntToString(nStage));
        // Check if this stage is marked as already set up
        // This stops list duplication when scrolling
        if(!GetIsStageSetUp(nStage, oPC))
        {
            if(DEBUG) DoDebug("inv_invokeconv: Stage was not set up already");
            // Level selection stage
            if(nStage == STAGE_SELECT_LEVEL)
            {
                if(DEBUG) DoDebug("inv_invokeconv: Building level selection");
                SetHeader(GetStringByStrRef(STRREF_LEVELLIST_HEADER));

                // Determine maximum power level
                int nInvokeLevel = GetInvokerLevel(oPC, nClass);
                int bUnlearn = !GetLocalInt(oPC, "InvUnlearnLvl");
                int nMaxLevel;
                if(GetLocalInt(oPC, "InvUnlearn"))
                    nMaxLevel = StringToInt(Get2DACache(sInvocationFile, "Level", GetLocalInt(oPC, "InvUnlearn")));
                else if(nClass == -2 || nClass == CLASS_TYPE_INVALID)
                {
                    bUnlearn = FALSE;
                    nInvokeLevel = GetInvokerLevel(oPC, GetPrimaryInvocationClass(oPC));
                    nMaxLevel = StringToInt(Get2DACache(sInvFile, "MaxInvocationLevel", nInvokeLevel - 1));
                    if(nClass == CLASS_TYPE_INVALID) nMaxLevel--;
                }
                else
                    nMaxLevel = StringToInt(Get2DACache(sInvFile, "MaxInvocationLevel", nInvokeLevel - 1));

                // Set the tokens
                int i;
                for(i = 0; i < nMaxLevel; i++){
                    AddChoice(GetStringByStrRef(LEVEL_STRREF_START - i), // The minus is correct, these are stored in inverse order in the TLK. Whoops
                              i + 1
                              );
                }
                if(bUnlearn && nMaxLevel > 1) AddChoice(PRC_TEXT_GREEN+"[Replace]", -1, oPC);

                // Set the next, previous and wait tokens to default values
                SetDefaultTokens();
                // Set the convo quit text to "Abort"
                SetCustomToken(DYNCONV_TOKEN_EXIT, GetStringByStrRef(DYNCONV_STRREF_ABORT_CONVO));
            }
            // Power selection stage
            if(nStage == STAGE_SELECT_INVOCATION)
            {
                if(DEBUG) DoDebug("inv_invokeconv: Building invocation selection");
                int nCurrentInvocations = GetInvocationCount(oPC, nClass);
                int nMaxInvocations = GetMaxInvocationCount(oPC, nClass);
                //quick bugcheck in case the convo gets started when not needed
                if(nCurrentInvocations >= nMaxInvocations)
                    AllowExit(DYNCONV_EXIT_ALLOWED_SHOW_CHOICE, FALSE, oPC);
                string sToken = GetStringByStrRef(STRREF_POWERLIST_HEADER1) + " " + //"Select a power to gain.\n You can select "
                                IntToString(nMaxInvocations-nCurrentInvocations) + " " +
                                GetStringByStrRef(STRREF_POWERLIST_HEADER2);        //" more powers"
                SetHeader(sToken);

                // Set the first choice to be return to level selection stage
                AddChoice(GetStringByStrRef(STRREF_BACK_TO_LSELECT), CHOICE_BACK_TO_LSELECT, oPC);

                // Determine maximum power level
                int nInvokeLevel = GetInvokerLevel(oPC, nClass);
                int nMaxLevel = StringToInt(Get2DACache(sInvFile, "MaxInvocationLevel", nInvokeLevel-1));
                if(nClass == -2 || nClass == CLASS_TYPE_INVALID)
                {
                    nInvokeLevel = GetInvokerLevel(oPC, GetPrimaryInvocationClass(oPC));
                    if(nClass == CLASS_TYPE_INVALID) nMaxLevel--;
                }


                int nInvocationLevelToBrowse = GetLocalInt(oPC, "nInvocationLevelToBrowse");
                int i, nInvocationLevel;
                string sFeatID;
                for(i = 0; i < GetPRCSwitch(FILE_END_CLASS_POWER) ; i++)
                {
                    nInvocationLevel = StringToInt(Get2DACache(sInvocationFile, "Level", i));
                    // Skip any powers of too low level
                    if(nInvocationLevel < nInvocationLevelToBrowse){
                        continue;
                    }
                    /* Due to the way the power list 2das are structured, we know that once
                     * the level of a read power is greater than the maximum manifestable
                     * it'll never be lower again. Therefore, we can skip reading the
                     * powers that wouldn't be shown anyway.
                     */
                    if(nInvocationLevel > nInvocationLevelToBrowse){
                        break;
                    }
                    sFeatID = Get2DACache(sInvocationFile, "FeatID", i);
                    if(sFeatID != ""                                           // Non-blank row
                     && !GetHasFeat(StringToInt(sFeatID), oPC)                 // PC does not already posses the power
                       )
                    {
                        if(SORT) AddToTempList(oPC, GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", StringToInt(sFeatID)))), i);
                        else     AddChoice(GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", StringToInt(sFeatID)))), i, oPC);
                    }
                }

                if(SORT) TransferTempList(oPC);

                /* Hack - In the power selection stage, on returning from
                 * confirmation dialog where the answer was "No", restore the
                 * offset to be the same as on entering the confirmation dialog.
                 */
                if(GetLocalInt(oPC, "InvocationListChoiceOffset"))
                {
                    if(DEBUG) DoDebug("inv_invokeconv: Running offset restoration hack");
                    SetLocalInt(oPC, DYNCONV_CHOICEOFFSET, GetLocalInt(oPC, "InvocationListChoiceOffset") - 1);
                    DeleteLocalInt(oPC, "InvocationListChoiceOffset");
                }

                MarkStageSetUp(STAGE_SELECT_INVOCATION, oPC);
            }
            // Selection confirmation stage
            else if(nStage == STAGE_CONFIRM_SELECTION)
            {
                if(DEBUG) DoDebug("inv_invokeconv: Building selection confirmation");
                // Build the confirmantion query
                string sToken = GetStringByStrRef(STRREF_SELECTED_HEADER1) + "\n\n"; // "You have selected:"
                int nInvocation = GetLocalInt(oPC, "nInvocation");
                int nFeatID = StringToInt(Get2DACache(sInvocationFile, "FeatID", nInvocation));
                sToken += GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", nFeatID)))+"\n";
                sToken += GetStringByStrRef(StringToInt(Get2DACache("feat", "DESCRIPTION", nFeatID)))+"\n\n";
                sToken += GetStringByStrRef(STRREF_SELECTED_HEADER2); // "Is this correct?"
                SetHeader(sToken);

                AddChoice(GetStringByStrRef(STRREF_YES), TRUE, oPC); // "Yes"
                AddChoice(GetStringByStrRef(STRREF_NO), FALSE, oPC); // "No"
            }
            else if(nStage == STAGE_UNLEARN_INVOCATION)
            {
                // Determine maximum power level
                int nInvokeLevel = GetInvokerLevel(oPC, nClass);
                int nMaxLevel = StringToInt(Get2DACache(sInvFile, "MaxInvocationLevel", nInvokeLevel-1));

                SetHeader("Select invocation to replace");
                ListInvocationsKnown(oPC, nClass, nMaxLevel);
                MarkStageSetUp(STAGE_UNLEARN_INVOCATION, oPC);
            }
            else if(nStage == STAGE_UNLEARN_CONFIRM)
            {
                // Build the confirmantion query
                string sToken = GetStringByStrRef(STRREF_SELECTED_HEADER1) + "\n\n"; // "You have selected:"
                int nInvocation = GetLocalInt(oPC, "InvUnlearn");
                int nFeatID = StringToInt(Get2DACache(sInvocationFile, "FeatID", nInvocation));
                sToken += GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", nFeatID)))+"\n";
                sToken += GetStringByStrRef(StringToInt(Get2DACache("feat", "DESCRIPTION", nFeatID)))+"\n\n";
                sToken += GetStringByStrRef(STRREF_SELECTED_HEADER2); // "Is this correct?"
                SetHeader(sToken);

                AddChoice(GetStringByStrRef(STRREF_YES), TRUE, oPC); // "Yes"
                AddChoice(GetStringByStrRef(STRREF_NO), FALSE, oPC); // "No"
            }
            // Conversation finished stage
            else if(nStage == STAGE_ALL_INVOCATIONS_SELECTED)
            {
                if(DEBUG) DoDebug("inv_invokeconv: Building finish note");
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
        if(DEBUG) DoDebug("inv_invokeconv: Running exit handler");
        // End of conversation cleanup
        DeleteLocalInt(oPC, "nClass");
        DeleteLocalInt(oPC, "nInvocation");
        DeleteLocalInt(oPC, "nInvocationLevelToBrowse");
        DeleteLocalInt(oPC, "InvocationListChoiceOffset");
        DeleteLocalInt(oPC, "InvUnlearn");
        DeleteLocalInt(oPC, "InvUnlearnLvl");

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
        if(DEBUG) DoDebug("inv_invokeconv: ERROR: Conversation abort section run");
    }
    // Handle PC response
    else
    {
        int nChoice = GetChoice(oPC);
        if(DEBUG) DoDebug("inv_invokeconv: Handling PC response, stage = " + IntToString(nStage) + "; nChoice = " + IntToString(nChoice) + "; choice text = '" + GetChoiceText(oPC) +  "'");
        if(nStage == STAGE_SELECT_LEVEL)
        {
            if(nChoice == -1)
                nStage = STAGE_UNLEARN_INVOCATION;
            else
            {
                if(DEBUG) DoDebug("inv_invokeconv: Level selected");
                SetLocalInt(oPC, "nInvocationLevelToBrowse", nChoice);
                nStage = STAGE_SELECT_INVOCATION;
            }
        }
        else if(nStage == STAGE_SELECT_INVOCATION)
        {
            if(nChoice == CHOICE_BACK_TO_LSELECT)
            {
                if(DEBUG) DoDebug("inv_invokeconv: Returning to level selection");
                nStage = STAGE_SELECT_LEVEL;
                DeleteLocalInt(oPC, "nInvocationLevelToBrowse");
            }
            else
            {
                if(DEBUG) DoDebug("inv_invokeconv: Entering invocation confirmation");
                SetLocalInt(oPC, "nInvocation", nChoice);
                // Store offset so that if the user decides not to take the power,
                // we can return to the same page in the power list instead of resetting to the beginning
                // Store the value +1 in order to be able to differentiate between offset 0 and undefined
                SetLocalInt(oPC, "InvocationListChoiceOffset", GetLocalInt(oPC, DYNCONV_CHOICEOFFSET) + 1);
                nStage = STAGE_CONFIRM_SELECTION;
            }
            MarkStageNotSetUp(STAGE_SELECT_INVOCATION, oPC);
        }
        else if(nStage == STAGE_CONFIRM_SELECTION)
        {
            if(DEBUG) DoDebug("inv_invokeconv: Handling invocation confirmation");
            if(nChoice == TRUE)
            {
                int nInvocation = GetLocalInt(oPC, "nInvocation");
                int nUnlernInv = GetLocalInt(oPC, "InvUnlearn");
                if(DEBUG) DoDebug("inv_invokeconv: Adding invocation: " + IntToString(nInvocation));
                if(nUnlernInv)
                    ReplaceInvocation(oPC, nClass, nInvocation, nUnlernInv, sInvocationFile);
                else
                    AddInvocationKnown(oPC, nClass, nInvocation, TRUE, GetHitDice(oPC));

                // Delete the stored offset
                DeleteLocalInt(oPC, "InvocationListChoiceOffset");
            }

            int nCurrentInvocations = GetInvocationCount(oPC, nClass);
            int nMaxInvocations = GetMaxInvocationCount(oPC, nClass);
            if(nCurrentInvocations >= nMaxInvocations)
                nStage = STAGE_ALL_INVOCATIONS_SELECTED;
            else
                nStage = STAGE_SELECT_INVOCATION;
        }
        else if(nStage == STAGE_UNLEARN_INVOCATION)
        {
            SetLocalInt(oPC, "InvUnlearn", (nChoice & 0xFF));
            SetLocalInt(oPC, "InvUnlearnLvl", ((nChoice >>> 8) & 0x3F));
            nStage = STAGE_UNLEARN_CONFIRM;
            MarkStageNotSetUp(STAGE_UNLEARN_INVOCATION, oPC);
        }
        else if(STAGE_UNLEARN_CONFIRM)
        {
            if(nChoice == TRUE)
            {
                // Decrement Invocations known total
                string sArray = _INVOCATION_LIST_NAME_BASE + IntToString(nClass) + _INVOCATION_LIST_TOTAL_KNOWN;
                SetPersistantLocalInt(oPC, sArray, GetPersistantLocalInt(oPC, sArray) - 1);
                // Remove invocation feat
                int nInvocation = GetLocalInt(oPC, "InvUnlearn");
                int ipFeat = StringToInt(Get2DACache(sInvocationFile, "IPFeatID", nInvocation));
                RemoveSpecificProperty(GetPCSkin(oPC), ITEM_PROPERTY_BONUS_FEAT, ipFeat);
            }
            nStage = STAGE_SELECT_LEVEL;
        }

        if(DEBUG) DoDebug("inv_invokeconv: New stage: " + IntToString(nStage));

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
