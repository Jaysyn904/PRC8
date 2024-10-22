//:://////////////////////////////////////////////
//:: Meldshaper Bind Soulmeld choice script
//:: moi_bindingcnv
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
	int nClass = GetMeldshapingClass(oMeldshaper);
    string sMeldFile = GetMeldFile(); 

    // Check which of the conversation scripts called the scripts
    if(nValue == 0) // All of them set the DynConv_Var to non-zero value, so something is wrong -> abort
        return;

    if(nValue == DYNCONV_SETUP_STAGE)
    {
        if(DEBUG) DoDebug("moi_bindingcnv: Running setup stage for stage " + IntToString(nStage));
        // Check if this stage is marked as already set up
        // This stops list duplication when scrolling
        if(!GetIsStageSetUp(nStage, oMeldshaper))
        {
            if(DEBUG) DoDebug("moi_bindingcnv: Stage was not set up already");
			if(nStage == STAGE_SELECT_MELD)
            {
                if(DEBUG) DoDebug("moi_bindingcnv: Building meld selection");
                
                SetHeader("You are binding soulmelds as a "+GetStringByStrRef(StringToInt(Get2DACache("classes", "Name", nClass)))+". You can bind up to "+IntToString(GetMaxBindCount(oMeldshaper, nClass))+" soulmelds. If you exit this conversation without selecting all your binds, you will need to rest to bind melds.");
               
                int i, nTest;
                for(i = 1; i < 22 ; i++)
                {
                    int nMeld = GetIsChakraUsed(oMeldshaper, i, nClass);
                    
                    if (DEBUG) DoDebug("moi_bindingcnv "+IntToString(i)+" nMeld: "+IntToString(nMeld));
                    
                    int nTotem = TRUE;
                    
                    // If we're doing totemist, and it's been bound to the totem meld, and you don't have the 11th level class feature
                    if (GetIsMeldBound(oMeldshaper, nMeld) == CHAKRA_TOTEM && nClass == CLASS_TYPE_TOTEMIST && 11 > GetLevelByClass(CLASS_TYPE_TOTEMIST, oMeldshaper)) nTotem = FALSE;
                    
                    if (DEBUG) DoDebug("moi_bindingcnv nTotem: "+IntToString(nTotem));
                    
                    // Something was stored in the Chakra, and the character has access to a bind, and it's not been bound to the totem chakra. If it's already bound, skip it
                    if(nMeld && (GetCanBindChakra(oMeldshaper, i) || (nClass == CLASS_TYPE_TOTEMIST && GetLevelByClass(CLASS_TYPE_TOTEMIST, oMeldshaper) >= 2)) && nTotem && !GetIsMeldBound(oMeldshaper, nMeld) && !GetIsChakraBound(oMeldshaper, i)) 
                    {
						AddChoice(GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nMeld))), i, oMeldshaper);  
						nTest++;
                    }
                }
                if(GetMaxBindCount(oMeldshaper, nClass) == 0) // This can happen with multiclassing
                   	AddChoice("Next Class", -1, oMeldshaper);
                if(nTest == 0) // Every meld isn't in a legal bind spot
                	AddChoice("Exit Conversation", -2, oMeldshaper);
                // Set the next, previous and wait tokens to default values
                SetDefaultTokens();
                // Set the convo quit text to "Abort"
                SetCustomToken(DYNCONV_TOKEN_EXIT, GetStringByStrRef(DYNCONV_STRREF_ABORT_CONVO));
            }            
            // Selection confirmation stage
            else if(nStage == STAGE_CONFIRM_SELECTION)
            {
                if(DEBUG) DoDebug("moi_bindingcnv: Building selection confirmation");
                
                // This can only ever trigger for the totemist
                if ((!GetIsChakraBound(oMeldshaper, CHAKRA_TOTEM) || !GetIsChakraBound(oMeldshaper, CHAKRA_DOUBLE_TOTEM)) && nClass == CLASS_TYPE_TOTEMIST)
                {
	                // Build the confirmation query
	                int nMeld = GetIsChakraUsed(oMeldshaper, GetLocalInt(oMeldshaper, "nChakra"), nClass);
	                string sToken = "You have chosen to bind "+GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nMeld)))+"\n\n"; 
	                sToken += GetStringByStrRef(StringToInt(Get2DACache("spells", "SpellDesc", nMeld)))+"\n\n";
	                sToken += "Do you wish to bind it to the Totem Chakra or the "+ChakraToString(GetLocalInt(oMeldshaper, "nChakra"))+" chakra, if available?"; 
	                SetHeader(sToken); 
	                
	                if (!GetIsChakraBound(oMeldshaper, CHAKRA_TOTEM)) AddChoice("Totem", 1000, oMeldshaper);
	                if (GetHasFeat(FEAT_DOUBLE_CHAKRA_TOTEM, oMeldshaper) && GetIsChakraBound(oMeldshaper, CHAKRA_TOTEM)) AddChoice("Double Chakra Totem", 1001, oMeldshaper);
	                if (GetCanBindChakra(oMeldshaper, GetLocalInt(oMeldshaper, "nChakra"))) AddChoice(ChakraToString(GetLocalInt(oMeldshaper, "nChakra")), TRUE, oMeldshaper);
	                AddChoice(GetStringByStrRef(STRREF_NO), FALSE, oMeldshaper); // "No"	                
                }
                else
                {
	                // Build the confirmation query
	                int nMeld = GetIsChakraUsed(oMeldshaper, GetLocalInt(oMeldshaper, "nChakra"), nClass);
	                string sToken = "You have chosen to bind "+GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nMeld)))+" to the "+ChakraToString(GetLocalInt(oMeldshaper, "nChakra"))+" chakra"+ "\n\n"; 
	                sToken += GetStringByStrRef(StringToInt(Get2DACache("spells", "SpellDesc", nMeld)))+"\n\n";
	                sToken += GetStringByStrRef(STRREF_SELECTED_HEADER2); // "Is this correct?"
	                SetHeader(sToken);
	                
	                // Special code if the astral vambraces are being bound to the arm chakra, yes
	                if (nMeld == MELD_ASTRAL_VAMBRACES && GetIsChakraUsed(oMeldshaper, CHAKRA_ARMS, nClass) == MELD_ASTRAL_VAMBRACES)
	                {
	                	AddChoice("Buff", 1, oMeldshaper);
	                	AddChoice("Celerity", 2, oMeldshaper);
	                	AddChoice("Cleave", 3, oMeldshaper);
	                	AddChoice("Deflection", 4, oMeldshaper);
	                	AddChoice("Improved Bull Rush", 5, oMeldshaper);
	                	AddChoice("Mobility", 6, oMeldshaper);
	                	AddChoice("Power Attack", 7, oMeldshaper);
	                	AddChoice("Resist Acid", 8, oMeldshaper);
	                	AddChoice("Resist Cold", 9, oMeldshaper);
	                	AddChoice("Resist Electrical", 10, oMeldshaper);
	                	AddChoice("Resist Fire", 11, oMeldshaper);
	                	AddChoice("Resist Sonic", 12, oMeldshaper);
	                }
	                else
		                AddChoice(GetStringByStrRef(STRREF_YES), TRUE, oMeldshaper); // "Yes"
		                
	                AddChoice(GetStringByStrRef(STRREF_NO), FALSE, oMeldshaper); // "No"
	            }    
            }
        }

        // Do token setup
        SetupTokens();
    }
    else if(nValue == DYNCONV_EXITED)
    {
        if(DEBUG) DoDebug("moi_bindingcnv: Running exit handler");
        // End of conversation cleanup
        DeleteLocalInt(oMeldshaper, "nMeld");
        DeleteLocalInt(oMeldshaper, "nChakra");
        DeleteLocalInt(oMeldshaper, "FirstMeldDone");
        DeleteLocalInt(oMeldshaper, "SecondMeldDone");
        DeleteLocalInt(oMeldshaper, "ThirdMeldDone");
        DeleteLocalInt(oMeldshaper, "FourthMeldDone");
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
        if(DEBUG) DoDebug("moi_bindingcnv: Handling PC response, stage = " + IntToString(nStage) + "; nChoice = " + IntToString(nChoice) + "; choice text = '" + GetChoiceText(oMeldshaper) +  "'");
        if(nStage == STAGE_SELECT_MELD)
        {
        	// Next Class
        	if (nChoice == -1)
        	{
            	if (nClass == CLASS_TYPE_INCARNATE)
            	{
            		SetLocalInt(oMeldshaper, "FirstMeldDone", TRUE);
            		if (!GetLevelByClass(CLASS_TYPE_SOULBORN, oMeldshaper)) SetLocalInt(oMeldshaper, "SecondMeldDone", TRUE);
            		if (!GetLevelByClass(CLASS_TYPE_TOTEMIST, oMeldshaper)) SetLocalInt(oMeldshaper, "ThirdMeldDone", TRUE); 
            		if (!GetLevelByClass(CLASS_TYPE_SPINEMELD_WARRIOR, oMeldshaper)) SetLocalInt(oMeldshaper, "FourthMeldDone", TRUE);
            	}
            	else if (nClass == CLASS_TYPE_SOULBORN)
            	{
            		SetLocalInt(oMeldshaper, "SecondMeldDone", TRUE);
            		if (!GetLevelByClass(CLASS_TYPE_TOTEMIST, oMeldshaper)) SetLocalInt(oMeldshaper, "ThirdMeldDone", TRUE);
            		if (!GetLevelByClass(CLASS_TYPE_INCARNATE, oMeldshaper)) SetLocalInt(oMeldshaper, "FirstMeldDone", TRUE); 
            		if (!GetLevelByClass(CLASS_TYPE_SPINEMELD_WARRIOR, oMeldshaper)) SetLocalInt(oMeldshaper, "FourthMeldDone", TRUE);
            	}             	
            	else if (nClass == CLASS_TYPE_TOTEMIST)
            	{
            		SetLocalInt(oMeldshaper, "ThirdMeldDone", TRUE);
            		if (!GetLevelByClass(CLASS_TYPE_SOULBORN, oMeldshaper)) SetLocalInt(oMeldshaper, "SecondMeldDone", TRUE);
            		if (!GetLevelByClass(CLASS_TYPE_INCARNATE, oMeldshaper)) SetLocalInt(oMeldshaper, "FirstMeldDone", TRUE);  
            		if (!GetLevelByClass(CLASS_TYPE_SPINEMELD_WARRIOR, oMeldshaper)) SetLocalInt(oMeldshaper, "FourthMeldDone", TRUE);
            	} 
            	else if (nClass == CLASS_TYPE_SPINEMELD_WARRIOR)
            	{
            		SetLocalInt(oMeldshaper, "FourthMeldDone", TRUE);
            		if (!GetLevelByClass(CLASS_TYPE_SOULBORN, oMeldshaper)) SetLocalInt(oMeldshaper, "SecondMeldDone", TRUE);
            		if (!GetLevelByClass(CLASS_TYPE_INCARNATE, oMeldshaper)) SetLocalInt(oMeldshaper, "FirstMeldDone", TRUE);  
            		if (!GetLevelByClass(CLASS_TYPE_TOTEMIST, oMeldshaper)) SetLocalInt(oMeldshaper, "ThirdMeldDone", TRUE);
            	}    
            	ClearCurrentStage(oMeldshaper);
        		nStage = STAGE_SELECT_MELD;
        	}
        	else if (nChoice == -2) // Exit conversation
        	{
        		AllowExit(DYNCONV_EXIT_FORCE_EXIT); 
        	}
           	else
           	{
           		if(DEBUG) DoDebug("moi_bindingcnv: Chakra selected");
           		SetLocalInt(oMeldshaper, "nChakra", nChoice);
           		nStage = STAGE_CONFIRM_SELECTION;
           	}	

            MarkStageNotSetUp(STAGE_SELECT_MELD, oMeldshaper);
        }        
        else if(nStage == STAGE_CONFIRM_SELECTION)
        {     
        	if (nChoice == 1000)
        	{
        		BindMeldToChakra(oMeldshaper, GetIsChakraUsed(oMeldshaper, GetLocalInt(oMeldshaper, "nChakra"), nClass), CHAKRA_TOTEM, nClass);
        		DeleteLocalInt(oMeldshaper, "nChakra");
        	}
        	else if (nChoice == 1001)
        	{
        		BindMeldToChakra(oMeldshaper, GetIsChakraUsed(oMeldshaper, GetLocalInt(oMeldshaper, "nChakra"), nClass), CHAKRA_DOUBLE_TOTEM, nClass);
        		DeleteLocalInt(oMeldshaper, "nChakra");
        	}        	
        	else if (nChoice)
        	{
        		// Special check on the Astral Vambraces arms chakra
        		if (GetIsChakraUsed(oMeldshaper, GetLocalInt(oMeldshaper, "nChakra"), nClass) == MELD_ASTRAL_VAMBRACES && GetLocalInt(oMeldshaper, "nChakra") == CHAKRA_ARMS) SetLocalInt(oMeldshaper, "AstralVambraces", nChoice);
        		BindMeldToChakra(oMeldshaper, GetIsChakraUsed(oMeldshaper, GetLocalInt(oMeldshaper, "nChakra"), nClass), GetLocalInt(oMeldshaper, "nChakra"), nClass);
        		DeleteLocalInt(oMeldshaper, "nChakra");
        	}	        	
        	
        	// We have more to go
            if(GetMaxBindCount(oMeldshaper, nClass) > GetTotalBoundMelds(oMeldshaper))
            {
                nStage = STAGE_SELECT_MELD;
            }
            else
            {
            	if (nClass == CLASS_TYPE_INCARNATE)
            	{
            		SetLocalInt(oMeldshaper, "FirstMeldDone", TRUE);
            		if (!GetLevelByClass(CLASS_TYPE_SOULBORN, oMeldshaper)) SetLocalInt(oMeldshaper, "SecondMeldDone", TRUE);
            		if (!GetLevelByClass(CLASS_TYPE_TOTEMIST, oMeldshaper)) SetLocalInt(oMeldshaper, "ThirdMeldDone", TRUE); 
            		if (!GetLevelByClass(CLASS_TYPE_SPINEMELD_WARRIOR, oMeldshaper)) SetLocalInt(oMeldshaper, "FourthMeldDone", TRUE);
            	}
            	else if (nClass == CLASS_TYPE_SOULBORN)
            	{
            		SetLocalInt(oMeldshaper, "SecondMeldDone", TRUE);
            		if (!GetLevelByClass(CLASS_TYPE_TOTEMIST, oMeldshaper)) SetLocalInt(oMeldshaper, "ThirdMeldDone", TRUE);
            		if (!GetLevelByClass(CLASS_TYPE_INCARNATE, oMeldshaper)) SetLocalInt(oMeldshaper, "FirstMeldDone", TRUE); 
            		if (!GetLevelByClass(CLASS_TYPE_SPINEMELD_WARRIOR, oMeldshaper)) SetLocalInt(oMeldshaper, "FourthMeldDone", TRUE);
            	}             	
            	else if (nClass == CLASS_TYPE_TOTEMIST)
            	{
            		SetLocalInt(oMeldshaper, "ThirdMeldDone", TRUE);
            		if (!GetLevelByClass(CLASS_TYPE_SOULBORN, oMeldshaper)) SetLocalInt(oMeldshaper, "SecondMeldDone", TRUE);
            		if (!GetLevelByClass(CLASS_TYPE_INCARNATE, oMeldshaper)) SetLocalInt(oMeldshaper, "FirstMeldDone", TRUE);  
            		if (!GetLevelByClass(CLASS_TYPE_SPINEMELD_WARRIOR, oMeldshaper)) SetLocalInt(oMeldshaper, "FourthMeldDone", TRUE);
            	} 
            	else if (nClass == CLASS_TYPE_SPINEMELD_WARRIOR)
            	{
            		SetLocalInt(oMeldshaper, "FourthMeldDone", TRUE);
            		if (!GetLevelByClass(CLASS_TYPE_SOULBORN, oMeldshaper)) SetLocalInt(oMeldshaper, "SecondMeldDone", TRUE);
            		if (!GetLevelByClass(CLASS_TYPE_INCARNATE, oMeldshaper)) SetLocalInt(oMeldshaper, "FirstMeldDone", TRUE);  
            		if (!GetLevelByClass(CLASS_TYPE_TOTEMIST, oMeldshaper)) SetLocalInt(oMeldshaper, "ThirdMeldDone", TRUE);
            	}             	
            		
            	if (GetMeldshapingClass(oMeldshaper) > 0)
            		nStage = STAGE_SELECT_MELD; // We've got another class to go
            	else // We've finished everything
            	{           	
	           	 	// And we're all done
           	 		if (GetLevelByClass(CLASS_TYPE_INCARNUM_BLADE, oMeldshaper))
           	 		{
            			DelayCommand(0.5, AssignCommand(oMeldshaper, ClearAllActions(TRUE)));
        				StartDynamicConversation("moi_iblade_bind", oMeldshaper, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oMeldshaper);
        			}	            	
            	
        			DeleteLocalInt(oMeldshaper, "FirstMeldDone");
        			DeleteLocalInt(oMeldshaper, "SecondMeldDone");
        			DeleteLocalInt(oMeldshaper, "ThirdMeldDone");
        			DeleteLocalInt(oMeldshaper, "FourthMeldDone");
            		AllowExit(DYNCONV_EXIT_FORCE_EXIT); 
            	}
            }
            MarkStageNotSetUp(STAGE_CONFIRM_SELECTION, oMeldshaper);        
        }

        if(DEBUG) DoDebug("moi_bindingcnv: New stage: " + IntToString(nStage));

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oMeldshaper);
    }
}
