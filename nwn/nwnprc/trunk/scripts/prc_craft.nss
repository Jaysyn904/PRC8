/*
    prc_craft

    Dynamic conversation file for forge, modified from
        old psi_powconv, borrowed from prc_ccc

    By: Flaming_Sword
    Created: Jul 12, 2006
    Modified: Nov 5, 2007

    LIMITATIONS:
        ITEM_PROPERTY_BONUS_FEAT
            not all feats available, anything much higher killed the game
            some of the feats added can be silly (blame the 2das)
        IPRP_SPELLS
            anything involving this 2da file can only use the bioware spells
                since anything much higher produced TMIs
        Not all item properties have returning functions
        Needs updating if item property 2da files increase in size

    CHECK:
        89 properties with constants, 15 without
*/

#include "prc_craft_cv_inc"
#include "inc_dynconv"


void main()
{
    object oTarget = PRCGetSpellTargetObject();
    object oPC = OBJECT_SELF;//GetPCSpeaker();
    int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);
    if(GetLocalInt(oPC, "PRC_CRAFT_TERMINATED"))
    {
        SendMessageToPC(oPC, "Error Recovery: Please try again");
        SetLocalInt(oPC, DYNCONV_VARIABLE, 0);
        DeleteLocalInt(oPC, "PRC_CRAFT_TERMINATED");
        DeleteLocalInt(oPC, "DynConv_Waiting");
        AllowExit(DYNCONV_EXIT_FORCE_EXIT);
        return;
    }
    if(DEBUG) DoDebug("prc_craft: nValue = " + IntToString(nValue));
    if(nValue == 0)
    {   //as part of a cast spell and not in the convo
        if(GetPRCSwitch(PRC_DISABLE_CRAFT))
        {
            SendMessageToPC(oPC, "Crafting has been disabled.");
            return;
        }
        if(GetLocalInt(GetArea(oPC), PRC_AREA_DISABLE_CRAFTING) != GetPRCSwitch(PRC_AREA_DISABLE_CRAFTING_INVERT))
        {
            SendMessageToPC(oPC, "Crafting has been disabled in this area.");
            return;
        }
        if(GetLocalInt(oPC, PRC_CRAFT_HB))
        {
            SendMessageToPC(oPC, "You are already crafting an item.");
            return;
        }
        if(oTarget == OBJECT_SELF)
        {   //cast on self, crafting non-magical items
            SetLocalInt(OBJECT_SELF, PRC_CRAFT_SCRIPT_STATE, PRC_CRAFT_STATE_NORMAL);
        }
        else if(GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
        {   //cast on item, crafting targeted item
            int nFeat = GetCraftingFeat(oTarget);
            int bToken = 0;
            if(GetPlotFlag(oTarget) || nFeat == -1)
            {
                SendMessageToPC(oPC, "You cannot craft this item.");
                return;
            }
            location lLoc = GetLocation(oPC);
            object oContainer = GetFirstObjectInShape(SHAPE_SPHERE, 10.0, lLoc, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_PLACEABLE);
            string sToken = PRC_CRAFT_TOKEN;
            while(GetIsObjectValid(oContainer))
            {
                if(!GetIsPC(oContainer) && GetHasInventory(oContainer))
                {
                    if(GetIsObjectValid(GetItemPossessedBy(oContainer, sToken)))
                    {
                        SetLocalInt(oPC, PRC_CRAFT_TOKEN, 1);
                        bToken = 1;
                        break;
                    }
                }
                oContainer = GetNextObjectInShape(SHAPE_SPHERE, 10.0, lLoc, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_PLACEABLE);
            }
            if(!GetHasFeat(nFeat, oPC) && !bToken)
            {
                SendMessageToPC(oPC, "You do not have the required feat to craft this item.");
                return;
            }/*
            if(!GetPRCSwitch(PRC_CRAFTING_ARBITRARY))
            {
                int nBase = GetBaseItemType(oTarget);
                if(nFeat == FEAT_CRAFT_ARMS_ARMOR)
                {
                    if((!(GetMaterialString(StringToInt(sMaterial)) == sMaterial && sMaterial != "000") && !GetIsMagicItem(oTarget)))
                    {
                        SendMessageToPC(oPC, "This is not a craftable magic item.");
                        return;
                    }
                }
                else if(StringToInt(Get2DACache("prc_craft_gen_it", "Type", GetBaseItemType(oTarget))) == PRC_CRAFT_ITEM_TYPE_CASTSPELL)
                {
                    SendMessageToPC(oPC, "This item must be crafted by casting spells on it.");
                    return;
                }
                else if(GetIsMagicItem(oTarget))
                {
                    SendMessageToPC(oPC, "This is not a craftable magic item.");
                    return;
                }
            }*/
            SetLocalInt(OBJECT_SELF, PRC_CRAFT_SCRIPT_STATE, PRC_CRAFT_STATE_MAGIC);
            SetLocalObject(OBJECT_SELF, PRC_CRAFT_ITEM, oTarget);
        }
        StartDynamicConversation("prc_craft", OBJECT_SELF, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE);
        return;
    }
    int nStage = GetStage(oPC);
    //in case the script execution is screwed somehow
    SetLocalInt(oPC, "PRC_CRAFT_TERMINATED", 1);

    object oItem = GetLocalObject(oPC, PRC_CRAFT_ITEM);
    int nType = GetLocalInt(oPC, PRC_CRAFT_TYPE);
    string sSubtype = GetLocalString(oPC, PRC_CRAFT_SUBTYPE);
    int nSubTypeValue = GetLocalInt(oPC, PRC_CRAFT_SUBTYPEVALUE);
    string sCostTable = GetLocalString(oPC, PRC_CRAFT_COSTTABLE);
    int nCostTableValue = GetLocalInt(oPC, PRC_CRAFT_COSTTABLEVALUE);
    string sParam1 = GetLocalString(oPC, PRC_CRAFT_PARAM1);
    int nParam1Value = GetLocalInt(oPC, PRC_CRAFT_PARAM1VALUE);

    string sTag = GetLocalString(oPC, PRC_CRAFT_TAG);

    int nAC = GetLocalInt(oPC, PRC_CRAFT_AC);
    int nBase = GetLocalInt(oPC, PRC_CRAFT_BASEITEMTYPE);
    int nCost = GetLocalInt(oPC, PRC_CRAFT_COST);
    int nXP = GetLocalInt(oPC, PRC_CRAFT_XP);
    int nTime = GetLocalInt(oPC, PRC_CRAFT_TIME);
    int nMaterial = GetLocalInt(oPC, PRC_CRAFT_MATERIAL);
    int nMighty = GetLocalInt(oPC, PRC_CRAFT_MIGHTY);
    int nPropList = GetLocalInt(oPC, PRC_CRAFT_PROPLIST);
    int nState = GetLocalInt(oPC, PRC_CRAFT_SCRIPT_STATE);
    int bToken = GetLocalInt(oPC, PRC_CRAFT_TOKEN);

    string sFile = GetLocalString(oPC, PRC_CRAFT_FILE);

    int nEnhancement = GetLocalInt(oPC, PRC_CRAFT_MAGIC_ENHANCE);
    int nAdditional = GetLocalInt(oPC, PRC_CRAFT_MAGIC_ADDITIONAL);
    int nEpic = GetLocalInt(oPC, PRC_CRAFT_MAGIC_EPIC);

    int nLine = GetLocalInt(oPC, PRC_CRAFT_LINE);


    object oNewItem = GetItemPossessedBy(GetCraftChest(), sTag);

    string sTemp = "";
    int nTemp = 0;

    int nHD = GetHitDice(oPC);
    int nMinXP = nHD * (nHD - 1) * 500;
    int nCurrentXP = GetXP(oPC);
    int nCostDiff;
    int nXPDiff = 0;
    itemproperty ip;

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
                    if(nState == PRC_CRAFT_STATE_NORMAL)
                    {
                        SetHeader("Select an item to craft.");
                        SetLocalInt(oPC, "DynConv_Waiting", TRUE);
                        SetLocalInt(oPC, PRC_CRAFT_AC, -1);
                        SetLocalInt(oPC, PRC_CRAFT_MIGHTY, -1);
                        PopulateList(oPC, PRCGetFileEnd("prc_craft_gen_it"), TRUE, "prc_craft_gen_it");
                    }
                    else if(nState == PRC_CRAFT_STATE_MAGIC)
                    {
                        int nBaseItem = GetBaseItemType(oItem);
                        int bAllow = TRUE;
                        sFile = GetCrafting2DA(oItem);
                        string sMaterial = GetStringLeft(GetTag(oItem), 3);
                        SetLocalString(oPC, PRC_CRAFT_FILE, sFile);
                        int nFeat = GetCraftingFeat(oItem);
                        int bEpic = (GetHasFeat(GetEpicCraftingFeat(nFeat), oPC) && (!GetPRCSwitch(PRC_DISABLE_CRAFT_EPIC)));
                        if(bToken)
                            sTemp = "Using crafting facilities\n\n";
                        sTemp += ItemStats(oItem) + "\nPlease make a selection.";
                        SetHeader(ItemStats(oItem) + "\nPlease make a selection.");
                        struct itemvars strTemp = GetItemVars(oPC, oItem, sFile, bEpic, 1);
                        SetLocalInt(oPC, PRC_CRAFT_MAGIC_ENHANCE, strTemp.enhancement);
                        SetLocalInt(oPC, PRC_CRAFT_MAGIC_ADDITIONAL, strTemp.additionalcost);
                        SetLocalInt(oPC, PRC_CRAFT_MAGIC_EPIC, strTemp.epic);
                        AddChoice(ActionString("Change Name"), CHOICE_SETNAME, oPC);
                        AddChoice(ActionString("Change Appearance"), CHOICE_SETAPPEARANCE, oPC);
                        if(!GetPRCSwitch(PRC_CRAFTING_ARBITRARY))
                        {
                            if(nFeat == FEAT_CRAFT_ARMS_ARMOR)
                            {
                                if((!(GetMaterialString(StringToInt(sMaterial)) == sMaterial && sMaterial != "000") && !GetIsMagicItem(oItem)))
                                    bAllow = FALSE;
                            }
                            else if(nFeat == FEAT_CRAFT_STAFF)
                            {
                                int nStaffSpells = 0;
                                itemproperty ipTest = GetFirstItemProperty(oItem);
                                while(GetIsItemPropertyValid(ipTest))
                                {
                                    if(GetItemPropertyType(ipTest) == ITEM_PROPERTY_CAST_SPELL)
                                        nStaffSpells++;
                                    ipTest = GetNextItemProperty(oItem);
                                }
                                if(nStaffSpells > 7)
                                    bAllow = FALSE;
                            }
                            else if(GetIsMagicItem(oItem))
                                    bAllow = FALSE;
                        }
                        if(bAllow)
                            if(sFile != "" && StringToInt(Get2DACache("prc_craft_gen_it", "Type", GetBaseItemType(oTarget))) == PRC_CRAFT_ITEM_TYPE_CASTSPELL)
                                bAllow = FALSE;
                        if(bAllow)
                        {
                            AddChoice(ActionString("Clone Item"), CHOICE_CLONE, oPC);
                            SetLocalInt(oPC, "DynConv_Waiting", TRUE);
                            SetLocalInt(oPC, PRC_CRAFT_TYPE, -1);
                            SetLocalString(oPC, PRC_CRAFT_SUBTYPE, "");
                            SetLocalInt(oPC, PRC_CRAFT_SUBTYPEVALUE, -1);
                            SetLocalString(oPC, PRC_CRAFT_COSTTABLE, "");
                            SetLocalInt(oPC, PRC_CRAFT_COSTTABLEVALUE, -1);
                            SetLocalString(oPC, PRC_CRAFT_PARAM1, "");
                            SetLocalInt(oPC, PRC_CRAFT_PARAM1VALUE, -1);
                            if(GetPRCSwitch(PRC_CRAFTING_ARBITRARY))
                            {
                                sFile = "itempropdef";
                                SetLocalString(oPC, PRC_CRAFT_FILE, sFile);
                                PopulateList(oPC, NUM_MAX_PROPERTIES, TRUE, sFile, oItem);
                            }
                            else if(sFile == "")
                            {
                                sFile = "iprp_spells";
                                SetLocalInt(oPC, PRC_CRAFT_TYPE, ITEM_PROPERTY_CAST_SPELL);
                                PopulateList(oPC, PRCGetFileEnd(sFile), TRUE, sFile);
                            }
                            else
                            {
                                PopulateList(oPC, PRCGetFileEnd(sFile), FALSE, sFile);
                            }
                            if(GetPRCSwitch(PRC_CRAFTING_ARBITRARY) || sFile != "")
                            {
                                string sMaterial = GetStringLeft(GetTag(oTarget), 3);
                                object oChest = GetCraftChest();
                                string sTag = sMaterial + GetUniqueID() + PRC_CRAFT_UID_SUFFIX;
                                while(GetIsObjectValid(GetItemPossessedBy(oChest, sTag)))//make sure there aren't any tag conflicts
                                    sTag = sMaterial + GetUniqueID() + PRC_CRAFT_UID_SUFFIX;    //may choke if all uids are taken :P
                                if (GetLevelByClass(CLASS_TYPE_IRONSOUL_FORGEMASTER)) sTag = GetName(OBJECT_SELF);    
                                oNewItem = CopyObject(oItem, GetLocation(oChest), oChest, sTag);
                                SetIdentified(oNewItem, TRUE);  //just in case
                                SetLocalString(oPC, PRC_CRAFT_TAG, GetTag(oNewItem));
                            }
                        }
                    }
                    SetDefaultTokens();
                    AllowExit(DYNCONV_EXIT_ALLOWED_SHOW_CHOICE, FALSE, oPC);
                    MarkStageSetUp(nStage, oPC);
                    SetCustomToken(DYNCONV_TOKEN_EXIT, ActionString("Leave"));
                    SetCustomToken(DYNCONV_TOKEN_NEXT, ActionString("Next"));
                    SetCustomToken(DYNCONV_TOKEN_PREV, ActionString("Previous"));
                    break;
                }
                case STAGE_SELECT_SUBTYPE:
                {
                    SetHeader("Select a subtype.");
                    AddChoice(ActionString("Back"), CHOICE_BACK, oPC);
                    SetLocalInt(oPC, "DynConv_Waiting", TRUE);
                    PopulateList(oPC, PRCGetFileEnd(sSubtype), TRUE, sSubtype);
                    MarkStageSetUp(nStage);
                    break;
                }
                case STAGE_SELECT_COSTTABLEVALUE:
                {
                    SetHeader("Select a costtable value.");
                    AddChoice(ActionString("Back"), CHOICE_BACK, oPC);
                    SetLocalInt(oPC, "DynConv_Waiting", TRUE);
                    PopulateList(oPC, PRCGetFileEnd(sCostTable), FALSE, sCostTable);
                    MarkStageSetUp(nStage);
                    break;
                }
                case STAGE_SELECT_PARAM1VALUE:
                {
                    SetHeader("Select a param1 value.");
                    AddChoice(ActionString("Back"), CHOICE_BACK, oPC);
                    SetLocalInt(oPC, "DynConv_Waiting", TRUE);
                    PopulateList(oPC, PRCGetFileEnd(sParam1), FALSE, sParam1);
                    MarkStageSetUp(nStage);
                    break;
                }
                case STAGE_CONFIRM:
                {
                    itemproperty ip = ConstructIP(nType, nSubTypeValue, nCostTableValue, nParam1Value);
                    IPSafeAddItemProperty(oNewItem, ip, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
                    nTemp = GetGoldPieceValue(oNewItem) - GetGoldPieceValue(oItem);
                    int nTime = GetCraftingTime(nTemp);
                    int nTemp2 = 0;
                    if(!bToken)
                    {
                        nTemp /= 2;
                        nTemp2 = nTemp / 25;
                        if(nTemp2 < 1) nTemp2 = 1;
                    }
                    if(nTemp < 1) nTemp = 1;
                    SetLocalInt(oPC, PRC_CRAFT_COST, nTemp);
                    SetLocalInt(oPC, PRC_CRAFT_XP, nTemp2);
                    sTemp = GetItemPropertyString(ip);
                    sTemp += "\nCost: " + IntToString(nTemp) + "gp " + IntToString(nTemp2) + "XP";
                    if(nTime > 0)
                        sTemp += "\nTime: " + IntToString(nTime) + " rounds";
                    SetHeader("You have selected:\n\n" + sTemp + "\n\nPlease confirm your selection.");
                    AddChoice(ActionString("Back"), CHOICE_BACK, oPC);
                    if(GetGold(oPC) >= nTemp && (nCurrentXP - nMinXP) >= nTemp2)
                        AddChoice(ActionString("Confirm"), CHOICE_CONFIRM, oPC);
                    MarkStageSetUp(nStage);
                    break;
                }
                case STAGE_BANE:
                {
                    SetHeader("Select a racial type.");
                    AllowExit(DYNCONV_EXIT_NOT_ALLOWED, FALSE, oPC);
                    AddChoice(ActionString("Back"), CHOICE_BACK, oPC);
                    SetLocalInt(oPC, "DynConv_Waiting", TRUE);
                    PopulateList(oPC, PRCGetFileEnd("racialtypes"), TRUE, "racialtypes");
                    MarkStageSetUp(nStage);
                    break;
                }
                case STAGE_CRAFT_AC:
                {
                    SetHeader("Select a base AC value.");
                    AllowExit(DYNCONV_EXIT_NOT_ALLOWED, FALSE, oPC);
                    AddChoice(ActionString("Back"), CHOICE_BACK, oPC);
                    for(i = 0; i < 9; i++)
                        AddChoice(ActionString(IntToString(i)), i, oPC);
                    MarkStageSetUp(nStage);
                    break;
                }
                case STAGE_CRAFT_MIGHTY:
                {
                    SetHeader("Select a mighty value.");
                    AllowExit(DYNCONV_EXIT_NOT_ALLOWED, FALSE, oPC);
                    AddChoice(ActionString("Back"), CHOICE_BACK, oPC);
                    for(i = 0; i < 21; i++)
                        AddChoice("+" + ActionString(IntToString(i)), i, oPC);
                    MarkStageSetUp(nStage);
                    break;
                }
                case STAGE_CRAFT_MASTERWORK:
                {
                    SetHeader("Select an item type.");
                    AllowExit(DYNCONV_EXIT_NOT_ALLOWED, FALSE, oPC);
                    AddChoice(ActionString("Back"), CHOICE_BACK, oPC);
                    AddChoice(ActionString("Normal"), PRC_CRAFT_FLAG_NONE, oPC);
                    nTemp = StringToInt(Get2DACache("prc_craft_gen_it", "Type", nBase));
                    if(!(
                        ((nBase == BASE_ITEM_ARMOR) && (!nAC)) ||
                        (nTemp == PRC_CRAFT_ITEM_TYPE_MISC) ||
                        (nTemp == PRC_CRAFT_ITEM_TYPE_CASTSPELL)
                        )
                        )
                    {
                        AddChoice(ActionString("Masterwork"), PRC_CRAFT_FLAG_MASTERWORK, oPC);
                        //if(CheckCraftingMaterial(nBase, PRC_CRAFT_MATERIAL_METAL))
                        if(nBase == BASE_ITEM_ARMOR)    //because we can only have adamantine armour at this point
                            AddChoice(ActionString("Adamantine"), PRC_CRAFT_FLAG_ADAMANTINE, oPC);
                        if(CheckCraftingMaterial(nBase, PRC_CRAFT_MATERIAL_WOOD))
                            AddChoice(ActionString("Darkwood"), PRC_CRAFT_FLAG_DARKWOOD, oPC);
                        if((nBase == BASE_ITEM_ARMOR) ||
                            (nBase == BASE_ITEM_SMALLSHIELD) ||
                            (nBase == BASE_ITEM_LARGESHIELD) ||
                            (nBase == BASE_ITEM_TOWERSHIELD))
                            AddChoice(ActionString("Dragonhide"), PRC_CRAFT_FLAG_DRAGONHIDE, oPC);
                        if(CheckCraftingMaterial(nBase, PRC_CRAFT_MATERIAL_METAL))
                            AddChoice(ActionString("Mithral"), PRC_CRAFT_FLAG_MITHRAL, oPC);/*
                        if(CheckCraftingMaterial(nBase, PRC_CRAFT_MATERIAL_METAL))
                            AddChoice(ActionString("Cold Iron"), PRC_CRAFT_FLAG_COLD_IRON, oPC);
                        if(CheckCraftingMaterial(nBase, PRC_CRAFT_MATERIAL_METAL))
                            AddChoice(ActionString("Alchemical Silver"), PRC_CRAFT_FLAG_ALCHEMICAL_SILVER, oPC);*/
                        /* NOT IMPLEMENTED YET
                        if(CheckCraftingMaterial(nBase, PRC_CRAFT_MATERIAL_METAL))
                            AddChoice(ActionString("Mundane Crystal"), PRC_CRAFT_FLAG_MUNDANE_CRYSTAL, oPC);
                        if(CheckCraftingMaterial(nBase, PRC_CRAFT_MATERIAL_METAL))
                            AddChoice(ActionString("Deep Crystal"), PRC_CRAFT_FLAG_DEEP_CRYSTAL, oPC);
                        */
                    }
                    else if((nBase == BASE_ITEM_ARMOR) && (!nAC))
                        AddChoice(ActionString("Masterwork"), PRC_CRAFT_FLAG_MASTERWORK, oPC);
                    MarkStageSetUp(nStage);
                    break;
                }
                case STAGE_CRAFT_CONFIRM:
                {   //PHB item prices stored in baseitems.2da
                    AllowExit(DYNCONV_EXIT_ALLOWED_SHOW_CHOICE, FALSE, oPC);
                    struct itemvars strTemp;
                    strTemp.item = oNewItem;
                    nTemp = GetPnPItemCost(strTemp);
                    int nScale = GetPRCSwitch(PRC_CRAFTING_MUNDANE_COST_SCALE);
                    if(nScale > 0)
                    {
                        nTemp = FloatToInt(IntToFloat(nTemp) * IntToFloat(nScale) / 100.0);
                    }
                    nTemp /= 3;

                    if(nTemp < 1) nTemp = 1;
                    SetLocalInt(oPC, PRC_CRAFT_COST, nTemp);
                    SetHeader("You have chosen to craft:\n\n" + ItemStats(oNewItem) + "\nPrice: " + IntToString(nTemp) + "gp");
                    AddChoice(ActionString("Back"), CHOICE_BACK, oPC);
                    if(GetGold(oPC) >= nTemp)
                        AddChoice(ActionString("Confirm"), CHOICE_CONFIRM, oPC);
                    //DestroyObject(oNewItem);
                    MarkStageSetUp(nStage);
                    break;
                }
                case STAGE_CONFIRM_MAGIC:
                {
                    AllowExit(DYNCONV_EXIT_ALLOWED_SHOW_CHOICE, FALSE, oPC);
                    struct itemvars strTempOld, strTempNew;
                    int nFeat = GetCraftingFeat(oItem);
                    if(nFeat == FEAT_CRAFT_ARMS_ARMOR)
                    {
                        ApplyItemProps(oNewItem, sFile, nLine);
                        strTempOld.item = oItem;
                        strTempOld.enhancement = nEnhancement;
                        strTempOld.additionalcost = nAdditional;
                        strTempOld.epic = nEpic;
                        strTempNew = GetItemVars(oPC, oNewItem, sFile);
                        if(nEnhancement > 10 || strTempNew.enhancement > 10) strTempNew.epic = TRUE;
                        int nCostOld = GetPnPItemCost(strTempOld, FALSE);
                        int nCostNew = GetPnPItemCost(strTempNew, FALSE);
                        nCostDiff = nCostNew - nCostOld;    //assumes cost increases with addition of itemprops :P
                        if(!bToken)
                        {
                            int nXPOld = GetPnPItemXPCost(nCostOld, nEpic);
                            int nXPNew = GetPnPItemXPCost(nCostNew, strTempNew.epic);
                            nXPDiff = nXPNew - nXPOld;
                        }
                    }
                    else
                    {
                        nCostDiff = StringToInt(Get2DACache(sFile, "AdditionalCost", nLine));
                        nCostDiff = GetModifiedGoldCost(nCostDiff, oPC, nFeat);
                        if(!bToken)
                            nXPDiff = GetPnPItemXPCost(nCostDiff, StringToInt(Get2DACache(sFile, "Epic", nLine)));
                    }
                    int nTime = GetCraftingTime(nCostDiff);

                    if(!bToken)
                    {
                        nCostDiff /= 2;
                        nXPDiff /= 2;
                    }
                    nCostDiff = GetModifiedGoldCost(nCostDiff, oPC, nFeat);
                    nXPDiff = GetModifiedXPCost(nXPDiff, oPC, nFeat);
                    nTime = GetModifiedTimeCost(nTime, oPC, nFeat);
                    if(nCostDiff < 1) nCostDiff = 1;
                    if(nXPDiff < 0) nXPDiff = 0;
                    SetLocalInt(oPC, PRC_CRAFT_COST, nCostDiff);
                    SetLocalInt(oPC, PRC_CRAFT_XP, nXPDiff);
                    SetLocalInt(oPC, PRC_CRAFT_TIME, nTime);
                    sTemp += GetStringByStrRef(StringToInt(Get2DACache(sFile, "Name", nLine)));
                    sTemp += "\n\n";
                    sTemp += GetStringByStrRef(StringToInt(Get2DACache(sFile, "Description", nLine)));
                    //sTemp += "\n\n";
                    //sTemp += ItemStats(oNewItem);
                    sTemp += "\nCost: " + IntToString(nCostDiff) + "gp " + IntToString(nXPDiff) + "XP";
                    if(nTime > 0)
                        sTemp += "\nTime: " + IntToString(nTime) + " rounds";
                    SetHeader("You have selected:\n\n" + sTemp + "\n\nPlease confirm your selection.");
                    AddChoice(ActionString("Back"), CHOICE_BACK, oPC);

                    int nHD = GetHitDice(oPC);
                    int nMinXP = nHD * (nHD - 1) * 500;
                    int nCurrentXP = GetXP(oPC);

                    if(GetGold(oPC) >= nCostDiff && (nCurrentXP - nMinXP) >= nXPDiff && CheckPrereq(oPC, nLine, GetHasFeat(GetEpicCraftingFeat(GetCraftingFeat(oItem)), oPC) && (!GetPRCSwitch(PRC_DISABLE_CRAFT_EPIC)), sFile, strTempNew))
                        AddChoice(ActionString("Confirm"), CHOICE_CONFIRM, oPC);
                    SetLocalInt(oPC, PRC_CRAFT_COST, nCostDiff);
                    SetLocalInt(oPC, PRC_CRAFT_XP, nXPDiff);
                    DestroyObject(oNewItem);
                    MarkStageSetUp(nStage);
                    break;
                }
                case STAGE_APPEARANCE:
                {
                    sTemp = PRCGetItemAppearanceString(oPC, oItem);
                    SetHeader("Please make a selection.\n\nYour item appearance code is: \n\n" + sTemp);
                    AddChoice(ActionString("Back"), CHOICE_BACK, oPC);
                    AddChoice(ActionString("Set new appearance code"), CHOICE_APPEARANCE_SHOUT, oPC);
                    //AddChoice(ActionString("Select new appearance"), CHOICE_APPEARANCE_SELECT, oPC);
                    MarkStageSetUp(nStage);
                    break;
                }
                case STAGE_CLONE:
                {
                    AllowExit(DYNCONV_EXIT_ALLOWED_SHOW_CHOICE, FALSE, oPC);
                    string sMaterial = GetStringLeft(GetTag(oTarget), 3);
                    int nFeat = GetCraftingFeat(oItem);
                    if(GetPRCSwitch(PRC_CRAFTING_ARBITRARY) || (GetMaterialString(StringToInt(sMaterial)) != sMaterial))
                    {
                        itemproperty ip = GetFirstItemProperty(oNewItem);
                        while(GetIsItemPropertyValid(ip))
                        {   //removing cost reducing itemprops
                            nType = GetItemPropertyType(ip);
                            if(nType >= 120 && nType <= 127)
                                RemoveItemProperty(oNewItem, ip);
                            ip = GetNextItemProperty(oNewItem);
                        }
                        nCost = GetGoldPieceValue(oNewItem);
                        nXP = nCost / 25;
                        if(nXP < 1) nXP = 1;
                        nTime = GetCraftingTime(nCost);
                    }
                    else
                    {
                        struct itemvars strTemp;
                        strTemp.item = oItem;
                        strTemp.enhancement = nEnhancement;
                        strTemp.additionalcost = nAdditional;
                        strTemp.epic = nEpic;
                        nCost = GetPnPItemCost(strTemp);
                        nXP = GetPnPItemXPCost(GetPnPItemCost(strTemp, FALSE), nEpic);
                        nTime = GetCraftingTime(nCost);
                    }
                    nCost = GetModifiedGoldCost(nCost, oPC, nFeat);
                    nXP = GetModifiedXPCost(nXP, oPC, nFeat);
                    nTime = GetModifiedTimeCost(nTime, oPC, nFeat);
                    if(nCost < 1) nCost = 1;
                    if(nXP < 0) nXP = 0;
                    SetLocalInt(oPC, PRC_CRAFT_COST, nCost);
                    SetLocalInt(oPC, PRC_CRAFT_XP, nXP);
                    SetLocalInt(oPC, PRC_CRAFT_TIME, nTime);
                    sTemp = "Do you want to clone this item?\n\nCost: " + IntToString(nCost) + "gp " + IntToString(nXP) + "XP";
                    if(nTime > 0)
                        sTemp += "\nTime: " + IntToString(nTime) + " rounds";
                    SetHeader(sTemp);
                    AddChoice(ActionString("Back"), CHOICE_BACK, oPC);
                    int nHD = GetHitDice(oPC);
                    int nMinXP = nHD * (nHD - 1) * 500;
                    int nCurrentXP = GetXP(oPC);

                    if(GetGold(oPC) >= nCost && (nCurrentXP - nMinXP) >= nXP)
                        AddChoice(ActionString("Confirm"), CHOICE_CONFIRM, oPC);
                    DestroyObject(oNewItem);
                    MarkStageSetUp(nStage);
                    break;
                }
                case STAGE_CRAFT_GOLEM:
                {
                    //TODO: handlers for these states
                    SetHeader("Select a golem type.\n\nINCOMPLETE - DO NOT USE");
                    SetLocalInt(oPC, "DynConv_Waiting", TRUE);
                    SetLocalInt(oPC, PRC_CRAFT_AC, -1);
                    SetLocalInt(oPC, PRC_CRAFT_MIGHTY, -1);
                    SetLocalString(oPC, PRC_CRAFT_FILE, "craft_golem");
                    PopulateList(oPC, PRCGetFileEnd("craft_golem"), TRUE, "craft_golem");
                    MarkStageSetUp(nStage);
                    break;
                }
                case STAGE_CRAFT_GOLEM_HD:
                {
                    struct golemhds ghds = GetGolemHDsFromString(Get2DACache(sFile, "HD", nLine));
                    nCostDiff = GetPnPGolemCost(nLine, nParam1Value, CRAFT_COST_TYPE_CRAFTING);
                    nXPDiff = GetPnPGolemCost(nLine, nParam1Value, CRAFT_COST_TYPE_XP);
                    SetLocalInt(oPC, PRC_CRAFT_PARAM1VALUE, nParam1Value);
                    sTemp += GetStringByStrRef(StringToInt(Get2DACache(sFile, "Name", nLine)));
                    sTemp += "\n\n";
                    sTemp += GetStringByStrRef(StringToInt(Get2DACache(sFile, "Description", nLine)));
                    sTemp += "\nCost: " + IntToString(nCostDiff) + "gp " + IntToString(nXPDiff) + "XP";
                    if(nTime > 0)
                        sTemp += "\nTime: " + IntToString(nTime) + " rounds";
                    SetHeader("You have selected:\n\n" + sTemp + "\n\nPlease set the number of hitdice.");
                    AddChoice(ActionString("Back"), CHOICE_BACK, oPC);
                    AddChoice(ActionString("Hitdice + 1"), CHOICE_PLUS_1, oPC);
                    AddChoice(ActionString("Hitdice + 10"), CHOICE_PLUS_10, oPC);
                    AddChoice(ActionString("Hitdice - 1"), CHOICE_MINUS_1, oPC);
                    AddChoice(ActionString("Hitdice - 10"), CHOICE_MINUS_10, oPC);

                    //if(GetGold(oPC) >= nCostDiff && (nCurrentXP - nMinXP) >= nXPDiff && CheckPrereq(oPC, nLine, GetHasFeat(GetEpicCraftingFeat(GetCraftingFeat(oItem)), oPC) && (!GetPRCSwitch(PRC_DISABLE_CRAFT_EPIC)), sFile, strTempNew))
                    if(GetGold(oPC) >= nCostDiff && (nCurrentXP - nMinXP) >= nXPDiff && CheckGolemPrereq(oPC, nLine, GetHasFeat(GetEpicCraftingFeat(GetCraftingFeat(oItem)), oPC)))
                        AddChoice(ActionString("Confirm"), CHOICE_CONFIRM, oPC);
                    SetLocalInt(oPC, PRC_CRAFT_COST, nCostDiff);
                    SetLocalInt(oPC, PRC_CRAFT_XP, nXPDiff);
                    MarkStageSetUp(nStage);
                    break;
                }
                case STAGE_CRAFT_ALCHEMY:
                {
                    SetHeader("Which alchemical item would you like to create?");
                    SetLocalInt(oPC, "DynConv_Waiting", TRUE);
                    SetLocalString(oPC, PRC_CRAFT_FILE, "prc_craft_alchem");
                    PopulateList(oPC, PRCGetFileEnd("prc_craft_alchem"), TRUE, "prc_craft_alchem");
                    MarkStageSetUp(nStage);
                    break;
                }
                case STAGE_CONFIRM_ALCHEMY:
                {
                    sTemp = "Are you sure you want to create "+GetStringByStrRef(StringToInt(Get2DACache("prc_craft_alchem", "Name", nLine)))+"?";
                    sTemp += "\nCrafting cost: "+Get2DACache("prc_craft_alchem", "GoldCost", nLine)+" gp";
                    sTemp += "\nCrafting DC: "+Get2DACache("prc_craft_alchem", "CraftDC", nLine);
                    SetHeader(sTemp);
                    AddChoice(ActionString("Back"), CHOICE_BACK, oPC);
                    AddChoice(ActionString("Confirm"), CHOICE_CONFIRM, oPC);
                    MarkStageSetUp(nStage);
                    break;
                }
                case STAGE_CRAFT_POISON:
                {
                    SetHeader("Which poison would you like to create?");
                    SetLocalInt(oPC, "DynConv_Waiting", TRUE);
                    SetLocalString(oPC, PRC_CRAFT_FILE, "prc_craft_poison");
                    PopulateList(oPC, PRCGetFileEnd("prc_craft_poison"), TRUE, "prc_craft_poison");
                    MarkStageSetUp(nStage);
                    break;
                }
                case STAGE_CONFIRM_POISON:
                {
                    int bIngredients = GetPRCSwitch(PRC_CRAFT_POISON_USE_INGREDIENTS);
                    string sIngr1Name = Get2DACache("prc_craft_poison", "Ingr1Name", nLine);
                    string sIngr2Name = Get2DACache("prc_craft_poison", "Ingr2Name", nLine);
                    string sCost = Get2DACache("prc_craft_poison", "GoldCost", nLine);
                    sTemp = "Are you sure you want to create this poison:\n";
                    sTemp += GetStringByStrRef(StringToInt(Get2DACache("prc_craft_poison", "Description", nLine)));
                    if(sIngr1Name != "")
                    {
                        sTemp += "\nIngredients: "+Get2DACache("prc_craft_poison", "Ingr1Name", nLine)+", "+Get2DACache("prc_craft_poison", "Ingr2Name", nLine);
                        sTemp += "\nCrafting cost: "+IntToString(StringToInt(sCost)/10)+" gp";
                    }
                    else
                        sTemp += "\nCrafting cost: "+sCost+" gp";
                    sTemp += "\nCrafting DC: "+Get2DACache("prc_craft_poison", "CraftDC", nLine);
                    SetHeader(sTemp);
                    AddChoice(ActionString("Back"), CHOICE_BACK, oPC);
                    AddChoice(ActionString("Confirm"), CHOICE_CONFIRM, oPC);
                    MarkStageSetUp(nStage);
                    break;
                }

                /*
                case <CONSTANT>:
                {
                    SetHeader("");
                    AddChoice(ActionString(""), <CONSTANT>, oPC);
                    MarkStageSetUp(nStage);
                    break;
                }
                */

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
        if(DEBUG) DoDebug("prc_craft: Running exit handler");
        // End of conversation cleanup
        DeleteLocalObject(oPC, PRC_CRAFT_ITEM);
        DeleteLocalInt(oPC, PRC_CRAFT_TYPE);
        DeleteLocalString(oPC, PRC_CRAFT_SUBTYPE);
        DeleteLocalInt(oPC, PRC_CRAFT_SUBTYPEVALUE);
        DeleteLocalString(oPC, PRC_CRAFT_COSTTABLE);
        DeleteLocalInt(oPC, PRC_CRAFT_COSTTABLEVALUE);
        DeleteLocalString(oPC, PRC_CRAFT_PARAM1);
        DeleteLocalInt(oPC, PRC_CRAFT_PARAM1VALUE);
        DeleteLocalInt(oPC, PRC_CRAFT_PROPLIST);
        DeleteLocalString(oPC, PRC_CRAFT_TAG);
        DeleteLocalInt(oPC, PRC_CRAFT_AC);
        DeleteLocalInt(oPC, PRC_CRAFT_BASEITEMTYPE);
        DeleteLocalInt(oPC, PRC_CRAFT_COST);
        DeleteLocalInt(oPC, PRC_CRAFT_XP);
        DeleteLocalInt(oPC, PRC_CRAFT_TIME);
        DeleteLocalInt(oPC, PRC_CRAFT_MATERIAL);
        DeleteLocalInt(oPC, PRC_CRAFT_MIGHTY);
        DeleteLocalInt(oPC, PRC_CRAFT_SCRIPT_STATE);
        DestroyObject(oNewItem, 0.1);
        DeleteLocalInt(oPC, PRC_CRAFT_TAG);
        DeleteLocalInt(oPC, PRC_CRAFT_MAGIC_ENHANCE);
        DeleteLocalInt(oPC, PRC_CRAFT_MAGIC_ADDITIONAL);
        DeleteLocalInt(oPC, PRC_CRAFT_MAGIC_EPIC);
        DeleteLocalInt(oPC, PRC_CRAFT_LINE);
        DeleteLocalString(oPC, PRC_CRAFT_FILE);
        DeleteLocalInt(oPC, PRC_CRAFT_SPECIAL_BANE);
        DeleteLocalInt(oPC, PRC_CRAFT_SPECIAL_BANE_RACE);
        DeleteLocalInt(oPC, PRC_CRAFT_TOKEN);
        array_delete(oPC, PRC_CRAFT_ITEMPROP_ARRAY);
        /*
        while(GetIsObjectValid(oNewItem))   //clearing inventory
        {
            DestroyObject(oNewItem);
            oNewItem = GetNextItemInInventory(OBJECT_SELF);
        }
        */
    }
    else if(nValue == DYNCONV_ABORTED)
    {
        // This section should never be run, since aborting this conversation should
        // always be forbidden and as such, any attempts to abort the conversation
        // should be handled transparently by the system
        if(DEBUG) DoDebug("prc_craft: ERROR: Conversation abort section run");
    }
    // Handle PC response
    else
    {
        int nChoice = GetChoice(oPC);
        switch(nStage)
        {
            case STAGE_START:
            {
                if(nState == PRC_CRAFT_STATE_NORMAL)
                {
                    SetLocalInt(oPC, PRC_CRAFT_BASEITEMTYPE, nChoice);
                    if(nChoice == BASE_ITEM_GOLEM) nStage = STAGE_CRAFT_GOLEM;
                    else if(nChoice == BASE_ITEM_ALCHEMY) nStage = STAGE_CRAFT_ALCHEMY;
                    else if(nChoice == BASE_ITEM_POISON) nStage = STAGE_CRAFT_POISON;
                    else if(nChoice == BASE_ITEM_ARMOR) nStage = STAGE_CRAFT_AC;
                    else if((nChoice == BASE_ITEM_LONGBOW) ||
                        (nChoice == BASE_ITEM_SHORTBOW)
                        )
                        nStage = STAGE_CRAFT_MIGHTY;
                    else
                        nStage = STAGE_CRAFT_MASTERWORK;
                }
                else if(nState == PRC_CRAFT_STATE_MAGIC)
                {
                    if(nChoice == CHOICE_SETNAME)
                    {
                        //nStage = GetPrevItemPropStage(nStage, oPC, nPropList);
                        //object oListener = SpawnListener("prc_craft_listen", GetLocation(oPC), "**", oPC, 30.0f, TRUE);
                        AddChatEventHook(oPC, "prc_craft_listen", 30.0f);
                        SetLocalObject(oPC, PRC_CRAFT_LISTEN, oItem);
                        SetLocalInt(oPC, PRC_CRAFT_LISTEN, PRC_CRAFT_LISTEN_SETNAME);
                        SendMessageToPC(oPC, "Please state (use chat) the new name of the item within the next 30 seconds.");
                        //ClearCurrentStage(oPC);
                        AllowExit(DYNCONV_EXIT_FORCE_EXIT);
                        break;
                    }
                    else if(nChoice == CHOICE_SETAPPEARANCE)
                    {
                        nStage = STAGE_APPEARANCE;
                    }
                    else if(nChoice == CHOICE_CLONE)
                    {
                        nStage = STAGE_CLONE;
                    }
                    else
                    {
                        if(GetPRCSwitch(PRC_CRAFTING_ARBITRARY))
                        {
                            nType = nChoice;
                            SetLocalInt(oPC, PRC_CRAFT_TYPE, nType);
                            sSubtype = Get2DACache("itempropdef", "SubTypeResRef", nType);
                            SetLocalString(oPC, PRC_CRAFT_SUBTYPE, sSubtype);
                            sCostTable = Get2DACache("itempropdef", "CostTableResRef", nType);
                            if(sCostTable == "0")   //IPRP_BASE1 is blank
                                sCostTable = "";
                            if(sCostTable != "")
                                sCostTable = Get2DACache("iprp_costtable", "Name", StringToInt(sCostTable));
                            SetLocalString(oPC, PRC_CRAFT_COSTTABLE, sCostTable);
                            sParam1 = Get2DACache("itempropdef", "Param1ResRef", nType);
                            if(sParam1 != "")
                                sParam1 = Get2DACache("iprp_paramtable", "TableResRef", StringToInt(sParam1));
                            SetLocalString(oPC, PRC_CRAFT_PARAM1, sParam1);
                            nPropList = 0;
                            if(sSubtype != "")
                                nPropList |= HAS_SUBTYPE;
                            if(sCostTable != "")
                                nPropList |= HAS_COSTTABLE;
                            if(sParam1 != "")
                                nPropList |= HAS_PARAM1;
                            SetLocalInt(oPC, PRC_CRAFT_PROPLIST, nPropList);

                            nStage = GetNextItemPropStage(nStage, oPC, nPropList);
                        }
                        else if(sFile == "")
                        {
                            int nSpell = StringToInt(Get2DACache("iprp_spells", "SpellIndex", nChoice));
                            int bHasSpell = PRCGetHasSpell(nSpell, oPC);
                            int bFailed;
                            int bAllow = FALSE;
                            if(bHasSpell)
                            {
                                bAllow = TRUE;
                                PRCDecrementRemainingSpellUses(oPC, nSpell);
                            }
                            else
                            {
                                if(GetLevelByClass(CLASS_TYPE_ARTIFICER, oPC))
                                {
                                    bAllow = TRUE;
                                    SetLocalInt(oPC, "ArtificerCrafting", TRUE);    //temporary
                                }
                                if(GetLocalInt(oPC, "UsingImbueItem"))
                                {
                                    bAllow = TRUE;
                                }
                            }
                            //imbue item toggled by another feat
                            /*
                            else if(GetHasFeat(FEAT_IMBUE_ITEM, oPC))
                            {
                                SetLocalInt(oPC, "UsingImbueItem", TRUE);
                            }
                            */
                            if(!bAllow)
                            {
                                FloatingTextStringOnCreature("You cannot craft using that spell", oPC, FALSE);
                                bFailed = TRUE;
                            }
                            else
                            {
                                switch(GetBaseItemType(oItem))
                                {
                                    case BASE_ITEM_BLANK_POTION :
                                        // -------------------------------------------------
                                        // Brew Potion
                                        // -------------------------------------------------
                                       bFailed = CICraftCheckBrewPotion(oItem,oPC,nSpell);
                                       break;

                                    case BASE_ITEM_BLANK_SCROLL :
                                       // -------------------------------------------------
                                       // Scribe Scroll
                                       // -------------------------------------------------
                                       bFailed = CICraftCheckScribeScroll(oItem,oPC,nSpell);
                                       break;

                                    case BASE_ITEM_BLANK_WAND :
                                       // -------------------------------------------------
                                       // Craft Wand
                                       // -------------------------------------------------
                                       bFailed = CICraftCheckCraftWand(oItem,oPC,nSpell);
                                       break;

                                    case BASE_ITEM_CRAFTED_ROD :
                                       // -------------------------------------------------
                                       // Craft Rod
                                       // -------------------------------------------------
                                       bFailed = CICraftCheckCraftRod(oItem,oPC,nSpell);
                                       break;

                                    case BASE_ITEM_CRAFTED_STAFF :
                                       // -------------------------------------------------
                                       // Craft Staff
                                       // -------------------------------------------------
                                       bFailed = CICraftCheckCraftStaff(oItem,oPC,nSpell);
                                       break;
									   
                                    case BASE_ITEM_CRAFTED_SCEPTER :
                                       // -------------------------------------------------
                                       // Craft Scepter
                                       // -------------------------------------------------
                                       bFailed = CICraftCheckCraftScepter(oItem,oPC,nSpell);
                                       break;									   

                                    default:
                                        if(GetLocalInt(oPC, "InscribeRune"))
                                        {
                                            bFailed = InscribeRune(oItem,oPC,nSpell);
                                        }
                                        else if (GetStringLeft(GetResRef(oTarget), 5) == "it_gem")
                                        {
                                            bFailed = AttuneGem(oItem,oPC,nSpell);
                                        }
                                        else if(GetLocalInt(oPC, "CraftSkullTalisman"))
                                        {
                                            bFailed = CraftSkullTalisman(oItem,oPC,nSpell);
                                        }

                                        break;

    /*
                                    case BASE_ITEM_CRAFTED_STAFF :
                                       // -------------------------------------------------
                                       // Craft Staff
                                       // -------------------------------------------------
                                       CICraftCheckCraftStaff(oItem,oPC,nSpell);
                                       break;

                                    case BASE_ITEM_CRAFTED_STAFF :
                                       // -------------------------------------------------
                                       // Craft Staff
                                       // -------------------------------------------------
                                       CICraftCheckCraftStaff(oItem,oPC,nSpell);
                                       break;*/
                                }
                            }

                            //do something different if we fail? retry?
                            AllowExit(DYNCONV_EXIT_FORCE_EXIT);
                            break;
                            /*
                            //hardcoding of above for spells
                            sSubtype = "IPRP_SPELLS";
                            sCostTable = "IPRP_CHARGECOST";
                            SetLocalString(oPC, PRC_CRAFT_COSTTABLE, "3");
                            sCostTable = Get2DACache("itempropdef", "CostTableResRef", nType);
                            SetLocalInt(oPC, PRC_CRAFT_PROPLIST, 0);
                            SetLocalInt(oPC, PRC_CRAFT_SUBTYPEVALUE, nChoice);
                            nStage = GetNextItemPropStage(nStage, oPC, nPropList);
                            */
                        }
                        else
                        {
                            SetLocalInt(oPC, PRC_CRAFT_LINE, nChoice);
                            nStage = STAGE_CONFIRM_MAGIC;
                            if(sFile == "craft_weapon" && (nChoice == 26 || nChoice == 27))
                            {
                                nStage = STAGE_BANE;
                            }
                        }
                    }
                }
                MarkStageNotSetUp(nStage, oPC);
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
                        else
                        {
                            nPropList &= (~HAS_PARAM1);
                        }
                        SetLocalString(oPC, PRC_CRAFT_PARAM1, sParam1);
                        SetLocalInt(oPC, PRC_CRAFT_PROPLIST, nPropList);
                    }
                    SetLocalInt(oPC, PRC_CRAFT_PROPLIST, nPropList);
                    SetLocalInt(oPC, PRC_CRAFT_SUBTYPEVALUE, nSubTypeValue);
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
                    SetLocalInt(oPC, PRC_CRAFT_COSTTABLEVALUE, nCostTableValue);
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
                    SetLocalInt(oPC, PRC_CRAFT_PARAM1VALUE, nParam1Value);
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
                    ip = ConstructIP(nType, nSubTypeValue, nCostTableValue, nParam1Value);
                    SetLocalInt(oPC, PRC_CRAFT_HB, 1);
                    int nDelay = GetCraftingTime(nCost);
                    CraftingHB(oPC, oItem, ip, nCost, nXP, sFile, -1, nDelay);
                    AllowExit(DYNCONV_EXIT_FORCE_EXIT);
                }
                break;
            }
            case STAGE_BANE:
            {
                if(nChoice == CHOICE_BACK)
                    nStage = STAGE_START;
                else
                {
                    nStage = STAGE_CONFIRM_MAGIC;
                    SetLocalInt(oPC, PRC_CRAFT_SPECIAL_BANE_RACE, nChoice);
                }
                MarkStageNotSetUp(nStage, oPC);
                break;
            }
            case STAGE_CRAFT_AC:
            {
                if(nChoice == CHOICE_BACK)
                    nStage = STAGE_START;
                else
                {
                    SetLocalInt(oPC, PRC_CRAFT_AC, nChoice);
                    nStage = STAGE_CRAFT_MASTERWORK;
                }
                MarkStageNotSetUp(nStage, oPC);
                break;
            }
            case STAGE_CRAFT_MIGHTY:
            {
                if(nChoice == CHOICE_BACK)
                    nStage = STAGE_START;
                else
                {
                    SetLocalInt(oPC, PRC_CRAFT_MIGHTY, nChoice);
                    nStage = STAGE_CRAFT_MASTERWORK;
                }
                MarkStageNotSetUp(nStage, oPC);
                break;
            }
            case STAGE_CRAFT_MASTERWORK:
            {   //automatically masterwork materials
                if(nChoice == CHOICE_BACK)
                {
                    if(nAC != -1)
                        nStage = STAGE_CRAFT_AC;
                    else if(nMighty != -1)
                        nStage = STAGE_CRAFT_MIGHTY;
                    else
                        nStage = STAGE_START;
                    MarkStageNotSetUp(nStage, oPC);
                }
                else
                {
                    if((nChoice > PRC_CRAFT_FLAG_MASTERWORK) && (nChoice <= PRC_CRAFT_FLAG_DEEP_CRYSTAL))
                        nChoice |= PRC_CRAFT_FLAG_MASTERWORK;
                    SetLocalInt(oPC, PRC_CRAFT_MATERIAL, nChoice);
                    oNewItem = MakeMyItem(oPC, nBase, nAC, nChoice, nMighty);
                    SetIdentified(oNewItem, TRUE);  //just in case
                    SetLocalString(oPC, PRC_CRAFT_TAG, GetTag(oNewItem));
                    nStage = STAGE_CRAFT_CONFIRM;
                }
                MarkStageNotSetUp(nStage, oPC);
                break;
            }
            case STAGE_CRAFT_CONFIRM:
            {
                if(nChoice == CHOICE_BACK)
                {
                    nStage = STAGE_CRAFT_MASTERWORK;
                    DestroyObject(oNewItem, 0.1);
                    MarkStageNotSetUp(nStage, oPC);
                }
                else if(nChoice == CHOICE_CONFIRM)
                {
                    int nSkill = GetCraftingSkill(oNewItem);
                    int bCheck = FALSE;
                    TakeGoldFromCreature(GetLocalInt(oPC, PRC_CRAFT_COST), oPC, TRUE);
                    if(GetCraftingFeat(oNewItem) != FEAT_CRAFT_ARMS_ARMOR)
					{
						// Add this in prc_craft.nss where crafting is confirmed  
						int nTimeScale = GetPRCSwitch(PRC_CRAFTING_TIME_SCALE);  
						SendMessageToPC(oPC, "DEBUG: PRC_CRAFTING_TIME_SCALE = " + IntToString(nTimeScale));  
						  
						int nBaseTime = GetCraftingTime(nCost);  
						SendMessageToPC(oPC, "DEBUG: Base crafting time = " + IntToString(nBaseTime) + " rounds");  
						
						int nFeat = GetCraftingFeat(oItem);						
						int nModifiedTime = GetModifiedTimeCost(nBaseTime, oPC, nFeat);  
						SendMessageToPC(oPC, "DEBUG: Modified crafting time = " + IntToString(nModifiedTime) + " rounds");

						SetLocalInt(oPC, "PRC_CRAFT_REMOVE_MASTERWORK", TRUE);
						CopyItem(oNewItem, oPC, TRUE);
					}
                    else if(GetIsSkillSuccessful(oPC, nSkill, GetCraftingDC(oNewItem)))
                    {
                        bCheck = (nMaterial & PRC_CRAFT_FLAG_MASTERWORK) ? GetIsSkillSuccessful(oPC, nSkill, 20) : TRUE;
                        if(bCheck)
						{
							SetLocalInt(oPC, "PRC_CRAFT_REMOVE_MASTERWORK", TRUE);
							CopyItem(oNewItem, oPC, TRUE);
						}
                    }
                    AllowExit(DYNCONV_EXIT_FORCE_EXIT);
                }
                break;
            }
            case STAGE_CONFIRM_MAGIC:
            {
                if(nChoice == CHOICE_BACK)
                {
                    nStage = STAGE_START;
                    if(GetLocalInt(oPC, PRC_CRAFT_SPECIAL_BANE))
                        nStage = STAGE_BANE;
                    MarkStageNotSetUp(nStage, oPC);
                }
				else if(nChoice == CHOICE_CONFIRM)  
				{   
					// Save the item's UUID when crafting begins  
					object oItem = GetLocalObject(oPC, PRC_CRAFT_ITEM);  
					string sItemUUID = GetObjectUUID(oItem);  
					SQLocalsPlayer_SetString(oPC, "crafting_item_uuid", sItemUUID);  
					SQLocalsPlayer_SetString(oPC, "crafting_item_name", GetName(oItem));
					
					// Construct the item property for this crafting session
					int nType = GetLocalInt(oPC, PRC_CRAFT_TYPE);
					int nSubTypeValue = GetLocalInt(oPC, PRC_CRAFT_SUBTYPEVALUE);
					int nCostTableValue = GetLocalInt(oPC, PRC_CRAFT_COSTTABLEVALUE);
					int nParam1Value = GetLocalInt(oPC, PRC_CRAFT_PARAM1VALUE);
					
					itemproperty ip;
					if(nType > 0)
					{
						ip = ConstructIP(nType, nSubTypeValue, nCostTableValue, nParam1Value);
					}
					
					// Store IP components for persistence
					SetLocalInt(oPC, "PRC_CRAFT_IP_TYPE", nType);
					SetLocalInt(oPC, "PRC_CRAFT_IP_SUBTYPE", nSubTypeValue);
					SetLocalInt(oPC, "PRC_CRAFT_IP_COSTTABLE", nCostTableValue);
					SetLocalInt(oPC, "PRC_CRAFT_IP_PARAM1", nParam1Value);
					  
					SetLocalInt(oPC, PRC_CRAFT_HB, 1);  
					SQLocalsPlayer_SetInt(oPC, "crafting_active", 1);
					CraftingHB(oPC, oItem, ip, nCost, nXP, sFile, nLine, nTime);
					AllowExit(DYNCONV_EXIT_FORCE_EXIT);  
				}
                break;
            }
            case STAGE_APPEARANCE:
            {
                if(nChoice == CHOICE_BACK)
                {
                    nStage = STAGE_START;
                    MarkStageNotSetUp(nStage, oPC);
                }
                else
                {
                    //code here
                    switch(nChoice)
                    {
                        case CHOICE_APPEARANCE_SHOUT:
                        {
                            //object oListener = SpawnListener("prc_craft_listen", GetLocation(oPC), "**", oPC, 30.0f, TRUE);
                            AddChatEventHook(oPC, "prc_craft_listen", 30.0f);
                            SetLocalObject(oPC, PRC_CRAFT_LISTEN, oItem);
                            SetLocalInt(oPC, PRC_CRAFT_LISTEN, PRC_CRAFT_LISTEN_SETAPPEARANCE);
                            SendMessageToPC(oPC, "Please state (use chat) the new item appearance code within the next 30 seconds.");
                            AllowExit(DYNCONV_EXIT_FORCE_EXIT);
                        }
                        case CHOICE_APPEARANCE_SELECT: nStage = STAGE_APPEARANCE_LIST; break;
                    }
                }
                break;
            }
            case STAGE_CLONE:
            {
                if(nChoice == CHOICE_BACK)
                {
                    nStage = STAGE_START;
                    MarkStageNotSetUp(nStage, oPC);
                }
                else if(nChoice == CHOICE_CONFIRM)
                {
                    SetLocalInt(oPC, PRC_CRAFT_HB, 1);
                    CraftingHB(oPC, oItem, ip, nCost, nXP, sFile, -2, nTime);
                    AllowExit(DYNCONV_EXIT_FORCE_EXIT);
                }
                break;
            }
            case STAGE_CRAFT_GOLEM:
            {
                if(nChoice == CHOICE_BACK)
                {
                    nStage = STAGE_START;
                    MarkStageNotSetUp(nStage, oPC);
                }
                else
                {
                    struct golemhds ghds = GetGolemHDsFromString(Get2DACache(sFile, "HD", nLine));
                    SetLocalInt(oPC, PRC_CRAFT_LINE, nChoice);
                    SetLocalInt(oPC, PRC_CRAFT_PARAM1VALUE, ghds.base);
                }
                break;
            }
            case STAGE_CRAFT_GOLEM_HD:
            {
                if(nChoice == CHOICE_BACK)
                {
                    nStage = STAGE_CRAFT_GOLEM;
                    MarkStageNotSetUp(nStage, oPC);
                }
                else
                {
                    struct golemhds ghds = GetGolemHDsFromString(Get2DACache(sFile, "HD", nLine));
                    //code here
                    switch(nChoice)
                    {
                        case CHOICE_PLUS_1: nParam1Value++; break;
                        case CHOICE_PLUS_10: nParam1Value+= 10; break;
                        case CHOICE_MINUS_1: nParam1Value--; break;
                        case CHOICE_MINUS_10: nParam1Value-= 10; break;

                        //placeholder
                        case CHOICE_CONFIRM:
                        {
                            CraftingHB(oPC, oItem, ip, nCost, nXP, sFile, -2, nTime);
                            AllowExit(DYNCONV_EXIT_FORCE_EXIT);
                            break;
                        }
                    }
                    if(nParam1Value < ghds.base) nParam1Value = ghds.base;
                    if(nParam1Value > ghds.max2) nParam1Value = ghds.max2;
                }
                break;
            }
            case STAGE_CRAFT_ALCHEMY:
            {
                if(nChoice == CHOICE_BACK)
                {
                    nStage = STAGE_START;
                    MarkStageNotSetUp(nStage, oPC);
                }
                else
                {
                    nStage = STAGE_CONFIRM_ALCHEMY;
                    SetLocalInt(oPC, PRC_CRAFT_LINE, nChoice);
                }
                break;
            }
            case STAGE_CONFIRM_ALCHEMY:
            {
                if(nChoice == CHOICE_BACK)
                {
                    nStage = STAGE_START;
                    MarkStageNotSetUp(nStage, oPC);
                }
                else if(nChoice == CHOICE_CONFIRM)
                {
                    int nCost = StringToInt(Get2DACache("prc_craft_alchem", "GoldCost", nLine));
                    if(GetGold(oPC) < nCost)
                    {
                        FloatingTextStringOnCreature("Crafting: Insufficient gold!", oPC);
                        return;
                    }
                    int nDC = StringToInt(Get2DACache("prc_craft_alchem", "CraftDC", nLine));
                    string sResRef = Get2DACache("prc_craft_alchem", "ResRef", nLine);
                    TakeGoldFromCreature(nCost, oPC, TRUE);
                    if(GetIsSkillSuccessful(oPC, SKILL_CRAFT_ALCHEMY, nDC))
                    {
                        SendMessageToPC(oPC, "Item successfully created.");
                        object oItem = CreateItemOnObject(sResRef, oPC);
                    }
                    AllowExit(DYNCONV_EXIT_FORCE_EXIT);
                }
                break;
            }
            case STAGE_CRAFT_POISON:
            {
                if(nChoice == CHOICE_BACK)
                {
                    nStage = STAGE_START;
                    MarkStageNotSetUp(nStage, oPC);
                }
                else
                {
                    nStage = STAGE_CONFIRM_POISON;
                    SetLocalInt(oPC, PRC_CRAFT_LINE, nChoice);
                }
                break;
            }
            case STAGE_CONFIRM_POISON:
            {
                if(nChoice == CHOICE_BACK)
                {
                    nStage = STAGE_START;
                    MarkStageNotSetUp(nStage, oPC);
                }
                else if(nChoice == CHOICE_CONFIRM)
                {
                    int bIngredients = GetPRCSwitch(PRC_CRAFT_POISON_USE_INGREDIENTS);
                    int nCost = StringToInt(Get2DACache("prc_craft_poison", "GoldCost", nLine));
                    int nPCGold = GetGold(oPC);
                    object oIngr1, oIngr2;
                    if(bIngredients)
                    {
                        int bHasIngr1 = TRUE, bHasIngr2 = TRUE;
                        string sIngr1 = Get2DACache("prc_craft_poison", "Ingr1", nLine);
                        string sIngr1Name = Get2DACache("prc_craft_poison", "Ingr1Name", nLine);
                        string sIngr2 = Get2DACache("prc_craft_poison", "Ingr2", nLine);
                        string sIngr2Name = Get2DACache("prc_craft_poison", "Ingr2Name", nLine);
                        if(sIngr1 != "")
                        {
                            nCost /= 10;//this poison requires at least one ingredient, so we decrease crafting cost here
                            bHasIngr1 = FALSE;
                        }
                        if(sIngr2 != "")
                            bHasIngr2 = FALSE;

                        oIngr1 = GetItemPossessedBy(oPC, sIngr1);
                        if(GetIsObjectValid(oIngr1))
                            bHasIngr1 = TRUE;
                        oIngr2 = GetItemPossessedBy(oPC, sIngr2);
                        if(GetIsObjectValid(oIngr2))
                            bHasIngr2 = TRUE;

                        if(!bHasIngr1 || !bHasIngr2)// we don't have required ingredients, abort crafting
                        {
                            if(!bHasIngr1)
                                FloatingTextStringOnCreature("Ingredient missing: " + sIngr1Name, oPC, FALSE);
                            if(!bHasIngr2)
                                FloatingTextStringOnCreature("Ingredient missing: " + sIngr2Name, oPC, FALSE);
                            return;
                        }
                    }
                    if(GetGold(oPC) < nCost)
                    {
                        FloatingTextStringOnCreature("Crafting: Insufficient gold!", oPC);
                        return;
                    }
                    int nPoison = GetSkillRank(SKILL_CRAFT_POISON, oPC);
                    int nAlchem = GetSkillRank(SKILL_CRAFT_ALCHEMY, oPC);
                    int nDC = StringToInt(Get2DACache("prc_craft_poison", "CraftDC", nLine));
                    string sPoison = Get2DACache("prc_craft_poison", "Poison2daLine", nLine);
                    int nName = StringToInt(Get2DACache("prc_craft_poison", "Name", nLine));
                    int nDesc = StringToInt(Get2DACache("prc_craft_poison", "Description", nLine));
                    int nType = StringToInt(Get2DACache("prc_craft_poison", "PoisonType", nLine));
                    int nSkill = SKILL_CRAFT_POISON;
                    //Use alchemy skill if it is 5 or more higher than craft(poisonmaking). DC is increased by 4.
                    if((nAlchem - nPoison) > 4)
                    {
                        nSkill = SKILL_CRAFT_ALCHEMY;
                        nDC += 4;
                        if(DEBUG) DoDebug("Using craft(alchemy) instead of craft(poison). New DC is "+ IntToString(nDC) + ".");
                    }
                    TakeGoldFromCreature(nCost, oPC, TRUE);
                    if(GetIsSkillSuccessful(oPC, nSkill, nDC))
                    {
                        // remove used ingredients
                        int nStack = GetNumStackedItems(oIngr1);
                        if(nStack > 1)
                            SetItemStackSize(oIngr1, --nStack);
                        else
                            DestroyObject(oIngr1);

                        nStack = GetNumStackedItems(oIngr2);
                        if(nStack > 1)
                            SetItemStackSize(oIngr2, --nStack);
                        else
                            DestroyObject(oIngr2);

                        SendMessageToPC(oPC, "Item successfully created.");
                        object oPoison;
                        if(nType == 0) oPoison = CreateItemOnObject("prc_it_poist0", oPC, 1, "prc_it_pois" + sPoison);
                        else if(nType == 1) oPoison = CreateItemOnObject("prc_it_poist1", oPC, 1, "prc_it_pois" + sPoison);
                        else if(nType == 2) oPoison = CreateItemOnObject("prc_it_poist2", oPC, 1, "prc_it_pois" + sPoison);
                        else if(nType == 3) oPoison = CreateItemOnObject("prc_it_poist3", oPC, 1, "prc_it_pois" + sPoison);
                        else
                        {
                            SendMessageToPC(oPC, "Invalid poison type. Aborting.");
                            GiveGoldToCreature(oPC, nCost);
                            return;
                        }
                        //Set name and description
                        SetName(oPoison, GetStringByStrRef(nName));
                        SetDescription(oPoison, GetStringByStrRef(nDesc));
						SetLocalInt(oPoison, "pois_idx", StringToInt(sPoison));
						
                    }
                    AllowExit(DYNCONV_EXIT_FORCE_EXIT);
                }
                break;
            }

            /*
            case <CONSTANT>:
            {
                if(nChoice == CHOICE_BACK)
                {
                    nStage = STAGE_START;
                    MarkStageNotSetUp(nStage, oPC);
                }
                else
                {
                    //code here
                    switch(nChoice)
                    {
                        case a: nStage = a; break;
                        case a: nStage = a; break;
                        case a: nStage = a; break;
                    }
                }
                break;
            }
            */
        }
        if(DEBUG) DoDebug("Next stage: " + IntToString(nStage));
        SetStage(nStage, oPC);
    }
    DeleteLocalInt(oPC, "PRC_CRAFT_TERMINATED");
}
