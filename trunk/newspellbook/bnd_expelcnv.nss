//:://////////////////////////////////////////////
//:: Expel Vestige choice script
//:: bnd_expelcnv
//:://////////////////////////////////////////////
/*
    @author Stratovarius - 2021.02.03
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "bnd_inc_bndfunc"
#include "inc_dynconv"

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_SELECT_VESTIGE      = 0;
const int STAGE_CONFIRM_SELECTION   = 1;

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

void PrintList(object oBinder)
{
    string tp = "Printing list:\n";
    string s = GetLocalString(oBinder, "PRC_MeldshapeConvo_List_Head");
    if(s == ""){
        tp += "Empty\n";
    }
    else{
        tp += s + "\n";
        s = GetLocalString(oBinder, "PRC_MeldshapeConvo_List_Next_" + s);
        while(s != ""){
            tp += "=> " + s + "\n";
            s = GetLocalString(oBinder, "PRC_MeldshapeConvo_List_Next_" + s);
        }
    }

    DoDebug(tp);
}

/**
 * Creates a linked list of entries that is sorted into alphabetical order
 * as it is built.
 * Assumption: mystery names are unique.
 *
 * @param oBinder     The storage object aka whomever is gaining powers in this conversation
 * @param sChoice The choice string
 * @param nChoice The choice value
 */
void AddToTempList(object oBinder, string sChoice, int nChoice)
{
    if(DEBUG_LIST) DoDebug("\nAdding to temp list: '" + sChoice + "' - " + IntToString(nChoice));
    if(DEBUG_LIST) PrintList(oBinder);
    // If there is nothing yet
    if(!GetLocalInt(oBinder, "PRC_MeldshapeConvo_ListInited"))
    {
        SetLocalString(oBinder, "PRC_MeldshapeConvo_List_Head", sChoice);
        SetLocalInt(oBinder, "PRC_MeldshapeConvo_List_" + sChoice, nChoice);

        SetLocalInt(oBinder, "PRC_MeldshapeConvo_ListInited", TRUE);
    }
    else
    {
        // Find the location to instert into
        string sPrev = "", sNext = GetLocalString(oBinder, "PRC_MeldshapeConvo_List_Head");
        while(sNext != "" && StringCompare(sChoice, sNext) >= 0)
        {
            if(DEBUG_LIST) DoDebug("Comparison between '" + sChoice + "' and '" + sNext + "' = " + IntToString(StringCompare(sChoice, sNext)));
            sPrev = sNext;
            sNext = GetLocalString(oBinder, "PRC_MeldshapeConvo_List_Next_" + sNext);
        }

        // Insert the new entry
        // Does it replace the head?
        if(sPrev == "")
        {
            if(DEBUG_LIST) DoDebug("New head");
            SetLocalString(oBinder, "PRC_MeldshapeConvo_List_Head", sChoice);
        }
        else
        {
            if(DEBUG_LIST) DoDebug("Inserting into position between '" + sPrev + "' and '" + sNext + "'");
            SetLocalString(oBinder, "PRC_MeldshapeConvo_List_Next_" + sPrev, sChoice);
        }

        SetLocalString(oBinder, "PRC_MeldshapeConvo_List_Next_" + sChoice, sNext);
        SetLocalInt(oBinder, "PRC_MeldshapeConvo_List_" + sChoice, nChoice);
    }
}

/**
 * Reads the linked list built with AddToTempList() to AddChoice() and
 * deletes it.
 *
 * @param oBinder A PC gaining powers at the moment
 */
void TransferTempList(object oBinder)
{
    string sChoice = GetLocalString(oBinder, "PRC_MeldshapeConvo_List_Head");
    int    nChoice = GetLocalInt   (oBinder, "PRC_MeldshapeConvo_List_" + sChoice);

    DeleteLocalString(oBinder, "PRC_MeldshapeConvo_List_Head");
    string sPrev;

    if(DEBUG_LIST) DoDebug("Head is: '" + sChoice + "' - " + IntToString(nChoice));

    while(sChoice != "")
    {
        // Add the choice
        AddChoice(sChoice, nChoice, oBinder);

        // Get next
        sChoice = GetLocalString(oBinder, "PRC_MeldshapeConvo_List_Next_" + (sPrev = sChoice));
        nChoice = GetLocalInt   (oBinder, "PRC_MeldshapeConvo_List_" + sChoice);

        if(DEBUG_LIST) DoDebug("Next is: '" + sChoice + "' - " + IntToString(nChoice) + "; previous = '" + sPrev + "'");

        // Delete the already handled data
        DeleteLocalString(oBinder, "PRC_MeldshapeConvo_List_Next_" + sPrev);
        DeleteLocalInt   (oBinder, "PRC_MeldshapeConvo_List_" + sPrev);
    }

    DeleteLocalInt(oBinder, "PRC_MeldshapeConvo_ListInited");
}

void main()
{
    object oBinder = GetPCSpeaker();
    int nValue = GetLocalInt(oBinder, DYNCONV_VARIABLE);
    int nStage = GetStage(oBinder);
    string sVestigeFile = GetVestigeFile(); 

    // Check which of the conversation scripts called the scripts
    if(nValue == 0) // All of them set the DynConv_Var to non-zero value, so something is wrong -> abort
        return;

    if(nValue == DYNCONV_SETUP_STAGE)
    {
        if(DEBUG) DoDebug("bnd_expelcnv: Running setup stage for stage " + IntToString(nStage));
        // Check if this stage is marked as already set up
        // This stops list duplication when scrolling
        if(!GetIsStageSetUp(nStage, oBinder))
        {
            if(DEBUG) DoDebug("bnd_expelcnv: Stage was not set up already");
			if(nStage == STAGE_SELECT_VESTIGE)
            {
                if(DEBUG) DoDebug("bnd_expelcnv: Building vestige selection");

                SetHeader("Choose the vestige to expel.");
               
                string sVestige;
                int i, nVestige;
                for(i = 0; i < 50 ; i++)
                {
                    sVestige = GetStringByStrRef(StringToInt(Get2DACache(sVestigeFile, "Name", i)));
                    nVestige = StringToInt(Get2DACache(sVestigeFile, "SpellID", i));
                    if (DEBUG) DoDebug("sVestige: "+sVestige);
                    
                    // If we have the vestige bound
                    if(GetHasSpellEffect(nVestige, oBinder)) 
                    {
						AddChoice(GetStringByStrRef(StringToInt(Get2DACache(sVestigeFile, "Name", i))), i, oBinder);  
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
                if(DEBUG) DoDebug("bnd_expelcnv: Building selection confirmation");
                // Build the confirmation query
                string sToken = GetStringByStrRef(STRREF_SELECTED_HEADER1) + "\n\n"; // "You have selected:"
                int nSpellId = GetLocalInt(oBinder, "nVestige");
                sToken += GetStringByStrRef(StringToInt(Get2DACache(sVestigeFile, "Description", nSpellId)))+"\n\n";
                sToken += GetStringByStrRef(STRREF_SELECTED_HEADER2); // "Is this correct?"
                SetHeader(sToken);

                AddChoice(GetStringByStrRef(STRREF_YES), TRUE, oBinder); // "Yes"
                AddChoice(GetStringByStrRef(STRREF_NO), FALSE, oBinder); // "No"
            }
        }

        // Do token setup
        SetupTokens();
    }
    else if(nValue == DYNCONV_EXITED)
    {
        if(DEBUG) DoDebug("bnd_expelcnv: Running exit handler");
        // End of conversation cleanup
        DeleteLocalInt(oBinder, "nVestige");
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
        int nChoice = GetChoice(oBinder);
        if(DEBUG) DoDebug("bnd_expelcnv: Handling PC response, stage = " + IntToString(nStage) + "; nChoice = " + IntToString(nChoice) + "; choice text = '" + GetChoiceText(oBinder) +  "'");
        
        if(nStage == STAGE_SELECT_VESTIGE)
        {
           	if(DEBUG) DoDebug("bnd_expelcnv: Chakra selected");
           	SetLocalInt(oBinder, "nVestige", nChoice);
           	nStage = STAGE_CONFIRM_SELECTION;

            MarkStageNotSetUp(STAGE_SELECT_VESTIGE, oBinder);
        }        
        else if(nStage == STAGE_CONFIRM_SELECTION)
        {     
        	if (nChoice)
        	{
				int nContactTime = VESTIGE_CONTACT_TIME;		
				if(GetPRCSwitch(PRC_CONTACT_VESTIGE_TIMER) >= 6) nContactTime = GetPRCSwitch(PRC_CONTACT_VESTIGE_TIMER);        		     	
       			ContactVestige(oBinder, nContactTime, GetLocalInt(oBinder, "nVestige"), TRUE);
       			DeleteLocalInt(oBinder, "nVestige");        		
       			AllowExit(DYNCONV_EXIT_FORCE_EXIT); 
        	}
        	else 
        		nStage = STAGE_SELECT_VESTIGE;
        		
            MarkStageNotSetUp(STAGE_CONFIRM_SELECTION, oBinder);        
        }

        if(DEBUG) DoDebug("bnd_expelcnv: New stage: " + IntToString(nStage));

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oBinder);
    }
}
