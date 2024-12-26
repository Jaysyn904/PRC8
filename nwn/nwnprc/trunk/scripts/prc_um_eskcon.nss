//:://////////////////////////////////////////////
//:: Ultimate Magus Spell Knowledge choice script
//:: prc_um_eskcon
//:://////////////////////////////////////////////
/*
    @author Stratovarius - 2019.12.29
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "inc_dynconv"

//////////////////////////////////////////////////
/* Constant definitions                         */
//////////////////////////////////////////////////

const int STAGE_SELECT_SPELL            = 0;
const int STAGE_CONFIRM_SELECTION_SPELL = 1;
const int STAGE_SELECT_SPELL_LEVEL      = 2;

const int CHOICE_BACK_TO_LSELECT    = -1;
const int STRREF_SELECTED_HEADER1   = 16824209; // "You have selected:"
const int STRREF_SELECTED_HEADER2   = 16824210; // "Is this correct?"
const int LEVEL_STRREF_START        = 16824809;
const int STRREF_YES                = 4752;     // "Yes"
const int STRREF_NO                 = 4753;     // "No"

const int SORT       = TRUE; // If the sorting takes too much CPU, set to FALSE
const int DEBUG_LIST = FALSE;

//////////////////////////////////////////////////
/* Function defintions                          */
//////////////////////////////////////////////////

void PrintList(object oMagus)
{
    string tp = "Printing list:\n";
    string s = GetLocalString(oMagus, "PRC_EssentiaConvo_List_Head");
    if(s == ""){
        tp += "Empty\n";
    }
    else{
        tp += s + "\n";
        s = GetLocalString(oMagus, "PRC_EssentiaConvo_List_Next_" + s);
        while(s != ""){
            tp += "=> " + s + "\n";
            s = GetLocalString(oMagus, "PRC_EssentiaConvo_List_Next_" + s);
        }
    }

    DoDebug(tp);
}

/**
 * Creates a linked list of entries that is sorted into alphabetical order
 * as it is built.
 * Assumption: mystery names are unique.
 *
 * @param oMagus     The storage object aka whomever is gaining powers in this conversation
 * @param sChoice The choice string
 * @param nChoice The choice value
 */
void AddToTempList(object oMagus, string sChoice, int nChoice)
{
    if(DEBUG_LIST) DoDebug("\nAdding to temp list: '" + sChoice + "' - " + IntToString(nChoice));
    if(DEBUG_LIST) PrintList(oMagus);
    // If there is nothing yet
    if(!GetLocalInt(oMagus, "PRC_EssentiaConvo_ListInited"))
    {
        SetLocalString(oMagus, "PRC_EssentiaConvo_List_Head", sChoice);
        SetLocalInt(oMagus, "PRC_EssentiaConvo_List_" + sChoice, nChoice);

        SetLocalInt(oMagus, "PRC_EssentiaConvo_ListInited", TRUE);
    }
    else
    {
        // Find the location to instert into
        string sPrev = "", sNext = GetLocalString(oMagus, "PRC_EssentiaConvo_List_Head");
        while(sNext != "" && StringCompare(sChoice, sNext) >= 0)
        {
            if(DEBUG_LIST) DoDebug("Comparison between '" + sChoice + "' and '" + sNext + "' = " + IntToString(StringCompare(sChoice, sNext)));
            sPrev = sNext;
            sNext = GetLocalString(oMagus, "PRC_EssentiaConvo_List_Next_" + sNext);
        }

        // Insert the new entry
        // Does it replace the head?
        if(sPrev == "")
        {
            if(DEBUG_LIST) DoDebug("New head");
            SetLocalString(oMagus, "PRC_EssentiaConvo_List_Head", sChoice);
        }
        else
        {
            if(DEBUG_LIST) DoDebug("Inserting into position between '" + sPrev + "' and '" + sNext + "'");
            SetLocalString(oMagus, "PRC_EssentiaConvo_List_Next_" + sPrev, sChoice);
        }

        SetLocalString(oMagus, "PRC_EssentiaConvo_List_Next_" + sChoice, sNext);
        SetLocalInt(oMagus, "PRC_EssentiaConvo_List_" + sChoice, nChoice);
    }
}

/**
 * Reads the linked list built with AddToTempList() to AddChoice() and
 * deletes it.
 *
 * @param oMagus A PC gaining powers at the moment
 */
void TransferTempList(object oMagus)
{
    string sChoice = GetLocalString(oMagus, "PRC_EssentiaConvo_List_Head");
    int    nChoice = GetLocalInt   (oMagus, "PRC_EssentiaConvo_List_" + sChoice);

    DeleteLocalString(oMagus, "PRC_EssentiaConvo_List_Head");
    string sPrev;

    if(DEBUG_LIST) DoDebug("Head is: '" + sChoice + "' - " + IntToString(nChoice));

    while(sChoice != "")
    {
        // Add the choice
        AddChoice(sChoice, nChoice, oMagus);

        // Get next
        sChoice = GetLocalString(oMagus, "PRC_EssentiaConvo_List_Next_" + (sPrev = sChoice));
        nChoice = GetLocalInt   (oMagus, "PRC_EssentiaConvo_List_" + sChoice);

        if(DEBUG_LIST) DoDebug("Next is: '" + sChoice + "' - " + IntToString(nChoice) + "; previous = '" + sPrev + "'");

        // Delete the already handled data
        DeleteLocalString(oMagus, "PRC_EssentiaConvo_List_Next_" + sPrev);
        DeleteLocalInt   (oMagus, "PRC_EssentiaConvo_List_" + sPrev);
    }

    DeleteLocalInt(oMagus, "PRC_EssentiaConvo_ListInited");
}

void LearnSpecificSpell(int nClass, int nSpellLevel, int nSpellbookID, object oPC)
{
  // get location of persistant storage on the hide
  string sSpellbook = GetSpellsKnown_Array(nClass, nSpellLevel);
  //object oToken = GetHideToken(oPC);

  // Create spells known persistant array  if it is missing
  int nSize = persistant_array_get_size(oPC, sSpellbook);
  if (nSize < 0)
  {
    persistant_array_create(oPC, sSpellbook);
    nSize = 0;
  }

  // Mark the spell as known (e.g. add it to the end of oPCs spellbook)
  persistant_array_set_int(oPC, sSpellbook, nSize, nSpellbookID);

  // increment the spells known value in the cache
  string sCache = "SKCCCache" + IntToString(nSpellLevel);
  int nKnown = GetLocalInt(oPC, sCache);
  if (nKnown) SetLocalInt(oPC, sCache, ++nKnown);

  if(GetSpellbookTypeForClass(nClass) == SPELLBOOK_TYPE_SPONTANEOUS)
  {
    // get the associated feat and IPfeat IDs
    string sFile = GetNSBDefinitionFileName(nClass);
    int nIPFeatID = StringToInt(Get2DACache(sFile, "IPFeatID", nSpellbookID));
    int nFeatID   = StringToInt(Get2DACache(sFile, "FeatID", nSpellbookID));

    // Add spell use feats (this also places the bonus feat on the hide, so we can check whether oPC knows this spell by testing for the featID on the hide)
    AddSpellUse(oPC, nSpellbookID, nClass, sFile, "NewSpellbookMem_" + IntToString(nClass), SPELLBOOK_TYPE_SPONTANEOUS, GetPCSkin(oPC), nFeatID, nIPFeatID);
  }
}

void main()
{
    object oMagus = GetPCSpeaker();
    int nValue = GetLocalInt(oMagus, DYNCONV_VARIABLE);
    int nStage = GetStage(oMagus);
	int nLevel = GetLevelByClass(CLASS_TYPE_ULTIMATE_MAGUS, oMagus);

    // Check which of the conversation scripts called the scripts
    if(nValue == 0) // All of them set the DynConv_Var to non-zero value, so something is wrong -> abort
        return;

    if(nValue == DYNCONV_SETUP_STAGE)
    {
        if(DEBUG) DoDebug("prc_um_eskcon: Running setup stage for stage " + IntToString(nStage));
        // Check if this stage is marked as already set up
        // This stops list duplication when scrolling
        if(!GetIsStageSetUp(nStage, oMagus))
        {
            if(DEBUG) DoDebug("prc_um_eskcon: Stage was not set up already");
			if(nStage == STAGE_SELECT_SPELL_LEVEL)
            {
                if(DEBUG) DoDebug("prc_um_eskcon: Building spell level selection");
                SetHeader("Choose the level of spell to add to your spontaneous spells known.");

                // Set the tokens. 
                int nType = GetPrimaryArcaneClass(oMagus);   
                int nMax = GetMaxSpellLevelForCasterLevel(nType, GetLevelByTypeArcane(oMagus));
                int nCap = 1; // 2nd level spells learned is capped at 1st level
                
				if (nLevel >= 10) nCap = 5;
				else if (nLevel >= 8) nCap = 4;
				else if (nLevel >= 6) nCap = 3;
				else if (nLevel >= 4) nCap = 2;
				
				// Max spell level to learn
				if (nCap > nMax) nMax = nCap;
                
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
			else if(nStage == STAGE_SELECT_SPELL)
            {
                if(DEBUG) DoDebug("prc_um_eskcon: Building spell selection");

                SetHeader("Choose the spell you wish to learn. It will be added to your Sorcerer's spells known.");
               
            	int nType = GetPrimaryArcaneClass(oMagus);   
                if (nType != CLASS_TYPE_INVALID)
                {
                	//int nMax = GetMaxSpellLevelForCasterLevel(nType, GetLevelByTypeArcane(oMagus));
                	string sPowerFile = GetFileForClass(nType);
                	if (nType == CLASS_TYPE_WIZARD) sPowerFile = "cls_spell_sorc";
                	int nLevelToBrowse = GetLocalInt(oMagus, "UltimateMagusLevel");
                	int i, nSpellLevel;
                	string sFeatID;
                	for(i = 0; i < 550 ; i++)
                	{
                		nSpellLevel = StringToInt(Get2DACache(sPowerFile, "Level", i));
                    	if(nSpellLevel < nLevelToBrowse){
                    	    continue;
                    	} 
                    	//FloatingTextStringOnCreature(IntToString(nSpellLevel)+" "+IntToString(i), oMagus);
	               	    //Due to the way the 2das are structured, we know that once
                	    //the level of a read evocation is greater than the maximum castable
                	    //it'll never be lower again. Therefore, we can skip reading the
                	    //evocations that wouldn't be shown anyway.
                	    if(nSpellLevel > nLevelToBrowse){
                	        break;
                	    }
                	    //sFeatID = Get2DACache(sPowerFile, "FeatID", i);
                		int nSpellId = StringToInt(Get2DACache(sPowerFile, "RealSpellID", i));
                	    
                	    if(!PRCGetIsRealSpellKnownByClass(nSpellId, CLASS_TYPE_SORCERER, oMagus) && PRCGetHasSpell(nSpellId, oMagus)) // Must know the spell, but not know it as a sorcerer
                	    {
                	    	// Need to use the row number as choice for the NSB system
							AddChoice(GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSpellId))), i, oMagus);  
                	    }
                	}                	
                }              

                // Set the next, previous and wait tokens to default values
                SetDefaultTokens();
                // Set the convo quit text to "Abort"
                SetCustomToken(DYNCONV_TOKEN_EXIT, GetStringByStrRef(DYNCONV_STRREF_ABORT_CONVO));
            }             
            else if(nStage == STAGE_CONFIRM_SELECTION_SPELL)
            {
                if(DEBUG) DoDebug("prc_um_eskcon: Building selection confirmation");
                // Build the confirmation query
                int nSpell = GetLocalInt(oMagus, "nSpell");
                string sToken = "You have chosen to learn "+GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSpell)))+"."+ "\n\n"; 
                sToken += GetStringByStrRef(STRREF_SELECTED_HEADER2); // "Is this correct?"
                SetHeader(sToken);

                AddChoice(GetStringByStrRef(STRREF_YES), TRUE, oMagus); // "Yes"
                AddChoice(GetStringByStrRef(STRREF_NO), FALSE, oMagus); // "No"
            }            
        }

        // Do token setup
        SetupTokens();
    }
    else if(nValue == DYNCONV_EXITED)
    {
        if(DEBUG) DoDebug("prc_um_eskcon: Running exit handler");
        // End of conversation cleanup
        DeleteLocalInt(oMagus, "nSpell");
        DeleteLocalInt(oMagus, "UltimateMagusLevel");
    }
    else if(nValue == DYNCONV_ABORTED)
    {
        // End of conversation cleanup
        DeleteLocalInt(oMagus, "nSpell");
        DeleteLocalInt(oMagus, "UltimateMagusLevel");
    }
    // Handle PC response
    else
    {
        int nChoice = GetChoice(oMagus);
        if(DEBUG) DoDebug("prc_um_eskcon: Handling PC response, stage = " + IntToString(nStage) + "; nChoice = " + IntToString(nChoice) + "; choice text = '" + GetChoiceText(oMagus) +  "'");
        if(nStage == STAGE_SELECT_SPELL_LEVEL)
        {
           	if(DEBUG) DoDebug("prc_um_eskcon: spell level selected");
           	SetLocalInt(oMagus, "UltimateMagusLevel", nChoice);
           	nStage = STAGE_SELECT_SPELL;

            MarkStageNotSetUp(STAGE_SELECT_SPELL_LEVEL, oMagus);
        }        
        else if(nStage == STAGE_SELECT_SPELL)
        {
           	if(DEBUG) DoDebug("prc_um_eskcon: Spell selected");
           	SetLocalInt(oMagus, "nSpell", nChoice);
           	nStage = STAGE_CONFIRM_SELECTION_SPELL;

            MarkStageNotSetUp(STAGE_SELECT_SPELL, oMagus);
        }         
        else if(nStage == STAGE_CONFIRM_SELECTION_SPELL)
        {     
        	if (nChoice) //Put add spells known here
        	{
        		LearnSpecificSpell(CLASS_TYPE_SORCERER, GetLocalInt(oMagus, "UltimateMagusLevel"), GetLocalInt(oMagus, "nSpell"), oMagus);
        		DeleteLocalInt(oMagus, "nSpell");
        		DeleteLocalInt(oMagus, "UltimateMagusLevel");
            	AllowExit(DYNCONV_EXIT_FORCE_EXIT); 
            }
            MarkStageNotSetUp(STAGE_CONFIRM_SELECTION_SPELL, oMagus); 	       
        }        

        if(DEBUG) DoDebug("prc_um_eskcon: New stage: " + IntToString(nStage));

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oMagus);
    }
}
