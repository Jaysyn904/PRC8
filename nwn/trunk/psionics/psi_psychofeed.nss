//:://////////////////////////////////////////////
//:: Psychofeedback Conversation
//:: psi_psychofeed
//:://////////////////////////////////////////////
/** @file
    This allows you to drain some stats to boost others


    @author Stratovarius
    @date   Created  - 29.10.2005
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_dynconv"
#include "psi_inc_psifunc"

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_STAT_BOOST_CHOICE = 0;
const int STAGE_CONFIRMATION      = 1;
const int STAGE_STAT_BURN_CHOICE  = 2;
const int STAGE_STAT_AMOUNT       = 3;

//////////////////////////////////////////////////
/* Aid functions                                */
//////////////////////////////////////////////////

// Just takes the stat and returns the name
string StatToName(int nStat)
{
    if      (nStat == ABILITY_STRENGTH)     return GetStringByStrRef(135);
    else if (nStat == ABILITY_DEXTERITY)    return GetStringByStrRef(133);
    else if (nStat == ABILITY_CONSTITUTION) return GetStringByStrRef(132);
    else if (nStat == ABILITY_WISDOM)       return GetStringByStrRef(136);
    else if (nStat == ABILITY_INTELLIGENCE) return GetStringByStrRef(134);
    else if (nStat == ABILITY_CHARISMA)     return GetStringByStrRef(131);

    // if its not a stat
    return "";
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
            if(nStage == STAGE_STAT_BOOST_CHOICE)
            {
                // Set the header
                SetHeader("Select the Ability Score you would like to boost.");

                // Add responses for the PC
                AddChoice(StatToName(ABILITY_STRENGTH),     ABILITY_STRENGTH,     oPC);
                AddChoice(StatToName(ABILITY_DEXTERITY),    ABILITY_DEXTERITY,    oPC);
                AddChoice(StatToName(ABILITY_CONSTITUTION), ABILITY_CONSTITUTION, oPC);

                MarkStageSetUp(STAGE_STAT_BOOST_CHOICE, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_STAT_BURN_CHOICE)//Stat to burn
            {
                // Set the header
                SetHeader("Select the Ability Score you would like to burn for this power.");

                // Add responses for the PC
                AddChoice(StatToName(ABILITY_STRENGTH),     ABILITY_STRENGTH,     oPC);
                AddChoice(StatToName(ABILITY_DEXTERITY),    ABILITY_DEXTERITY,    oPC);
                AddChoice(StatToName(ABILITY_CONSTITUTION), ABILITY_CONSTITUTION, oPC);
                AddChoice(StatToName(ABILITY_WISDOM),       ABILITY_WISDOM,       oPC);
                AddChoice(StatToName(ABILITY_INTELLIGENCE), ABILITY_INTELLIGENCE, oPC);
                AddChoice(StatToName(ABILITY_CHARISMA),     ABILITY_CHARISMA,     oPC);

                MarkStageSetUp(STAGE_STAT_BURN_CHOICE, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_STAT_AMOUNT)//Stat to burn
            {
                // Set the header
                string sAmount = "How much would you like to burn and increase your stat by?\n";
                sAmount += "If you select a value higher than your manifester level, it will be set to your manifester leve.\n";
                sAmount += "Your manifester level is " + IntToString(GetLocalInt(oPC, "PsychoFeedManifesterLevel")) + "\n";
                sAmount += "Your current value is " + IntToString(GetLocalInt(oPC, "PsychoFeedbackAmount"));
                SetHeader(sAmount);

                AddChoice("Add 1", 1);
                AddChoice("Add 5", 5);
                AddChoice("Add 10", 10);
                AddChoice("Subtract 1", -1);
                AddChoice("Subtract 5", -5);
                AddChoice("Subtract 10", -10);
                AddChoice("Finished", 666);

                MarkStageSetUp(STAGE_STAT_AMOUNT, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_CONFIRMATION)//confirmation
            {
                int nChoice = GetLocalInt(oPC, "PsychoFeedbackStat");
                int nBurn = GetLocalInt(oPC, "PsychoFeedbackBurn");
                int nAmount = GetLocalInt(oPC, "PsychoFeedbackAmount");
                AddChoice(GetStringByStrRef(4752), TRUE); // "Yes"
                AddChoice(GetStringByStrRef(4753), FALSE); // "No"

                string sName = StatToName(nChoice);
                string sText = "You have selected " + sName + " as the ability to boost.\n";
                sName = StatToName(nBurn);
                sText += "You have selected " + sName + " as the ability to burn.\n";
                sText += "You have selected " + IntToString(nAmount) + " as the value.\n";
                sText += "Is this correct?";

                SetHeader(sText);
                MarkStageSetUp(STAGE_CONFIRMATION, oPC);
            }
        }

        // Do token setup
        SetupTokens();
    }
    // End of conversation cleanup
    else if(nValue == DYNCONV_EXITED)
    {
        // End of conversation cleanup
        DeleteLocalInt(oPC, "PsychoFeedbackStat");
        DeleteLocalInt(oPC, "PsychoFeedbackBurn");
        DeleteLocalInt(oPC, "PsychoFeedbackAmount");
    }
    // Abort conversation cleanup.
    // NOTE: This section is only run when the conversation is aborted
    // while aborting is allowed. When it isn't, the dynconvo infrastructure
    // handles restoring the conversation in a transparent manner
    else if(nValue == DYNCONV_ABORTED)
    {
        // End of conversation cleanup
        DeleteLocalInt(oPC, "PsychoFeedbackStat");
        DeleteLocalInt(oPC, "PsychoFeedbackBurn");
        DeleteLocalInt(oPC, "PsychoFeedbackAmount");
    }
    // Handle PC responses
    else
    {
        // variable named nChoice is the value of the player's choice as stored when building the choice list
        // variable named nStage determines the current conversation node
        int nChoice = GetChoice(oPC);
        if(nStage == STAGE_STAT_BOOST_CHOICE)
        {
            nStage = STAGE_STAT_BURN_CHOICE;
            SetLocalInt(oPC, "PsychoFeedbackStat", nChoice);
        }
        else if(nStage == STAGE_STAT_BURN_CHOICE)
        {
            nStage = STAGE_STAT_AMOUNT;
            SetLocalInt(oPC, "PsychoFeedbackBurn", nChoice);
        }
        else if(nStage == STAGE_STAT_AMOUNT)
        {
            // Exit value for this stage
            if (nChoice == 666)
            {
                nStage = STAGE_CONFIRMATION;
            }
            else
            {
                int nPFAmount = GetLocalInt(oPC, "PsychoFeedbackAmount");
                SetLocalInt(oPC, "PsychoFeedbackAmount", (nPFAmount + nChoice));
                nStage = STAGE_STAT_AMOUNT;
            }
            ClearCurrentStage();
        }
        else if(nStage == STAGE_CONFIRMATION)//confirmation
        {
            // No point in letting them finish if they haven't burned anything
            if(nChoice == TRUE && GetLocalInt(oPC, "PsychoFeedbackAmount") > 0)
            {
                int nStat = GetLocalInt(oPC, "PsychoFeedbackStat");
                int nBurn = GetLocalInt(oPC, "PsychoFeedbackBurn");
                int nAmount = GetLocalInt(oPC, "PsychoFeedbackAmount");
                if (nAmount > GetLocalInt(oPC, "PsychoFeedManifesterLevel")) nAmount = GetLocalInt(oPC, "PsychoFeedManifesterLevel");

                effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
                effect eVis2 = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
                effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

                ApplyAbilityDamage(oPC, nBurn, nAmount, DURATION_TYPE_TEMPORARY, FALSE, -1.0f);

                effect eStr = EffectAbilityIncrease(nStat,nAmount);
                effect eLink = EffectLinkEffects(eStr, eDur);

                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, GetLocalFloat(oPC, "PsychoFeedDuration"), TRUE, POWER_PSYCHOFEEDBACK, GetLocalInt(oPC, "PsychoFeedManifesterLevel"));
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oPC);

                // And we're all done
                AllowExit(DYNCONV_EXIT_FORCE_EXIT);

            }
            else
            {
                nStage = STAGE_STAT_BOOST_CHOICE;
                MarkStageNotSetUp(STAGE_STAT_BOOST_CHOICE, oPC);
                MarkStageNotSetUp(STAGE_STAT_BURN_CHOICE, oPC);
                MarkStageNotSetUp(STAGE_STAT_AMOUNT, oPC);
                MarkStageNotSetUp(STAGE_CONFIRMATION, oPC);
            }

            DeleteLocalInt(oPC, "PsychoFeedbackStat");
            DeleteLocalInt(oPC, "PsychoFeedbackBurn");
            DeleteLocalInt(oPC, "PsychoFeedbackAmount");
        }

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
