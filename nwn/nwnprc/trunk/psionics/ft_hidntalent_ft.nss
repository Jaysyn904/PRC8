//:://////////////////////////////////////////////////////////////////    
//:: Hidden Talent    
//:: ft_hidntalent_ft    
//:://////////////////////////////////////////////////////////////////    
/** @file    
    This allows you to pick a hidden talent @ 1st level    
    
    @original author Fencas    
    @date   Created  - 2025-01-12    
	    
	@revised by Jaysyn (for Hidden Talent)    
    @date   Revised  - 2025-01-30 07:42:03    
*/    
//:://////////////////////////////////////////////////////////////////    
    
#include "inc_dynconv"    
#include "prc_inc_function"    
#include "NW_I0_GENERIC"    
#include "inc_persist_loca"    
    
//////////////////////////////////////////////////    
// Constant Definitions    
//////////////////////////////////////////////////    
const int STAGE_SELECT_ABIL = 0;    
const int STAGE_CONFIRMATION = 1;    
    
//////////////////////////////////////////////////    
// Main Function    
//////////////////////////////////////////////////    
void main()    
{    
    object oPC = GetPCSpeaker();    
    object oSkin = GetPCSkin(oPC);    
    int nRow;    
    int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);    
    int nStage = GetStage(oPC);    
    int nLevel = GetPersistantLocalInt(oPC, "HiddenTalentCheck");    
    
    // Abort if DynConv_Var is not set properly    
    if (nValue == 0)    
    {    
        if (DEBUG) DoDebug("ft_hidntalent_ft: Aborting due to error.");    
        return;    
    }    
    
    // Conversation Setup Stage    
    if (nValue == DYNCONV_SETUP_STAGE)    
    {    
        if (!GetIsStageSetUp(nStage, oPC))    
        {    
            if (nStage == STAGE_SELECT_ABIL)    
            {    
                // --- Step 1: Mark Already Selected Hidden Talents ---    
                int nStartFeat = 25901;    
                int nEndFeat = 25946;    
    
				effect eEffect = GetFirstEffect(oPC);    
				while (GetIsEffectValid(eEffect))    
				{    
					string sTag = GetEffectTag(eEffect);    
					// Check if effect tag matches Hidden Talent pattern    
					if(GetStringLeft(sTag, 13) == "HiddenTalent_")    
					{    
						int nFeatID = StringToInt(GetSubString(sTag, 13, GetStringLength(sTag) - 13));    
						SetLocalInt(oPC, "HiddenTalent_" + IntToString(nFeatID), 1);    
					}    
					eEffect = GetNextEffect(oPC);    
				}    
    
                // --- Step 2: Display Available Feats ---    
                SetHeader("Choose a Hidden Talent:");    
    
                for (nRow = nStartFeat; nRow <= nEndFeat; nRow++)    
                {    
					string sTextRef = Get2DAString("feat", "FEAT", nRow);    
					string sName = GetStringByStrRef(StringToInt(sTextRef));    
					if(sName == "") sName = "Power " + IntToString(nRow);    
    
					if (!GetHasFeat(nRow, oPC) && !GetLocalInt(oPC, "HiddenTalent_" + IntToString(nRow)))    
					{    
						AddChoice(sName, nRow, oPC);    
					}    
                }    
    
                SetDefaultTokens();    
                MarkStageSetUp(STAGE_SELECT_ABIL, oPC);    
            }    
            else if (nStage == STAGE_CONFIRMATION)    
            {    
                int nChoice = GetLocalInt(oPC, "HiddenTalentChoice");    
                string sFeatName = GetStringByStrRef(StringToInt(Get2DAString("feat", "FEAT", nChoice)));    
                if(sFeatName == "") sFeatName = "Power " + IntToString(nChoice);    
                  
                AddChoice(GetStringByStrRef(4752), TRUE);  // "Yes"    
                AddChoice(GetStringByStrRef(4753), FALSE); // "No"    
                  
                string sText = "You have selected " + sFeatName + ".\n";    
                sText += "Is this correct?";    
                  
                SetHeader(sText);    
                MarkStageSetUp(STAGE_CONFIRMATION, oPC);    
            }    
        }    
    
        // Token Setup    
        SetupTokens();    
    }    
    else if (nValue == DYNCONV_EXITED)    
    {    
        if (DEBUG) DoDebug("ft_hidntalent_ft: Running exit handler");    
        DeleteLocalInt(oPC, "HiddenTalentChoice");    
    }    
    else if (nValue == DYNCONV_ABORTED)    
    {    
        if (DEBUG) DoDebug("ft_hidntalent_ft: ERROR: Conversation abort section run");    
        DeleteLocalInt(oPC, "HiddenTalentChoice");    
    }    
    // --- Stage Selection & Feat Application ---    
    else    
    {    
        int nChoice = GetChoice(oPC);    
		int nLevel = GetHitDice(oPC);    
    
        if (nStage == STAGE_SELECT_ABIL)    
        {    
            // Store the choice and go to confirmation    
            SetLocalInt(oPC, "HiddenTalentChoice", nChoice);    
            nStage = STAGE_CONFIRMATION;    
            MarkStageNotSetUp(STAGE_SELECT_ABIL, oPC);    
        }    
        else if (nStage == STAGE_CONFIRMATION)    
        {    
            if (nChoice == TRUE)  // User confirmed "Yes"    
            {    
                int nFeatChoice = GetLocalInt(oPC, "HiddenTalentChoice");    
                if (nFeatChoice > 0)    
                {    
                    effect eBonusFeat = EffectBonusFeat(nFeatChoice);    
                    eBonusFeat = UnyieldingEffect(eBonusFeat);    
                    eBonusFeat = TagEffect(eBonusFeat, "HiddenTalent_" + IntToString(nFeatChoice));    
                    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBonusFeat, oPC);    
                }    
                SetPersistantLocalInt(oPC, "HiddenTalentChosen", 1); 
                SetPersistantLocalInt(oPC, "HiddenTalent_" + IntToString(nLevel), 1);    
                DeletePersistantLocalInt(oPC, "HiddenTalentCheck");    
                DeleteLocalInt(oPC, "HiddenTalentChoice");    
                AllowExit(DYNCONV_EXIT_FORCE_EXIT);    
            }    
            else  // User chose "No"    
            {    
                nStage = STAGE_SELECT_ABIL;    
                MarkStageNotSetUp(STAGE_SELECT_ABIL, oPC);    
                MarkStageNotSetUp(STAGE_CONFIRMATION, oPC);    
            }    
        }    
    
        if (DEBUG) DoDebug("ft_hidntalent_ft: New stage: " + IntToString(nStage));    
    
        SetStage(nStage, oPC);    
    }    
}