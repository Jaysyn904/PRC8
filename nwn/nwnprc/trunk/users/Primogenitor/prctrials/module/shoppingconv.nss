//:://////////////////////////////////////////////
//:: Short description
//:: filename
//:://////////////////////////////////////////////
/** @file
    Long description


    @author Joe Random
    @date   Created  - yyyy.mm.dd
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "inc_dynconv"
#include "rig_inc"
#include "inc_ecl"

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_SHOP                = 0;
const int STAGE_BIOWARE_SHOP        = 1;
const int STAGE_RANDOM_SHOP         = 2;
const int STAGE_RANDOM_SHOP_LEVEL   = 21;
const int STAGE_RANDOM_SHOP_AC      = 22;


//////////////////////////////////////////////////
/* Aid functions                                */
//////////////////////////////////////////////////

void StoresGetRandomizedItemByType(int nBaseItemType, int nLevel, int nAC = 0)
{
    object oTest = GetRandomizedItemByType(nBaseItemType, nLevel, nAC);
}

//////////////////////////////////////////////////
/* Main function                                */
//////////////////////////////////////////////////

void main()
{
    object oPC = GetPCSpeaker();
    object oTarget = GetObjectByTag("EffectCreature");
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

    // Check which of the conversation scripts called the scripts
    if(nValue == 0) // All of them set the DynConv_Var to non-zero value, so something is wrong -> abort
        return;

    if(nValue == DYNCONV_SETUP_STAGE)
    {
        // Check if this stage is marked as already set up
        // This stops list duplication when scrolling
        if(!GetIsStageSetUp(nStage, oPC))
        {
            if(nStage == STAGE_SHOP)
            {
                SetHeader("Select a type of shop");                
                AddChoice("Bioware stores",  1, oPC);              
                AddChoice("Random Item Generator stores",  2, oPC);
                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_BIOWARE_SHOP)
            {
                SetHeader("Select an shop");                
                AddChoice("nw_storethief001",  0, oPC);
                AddChoice("nw_storethief002",  1, oPC);
                AddChoice("nw_storethief003",  2, oPC);
                AddChoice("x2_storethief001",  3, oPC);
                AddChoice("x2_storethief002",  4, oPC);
                AddChoice("x2_storethief003",  5, oPC);
                AddChoice("x2_merc_dye",       6, oPC);
                AddChoice("nw_storgenral001",  7, oPC);
                AddChoice("nw_storgenral002",  8, oPC);
                AddChoice("nw_storgenral003",  9, oPC);
                AddChoice("x2_storegenl001",  10, oPC);
                AddChoice("nw_storemagic001", 11, oPC);
                AddChoice("nw_storemagic002", 12, oPC);
                AddChoice("nw_storemagic003", 13, oPC);
                AddChoice("nw_storemagic004", 14, oPC);
                AddChoice("x2_storemage001",  15, oPC);
                AddChoice("x2_storemage002",  16, oPC);
                AddChoice("x2_storemage003",  17, oPC);
                AddChoice("nw_storenatu001",  18, oPC);
                AddChoice("nw_storenatu002",  19, oPC);
                AddChoice("nw_storenatu003",  20, oPC);
                AddChoice("nw_storenatu004",  21, oPC);
                AddChoice("x2_storenatr001",  22, oPC);
                AddChoice("nw_lostitems",     23, oPC);
                AddChoice("nw_storespec001",  24, oPC);
                AddChoice("nw_storespec002",  25, oPC);
                AddChoice("nw_storespec003",  26, oPC);
                AddChoice("nw_storebar01",    27, oPC);
                AddChoice("nw_storetmple001", 28, oPC);
                AddChoice("nw_storetmple002", 29, oPC);
                AddChoice("nw_storetmple003", 30, oPC);
                AddChoice("nw_storetmple004", 31, oPC);
                AddChoice("x2_storetempl001", 32, oPC);
                AddChoice("x2_storetempl002", 33, oPC);
                AddChoice("x2_genie",         34, oPC);
                AddChoice("nw_storeweap001",  35, oPC);
                AddChoice("nw_storeweap002",  36, oPC);
                AddChoice("nw_storeweap003",  37, oPC);
                AddChoice("nw_storeweap004",  38, oPC);
                AddChoice("x2_storeweap001",  39, oPC);
                AddChoice("x2_storeweap002",  40, oPC);
                AddChoice("x2_storeweap003",  41, oPC);
                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_RANDOM_SHOP)
            {
                SetHeader("Select a type of item"); 
                int i;
                for(i=0; i<RIG_ROOT_COUNT; i++)
                {
                        
                    int nBaseItem = StringToInt(Get2DACache("rig_root", "BaseItem", i));
                    string sName = GetStringByStrRef(StringToInt(Get2DACache("baseitems", "Name", nBaseItem)));
                    AddChoice(sName,  nBaseItem, oPC);      
                }    
                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_RANDOM_SHOP_AC)
            {
                SetHeader("Select a AC of item"); 
                int i;
                for(i=1;i<10;i++)
                {
                    AddChoice("AC "+IntToString(i),  i, oPC);      
                }    
                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_RANDOM_SHOP_LEVEL)
            {
                SetHeader("Select a level of item"); 
                int i;
                for(i=1;i<40;i++)
                {
                    AddChoice("Level "+IntToString(i),  i, oPC);      
                }    
                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
        }

        // Do token setup
        SetupTokens();
    }
    // End of conversation cleanup
    else if(nValue == DYNCONV_EXITED)
    {
        // Add any locals set through this conversation
        DeleteLocalInt(OBJECT_SELF, "RIG_Item");
        DeleteLocalInt(OBJECT_SELF, "RIG_AC");
    }
    // Abort conversation cleanup.
    // NOTE: This section is only run when the conversation is aborted
    // while aborting is allowed. When it isn't, the dynconvo infrastructure
    // handles restoring the conversation in a transparent manner
    else if(nValue == DYNCONV_ABORTED)
    {
        // Add any locals set through this conversation
        DeleteLocalInt(OBJECT_SELF, "RIG_Item");
        DeleteLocalInt(OBJECT_SELF, "RIG_AC");
    }
    // Handle PC responses
    else
    {
        // variable named nChoice is the value of the player's choice as stored when building the choice list
        // variable named nStage determines the current conversation node
        int nChoice = GetChoice(oPC);
        if(nStage == STAGE_SHOP)
        {
            if(nChoice == 1)
                nStage = STAGE_BIOWARE_SHOP;
            else if(nChoice == 2)
                nStage = STAGE_RANDOM_SHOP;
            
        }
        else if(nStage == STAGE_BIOWARE_SHOP)
        {
            string sResRef = GetChoiceText(oPC);
            object oStore = CreateObject(OBJECT_TYPE_STORE, sResRef, GetLocation(OBJECT_SELF));
            DelayCommand(1.0, OpenStore(oStore, oPC));
            AssignCommand(oStore, 
                DelayCommand(300.0, 
                DestroyObject(oStore)));
            AllowExit(DYNCONV_EXIT_FORCE_EXIT);    
        }
        else if(nStage == STAGE_RANDOM_SHOP)
        {
            SetLocalInt(OBJECT_SELF, "RIG_Item", nChoice); 
            if(nChoice == BASE_ITEM_ARMOR)
                nStage = STAGE_RANDOM_SHOP_AC;
            else    
                nStage = STAGE_RANDOM_SHOP_LEVEL;
        }
        else if(nStage == STAGE_RANDOM_SHOP_AC)
        {
            SetLocalInt(OBJECT_SELF, "RIG_AC", nChoice); 
            nStage = STAGE_RANDOM_SHOP_LEVEL;
        }
        else if(nStage == STAGE_RANDOM_SHOP_LEVEL)
        {
            string sResRef = "store_sale";
            object oStore = CreateObject(OBJECT_TYPE_STORE, sResRef, GetLocation(OBJECT_SELF));
            DelayCommand(1.0, OpenStore(oStore, oPC));
            AssignCommand(oStore, 
                DelayCommand(300.0, 
                DestroyObject(oStore)));
            int nType = GetLocalInt(OBJECT_SELF, "RIG_Item"); 
            int nAC = GetLocalInt(OBJECT_SELF, "RIG_AC");
            int i;
            for(i=0; i < RIG_GetCacheSize(nType); i++)
            {
                AssignCommand(oStore, 
                    StoresGetRandomizedItemByType(
                        nType,
                        nChoice,
                        nAC));
            }
            AllowExit(DYNCONV_EXIT_FORCE_EXIT);  
        }

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
