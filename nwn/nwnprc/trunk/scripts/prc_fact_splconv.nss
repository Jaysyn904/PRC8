//:://////////////////////////////////////////////
//:: Factotum Arcane Dilettante choice script
//:: prc_fact_splconv
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

const int STAGE_SELECT_LEVEL        = 0;
const int STAGE_SELECT_SPELL        = 1;
const int STAGE_CONFIRM_SELECTION   = 2;
const int STAGE_SELECT_SCHOOL       = 3;

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
        if(DEBUG) DoDebug("prc_fact_splconv: Running setup stage for stage " + IntToString(nStage));
        // Check if this stage is marked as already set up
        // This stops list duplication when scrolling
        if(!GetIsStageSetUp(nStage, oPC))
        {
            if(DEBUG) DoDebug("prc_fact_splconv: Stage was not set up already");
            // Level selection stage
            if(nStage == STAGE_SELECT_LEVEL)
            {
                if(DEBUG) DoDebug("prc_fact_splconv: Building level selection");
                SetHeader("Choose the level of spell to prepare. You can only learn one spell of your maximum level.");

                // Set the tokens. 
                int nMax = GetLocalInt(oPC, "FactotumArcDil");
                // Chosen the max level, reduce it by one
                if (GetLocalInt(oPC, "ArcDilMaxPicked"))
                	nMax--;
                	
                AddChoice("Level 0", 0);
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
            if(nStage == STAGE_SELECT_SCHOOL)
            {
                if(DEBUG) DoDebug("prc_fact_splconv: Building school selection");
                SetHeader("Choose the school of the spell to prepare");

                AddChoice("Abjuration", 1);
                AddChoice("Conjuration", 2);
                AddChoice("Divination", 3);
                AddChoice("Enchantment", 4);
                AddChoice("Evocation", 5);
                AddChoice("Illusion", 6);
                AddChoice("Necromancy", 7);
                AddChoice("Transmutation", 8);

			 	MarkStageSetUp(STAGE_SELECT_SCHOOL, oPC);
            }            
            if(nStage == STAGE_SELECT_SPELL)
            {
                if(DEBUG) DoDebug("prc_fact_splconv: Building spell selection");

                SetHeader("Select a spell to prepare");

                // Set the first choice to be return to level selection stage
                AddChoice(GetStringByStrRef(STRREF_BACK_TO_LSELECT), CHOICE_BACK_TO_LSELECT, oPC);

                int nArcDilLevelToBrowse = GetLocalInt(oPC, "nArcDilLevelToBrowse");
                int nSchool = GetLocalInt(oPC, "nArcDilSchoolToBrowse");
                string sSchool;
                
                // Turn school into a letter
                if (nSchool == 1) sSchool = "A";
                if (nSchool == 2) sSchool = "C";
                if (nSchool == 3) sSchool = "D";
                if (nSchool == 4) sSchool = "E";
                if (nSchool == 5) sSchool = "V";
                if (nSchool == 6) sSchool = "I";
                if (nSchool == 7) sSchool = "N";
                if (nSchool == 8) sSchool = "T";

                if(DEBUG) DoDebug("prc_fact_splconv: Spell Level To Browse: " + IntToString(nArcDilLevelToBrowse));

                int i, nArcDilSpellLevel;
                string sFeatID;
                for(i = 0; i < 550 ; i++)
                {
                    nArcDilSpellLevel = StringToInt(Get2DACache(sPowerFile, "Level", i));
                    // Skip any powers of too low level
                    if(nArcDilSpellLevel < nArcDilLevelToBrowse){
                        continue;
                    }
                     //Due to the way the 2das are structured, we know that once
                     //the level of a read evocation is greater than the maximum castable
                     //it'll never be lower again. Therefore, we can skip reading the
                     //evocations that wouldn't be shown anyway.
                     
                    if(nArcDilSpellLevel > nArcDilLevelToBrowse){
                        break;
                    }
                    sFeatID = Get2DACache(sPowerFile, "FeatID", i);
                    int nSpellId = StringToInt(Get2DACache(sPowerFile, "RealSpellID", i));
                    
                    // Radial spells won't work through this method, so skip them
                    int nRadial = StringToInt(Get2DACache("spells", "SubRadSpell1", nSpellId));
                    
                    if(sFeatID != "") // Non-blank row
                    {
                        if (sSchool == Get2DACache("spells", "School", nSpellId) && !nRadial)
                        {
                            if(SORT) AddToTempList(oPC, GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSpellId))), nSpellId);
                            else     AddChoice(GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSpellId))), nSpellId, oPC);
                        }    
                    }
                }                

                if(SORT) TransferTempList(oPC);

                // Hack - In the mystery selection stage, on returning from
                // confirmation dialog where the answer was "No", restore the
                // offset to be the same as on entering the confirmation dialog.
                if(GetLocalInt(oPC, "ArcDilChoiceOffset"))
                {
                    if(DEBUG) DoDebug("prc_fact_splconv: Running offset restoration hack");
                    SetLocalInt(oPC, DYNCONV_CHOICEOFFSET, GetLocalInt(oPC, "ArcDilChoiceOffset") - 1);
                    DeleteLocalInt(oPC, "ArcDilChoiceOffset");
                }

                MarkStageSetUp(STAGE_SELECT_SPELL, oPC);
            }
            // Selection confirmation stage
            else if(nStage == STAGE_CONFIRM_SELECTION)
            {
                if(DEBUG) DoDebug("prc_fact_splconv: Building selection confirmation");
                // Build the confirmation query
                string sToken = GetStringByStrRef(STRREF_SELECTED_HEADER1) + "\n\n"; // "You have selected:"
                int nSpellId = GetLocalInt(oPC, "nArcDilSpell");
                sToken += GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSpellId)))+"\n";
                sToken += GetStringByStrRef(StringToInt(Get2DACache("spells", "SpellDesc", nSpellId)))+"\n\n";
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
        if(DEBUG) DoDebug("prc_fact_splconv: Running exit handler");
        // End of conversation cleanup
        DeleteLocalInt(oPC, "nArcDilSpell");
        DeleteLocalInt(oPC, "nArcDilLevelToBrowse");
        DeleteLocalInt(oPC, "ArcDilChoiceOffset");
        DeleteLocalInt(oPC, "nArcDilSchoolToBrowse");
        DeleteLocalInt(oPC, "FactotumArcDil");
        DeleteLocalInt(oPC, "ArcDilMaxPicked");
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
        if(DEBUG) DoDebug("prc_fact_splconv: Handling PC response, stage = " + IntToString(nStage) + "; nChoice = " + IntToString(nChoice) + "; choice text = '" + GetChoiceText(oPC) +  "'");
        if(nStage == STAGE_SELECT_LEVEL)
        {
           	if(DEBUG) DoDebug("prc_fact_splconv: Level selected");
           	SetLocalInt(oPC, "nArcDilLevelToBrowse", nChoice);
           	nStage = STAGE_SELECT_SCHOOL;

            MarkStageNotSetUp(STAGE_SELECT_LEVEL, oPC);
        }
        else if(nStage == STAGE_SELECT_SCHOOL)
        {
           	if(DEBUG) DoDebug("prc_fact_splconv: School selected");
           	SetLocalInt(oPC, "nArcDilSchoolToBrowse", nChoice);
           	nStage = STAGE_SELECT_SPELL;

            MarkStageNotSetUp(STAGE_SELECT_SCHOOL, oPC);
        }        
        else if(nStage == STAGE_SELECT_SPELL)
        {
            if(nChoice == CHOICE_BACK_TO_LSELECT)
            {
                if(DEBUG) DoDebug("prc_fact_splconv: Returning to level selection");
                nStage = STAGE_SELECT_LEVEL;
                // Clean up
                DeleteLocalInt(oPC, "nArcDilLevelToBrowse");
            }
            else
            {
                if(DEBUG) DoDebug("prc_fact_splconv: Entering spell confirmation");
                SetLocalInt(oPC, "nArcDilSpell", nChoice);
                // Store offset so that if the user decides not to take the mystery,
                // we can return to the same page in the mystery list instead of resetting to the beginning
                // Store the value +1 in order to be able to differentiate between offset 0 and undefined
                SetLocalInt(oPC, "ArcDilChoiceOffset", GetLocalInt(oPC, DYNCONV_CHOICEOFFSET) + 1);
                nStage = STAGE_CONFIRM_SELECTION;
            }
            MarkStageNotSetUp(STAGE_SELECT_SPELL, oPC);
        }
        else if(nStage == STAGE_CONFIRM_SELECTION)
        {     
        	if (nChoice)
        	{
        		int nSpellId = GetLocalInt(oPC, "nArcDilSpell");
        		PrepareArcDilSpell(oPC, nSpellId);
        		// Only one spell of maximum level
        		if (StringToInt(Get2DACache("spells", "Wiz_Sorc", nSpellId)) == GetLocalInt(oPC, "FactotumArcDil"))
        			SetLocalInt(oPC, "ArcDilMaxPicked", TRUE);
        	}		
        	
        	// We have more to go
            if(GetMaxLearnedArcDil(oPC))
            {
                nStage = STAGE_SELECT_LEVEL;
            }
            else
            {
           	 	// And we're all done
            	AllowExit(DYNCONV_EXIT_FORCE_EXIT); 
            	DelayCommand(0.5, CheckFactotumSlots(oPC));
            	if (GetLevelByClass(CLASS_TYPE_FACTOTUM, oPC) >= 19) DelayCommand(0.25, StartDynamicConversation("prc_fact_cunconv", oPC, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oPC));
            }
            MarkStageNotSetUp(STAGE_CONFIRM_SELECTION, oPC);        
        }

        if(DEBUG) DoDebug("prc_fact_splconv: New stage: " + IntToString(nStage));

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
