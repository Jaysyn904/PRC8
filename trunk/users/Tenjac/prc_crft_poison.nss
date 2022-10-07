///////////////////////////////////////////////////
//  Craft Poison Convo
//  prc_crft_poison
///////////////////////////////////////////////////

#include "prc_inc_spells"
#include "inc_dynconv"

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_ENTRY                           =0;
const int STAGE_POISON                          =1;
const int STAGE_CONFIRM                         =2;

//////////////////////////////////////////////////
/* Aid functions                                */
//////////////////////////////////////////////////

void AddToTempList(object oPC, string sChoice, int nChoice)
{
    if(DEBUG_LIST) DoDebug("\nAdding to temp list: '" + sChoice + "' - " + IntToString(nChoice));
    if(DEBUG_LIST) PrintList(oPC);
    // If there is nothing yet
    if(!GetLocalInt(oPC, "PRC_CRAFT_CONVO_ListInited"))
    {
        SetLocalString(oPC, "PRC_CRAFT_CONVO_List_Head", sChoice);
        SetLocalInt(oPC, "PRC_CRAFT_CONVO_List_" + sChoice, nChoice);

        SetLocalInt(oPC, "PRC_CRAFT_CONVO_ListInited", TRUE);
    }
    else
    {
        // Find the location to instert into
        string sPrev = "", sNext = GetLocalString(oPC, "PRC_CRAFT_CONVO_List_Head");
        while(sNext != "" && StringCompare(sChoice, sNext) >= 0)
        {
            if(DEBUG_LIST) DoDebug("Comparison between '" + sChoice + "' and '" + sNext + "' = " + IntToString(StringCompare(sChoice, sNext)));
            sPrev = sNext;
            sNext = GetLocalString(oPC, "PRC_CRAFT_CONVO_List_Next_" + sNext);
        }

        // Insert the new entry
        // Does it replace the head?
        if(sPrev == "")
        {
            if(DEBUG_LIST) DoDebug("New head");
            SetLocalString(oPC, "PRC_CRAFT_CONVO_List_Head", sChoice);
        }
        else
        {
            if(DEBUG_LIST) DoDebug("Inserting into position between '" + sPrev + "' and '" + sNext + "'");
            SetLocalString(oPC, "PRC_CRAFT_CONVO_List_Next_" + sPrev, sChoice);
        }

        SetLocalString(oPC, "PRC_CRAFT_CONVO_List_Next_" + sChoice, sNext);
        SetLocalInt(oPC, "PRC_CRAFT_CONVO_List_" + sChoice, nChoice);
    }
}

//Adds names to a list based on sTable (2da), delayed recursion

//  to avoid TMI

void PopulateList(object oPC, int MaxValue, int bSort, string sTable, object oItem = OBJECT_INVALID, int i = 0)
{
        
        if(GetLocalInt(oPC, "DynConv_Waiting") == FALSE)
        
        return;
        
        if(i <= MaxValue)
        
        {
                int bValid = TRUE;                
                string sTemp = "";           
                bValid = array_get_int(oPC, PRC_CRAFT_ITEMPROP_ARRAY, i);
                
                sTemp = Get2DACache(sTable, "Name", i);
                
                if((sTemp != "") && bValid)//this is going to kill                
                {                      
                        if(sTable == "iprp_spells")                        
                        {
                                string sIndex = Get2DACache(sTable, "SpellIndex", i);                           
                                if(sIndex != GetLocalString(oPC, "LastSpell"))
                                
                                {   //don't add if it's a repeat
                                        
                                        if(bSort)   AddToTempList(oPC, ActionString(GetStringByStrRef(StringToInt(sTemp))), i);                                        
                                        else        AddChoice(ActionString(GetStringByStrRef(StringToInt(sTemp))), i, oPC);
                                        
                                        SetLocalString(oPC, "LastSpell", sIndex);                                        
                                }                                
                        }
                        
                        else                        
                        {                                
                                if(bSort)   AddToTempList(oPC, ActionString(GetStringByStrRef(StringToInt(sTemp))), i);                                
                                else        AddChoice(ActionString(GetStringByStrRef(StringToInt(sTemp))), i, oPC);                                
                        }
                }
                
                if(!(i % 100) && i) //i != 0, i % 100 == 0                
                FloatingTextStringOnCreature("*Tick*", oPC, FALSE);               
        }
        
        else        
        {                
                if(bSort) TransferTempList(oPC);                
                DeleteLocalInt(oPC, "DynConv_Waiting");                
                FloatingTextStringOnCreature("*Done*", oPC, FALSE);                
                return;                
        }        
        DelayCommand(0.01, PopulateList(oPC, MaxValue, bSort, sTable, oItem, i + 1));        
}

//////////////////////////////////////////////////
/* Main function                                */
//////////////////////////////////////////////////

void main()
{
    object oPC = GetPCSpeaker();
    /* Get the value of the local variable set by the conversation script calling
     * this script. Values:
     * DYNCONV_ABORTED     Conversation aborted
     * DYNCONV_EXITED      Conversation exited via the exit node
     * DYNCONV_SETUP_STAGE System's reply turn
     * 0                   Error - something else called the script
     * Other               The user made a choice
     */
    int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);
    // The stage is used to determine the active conversation node.
    // 0 is the entry node.
    int nStage = GetStage(oPC);    
    
    int nPoison = GetSkillRank(SKILL_CRAFT_POISON, oPC);
    int nAlchem = GetSkillRank(SKILL_CRAFT_ALCHEMY, oPC);    
    
    // Check which of the conversation scripts called the scripts
    if(nValue == 0) // All of them set the DynConv_Var to non-zero value, so something is wrong -> abort
        return;

    if(nValue == DYNCONV_SETUP_STAGE)
    {
        // Check if this stage is marked as already set up
        // This stops list duplication when scrolling
        if(!GetIsStageSetUp(nStage, oPC))
        {
            // variable named nStage determines the current conversation node
            // Function SetHeader to set the text displayed to the PC
            // Function AddChoice to add a response option for the PC. The responses are show in order added
            if(nStage == STAGE_ENTRY)
            {
                    AllowExit(DYNCONV_EXIT_FORCE_EXIT);
                    SetHeader("Would you like to craft a poison?");
                    AddChoice("Yes.", 1);
                                       
                    MarkStageSetUp(nStage, oPC);
                    SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values            
            }
            
            if(nStage == STAGE_POISON)
            {
                    if(DEBUG) DoDebug("prc_crft_poison: Building poison selection");
                    SetHeader("Which poison would you like to create?");
                    
                    //Read 2da and setup choices
                    PopulateList(oPC, PRCGetFileEnd("prc_craft_poison"), TRUE, "prc_craft_poison");
                    
                    MarkStageSetUp(nStage, oPC);
                    SetDefaultTokens();
            }
            
            else if (nStage == STAGE_CONFIRM)
            {
                    SetHeader("Are you sure you want to create this item?");
                    
                    AddChoice("Back", CHOICE_BACK, oPC);
                    
                    if(GetGold(oPC) >= nCost) AddChoice("Confirm", CHOICE_CONFIRM_CRAFT, oPC);
                    MarkStageSetUp(nStage);
            }            
            
            else  
            {
                    if(DEBUG) DoDebug("Invalid Stage: " + IntToString(nStage));
                    return;
            }
    }
    // Do token setup
    SetupTokens();
    
    // End of conversation cleanup
        else if(nValue == DYNCONV_EXITED)
        {
                // Add any locals set through this conversation
                DeleteLocalInt(oPC, "PRC_CRAFT_COST");
                DeleteLocalInt(oPC, "PRC_CRAFT_DC");
                DeleteLocalString(oPC, "PRC_CRAFT_RESREF");
                DeleteLocalInt(oPC, "PRC_CRAFT_SKILLUSED");
        }
        // Abort conversation cleanup.
        // NOTE: This section is only run when the conversation is aborted
        // while aborting is allowed. When it isn't, the dynconvo infrastructure
        // handles restoring the conversation in a transparent manner
        else if(nValue == DYNCONV_ABORTED)
        {
                DeleteLocalInt(oPC, "PRC_CRAFT_COST");
                DeleteLocalInt(oPC, "PRC_CRAFT_DC");
                DeleteLocalString(oPC, "PRC_CRAFT_RESREF");
                DeleteLocalInt(oPC, "PRC_CRAFT_SKILLUSED");
            // Add any locals set through this conversation
            if(DEBUG) DoDebug("prc_craft: ERROR: Conversation abort section run");
        }
        // Handle PC responses
        else
        {
            // variable named nChoice is the value of the player's choice as stored when building the choice list
            // variable named nStage determines the current conversation node
            int nChoice = GetChoice(oPC);
            if(nStage == STAGE_ENTRY)
            {
                    if(nChoice == 1) nStage = STAGE_POISON;                    
                // Move to another stage based on response, for example
                //nStage = STAGE_QUUX;
            }
            
            else if(nStage == STAGE_POISON)
            {
                    //Create choice list                    
                                        
            }
            
            else if(nStage == STAGE_CONFIRM)
            {
                    if(nChoice == CHOICE_ABORT_CRAFT)
                    {
                            nStage = STAGE_ENTRY;
                    }
                    
                    else if(nChoice == CHOICE_CONFIRM_CRAFT)
                    {
                            int n2daLine = nChoice--;
                            if(n2daLine < 0) SendMessageToPC(oPC, "Invalid prc_crft_poison.2da line");
                            int nDC = StringToInt(Get2daCache("prc_crft_poison", "CraftDC", n2daLine));
                            int nCost = StringToInt(Get2daCache("prc_crft_poison", "GoldCost", n2daLine));
                            string sPoison = Get2daCache("prc_crft_poison", "Poison2daLine", n2daLine);
                            int nName = StringToInt(Get2daCache("prc_crft_poison", "Name", n2daLine));
                            int nDesc = StringToInt(Get2daCache("prc_crft_poison", "Description", n2daLine));
                            int nType = StringToInt(Get2daCache("prc_crft_poison", "PoisonType", n2daLine));
                            nSkill = SKILL_CRAFT_POISON;             
                            
                            //Use alchemy skill if it is 5 or more higher than craft(poisonmaking). DC is increased by 4.
                            if((nAlchem - nPoison) >4)
                            {
                                    nSkill = SKILL_CRAFT_ALCHEMY;
                                    nDC += 4;
                                    SendMessageToPC(oPC, "Using craft(alchemy) instead of craft(poison). New DC is "+ IntToString(nDC) + ".");                                    
                            }                            
                                                  
                            TakeGoldFromCreature(nCost, oPC, TRUE);
                            if(GetIsSkillSuccessful(oPC, nSkill), nDC))
                            {
                                    SendMessageToPc(oPC, "Item successfully created.");
                                    object oTarget; CreateItemOnObject("prc_it_poison", oPC, 1, "prc_it_pois" + sPoison);
                                                                                                                                           
                                    if(nType == 0) CreateItemOnObject("prc_it_poist0", oPC, 1, "prc_it_pois" + sPoison);                                    
                                    
                                    else if(nType == 1) CreateItemOnObject("prc_it_poist1", oPC, 1, "prc_it_pois" + sPoison);
                                    
                                    else if(nType == 2) CreateItemOnObject("prc_it_poist2", oPC, 1, "prc_it_pois" + sPoison);
                                                                        
                                    else if(nType == 3) CreateItemOnObject("prc_it_poist3", oPC, 1, "prc_it_pois" + sPoison);
                                    
                                    else
                                    {
                                            SendMessageToPC(oPC, "Invalid poison type. Aborting."
                                            GiveGoldToCreature(oPC, nCost);
                                            return;
                                    }
                                    
                                    //Set name and descrip
                                    SetName(oTarget, GetStringByStrRef(nName));
                                    SetDescription(oTarget, GetStringByStrRef(nDesc));
                            }                            
                            AllowExit(DYNCONV_EXIT_FORCE_EXIT);
                    }                
            }            
            // Store the stage value. If it has been changed, this clears out the choices
            SetStage(nStage, oPC);
    }
}       