//:://////////////////////////////////////////////
//:: Rebind Totem Soulmeld choice script
//:: moi_ttmbindcnv
//:://////////////////////////////////////////////
/*
    @author Stratovarius - 2019.12.21
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "moi_inc_moifunc"
#include "inc_dynconv"

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_SELECT_MELD         = 0;
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
    string s = GetLocalString(oMeldshaper, "PRC_TotemConvo_List_Head");
    if(s == ""){
        tp += "Empty\n";
    }
    else{
        tp += s + "\n";
        s = GetLocalString(oMeldshaper, "PRC_TotemConvo_List_Next_" + s);
        while(s != ""){
            tp += "=> " + s + "\n";
            s = GetLocalString(oMeldshaper, "PRC_TotemConvo_List_Next_" + s);
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
    if(!GetLocalInt(oMeldshaper, "PRC_TotemConvo_ListInited"))
    {
        SetLocalString(oMeldshaper, "PRC_TotemConvo_List_Head", sChoice);
        SetLocalInt(oMeldshaper, "PRC_TotemConvo_List_" + sChoice, nChoice);

        SetLocalInt(oMeldshaper, "PRC_TotemConvo_ListInited", TRUE);
    }
    else
    {
        // Find the location to instert into
        string sPrev = "", sNext = GetLocalString(oMeldshaper, "PRC_TotemConvo_List_Head");
        while(sNext != "" && StringCompare(sChoice, sNext) >= 0)
        {
            if(DEBUG_LIST) DoDebug("Comparison between '" + sChoice + "' and '" + sNext + "' = " + IntToString(StringCompare(sChoice, sNext)));
            sPrev = sNext;
            sNext = GetLocalString(oMeldshaper, "PRC_TotemConvo_List_Next_" + sNext);
        }

        // Insert the new entry
        // Does it replace the head?
        if(sPrev == "")
        {
            if(DEBUG_LIST) DoDebug("New head");
            SetLocalString(oMeldshaper, "PRC_TotemConvo_List_Head", sChoice);
        }
        else
        {
            if(DEBUG_LIST) DoDebug("Inserting into position between '" + sPrev + "' and '" + sNext + "'");
            SetLocalString(oMeldshaper, "PRC_TotemConvo_List_Next_" + sPrev, sChoice);
        }

        SetLocalString(oMeldshaper, "PRC_TotemConvo_List_Next_" + sChoice, sNext);
        SetLocalInt(oMeldshaper, "PRC_TotemConvo_List_" + sChoice, nChoice);
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
    string sChoice = GetLocalString(oMeldshaper, "PRC_TotemConvo_List_Head");
    int    nChoice = GetLocalInt   (oMeldshaper, "PRC_TotemConvo_List_" + sChoice);

    DeleteLocalString(oMeldshaper, "PRC_TotemConvo_List_Head");
    string sPrev;

    if(DEBUG_LIST) DoDebug("Head is: '" + sChoice + "' - " + IntToString(nChoice));

    while(sChoice != "")
    {
        // Add the choice
        AddChoice(sChoice, nChoice, oMeldshaper);

        // Get next
        sChoice = GetLocalString(oMeldshaper, "PRC_TotemConvo_List_Next_" + (sPrev = sChoice));
        nChoice = GetLocalInt   (oMeldshaper, "PRC_TotemConvo_List_" + sChoice);

        if(DEBUG_LIST) DoDebug("Next is: '" + sChoice + "' - " + IntToString(nChoice) + "; previous = '" + sPrev + "'");

        // Delete the already handled data
        DeleteLocalString(oMeldshaper, "PRC_TotemConvo_List_Next_" + sPrev);
        DeleteLocalInt   (oMeldshaper, "PRC_TotemConvo_List_" + sPrev);
    }

    DeleteLocalInt(oMeldshaper, "PRC_TotemConvo_ListInited");
}

void main()
{
    object oMeldshaper = GetPCSpeaker();
    int nValue = GetLocalInt(oMeldshaper, DYNCONV_VARIABLE);
    int nStage = GetStage(oMeldshaper);
	int nClass = CLASS_TYPE_TOTEMIST;
    string sMeldFile = GetMeldFile(); 

    // Check which of the conversation scripts called the scripts
    if(nValue == 0) // All of them set the DynConv_Var to non-zero value, so something is wrong -> abort
        return;

    if(nValue == DYNCONV_SETUP_STAGE)
    {
        if(DEBUG) DoDebug("moi_ttmbindcnv: Running setup stage for stage " + IntToString(nStage));
        // Check if this stage is marked as already set up
        // This stops list duplication when scrolling
        if(!GetIsStageSetUp(nStage, oMeldshaper))
        {
            if(DEBUG) DoDebug("moi_ttmbindcnv: Stage was not set up already");
			if(nStage == STAGE_SELECT_MELD)
            {
                if(DEBUG) DoDebug("moi_ttmbindcnv: Building meld selection");
                
                SetHeader("Choose the soulmelds you wish to bind. You can bind up to "+IntToString(GetMaxBindCount(oMeldshaper, nClass))+" soulmelds");
               
                int i;
                for(i = 1; i < 11 ; i++)
                {
                    int nMeld = GetIsChakraUsed(oMeldshaper, i, nClass);
                    
                    if (DEBUG) DoDebug("moi_ttmbindcnv "+IntToString(i)+" nMeld: "+IntToString(nMeld));
                    
                    // It's a meld, and it's either not bound or we can bind to both regular chakra and totem chakra
                    if(nMeld && (!GetIsMeldBound(oMeldshaper, nMeld) || GetLevelByClass(CLASS_TYPE_TOTEMIST, oMeldshaper) >= 11)) 
                    {
						AddChoice(GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nMeld))), i, oMeldshaper);  
                    }
                }

                // Set the next, previous and wait tokens to default values
                SetDefaultTokens();
                // Set the convo quit text to "Abort"
                SetCustomToken(DYNCONV_TOKEN_EXIT, GetStringByStrRef(DYNCONV_STRREF_ABORT_CONVO));
            }            
            // Selection confirmation stage
            else if(nStage == STAGE_CONFIRM_SELECTION)
            {
                if(DEBUG) DoDebug("moi_ttmbindcnv: Building selection confirmation");

	            // Build the confirmation query
	            int nMeld = GetIsChakraUsed(oMeldshaper, GetLocalInt(oMeldshaper, "nChakra"), nClass);
	            string sToken = "You have chosen to bind "+GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nMeld)))+"\n\n"; 
	            sToken += GetStringByStrRef(StringToInt(Get2DACache("spells", "SpellDesc", nMeld)))+"\n\n";
	            sToken += "Do you wish to bind it to the Totem Chakra?"; 
	            SetHeader(sToken); 
	            
	            AddChoice("Totem", 1000, oMeldshaper);
	            AddChoice(GetStringByStrRef(STRREF_NO), FALSE, oMeldshaper); // "No"	                   
            }
        }

        // Do token setup
        SetupTokens();
    }
    else if(nValue == DYNCONV_EXITED)
    {
        if(DEBUG) DoDebug("moi_ttmbindcnv: Running exit handler");
        // End of conversation cleanup
        DeleteLocalInt(oMeldshaper, "nMeld");
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
        if(DEBUG) DoDebug("moi_ttmbindcnv: Handling PC response, stage = " + IntToString(nStage) + "; nChoice = " + IntToString(nChoice) + "; choice text = '" + GetChoiceText(oMeldshaper) +  "'");
        if(nStage == STAGE_SELECT_MELD)
        {
           	if(DEBUG) DoDebug("moi_ttmbindcnv: Chakra selected");
           	SetLocalInt(oMeldshaper, "nChakra", nChoice);
           	nStage = STAGE_CONFIRM_SELECTION;

            MarkStageNotSetUp(STAGE_SELECT_MELD, oMeldshaper);
        }        
        else if(nStage == STAGE_CONFIRM_SELECTION)
        {     
        	if (nChoice == 1000)
        	{
        		BindMeldToChakra(oMeldshaper, GetIsChakraUsed(oMeldshaper, GetLocalInt(oMeldshaper, "nChakra"), nClass), CHAKRA_TOTEM, nClass);
        		DeleteLocalInt(oMeldshaper, "nChakra");
        		AllowExit(DYNCONV_EXIT_FORCE_EXIT); 
        	}        	
            else
            {
                nStage = STAGE_SELECT_MELD;
            }

            MarkStageNotSetUp(STAGE_CONFIRM_SELECTION, oMeldshaper);        
        }

        if(DEBUG) DoDebug("moi_ttmbindcnv: New stage: " + IntToString(nStage));

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oMeldshaper);
    }
}
