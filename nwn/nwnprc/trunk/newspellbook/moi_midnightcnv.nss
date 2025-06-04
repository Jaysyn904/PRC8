//:://////////////////////////////////////////////
//:: Meldshaper Invest Essentia choice script
//:: moi_midnightcnv
//:://////////////////////////////////////////////
/*
    @author Stratovarius - 2019.12.29
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "moi_inc_moifunc"
#include "inc_dynconv"

//////////////////////////////////////////////////
/* Constant definitions                         */
//////////////////////////////////////////////////

const int STAGE_SELECT_POWER            = 0;
const int STAGE_SELECT_ESSENTIA_POWER    = 6;
const int STAGE_CONFIRM_SELECTION_POWER  = 7;

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
    string s = GetLocalString(oMeldshaper, "PRC_MidnightConvo_List_Head");
    if(s == ""){
        tp += "Empty\n";
    }
    else{
        tp += s + "\n";
        s = GetLocalString(oMeldshaper, "PRC_MidnightConvo_List_Next_" + s);
        while(s != ""){
            tp += "=> " + s + "\n";
            s = GetLocalString(oMeldshaper, "PRC_MidnightConvo_List_Next_" + s);
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
    if(!GetLocalInt(oMeldshaper, "PRC_MidnightConvo_ListInited"))
    {
        SetLocalString(oMeldshaper, "PRC_MidnightConvo_List_Head", sChoice);
        SetLocalInt(oMeldshaper, "PRC_MidnightConvo_List_" + sChoice, nChoice);

        SetLocalInt(oMeldshaper, "PRC_MidnightConvo_ListInited", TRUE);
    }
    else
    {
        // Find the location to instert into
        string sPrev = "", sNext = GetLocalString(oMeldshaper, "PRC_MidnightConvo_List_Head");
        while(sNext != "" && StringCompare(sChoice, sNext) >= 0)
        {
            if(DEBUG_LIST) DoDebug("Comparison between '" + sChoice + "' and '" + sNext + "' = " + IntToString(StringCompare(sChoice, sNext)));
            sPrev = sNext;
            sNext = GetLocalString(oMeldshaper, "PRC_MidnightConvo_List_Next_" + sNext);
        }

        // Insert the new entry
        // Does it replace the head?
        if(sPrev == "")
        {
            if(DEBUG_LIST) DoDebug("New head");
            SetLocalString(oMeldshaper, "PRC_MidnightConvo_List_Head", sChoice);
        }
        else
        {
            if(DEBUG_LIST) DoDebug("Inserting into position between '" + sPrev + "' and '" + sNext + "'");
            SetLocalString(oMeldshaper, "PRC_MidnightConvo_List_Next_" + sPrev, sChoice);
        }

        SetLocalString(oMeldshaper, "PRC_MidnightConvo_List_Next_" + sChoice, sNext);
        SetLocalInt(oMeldshaper, "PRC_MidnightConvo_List_" + sChoice, nChoice);
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
    string sChoice = GetLocalString(oMeldshaper, "PRC_MidnightConvo_List_Head");
    int    nChoice = GetLocalInt   (oMeldshaper, "PRC_MidnightConvo_List_" + sChoice);

    DeleteLocalString(oMeldshaper, "PRC_MidnightConvo_List_Head");
    string sPrev;

    if(DEBUG_LIST) DoDebug("Head is: '" + sChoice + "' - " + IntToString(nChoice));

    while(sChoice != "")
    {
        // Add the choice
        AddChoice(sChoice, nChoice, oMeldshaper);

        // Get next
        sChoice = GetLocalString(oMeldshaper, "PRC_MidnightConvo_List_Next_" + (sPrev = sChoice));
        nChoice = GetLocalInt   (oMeldshaper, "PRC_MidnightConvo_List_" + sChoice);

        if(DEBUG_LIST) DoDebug("Next is: '" + sChoice + "' - " + IntToString(nChoice) + "; previous = '" + sPrev + "'");

        // Delete the already handled data
        DeleteLocalString(oMeldshaper, "PRC_MidnightConvo_List_Next_" + sPrev);
        DeleteLocalInt   (oMeldshaper, "PRC_MidnightConvo_List_" + sPrev);
    }

    DeleteLocalInt(oMeldshaper, "PRC_MidnightConvo_ListInited");
}

void main()
{
    object oMeldshaper = GetPCSpeaker();
    int nValue = GetLocalInt(oMeldshaper, DYNCONV_VARIABLE);
    int nStage = GetStage(oMeldshaper);
	int nClass = GetMeldshapingClass(oMeldshaper);
    string sMeldFile = GetMeldFile(); 

    // Check which of the conversation scripts called the scripts
    if(nValue == 0) // All of them set the DynConv_Var to non-zero value, so something is wrong -> abort
        return;

    if(nValue == DYNCONV_SETUP_STAGE)
    {
        if(DEBUG) DoDebug("moi_midnightcnv: Running setup stage for stage " + IntToString(nStage));
        // Check if this stage is marked as already set up
        // This stops list duplication when scrolling
        if(!GetIsStageSetUp(nStage, oMeldshaper))
        {
            if(DEBUG) DoDebug("moi_midnightcnv: Stage was not set up already");

			if(nStage == STAGE_SELECT_POWER)
            {
            	if(DEBUG) DoDebug("moi_midnightcnv: Building power selection");
                int i, nPowerLevel;
                int nMaxLevel = GetMaxEssentiaCapacityFeat(oMeldshaper);
                string sFeatID;
				for(i = 14001; i < 14260 ; i++)
                {
                    nPowerLevel = StringToInt(Get2DACache("spells", "Innate", i));

                    //Due to the way the 2das are structured, we know that once
                    //the level of a read evocation is greater than the maximum castable
                    //it'll never be lower again. Therefore, we can skip reading the
                    //evocations that wouldn't be shown anyway.
                     
                    if(nPowerLevel > nMaxLevel)
                        break;
       
                    if(GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", i))) != "") // Non-blank row
                    {
                        if(SORT) AddToTempList(oMeldshaper, GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", i))), i);
                        else     AddChoice(GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", i))), i, oMeldshaper);   
                    }
                }
				
				TransferTempList(oMeldshaper);				
            } 			
			else if(nStage == STAGE_SELECT_ESSENTIA_POWER)
            {
                if(DEBUG) DoDebug("moi_midnightcnv: Building essentia selection");
                // Build the confirmation query
                int nPower = GetLocalInt(oMeldshaper, "nPower");
                SetHeader("How much do you want to invest into "+GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nPower)))+"?"); 
                int i;
                int nMin = PRCMin(GetMaxEssentiaCapacityFeat(oMeldshaper), StringToInt(Get2DACache("spells", "Innate", nPower)));
                for(i = 1; i <= nMin; i++)
                {
					AddChoice(IntToString(i), i, oMeldshaper);  
                }
            }  
            else if(nStage == STAGE_CONFIRM_SELECTION_POWER)
            {
                if(DEBUG) DoDebug("moi_midnightcnv: Building selection confirmation");
                // Build the confirmation query
                int nPower = GetLocalInt(oMeldshaper, "nPower");
                string sToken = "You have chosen to invest "+IntToString(GetLocalInt(oMeldshaper, "nEssentia"))+" essentia into "+GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nPower)))+"."+ "\n\n"; 
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
        if(DEBUG) DoDebug("moi_midnightcnv: Running exit handler");
        // End of conversation cleanup
        DeleteLocalInt(oMeldshaper, "nPower");
        DeleteLocalInt(oMeldshaper, "nEssentia");
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
        if(DEBUG) DoDebug("moi_midnightcnv: Handling PC response, stage = " + IntToString(nStage) + "; nChoice = " + IntToString(nChoice) + "; choice text = '" + GetChoiceText(oMeldshaper) +  "'");
        if(nStage == STAGE_SELECT_POWER)
        {
           	if(DEBUG) DoDebug("moi_midnightcnv: Type selected");
           	SetLocalInt(oMeldshaper, "nPower", nChoice);         		

            MarkStageNotSetUp(STAGE_SELECT_POWER, oMeldshaper);
        }     
        else if(nStage == STAGE_SELECT_ESSENTIA_POWER)
        {
           	if(DEBUG) DoDebug("moi_midnightcnv: Feat Essentia selected");
           	SetLocalInt(oMeldshaper, "nEssentia", nChoice);
           	nStage = STAGE_CONFIRM_SELECTION_POWER;

            MarkStageNotSetUp(STAGE_SELECT_ESSENTIA_POWER, oMeldshaper);
        }    
        else if(nStage == STAGE_CONFIRM_SELECTION_POWER)
        {     
        	if (nChoice)
        	{
        		SetLocalInt(oMeldshaper, "MidnightAugPower", GetLocalInt(oMeldshaper, "nPower"));
        		InvestEssentiaFeat(oMeldshaper, FEAT_MIDNIGHT_AUGMENTATION, GetLocalInt(oMeldshaper, "nEssentia"));
        		DeleteLocalInt(oMeldshaper, "nPower");
        		DeleteLocalInt(oMeldshaper, "nEssentia");
        		AllowExit(DYNCONV_EXIT_FORCE_EXIT); 
        	}		
            else
            {
       	 		nStage = STAGE_SELECT_POWER;      	
            }
            MarkStageNotSetUp(STAGE_CONFIRM_SELECTION_POWER, oMeldshaper);        
        }         

        if(DEBUG) DoDebug("moi_midnightcnv: New stage: " + IntToString(nStage));

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oMeldshaper);
    }
}