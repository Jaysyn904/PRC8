//:://////////////////////////////////////////////
//:: Incarnum Blade Bind Blademeld choice script
//:: moi_iblade_bind
//:://////////////////////////////////////////////
/*
    @author Stratovarius - 2021.01.25
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "moi_inc_moifunc"
#include "inc_dynconv"

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_SELECT_MELD       = 0;
const int STAGE_CONFIRM_SELECTION   = 2;

const int CHOICE_BACK_TO_LSELECT    = -1;
const int STRREF_SELECTED_HEADER1   = 16824209; // "You have selected:"
const int STRREF_SELECTED_HEADER2   = 16824210; // "Is this correct?"
const int STRREF_YES                = 4752;     // "Yes"
const int STRREF_NO                 = 4753;     // "No"

const int SORT       = TRUE; // If the sorting takes too much CPU, set to FALSE
const int DEBUG_LIST = FALSE;

//////////////////////////////////////////////////
/* Function defintions                          */
//////////////////////////////////////////////////

void PrintList(object oMeldshaper)
{
    string tp = "Printing list:\n";
    string s = GetLocalString(oMeldshaper, "PRC_BindingConvo_List_Head");
    if(s == ""){
        tp += "Empty\n";
    }
    else{
        tp += s + "\n";
        s = GetLocalString(oMeldshaper, "PRC_BindingConvo_List_Next_" + s);
        while(s != ""){
            tp += "=> " + s + "\n";
            s = GetLocalString(oMeldshaper, "PRC_BindingConvo_List_Next_" + s);
        }
    }

    DoDebug(tp);
}

/**
 * Creates a linked list of entries that is sorted into alphabetical order
 * as it is built.
 * Assumption: mystery names are unique.
 *
 * @param oMeldshaper     The storage object aka whomever is gaining powers in this conversation
 * @param sChoice The choice string
 * @param nChoice The choice value
 */
void AddToTempList(object oMeldshaper, string sChoice, int nChoice)
{
    if(DEBUG_LIST) DoDebug("\nAdding to temp list: '" + sChoice + "' - " + IntToString(nChoice));
    if(DEBUG_LIST) PrintList(oMeldshaper);
    // If there is nothing yet
    if(!GetLocalInt(oMeldshaper, "PRC_BindingConvo_ListInited"))
    {
        SetLocalString(oMeldshaper, "PRC_BindingConvo_List_Head", sChoice);
        SetLocalInt(oMeldshaper, "PRC_BindingConvo_List_" + sChoice, nChoice);

        SetLocalInt(oMeldshaper, "PRC_BindingConvo_ListInited", TRUE);
    }
    else
    {
        // Find the location to instert into
        string sPrev = "", sNext = GetLocalString(oMeldshaper, "PRC_BindingConvo_List_Head");
        while(sNext != "" && StringCompare(sChoice, sNext) >= 0)
        {
            if(DEBUG_LIST) DoDebug("Comparison between '" + sChoice + "' and '" + sNext + "' = " + IntToString(StringCompare(sChoice, sNext)));
            sPrev = sNext;
            sNext = GetLocalString(oMeldshaper, "PRC_BindingConvo_List_Next_" + sNext);
        }

        // Insert the new entry
        // Does it replace the head?
        if(sPrev == "")
        {
            if(DEBUG_LIST) DoDebug("New head");
            SetLocalString(oMeldshaper, "PRC_BindingConvo_List_Head", sChoice);
        }
        else
        {
            if(DEBUG_LIST) DoDebug("Inserting into position between '" + sPrev + "' and '" + sNext + "'");
            SetLocalString(oMeldshaper, "PRC_BindingConvo_List_Next_" + sPrev, sChoice);
        }

        SetLocalString(oMeldshaper, "PRC_BindingConvo_List_Next_" + sChoice, sNext);
        SetLocalInt(oMeldshaper, "PRC_BindingConvo_List_" + sChoice, nChoice);
    }
}

/**
 * Reads the linked list built with AddToTempList() to AddChoice() and
 * deletes it.
 *
 * @param oMeldshaper A PC gaining powers at the moment
 */
void TransferTempList(object oMeldshaper)
{
    string sChoice = GetLocalString(oMeldshaper, "PRC_BindingConvo_List_Head");
    int    nChoice = GetLocalInt   (oMeldshaper, "PRC_BindingConvo_List_" + sChoice);

    DeleteLocalString(oMeldshaper, "PRC_BindingConvo_List_Head");
    string sPrev;

    if(DEBUG_LIST) DoDebug("Head is: '" + sChoice + "' - " + IntToString(nChoice));

    while(sChoice != "")
    {
        // Add the choice
        AddChoice(sChoice, nChoice, oMeldshaper);

        // Get next
        sChoice = GetLocalString(oMeldshaper, "PRC_BindingConvo_List_Next_" + (sPrev = sChoice));
        nChoice = GetLocalInt   (oMeldshaper, "PRC_BindingConvo_List_" + sChoice);

        if(DEBUG_LIST) DoDebug("Next is: '" + sChoice + "' - " + IntToString(nChoice) + "; previous = '" + sPrev + "'");

        // Delete the already handled data
        DeleteLocalString(oMeldshaper, "PRC_BindingConvo_List_Next_" + sPrev);
        DeleteLocalInt   (oMeldshaper, "PRC_BindingConvo_List_" + sPrev);
    }

    DeleteLocalInt(oMeldshaper, "PRC_BindingConvo_ListInited");
}

void main()
{
    object oMeldshaper = GetPCSpeaker();
    int nValue = GetLocalInt(oMeldshaper, DYNCONV_VARIABLE);
    int nStage = GetStage(oMeldshaper);
	int nClass = GetLevelByClass(CLASS_TYPE_INCARNUM_BLADE, oMeldshaper);

	int i;
	// Make sure to clean off existing blademelds before applying new ones
    for (i = 18647; i < 18657; i++)
    {
		PRCRemoveSpellEffects(i, oMeldshaper, oMeldshaper);
		GZPRCRemoveSpellEffects(i, oMeldshaper, FALSE);
    }  	
    
    // Check which of the conversation scripts called the scripts
    if(nValue == 0) // All of them set the DynConv_Var to non-zero value, so something is wrong -> abort
        return;

    if(nValue == DYNCONV_SETUP_STAGE)
    {
        if(DEBUG) DoDebug("moi_iblade_bind: Running setup stage for stage " + IntToString(nStage));
        // Check if this stage is marked as already set up
        // This stops list duplication when scrolling
        if(!GetIsStageSetUp(nStage, oMeldshaper))
        {
            if(DEBUG) DoDebug("moi_iblade_bind: Stage was not set up already");
			if(nStage == STAGE_SELECT_MELD)
            {
                if(DEBUG) DoDebug("moi_iblade_bind: Building meld selection");
                
                SetHeader("Choose the chakra you wish to bind your blademeld to. At 5th level you can bind two chakras with your blade meld. If you exit this conversation without selecting all your binds, you will need to rest to bind melds.");
               
				if (!GetIsBlademeldUsed(oMeldshaper, CHAKRA_CROWN    )) AddChoice("Crown",     CHAKRA_CROWN    , oMeldshaper);
				if (!GetIsBlademeldUsed(oMeldshaper, CHAKRA_FEET     )) AddChoice("Feet",      CHAKRA_FEET     , oMeldshaper);
				if (!GetIsBlademeldUsed(oMeldshaper, CHAKRA_HANDS    )) AddChoice("Hands",     CHAKRA_HANDS    , oMeldshaper);
				if (nClass >= 2)
				{
					if (!GetIsBlademeldUsed(oMeldshaper, CHAKRA_ARMS     )) AddChoice("Arms",      CHAKRA_ARMS     , oMeldshaper);
					if (!GetIsBlademeldUsed(oMeldshaper, CHAKRA_BROW     )) AddChoice("Brow",      CHAKRA_BROW     , oMeldshaper);
					if (!GetIsBlademeldUsed(oMeldshaper, CHAKRA_SHOULDERS)) AddChoice("Shoulders", CHAKRA_SHOULDERS, oMeldshaper);
				}
				if (nClass >= 3)
				{
					if (!GetIsBlademeldUsed(oMeldshaper, CHAKRA_THROAT   )) AddChoice("Throat",    CHAKRA_THROAT   , oMeldshaper);
					if (!GetIsBlademeldUsed(oMeldshaper, CHAKRA_WAIST    )) AddChoice("Waist",     CHAKRA_WAIST    , oMeldshaper);
				}	
				if (nClass >= 4)
					if (!GetIsBlademeldUsed(oMeldshaper, CHAKRA_HEART    )) AddChoice("Heart",     CHAKRA_HEART    , oMeldshaper);
				if (nClass >= 5)	
					if (!GetIsBlademeldUsed(oMeldshaper, CHAKRA_SOUL     )) AddChoice("Soul",      CHAKRA_SOUL     , oMeldshaper);

                // Set the next, previous and wait tokens to default values
                SetDefaultTokens();
                // Set the convo quit text to "Abort"
                SetCustomToken(DYNCONV_TOKEN_EXIT, GetStringByStrRef(DYNCONV_STRREF_ABORT_CONVO));
            }            
            // Selection confirmation stage
            else if(nStage == STAGE_CONFIRM_SELECTION)
            {
                if(DEBUG) DoDebug("moi_iblade_bind: Building selection confirmation");

                // Build the confirmation query
                int nChakra = GetLocalInt(oMeldshaper, "nChakra");
                string sToken = "You have chosen to bind your blademeld to the "+ChakraToString(nChakra)+" chakra"+ "\n\n"; 
                sToken += GetBlademeldDesc(nChakra)+"\n\n";
                sToken += GetStringByStrRef(STRREF_SELECTED_HEADER2); // "Is this correct?"
                SetHeader(sToken);
	
                AddChoice(GetStringByStrRef(STRREF_YES), TRUE, oMeldshaper); // "Yes"
                AddChoice(GetStringByStrRef(STRREF_NO), FALSE, oMeldshaper); // "No"
            }
        }

        // Do token setup
        SetupTokens();
    }
    else if(nValue == DYNCONV_EXITED)
    {
        if(DEBUG) DoDebug("moi_iblade_bind: Running exit handler");
        // End of conversation cleanup
        DeleteLocalInt(oMeldshaper, "nChakra");
        DeleteLocalInt(oMeldshaper, "BlademeldChoice");
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
        int nChoice = GetChoice(oMeldshaper);
        if(DEBUG) DoDebug("moi_iblade_bind: Handling PC response, stage = " + IntToString(nStage) + "; nChoice = " + IntToString(nChoice) + "; choice text = '" + GetChoiceText(oMeldshaper) +  "'");
        if(nStage == STAGE_SELECT_MELD)
        {
           	if(DEBUG) DoDebug("moi_iblade_bind: Chakra selected");
           	SetLocalInt(oMeldshaper, "nChakra", nChoice);
           	nStage = STAGE_CONFIRM_SELECTION;

            MarkStageNotSetUp(STAGE_SELECT_MELD, oMeldshaper);
        }        
        else if(nStage == STAGE_CONFIRM_SELECTION)
        {     
        	if (nChoice)
        	{
        		ShapeSoulmeld(oMeldshaper, ChakraToBlademeld(GetLocalInt(oMeldshaper, "nChakra")));
        		// Mark it used
        		SetLocalInt(oMeldshaper, "BlademeldChoice", GetLocalInt(oMeldshaper, "BlademeldChoice")+1);
        		DeleteLocalInt(oMeldshaper, "nChakra");
        	}	        	
        	
        	// We have more to go
            if(!GetLocalInt(oMeldshaper, "BlademeldChoice") || (nClass == 5 && GetLocalInt(oMeldshaper, "BlademeldChoice") == 1))
            {
                nStage = STAGE_SELECT_MELD;
            }
            else
            {
           		AllowExit(DYNCONV_EXIT_FORCE_EXIT); 
            }
            MarkStageNotSetUp(STAGE_CONFIRM_SELECTION, oMeldshaper);        
        }

        if(DEBUG) DoDebug("moi_iblade_bind: New stage: " + IntToString(nStage));

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oMeldshaper);
    }
}

