//:://////////////////////////////////////////////
//:: Meldshaper Invest Essentia choice script
//:: moi_essentiacnv
//:://////////////////////////////////////////////
/*
    @author Stratovarius - 2019.12.29
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "moi_inc_moifunc"
#include "psi_inc_core"
#include "inc_dynconv"

//////////////////////////////////////////////////
/* Constant definitions                         */
//////////////////////////////////////////////////

const int STAGE_SELECT_TYPE             = 0;
const int STAGE_SELECT_MELD             = 1;
const int STAGE_SELECT_ESSENTIA         = 2;
const int STAGE_CONFIRM_SELECTION       = 3;
const int STAGE_SELECT_FEAT             = 4;
const int STAGE_SELECT_CLASS            = 5;
const int STAGE_SELECT_ESSENTIA_FEAT    = 6;
const int STAGE_CONFIRM_SELECTION_FEAT  = 7;
const int STAGE_SELECT_ESSENTIA_CLASS   = 8;
const int STAGE_CONFIRM_SELECTION_CLASS = 9;
const int STAGE_SELECT_SPELL            = 10;
const int STAGE_SELECT_ESSENTIA_SPELL   = 11;
const int STAGE_CONFIRM_SELECTION_SPELL = 12;
const int STAGE_SELECT_SPELL_LEVEL      = 13;

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

void PrintList(object oMeldshaper)
{
    string tp = "Printing list:\n";
    string s = GetLocalString(oMeldshaper, "PRC_EssentiaConvo_List_Head");
    if(s == ""){
        tp += "Empty\n";
    }
    else{
        tp += s + "\n";
        s = GetLocalString(oMeldshaper, "PRC_EssentiaConvo_List_Next_" + s);
        while(s != ""){
            tp += "=> " + s + "\n";
            s = GetLocalString(oMeldshaper, "PRC_EssentiaConvo_List_Next_" + s);
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
    if(!GetLocalInt(oMeldshaper, "PRC_EssentiaConvo_ListInited"))
    {
        SetLocalString(oMeldshaper, "PRC_EssentiaConvo_List_Head", sChoice);
        SetLocalInt(oMeldshaper, "PRC_EssentiaConvo_List_" + sChoice, nChoice);

        SetLocalInt(oMeldshaper, "PRC_EssentiaConvo_ListInited", TRUE);
    }
    else
    {
        // Find the location to instert into
        string sPrev = "", sNext = GetLocalString(oMeldshaper, "PRC_EssentiaConvo_List_Head");
        while(sNext != "" && StringCompare(sChoice, sNext) >= 0)
        {
            if(DEBUG_LIST) DoDebug("Comparison between '" + sChoice + "' and '" + sNext + "' = " + IntToString(StringCompare(sChoice, sNext)));
            sPrev = sNext;
            sNext = GetLocalString(oMeldshaper, "PRC_EssentiaConvo_List_Next_" + sNext);
        }

        // Insert the new entry
        // Does it replace the head?
        if(sPrev == "")
        {
            if(DEBUG_LIST) DoDebug("New head");
            SetLocalString(oMeldshaper, "PRC_EssentiaConvo_List_Head", sChoice);
        }
        else
        {
            if(DEBUG_LIST) DoDebug("Inserting into position between '" + sPrev + "' and '" + sNext + "'");
            SetLocalString(oMeldshaper, "PRC_EssentiaConvo_List_Next_" + sPrev, sChoice);
        }

        SetLocalString(oMeldshaper, "PRC_EssentiaConvo_List_Next_" + sChoice, sNext);
        SetLocalInt(oMeldshaper, "PRC_EssentiaConvo_List_" + sChoice, nChoice);
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
    string sChoice = GetLocalString(oMeldshaper, "PRC_EssentiaConvo_List_Head");
    int    nChoice = GetLocalInt   (oMeldshaper, "PRC_EssentiaConvo_List_" + sChoice);

    DeleteLocalString(oMeldshaper, "PRC_EssentiaConvo_List_Head");
    string sPrev;

    if(DEBUG_LIST) DoDebug("Head is: '" + sChoice + "' - " + IntToString(nChoice));

    while(sChoice != "")
    {
        // Add the choice
        AddChoice(sChoice, nChoice, oMeldshaper);

        // Get next
        sChoice = GetLocalString(oMeldshaper, "PRC_EssentiaConvo_List_Next_" + (sPrev = sChoice));
        nChoice = GetLocalInt   (oMeldshaper, "PRC_EssentiaConvo_List_" + sChoice);

        if(DEBUG_LIST) DoDebug("Next is: '" + sChoice + "' - " + IntToString(nChoice) + "; previous = '" + sPrev + "'");

        // Delete the already handled data
        DeleteLocalString(oMeldshaper, "PRC_EssentiaConvo_List_Next_" + sPrev);
        DeleteLocalInt   (oMeldshaper, "PRC_EssentiaConvo_List_" + sPrev);
    }

    DeleteLocalInt(oMeldshaper, "PRC_EssentiaConvo_ListInited");
}

void main()
{
    object oMeldshaper = GetPCSpeaker();
    int nValue = GetLocalInt(oMeldshaper, DYNCONV_VARIABLE);
    int nStage = GetStage(oMeldshaper);
	int nClass = GetMeldshapingClass(oMeldshaper);
    string sMeldFile = GetMeldFile(); 
    if (GetLocalInt(oMeldshaper, "nInvestClass") > 70) nClass = GetLocalInt(oMeldshaper, "nInvestClass");

    // Check which of the conversation scripts called the scripts
    if(nValue == 0) // All of them set the DynConv_Var to non-zero value, so something is wrong -> abort
        return;

    if(nValue == DYNCONV_SETUP_STAGE)
    {
        if(DEBUG) DoDebug("moi_essentiacnv: Running setup stage for stage " + IntToString(nStage));
        // Check if this stage is marked as already set up
        // This stops list duplication when scrolling
        if(!GetIsStageSetUp(nStage, oMeldshaper))
        {
            if(DEBUG) DoDebug("moi_essentiacnv: Stage was not set up already");
			if(nStage == STAGE_SELECT_TYPE)
            {
                if(DEBUG) DoDebug("moi_essentiacnv: Building meld selection");
                
                SetHeader("Choose what you wish to invest essentia in.");
               
				if (GetLevelByClass(CLASS_TYPE_INCARNATE, oMeldshaper))         AddChoice("Incarnate Soulmelds", CLASS_TYPE_INCARNATE, oMeldshaper);
				if (GetLevelByClass(CLASS_TYPE_SOULBORN, oMeldshaper))          AddChoice("Soulborn Soulmelds", CLASS_TYPE_SOULBORN, oMeldshaper);
				if (GetLevelByClass(CLASS_TYPE_TOTEMIST, oMeldshaper))          AddChoice("Totemist Soulmelds", CLASS_TYPE_TOTEMIST, oMeldshaper);
				if (GetLevelByClass(CLASS_TYPE_SPINEMELD_WARRIOR, oMeldshaper)) AddChoice("Spinemeld Warrior Soulmelds", CLASS_TYPE_SPINEMELD_WARRIOR, oMeldshaper);
				// This is because feats can't have temporary essentia invested in them
				if (!GetTemporaryEssentia(oMeldshaper)) AddChoice("Feats", 2, oMeldshaper);
				AddChoice("Class Features", 1, oMeldshaper);
				//This will fail if the PC cannot take the class
				if (GetLevelByClass(CLASS_TYPE_SOULCASTER, oMeldshaper) && !GetLocalInt(oMeldshaper, "PRC_PrereqSoulcaster")) AddChoice("Spells & Powers", 4, oMeldshaper);

                // Set the next, previous and wait tokens to default values
                SetDefaultTokens();
                // Set the convo quit text to "Abort"
                SetCustomToken(DYNCONV_TOKEN_EXIT, GetStringByStrRef(DYNCONV_STRREF_ABORT_CONVO));
            }            
			else if(nStage == STAGE_SELECT_MELD)
            {
                if(DEBUG) DoDebug("moi_essentiacnv: Building meld selection");
                
                SetHeader("You are investing in soulmelds as a "+GetStringByStrRef(StringToInt(Get2DACache("classes", "Name", nClass)))+". You can invest up to "+IntToString(GetMaxEssentiaCapacity(oMeldshaper, nClass, -1))+" into a single soulmeld, and up to "+IntToString(GetTotalUsableEssentia(oMeldshaper))+" total. You have used "+IntToString(GetTotalEssentiaInvested(oMeldshaper))+" of your total.");
               
                int i;
                for(i = 1; i < 11 ; i++) // Done as two separate loops to skip out Totem melds
                {
                    int nMeld = GetIsChakraUsed(oMeldshaper, i, nClass);
                    
                    if (DEBUG) DoDebug("nMeld: "+IntToString(nMeld));
                    
                    // Just list the melds here
                    if(nMeld) 
                    {
						AddChoice(GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nMeld))), nMeld, oMeldshaper);  
                    }
                }
                for(i = 12; i < 22 ; i++)
                {
                    int nMeld = GetIsChakraUsed(oMeldshaper, i, nClass);
                    
                    if (DEBUG) DoDebug("nMeld: "+IntToString(nMeld));
                    
                    // Just list the melds here
                    if(nMeld) 
                    {
						AddChoice(GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nMeld))), nMeld, oMeldshaper);  
                    }
                }                
				if (GetRacialType(oMeldshaper) == RACIAL_TYPE_DUSKLING)
					AddChoice("Duskling Speed", MELD_DUSKLING_SPEED, oMeldshaper);                 

                // Set the next, previous and wait tokens to default values
                SetDefaultTokens();
                // Set the convo quit text to "Abort"
                SetCustomToken(DYNCONV_TOKEN_EXIT, GetStringByStrRef(DYNCONV_STRREF_ABORT_CONVO));
            }   
			else if(nStage == STAGE_SELECT_FEAT)
            {
                if(DEBUG) DoDebug("moi_essentiacnv: Building feat selection");
                
                SetHeader("Choose the feat you wish to invest essentia in. You can invest up to "+IntToString(GetMaxEssentiaCapacityFeat(oMeldshaper))+" into a single feat, and up to "+IntToString(GetTotalUsableEssentia(oMeldshaper))+" total. Essentia invested into feats is used up until your next rest. You have used "+IntToString(GetTotalEssentiaInvested(oMeldshaper))+" of your total.");
               
                int i;
                for (i = 8869; i < 8889; i++)
                {
                	// Can't have any essentia invested in the feat already
                    if(GetHasFeat(i, oMeldshaper) && !GetEssentiaInvestedFeat(oMeldshaper, i)) 
                    {
						AddChoice(GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", i))), i, oMeldshaper);  
                    }
                }

                // Set the next, previous and wait tokens to default values
                SetDefaultTokens();
                // Set the convo quit text to "Abort"
                SetCustomToken(DYNCONV_TOKEN_EXIT, GetStringByStrRef(DYNCONV_STRREF_ABORT_CONVO));
            }      
			else if(nStage == STAGE_SELECT_CLASS)
            {
                if(DEBUG) DoDebug("moi_essentiacnv: Building feat selection");
                
                SetHeader("Choose the ability you wish to invest essentia in. You can invest up to "+IntToString(GetMaxEssentiaCapacity(oMeldshaper, -1, -1))+" into a single ability, and up to "+IntToString(GetTotalUsableEssentia(oMeldshaper))+" total. You have used "+IntToString(GetTotalEssentiaInvested(oMeldshaper))+" of your total."); 

				if (GetLevelByClass(CLASS_TYPE_SPINEMELD_WARRIOR, oMeldshaper) >= 2) AddChoice("Spine Enhancement", MELD_SPINE_ENHANCEMENT, oMeldshaper);  
				if (GetLevelByClass(CLASS_TYPE_IRONSOUL_FORGEMASTER, oMeldshaper) >= 1) AddChoice("Shield Bond", MELD_IRONSOUL_SHIELD, oMeldshaper);  
				if (GetLevelByClass(CLASS_TYPE_IRONSOUL_FORGEMASTER, oMeldshaper) >= 5) AddChoice("Armor Bond", MELD_IRONSOUL_ARMOR, oMeldshaper);  
				if (GetLevelByClass(CLASS_TYPE_IRONSOUL_FORGEMASTER, oMeldshaper) >= 9) AddChoice("Weapon Bond", MELD_IRONSOUL_WEAPON, oMeldshaper);  
				if (GetLevelByClass(CLASS_TYPE_UMBRAL_DISCIPLE, oMeldshaper) >= 1)  AddChoice("Step of the Bodiless",MELD_UMBRAL_STEP  , oMeldshaper);
				if (GetLevelByClass(CLASS_TYPE_UMBRAL_DISCIPLE, oMeldshaper) >= 3)  AddChoice("Embrace of Shadow",   MELD_UMBRAL_SHADOW, oMeldshaper);
				if (GetLevelByClass(CLASS_TYPE_UMBRAL_DISCIPLE, oMeldshaper) >= 7)  AddChoice("Sight of the Eyeless",MELD_UMBRAL_SIGHT , oMeldshaper);
				if (GetLevelByClass(CLASS_TYPE_UMBRAL_DISCIPLE, oMeldshaper) >= 9)  AddChoice("Soulchilling Strike", MELD_UMBRAL_SOUL  , oMeldshaper);
				if (GetLevelByClass(CLASS_TYPE_UMBRAL_DISCIPLE, oMeldshaper) >= 10) AddChoice("Kiss of the Shadows", MELD_UMBRAL_KISS  , oMeldshaper);
				if (GetLevelByClass(CLASS_TYPE_INCANDESCENT_CHAMPION, oMeldshaper) >= 1) AddChoice("Incandescent Strike", MELD_INCANDESCENT_STRIKE  , oMeldshaper);
				if (GetLevelByClass(CLASS_TYPE_INCANDESCENT_CHAMPION, oMeldshaper) >= 2) AddChoice("Incandescent Heal", MELD_INCANDESCENT_HEAL         , oMeldshaper);
				if (GetLevelByClass(CLASS_TYPE_INCANDESCENT_CHAMPION, oMeldshaper) >= 3) AddChoice("Incandescent Countenance", MELD_INCANDESCENT_COUNTENANCE  , oMeldshaper);
				if (GetLevelByClass(CLASS_TYPE_INCANDESCENT_CHAMPION, oMeldshaper) >= 5) AddChoice("Incandescent Ray", MELD_INCANDESCENT_RAY          , oMeldshaper);
				if (GetLevelByClass(CLASS_TYPE_INCANDESCENT_CHAMPION, oMeldshaper) >= 8) AddChoice("Incandescent Aura", MELD_INCANDESCENT_AURA         , oMeldshaper);
				if (GetLevelByClass(CLASS_TYPE_WITCHBORN_BINDER, oMeldshaper) >= 1)  AddChoice("Meldshield",         MELD_WITCH_MELDSHIELD, oMeldshaper);
				if (GetLevelByClass(CLASS_TYPE_WITCHBORN_BINDER, oMeldshaper) >= 2)  AddChoice("Dispelling Orb",     MELD_WITCH_DISPEL    , oMeldshaper);
				if (GetLevelByClass(CLASS_TYPE_WITCHBORN_BINDER, oMeldshaper) >= 4)  AddChoice("Mage Shackles",      MELD_WITCH_SHACKLES  , oMeldshaper);
				if (GetLevelByClass(CLASS_TYPE_WITCHBORN_BINDER, oMeldshaper) >= 6)  AddChoice("Word of Abrogation", MELD_WITCH_ABROGATION, oMeldshaper);
				if (GetLevelByClass(CLASS_TYPE_WITCHBORN_BINDER, oMeldshaper) >= 8)  AddChoice("Spiritflat",         MELD_WITCH_SPIRITFLAY, oMeldshaper);				
				if (GetLevelByClass(CLASS_TYPE_WITCHBORN_BINDER, oMeldshaper) >= 10) AddChoice("Grim Integument",    MELD_WITCH_INTEGUMENT, oMeldshaper);

                // Set the next, previous and wait tokens to default values
                SetDefaultTokens();
                // Set the convo quit text to "Abort"
                SetCustomToken(DYNCONV_TOKEN_EXIT, GetStringByStrRef(DYNCONV_STRREF_ABORT_CONVO));
            }    
            else if(nStage == STAGE_SELECT_SPELL_LEVEL)
            {
                if(DEBUG) DoDebug("moi_essentiacnv: Building spell level selection");
                string sType = "power";
        		if (GetPrimaryArcaneClass(oMeldshaper)) sType = "spell";                
                SetHeader("Choose the level of "+sType+" to invest with essentia.");

                // Set the tokens. 
                int nType = GetPrimaryArcaneClass(oMeldshaper);   
                int nMax = GetMaxSpellLevelForCasterLevel(nType, GetLevelByTypeArcane(oMeldshaper));
                
                if (GetPrimaryPsionicClass(oMeldshaper) > nType) nMax = GetMaxPowerLevel(oMeldshaper);
                
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
                if(DEBUG) DoDebug("moi_essentiacnv: Building spell selection");
                
                string sType = "power";
        		if (GetPrimaryArcaneClass(oMeldshaper)) sType = "spell";
                SetHeader("Choose the "+sType+" you wish to invest essentia in. You can invest 1 essentia into a single "+sType+", and into "+IntToString(GetLevelByClass(CLASS_TYPE_SOULCASTER, oMeldshaper))+" "+sType+"s total");
               
            	int nType = GetPrimaryArcaneClass(oMeldshaper);   
                if (nType != CLASS_TYPE_INVALID)
                {
                	//int nMax = GetMaxSpellLevelForCasterLevel(nType, GetLevelByTypeArcane(oMeldshaper));
                	string sPowerFile = GetFileForClass(nType);
                	if (nType == CLASS_TYPE_WIZARD) sPowerFile = "cls_spell_sorc";
                	int nLevelToBrowse = GetLocalInt(oMeldshaper, "SoulcasterLevel");
                	//FloatingTextStringOnCreature(sPowerFile+" "+IntToString(nLevelToBrowse), oMeldshaper);
                	int i, nSpellLevel;
                	string sFeatID;
                	for(i = 0; i < 550 ; i++)
                	{
                		nSpellLevel = StringToInt(Get2DACache(sPowerFile, "Level", i));
                    	if(nSpellLevel < nLevelToBrowse){
                    	    continue;
                    	} 
                    	//FloatingTextStringOnCreature(IntToString(nSpellLevel)+" "+IntToString(i), oMeldshaper);
	               	    //Due to the way the 2das are structured, we know that once
                	    //the level of a read evocation is greater than the maximum castable
                	    //it'll never be lower again. Therefore, we can skip reading the
                	    //evocations that wouldn't be shown anyway.
                	    if(nSpellLevel > nLevelToBrowse){
                	        break;
                	    }
                	    //sFeatID = Get2DACache(sPowerFile, "FeatID", i);
                		int nSpellId = StringToInt(Get2DACache(sPowerFile, "RealSpellID", i));
                	    
                	    if(/*sFeatID != "" && */PRCGetHasSpell(nSpellId, oMeldshaper)) // Non-blank row, must have the spell memorized/known
                	    {
							AddChoice(GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSpellId))), nSpellId, oMeldshaper);  
                	    }
                	}                	
                }
                else // We know we're Psionic
                {
                	string sPowerFile = GetAMSDefinitionFileName(nType);
                	int nLevelToBrowse = GetLocalInt(oMeldshaper, "SoulcasterLevel");
                	int i, nSpellLevel;
                	string sFeatID;
                	for(i = 0; i < 286 ; i++)
                	{
                		nSpellLevel = StringToInt(Get2DACache(sPowerFile, "Level", i));
                    	if(nSpellLevel < nLevelToBrowse){
                    	    continue;
                    	} 
	               	    //Due to the way the 2das are structured, we know that once
                	    //the level of a read evocation is greater than the maximum castable
                	    //it'll never be lower again. Therefore, we can skip reading the
                	    //evocations that wouldn't be shown anyway.
                	    if(nSpellLevel > nLevelToBrowse){
                	        break;
                	    }
                	    sFeatID = Get2DACache(sPowerFile, "FeatID", i);
                		int nSpellId = StringToInt(Get2DACache(sPowerFile, "RealSpellID", i));
                	    
                	    if(sFeatID != "" && GetHasFeat(StringToInt(sFeatID), oMeldshaper)) // Non-blank row, must have the power
                	    {
							AddChoice(GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSpellId))), nSpellId, oMeldshaper);  
                	    }
                	}                 	
                }               

                // Set the next, previous and wait tokens to default values
                SetDefaultTokens();
                // Set the convo quit text to "Abort"
                SetCustomToken(DYNCONV_TOKEN_EXIT, GetStringByStrRef(DYNCONV_STRREF_ABORT_CONVO));
            }             
            // Selection confirmation stage
            else if(nStage == STAGE_SELECT_ESSENTIA)
            {
                if(DEBUG) DoDebug("moi_essentiacnv: Building essentia selection");
                // Build the confirmation query
                int nMeld = GetLocalInt(oMeldshaper, "nMeld");
                SetHeader("How much do you want to invest into "+GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nMeld)))+"?"); 
                int i;
                
                for(i = 1; i <= PRCMin(GetTotalEssentia(oMeldshaper)-GetTotalEssentiaInvested(oMeldshaper), GetMaxEssentiaCapacity(oMeldshaper, nClass, nMeld)); i++)
                {
					AddChoice(IntToString(i), i, oMeldshaper);  
                }
                // If there's still room to add more essentia, and there's expanded soulmeld essentia available
                if (((GetTotalEssentia(oMeldshaper)-GetTotalEssentiaInvested(oMeldshaper)) > GetMaxEssentiaCapacity(oMeldshaper, nClass, nMeld)) && !GetIsSoulmeldCapacityUsed(oMeldshaper))
                {
                	AddChoice(IntToString(i), 1000+i, oMeldshaper);  
                }
            } 
            else if(nStage == STAGE_SELECT_ESSENTIA_FEAT)
            {
                if(DEBUG) DoDebug("moi_essentiacnv: Building essentia selection");
                // Build the confirmation query
                int nMeld = GetLocalInt(oMeldshaper, "nMeld");
                SetHeader("How much do you want to invest into "+GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", nMeld)))+"?"); 
                int i;
                for(i = 1; i <= PRCMin(GetTotalEssentia(oMeldshaper)-GetTotalEssentiaInvested(oMeldshaper), GetMaxEssentiaCapacityFeat(oMeldshaper)); i++)
                {
					AddChoice(IntToString(i), i, oMeldshaper);  
                }
            }  
            else if(nStage == STAGE_SELECT_ESSENTIA_CLASS)
            {
                if(DEBUG) DoDebug("moi_essentiacnv: Building essentia selection");
                // Build the confirmation query
                int nMeld = GetLocalInt(oMeldshaper, "nMeld");
                SetHeader("How much do you want to invest into "+GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nMeld)))+"?"); 
                int nMax = PRCMin(GetTotalEssentia(oMeldshaper)-GetTotalEssentiaInvested(oMeldshaper), GetMaxEssentiaCapacityFeat(oMeldshaper));
                if (nMeld == MELD_SPINE_ENHANCEMENT) nMax = GetLevelByClass(CLASS_TYPE_SPINEMELD_WARRIOR, oMeldshaper)/2;
                int i;
                for(i = 1; i <= nMax; i++)
                {
					AddChoice(IntToString(i), i, oMeldshaper);  
                }
            }   
            else if(nStage == STAGE_SELECT_ESSENTIA_SPELL)
            {
                if(DEBUG) DoDebug("moi_essentiacnv: Building essentia selection");
                // Build the confirmation query
                int nMeld = GetLocalInt(oMeldshaper, "nMeld");
                SetHeader("How much do you want to invest into "+GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nMeld)))+"?"); 
				AddChoice(IntToString(1), 1, oMeldshaper);  
				if (GetLevelByClass(CLASS_TYPE_SOULCASTER, oMeldshaper) >= 7) AddChoice(IntToString(2), 2, oMeldshaper);  
            }            
            // Selection confirmation stage
            else if(nStage == STAGE_CONFIRM_SELECTION)
            {
                if(DEBUG) DoDebug("moi_essentiacnv: Building selection confirmation");
                // Build the confirmation query
                int nMeld = GetLocalInt(oMeldshaper, "nMeld");
                int nEssentia = GetLocalInt(oMeldshaper, "nEssentia");
                // Marked as using Expanded Soulmeld Capacity, make it look pretty
                if (nEssentia > 1000) nEssentia -= 1000;
                string sToken = "You have chosen to invest "+IntToString(nEssentia)+" essentia into "+GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nMeld)))+"."+ "\n\n"; 
                sToken += GetStringByStrRef(STRREF_SELECTED_HEADER2); // "Is this correct?"
                SetHeader(sToken);

                AddChoice(GetStringByStrRef(STRREF_YES), TRUE, oMeldshaper); // "Yes"
                AddChoice(GetStringByStrRef(STRREF_NO), FALSE, oMeldshaper); // "No"
            }
            else if(nStage == STAGE_CONFIRM_SELECTION_FEAT)
            {
                if(DEBUG) DoDebug("moi_essentiacnv: Building selection confirmation");
                // Build the confirmation query
                int nMeld = GetLocalInt(oMeldshaper, "nMeld");
                string sToken = "You have chosen to invest "+IntToString(GetLocalInt(oMeldshaper, "nEssentia"))+" essentia into "+GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", nMeld)))+"."+ "\n\n"; 
                sToken += GetStringByStrRef(STRREF_SELECTED_HEADER2); // "Is this correct?"
                SetHeader(sToken);

                AddChoice(GetStringByStrRef(STRREF_YES), TRUE, oMeldshaper); // "Yes"
                AddChoice(GetStringByStrRef(STRREF_NO), FALSE, oMeldshaper); // "No"
            }  
            else if(nStage == STAGE_CONFIRM_SELECTION_CLASS)
            {
                if(DEBUG) DoDebug("moi_essentiacnv: Building selection confirmation");
                // Build the confirmation query
                int nMeld = GetLocalInt(oMeldshaper, "nMeld");
                string sToken = "You have chosen to invest "+IntToString(GetLocalInt(oMeldshaper, "nEssentia"))+" essentia into "+GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nMeld)))+"."+ "\n\n"; 
                sToken += GetStringByStrRef(STRREF_SELECTED_HEADER2); // "Is this correct?"
                SetHeader(sToken);

                AddChoice(GetStringByStrRef(STRREF_YES), TRUE, oMeldshaper); // "Yes"
                AddChoice(GetStringByStrRef(STRREF_NO), FALSE, oMeldshaper); // "No"
            }     
            else if(nStage == STAGE_CONFIRM_SELECTION_SPELL)
            {
                if(DEBUG) DoDebug("moi_essentiacnv: Building selection confirmation");
                // Build the confirmation query
                int nMeld = GetLocalInt(oMeldshaper, "nMeld");
                string sToken = "You have chosen to invest "+IntToString(GetLocalInt(oMeldshaper, "nEssentia"))+" essentia into "+GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nMeld)))+"."+ "\n\n"; 
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
        if(DEBUG) DoDebug("moi_essentiacnv: Running exit handler");
        // End of conversation cleanup
        DeleteLocalInt(oMeldshaper, "nMeld");
        DeleteLocalInt(oMeldshaper, "nEssentia");
        DeleteLocalInt(oMeldshaper, "nInvestClass");
		WipeMelds(oMeldshaper);
		ReshapeMelds(oMeldshaper);          
    }
    else if(nValue == DYNCONV_ABORTED)
    {
        // End of conversation cleanup
        DeleteLocalInt(oMeldshaper, "nMeld");
        DeleteLocalInt(oMeldshaper, "nEssentia");
        DeleteLocalInt(oMeldshaper, "nInvestClass");
		WipeMelds(oMeldshaper);
		ReshapeMelds(oMeldshaper);  
    }
    // Handle PC response
    else
    {
        int nChoice = GetChoice(oMeldshaper);
        if(DEBUG) DoDebug("moi_essentiacnv: Handling PC response, stage = " + IntToString(nStage) + "; nChoice = " + IntToString(nChoice) + "; choice text = '" + GetChoiceText(oMeldshaper) +  "'");
        if(nStage == STAGE_SELECT_TYPE)
        {
           	if(DEBUG) DoDebug("moi_essentiacnv: Type selected");
           	if (nChoice == 4)
           		nStage = STAGE_SELECT_SPELL_LEVEL;           	
           	if (nChoice >= 70) // It's a class
           	{
           		nStage = STAGE_SELECT_MELD;
           		SetLocalInt(oMeldshaper, "nInvestClass", nChoice);
           	}	
           	if (nChoice == 2)
           		nStage = STAGE_SELECT_FEAT;
           	if (nChoice == 1)
           		nStage = STAGE_SELECT_CLASS;           		

            MarkStageNotSetUp(STAGE_SELECT_TYPE, oMeldshaper);
        }     
        else if(nStage == STAGE_SELECT_MELD)
        {
           	if(DEBUG) DoDebug("moi_essentiacnv: Meld selected");
           	SetLocalInt(oMeldshaper, "nMeld", nChoice);
           	nStage = STAGE_SELECT_ESSENTIA;

            MarkStageNotSetUp(STAGE_SELECT_MELD, oMeldshaper);
        }         
        else if(nStage == STAGE_SELECT_FEAT)
        {
           	if(DEBUG) DoDebug("moi_essentiacnv: Feat selected");
           	SetLocalInt(oMeldshaper, "nMeld", nChoice);
           	nStage = STAGE_SELECT_ESSENTIA_FEAT;

            MarkStageNotSetUp(STAGE_SELECT_FEAT, oMeldshaper);
        }  
        else if(nStage == STAGE_SELECT_CLASS)
        {
           	if(DEBUG) DoDebug("moi_essentiacnv: Class Ability selected");
           	SetLocalInt(oMeldshaper, "nMeld", nChoice);
           	nStage = STAGE_SELECT_ESSENTIA_CLASS;

            MarkStageNotSetUp(STAGE_SELECT_CLASS, oMeldshaper);
        }    
        else if(nStage == STAGE_SELECT_SPELL_LEVEL)
        {
           	if(DEBUG) DoDebug("moi_essentiacnv: spell level selected");
           	SetLocalInt(oMeldshaper, "SoulcasterLevel", nChoice);
           	nStage = STAGE_SELECT_SPELL;

            MarkStageNotSetUp(STAGE_SELECT_SPELL_LEVEL, oMeldshaper);
        }        
        else if(nStage == STAGE_SELECT_SPELL)
        {
           	if(DEBUG) DoDebug("moi_essentiacnv: Spell or Power selected");
           	SetLocalInt(oMeldshaper, "nMeld", nChoice);
           	nStage = STAGE_SELECT_ESSENTIA_SPELL;

            MarkStageNotSetUp(STAGE_SELECT_SPELL, oMeldshaper);
        }         
        else if(nStage == STAGE_SELECT_ESSENTIA)
        {
           	if(DEBUG) DoDebug("moi_essentiacnv: Meld Essentia selected");
           	SetLocalInt(oMeldshaper, "nEssentia", nChoice);
           	nStage = STAGE_CONFIRM_SELECTION;

            MarkStageNotSetUp(STAGE_SELECT_ESSENTIA, oMeldshaper);
        } 
        else if(nStage == STAGE_SELECT_ESSENTIA_FEAT)
        {
           	if(DEBUG) DoDebug("moi_essentiacnv: Feat Essentia selected");
           	SetLocalInt(oMeldshaper, "nEssentia", nChoice);
           	nStage = STAGE_CONFIRM_SELECTION_FEAT;

            MarkStageNotSetUp(STAGE_SELECT_ESSENTIA_FEAT, oMeldshaper);
        }    
        else if(nStage == STAGE_SELECT_ESSENTIA_CLASS)
        {
           	if(DEBUG) DoDebug("moi_essentiacnv: Feat Essentia selected");
           	SetLocalInt(oMeldshaper, "nEssentia", nChoice);
           	nStage = STAGE_CONFIRM_SELECTION_CLASS;

            MarkStageNotSetUp(STAGE_SELECT_ESSENTIA_CLASS, oMeldshaper);
        }   
        else if(nStage == STAGE_SELECT_ESSENTIA_SPELL)
        {
           	if(DEBUG) DoDebug("moi_essentiacnv: Spell Essentia selected");
           	SetLocalInt(oMeldshaper, "nEssentia", nChoice);
           	nStage = STAGE_CONFIRM_SELECTION_SPELL;

            MarkStageNotSetUp(STAGE_SELECT_ESSENTIA_SPELL, oMeldshaper);
        }         
        else if(nStage == STAGE_CONFIRM_SELECTION)
        {     
        	if (nChoice)
        	{
        		InvestEssentia(oMeldshaper, GetLocalInt(oMeldshaper, "nMeld"), GetLocalInt(oMeldshaper, "nEssentia"));
        		DeleteLocalInt(oMeldshaper, "nMeld");
        		DeleteLocalInt(oMeldshaper, "nEssentia");
        	}		
        	
        	// We have more to go
            if(GetTotalUsableEssentia(oMeldshaper) > GetTotalEssentiaInvested(oMeldshaper))
            {
                nStage = STAGE_SELECT_TYPE;
            }
            else
            {
           	 	// And we're all done, so wipe and recast everything
				WipeMelds(oMeldshaper);
				ReshapeMelds(oMeldshaper);           	 	
            	AllowExit(DYNCONV_EXIT_FORCE_EXIT); 
            }
            MarkStageNotSetUp(STAGE_CONFIRM_SELECTION, oMeldshaper);        
        }
        else if(nStage == STAGE_CONFIRM_SELECTION_FEAT)
        {     
        	if (nChoice)
        	{
        		InvestEssentiaFeat(oMeldshaper, GetLocalInt(oMeldshaper, "nMeld"), GetLocalInt(oMeldshaper, "nEssentia"));
        		DeleteLocalInt(oMeldshaper, "nMeld");
        		DeleteLocalInt(oMeldshaper, "nEssentia");
        	}		
        	
        	// We have more to go
            if(GetTotalUsableEssentia(oMeldshaper) > GetTotalEssentiaInvested(oMeldshaper))
            {
                nStage = STAGE_SELECT_TYPE;
            }
            else
            {
           	 	// And we're all done, so wipe and recast everything
				WipeMelds(oMeldshaper);
				ReshapeMelds(oMeldshaper);           	 	
            	AllowExit(DYNCONV_EXIT_FORCE_EXIT); 
            }
            MarkStageNotSetUp(STAGE_CONFIRM_SELECTION_FEAT, oMeldshaper);        
        }  
        else if(nStage == STAGE_CONFIRM_SELECTION_CLASS)
        {     
        	if (nChoice)
        	{
        		InvestEssentia(oMeldshaper, GetLocalInt(oMeldshaper, "nMeld"), GetLocalInt(oMeldshaper, "nEssentia"));
        		DeleteLocalInt(oMeldshaper, "nMeld");
        		DeleteLocalInt(oMeldshaper, "nEssentia");
        	}		
        	
        	// We have more to go
            if(GetTotalUsableEssentia(oMeldshaper) > GetTotalEssentiaInvested(oMeldshaper))
            {
                nStage = STAGE_SELECT_TYPE;
            }
            else
            {
           	 	// And we're all done, so wipe and recast everything
				WipeMelds(oMeldshaper);
				ReshapeMelds(oMeldshaper);           	 	
            	AllowExit(DYNCONV_EXIT_FORCE_EXIT); 
            }
            MarkStageNotSetUp(STAGE_CONFIRM_SELECTION_CLASS, oMeldshaper);        
        }
        else if(nStage == STAGE_CONFIRM_SELECTION_SPELL)
        {     
        	if (nChoice)
        	{
        		InvestEssentiaSpell(oMeldshaper, GetLocalInt(oMeldshaper, "nMeld"), GetLocalInt(oMeldshaper, "nEssentia"));
        		DeleteLocalInt(oMeldshaper, "nMeld");
        		DeleteLocalInt(oMeldshaper, "nEssentia");
        	}		
        	
        	// We have more to go
            if(GetTotalUsableEssentia(oMeldshaper) > GetTotalEssentiaInvested(oMeldshaper))
            {
                nStage = STAGE_SELECT_TYPE;
            }
            else
            {
           	 	// And we're all done, so wipe and recast everything
				WipeMelds(oMeldshaper);
				ReshapeMelds(oMeldshaper);           	 	
            	AllowExit(DYNCONV_EXIT_FORCE_EXIT); 
            }
            MarkStageNotSetUp(STAGE_CONFIRM_SELECTION, oMeldshaper);        
        }        

        if(DEBUG) DoDebug("moi_essentiacnv: New stage: " + IntToString(nStage));

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oMeldshaper);
    }
}
