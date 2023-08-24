//:://////////////////////////////////////////////
//:: Samurai Ancestral Daisho conversation
//:: codi_s2_ancdaic
//:://////////////////////////////////////////////
/** @file



    @author Primogenitor
    @date   Created  - 2006.01.24
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "inc_dynconv"

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_ENTRY               = 0;
const int STAGE_IMPROVE             = 1;
const int STAGE_IMPROVE_TYPE        = 2;
const int STAGE_IMPROVE_SUB_TYPE    = 3;
const int STAGE_IMPROVE_PARAM1      = 4;
const int STAGE_IMPROVE_VALUE       = 5;
const int STAGE_IMPROVE_ADD         = 6;

const int ERROR_CODE_5_FIX =1;

const int CHOICE_RETURN_TO_PREVIOUS = 0xFFFFFFFF;

//////////////////////////////////////////////////
/* Aid functions                                */
//////////////////////////////////////////////////



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
                SetHeader("You have invoked the power of your ancestral daisho. What would you like to do?");
                AddChoice("[Sacrifice one or more items]", 1, oPC);
                AddChoice("[Improve an ancestral weapon]", 2, oPC);
                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_IMPROVE)
            {
                SetHeader("Which type of weapon would you like to improve?");
                AddChoice("[Katana]", 1, oPC);
                AddChoice("[Wakizashi (short sword)]", 2, oPC);
                AddChoice("Go back.", CHOICE_RETURN_TO_PREVIOUS, oPC);
                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_IMPROVE_TYPE)
            {
                SetHeader("Which type of itemproperty do you wish to add?");
                AddChoice("Go back.", CHOICE_RETURN_TO_PREVIOUS, oPC);
                int nRow      = 0;
                string sLabel = Get2DACache("itempropdef", "Label", nRow);
                while(sLabel != "")
                {
                    int bIsValid = StringToInt(Get2DACache("itemprops", "0_Melee", nRow));
                    if(bIsValid)
                    {
                        int nStrRef = StringToInt(Get2DACache("itemprops", "StringRef", nRow));
                        if(nStrRef && !GetPRCSwitch(PRC_SAMURAI_BAN_+IntToString(nRow)+"_*_*_*"))
                            AddChoice(GetStringByStrRef(nStrRef), nRow, oPC);
                    }
                    nRow++;
                    sLabel = Get2DACache("itempropdef", "Label", nRow);
                }
            }
            else if(nStage == STAGE_IMPROVE_SUB_TYPE)
            {
                int nType = GetLocalInt(oPC, "codi_ancdai_type");
                SetHeader("Which subtype of itemproperty do you wish to add?");
                AddChoice("Go back.", CHOICE_RETURN_TO_PREVIOUS, oPC);
                string sSubTypeResRef = Get2DACache("itempropdef", "SubTypeResRef", nType);
                int i;
                for(i=0;i<200;i++)
                {
                    int nStrRef = StringToInt(Get2DACache(sSubTypeResRef, "Name", i));
                    if(nStrRef != 0)
                    {
                        if(!GetPRCSwitch(PRC_SAMURAI_BAN_+IntToString(nType)+"_"+IntToString(i)+"_*_*"))
                            AddChoice(GetStringByStrRef(nStrRef), i, oPC);
                    }
                }
            }
            else if(nStage == STAGE_IMPROVE_PARAM1)
            {
                int nType = GetLocalInt(oPC, "codi_ancdai_type");
                int nSubType = GetLocalInt(oPC, "codi_ancdai_subtype");
                SetHeader("Which variation of itemproperty do you wish to add?");
                AddChoice("Go back.", CHOICE_RETURN_TO_PREVIOUS, oPC);
                string sParam1ResRef = Get2DACache("itempropdef", "Param1ResRef", nType);
                //may depend on subtype
                if(sParam1ResRef == "")
                {
                    string sSubTypeResRef = Get2DACache("itempropdef", "SubTypeResRef", nType);
                    if(sSubTypeResRef != "")
                    {
                        sParam1ResRef = Get2DACache(sSubTypeResRef, "Param1ResRef", nSubType);
                    }
                }
                //lookup the number to get the real filename
                sParam1ResRef = Get2DACache("iprp_paramtable", "TableResRef", StringToInt(sParam1ResRef));
                //now loop over rows
                int i;
                for(i=0;i<200;i++)
                {
                    int nStrRef = StringToInt(Get2DACache(sParam1ResRef, "Name", i));
                    if(nStrRef != 0)
                    {
                        if(!GetPRCSwitch(PRC_SAMURAI_BAN_+IntToString(nType)+"_"+IntToString(nSubType)+"_"+IntToString(i)+"_*")
                            && !GetPRCSwitch(PRC_SAMURAI_BAN_+IntToString(nType)+"_*_"+IntToString(i)+"_*"))
                            AddChoice(GetStringByStrRef(nStrRef), i, oPC);
                    }
                }
            }
            else if(nStage == STAGE_IMPROVE_VALUE)
            {
                int nType = GetLocalInt(oPC, "codi_ancdai_type");
                int nSubType = GetLocalInt(oPC, "codi_ancdai_subtype");
                int nParam1 = GetLocalInt(oPC, "codi_ancdai_param1");
                SetHeader("Which value of itemproperty do you wish to add?");
                AddChoice("Go back.", CHOICE_RETURN_TO_PREVIOUS, oPC);
                string sCostResRef = Get2DACache("itempropdef", "CostTableResRef", nType);
                //lookup the number to get the real filename
                sCostResRef = Get2DACache("iprp_costtable", "Name", StringToInt(sCostResRef));
                int i;
                for(i=0;i<200;i++)
                {
                    int nStrRef = StringToInt(Get2DACache(sCostResRef, "Name", i));
                    if(nStrRef != 0)
                    {
                        if(!GetPRCSwitch(PRC_SAMURAI_BAN_+IntToString(nType)+"_"+IntToString(nSubType)+"_"+IntToString(nParam1)+"_"+IntToString(i))
                            && !GetPRCSwitch(PRC_SAMURAI_BAN_+IntToString(nType)+"_*_"+IntToString(nParam1)+"_"+IntToString(i))
                            && !GetPRCSwitch(PRC_SAMURAI_BAN_+IntToString(nType)+"_*_*_"+IntToString(i)))
                            AddChoice(GetStringByStrRef(nStrRef), i, oPC);
                    }
                }
            }
            else if(nStage == STAGE_IMPROVE_ADD)
            {
                int nType = GetLocalInt(oPC, "codi_ancdai_type");
                int nSubType = GetLocalInt(oPC, "codi_ancdai_subtype");
                int nParam1 = GetLocalInt(oPC, "codi_ancdai_param1");
                int nValue = GetLocalInt(oPC, "codi_ancdai_value");
                int nVar2;
                int nVar3;
                int nVar4;
                //assign then in order
                string sSubType = Get2DACache("itempropdef", "SubTypeResRef", nType);
                string sParam1ResRef = Get2DACache("itempropdef", "Param1ResRef", nType);
                string sValueResRef = Get2DACache("itempropdef", "CostTableResRef", nType);
                if(sParam1ResRef == "")
                {
                    //if there is a subtype, param1 may be defined there
                    if(sSubType != "")
                        sParam1ResRef = Get2DACache(sSubType, "Param1ResRef", nSubType);
                }

                if(sSubType != "")
                {
                    nVar2 = nSubType;
                    if(sParam1ResRef != "")
                    {
                        nVar3 = nParam1;
                        if(sValueResRef != "")
                            nVar4 = nValue;
                    }
                    else if(sValueResRef != "")
                        nVar3 = nValue;
                }
                else if(sParam1ResRef != "")
                {
                    nVar2 = nParam1;
                    if(sValueResRef != "")
                        nVar3 = nValue;
                }
                else if(sValueResRef != "")
                    nVar2 = nValue;
                //fudges to turn types into vars
                if(nType == ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP
                    || nType == ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP
                    || nType == ITEM_PROPERTY_DAMAGE_BONUS_VS_SPECIFIC_ALIGNMENT)
                {
//                    int nTemp = nVar3;
//                    nVar3 = nVar4;
//                    nVar4 = nTemp;
                }
                //get the itemproperty
                itemproperty ipToAdd = IPGetItemPropertyByID(nType, nVar2, nVar3, nVar4);
                if(!GetIsItemPropertyValid(ipToAdd))
                    DoDebug("Itemproperty Not Valid");

                //set the header
                SetHeader("You are attempting to add "+ItemPropertyToString(ipToAdd));

                //work out cost
                object oItem = GetLocalObject(oPC, "codi_ancdai");
                object oCopy = CopyItem(oItem, GetObjectByTag("HEARTOFCHAOS"), TRUE);
                if(!GetIsObjectValid(oCopy))
                    DoDebug("Copy not valid");
                SetIdentified(oCopy, TRUE);
                SetPlotFlag(oCopy, FALSE);
                SetStolenFlag(oCopy, FALSE);
                int nOldValue = GetGoldPieceValue(oCopy);
                IPSafeAddItemProperty(oCopy, ipToAdd);
                int nNewValue = GetGoldPieceValue(oCopy);
                int nIPCost = nNewValue-nOldValue;
                //sanity check for infinite gold
                if(nIPCost < 0)
                {
                    AddChoice("You cannot add this because it would lower the value of your weapon.", CHOICE_RETURN_TO_PREVIOUS, oPC);
                }
                else
                {
                    int nSacrificed = GetPersistantLocalInt(oPC, "CODI_SAMURAI");
                    if(nIPCost > nSacrificed)
                        AddChoice("You cannot add this because it would cost more than you have sacrificed ("+
                            IntToString(nIPCost)+" vs "+IntToString(nSacrificed)+")", CHOICE_RETURN_TO_PREVIOUS, oPC);
                    else
                    {
                        int nMaxValue;
                        //get maxvalue based on character level & Epic Ancestral Daisho feats
                        int nSamuraiLevel =  GetHitDice(oPC);
                        if(nSamuraiLevel >=4 && nSamuraiLevel < 7)
                            nMaxValue =     2000;
                        else if(nSamuraiLevel >=7 && nSamuraiLevel < 9)
                            nMaxValue =     8000;
                        else if(nSamuraiLevel >=9 && nSamuraiLevel < 11)
                            nMaxValue =    18000;
                        else if(nSamuraiLevel >=11 && nSamuraiLevel < 13)
                            nMaxValue =    32000;
                        else if(nSamuraiLevel >=13 && nSamuraiLevel < 14)
                            nMaxValue =    50000;
                        else if(nSamuraiLevel >=14 && nSamuraiLevel < 15)
                            nMaxValue =    72000;
                        else if(nSamuraiLevel >=15 && nSamuraiLevel < 16)
                            nMaxValue =    98000;
                        else if(nSamuraiLevel >=16 && nSamuraiLevel < 17)
                            nMaxValue =   126000;
                        else if(nSamuraiLevel >=17 && nSamuraiLevel < 18)
                            nMaxValue =   162000;
                        else if(nSamuraiLevel >= 18)
                        {
                            nMaxValue =   200000;
                            if(GetHasFeat(FEAT_EPIC_ANCESTRAL_DAISHO_10))
                                nMaxValue =  8000000;
                            else if(GetHasFeat(FEAT_EPIC_ANCESTRAL_DAISHO_9))
                                nMaxValue =  7220000;
                            else if(GetHasFeat(FEAT_EPIC_ANCESTRAL_DAISHO_8))
                                nMaxValue =  6480000;
                            else if(GetHasFeat(FEAT_EPIC_ANCESTRAL_DAISHO_7))
                                nMaxValue =  5780000;
                            else if(GetHasFeat(FEAT_EPIC_ANCESTRAL_DAISHO_6))
                                nMaxValue =  5120000;
                            else if(GetHasFeat(FEAT_EPIC_ANCESTRAL_DAISHO_5))
                                nMaxValue =  4500000;
                            else if(GetHasFeat(FEAT_EPIC_ANCESTRAL_DAISHO_4))
                                nMaxValue =  3920000;
                            else if(GetHasFeat(FEAT_EPIC_ANCESTRAL_DAISHO_3))
                                nMaxValue =  3380000;
                            else if(GetHasFeat(FEAT_EPIC_ANCESTRAL_DAISHO_2))
                                nMaxValue =  2880000;
                            else if(GetHasFeat(FEAT_EPIC_ANCESTRAL_DAISHO_1))
                                nMaxValue =  2420000;
                        }
                        if(GetPRCSwitch(PRC_SAMURAI_VALUE_SCALAR_x100))
                            nMaxValue = FloatToInt(IntToFloat(nMaxValue)*(IntToFloat(GetPRCSwitch(PRC_SAMURAI_VALUE_SCALAR_x100))/100.0));
                        //get the items
                        object oKatana;
                        object oWakizashi;
                        int i;
                        for(i=0;i<14;i++)
                        {
                            object oTest = GetItemInSlot(i, oPC);
                            if(GetTag(oTest) == "codi_katana")
                                oKatana = oTest;
                            if(GetTag(oTest) == "codi_wakizashi")
                                oWakizashi = oTest;
                        }
                        object oTest = GetFirstItemInInventory(oPC);
                        while(GetIsObjectValid(oTest)
                            && (!GetIsObjectValid(oKatana)
                                || !GetIsObjectValid(oWakizashi)))
                        {
                            if(GetTag(oTest) == "codi_katana")
                                oKatana = oTest;
                            if(GetTag(oTest) == "codi_wakizashi")
                                oWakizashi = oTest;
                            oTest = GetNextItemInInventory(oPC);
                        }
                        //get the value
                        int nCurrentValue = nNewValue;
                        if(oWakizashi == oItem)
                        {
                            nCurrentValue += GetGoldPieceValue(oKatana);
                        }
                        else
                            nCurrentValue += GetGoldPieceValue(oWakizashi);

                        if(nCurrentValue > nMaxValue)
                        {
                            AddChoice("You cannot add this because it would bring the total value above your limit ("+
                                IntToString(nCurrentValue)+" vs "+IntToString(nMaxValue)+")", CHOICE_RETURN_TO_PREVIOUS, oPC);
                        }
                        else
                        {
                            AddChoice("This will cost "+IntToString(nIPCost)+" from your sacrificed total of "+IntToString(nSacrificed), TRUE, oPC);
                            AddChoice("This cost is too great at the moment", CHOICE_RETURN_TO_PREVIOUS, oPC);
                        }
                    }
                }
            }
        }

        // Do token setup
        SetupTokens();
    }
    // End of conversation cleanup
    else if(nValue == DYNCONV_EXITED)
    {
        // Add any locals set through this conversation
        DeleteLocalObject(oPC, "codi_ancdai");
        DeleteLocalInt(oPC, "codi_ancdai_type");
        DeleteLocalInt(oPC, "codi_ancdai_subtype");
        DeleteLocalInt(oPC, "codi_ancdai_param1");
        DeleteLocalInt(oPC, "codi_ancdai_value");
    }
    // Abort conversation cleanup.
    // NOTE: This section is only run when the conversation is aborted
    // while aborting is allowed. When it isn't, the dynconvo infrastructure
    // handles restoring the conversation in a transparent manner
    else if(nValue == DYNCONV_ABORTED)
    {
        // Add any locals set through this conversation
        DeleteLocalObject(oPC, "codi_ancdai");
        DeleteLocalInt(oPC, "codi_ancdai_type");
        DeleteLocalInt(oPC, "codi_ancdai_subtype");
        DeleteLocalInt(oPC, "codi_ancdai_param1");
        DeleteLocalInt(oPC, "codi_ancdai_value");
    }
    // Handle PC responses
    else
    {
        // variable named nChoice is the value of the player's choice as stored when building the choice list
        // variable named nStage determines the current conversation node
        int nChoice = GetChoice(oPC);
        if(nStage == STAGE_ENTRY)
        {
            if(nChoice == 1) //sacrifice items
            {
                object oAltar = CreateObject(OBJECT_TYPE_PLACEABLE, "codi_sam_altar", GetLocation(oPC));
                AssignCommand(oPC, ClearAllActions());
                AssignCommand(oPC, DoPlaceableObjectAction(oAltar, PLACEABLE_ACTION_USE));
                SPApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY), oAltar);
                DestroyObject(oAltar, 360.0); //6 minutes
                AllowExit(DYNCONV_EXIT_FORCE_EXIT);
            }
            else if(nChoice == 2) //improve weapon
            {
                MarkStageNotSetUp(nStage, oPC);
                nStage = STAGE_IMPROVE;
                MarkStageNotSetUp(nStage, oPC);
            }

        }
        else if(nStage == STAGE_IMPROVE)
        {
            if(nChoice == 1) //katana
            {
                object oKatana;
                object oTest;
                int i;
                for(i=0;i<14;i++)
                {
                    oTest = GetItemInSlot(i, OBJECT_SELF);
                    if(GetTag(oTest) == "codi_katana")
                        oKatana = oTest;
                }
                oTest = GetFirstItemInInventory(OBJECT_SELF);
                while(GetIsObjectValid(oTest)
                    && !GetIsObjectValid(oKatana))
                {
                    if(GetTag(oTest) == "codi_katana")
                        oKatana = oTest;
                    oTest = GetNextItemInInventory(OBJECT_SELF);
                }
                SetLocalObject(oPC, "codi_ancdai", oKatana);
                MarkStageNotSetUp(nStage, oPC);
                nStage = STAGE_IMPROVE_TYPE;
                MarkStageNotSetUp(nStage, oPC);
            }
            else if(nChoice == 2) //wakizashi
            {
                object oWakizashi;
                object oTest;
                int i;
                for(i=0;i<14;i++)
                {
                    oTest = GetItemInSlot(i, OBJECT_SELF);
                    if(GetTag(oTest) == "codi_wakizashi")
                        oWakizashi = oTest;
                }
                oTest = GetFirstItemInInventory(OBJECT_SELF);
                while(GetIsObjectValid(oTest)
                    && !GetIsObjectValid(oWakizashi))
                {
                    if(GetTag(oTest) == "codi_wakizashi")
                        oWakizashi = oTest;
                    oTest = GetNextItemInInventory(OBJECT_SELF);
                }
                SetLocalObject(oPC, "codi_ancdai", oWakizashi);
                MarkStageNotSetUp(nStage, oPC);
                nStage = STAGE_IMPROVE_TYPE;
                MarkStageNotSetUp(nStage, oPC);
            }
            else if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
            {
                MarkStageNotSetUp(nStage, oPC);
                nStage = STAGE_ENTRY;
                MarkStageNotSetUp(nStage, oPC);
            }
        }
        else if(nStage == STAGE_IMPROVE_TYPE)
        {
            if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
            {
                MarkStageNotSetUp(nStage, oPC);
                nStage = STAGE_IMPROVE;
                MarkStageNotSetUp(nStage, oPC);
            }
            else
            {
                int nType = nChoice;
                SetLocalInt(oPC, "codi_ancdai_type", nChoice);
                //look for subtype
                string sSubType = Get2DACache("itempropdef", "SubTypeResRef", nType);
                if(sSubType != "")
                    nStage = STAGE_IMPROVE_SUB_TYPE;
                else
                {
                    //no subtype
                    //check param1
                    string sParam1ResRef = Get2DACache("itempropdef", "Param1ResRef", nType);
                    if(sParam1ResRef != "")
                    {
                        nStage = STAGE_IMPROVE_PARAM1;
                    }
                    else
                    {
                        //no param1
                        //check value
                        int nValueResRef = StringToInt(Get2DACache("itempropdef", "CostTableResRef", nType));
                        if(nValueResRef)
                        {
                            nStage = STAGE_IMPROVE_VALUE;
                        }
                        else
                        {
                            //no value
                            //proceed to add
                            MarkStageNotSetUp(nStage, oPC);
                            nStage = STAGE_IMPROVE_ADD;
                            MarkStageNotSetUp(nStage, oPC);
                        }
                    }
                }
            }

        }
        else if(nStage == STAGE_IMPROVE_SUB_TYPE)
        {
            if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
            {
                MarkStageNotSetUp(nStage, oPC);
                nStage = STAGE_IMPROVE_TYPE;
                MarkStageNotSetUp(nStage, oPC);
            }
            else
            {
                SetLocalInt(oPC, "codi_ancdai_subtype", nChoice);
                int nType = GetLocalInt(oPC, "codi_ancdai_type");
                int nSubType = nChoice;
                //check param1
                string sParam1ResRef = Get2DACache("itempropdef", "Param1ResRef", nType);
                if(sParam1ResRef != "")
                {
                    nStage = STAGE_IMPROVE_PARAM1;
                }
                else
                {
                    //if there is a subtype, param1 may be defined there
                    string sSubType = Get2DACache("itempropdef", "SubTypeResRef", nType);
                    if(sSubType != "")
                    {
                        sParam1ResRef = Get2DACache(sSubType, "Param1ResRef", nSubType);
                        if(sParam1ResRef != "")
                        {
                            nStage = STAGE_IMPROVE_PARAM1;
                        }
                        else
                        {
                            //certainly no param1 now
                            //cheat a bit and pretend no subtype to get into the next if statement
                            sSubType = "";
                        }
                    }
                    //this is not an else statement
                    if(sSubType == "")
                    {
                        //no param1
                        //check value
                        int nValueResRef = StringToInt(Get2DACache("itempropdef", "CostTableResRef", nType));
                        if(nValueResRef)
                        {
                            nStage = STAGE_IMPROVE_VALUE;
                        }
                        else
                        {
                            //no value
                            //proceed to add
                            MarkStageNotSetUp(nStage, oPC);
                            nStage = STAGE_IMPROVE_ADD;
                            MarkStageNotSetUp(nStage, oPC);
                        }
                    }
                }
            }
        }
        else if(nStage == STAGE_IMPROVE_PARAM1)
        {
            if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
            {
                MarkStageNotSetUp(nStage, oPC);
                nStage = STAGE_IMPROVE_TYPE;
                MarkStageNotSetUp(nStage, oPC);
            }
            else
            {
                SetLocalInt(oPC, "codi_ancdai_param1", nChoice);
                int nType = GetLocalInt(oPC, "codi_ancdai_type");
                int nSubType = GetLocalInt(oPC, "codi_ancdai_subtype");
                //check value
                string sValueResRef = Get2DACache("itempropdef", "CostTableResRef", nType);
                if(sValueResRef != "")
                {
                    nStage = STAGE_IMPROVE_VALUE;
                }
                else
                {
                    //no value
                    //proceed to add
                    MarkStageNotSetUp(nStage, oPC);
                    nStage = STAGE_IMPROVE_ADD;
                    MarkStageNotSetUp(nStage, oPC);
                }
            }
        }
        else if(nStage == STAGE_IMPROVE_VALUE)
        {
            if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
            {
                MarkStageNotSetUp(nStage, oPC);
                nStage = STAGE_IMPROVE_TYPE;
                MarkStageNotSetUp(nStage, oPC);
            }
            else
            {
                SetLocalInt(oPC, "codi_ancdai_value", nChoice);
                int nType = GetLocalInt(oPC, "codi_ancdai_type");
                //proceed to add
                nStage = STAGE_IMPROVE_ADD;
            }
        }
        else if(nStage == STAGE_IMPROVE_ADD)
        {
            if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
            {
                MarkStageNotSetUp(nStage, oPC);
                nStage = STAGE_ENTRY;
                MarkStageNotSetUp(nStage, oPC);
            }
            else if(nChoice == TRUE)
            {
                //store old cost
                object oItem = GetLocalObject(oPC, "codi_ancdai");
                int nOldPlot = GetPlotFlag(oItem);
                int nOldValue = GetGoldPieceValue(oItem);
                SetPlotFlag(oItem, nOldPlot);
                SetStolenFlag(oItem, nOldPlot);
                int nSacrificed = GetPersistantLocalInt(oPC, "CODI_SAMURAI");
                //add the itemproperty
                int nType = GetLocalInt(oPC, "codi_ancdai_type");
                int nSubType = GetLocalInt(oPC, "codi_ancdai_subtype");
                int nParam1 = GetLocalInt(oPC, "codi_ancdai_param1");
                int nValue = GetLocalInt(oPC, "codi_ancdai_value");
                int nVar2;
                int nVar3;
                int nVar4;
                //assign then in order
                string sSubType = Get2DACache("itempropdef", "SubTypeResRef", nType);
                string sParam1ResRef = Get2DACache("itempropdef", "Param1ResRef", nType);
                string sValueResRef = Get2DACache("itempropdef", "CostTableResRef", nType);
                if(sParam1ResRef == "")
                {
                    //if there is a subtype, param1 may be defined there
                    if(sSubType != "")
                        sParam1ResRef = Get2DACache(sSubType, "Param1ResRef", nSubType);
                }

                if(sSubType != "")
                {
                    nVar2 = nSubType;
                    if(sParam1ResRef != "")
                    {
                        nVar3 = nParam1;
                        if(sValueResRef != "")
                            nVar4 = nValue;
                    }
                    else if(sValueResRef != "")
                        nVar3 = nValue;
                }
                else if(sParam1ResRef != "")
                {
                    nVar2 = nParam1;
                    if(sValueResRef != "")
                        nVar3 = nValue;
                }
                else if(sValueResRef != "")
                    nVar2 = nValue;
                //fudges to turn types into vars
                if(nType == ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP
                    || nType == ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP
                    || nType == ITEM_PROPERTY_DAMAGE_BONUS_VS_SPECIFIC_ALIGNMENT)
                {
                    int nTemp = nVar3;
                    nVar3 = nVar4;
                    nVar4 = nTemp;
                }
                //get the itemproperty
                itemproperty ipToAdd = IPGetItemPropertyByID(nType, nVar2, nVar3, nVar4);
                if(!GetIsItemPropertyValid(ipToAdd))
                    DoDebug("Itemproperty Not Valid");
                IPSafeAddItemProperty(oItem, ipToAdd);
                //remove gold cost
                //only works if non-plot
                int nNewPlot = GetPlotFlag(oItem);
                int nNewValue = GetGoldPieceValue(oItem);
                SetPlotFlag(oItem, nNewPlot);
                SetStolenFlag(oItem, nNewPlot);
                int nIPCost = nNewValue-nOldValue;
                SetPersistantLocalInt(oPC, "CODI_SAMURAI", nSacrificed-nIPCost);
                //go back to start
                MarkStageNotSetUp(nStage, oPC);
                nStage = STAGE_ENTRY;
                MarkStageNotSetUp(nStage, oPC);
            }
        }

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
