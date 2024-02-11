//:://////////////////////////////////////////////
//:: Appearance changing dynamic conversation
//:: appearconv.nss
//:://////////////////////////////////////////////
/** @file
    Conversation to change appearance
    
    Allows for add/remove wings/tails, head changes,
    portrait, and overall appearance


    @author Primogenitor
    @date   Created  - 2006.09.26
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "inc_dynconv"

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_ENTRY                       =  0;
const int STAGE_APPEARANCE                  = 510;
const int STAGE_HEAD                        = 520;
const int STAGE_WINGS                       = 530;
const int STAGE_TAIL                        = 540;
const int STAGE_BODYPART                    = 550;
const int STAGE_BODYPART_CHANGE             = 551;
const int STAGE_PORTRAIT                    = 560;
const int STAGE_EQUIPMENT                   = 590;
const int STAGE_EQUIPMENT_SIMPLE            = 591; //e.g. shield
const int STAGE_EQUIPMENT_LAYERED           = 592; //e.g. helm
const int STAGE_EQUIPMENT_COMPOSITE         = 593; //e.g. sword
const int STAGE_EQUIPMENT_COMPOSITE_B       = 594; 
const int STAGE_EQUIPMENT_ARMOR             = 595; //e.g. armor

const int CHOICE_RETURN_TO_PREVIOUS             = 0xEFFFFFFF;


//////////////////////////////////////////////////
/* Aid functions                                */
//////////////////////////////////////////////////

void AddPortraits(int nMin, int nMax, object oPC)
{
    int i;
    string sName;
    for(i=nMin;i<nMin+100;i++)
    {
        //test for model
        if(Get2DACache("portraits", "Race", i) != "")
        {
            sName = Get2DACache("portraits", "BaseResRef", i);
            AddChoice(sName, i, oPC);
        }
    }
    if(i < nMax)
        DelayCommand(0.00, AddPortraits(i, nMax, oPC));        
}

void AddTails(int nMin, int nMax, object oPC)
{
    int i;
    string sName;
    for(i=nMin;i<nMin+100;i++)
    {
        //test for model
        if(Get2DACache("tailmodel", "MODEL", i) != "")
        {
            sName = Get2DACache("wingmodel", "LABEL", i);
            AddChoice(sName, i, oPC);
        }
    }
    if(i < nMax)
        DelayCommand(0.00, AddTails(i, nMax, oPC));        
}

void AddWings(int nMin, int nMax, object oPC)
{
    int i;
    string sName;
    for(i=nMin;i<nMin+100;i++)
    {
        //test for model
        if(Get2DACache("wingmodel", "MODEL", i) != "")
        {
            sName = Get2DACache("wingmodel", "LABEL", i);
            AddChoice(sName, i, oPC);
        }
    }
    if(i < nMax)
        DelayCommand(0.00, AddWings(i, nMax, oPC));
}

void AddAppearances(int nMin, int nMax, object oPC)
{
    int i;
    string sName;
    for(i=nMin;i<nMin+100;i++)
    {
        //test for model
        if(Get2DACache("appearance", "RACE", i) != "")
        {
            //test for tlk name
            sName = GetStringByStrRef(StringToInt(Get2DACache("appearance", "STRING_REF", i)));
            //no tlk name, use label
            if(sName == "")
                sName = Get2DACache("appearance", "LABEL", i);
            AddChoice(sName, i, oPC);
        }
    }
    if(i < nMax)
        DelayCommand(0.00, AddAppearances(i, nMax, oPC));
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
                // Set the header
                SetHeader("What aspect of your appearance do you wish to alter?");
                // Add responses for the PC
                AddChoice("Model", 1, oPC);
                int bCanHaveWings;
                int bCanHaveTail;
                string sModelType = Get2DACache("appearance", "MODELTYPE", GetAppearanceType(oPC));
                if(sModelType == "P")
                {
                    bCanHaveTail=TRUE;
                    bCanHaveWings=TRUE;
                }
                else
                {
                    if(TestStringAgainstPattern("**W**", sModelType))
                        bCanHaveWings=TRUE;
                    if(TestStringAgainstPattern("**T**", sModelType))
                        bCanHaveTail=TRUE;
                }
                if(sModelType == "P")
                    AddChoice("Head", 2, oPC);
                if(bCanHaveWings)
                    AddChoice("Wings", 3, oPC);
                if(bCanHaveTail)
                    AddChoice("Tail", 4, oPC);
                if(sModelType == "P")
                    AddChoice("Other bodypart including tattoos", 5, oPC);
                if(bCanHaveTail)
                    AddChoice("Portrait", 6, oPC);
                AddChoice("Equipment", 7, oPC);

                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_APPEARANCE)
            {
                SetHeader("Select an appearance to assume");
                AddChoice("Return to previous", CHOICE_RETURN_TO_PREVIOUS, oPC);
                AddAppearances(0, GetPRCSwitch(FILE_END_APPEARANCE), oPC);
                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_HEAD)
            {
                SetHeader("Select a head");
                AddChoice("Return to previous step", CHOICE_RETURN_TO_PREVIOUS, oPC);
                AddChoice("Goto first head", 1, oPC);
                AddChoice("Next head", 2, oPC);
                if(GetCreatureBodyPart(CREATURE_PART_HEAD, oPC) > 0)
                    AddChoice("Previous head", 3, oPC);
                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_WINGS)
            {
                SetHeader("");
                AddChoice("Return to previous step", CHOICE_RETURN_TO_PREVIOUS, oPC);
                AddWings(0, GetPRCSwitch(FILE_END_WINGS), oPC);
                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_TAIL)
            {
                SetHeader("");
                AddChoice("Return to previous step", CHOICE_RETURN_TO_PREVIOUS, oPC);
                AddTails(0, GetPRCSwitch(FILE_END_TAILS), oPC);
                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_BODYPART)
            {
                SetHeader("Which bodypart?");
                AddChoice("Return to previous step", CHOICE_RETURN_TO_PREVIOUS, oPC);
                AddChoice("Right shin",     CREATURE_PART_RIGHT_SHIN, oPC);
                AddChoice("Left shin",      CREATURE_PART_LEFT_SHIN, oPC);
                AddChoice("Right thigh",    CREATURE_PART_RIGHT_THIGH, oPC);
                AddChoice("Left thigh",     CREATURE_PART_LEFT_THIGH, oPC);
                AddChoice("Torso",          CREATURE_PART_TORSO, oPC);
                AddChoice("Right forearm",  CREATURE_PART_RIGHT_FOREARM, oPC);
                AddChoice("Left forearm",   CREATURE_PART_LEFT_FOREARM, oPC);
                AddChoice("Right bicep",    CREATURE_PART_RIGHT_BICEP, oPC);
                AddChoice("Left bicep",     CREATURE_PART_LEFT_BICEP, oPC);
                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_BODYPART_CHANGE)
            {
                SetHeader("Select a change");
                AddChoice("Return to previous step", CHOICE_RETURN_TO_PREVIOUS, oPC);
                AddChoice("Goto first bodypart", 1, oPC);
                AddChoice("Next bodypart", 2, oPC);
                int nPart = GetLocalInt(oPC, "BodypartToChange");
                if(GetCreatureBodyPart(nPart, oPC) > 0)
                    AddChoice("Previous bodypart", 3, oPC);
                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_PORTRAIT)
            {
                SetHeader("Select a portrait");
                AddChoice("Return to previous step", CHOICE_RETURN_TO_PREVIOUS, oPC);
                AddPortraits(0, GetPRCSwitch(FILE_END_PORTRAITS), oPC);
                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_EQUIPMENT)
            {
                SetHeader("Select a piece of equipment to modify");
                AddChoice("Return to previous step", CHOICE_RETURN_TO_PREVIOUS, oPC);
                if(!array_exists(oPC, "PRC_ItemsToUse"))
                {
                    array_create(oPC, "PRC_ItemsToUse");
                    int nSlot;
                    for(nSlot = 0; nSlot < 14; nSlot++)
                    {
                        object oItem = GetItemInSlot(nSlot, oPC);
                        //only modify identified items
                        if(GetIsObjectValid(oItem)  
                            && GetIdentified(oItem))
                        {
                            AddChoice(GetName(oItem), array_get_size(oPC, "PRC_ItemsToUse"));
                            array_set_object(oPC, "PRC_ItemsToUse", array_get_size(oPC, "PRC_ItemsToUse"), oItem);
                        }
                    }
                    object oItem = GetFirstItemInInventory(oPC);
                    while(GetIsObjectValid(oItem))
                    {
                        //only modify identified items
                        if(GetIdentified(oItem))
                        {
                            AddChoice(GetName(oItem), array_get_size(oPC, "PRC_ItemsToUse"));
                            array_set_object(oPC, "PRC_ItemsToUse", array_get_size(oPC, "PRC_ItemsToUse"), oItem);
                        }
                        oItem = GetNextItemInInventory(oPC);
                    }
                }
                else
                {
                    int i;
                    for(i=0;i<array_get_size(oPC, "PRC_ItemsToUse");i++)
                    {
                        object oItem = array_get_object(oPC, "PRC_ItemsToUse", i);
                        AddChoice(GetName(oItem), i);
                    }
                }

                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_EQUIPMENT_SIMPLE)
            {
                SetHeader("How do you wish to modify this item?");
                AddChoice("Return to previous step", CHOICE_RETURN_TO_PREVIOUS, oPC);
                AddChoice("Previous appearance", 1, oPC);
                AddChoice("Next appearance", 2, oPC);
                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_EQUIPMENT_LAYERED)
            {
                SetHeader("How do you wish to modify this item?");
                AddChoice("Return to previous step", CHOICE_RETURN_TO_PREVIOUS, oPC);
                AddChoice("Previous appearance",    1, oPC);
                AddChoice("Next appearance",        2, oPC);
                AddChoice("Previous cloth1 color",  3, oPC);
                AddChoice("Next cloth1 color",      4, oPC);
                AddChoice("Previous cloth2 color",  5, oPC);
                AddChoice("Next cloth2 color",      6, oPC);
                AddChoice("Previous leather1 color",7, oPC);
                AddChoice("Next leather1 color",    8, oPC);
                AddChoice("Previous leather2 color",9, oPC);
                AddChoice("Next leather2 color",   10, oPC);
                AddChoice("Previous metal1 color", 11, oPC);
                AddChoice("Next metal1 color",     12, oPC);
                AddChoice("Previous metal2 color", 13, oPC);
                AddChoice("Next metal2 color",     14, oPC);
                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_EQUIPMENT_COMPOSITE)
            {
                SetHeader("How do you wish to modify this item?");
                AddChoice("Return to previous step", CHOICE_RETURN_TO_PREVIOUS, oPC);
                AddChoice("Previous bottom part appearance",    1, oPC);
                AddChoice("Next bottom part appearance",        2, oPC);
                AddChoice("Previous bottom part color",         3, oPC);
                AddChoice("Next bottom part color",             4, oPC);
                AddChoice("Previous middle part appearance",    5, oPC);
                AddChoice("Next middle part appearance",        6, oPC);
                AddChoice("Previous middle part color",         7, oPC);
                AddChoice("Next middle part color",             8, oPC);
                AddChoice("Previous top part appearance",    9, oPC);
                AddChoice("Next top part appearance",       10, oPC);
                AddChoice("Previous top part color",        11, oPC);
                AddChoice("Next top part color",            12, oPC);
                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_EQUIPMENT_ARMOR)
            {
                SetHeader("How do you wish to modify this item?");
                AddChoice("Return to previous step", CHOICE_RETURN_TO_PREVIOUS, oPC);
                //cant change model yet
                AddChoice("Previous cloth1 color",  3, oPC);
                AddChoice("Next cloth1 color",      4, oPC);
                AddChoice("Previous cloth2 color",  5, oPC);
                AddChoice("Next cloth2 color",      6, oPC);
                AddChoice("Previous leather1 color",7, oPC);
                AddChoice("Next leather1 color",    8, oPC);
                AddChoice("Previous leather2 color",9, oPC);
                AddChoice("Next leather2 color",   10, oPC);
                AddChoice("Previous metal1 color", 11, oPC);
                AddChoice("Next metal1 color",     12, oPC);
                AddChoice("Previous metal2 color", 13, oPC);
                AddChoice("Next metal2 color",     14, oPC);
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
        DeleteLocalInt(oPC, "BodypartToChange");
        array_delete(oPC, "PRC_ItemsToUse");
        DeleteLocalObject(oPC, "PRC_ItemToUse");
    }
    // Abort conversation cleanup.
    // NOTE: This section is only run when the conversation is aborted
    // while aborting is allowed. When it isn't, the dynconvo infrastructure
    // handles restoring the conversation in a transparent manner
    else if(nValue == DYNCONV_ABORTED)
    {
        // Add any locals set through this conversation
        DeleteLocalInt(oPC, "BodypartToChange");
        array_delete(oPC, "PRC_ItemsToUse");
        DeleteLocalObject(oPC, "PRC_ItemToUse");
    }
    // Handle PC responses
    else
    {
        // variable named nChoice is the value of the player's choice as stored when building the choice list
        // variable named nStage determines the current conversation node
        int nOldStage = nStage;
        int nChoice = GetChoice(oPC);
        if(nStage == STAGE_ENTRY)
        {
            if(nChoice == 1)
                nStage = STAGE_APPEARANCE;
            else if(nChoice == 2)
                nStage = STAGE_HEAD;
            else if(nChoice == 3)
                nStage = STAGE_WINGS;
            else if(nChoice == 4)
                nStage = STAGE_TAIL;
            else if(nChoice == 5)
                nStage = STAGE_BODYPART;
            else if(nChoice == 6)
                nStage = STAGE_PORTRAIT;
            else if(nChoice == 7)
                nStage = STAGE_EQUIPMENT;
        }
        else if(nStage == STAGE_APPEARANCE)
        {
            if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
                nStage = STAGE_ENTRY;
            else
                SetCreatureAppearanceType(oPC, nChoice);    
             
        }
        else if(nStage == STAGE_HEAD)
        {
            if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
                nStage = STAGE_ENTRY;
            else
            {
                //need to regenerate the list so go lower disappears correctly
                MarkStageNotSetUp(nStage, oPC); 
                if(nChoice == 1)
                    SetCreatureBodyPart(CREATURE_PART_HEAD, 1, oPC);   
                else if(nChoice == 2)
                    SetCreatureBodyPart(CREATURE_PART_HEAD, GetCreatureBodyPart(CREATURE_PART_HEAD, oPC)+1, oPC);  
                else if(nChoice == 3)
                    SetCreatureBodyPart(CREATURE_PART_HEAD, GetCreatureBodyPart(CREATURE_PART_HEAD, oPC)-1, oPC);   
            }    
             
        }
        else if(nStage == STAGE_WINGS)
        {
            if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
                nStage = STAGE_ENTRY;
            else
                SetCreatureWingType(nChoice, oPC);    
             
        }
        else if(nStage == STAGE_TAIL)
        {
            if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
                nStage = STAGE_ENTRY;
            else
                SetCreatureTailType(nChoice, oPC);    
             
        }
        else if(nStage == STAGE_BODYPART)
        {
            if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
                nStage = STAGE_ENTRY;
            else
            {
                SetLocalInt(oPC, "BodypartToChange", nChoice);
                nStage = STAGE_BODYPART_CHANGE;
            }
        }    
        else if(nStage == STAGE_BODYPART_CHANGE)
        {
            if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
                nStage = STAGE_BODYPART;
            else
            {
                int nPart = GetLocalInt(oPC, "BodypartToChange");
                if(nChoice == 1)
                    SetCreatureBodyPart(nPart, 1, oPC);   
                else if(nChoice == 2)
                    SetCreatureBodyPart(nPart, GetCreatureBodyPart(nPart, oPC)+1, oPC);  
                else if(nChoice == 3)
                    SetCreatureBodyPart(nPart, GetCreatureBodyPart(nPart, oPC)-1, oPC);  
            
            }
        }  
        else if(nStage == STAGE_PORTRAIT)
        {  
            if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
                nStage = STAGE_ENTRY;
            else
            {
                string sPortraitResRef = Get2DACache("portraits", "BaseResRef", nChoice);
                sPortraitResRef = GetStringLeft(sPortraitResRef, GetStringLength(sPortraitResRef)-1); //trim the trailing _
                SetPortraitResRef(oPC, sPortraitResRef);
                SetPortraitId(oPC, nChoice);
            }
        }
        else if(nStage == STAGE_EQUIPMENT)
        {
            if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
                nStage = STAGE_ENTRY;
            else
            {
                object oItem = array_get_object(oPC, "PRC_ItemsToUse", nChoice);
                SetLocalObject(oPC, "PRC_ItemToUse", oItem);
                //clean up the array so it regenerates properly
                array_delete(oPC, "PRC_ItemsToUse");
                int nBase = GetBaseItemType(oItem);
                int nAppearType = StringToInt(Get2DACache("baseitems", "ModelType", nBase));
                if(nAppearType == 0)
                    nStage = STAGE_EQUIPMENT_SIMPLE;
                else if(nAppearType == 1)
                    nStage = STAGE_EQUIPMENT_LAYERED;
                else if(nAppearType == 2)
                    nStage = STAGE_EQUIPMENT_COMPOSITE;
                else if(nAppearType == 3)
                    nStage = STAGE_EQUIPMENT_ARMOR;    
                else
                    //something odd here
                    nStage = STAGE_ENTRY;
            }
        }
        else if(nStage == STAGE_EQUIPMENT_SIMPLE
            || nStage == STAGE_EQUIPMENT_LAYERED
            || nStage == STAGE_EQUIPMENT_COMPOSITE
            || nStage == STAGE_EQUIPMENT_ARMOR)
        {
            if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
                nStage = STAGE_ENTRY;
            else
            {
                object oItem = GetLocalObject(oPC, "PRC_ItemToUse");
                int nSlot = -1;
                int i;
                for(i = 0; i<14;i++)
                {
                    if(GetItemInSlot(i, oPC) == oItem)
                        nSlot = i;
                }
                //move to limbo
                object oChest = GetObjectByTag("HEARTOFCHAOS");
                object oNewItem = CopyItem(oItem, oChest, TRUE);
                DestroyObject(oNewItem);
                if(nStage == STAGE_EQUIPMENT_SIMPLE)
                {
                    if(nChoice == 1)        //previous
                        oNewItem = CopyItemAndModify(oNewItem, ITEM_APPR_TYPE_SIMPLE_MODEL, -1, 
                            GetItemAppearance(oItem, ITEM_APPR_TYPE_SIMPLE_MODEL, -1)-1, TRUE);
                    else if(nChoice == 2)   //next
                        oNewItem = CopyItemAndModify(oNewItem, ITEM_APPR_TYPE_SIMPLE_MODEL, -1, 
                            GetItemAppearance(oItem, ITEM_APPR_TYPE_SIMPLE_MODEL, -1)+1, TRUE);
                }        
                else if(nStage == STAGE_EQUIPMENT_LAYERED)
                {
                    if(nChoice == 1)        //previous appearance
                        oNewItem = CopyItemAndModify(oNewItem, ITEM_APPR_TYPE_SIMPLE_MODEL, -1, 
                            GetItemAppearance(oItem, ITEM_APPR_TYPE_SIMPLE_MODEL, -1)-1, TRUE);
                    else if(nChoice == 2)   //next appearance
                        oNewItem = CopyItemAndModify(oNewItem, ITEM_APPR_TYPE_SIMPLE_MODEL, -1, 
                            GetItemAppearance(oItem, ITEM_APPR_TYPE_SIMPLE_MODEL, -1)+1, TRUE);
                    else if(nChoice == 3)   //previous cloth1
                        oNewItem = CopyItemAndModify(oNewItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH1, 
                            GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH1)-1, TRUE);
                    else if(nChoice == 4)   //next cloth1
                        oNewItem = CopyItemAndModify(oNewItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH1, 
                            GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH1)+1, TRUE);
                    else if(nChoice == 5)   //previous cloth2
                        oNewItem = CopyItemAndModify(oNewItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH2, 
                            GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH2)-1, TRUE);
                    else if(nChoice == 6)   //next cloth2
                        oNewItem = CopyItemAndModify(oNewItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH2, 
                            GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH2)+1, TRUE);
                    else if(nChoice == 7)   //previous leather1
                        oNewItem = CopyItemAndModify(oNewItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER1, 
                            GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER1)-1, TRUE);
                    else if(nChoice == 8)   //next leather1
                        oNewItem = CopyItemAndModify(oNewItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER1, 
                            GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER1)+1, TRUE);
                    else if(nChoice == 9)   //previous leather2
                        oNewItem = CopyItemAndModify(oNewItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER2, 
                            GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER2)-1, TRUE);
                    else if(nChoice == 10)   //next leather2
                        oNewItem = CopyItemAndModify(oNewItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER2, 
                            GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER2)+1, TRUE);
                    else if(nChoice == 11)   //previous metal1
                        oNewItem = CopyItemAndModify(oNewItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL1, 
                            GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL1)-1, TRUE);
                    else if(nChoice == 12)   //next metal1
                        oNewItem = CopyItemAndModify(oNewItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL1, 
                            GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL1)+1, TRUE);
                    else if(nChoice == 13)   //previous metal2
                        oNewItem = CopyItemAndModify(oNewItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL2, 
                            GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL2)-1, TRUE);
                    else if(nChoice == 14)   //next metal2
                        oNewItem = CopyItemAndModify(oNewItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL2, 
                            GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL2)+1, TRUE);
                }
                else if(nStage == STAGE_EQUIPMENT_COMPOSITE)
                {
                    if(nChoice == 1)        //previous part 1 appearance
                        oNewItem = CopyItemAndModify(oNewItem, ITEM_APPR_TYPE_WEAPON_MODEL, ITEM_APPR_WEAPON_MODEL_BOTTOM, 
                            GetItemAppearance(oItem, ITEM_APPR_TYPE_WEAPON_MODEL, ITEM_APPR_WEAPON_MODEL_BOTTOM)-1, TRUE);
                    else if(nChoice == 2)   //next part 1 appearance
                        oNewItem = CopyItemAndModify(oNewItem, ITEM_APPR_TYPE_WEAPON_MODEL, ITEM_APPR_WEAPON_MODEL_BOTTOM, 
                            GetItemAppearance(oItem, ITEM_APPR_TYPE_WEAPON_MODEL, ITEM_APPR_WEAPON_MODEL_BOTTOM)+1, TRUE);
                    else if(nChoice == 3)   //previous part 1 color
                        oNewItem = CopyItemAndModify(oNewItem, ITEM_APPR_TYPE_WEAPON_COLOR, ITEM_APPR_WEAPON_COLOR_BOTTOM, 
                            GetItemAppearance(oItem, ITEM_APPR_TYPE_WEAPON_COLOR, ITEM_APPR_WEAPON_COLOR_BOTTOM)-1, TRUE);
                    else if(nChoice == 4)   //next part 1 color
                        oNewItem = CopyItemAndModify(oNewItem, ITEM_APPR_TYPE_WEAPON_COLOR, ITEM_APPR_WEAPON_COLOR_BOTTOM, 
                            GetItemAppearance(oItem, ITEM_APPR_TYPE_WEAPON_COLOR, ITEM_APPR_WEAPON_COLOR_BOTTOM)+1, TRUE);
                    else if(nChoice == 5)   //previous part 2 appearance
                        oNewItem = CopyItemAndModify(oNewItem, ITEM_APPR_TYPE_WEAPON_MODEL, ITEM_APPR_WEAPON_MODEL_MIDDLE, 
                            GetItemAppearance(oItem, ITEM_APPR_TYPE_WEAPON_MODEL, ITEM_APPR_WEAPON_MODEL_MIDDLE)-1, TRUE);
                    else if(nChoice == 6)   //next part 2 appearance
                        oNewItem = CopyItemAndModify(oNewItem, ITEM_APPR_TYPE_WEAPON_MODEL, ITEM_APPR_WEAPON_MODEL_MIDDLE, 
                            GetItemAppearance(oItem, ITEM_APPR_TYPE_WEAPON_MODEL, ITEM_APPR_WEAPON_MODEL_MIDDLE)+1, TRUE);
                    else if(nChoice == 7)   //previous part 2 color
                        oNewItem = CopyItemAndModify(oNewItem, ITEM_APPR_TYPE_WEAPON_COLOR, ITEM_APPR_WEAPON_COLOR_MIDDLE, 
                            GetItemAppearance(oItem, ITEM_APPR_TYPE_WEAPON_COLOR, ITEM_APPR_WEAPON_COLOR_MIDDLE)-1, TRUE);
                    else if(nChoice == 8)   //next part 2 color
                        oNewItem = CopyItemAndModify(oNewItem, ITEM_APPR_TYPE_WEAPON_COLOR, ITEM_APPR_WEAPON_COLOR_MIDDLE, 
                            GetItemAppearance(oItem, ITEM_APPR_TYPE_WEAPON_COLOR, ITEM_APPR_WEAPON_COLOR_MIDDLE)+1, TRUE);
                    else if(nChoice == 9)   //previous part 3 appearance
                        oNewItem = CopyItemAndModify(oNewItem, ITEM_APPR_TYPE_WEAPON_MODEL, ITEM_APPR_WEAPON_MODEL_TOP, 
                            GetItemAppearance(oItem, ITEM_APPR_TYPE_WEAPON_MODEL, ITEM_APPR_WEAPON_MODEL_TOP)-1, TRUE);
                    else if(nChoice == 10)  //next part 3 appearance
                        oNewItem = CopyItemAndModify(oNewItem, ITEM_APPR_TYPE_WEAPON_MODEL, ITEM_APPR_WEAPON_MODEL_TOP, 
                            GetItemAppearance(oItem, ITEM_APPR_TYPE_WEAPON_MODEL, ITEM_APPR_WEAPON_MODEL_TOP)+1, TRUE);
                    else if(nChoice == 11)   //previous part 3 color
                        oNewItem = CopyItemAndModify(oNewItem, ITEM_APPR_TYPE_WEAPON_COLOR, ITEM_APPR_WEAPON_COLOR_TOP, 
                            GetItemAppearance(oItem, ITEM_APPR_TYPE_WEAPON_COLOR, ITEM_APPR_WEAPON_COLOR_TOP)-1, TRUE);
                    else if(nChoice == 12)   //next part 3 color
                        oNewItem = CopyItemAndModify(oNewItem, ITEM_APPR_TYPE_WEAPON_COLOR, ITEM_APPR_WEAPON_COLOR_TOP, 
                            GetItemAppearance(oItem, ITEM_APPR_TYPE_WEAPON_COLOR, ITEM_APPR_WEAPON_COLOR_TOP)+1, TRUE);
                }
                else if(nStage == STAGE_EQUIPMENT_ARMOR)
                {
                //cant change model yet
                    if(nChoice == 3)   //previous cloth1
                        oNewItem = CopyItemAndModify(oNewItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH1, 
                            GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH1)-1, TRUE);
                    else if(nChoice == 4)   //next cloth1
                        oNewItem = CopyItemAndModify(oNewItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH1, 
                            GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH1)+1, TRUE);
                    else if(nChoice == 5)   //previous cloth2
                        oNewItem = CopyItemAndModify(oNewItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH2, 
                            GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH2)-1, TRUE);
                    else if(nChoice == 6)   //next cloth2
                        oNewItem = CopyItemAndModify(oNewItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH2, 
                            GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH2)+1, TRUE);
                    else if(nChoice == 7)   //previous leather1
                        oNewItem = CopyItemAndModify(oNewItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER1, 
                            GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER1)-1, TRUE);
                    else if(nChoice == 8)   //next leather1
                        oNewItem = CopyItemAndModify(oNewItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER1, 
                            GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER1)+1, TRUE);
                    else if(nChoice == 9)   //previous leather2
                        oNewItem = CopyItemAndModify(oNewItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER2, 
                            GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER2)-1, TRUE);
                    else if(nChoice == 10)   //next leather2
                        oNewItem = CopyItemAndModify(oNewItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER2, 
                            GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER2)+1, TRUE);
                    else if(nChoice == 11)   //previous metal1
                        oNewItem = CopyItemAndModify(oNewItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL1, 
                            GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL1)-1, TRUE);
                    else if(nChoice == 12)   //next metal1
                        oNewItem = CopyItemAndModify(oNewItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL1, 
                            GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL1)+1, TRUE);
                    else if(nChoice == 13)   //previous metal2
                        oNewItem = CopyItemAndModify(oNewItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL2, 
                            GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL2)-1, TRUE);
                    else if(nChoice == 14)   //next metal2
                        oNewItem = CopyItemAndModify(oNewItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL2, 
                            GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL2)+1, TRUE);
                }
                //new appearance valid
                if(GetIsObjectValid(oNewItem))
                {
                    DestroyObject(oNewItem);
                    DestroyObject(oItem);
                    oNewItem = CopyItem(oNewItem, oPC, TRUE);
                    if(nSlot != -1)
                        AssignCommand(oPC, ActionEquipItem(oNewItem, nSlot));
                    //store the new version as the local item
                    //so it can be remodified
                    SetLocalObject(oPC, "PRC_ItemToUse", oNewItem);
                }
            }    
        }
        if(nStage != nOldStage)
            MarkStageNotSetUp(nStage, oPC); 
        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
