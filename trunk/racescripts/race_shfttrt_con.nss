//:://////////////////////////////////////////////
//:: Shifter Trait conversation script
//:: race_shfttrt_con
//:://////////////////////////////////////////////
/** @file
    This script controls the feat selection
    conversation for Shifters


    @author Primogenitor - Orinigal
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

const int STAGE_SELECT_TRAIT             = 0;
const int STAGE_TRAIT_SELECTED           = 1;
const int STAGE_CONFIRM_SELECTION        = 2;

const int CHOICE_BACK_TO_LSELECT         = -1;

const int STRREF_LEVELLIST_HEADER        = 16828148; // "Select a shifter trait to represent your lycanthrope heritage:"
const int STRREF_SELECTED_HEADER1        = 16824209; // "You have selected:"
const int STRREF_SELECTED_HEADER2        = 16824210; // "Is this correct?"
const int STRREF_END_HEADER              = 16828149; // "Your trait has been selected."
const int STRREF_END_CONVO_SELECT        = 16824212; // "Finish"
const int STRREF_YES                     = 4752;     // "Yes"
const int STRREF_NO                      = 4753;     // "No"

const int BEASTHIDE                      = 1;
const int DREAMSIGHT                     = 2;
const int GOREBRUTE                      = 3;
const int LONGSTRIDE                     = 4;
const int LONGTOOTH                      = 5;
const int RAZORCLAW                      = 6;
const int WILDHUNT                       = 7;
const int WINTERHIDE                     = 8;

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
        if(DEBUG) DoDebug("race_shfttrt_con: Running setup stage for stage " + IntToString(nStage));
        // Check if this stage is marked as already set up
        // This stops list duplication when scrolling
        if(!GetIsStageSetUp(nStage, oPC))
        {
            if(DEBUG) DoDebug("race_shfttrt_con: Stage was not set up already");
            // Level selection stage
            if(nStage == STAGE_SELECT_TRAIT)
            {
                if(DEBUG) DoDebug("race_shfttrt_con: Building guild selection");
                SetHeader(GetStringByStrRef(STRREF_LEVELLIST_HEADER));

                // Set the tokens
                int i = 0;
                if(!GetHasFeat(FEAT_SHIFTER_BEASTHIDE))
                    AddChoice(GetStringByStrRef(16828134), BEASTHIDE);// "Beasthide"
                if(!GetHasFeat(FEAT_SHIFTER_DREAMSIGHT))
                    AddChoice(GetStringByStrRef(16828136), DREAMSIGHT);//"Dreamsight"
                if(!GetHasFeat(FEAT_SHIFTER_GOREBRUTE))
                    AddChoice(GetStringByStrRef(16828138), GOREBRUTE);//"Gorebrute"
                if(!GetHasFeat(FEAT_SHIFTER_LONGSTRIDE))
                    AddChoice(GetStringByStrRef(16828140), LONGSTRIDE);//"Longstride"
                if(!GetHasFeat(FEAT_SHIFTER_LONGTOOTH))
                    AddChoice(GetStringByStrRef(16828142), LONGTOOTH);// "Longtooth"
                if(!GetHasFeat(FEAT_SHIFTER_RAZORCLAW))
                    AddChoice(GetStringByStrRef(16828144), RAZORCLAW);// "Razorclaw"
                if(!GetHasFeat(FEAT_SHIFTER_WILDHUNT))
                    AddChoice(GetStringByStrRef(16828146), WILDHUNT);// "Wildhunt"
                if(!GetHasFeat(FEAT_SHIFTER_WINTERHIDE))
                    AddChoice(GetStringByStrRef(16835618), WINTERHIDE);// "Wildhunt"                    

                // Set the next, previous and wait tokens to default values
                SetDefaultTokens();
                // Set the convo quit text to "Abort"
                SetCustomToken(DYNCONV_TOKEN_EXIT, GetStringByStrRef(DYNCONV_STRREF_ABORT_CONVO));
            }
            // Selection confirmation stage
            else if(nStage == STAGE_CONFIRM_SELECTION)
            {
                if(DEBUG) DoDebug("race_shfttrt_con: Building selection confirmation");
                // Build the confirmantion query
                string sToken = GetStringByStrRef(STRREF_SELECTED_HEADER1) + "\n\n"; // "You have selected:"
                int nTrait = GetLocalInt(oPC, "nTrait");
                if(nTrait == BEASTHIDE)
                    sToken += GetStringByStrRef(16828134) + "\n\n" + GetStringByStrRef(16828135) + "\n";
                else if(nTrait == DREAMSIGHT)
                    sToken += GetStringByStrRef(16828136) + "\n\n" + GetStringByStrRef(16828137) + "\n";
                else if(nTrait == GOREBRUTE)
                    sToken += GetStringByStrRef(16828138) + "\n\n" + GetStringByStrRef(16828139) + "\n";
                else if(nTrait == LONGSTRIDE)
                    sToken += GetStringByStrRef(16828140) + "\n\n" + GetStringByStrRef(16828141) + "\n";
                else if(nTrait == LONGTOOTH)
                    sToken += GetStringByStrRef(16828142) + "\n\n" + GetStringByStrRef(16828143) + "\n";
                else if(nTrait == RAZORCLAW)
                    sToken += GetStringByStrRef(16828144) + "\n\n" + GetStringByStrRef(16828145) + "\n";
                else if(nTrait == WILDHUNT)
                    sToken += GetStringByStrRef(16828146) + "\n\n" + GetStringByStrRef(16828147) + "\n";
                else if(nTrait == WINTERHIDE)
                    sToken += GetStringByStrRef(16835618) + "\n\n" + GetStringByStrRef(16835619) + "\n";                    
                sToken += GetStringByStrRef(STRREF_SELECTED_HEADER2); // "Is this correct?"
                SetHeader(sToken);

                AddChoice(GetStringByStrRef(STRREF_YES), TRUE, oPC); // "Yes"
                AddChoice(GetStringByStrRef(STRREF_NO), FALSE, oPC); // "No"
            }
            // Conversation finished stage
            else if(nStage == STAGE_TRAIT_SELECTED)
            {
                if(DEBUG) DoDebug("race_shfttrt_con: Building finish note");
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
        if(DEBUG) DoDebug("race_shfttrt_con: Running exit handler");
        // End of conversation cleanup
        if(GetPersistantLocalInt(oPC, "FirstShifterTrait") < 100)
        {
            int nTrait = GetLocalInt(oPC, "nTrait");
            if(nTrait == BEASTHIDE)
                SetPersistantLocalInt(oPC, "FirstShifterTrait", FEAT_SHIFTER_BEASTHIDE);
            else if(nTrait == DREAMSIGHT)
                SetPersistantLocalInt(oPC, "FirstShifterTrait", FEAT_SHIFTER_DREAMSIGHT);
            else if(nTrait == GOREBRUTE)
                SetPersistantLocalInt(oPC, "FirstShifterTrait", FEAT_SHIFTER_GOREBRUTE);
            else if(nTrait == LONGSTRIDE)
                SetPersistantLocalInt(oPC, "FirstShifterTrait", FEAT_SHIFTER_LONGSTRIDE);
            else if(nTrait == LONGTOOTH)
                SetPersistantLocalInt(oPC, "FirstShifterTrait", FEAT_SHIFTER_LONGTOOTH);
            else if(nTrait == RAZORCLAW)
                SetPersistantLocalInt(oPC, "FirstShifterTrait", FEAT_SHIFTER_RAZORCLAW);
            else if(nTrait == WILDHUNT)
                SetPersistantLocalInt(oPC, "FirstShifterTrait", FEAT_SHIFTER_WILDHUNT);
            else if(nTrait == WINTERHIDE)
                SetPersistantLocalInt(oPC, "FirstShifterTrait", FEAT_SHIFTER_WINTERHIDE);                
        }
        DeleteLocalInt(oPC, "nTrait");
    }
    else if(nValue == DYNCONV_ABORTED)
    {
        // This section should never be run, since aborting this conversation should
        // always be forbidden and as such, any attempts to abort the conversation
        // should be handled transparently by the system
        if(DEBUG) DoDebug("race_shfttrt_con: ERROR: Conversation abort section run");
    }
    // Handle PC response
    else
    {
        int nChoice = GetChoice(oPC);
        if(DEBUG) DoDebug("race_shfttrt_con: Handling PC response, stage = " + IntToString(nStage) + "; nChoice = " + IntToString(nChoice) + "; choice text = '" + GetChoiceText(oPC) +  "'");
        if(nStage == STAGE_SELECT_TRAIT)
        {
            if(DEBUG) DoDebug("race_shfttrt_con: Trait selected.  Entering Confirmation.");
            SetLocalInt(oPC, "nTrait", nChoice);
            nStage = STAGE_CONFIRM_SELECTION;
        }
        else if(nStage == STAGE_CONFIRM_SELECTION)
        {
            if(DEBUG) DoDebug("race_shfttrt_con: Handling trait confirmation");
            if(nChoice == TRUE)
            {
                if(DEBUG) DoDebug("race_shfttrt_con: Marking Trait");
                int nTrait = GetLocalInt(oPC, "nTrait");
                itemproperty ipIP;
                int nFeat;

                if(nTrait == BEASTHIDE)
                {
                    ipIP  = ItemPropertyBonusFeat(IP_CONST_FEAT_SHIFTER_BEASTHIDE);
                    nFeat = FEAT_SHIFTER_BEASTHIDE;
                }
                else if(nTrait == DREAMSIGHT)
                {
                    ipIP  = ItemPropertyBonusFeat(IP_CONST_FEAT_SHIFTER_DREAMSIGHT);
                    nFeat = FEAT_SHIFTER_DREAMSIGHT;
                }
                else if(nTrait == GOREBRUTE)
                {
                    ipIP  = ItemPropertyBonusFeat(IP_CONST_FEAT_SHIFTER_GOREBRUTE);
                    nFeat = FEAT_SHIFTER_GOREBRUTE;
                }
                else if(nTrait == LONGSTRIDE)
                {
                    ipIP  = ItemPropertyBonusFeat(IP_CONST_FEAT_SHIFTER_LONGSTRIDE);
                    nFeat = FEAT_SHIFTER_LONGSTRIDE;
                }
                else if(nTrait == LONGTOOTH)
                {
                    ipIP  = ItemPropertyBonusFeat(IP_CONST_FEAT_SHIFTER_LONGTOOTH);
                    nFeat = FEAT_SHIFTER_LONGTOOTH;
                }
                else if(nTrait == RAZORCLAW)
                {
                    ipIP  = ItemPropertyBonusFeat(IP_CONST_FEAT_SHIFTER_RAZORCLAW);
                    nFeat = FEAT_SHIFTER_RAZORCLAW;
                }
                else if(nTrait == WILDHUNT)
                {
                    ipIP  = ItemPropertyBonusFeat(IP_CONST_FEAT_SHIFTER_WILDHUNT);
                    nFeat = FEAT_SHIFTER_WILDHUNT;
                }
                else if(nTrait == WILDHUNT)
                {
                    ipIP  = ItemPropertyBonusFeat(IP_CONST_FEAT_SHIFTER_WINTERHIDE);
                    nFeat = FEAT_SHIFTER_WINTERHIDE;
                }                

                if(bFuncs)
                    PRC_Funcs_AddFeat(oPC, nFeat);
                else
                    IPSafeAddItemProperty(oSkin, ipIP, 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);

                nStage = STAGE_TRAIT_SELECTED;
            }
            else
                nStage = STAGE_SELECT_TRAIT;
        }

        if(DEBUG) DoDebug("race_shfttrt_con: New stage: " + IntToString(nStage));

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
