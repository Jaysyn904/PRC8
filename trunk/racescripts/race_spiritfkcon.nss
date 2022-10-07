//:://////////////////////////////////////////////
//:: Spirit Folk conversation script
//:: race_spiritfkcon
//:://////////////////////////////////////////////
/** @file
    This script controls the feat selection
    conversation for Spirit Folk


    @author Primogenitor - Original
    @author Ornedan - Modifications
    @author Fox - ripped from Psionics convo
    @date   Modified - 2005.03.13
    @date   Modified - 2005.09.23
    @date   Modified - 2008.01.25
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "inc_dynconv"
#include "inc_nwnx_funcs"

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_SELECT_SPIRIT            = 0;
const int STAGE_SPIRIT_SELECTED          = 1;
const int STAGE_CONFIRM_SELECTION        = 2;

const int CHOICE_BACK_TO_LSELECT         = -1;

const int STRREF_LEVELLIST_HEADER        = 16828040; // "Select a spirit heritage:"
const int STRREF_SELECTED_HEADER1        = 16824209; // "You have selected:"
const int STRREF_SELECTED_HEADER2        = 16824210; // "Is this correct?"
const int STRREF_END_HEADER              = 16828041; // "Your spirit heritage has been selected."
const int STRREF_END_CONVO_SELECT        = 16824212; // "Finish"
const int STRREF_YES                     = 4752;     // "Yes"
const int STRREF_NO                      = 4753;     // "No"



//////////////////////////////////////////////////
/* Function defintions                          */
//////////////////////////////////////////////////

void main()
{
    object oPC = GetPCSpeaker();
    object oSkin = GetPCSkin(oPC);
    int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);
    int nStage = GetStage(oPC);
    int bFuncs = GetPRCSwitch(PRC_NWNX_FUNCS);

    // Check which of the conversation scripts called the scripts
    if(nValue == 0) // All of them set the DynConv_Var to non-zero value, so something is wrong -> abort
        return;

    if(nValue == DYNCONV_SETUP_STAGE)
    {
        if(DEBUG) DoDebug("race_spiritfkcon: Running setup stage for stage " + IntToString(nStage));
        // Check if this stage is marked as already set up
        // This stops list duplication when scrolling
        if(!GetIsStageSetUp(nStage, oPC))
        {
            if(DEBUG) DoDebug("race_spiritfkcon: Stage was not set up already");
            // Level selection stage
            if(nStage == STAGE_SELECT_SPIRIT)
            {
                if(DEBUG) DoDebug("race_spiritfkcon: Building Spirit selection");
                SetHeader(GetStringByStrRef(STRREF_LEVELLIST_HEADER));

                // Set the tokens
                int i = 0;
                AddChoice(GetStringByStrRef(16834283), 1);// "Bamboo Folk"
                AddChoice(GetStringByStrRef(16834285), 2);// "River Folk"
                AddChoice(GetStringByStrRef(16834287), 3);// "Sea Folk"
                AddChoice(GetStringByStrRef(16833105), 4);// "Mountain Folk"

                // Set the next, previous and wait tokens to default values
                SetDefaultTokens();
                // Set the convo quit text to "Abort"
                SetCustomToken(DYNCONV_TOKEN_EXIT, GetStringByStrRef(DYNCONV_STRREF_ABORT_CONVO));
            }
            // Selection confirmation stage
            else if(nStage == STAGE_CONFIRM_SELECTION)
            {
                if(DEBUG) DoDebug("race_spiritfkcon: Building selection confirmation");
                // Build the confirmantion query
                string sToken = GetStringByStrRef(STRREF_SELECTED_HEADER1) + "\n\n"; // "You have selected:"
                int nSpirit = GetLocalInt(oPC, "nSpirit");
                if(nSpirit == 1)
                    sToken += GetStringByStrRef(16834284);
                    // "Bamboo Spirit \n\nYou are one of the Bamboo tribe of Spirit Folk.  You gain a +2 bonus to lore and saves against acid spells, due ot your earthen nature.  You also gain Trackless Step and +4 to hide in wilderness settings.";
                else if(nSpirit == 2)
                    sToken += GetStringByStrRef(16834286);
                    // "River Spirit \n\nYou are one of the River tribe of Spirit Folk.  You are immune to drowning, and gain a +2 to save vs cold spells and effects, due to your water nature.";
                else if(nSpirit == 3)
                    sToken += GetStringByStrRef(16834288);
                    //"Sea Spirit \n\nYou are one of the Sea tribe of Spirit Folk.  You are immune to drowning, and gain a +2 to save vs fire spells and effects.";
                else if(nSpirit == 4)
                    sToken += GetStringByStrRef(16833110);
                    //"You are one of the Mountain tribe of Spirit Folk. You gain a +8 bonus to Climb, and a +2 bonus to Balance, Jump, and Tumble.";                    
                sToken += GetStringByStrRef(STRREF_SELECTED_HEADER2); // "Is this correct?"
                SetHeader(sToken);

                AddChoice(GetStringByStrRef(STRREF_YES), TRUE, oPC); // "Yes"
                AddChoice(GetStringByStrRef(STRREF_NO), FALSE, oPC); // "No"
            }
            // Conversation finished stage
            else if(nStage == STAGE_SPIRIT_SELECTED)
            {
                if(DEBUG) DoDebug("race_spiritfkcon: Building finish note");
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
        if(DEBUG) DoDebug("race_spiritfkcon: Running exit handler");
        // End of conversation cleanup
        DeleteLocalInt(oPC, "nSpirit");
    }
    else if(nValue == DYNCONV_ABORTED)
    {
        // This section should never be run, since aborting this conversation should
        // always be forbidden and as such, any attempts to abort the conversation
        // should be handled transparently by the system
        if(DEBUG) DoDebug("race_spiritfkcon: ERROR: Conversation abort section run");
    }
    // Handle PC response
    else
    {
        int nChoice = GetChoice(oPC);
        if(DEBUG) DoDebug("race_spiritfkcon: Handling PC response, stage = " + IntToString(nStage) + "; nChoice = " + IntToString(nChoice) + "; choice text = '" + GetChoiceText(oPC) +  "'");
        if(nStage == STAGE_SELECT_SPIRIT)
        {
            if(DEBUG) DoDebug("race_spiritfkcon: Spirit selected.  Entering Confirmation.");
            SetLocalInt(oPC, "nSpirit", nChoice);
            nStage = STAGE_CONFIRM_SELECTION;
        }
        else if(nStage == STAGE_CONFIRM_SELECTION)
        {
            if(DEBUG) DoDebug("race_spiritfkcon: Handling Spirit confirmation");
            if(nChoice == TRUE)
            {
                if(DEBUG) DoDebug("race_spiritfkcon: Marking Spirit");
                int nSpirit = GetLocalInt(oPC, "nSpirit");
                itemproperty ipIP;
                int nFeat;

                if(nSpirit == 1)
                {
                    ipIP  = ItemPropertyBonusFeat(IP_CONST_FEAT_BAMBOO_FOLK);
                    nFeat = FEAT_BONUS_BAMBOO;
                }
                else if(nSpirit == 2)
                {
                    ipIP  = ItemPropertyBonusFeat(IP_CONST_FEAT_RIVER_FOLK);
                    nFeat = FEAT_BONUS_RIVER;
                }
                else if(nSpirit == 3)
                {
                    ipIP  = ItemPropertyBonusFeat(IP_CONST_FEAT_SEA_FOLK);
                    nFeat = FEAT_BONUS_SEA;
                }
                else if(nSpirit == 4)
                {
                    ipIP  = ItemPropertyBonusFeat(IP_CONST_FEAT_MOUNTAIN_FOLK);
                    nFeat = FEAT_BONUS_MOUNTAIN;
                }                

                if(bFuncs)
                    PRC_Funcs_AddFeat(oPC, nFeat);
                else
                    IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);

                nStage = STAGE_SPIRIT_SELECTED;
            }
            else
                nStage = STAGE_SELECT_SPIRIT;
        }

        if(DEBUG) DoDebug("race_spiritfkcon: New stage: " + IntToString(nStage));

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
