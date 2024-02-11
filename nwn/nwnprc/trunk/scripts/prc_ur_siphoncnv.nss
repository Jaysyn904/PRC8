//:://////////////////////////////////////////////
//:: Ur-Priest Siphon Spell Power choice script
//:: prc_ur_siphoncnv
//:://////////////////////////////////////////////
/** @file
    @author Stratovarius - 28/03/21
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_burn"
#include "inc_dynconv"

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_SELECT_BURN_LEVEL_1    = 0;
const int STAGE_SELECT_BURN_LEVEL_2    = 1;
const int STAGE_SELECT_SPELL           = 2;
const int STAGE_CONFIRM_SELECTION      = 3;

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

void PrintList(object oCaster)
{
    string tp = "Printing list:\n";
    string s = GetLocalString(oCaster, "PRC_MystConvo_List_Head");
    if(s == ""){
        tp += "Empty\n";
    }
    else{
        tp += s + "\n";
        s = GetLocalString(oCaster, "PRC_MystConvo_List_Next_" + s);
        while(s != ""){
            tp += "=> " + s + "\n";
            s = GetLocalString(oCaster, "PRC_MystConvo_List_Next_" + s);
        }
    }

    DoDebug(tp);
}

/**
 * Creates a linked list of entries that is sorted into alphabetical order
 * as it is built.
 * Assumption: mystery names are unique.
 *
 * @param oCaster     The storage object aka whomever is gaining powers in this conversation
 * @param sChoice The choice string
 * @param nChoice The choice value
 */
void AddToTempList(object oCaster, string sChoice, int nChoice)
{
    if(DEBUG_LIST) DoDebug("\nAdding to temp list: '" + sChoice + "' - " + IntToString(nChoice));
    if(DEBUG_LIST) PrintList(oCaster);
    // If there is nothing yet
    if(!GetLocalInt(oCaster, "PRC_MystConvo_ListInited"))
    {
        SetLocalString(oCaster, "PRC_MystConvo_List_Head", sChoice);
        SetLocalInt(oCaster, "PRC_MystConvo_List_" + sChoice, nChoice);

        SetLocalInt(oCaster, "PRC_MystConvo_ListInited", TRUE);
    }
    else
    {
        // Find the location to instert into
        string sPrev = "", sNext = GetLocalString(oCaster, "PRC_MystConvo_List_Head");
        while(sNext != "" && StringCompare(sChoice, sNext) >= 0)
        {
            if(DEBUG_LIST) DoDebug("Comparison between '" + sChoice + "' and '" + sNext + "' = " + IntToString(StringCompare(sChoice, sNext)));
            sPrev = sNext;
            sNext = GetLocalString(oCaster, "PRC_MystConvo_List_Next_" + sNext);
        }

        // Insert the new entry
        // Does it replace the head?
        if(sPrev == "")
        {
            if(DEBUG_LIST) DoDebug("New head");
            SetLocalString(oCaster, "PRC_MystConvo_List_Head", sChoice);
        }
        else
        {
            if(DEBUG_LIST) DoDebug("Inserting into position between '" + sPrev + "' and '" + sNext + "'");
            SetLocalString(oCaster, "PRC_MystConvo_List_Next_" + sPrev, sChoice);
        }

        SetLocalString(oCaster, "PRC_MystConvo_List_Next_" + sChoice, sNext);
        SetLocalInt(oCaster, "PRC_MystConvo_List_" + sChoice, nChoice);
    }
}

/**
 * Reads the linked list built with AddToTempList() to AddChoice() and
 * deletes it.
 *
 * @param oCaster A PC gaining powers at the moment
 */
void TransferTempList(object oCaster)
{
    string sChoice = GetLocalString(oCaster, "PRC_MystConvo_List_Head");
    int    nChoice = GetLocalInt   (oCaster, "PRC_MystConvo_List_" + sChoice);

    DeleteLocalString(oCaster, "PRC_MystConvo_List_Head");
    string sPrev;

    if(DEBUG_LIST) DoDebug("Head is: '" + sChoice + "' - " + IntToString(nChoice));

    while(sChoice != "")
    {
        // Add the choice
        AddChoice(sChoice, nChoice, oCaster);

        // Get next
        sChoice = GetLocalString(oCaster, "PRC_MystConvo_List_Next_" + (sPrev = sChoice));
        nChoice = GetLocalInt   (oCaster, "PRC_MystConvo_List_" + sChoice);

        if(DEBUG_LIST) DoDebug("Next is: '" + sChoice + "' - " + IntToString(nChoice) + "; previous = '" + sPrev + "'");

        // Delete the already handled data
        DeleteLocalString(oCaster, "PRC_MystConvo_List_Next_" + sPrev);
        DeleteLocalInt   (oCaster, "PRC_MystConvo_List_" + sPrev);
    }

    DeleteLocalInt(oCaster, "PRC_MystConvo_ListInited");
}

int HighestSpellLevel(object oCaster)
{
	int nUr = GetLevelByClass(CLASS_TYPE_UR_PRIEST, oCaster);
	int nWis = GetAbilityScore(oCaster, ABILITY_WISDOM);
	int nTest;
	if (nUr >= 9 && nWis >= 19) nTest = 9;
	else if (nUr >= 8 && nWis >= 18) nTest = 8;
	else if (nUr >= 7 && nWis >= 17) nTest = 7;
	else if (nUr >= 6 && nWis >= 16) nTest = 6;
	else if (nUr >= 5 && nWis >= 15) nTest = 5;
	else if (nUr >= 4 && nWis >= 14) nTest = 4;
	else if (nUr >= 3 && nWis >= 13) nTest = 3;
	else if (nUr >= 2 && nWis >= 12) nTest = 2;
	else if (nUr >= 1 && nWis >= 11) nTest = 1;
	//FloatingTextStringOnCreature(IntToString(nTest), oCaster);
	return nTest;
}                

void main()
{
    object oCaster = GetPCSpeaker();
    int nValue = GetLocalInt(oCaster, DYNCONV_VARIABLE);
    int nStage = GetStage(oCaster);

    string sPowerFile = "cls_spell_cler"; 

    // Check which of the conversation scripts called the scripts
    if(nValue == 0) // All of them set the DynConv_Var to non-zero value, so something is wrong -> abort
        return;

    if(nValue == DYNCONV_SETUP_STAGE)
    {
        if(DEBUG) DoDebug("prc_ur_siphoncnv: Running setup stage for stage " + IntToString(nStage));
        // Check if this stage is marked as already set up
        // This stops list duplication when scrolling
        if(!GetIsStageSetUp(nStage, oCaster))
        {
            if(DEBUG) DoDebug("prc_ur_siphoncnv: Stage was not set up already");
            // Level selection stage
            if(nStage == STAGE_SELECT_BURN_LEVEL_1)
            {
                if(DEBUG) DoDebug("prc_ur_siphoncnv: Building burn level 1 selection");
                SetHeader("Choose the level of the first spell you wish to expend");


                // Set the tokens. Max 8th level spell, since you are doing this to cast a higher level spell
                int nSpell;
                int nHighest = HighestSpellLevel(oCaster); // Stop them from burning a max level spell, since that's a waste
                nSpell = GetBestL1Spell(oCaster, -1);
                if (nSpell != -1) AddChoice(GetStringByStrRef(LEVEL_STRREF_START), 1);
                nSpell = GetBestL2Spell(oCaster, -1);
                if (nSpell != -1) AddChoice(GetStringByStrRef(LEVEL_STRREF_START - 1), 2);
                nSpell = GetBestL3Spell(oCaster, -1);
                if (nSpell != -1) AddChoice(GetStringByStrRef(LEVEL_STRREF_START - 2), 3);
                nSpell = GetBestL4Spell(oCaster, -1);
                if (nSpell != -1) AddChoice(GetStringByStrRef(LEVEL_STRREF_START - 3), 4);
                nSpell = GetBestL5Spell(oCaster, -1);
                if (nSpell != -1) AddChoice(GetStringByStrRef(LEVEL_STRREF_START - 4), 5);
                nSpell = GetBestL6Spell(oCaster, -1);
                if (nSpell != -1 && nHighest != 6) AddChoice(GetStringByStrRef(LEVEL_STRREF_START - 5), 6);
                nSpell = GetBestL7Spell(oCaster, -1);
                if (nSpell != -1 && nHighest != 7) AddChoice(GetStringByStrRef(LEVEL_STRREF_START - 6), 7);
                nSpell = GetBestL8Spell(oCaster, -1);
                if (nSpell != -1 && nHighest != 8) AddChoice(GetStringByStrRef(LEVEL_STRREF_START - 7), 8);

                // Set the next, previous and wait tokens to default values
                SetDefaultTokens();
                // Set the convo quit text to "Abort"
                SetCustomToken(DYNCONV_TOKEN_EXIT, GetStringByStrRef(DYNCONV_STRREF_ABORT_CONVO));
            }
            if(nStage == STAGE_SELECT_BURN_LEVEL_2)
            {
                if(DEBUG) DoDebug("prc_ur_siphoncnv: Building burn level 2 selection");
                int nBurn1 = GetLocalInt(oCaster, "SiphonSpell1");
                SetHeader("Choose the level of the second spell you wish to expend. You have selected "+IntToString(nBurn1)+" as the level of your first spell to expend");


                // Set the tokens. Max 8th level spell, since you are doing this to cast a higher level spell
                // Can't select the same spell level as before for ease of code reasons
                int nSpell;
                int nHighest = HighestSpellLevel(oCaster);
                nSpell = GetBestL1Spell(oCaster, -1);
                if (nSpell != -1 && nBurn1 != 1) AddChoice(GetStringByStrRef(LEVEL_STRREF_START), 1);
                nSpell = GetBestL2Spell(oCaster, -1);
                if (nSpell != -1 && nBurn1 != 2) AddChoice(GetStringByStrRef(LEVEL_STRREF_START - 1), 2);
                nSpell = GetBestL3Spell(oCaster, -1);
                if (nSpell != -1 && nBurn1 != 3) AddChoice(GetStringByStrRef(LEVEL_STRREF_START - 2), 3);
                nSpell = GetBestL4Spell(oCaster, -1);
                if (nSpell != -1 && nBurn1 != 4) AddChoice(GetStringByStrRef(LEVEL_STRREF_START - 3), 4);
                nSpell = GetBestL5Spell(oCaster, -1);
                if (nSpell != -1 && nBurn1 != 5) AddChoice(GetStringByStrRef(LEVEL_STRREF_START - 4), 5);
                nSpell = GetBestL6Spell(oCaster, -1);
                if (nSpell != -1 && nBurn1 != 6 && nHighest != 6) AddChoice(GetStringByStrRef(LEVEL_STRREF_START - 5), 6);
                nSpell = GetBestL7Spell(oCaster, -1);
                if (nSpell != -1 && nBurn1 != 7 && nHighest != 7) AddChoice(GetStringByStrRef(LEVEL_STRREF_START - 6), 7);
                nSpell = GetBestL8Spell(oCaster, -1);
                if (nSpell != -1 && nBurn1 != 8 && nHighest != 8) AddChoice(GetStringByStrRef(LEVEL_STRREF_START - 7), 8);

                // Set the next, previous and wait tokens to default values
                SetDefaultTokens();
                // Set the convo quit text to "Abort"
                SetCustomToken(DYNCONV_TOKEN_EXIT, GetStringByStrRef(DYNCONV_STRREF_ABORT_CONVO));
            }            
            // mystery selection stage
            if(nStage == STAGE_SELECT_SPELL)
            {
                if(DEBUG) DoDebug("prc_ur_siphoncnv: Building spell selection");
                
                int nBurn1 = GetLocalInt(oCaster, "SiphonSpell1");
                int nBurn2 = GetLocalInt(oCaster, "SiphonSpell2");
                int nSpellLevel = ((nBurn1+nBurn2)/4)*3;
                // Sanity
                if (nSpellLevel > 9) nSpellLevel = 9;
                
                // Cap max level at what they can actually cast. We know they're at least a 6th level Ur-Priest
				int nTest = HighestSpellLevel(oCaster);                
                if (nSpellLevel > nTest) nSpellLevel = nTest;

                SetHeader("By expending a spell of level "+IntToString(nBurn1)+" and a spell of level "+IntToString(nBurn2)+", you can prepare a spell of "+IntToString(nSpellLevel)+" level");

                // Set the first choice to be return to level selection stage
                AddChoice(GetStringByStrRef(STRREF_BACK_TO_LSELECT), CHOICE_BACK_TO_LSELECT, oCaster);

                int i, nEvoLevel;
                string sFeatID;
                for(i = 0; i < 340 ; i++)
                {
                    nEvoLevel = StringToInt(Get2DACache(sPowerFile, "Level", i));
                    // Skip any powers of too low level
                    if(nEvoLevel < nSpellLevel){
                        continue;
                    }
                     //Due to the way the 2das are structured, we know that once
                     //the level of a read evocation is greater than the maximum castable
                     //it'll never be lower again. Therefore, we can skip reading the
                     //evocations that wouldn't be shown anyway.
                     
                    if(nEvoLevel > nSpellLevel){
                        break;
                    }
                    int nSpellId = StringToInt(Get2DACache(sPowerFile, "RealSpellID", i));
                    if(nSpellId) // Non-blank row
                    {
	                    if(SORT) AddToTempList(oCaster, GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSpellId))), nSpellId);
                        else     AddChoice(GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSpellId))), nSpellId, oCaster);
                    }
                }

                if(SORT) TransferTempList(oCaster);

                // Hack - In the mystery selection stage, on returning from
                // confirmation dialog where the answer was "No", restore the
                // offset to be the same as on entering the confirmation dialog.
                if(GetLocalInt(oCaster, "MYSTLISTChoiceOffset"))
                {
                    if(DEBUG) DoDebug("prc_ur_siphoncnv: Running offset restoration hack");
                    SetLocalInt(oCaster, DYNCONV_CHOICEOFFSET, GetLocalInt(oCaster, "MYSTLISTChoiceOffset") - 1);
                    DeleteLocalInt(oCaster, "MYSTLISTChoiceOffset");
                }

                MarkStageSetUp(STAGE_SELECT_SPELL, oCaster);
            }
            // Selection confirmation stage
            else if(nStage == STAGE_CONFIRM_SELECTION)
            {
                if(DEBUG) DoDebug("prc_ur_siphoncnv: Building selection confirmation");
                // Build the confirmantion query
                string sToken = GetStringByStrRef(STRREF_SELECTED_HEADER1) + "\n\n"; // "You have selected:"
                int nSpellId = GetLocalInt(oCaster, "nEvo");
                sToken += GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSpellId)))+"\n";
                sToken += GetStringByStrRef(StringToInt(Get2DACache("spells", "SpellDesc", nSpellId)))+"\n\n";
                sToken += GetStringByStrRef(STRREF_SELECTED_HEADER2); // "Is this correct?"
                SetHeader(sToken);

                AddChoice(GetStringByStrRef(STRREF_YES), TRUE, oCaster); // "Yes"
                AddChoice(GetStringByStrRef(STRREF_NO), FALSE, oCaster); // "No"
            }
        }

        // Do token setup
        SetupTokens();
    }
    else if(nValue == DYNCONV_EXITED)
    {
        if(DEBUG) DoDebug("prc_ur_siphoncnv: Running exit handler");
        // End of conversation cleanup
        DeleteLocalInt(oCaster, "SiphonSpell1");
        DeleteLocalInt(oCaster, "SiphonSpell2");
        DeleteLocalInt(oCaster, "nSpellLevel");
        DeleteLocalInt(oCaster, "MYSTLISTChoiceOffset");
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
        int nChoice = GetChoice(oCaster);
        if(DEBUG) DoDebug("prc_ur_siphoncnv: Handling PC response, stage = " + IntToString(nStage) + "; nChoice = " + IntToString(nChoice) + "; choice text = '" + GetChoiceText(oCaster) +  "'");
        if(nStage == STAGE_SELECT_BURN_LEVEL_1)
        {
           	if(DEBUG) DoDebug("prc_ur_siphoncnv: Spell 1 selected");
           	SetLocalInt(oCaster, "SiphonSpell1", nChoice);
           	nStage = STAGE_SELECT_BURN_LEVEL_2;

            MarkStageNotSetUp(STAGE_SELECT_BURN_LEVEL_1, oCaster);
        }
        else if(nStage == STAGE_SELECT_BURN_LEVEL_2)
        {
           	if(DEBUG) DoDebug("prc_ur_siphoncnv: Spell 2 selected");
           	SetLocalInt(oCaster, "SiphonSpell2", nChoice);
           	nStage = STAGE_SELECT_SPELL;

            MarkStageNotSetUp(STAGE_SELECT_BURN_LEVEL_2, oCaster);
        }        
        else if(nStage == STAGE_SELECT_SPELL)
        {
            if(nChoice == CHOICE_BACK_TO_LSELECT)
            {
                if(DEBUG) DoDebug("prc_ur_siphoncnv: Returning to level selection");
                nStage = STAGE_SELECT_BURN_LEVEL_1;
                // Clean up
                DeleteLocalInt(oCaster, "SiphonSpell1");
                DeleteLocalInt(oCaster, "SiphonSpell2");
            }
            else
            {
                if(DEBUG) DoDebug("prc_ur_siphoncnv: Entering spell confirmation");
                SetLocalInt(oCaster, "nEvo", nChoice);
                // Store offset so that if the user decides not to take the mystery,
                // we can return to the same page in the mystery list instead of resetting to the beginning
                // Store the value +1 in order to be able to differentiate between offset 0 and undefined
                SetLocalInt(oCaster, "MYSTLISTChoiceOffset", GetLocalInt(oCaster, DYNCONV_CHOICEOFFSET) + 1);
                nStage = STAGE_CONFIRM_SELECTION;
            }
            MarkStageNotSetUp(STAGE_SELECT_SPELL, oCaster);
        }
        else if(nStage == STAGE_CONFIRM_SELECTION)
        {
            SetLocalInt(oCaster, "UrSiphon", GetLocalInt(oCaster, "nEvo"));
            int nBurn1 = GetLocalInt(oCaster, "SiphonSpell1");
            int nBurn2 = GetLocalInt(oCaster, "SiphonSpell2");            
            SetLocalInt(oCaster, "BurnSpellLevel", nBurn1);
            BurnSpell(oCaster);
            SetLocalInt(oCaster, "BurnSpellLevel", nBurn2);
            BurnSpell(oCaster);
            DeleteLocalInt(oCaster, "BurnSpellLevel");
            // And we're all done
            AllowExit(DYNCONV_EXIT_FORCE_EXIT); 
        }

        if(DEBUG) DoDebug("prc_ur_siphoncnv: New stage: " + IntToString(nStage));

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oCaster);
    }
}
