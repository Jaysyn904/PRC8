//:://////////////////////////////////////////////
//:: Weapon Aptitude conversation script
//:: tob_aptitudeconv
//:://////////////////////////////////////////////
/** @file
    This script controls the weapon selection
    conversation for Warblade's Aptitude


    @author Primogenitor - Original
    @author Ornedan - Modifications
    @author Fox - ripped from Psionics convo
    @date   Modified - 2005.03.13
    @date   Modified - 2005.09.23
    @date   Modified - 2008.01.25
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

////#include "prc_alterations"
#include "inc_dynconv"
#include "prc_inc_wpnrest"

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_SELECT_OPTION             = 0;
const int STAGE_SELECT_WEAPON             = 1;

const int CHOICE_FOCUS_WEAPON_1           = 1;
const int CHOICE_CRITICAL_WEAPON_1        = 2;
const int CHOICE_FOCUS_WEAPON_2           = 3;
const int CHOICE_CRITICAL_WEAPON_2        = 4;

const string OPTION_FOCUS_WEAPON_1       = "PRC_WEAPAPT_FOCUS_1";
const string OPTION_CRITICAL_WEAPON_1    = "PRC_WEAPAPT_CRITICAL_1";
const string OPTION_FOCUS_WEAPON_2       = "PRC_WEAPAPT_FOCUS_2";
const string OPTION_CRITICAL_WEAPON_2    = "PRC_WEAPAPT_CRITICAL_2";

const string WEAPON_FILE = "prc_weap_items";

const int DEBUG_CONVO = FALSE;

//////////////////////////////////////////////////
/* Function defintions                          */
//////////////////////////////////////////////////

string GetOptionText(object oPC, string sOptionText, string sOption)
{
    string sWeapon;
    int nWeaponIndex = GetLocalInt(oPC, sOption);
    if(nWeaponIndex)
        sWeapon = GetStringByStrRef(StringToInt(Get2DACache(WEAPON_FILE, "Name", nWeaponIndex-1)));
    else
        sWeapon = GetStringByStrRef(16837740);
    return ReplaceString(sOptionText, "%(CURRENT)", sWeapon);
}

void main()
{
    object oPC = GetPCSpeaker();
    int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);
    int nStage = GetStage(oPC);

    // Check which of the conversation scripts called the scripts
    if(nValue == 0) // All of them set the DynConv_Var to non-zero value, so something is wrong -> abort
        return;

    if(nValue == DYNCONV_SETUP_STAGE)
    {
        if(DEBUG_CONVO) DoDebug("tob_aptitudeconv: Running setup stage for stage " + IntToString(nStage));
        // Check if this stage is marked as already set up
        // This stops list duplication when scrolling
        if(!GetIsStageSetUp(nStage, oPC))
        {
            if(DEBUG_CONVO) DoDebug("tob_aptitudeconv: Stage was not set up already");
            // Level selection stage
            if (nStage == STAGE_SELECT_OPTION)
            {
                if(DEBUG_CONVO) DoDebug("tob_aptitudeconv: Options");

                SetHeader(GetStringByStrRef(16837741));
                
                AddChoice(GetOptionText(oPC, GetStringByStrRef(16837736), OPTION_FOCUS_WEAPON_1), CHOICE_FOCUS_WEAPON_1);
                //AddChoice(GetOptionText(oPC, GetStringByStrRef(16837737), OPTION_CRITICAL_WEAPON_1), CHOICE_CRITICAL_WEAPON_1);
                //AddChoice(GetOptionText(oPC, GetStringByStrRef(16837738), OPTION_FOCUS_WEAPON_2), CHOICE_FOCUS_WEAPON_2);
                //AddChoice(GetOptionText(oPC, GetStringByStrRef(16837739), OPTION_CRITICAL_WEAPON_2), CHOICE_CRITICAL_WEAPON_2);

                SetDefaultTokens();
            }
            else if(nStage == STAGE_SELECT_WEAPON)
            {
                if(DEBUG_CONVO) DoDebug("tob_aptitudeconv: Building weapon selection");
                SetHeader(GetStringByStrRef(16827087));
                
                //Add weapons from 2da file
                int i = 0;
                while(Get2DACache(WEAPON_FILE, "label", i) != "") //until we hit a nonexistant line
                {
                   int nName = StringToInt(Get2DACache(WEAPON_FILE, "Name", i));
                   AddChoice(GetStringByStrRef(nName), i+1); //choice # = row # in WEAPON_FILE + 1
                   i++; //go to next line
                }
                
                // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                MarkStageSetUp(nStage, oPC);
                // Set the next, previous and wait tokens to default values
                SetDefaultTokens();
            }
        }

        // Do token setup
        SetupTokens();
    }
    else if(nValue == DYNCONV_EXITED)
    {
    }
    else if(nValue == DYNCONV_ABORTED)
    {
    }
    else
    {
        int nChoice = GetChoice(oPC);
        if(DEBUG_CONVO) DoDebug("tob_aptitudeconv: Handling PC response, stage = " + IntToString(nStage) + "; nChoice = " + IntToString(nChoice) + "; choice text = '" + GetChoiceText(oPC) +  "'");
        ClearCurrentStage(oPC);
        
        if(nStage == STAGE_SELECT_OPTION)
        {
            nStage = STAGE_SELECT_WEAPON;
            if(nChoice==CHOICE_FOCUS_WEAPON_1)
                SetLocalString(oPC, "PRC_WeapApt_Option", OPTION_FOCUS_WEAPON_1);
            else if(nChoice==CHOICE_CRITICAL_WEAPON_1)
                SetLocalString(oPC, "PRC_WeapApt_Option", OPTION_CRITICAL_WEAPON_1);
            else if(nChoice==CHOICE_FOCUS_WEAPON_2)
                SetLocalString(oPC, "PRC_WeapApt_Option", OPTION_FOCUS_WEAPON_2);
            else if(nChoice==CHOICE_CRITICAL_WEAPON_2)
                SetLocalString(oPC, "PRC_WeapApt_Option", OPTION_CRITICAL_WEAPON_2);
            else
                nStage == STAGE_SELECT_OPTION;
        }
        else if(nStage == STAGE_SELECT_WEAPON)
        {
            if(DEBUG_CONVO) DoDebug("tob_aptitudeconv: Weapon selected.  Entering Confirmation.");

            string sOption = GetLocalString(oPC, "PRC_WeapApt_Option");
            SetLocalInt(oPC, sOption, nChoice); //nChoice = row # in WEAPON_FILE + 1

            nStage = STAGE_SELECT_OPTION;
        }

        if(DEBUG_CONVO) DoDebug("tob_aptitudeconv: New stage: " + IntToString(nStage));

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
