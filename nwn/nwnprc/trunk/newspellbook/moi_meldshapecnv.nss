//:://////////////////////////////////////////////
//:: Meldshaper Shape Soulmeld choice script
//:: moi_meldshapecnv
//:://////////////////////////////////////////////
/*
    @author Stratovarius - 2019.12.21
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "moi_inc_moifunc"
#include "prc_inc_dragsham"
#include "inc_dynconv"

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_SELECT_CHAKRA       = 0;
const int STAGE_SELECT_MELD         = 1;
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
    string s = GetLocalString(oMeldshaper, "PRC_MeldshapeConvo_List_Head");
    if(s == ""){
        tp += "Empty\n";
    }
    else{
        tp += s + "\n";
        s = GetLocalString(oMeldshaper, "PRC_MeldshapeConvo_List_Next_" + s);
        while(s != ""){
            tp += "=> " + s + "\n";
            s = GetLocalString(oMeldshaper, "PRC_MeldshapeConvo_List_Next_" + s);
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
    if(!GetLocalInt(oMeldshaper, "PRC_MeldshapeConvo_ListInited"))
    {
        SetLocalString(oMeldshaper, "PRC_MeldshapeConvo_List_Head", sChoice);
        SetLocalInt(oMeldshaper, "PRC_MeldshapeConvo_List_" + sChoice, nChoice);

        SetLocalInt(oMeldshaper, "PRC_MeldshapeConvo_ListInited", TRUE);
    }
    else
    {
        // Find the location to instert into
        string sPrev = "", sNext = GetLocalString(oMeldshaper, "PRC_MeldshapeConvo_List_Head");
        while(sNext != "" && StringCompare(sChoice, sNext) >= 0)
        {
            if(DEBUG_LIST) DoDebug("Comparison between '" + sChoice + "' and '" + sNext + "' = " + IntToString(StringCompare(sChoice, sNext)));
            sPrev = sNext;
            sNext = GetLocalString(oMeldshaper, "PRC_MeldshapeConvo_List_Next_" + sNext);
        }

        // Insert the new entry
        // Does it replace the head?
        if(sPrev == "")
        {
            if(DEBUG_LIST) DoDebug("New head");
            SetLocalString(oMeldshaper, "PRC_MeldshapeConvo_List_Head", sChoice);
        }
        else
        {
            if(DEBUG_LIST) DoDebug("Inserting into position between '" + sPrev + "' and '" + sNext + "'");
            SetLocalString(oMeldshaper, "PRC_MeldshapeConvo_List_Next_" + sPrev, sChoice);
        }

        SetLocalString(oMeldshaper, "PRC_MeldshapeConvo_List_Next_" + sChoice, sNext);
        SetLocalInt(oMeldshaper, "PRC_MeldshapeConvo_List_" + sChoice, nChoice);
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
    string sChoice = GetLocalString(oMeldshaper, "PRC_MeldshapeConvo_List_Head");
    int    nChoice = GetLocalInt   (oMeldshaper, "PRC_MeldshapeConvo_List_" + sChoice);

    DeleteLocalString(oMeldshaper, "PRC_MeldshapeConvo_List_Head");
    string sPrev;

    if(DEBUG_LIST) DoDebug("Head is: '" + sChoice + "' - " + IntToString(nChoice));

    while(sChoice != "")
    {
        // Add the choice
        AddChoice(sChoice, nChoice, oMeldshaper);

        // Get next
        sChoice = GetLocalString(oMeldshaper, "PRC_MeldshapeConvo_List_Next_" + (sPrev = sChoice));
        nChoice = GetLocalInt   (oMeldshaper, "PRC_MeldshapeConvo_List_" + sChoice);

        if(DEBUG_LIST) DoDebug("Next is: '" + sChoice + "' - " + IntToString(nChoice) + "; previous = '" + sPrev + "'");

        // Delete the already handled data
        DeleteLocalString(oMeldshaper, "PRC_MeldshapeConvo_List_Next_" + sPrev);
        DeleteLocalInt   (oMeldshaper, "PRC_MeldshapeConvo_List_" + sPrev);
    }

    DeleteLocalInt(oMeldshaper, "PRC_MeldshapeConvo_ListInited");
}

/**
 * Enforces aligned soulmelds restrictions for Incarnate and Soulborn
 *
 * @param oMeldshaper A PC gaining powers at the moment
 */
int SoulmeldAlignmentCheck(object oMeldshaper, int nMeld, int nClass)
{
	int nLaw, nChaos, nGood, nEvil;
	if (GetHasDescriptor(nMeld, DESCRIPTOR_GOOD))    nGood  = TRUE;
	if (GetHasDescriptor(nMeld, DESCRIPTOR_EVIL))    nEvil  = TRUE;
	if (GetHasDescriptor(nMeld, DESCRIPTOR_LAWFUL))  nLaw   = TRUE;
	if (GetHasDescriptor(nMeld, DESCRIPTOR_CHAOTIC)) nChaos = TRUE;
	int nReturn = TRUE;
	
	if (nClass == CLASS_TYPE_SOULBORN)
	{
		// Check the four possible alignments
	   	if (GetAlignmentLawChaos(oMeldshaper) == ALIGNMENT_CHAOTIC && GetAlignmentGoodEvil(oMeldshaper) == ALIGNMENT_EVIL && (nGood || nLaw)) nReturn = FALSE;
		if (GetAlignmentLawChaos(oMeldshaper) == ALIGNMENT_CHAOTIC && GetAlignmentGoodEvil(oMeldshaper) == ALIGNMENT_GOOD && (nEvil || nLaw)) nReturn = FALSE;
		if (GetAlignmentLawChaos(oMeldshaper) == ALIGNMENT_LAWFUL && GetAlignmentGoodEvil(oMeldshaper) == ALIGNMENT_GOOD && (nChaos || nEvil)) nReturn = FALSE;
		if (GetAlignmentLawChaos(oMeldshaper) == ALIGNMENT_LAWFUL && GetAlignmentGoodEvil(oMeldshaper) == ALIGNMENT_EVIL && (nGood || nChaos)) nReturn = FALSE;
	}
	if (nClass == CLASS_TYPE_INCARNATE)
	{	
		// If any alignment doesn't match, it's a fail
   		if (GetAlignmentLawChaos(oMeldshaper) == ALIGNMENT_CHAOTIC && (nGood || nLaw || nEvil)) nReturn = FALSE;
		if (GetAlignmentLawChaos(oMeldshaper) == ALIGNMENT_LAWFUL && (nGood || nChaos || nEvil)) nReturn = FALSE;
		if (GetAlignmentGoodEvil(oMeldshaper) == ALIGNMENT_GOOD && (nChaos || nLaw || nEvil)) nReturn = FALSE;
		if (GetAlignmentGoodEvil(oMeldshaper) == ALIGNMENT_EVIL && (nChaos || nLaw || nGood)) nReturn = FALSE;
   	}
   	
   	// The feat allows non-evil (but not good) to use these melds
   	if(GetAlignmentGoodEvil(oMeldshaper) != ALIGNMENT_GOOD && GetHasFeat(FEAT_NECROCARNUM_ACOLYTE) && GetIsNecrocarnumMeld(nMeld)) nReturn = TRUE;
   	
   	return nReturn;	
}

/**
 * Enforces Dragonblooded soulmelds restrictions
 *
 * @param oMeldshaper A PC gaining powers at the moment
 */
int DragonbloodedCheck(object oMeldshaper, int nMeld)
{
	if (nMeld == MELD_CLAW_OF_THE_WYRM ||
	    nMeld == MELD_DRAGON_MANTLE    ||
	    nMeld == MELD_DRAGON_TAIL      ||
	    nMeld == MELD_DRAGONFIRE_MASK  ||
	    nMeld == MELD_ELDER_SPIRIT    )
	{
		// If it's a dragonblooded meld and the meldshaper isn't, return false
		if (!GetIsDragonblooded(oMeldshaper))
			return FALSE;
	}
	return TRUE;
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
        if(DEBUG) DoDebug("moi_meldshapecnv: Running setup stage for stage " + IntToString(nStage));
        // Check if this stage is marked as already set up
        // This stops list duplication when scrolling
        if(!GetIsStageSetUp(nStage, oMeldshaper))
        {
            if(DEBUG) DoDebug("moi_meldshapecnv: Stage was not set up already");
			if(nStage == STAGE_SELECT_CHAKRA)
            {
                if(DEBUG) DoDebug("moi_meldshapecnv: Building chakra selection");
                
                int nMeldCount = GetMaxShapeSoulmeldCount(oMeldshaper, nClass);
                
                SetHeader("You are shaping soulmelds as a "+GetStringByStrRef(StringToInt(Get2DACache("classes", "Name", nClass)))+".\n\n"+"Choose the chakra you wish to fill with a soulmeld. You can only shape one soulmeld that occupies this chakra.");
               
				if (!GetIsChakraUsed(oMeldshaper, CHAKRA_CROWN    , nClass)) AddChoice("Crown",     CHAKRA_CROWN    , oMeldshaper);
				if (!GetIsChakraUsed(oMeldshaper, CHAKRA_FEET     , nClass)) AddChoice("Feet",      CHAKRA_FEET     , oMeldshaper);
				if (!GetIsChakraUsed(oMeldshaper, CHAKRA_HANDS    , nClass)) AddChoice("Hands",     CHAKRA_HANDS    , oMeldshaper);
				if (!GetIsChakraUsed(oMeldshaper, CHAKRA_ARMS     , nClass)) AddChoice("Arms",      CHAKRA_ARMS     , oMeldshaper);
				if (!GetIsChakraUsed(oMeldshaper, CHAKRA_BROW     , nClass)) AddChoice("Brow",      CHAKRA_BROW     , oMeldshaper);
				if (!GetIsChakraUsed(oMeldshaper, CHAKRA_SHOULDERS, nClass)) AddChoice("Shoulders", CHAKRA_SHOULDERS, oMeldshaper);
				if (!GetIsChakraUsed(oMeldshaper, CHAKRA_THROAT   , nClass)) AddChoice("Throat",    CHAKRA_THROAT   , oMeldshaper);
				if (!GetIsChakraUsed(oMeldshaper, CHAKRA_WAIST    , nClass)) AddChoice("Waist",     CHAKRA_WAIST    , oMeldshaper);
				if (!GetIsChakraUsed(oMeldshaper, CHAKRA_HEART    , nClass)) AddChoice("Heart",     CHAKRA_HEART    , oMeldshaper);
				if (!GetIsChakraUsed(oMeldshaper, CHAKRA_SOUL     , nClass)) AddChoice("Soul",      CHAKRA_SOUL     , oMeldshaper);
				
				// Only show the double chakra if the basic one is already used up
				if (GetIsChakraUsed(oMeldshaper, CHAKRA_CROWN    , nClass) && !GetIsChakraUsed(oMeldshaper, CHAKRA_DOUBLE_CROWN    , nClass) && GetHasFeat(FEAT_DOUBLE_CHAKRA_CROWN    , oMeldshaper)) AddChoice("Double Crown",     CHAKRA_DOUBLE_CROWN    , oMeldshaper);
				if (GetIsChakraUsed(oMeldshaper, CHAKRA_FEET     , nClass) && !GetIsChakraUsed(oMeldshaper, CHAKRA_DOUBLE_FEET     , nClass) && GetHasFeat(FEAT_DOUBLE_CHAKRA_FEET     , oMeldshaper)) AddChoice("Double Feet",      CHAKRA_DOUBLE_FEET     , oMeldshaper);
				if (GetIsChakraUsed(oMeldshaper, CHAKRA_HANDS    , nClass) && !GetIsChakraUsed(oMeldshaper, CHAKRA_DOUBLE_HANDS    , nClass) && GetHasFeat(FEAT_DOUBLE_CHAKRA_HANDS    , oMeldshaper)) AddChoice("Double Hands",     CHAKRA_DOUBLE_HANDS    , oMeldshaper);
				if (GetIsChakraUsed(oMeldshaper, CHAKRA_ARMS     , nClass) && !GetIsChakraUsed(oMeldshaper, CHAKRA_DOUBLE_ARMS     , nClass) && GetHasFeat(FEAT_DOUBLE_CHAKRA_ARMS     , oMeldshaper)) AddChoice("Double Arms",      CHAKRA_DOUBLE_ARMS     , oMeldshaper);
				if (GetIsChakraUsed(oMeldshaper, CHAKRA_BROW     , nClass) && !GetIsChakraUsed(oMeldshaper, CHAKRA_DOUBLE_BROW     , nClass) && GetHasFeat(FEAT_DOUBLE_CHAKRA_BROW     , oMeldshaper)) AddChoice("Double Brow",      CHAKRA_DOUBLE_BROW     , oMeldshaper);
				if (GetIsChakraUsed(oMeldshaper, CHAKRA_SHOULDERS, nClass) && !GetIsChakraUsed(oMeldshaper, CHAKRA_DOUBLE_SHOULDERS, nClass) && GetHasFeat(FEAT_DOUBLE_CHAKRA_SHOULDERS, oMeldshaper)) AddChoice("Double Shoulders", CHAKRA_DOUBLE_SHOULDERS, oMeldshaper);
				if (GetIsChakraUsed(oMeldshaper, CHAKRA_THROAT   , nClass) && !GetIsChakraUsed(oMeldshaper, CHAKRA_DOUBLE_THROAT   , nClass) && GetHasFeat(FEAT_DOUBLE_CHAKRA_THROAT   , oMeldshaper)) AddChoice("Double Throat",    CHAKRA_DOUBLE_THROAT   , oMeldshaper);
				if (GetIsChakraUsed(oMeldshaper, CHAKRA_WAIST    , nClass) && !GetIsChakraUsed(oMeldshaper, CHAKRA_DOUBLE_WAIST    , nClass) && GetHasFeat(FEAT_DOUBLE_CHAKRA_WAIST    , oMeldshaper)) AddChoice("Double Waist",     CHAKRA_DOUBLE_WAIST    , oMeldshaper);
				if (GetIsChakraUsed(oMeldshaper, CHAKRA_HEART    , nClass) && !GetIsChakraUsed(oMeldshaper, CHAKRA_DOUBLE_HEART    , nClass) && GetHasFeat(FEAT_DOUBLE_CHAKRA_HEART    , oMeldshaper)) AddChoice("Double Heart",     CHAKRA_DOUBLE_HEART    , oMeldshaper);
				if (GetIsChakraUsed(oMeldshaper, CHAKRA_SOUL     , nClass) && !GetIsChakraUsed(oMeldshaper, CHAKRA_DOUBLE_SOUL     , nClass) && GetHasFeat(FEAT_DOUBLE_CHAKRA_SOUL     , oMeldshaper)) AddChoice("Double Soul",      CHAKRA_DOUBLE_SOUL     , oMeldshaper);				
												      
                // Set the next, previous and wait tokens to default values
                SetDefaultTokens();
                // Set the convo quit text to "Abort"
                SetCustomToken(DYNCONV_TOKEN_EXIT, GetStringByStrRef(DYNCONV_STRREF_ABORT_CONVO));
            }            
            // meld selection stage
            else if(nStage == STAGE_SELECT_MELD)
            {
                if(DEBUG) DoDebug("moi_meldshapecnv: Building level selection");
                
                int nMeldCount = GetMaxShapeSoulmeldCount(oMeldshaper, nClass);
                
                SetHeader("Choose the soulmeld to shape. You can shape "+IntToString(nMeldCount)+" soulmelds in total. You have "+IntToString(nMeldCount - GetTotalShapedMelds(oMeldshaper, nClass))+" remaining");
                int nChakra = DoubleChakraToChakra(GetLocalInt(oMeldshaper, "nChakra"));
               
                string sSpell, sChakra, sClass;
                int i;
                for(i = 0; i < 100 ; i++)
                {
                    sSpell = Get2DACache(sMeldFile, "SpellID", i);
                    sChakra = Get2DACache(sMeldFile, ChakraToString(nChakra), i);
                    sClass = GetStringByStrRef(StringToInt(Get2DACache("classes", "Name", nClass)));
                    int nMeld = StringToInt(sSpell);
                    
                    if (nClass == CLASS_TYPE_SPINEMELD_WARRIOR) sClass = "Spinemeld"; //Done this way because the class name and column title can't match otherwise
                    
                    int nTest = StringToInt(Get2DACache(sMeldFile, sClass, i));
                    
                    //if (DEBUG) DoDebug("sSpell: "+sSpell+" sChakra: "+sChakra+" sClass: "+sClass+" nTest: "+IntToString(nTest));
                    if (DEBUG) DoDebug("sChakra: "+sChakra+" nChakra: "+IntToString(nChakra));
                    
                    // Non-blank row, not shaped already, it can be attached to the chosen Chakra, and it's for the right class, and it doesn't contradict alignment
                    //if(nTest && sSpell != "" && !GetIsMeldShaped(oMeldshaper, nMeld, nClass) && StringToInt(sChakra) == nChakra && SoulmeldAlignmentCheck(oMeldshaper, nMeld, nClass) && DragonbloodedCheck(oMeldshaper, nMeld)) 
					int nIsTotemBound = (GetIsChakraUsed(oMeldshaper, CHAKRA_TOTEM, CLASS_TYPE_TOTEMIST) == nMeld);  
					int nCanDoubleBind = (GetLevelByClass(CLASS_TYPE_TOTEMIST, oMeldshaper) >= 11);  
					if(nTest && sSpell != "" &&   
					   (!GetIsMeldShaped(oMeldshaper, nMeld, nClass) || (nIsTotemBound && nCanDoubleBind)) &&   
					   StringToInt(sChakra) == nChakra &&   
					   SoulmeldAlignmentCheck(oMeldshaper, nMeld, nClass) &&   
					   DragonbloodedCheck(oMeldshaper, nMeld))                    
					{
						AddChoice(GetStringByStrRef(StringToInt(Get2DACache(sMeldFile, "Name", i))), nMeld, oMeldshaper);  
                    }
                }
                AddChoice("Back to Chakra Selection", CHOICE_BACK_TO_LSELECT, oMeldshaper);

                // Set the next, previous and wait tokens to default values
                SetDefaultTokens();
                // Set the convo quit text to "Abort"
                SetCustomToken(DYNCONV_TOKEN_EXIT, GetStringByStrRef(DYNCONV_STRREF_ABORT_CONVO));
            }
            // Selection confirmation stage
            else if(nStage == STAGE_CONFIRM_SELECTION)
            {
                if(DEBUG) DoDebug("moi_meldshapecnv: Building selection confirmation");
                // Build the confirmation query
                string sToken = GetStringByStrRef(STRREF_SELECTED_HEADER1) + "\n\n"; // "You have selected:"
                int nSpellId = GetLocalInt(oMeldshaper, "nMeld");
                //sToken += GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSpellId)))+"\n";
                sToken += GetStringByStrRef(StringToInt(Get2DACache("spells", "SpellDesc", nSpellId)))+"\n\n";
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
        if(DEBUG) DoDebug("moi_meldshapecnv: Running exit handler");
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
        if(DEBUG) DoDebug("moi_meldshapecnv: Handling PC response, stage = " + IntToString(nStage) + "; nChoice = " + IntToString(nChoice) + "; choice text = '" + GetChoiceText(oMeldshaper) +  "'");
        
        if(nStage == STAGE_SELECT_CHAKRA)
        {
           	if(DEBUG) DoDebug("moi_meldshapecnv: Chakra selected");
           	SetLocalInt(oMeldshaper, "nChakra", nChoice);
           	nStage = STAGE_SELECT_MELD;

            MarkStageNotSetUp(STAGE_SELECT_CHAKRA, oMeldshaper);
        }        
        else if(nStage == STAGE_SELECT_MELD)
        {
            if(nChoice == CHOICE_BACK_TO_LSELECT)
            {
                if(DEBUG) DoDebug("moi_meldshapecnv: Returning to Chakra selection");
                nStage = STAGE_SELECT_CHAKRA;
                DeleteLocalInt(oMeldshaper, "nChakra");
            }        
           	else
           	{	
           		if(DEBUG) DoDebug("moi_meldshapecnv: Meld selected");
           		SetLocalInt(oMeldshaper, "nMeld", nChoice);
           		nStage = STAGE_CONFIRM_SELECTION;
           	}	

            MarkStageNotSetUp(STAGE_SELECT_MELD, oMeldshaper);
        }
        else if(nStage == STAGE_CONFIRM_SELECTION)
        {     
        	if (nChoice)
        	{
        		ShapeSoulmeld(oMeldshaper, GetLocalInt(oMeldshaper, "nMeld"));
        		MarkMeldShaped(oMeldshaper, GetLocalInt(oMeldshaper, "nMeld"), nClass);
        		SetChakraUsed(oMeldshaper, GetLocalInt(oMeldshaper, "nMeld"), GetLocalInt(oMeldshaper, "nChakra"), nClass);
        		DeleteLocalInt(oMeldshaper, "nMeld");
        		DeleteLocalInt(oMeldshaper, "nChakra");
        	}		
        	
        	// We have more to go
            if(GetMaxShapeSoulmeldCount(oMeldshaper, nClass) > GetTotalShapedMelds(oMeldshaper, nClass))
            {
                nStage = STAGE_SELECT_CHAKRA;
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
            		nStage = STAGE_SELECT_CHAKRA; // We've got another class to go
            	else // We've finished everything
            	{
	           	 	// And we're all done
           	 		if (GetMaxBindCount(oMeldshaper, CLASS_TYPE_INCARNATE) || GetMaxBindCount(oMeldshaper, CLASS_TYPE_SOULBORN) || GetMaxBindCount(oMeldshaper, CLASS_TYPE_TOTEMIST) || GetMaxBindCount(oMeldshaper, CLASS_TYPE_SPINEMELD_WARRIOR))
           	 		{
            			DelayCommand(0.5, AssignCommand(oMeldshaper, ClearAllActions(TRUE)));
        				DelayCommand(0.55, StartDynamicConversation("moi_bindingcnv", oMeldshaper, DYNCONV_EXIT_ALLOWED_SHOW_CHOICE, FALSE, TRUE, oMeldshaper));           	 	
        			}	       			
        			DeleteLocalInt(oMeldshaper, "FirstMeldDone");
        			DeleteLocalInt(oMeldshaper, "SecondMeldDone");
        			DeleteLocalInt(oMeldshaper, "ThirdMeldDone");        			
            		AllowExit(DYNCONV_EXIT_FORCE_EXIT); 
            	}	
            }
            MarkStageNotSetUp(STAGE_CONFIRM_SELECTION, oMeldshaper);        
        }

        if(DEBUG) DoDebug("moi_meldshapecnv: New stage: " + IntToString(nStage));

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oMeldshaper);
    }
}
