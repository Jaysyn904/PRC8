//:://////////////////////////////////////////////////////////////////
//:: Hidden Talen
//:: ft_hidntalent_ft
//:://////////////////////////////////////////////////////////////////
/** @file
    THis allows you to pick a hidden talent @ 1st level

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
                int nTotalRows = FEAT_HIDDEN_TALENT_BIOFEEDBACK - FEAT_HIDDEN_TALENT_GRIP_IRON;
                int nEndFeat = nStartFeat + nTotalRows;
				
				string sFeat = Get2DAString("feat", "LABEL", nRow);

				effect eEffect = GetFirstEffect(oPC);
				while (GetIsEffectValid(eEffect))
				{
					if (GetEffectTag(eEffect) == "HiddenTalent_" + sFeat)
					{
						SetLocalInt(oPC, "HiddenTalent_" + IntToString(nRow), 1);
					}
					eEffect = GetNextEffect(oPC);
				}

                // --- Step 2: Display Available Feats ---
                SetHeader("Choose a Hidden Talent:");

                for (nRow = nStartFeat; nRow <= nEndFeat; nRow++)
                {
					string sName = Get2DAString("feats", "LABEL", nRow);
                    int nFeat = StringToInt(Get2DAString("feats", "FEAT", nRow));

					if (!GetHasFeat(nRow, oPC) && !GetLocalInt(oPC, "HiddenTalent_" + IntToString(nRow)))
					{
						AddChoice(sName, nRow, oPC);
}
                }

                SetDefaultTokens();
                MarkStageSetUp(STAGE_SELECT_ABIL, oPC);
            }
        }

        // Token Setup
        SetupTokens();
    }
    else if (nValue == DYNCONV_EXITED)
    {
        if (DEBUG) DoDebug("ft_hidntalent_ft: Running exit handler");
    }
    else if (nValue == DYNCONV_ABORTED)
    {
        if (DEBUG) DoDebug("ft_hidntalent_ft: ERROR: Conversation abort section run");
    }
    // --- Stage Selection & Feat Application ---
    else
    {
        int nChoice = GetChoice(oPC);
		int nLevel = GetHitDice(oPC);

        if (nStage == STAGE_SELECT_ABIL)
        {
            SetPersistantLocalInt(oPC, "HiddenTalent_" + IntToString(nLevel), 1);

            if (nChoice > 0)
            {
                effect eBonusFeat = EffectBonusFeat(nChoice);
                eBonusFeat = UnyieldingEffect(eBonusFeat);
                eBonusFeat = TagEffect(eBonusFeat, "HiddenTalent_" + IntToString(nChoice));
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBonusFeat, oPC);
            }

            DeletePersistantLocalInt(oPC, "HiddenTalentCheck");
            AllowExit(DYNCONV_EXIT_FORCE_EXIT);
        }

        if (DEBUG) DoDebug("ft_hidntalent_ft: New stage: " + IntToString(nStage));

        SetStage(nStage, oPC);
    }
}
