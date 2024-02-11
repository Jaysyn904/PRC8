/*
    forge_conv

    Dynamic conversation file for forge, modified from
        psi_powconv, borrowed from prc_ccc

    By: Flaming_Sword
    Created: January 2, 2006
    Modified: January 12, 2006

    LIMITATIONS:
        ITEM_PROPERTY_BONUS_FEAT
            not all feats available, anything much higher killed the game
            some of the feats added can be silly (blame the 2das)
        IPRP_SPELLS
            anything involving this 2da file can only use the bioware spells
                since anything much higher produced TMIs
        Not all item properties have returning functions
        Needs updating if item property 2da files increase in size

    USE:
        Place this script in the OnUsed event of a placable object
        Placeable must be plot, have inventory, locked

    CHECK:
        89 properties with constants, 15 without
*/

#include "forge_include"
#include "inc_dynconv"


//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

//const int STAGE_                        = ;

const int STAGE_START                   = 0;
const int STAGE_SELECT_ITEM             = 1;
const int STAGE_SELECT_TYPE             = 2;
const int STAGE_SELECT_SUBTYPE          = 3;
const int STAGE_SELECT_COSTTABLEVALUE   = 4;
const int STAGE_SELECT_PARAM1VALUE      = 5;
const int STAGE_CONFIRM                 = 6;

//const int CHOICE_                       = ;

const int CHOICE_FORGE                  = 20001;
const int CHOICE_BOOST                  = 20002;
const int CHOICE_BACK                   = 20003;
const int CHOICE_CLEAR                  = 20004;
const int CHOICE_CONFIRM                = 20005;
const int CHOICE_SETNAME                = 20006;

//const int NUM_MAX_COSTTABLEVALUES       = 70;
//const int NUM_MAX_PARAM1VALUES          = 70;

const int HAS_SUBTYPE                   = 1;
const int HAS_COSTTABLE                 = 2;
const int HAS_PARAM1                    = 4;

const int STRREF_YES                = 4752;     // "Yes"
const int STRREF_NO                 = 4753;     // "No"


const int SORT       = TRUE; // If the sorting takes too much CPU, set to FALSE
const int DEBUG_LIST = FALSE;
//////////////////////////////////////////////////
/* Function defintions                          */
//////////////////////////////////////////////////

void PrintList(object oPC)
{
    string tp = "Printing list:\n";
    string s = GetLocalString(oPC, "ForgeConvo_List_Head");
    if(s == ""){
        tp += "Empty\n";
    }
    else{
        tp += s + "\n";
        s = GetLocalString(oPC, "ForgeConvo_List_Next_" + s);
        while(s != ""){
            tp += "=> " + s + "\n";
            s = GetLocalString(oPC, "ForgeConvo_List_Next_" + s);
        }
    }

    DoDebug(tp);
}

/**
 * Creates a linked list of entries that is sorted into alphabetical order
 * as it is built.
 * Assumption: Power names are unique.
 *
 * @param oPC     The storage object aka whomever is gaining powers in this conversation
 * @param sChoice The choice string
 * @param nChoice The choice value
 */

void AddToTempList(object oPC, string sChoice, int nChoice)
{
    if(DEBUG_LIST) DoDebug("\nAdding to temp list: '" + sChoice + "' - " + IntToString(nChoice));
    if(DEBUG_LIST) PrintList(oPC);
    // If there is nothing yet
    if(!GetLocalInt(oPC, "ForgeConvo_ListInited"))
    {
        SetLocalString(oPC, "ForgeConvo_List_Head", sChoice);
        SetLocalInt(oPC, "ForgeConvo_List_" + sChoice, nChoice);

        SetLocalInt(oPC, "ForgeConvo_ListInited", TRUE);
    }
    else
    {
        // Find the location to instert into
        string sPrev = "", sNext = GetLocalString(oPC, "ForgeConvo_List_Head");
        while(sNext != "" && StringCompare(sChoice, sNext) >= 0)
        {
            if(DEBUG_LIST) DoDebug("Comparison between '" + sChoice + "' and '" + sNext + "' = " + IntToString(StringCompare(sChoice, sNext)));
            sPrev = sNext;
            sNext = GetLocalString(oPC, "ForgeConvo_List_Next_" + sNext);
        }

        // Insert the new entry
        // Does it replace the head?
        if(sPrev == "")
        {
            if(DEBUG_LIST) DoDebug("New head");
            SetLocalString(oPC, "ForgeConvo_List_Head", sChoice);
        }
        else
        {
            if(DEBUG_LIST) DoDebug("Inserting into position between '" + sPrev + "' and '" + sNext + "'");
            SetLocalString(oPC, "ForgeConvo_List_Next_" + sPrev, sChoice);
        }

        SetLocalString(oPC, "ForgeConvo_List_Next_" + sChoice, sNext);
        SetLocalInt(oPC, "ForgeConvo_List_" + sChoice, nChoice);
    }
}

/**
 * Reads the linked list built with AddToTempList() to AddChoice() and
 * deletes it.
 *
 * @param oPC A PC gaining powers at the moment
 */

void TransferTempList(object oPC)
{
    string sChoice = GetLocalString(oPC, "ForgeConvo_List_Head");
    int    nChoice = GetLocalInt   (oPC, "ForgeConvo_List_" + sChoice);

    DeleteLocalString(oPC, "ForgeConvo_List_Head");
    string sPrev;

    if(DEBUG_LIST) DoDebug("Head is: '" + sChoice + "' - " + IntToString(nChoice));

    while(sChoice != "")
    {
        // Add the choice
        AddChoice(sChoice, nChoice, oPC);

        // Get next
        sChoice = GetLocalString(oPC, "ForgeConvo_List_Next_" + (sPrev = sChoice));
        nChoice = GetLocalInt   (oPC, "ForgeConvo_List_" + sChoice);

        if(DEBUG_LIST) DoDebug("Next is: '" + sChoice + "' - " + IntToString(nChoice) + "; previous = '" + sPrev + "'");

        // Delete the already handled data
        DeleteLocalString(oPC, "ForgeConvo_List_Next_" + sPrev);
        DeleteLocalInt   (oPC, "ForgeConvo_List_" + sPrev);
    }

    DeleteLocalInt(oPC, "ForgeConvo_ListInited");
}

//Returns the next conversation stage according
//  to item property
int GetNextItemPropStage(int nStage, object oPC, int nPropList)
{
    nStage++;
    if(nStage == STAGE_SELECT_SUBTYPE && !(nPropList & HAS_SUBTYPE))
        nStage++;
    if(nStage == STAGE_SELECT_COSTTABLEVALUE && !(nPropList & HAS_COSTTABLE))
        nStage++;
    if(nStage == STAGE_SELECT_PARAM1VALUE && !(nPropList & HAS_PARAM1))
        nStage++;
    MarkStageNotSetUp(nStage, oPC);
    return nStage;
}

//Returns the previous conversation stage according
//  to item property
int GetPrevItemPropStage(int nStage, object oPC, int nPropList)
{
    nStage--;
    if(nStage == STAGE_SELECT_PARAM1VALUE && !(nPropList & HAS_PARAM1))
        nStage--;
    if(nStage == STAGE_SELECT_COSTTABLEVALUE && !(nPropList & HAS_COSTTABLE))
        nStage--;
    if(nStage == STAGE_SELECT_SUBTYPE && !(nPropList & HAS_SUBTYPE))
        nStage--;
    MarkStageNotSetUp(nStage, oPC);
    return nStage;
}

//Adds names to a list based on sTable (2da), delayed recursion
//  to avoid TMI
void PopulateList(object oPC, int MaxValue, int bSort, string sTable, int nStage, int nBase, int i = 0)
{
    if(GetLocalInt(oPC, "DynConv_Waiting") == FALSE)
        return;
    int bValid = TRUE;
    string sTemp = "";
    if(i < MaxValue)
    {
        if(nStage == STAGE_SELECT_TYPE) bValid = ValidProperty(nBase, i);
        sTemp = Get2DACache(sTable, "Name", i);
        if((sTemp != "") && bValid)//this is going to kill
        {
            if(bSort)   AddToTempList(oPC, ActionString(GetStringByStrRef(StringToInt(sTemp))), i);
            else        AddChoice(ActionString(GetStringByStrRef(StringToInt(sTemp))), i, oPC);
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
    DelayCommand(0.01, PopulateList(oPC, MaxValue, bSort, sTable, nStage, nBase, i + 1));
}

void main()
{
    object oPC = GetPCSpeaker();
    if(!(GetIsObjectValid(oPC) || IsInConversation(GetLastUsedBy())))
    {
        oPC = GetLastUsedBy();
        StartDynamicConversation("forge_conv", oPC, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, OBJECT_SELF);
        return;
    }
    int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);
    int nStage = GetStage(oPC);

    object oItem = GetLocalObject(oPC, "Forge_Item");
    int nType = GetLocalInt(oPC, "Forge_Type");
    string sSubtype = GetLocalString(oPC, "Forge_SubType");
    int nSubTypeValue = GetLocalInt(oPC, "Forge_SubTypeValue");
    string sCostTable = GetLocalString(oPC, "Forge_CostTable");
    int nCostTableValue = GetLocalInt(oPC, "Forge_CostTableValue");
    string sParam1 = GetLocalString(oPC, "Forge_Param1");
    int nParam1Value = GetLocalInt(oPC, "Forge_Param1Value");

    int nBase = GetBaseItemType(oItem);
    object oNewItem = GetFirstItemInInventory(OBJECT_SELF);
    int nPropList = GetLocalInt(oPC, "Forge_PropList");
    int nCost = GetLocalInt(oPC, "Forge_Cost");

    string sTemp = "";
    int nTemp = 0;

    // Check which of the conversation scripts called the scripts
    if(nValue == 0) // All of them set the DynConv_Var to non-zero value, so something is wrong -> abort
        return;

    if(nValue == DYNCONV_SETUP_STAGE)
    {
        //if(DEBUG) DoDebug("forge_conv: Running setup stage for stage " + IntToString(nStage));
        // Check if this stage is marked as already set up
        // This stops list duplication when scrolling
        if(!GetIsStageSetUp(nStage, oPC))
        {
            int i;
            switch(nStage)
            {
                case STAGE_START:
                {
                    SetHeader("Please make a selection.");
                    SetDefaultTokens();
                    AddChoice(ActionString("Forge Item"), CHOICE_FORGE, oPC);
                    AddChoice(ActionString("Boost Crafting Skills For 24 Hours"), CHOICE_BOOST, oPC);
                    SetCustomToken(DYNCONV_TOKEN_EXIT, ActionString("Leave"));
                    SetCustomToken(DYNCONV_TOKEN_NEXT, ActionString("Next"));
                    SetCustomToken(DYNCONV_TOKEN_PREV, ActionString("Previous"));
                    AllowExit(DYNCONV_EXIT_ALLOWED_SHOW_CHOICE, FALSE, oPC);
                    MarkStageSetUp(nStage, oPC);
                    break;
                }
                case STAGE_SELECT_ITEM:
                {
                    SetHeader("Select an equipped item to forge.");
                    AllowExit(DYNCONV_EXIT_NOT_ALLOWED, FALSE, oPC);
                    AddChoice(ActionString("Back"), CHOICE_BACK, oPC);
                    for(i = 0; i < 14; i++) //no creature items
                    {
                        sTemp = GetName(GetItemInSlot(i, oPC));
                        if(sTemp != "")
                            AddChoice(ActionString(sTemp), i, oPC);
                    }
                    MarkStageSetUp(nStage, oPC);
                    break;
                }
                case STAGE_SELECT_TYPE:
                {
                    SetHeader(ItemStats(oItem) + "\nSelect an item property.");
                    AddChoice(ActionString("Back"), CHOICE_BACK, oPC);
                    AddChoice(ActionString("Remove all item properties") +
                            " [<cþ>WARNING</c>]",
                        CHOICE_CLEAR, oPC);
                    AddChoice(ActionString("Change Name"), CHOICE_SETNAME, oPC);
                    SetLocalInt(oPC, "DynConv_Waiting", TRUE);
                    SetLocalInt(oPC, "Forge_Type", -1);
                    SetLocalString(oPC, "Forge_SubType", "");
                    SetLocalInt(oPC, "Forge_SubTypeValue", -1);
                    SetLocalString(oPC, "Forge_CostTable", "");
                    SetLocalInt(oPC, "Forge_CostTableValue", -1);
                    SetLocalString(oPC, "Forge_Param1", "");
                    SetLocalInt(oPC, "Forge_Param1Value", -1);
                    PopulateList(oPC, NUM_MAX_PROPERTIES, TRUE, "itempropdef", nStage, nBase);
                    MarkStageSetUp(nStage);
                    break;
                }
                case STAGE_SELECT_SUBTYPE:
                {
                    SetHeader("Select a subtype.");
                    AddChoice(ActionString("Back"), CHOICE_BACK, oPC);
                    nTemp = MaxListSize(sSubtype);
                    SetLocalInt(oPC, "DynConv_Waiting", TRUE);
                    PopulateList(oPC, nTemp, TRUE, sSubtype, nStage, nBase);
                    MarkStageSetUp(nStage);
                    break;
                }
                case STAGE_SELECT_COSTTABLEVALUE:
                {
                    SetHeader("Select a costtable value.");
                    AddChoice(ActionString("Back"), CHOICE_BACK, oPC);
                    nTemp = MaxListSize(sCostTable);
                    SetLocalInt(oPC, "DynConv_Waiting", TRUE);
                    PopulateList(oPC, nTemp, FALSE, sCostTable, nStage, nBase);
                    MarkStageSetUp(nStage);
                    break;
                }
                case STAGE_SELECT_PARAM1VALUE:
                {
                    SetHeader("Select a param1 value.");
                    AddChoice(ActionString("Back"), CHOICE_BACK, oPC);
                    nTemp = MaxListSize(sParam1);
                    SetLocalInt(oPC, "DynConv_Waiting", TRUE);
                    PopulateList(oPC, nTemp, FALSE, sParam1, nStage, nBase);
                    MarkStageSetUp(nStage);
                    break;
                }
                case STAGE_CONFIRM:
                {
                    itemproperty ip = ConstructIP(nType, nSubTypeValue, nCostTableValue, nParam1Value);
                    IPSafeAddItemProperty(oNewItem, ip, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
                    nTemp = GetGoldPieceValue(oNewItem) - GetGoldPieceValue(oItem);
                    SetLocalInt(oPC, "Forge_Cost", nTemp);
                    sTemp = InsertSpaceAfterString(GetStringByStrRef(StringToInt(Get2DACache("itempropdef", "GameStrRef", nType))));
                    if(sSubtype != "")
                        sTemp += InsertSpaceAfterString(GetStringByStrRef(StringToInt(Get2DACache(sSubtype, "Name", nSubTypeValue))));
                    if(sCostTable != "")
                        sTemp += InsertSpaceAfterString(GetStringByStrRef(StringToInt(Get2DACache(sCostTable, "Name", nCostTableValue))));
                    if(sParam1 != "")
                        sTemp += InsertSpaceAfterString(GetStringByStrRef(StringToInt(Get2DACache(sParam1, "Name", nParam1Value))));
                    sTemp += "\n\nCost: " + IntToString(nTemp);
                    SetHeader("You have selected:\n\n" + sTemp + "\n\nPlease confirm your selection.");
                    AddChoice(ActionString("Back"), CHOICE_BACK, oPC);
                    if(GetGold(oPC) >= nTemp)
                        AddChoice(ActionString("Confirm"), CHOICE_CONFIRM, oPC);
                    MarkStageSetUp(nStage);
                    break;
                }
                default:
                {
                    if(DEBUG) DoDebug("Invalid Stage: " + IntToString(nStage));
                    break;
                }
            }
        }
        // Do token setup
        SetupTokens();
    }
    else if(nValue == DYNCONV_EXITED)
    {
        if(DEBUG) DoDebug("forge_conv: Running exit handler");
        // End of conversation cleanup
        DeleteLocalObject(oPC, "Forge_Item");
        DeleteLocalInt(oPC, "Forge_Type");
        DeleteLocalString(oPC, "Forge_SubType");
        DeleteLocalInt(oPC, "Forge_SubTypeValue");
        DeleteLocalString(oPC, "Forge_CostTable");
        DeleteLocalInt(oPC, "Forge_CostTableValue");
        DeleteLocalString(oPC, "Forge_Param1");
        DeleteLocalInt(oPC, "Forge_Param1Value");
        DeleteLocalInt(oPC, "Forge_PropList");
        DeleteLocalInt(oPC, "Forge_Cost");
        while(GetIsObjectValid(oNewItem))   //clearing inventory
        {
            DestroyObject(oNewItem);
            oNewItem = GetNextItemInInventory(OBJECT_SELF);
        }
    }
    else if(nValue == DYNCONV_ABORTED)
    {
        // This section should never be run, since aborting this conversation should
        // always be forbidden and as such, any attempts to abort the conversation
        // should be handled transparently by the system
        if(DEBUG) DoDebug("forge_conv: ERROR: Conversation abort section run");
    }
    // Handle PC response
    else
    {
        int nChoice = GetChoice(oPC);
        switch(nStage)
        {
            case STAGE_START:
            {
                switch(nChoice)
                {
                    case CHOICE_FORGE: nStage = GetNextItemPropStage(nStage, oPC, nPropList); break;
                    case CHOICE_BOOST:
                    {
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSkillIncrease(SKILL_CRAFT_ARMOR, 50), oPC, HoursToSeconds(24));
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSkillIncrease(SKILL_CRAFT_TRAP, 50), oPC, HoursToSeconds(24));
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSkillIncrease(SKILL_CRAFT_WEAPON, 50), oPC, HoursToSeconds(24));
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_BREACH), oPC);
                        break;
                    }
                }
                break;
            }
            case STAGE_SELECT_ITEM:
            {
                if(nChoice == CHOICE_BACK)
                    nStage = GetPrevItemPropStage(nStage, oPC, nPropList);
                else
                {
                    oItem = GetItemInSlot(nChoice, oPC);
                    SetLocalObject(oPC, "Forge_Item", oItem);
                    //object oNewItem = GetFirstItemInInventory(OBJECT_SELF);
                    while(GetIsObjectValid(oNewItem))   //clearing inventory
                    {
                        DestroyObject(oNewItem);
                        oNewItem = GetNextItemInInventory(OBJECT_SELF);
                    }
                    oNewItem = CopyItem(oItem, OBJECT_SELF, FALSE); //temp item for cost
                    nStage = GetNextItemPropStage(nStage, oPC, nPropList);
                }
                break;
            }
            case STAGE_SELECT_TYPE:
            {
                if(nChoice == CHOICE_BACK)
                    nStage = GetPrevItemPropStage(nStage, oPC, nPropList);
                else if(nChoice == CHOICE_CLEAR) //strips item properties
                {
                    itemproperty ip = GetFirstItemProperty(oItem);
                    while(GetIsItemPropertyValid(ip))
                    {
                        RemoveItemProperty(oItem, ip);
                        ip = GetNextItemProperty(oItem);
                    }
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_BREACH), oPC);
                    SetHeader(ItemStats(oItem) + "\nSelect an item property.");
                }
                else if(nChoice == CHOICE_SETNAME)
                {
                    SetLocalInt(oPC, "Item_Name_Change", 1);
                    nStage = GetPrevItemPropStage(nStage, oPC, nPropList);
                    SendMessageToPC(oPC, "Please state (use chat) the new name of the item.");
                }
                else
                {
                    nType = nChoice;
                    SetLocalInt(oPC, "Forge_Type", nType);
                    sSubtype = Get2DACache("itempropdef", "SubTypeResRef", nType);
                    SetLocalString(oPC, "Forge_SubType", sSubtype);
                    sCostTable = Get2DACache("itempropdef", "CostTableResRef", nType);
                    if(sCostTable == "0")   //IPRP_BASE1 is blank
                        sCostTable = "";
                    if(sCostTable != "")
                        sCostTable = Get2DACache("iprp_costtable", "Name", StringToInt(sCostTable));
                    SetLocalString(oPC, "Forge_CostTable", sCostTable);
                    sParam1 = Get2DACache("itempropdef", "Param1ResRef", nType);
                    if(sParam1 != "")
                        sParam1 = Get2DACache("iprp_paramtable", "TableResRef", StringToInt(sParam1));
                    SetLocalString(oPC, "Forge_Param1", sParam1);

                    nPropList = 0;
                    if(sSubtype != "")
                        nPropList |= HAS_SUBTYPE;
                    if(sCostTable != "")
                        nPropList |= HAS_COSTTABLE;
                    if(sParam1 != "")
                        nPropList |= HAS_PARAM1;
                    SetLocalInt(oPC, "Forge_PropList", nPropList);

                    nStage = GetNextItemPropStage(nStage, oPC, nPropList);
                }
                break;
            }
            case STAGE_SELECT_SUBTYPE:
            {
                if(nChoice == CHOICE_BACK)
                    nStage = GetPrevItemPropStage(nStage, oPC, nPropList);
                else
                {
                    nSubTypeValue = nChoice;
                    if(nType == ITEM_PROPERTY_ON_HIT_PROPERTIES)    //Param1 depends on subtype
                    {
                        sParam1 = Get2DACache(sSubtype, "Param1ResRef", nSubTypeValue);
                        if(sParam1 != "")   //if subtype has a Param1
                        {
                            sParam1 = Get2DACache("iprp_paramtable", "TableResRef", StringToInt(sParam1));
                            nPropList |= HAS_PARAM1;
                        }
                        else //if(nPropList & HAS_PARAM1)
                            nPropList &= (~HAS_PARAM1);
                        SetLocalString(oPC, "Forge_Param1", sParam1);
                        SetLocalInt(oPC, "Forge_PropList", nPropList);
                    }
                    SetLocalInt(oPC, "Forge_PropList", nPropList);
                    SetLocalInt(oPC, "Forge_SubTypeValue", nSubTypeValue);
                    nStage = GetNextItemPropStage(nStage, oPC, nPropList);
                }
                break;
            }
            case STAGE_SELECT_COSTTABLEVALUE:
            {
                if(nChoice == CHOICE_BACK)
                    nStage = GetPrevItemPropStage(nStage, oPC, nPropList);
                else
                {
                    nCostTableValue = nChoice;
                    SetLocalInt(oPC, "Forge_CostTableValue", nCostTableValue);
                    nStage = GetNextItemPropStage(nStage, oPC, nPropList);
                }
                break;
            }
            case STAGE_SELECT_PARAM1VALUE:
            {
                if(nChoice == CHOICE_BACK)
                    nStage = GetPrevItemPropStage(nStage, oPC, nPropList);
                else
                {
                    nParam1Value = nChoice;
                    SetLocalInt(oPC, "Forge_Param1Value", nParam1Value);
                    nStage = GetNextItemPropStage(nStage, oPC, nPropList);
                }
                break;
            }
            case STAGE_CONFIRM:
            {
                if(nChoice == CHOICE_BACK)
                    nStage = GetPrevItemPropStage(nStage, oPC, nPropList);
                if(nChoice == CHOICE_CONFIRM)
                {
                    itemproperty ip = ConstructIP(nType, nSubTypeValue, nCostTableValue, nParam1Value);
                    IPSafeAddItemProperty(oItem, ip, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_BREACH), oPC);
                    TakeGoldFromCreature(GetLocalInt(oPC, "Forge_Cost"), oPC, TRUE);
                    nStage = STAGE_SELECT_TYPE;
                    MarkStageNotSetUp(nStage, oPC);
                }
                break;
            }
        }
        if(DEBUG) DoDebug("Next stage: " + IntToString(nStage));
        SetStage(nStage, oPC);
    }
}
