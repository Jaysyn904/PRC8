//:://////////////////////////////////////////////
//:: Binder Bind Vestige choice script
//:: bnd_bindingcnv
//:://////////////////////////////////////////////
/*
    @author Stratovarius - 2021.02.03
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "bnd_inc_bndfunc"

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_SELECT_VESTIGE      = 0;
const int STAGE_CONFIRM_SELECTION   = 1;
const int STAGE_PACT_AUGMENT        = 2;
const int STAGE_NABERIUS            = 3;
const int STAGE_EXPLOIT_VESTIGE     = 4;
const int STAGE_ASTAROTH            = 5;

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
        if(DEBUG) DoDebug("bnd_bindingcnv: Running setup stage for stage " + IntToString(nStage));
        // Check if this stage is marked as already set up
        // This stops list duplication when scrolling
        if(!GetIsStageSetUp(nStage, oBinder))
        {
            if(DEBUG) DoDebug("bnd_bindingcnv: Stage was not set up already");
			if(nStage == STAGE_SELECT_VESTIGE)
            {
                if(DEBUG) DoDebug("bnd_bindingcnv: Building vestige selection");

                SetHeader("Choose the vestige to bind.");
               
                string sVestige;
                int i, nVestige;
                for(i = 0; i < 50 ; i++)
                {
                    sVestige = GetStringByStrRef(StringToInt(Get2DACache(sVestigeFile, "Name", i)));
                    nVestige = StringToInt(Get2DACache(sVestigeFile, "SpellID", i));
                    if (DEBUG) DoDebug("sVestige: "+sVestige);
                    
                    // Non-blank row, can bind a vestige of that level, don't already have the vestige
                    if(nVestige && sVestige != "" && GetMaxVestigeLevel(oBinder) >= GetVestigeLevel(i) && !GetHasSpellEffect(nVestige, oBinder) && DoSpecialRequirements(oBinder, nVestige)) 
                    {
						AddChoice(sVestige, i, oBinder);  
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
                if(DEBUG) DoDebug("bnd_bindingcnv: Building selection confirmation");
                // Build the confirmation query
                string sToken = GetStringByStrRef(STRREF_SELECTED_HEADER1) + "\n\n"; // "You have selected:"
                int nSpellId = GetLocalInt(oBinder, "nVestige");
                sToken += GetStringByStrRef(StringToInt(Get2DACache(sVestigeFile, "Description", nSpellId)))+"\n\n";
                sToken += GetStringByStrRef(STRREF_SELECTED_HEADER2); // "Is this correct?"
                SetHeader(sToken);

                AddChoice(GetStringByStrRef(STRREF_YES), TRUE, oBinder); // "Yes"
                AddChoice("Rushed Bind (Bind in one round, but take a -10 penalty on your binding check)", 2, oBinder);
                if (GetHasFeat(FEAT_RAPID_PACT_MAKING, oBinder) && !GetLocalInt(oBinder, "RapidPactMaking")) AddChoice("Rapid Pact Making (Bind in one round, no penalty on your binding check)", 3, oBinder);
                AddChoice(GetStringByStrRef(STRREF_NO), FALSE, oBinder); // "No"
            }
            // Pact Augment stage
            else if(nStage == STAGE_PACT_AUGMENT)
            {
                if(DEBUG) DoDebug("bnd_bindingcnv: Building pact augment choices");
				
				SetHeader("You may choose to gain an additional benefit when you bind a vestige. You can choose a single ability multiple times, and their effects stack.");
				AddChoice("5 temporary hit points", 1, oBinder);
	            AddChoice("Resist Acid 5", 2, oBinder);
	            AddChoice("Resist Cold 5", 3, oBinder);
	            AddChoice("Resist Electrical 5", 4, oBinder);
	            AddChoice("Resist Fire 5", 5, oBinder);
	            AddChoice("Resist Sonic 5", 6, oBinder);				
	            AddChoice("+1 All Saving Throws", 7, oBinder);				
	            AddChoice("Damage Resistance 1/-", 8, oBinder);	
	            AddChoice("+1 Armor Class", 9, oBinder);	
	            AddChoice("+1 Attack", 10, oBinder);	
	            AddChoice("+1 Damage", 11, oBinder);	
            }    
			else if(nStage == STAGE_NABERIUS)
            {
                if(DEBUG) DoDebug("bnd_bindingcnv: Naberius skill selection");

                SetHeader("Choose the unranked skill to gain a +4 bonus in.");
               
                string sSkill;
                int i;
                for(i = 0; i < 40 ; i++)
                {
                    sSkill = GetStringByStrRef(StringToInt(Get2DACache("skills", "Name", i)));
                    if (DEBUG) DoDebug("sSkill: "+sSkill);
                    
                    // No ranks, can be used untrained, and hasn't already been picked
                    if(!GetSkillRank(i, oBinder, TRUE) && sSkill != "" && StringToInt(Get2DACache("skills", "Untrained", i)) && !GetLocalInt(oBinder, "NaberiusSkill"+IntToString(i))) 
                    {
						AddChoice(sSkill, i, oBinder);  
                    }
                }                
												      
                // Set the next, previous and wait tokens to default values
                SetDefaultTokens();
                // Set the convo quit text to "Abort"
                SetCustomToken(DYNCONV_TOKEN_EXIT, GetStringByStrRef(DYNCONV_STRREF_ABORT_CONVO));
            }  
			else if(nStage == STAGE_EXPLOIT_VESTIGE)
            {
                if(DEBUG) DoDebug("bnd_bindingcnv: Exploit Vestige selection");

                SetHeader("With this ability, you can choose to forego gaining one of this vestige’s granted abilities in order to gain one additional arcane spell of the highest you can cast.");
                
                int nVestige = GetLocalInt(oBinder, "nVestige");
                
                int i, nEvoLevel;
                string sAbil;
                for(i = 0; i < 150 ; i++)
                {
                    nEvoLevel = StringToInt(Get2DACache("vestigeabil", "VestigeNum", i));
                    // Skip any that don't belong to the right vestige
                    if(nEvoLevel < nVestige){
                        continue;
                    }
                     //Due to the way the 2das are structured, we know that once
                     //we've hit the end of a vestige, we're done
                     
                    if(nEvoLevel > nVestige){
                        break;
                    }
                    sAbil = Get2DACache("vestigeabil", "Ability", i);
                    if(sAbil != "") // Non-blank row
                    {
                    	AddChoice(sAbil, i, oBinder);
                    }
                }                
				AddChoice("None", 0, oBinder);												      
                // Set the next, previous and wait tokens to default values
                SetDefaultTokens();
                // Set the convo quit text to "Abort"
                SetCustomToken(DYNCONV_TOKEN_EXIT, GetStringByStrRef(DYNCONV_STRREF_ABORT_CONVO));
            }  
			else if(nStage == STAGE_ASTAROTH)
            {
                if(DEBUG) DoDebug("bnd_bindingcnv: Astaroth feat selection");

                SetHeader("Choose the crafting feat to gain.");
                int nBinderLevel = GetBinderLevel(oBinder, VESTIGE_ASTAROTH);
				AddChoice("Scribe Scroll",      FEAT_SCRIBE_SCROLL   , oBinder);
				AddChoice("Brew Potion",        FEAT_BREW_POTION     , oBinder);
				AddChoice("Craft Wonderous",    FEAT_CRAFT_WONDROUS  , oBinder);
				AddChoice("Craft Arms & Armor", FEAT_CRAFT_ARMS_ARMOR, oBinder);
				AddChoice("Craft Wand",         FEAT_CRAFT_WAND      , oBinder);
				
				if (nBinderLevel >= 9)  AddChoice("Craft Rod", FEAT_CRAFT_ROD, oBinder);
				if (nBinderLevel >= 12) AddChoice("Craft Staff", FEAT_CRAFT_STAFF, oBinder);
				if (nBinderLevel >= 12) AddChoice("Forge Ring", FEAT_FORGE_RING, oBinder);
												      
                // Set the next, previous and wait tokens to default values
                SetDefaultTokens();
                // Set the convo quit text to "Abort"
                SetCustomToken(DYNCONV_TOKEN_EXIT, GetStringByStrRef(DYNCONV_STRREF_ABORT_CONVO));
            }     
            MarkStageSetUp(nStage, oBinder);
        }

        // Do token setup
        SetupTokens();
    }
    else if(nValue == DYNCONV_EXITED)
    {
        if(DEBUG) DoDebug("bnd_bindingcnv: Running exit handler");
        // End of conversation cleanup
        DeleteLocalInt(oBinder, "nVestige");
        DeleteLocalInt(oBinder, "PactAugmentCount");
        DeleteLocalInt(oBinder, "NaberiusSkillCount");
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
        if(DEBUG) DoDebug("bnd_bindingcnv: Handling PC response, stage = " + IntToString(nStage) + "; nChoice = " + IntToString(nChoice) + "; choice text = '" + GetChoiceText(oBinder) +  "'");
        
        if(nStage == STAGE_SELECT_VESTIGE)
        {
           	if(DEBUG) DoDebug("bnd_bindingcnv: Chakra selected");
           	SetLocalInt(oBinder, "nVestige", nChoice);
           	
           	// Only once per day
        	if (GetLevelByClass(CLASS_TYPE_ANIMA_MAGE, oBinder) >= 2 && !GetLocalInt(oBinder, "ExploitVestige"))
        	{
        		nStage = STAGE_EXPLOIT_VESTIGE;
        	}
        	else 
        	{
        		nStage = STAGE_CONFIRM_SELECTION;
        	}           	
           	
			//ClearCurrentStage(oBinder);
            MarkStageNotSetUp(STAGE_SELECT_VESTIGE, oBinder);
        }        
        else if(nStage == STAGE_CONFIRM_SELECTION)
        {     
        	if (nChoice)
        	{
        		if (nChoice == 2)
        			SetLocalInt(oBinder, "RushedBinding", TRUE);
        		if (nChoice == 3)
        			SetLocalInt(oBinder, "RapidPactMaking", TRUE);        			
        		
        		if (GetPactAugmentCount(oBinder))
        		{
        			nStage = STAGE_PACT_AUGMENT;
        		}
        		else if (GetLocalInt(oBinder, "nVestige") == 4 && GetAbilityModifier(ABILITY_CONSTITUTION, oBinder) >= 1)
        		{
        			nStage = STAGE_NABERIUS;
        		}   
        		else if (GetLocalInt(oBinder, "nVestige") == 20)
        		{
        			nStage = STAGE_ASTAROTH;
        		}           		
        		else
        		{
					int nContactTime = VESTIGE_CONTACT_TIME;		
					if(GetPRCSwitch(PRC_CONTACT_VESTIGE_TIMER) >= 6) nContactTime = GetPRCSwitch(PRC_CONTACT_VESTIGE_TIMER);        		
        			ContactVestige(oBinder, nContactTime, GetLocalInt(oBinder, "nVestige"));
        			DeleteLocalInt(oBinder, "nVestige");        		
        			AllowExit(DYNCONV_EXIT_FORCE_EXIT); 
        		}
        	}
        	else 
        		nStage = STAGE_SELECT_VESTIGE;
        		
            MarkStageNotSetUp(STAGE_CONFIRM_SELECTION, oBinder);        
        }
        else if(nStage == STAGE_PACT_AUGMENT)
        {     
        	if (nChoice)
        	{
        		SetLocalInt(oBinder, "PactAugment"+IntToString(nChoice), GetLocalInt(oBinder, "PactAugment"+IntToString(nChoice))+1);
        		SetLocalInt(oBinder, "PactAugmentCount", GetLocalInt(oBinder, "PactAugmentCount")+1);
        	}		
        	
        	if (GetPactAugmentCount(oBinder) - GetLocalInt(oBinder, "PactAugmentCount"))
        	{
        		nStage = STAGE_PACT_AUGMENT;
        	}
        	else if (GetLocalInt(oBinder, "nVestige") == 4 && GetAbilityModifier(ABILITY_CONSTITUTION, oBinder) >= 1)
        	{
        		nStage = STAGE_NABERIUS;
        	}   
        	else if (GetLocalInt(oBinder, "nVestige") == 20)
        	{
        		nStage = STAGE_ASTAROTH;
        	}        	
        	else
        	{
				int nContactTime = VESTIGE_CONTACT_TIME;		
				if(GetPRCSwitch(PRC_CONTACT_VESTIGE_TIMER) >= 6) nContactTime = GetPRCSwitch(PRC_CONTACT_VESTIGE_TIMER);        		
        		ContactVestige(oBinder, nContactTime, GetLocalInt(oBinder, "nVestige"));
        		DeleteLocalInt(oBinder, "nVestige");        		
        		AllowExit(DYNCONV_EXIT_FORCE_EXIT); 
        	}
        	
        	ClearCurrentStage(oBinder);
            MarkStageNotSetUp(STAGE_PACT_AUGMENT, oBinder);        
        }  
        else if(nStage == STAGE_NABERIUS)
        {     
        	if (nChoice)
        	{
        		SetLocalInt(oBinder, "NaberiusSkill"+IntToString(nChoice), TRUE);
        		SetLocalInt(oBinder, "NaberiusSkillCount", GetLocalInt(oBinder, "NaberiusSkillCount")+1);
        	}		
        	
        	if (GetAbilityModifier(ABILITY_CONSTITUTION, oBinder) - GetLocalInt(oBinder, "NaberiusSkillCount"))
        	{
        		nStage = STAGE_NABERIUS;
        	}
        	else
        	{
				int nContactTime = VESTIGE_CONTACT_TIME;		
				if(GetPRCSwitch(PRC_CONTACT_VESTIGE_TIMER) >= 6) nContactTime = GetPRCSwitch(PRC_CONTACT_VESTIGE_TIMER);        		
        		ContactVestige(oBinder, nContactTime, GetLocalInt(oBinder, "nVestige"));
        		DeleteLocalInt(oBinder, "nVestige");        		
        		AllowExit(DYNCONV_EXIT_FORCE_EXIT); 
        	}
        	
        	ClearCurrentStage(oBinder);
            MarkStageNotSetUp(STAGE_NABERIUS, oBinder);        
        }    
		else if(nStage == STAGE_EXPLOIT_VESTIGE)
        {   
        	if (nChoice)
        	{
        		SetIsVestigeExploited(oBinder, nChoice);
        	}      
        	nStage = STAGE_CONFIRM_SELECTION;
			ClearCurrentStage(oBinder);
            MarkStageNotSetUp(STAGE_EXPLOIT_VESTIGE, oBinder);         	
        }
		else if(nStage == STAGE_ASTAROTH)  
		{       
			// Grant the selected crafting feat as a tagged effect  
			effect eFeat = EffectBonusFeat(nChoice);  
			eFeat = TagEffect(eFeat, "AstarothCraftingFeat");  
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eFeat), oBinder, HoursToSeconds(24));  
			  
			int nContactTime = VESTIGE_CONTACT_TIME;		  
			if(GetPRCSwitch(PRC_CONTACT_VESTIGE_TIMER) >= 6) nContactTime = GetPRCSwitch(PRC_CONTACT_VESTIGE_TIMER);        		  
			ContactVestige(oBinder, nContactTime, GetLocalInt(oBinder, "nVestige"));  
			DeleteLocalInt(oBinder, "nVestige");        		  
			AllowExit(DYNCONV_EXIT_FORCE_EXIT);   
			  
			ClearCurrentStage(oBinder);  
			MarkStageNotSetUp(STAGE_ASTAROTH, oBinder);          
		}
		
/*         else if(nStage == STAGE_ASTAROTH)
        {     
        	if (nChoice == FEAT_SCRIBE_SCROLL   ) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_FEAT_FEAT_SCRIBE_SCROLL   ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
			if (nChoice == FEAT_BREW_POTION     ) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_FEAT_FEAT_BREW_POTION     ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
			if (nChoice == FEAT_CRAFT_WONDROUS  ) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_FEAT_FEAT_CRAFT_WONDROUS  ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
			if (nChoice == FEAT_CRAFT_ARMS_ARMOR) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_FEAT_FEAT_CRAFT_ARMS_ARMOR), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
			if (nChoice == FEAT_CRAFT_WAND      ) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_FEAT_FEAT_CRAFT_WAND      ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
			if (nChoice == FEAT_CRAFT_ROD       ) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_FEAT_FEAT_CRAFT_ROD       ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
			if (nChoice == FEAT_CRAFT_STAFF     ) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_FEAT_FEAT_CRAFT_STAFF     ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
			if (nChoice == FEAT_FORGE_RING      ) IPSafeAddItemProperty(GetPCSkin(oBinder), ItemPropertyBonusFeat(IP_FEAT_FEAT_FORGE_RING      ), HoursToSeconds(24), X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
        	
			int nContactTime = VESTIGE_CONTACT_TIME;		
			if(GetPRCSwitch(PRC_CONTACT_VESTIGE_TIMER) >= 6) nContactTime = GetPRCSwitch(PRC_CONTACT_VESTIGE_TIMER);        		
       		ContactVestige(oBinder, nContactTime, GetLocalInt(oBinder, "nVestige"));
       		DeleteLocalInt(oBinder, "nVestige");        		
       		AllowExit(DYNCONV_EXIT_FORCE_EXIT); 
        	
        	ClearCurrentStage(oBinder);
            MarkStageNotSetUp(STAGE_ASTAROTH, oBinder);        
        }   */       

        if(DEBUG) DoDebug("bnd_bindingcnv: New stage: " + IntToString(nStage));

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oBinder);
    }
}
