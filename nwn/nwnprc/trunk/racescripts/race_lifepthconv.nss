//:://////////////////////////////////////////////
//:: Life Path conversation script
//:: race_lifepthconv
//:://////////////////////////////////////////////
/** @file
    This script controls the feat selection
    conversation for Tinker Gnomes


    @author Primogenitor - Orinigal
    @author Ornedan - Modifications
    @author Fox - ripped from Psionics convo
    @date   Modified - 2005.03.13
    @date   Modified - 2005.09.23
    @date   Modified - 2008.01.25
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

/*#include "prc_alterations"
#include "inc_dynconv"
#include "inc_nwnx_funcs"

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

/*const int STAGE_SELECT_LIFEPATH          = 0;
const int STAGE_LIFEPATH_SELECTED        = 1;
const int STAGE_CONFIRM_SELECTION        = 2;

const int CHOICE_BACK_TO_LSELECT         = -1;

const int STRREF_LEVELLIST_HEADER        = 16833128; // "Select a guild to pursue your Life Quest in:"
const int STRREF_SELECTED_HEADER1        = 16824209; // "You have selected:"
const int STRREF_SELECTED_HEADER2        = 16824210; // "Is this correct?"
const int STRREF_END_HEADER              = 16833129; // "Your Life Path has been selected."
const int STRREF_END_CONVO_SELECT        = 16824212; // "Finish"
const int STRREF_YES                     = 4752;     // "Yes"
const int STRREF_NO                      = 4753;     // "No"



//////////////////////////////////////////////////
/* Function defintions                          */
//////////////////////////////////////////////////

/*void main()
{
    object oPC = GetPCSpeaker();
    object oSkin = GetPCSkin(oPC);
    int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);
    int nStage = GetStage(oPC);
    int bFuncs = GetPRCSwitch(PRC_NWNXEE_ENABLED);

    // Check which of the conversation scripts called the scripts
    if(nValue == 0) // All of them set the DynConv_Var to non-zero value, so something is wrong -> abort
        return;

    if(nValue == DYNCONV_SETUP_STAGE)
    {
        if(DEBUG) DoDebug("race_lifepthconv: Running setup stage for stage " + IntToString(nStage));
        // Check if this stage is marked as already set up
        // This stops list duplication when scrolling
        if(!GetIsStageSetUp(nStage, oPC))
        {
            if(DEBUG) DoDebug("race_lifepthconv: Stage was not set up already");
            // Level selection stage
            if(nStage == STAGE_SELECT_LIFEPATH)
            {
                if(DEBUG) DoDebug("race_lifepthconv: Building guild selection");
                SetHeader(GetStringByStrRef(STRREF_LEVELLIST_HEADER));

                // Set the tokens
                int i = 0;
                AddChoice(GetStringByStrRef(16834289), 1);// "Craft Guild"
                AddChoice(GetStringByStrRef(16834291), 2);// "Tech Guild"
                AddChoice(GetStringByStrRef(16834293), 3);// "Sage Guild"

                // Set the next, previous and wait tokens to default values
                SetDefaultTokens();
                // Set the convo quit text to "Abort"
                SetCustomToken(DYNCONV_TOKEN_EXIT, GetStringByStrRef(DYNCONV_STRREF_ABORT_CONVO));
            }
            // Selection confirmation stage
            else if(nStage == STAGE_CONFIRM_SELECTION)
            {
                if(DEBUG) DoDebug("race_lifepthconv: Building selection confirmation");
                // Build the confirmantion query
                string sToken = GetStringByStrRef(STRREF_SELECTED_HEADER1) + "\n\n"; // "You have selected:"
                int nGuild = GetLocalInt(oPC, "nGuild");
                if(nGuild == 1)
                    sToken += GetStringByStrRef(16834290);
                    //"Craft Guild \n\nYou are a member of one of the gnomish crafting guilds. You gain a +2 bonus to crafting skills.";
                else if(nGuild == 2)
                    sToken += GetStringByStrRef(16834292);
                    //"Tech Guild \n\nYou are a member of one of the gnomish technology guilds. You gain a +1 bonus to crafting skills and Lore.";
                else if(nGuild == 3)
                    sToken += GetStringByStrRef(16834294);
                    //"Sage Guild \n\nYou are a member of one of the gnomish research guilds. You gain a +2 bonus to Lore.";
                sToken += GetStringByStrRef(STRREF_SELECTED_HEADER2); // "Is this correct?"
                SetHeader(sToken);

                AddChoice(GetStringByStrRef(STRREF_YES), TRUE, oPC); // "Yes"
                AddChoice(GetStringByStrRef(STRREF_NO), FALSE, oPC); // "No"
            }
            // Conversation finished stage
            else if(nStage == STAGE_LIFEPATH_SELECTED)
            {
                if(DEBUG) DoDebug("race_lifepthconv: Building finish note");
                SetHeader(GetStringByStrRef(STRREF_END_HEADER));
                // Set the convo quit text to "Finish"
                SetCustomToken(DYNCONV_TOKEN_EXIT, GetStringByStrRef(STRREF_END_CONVO_SELECT));
                AllowExit(DYNCONV_EXIT_ALLOWED_SHOW_CHOICE, FALSE, oPC);
            }
        }

        // Do token setup
        SetupTokens();
    }
    else if(nValue == DYNCONV_EXITED)
    {
        if(DEBUG) DoDebug("race_lifepthconv: Running exit handler");
        // End of conversation cleanup
        DeleteLocalInt(oPC, "nGuild");
    }
    else if(nValue == DYNCONV_ABORTED)
    {
        // This section should never be run, since aborting this conversation should
        // always be forbidden and as such, any attempts to abort the conversation
        // should be handled transparently by the system
        if(DEBUG) DoDebug("race_lifepthconv: ERROR: Conversation abort section run");
    }
    // Handle PC response
    else
    {
        int nChoice = GetChoice(oPC);
        if(DEBUG) DoDebug("race_lifepthconv: Handling PC response, stage = " + IntToString(nStage) + "; nChoice = " + IntToString(nChoice) + "; choice text = '" + GetChoiceText(oPC) +  "'");
        if(nStage == STAGE_SELECT_LIFEPATH)
        {
            if(DEBUG) DoDebug("race_lifepthconv: Guild selected.  Entering Confirmation.");
            SetLocalInt(oPC, "nGuild", nChoice);
            nStage = STAGE_CONFIRM_SELECTION;
        }
        else if(nStage == STAGE_CONFIRM_SELECTION)
        {
            if(DEBUG) DoDebug("race_lifepthconv: Handling guild confirmation");
            if(nChoice == TRUE)
            {
                if(DEBUG) DoDebug("race_lifepthconv: Marking Guild");
                int nGuild = GetLocalInt(oPC, "nGuild");
                itemproperty ipIP;
                int nFeat;

                if(nGuild == 1)
                {
                    ipIP  = ItemPropertyBonusFeat(IP_CONST_FEAT_CRAFTGUILD);
                    nFeat = FEAT_CRAFTGUILD;
                }
                else if(nGuild == 2)
                {
                    ipIP  = ItemPropertyBonusFeat(IP_CONST_FEAT_TECHGUILD);
                    nFeat = FEAT_TECHGUILD;
                }
                else if(nGuild == 3)
                {
                    ipIP  = ItemPropertyBonusFeat(IP_CONST_FEAT_SAGEGUILD);
                    nFeat = FEAT_SAGEGUILD;
                }

                if(bFuncs)
                    PRC_Funcs_AddFeat(oPC, nFeat);
                else
                    IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);

                nStage = STAGE_LIFEPATH_SELECTED;
            }
            else
                nStage = STAGE_SELECT_LIFEPATH;
        }

        if(DEBUG) DoDebug("race_lifepthconv: New stage: " + IntToString(nStage));

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}*/
void main()
{
}