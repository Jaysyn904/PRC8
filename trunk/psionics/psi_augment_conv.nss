//::///////////////////////////////////////////////
//:: Augmentation options conversation
//:: psi_augment_conv
//:://////////////////////////////////////////////
/** @file
    A conversation where the user may set up and
    modify their augmentation profiles and a few
    related settings.


    @author Ornedan
    @date   Created  - 2005.11.23
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_dynconv"
#include "psi_inc_augment"


//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_ENTRY          = 0;
const int STAGE_PROFILES       = 1;
const int STAGE_QUICKS         = 2;
const int STAGE_MISC           = 3;
const int STAGE_LEV_OR_PP      = 4;
const int STAGE_SET_DEFAULTS   = 5;
const int STAGE_SET_AUTOMETA   = 6;
const int STAGE_MODIFY_PROFILE = 7;

const int CHOICE_BACK_TO_MAIN = -1;

const int CHOICE_RAISE_1 = 1;
const int CHOICE_LOWER_1 = 2;
const int CHOICE_RAISE_2 = 3;
const int CHOICE_LOWER_2 = 4;
const int CHOICE_RAISE_3 = 5;
const int CHOICE_LOWER_3 = 6;
const int CHOICE_RAISE_4 = 7;
const int CHOICE_LOWER_4 = 8;
const int CHOICE_RAISE_5 = 9;
const int CHOICE_LOWER_5 = 10;
const int CHOICE_SAVE    = 11;
const int CHOICE_CLEAR   = 12;

const int CHOICE_YES = 1;
const int CHOICE_NO  = 0;

const int STRREF_ENTRY_HEADER        = 16828416; // "This conversation manages your augmentation profiles and augmentation quickselections."
const int STRREF_VIEWMOD_PROFILES    = 16828417; // "View / modify augmentation profiles"
const int STRREF_VIEWMOD_QUICKS      = 16828418; // "View / modify quickselections"
const int STRREF_SPECIALOPTIONS      = 16828419; // "Special options"
const int STRREF_BACK_TO_MAIN        = 16824794; // "Back to main menu"
const int STRREF_SELECT_PROFILE      = 16828420; // "Select profile to modify."
const int STRREF_SELECT_QUICKS       = 16828421; // "Select quickselection to modify."
const int STRREF_MAKE_SELECTION      = 16828422; // "Make your selection."
const int STRREF_ENTERSTAGE_LVLORPP  = 16828423; // "Set how the values in an augmentation profile are treated."
const int STRREF_ENTERSTAGE_SMPLDEF  = 16828424; // "Set augmentation profiles to a simple default."
const int STRREF_ENTERSTAGE_AUTOMET  = 16828403; // "Set whether metapsionics code tries to avoid exceeding manifester level cap."
const int STRREF_EXPLAIN_LVLORPP     = 16828425; // "You may define how your personal augmentation profiles are treated. The option values may either mean how many times to use that option, or how many power points to use for that option. In the latter case, the number of times the option is used is the number of power points divided by the cost of the option, rounded down.\nCurrent setting:"
const int STRREF_POWER_POINTS        = 16826409; // "Power Points"
const int STRREF_LEVELS              = 5220;     // "Levels"
const int STRREF_CHANGETO            = 16828426; // "Change to"
const int STRREF_SET_SIMPLE_DEFAULT  = 16828427; // "This will set your profiles to a simple progression, where each profile's first augmentation option's value is equal to the profile's number and all the other options are zero.\n\nThis change is irreversible, are you sure you want to do this?"
const int STRREF_EXPLAIN_AUTOMETA    = 16828402; // "Normally, active metapsionics are applied to an eligible power regardless of whether this would bring the PP cost over the manifester level cap\nAt your option, application of activated metapsionics other than quicken will be skipped if applying that metapsionic power would raise the PP cost over manifester level.\nCurrent setting: "
const int STRREF_YES                 = 4752;     // "Yes"
const int STRREF_NO                  = 4753;     // "No"
const int STRREF_ON                  = 16828380; // "On"
const int STRREF_OFF                 = 16828381; // "Off"
const int STRREF_SET_PROFILEVAL      = 16828428; // "Set the profile's values. Current:"
const int STRREF_OPTION              = 16823498; // "Option"
const int STRREF_RAISE_OPTION        = 16828429; // "Raise option"
const int STRREF_LOWER_OPTION        = 16828430; // "Lower option"
const int STRREF_VALUE               = 16828431; // "value"
const int STRREF_CLEAR_PROFILE       = 16828432; // "Clear profile"
const int STRREF_SAVE_PROFILE        = 16828433; // "Save profile"
const int STRREF_BACK_TO_MAIN_NOSAVE = 16828434; // "Return to main menu without saving"

//////////////////////////////////////////////////
/* Aid functions                                */
//////////////////////////////////////////////////

void ClearLocals(object oPC)
{
    DeleteLocalInt(oPC, "PRC_Augment_Setup_Convo_TempProfile");
    DeleteLocalInt(oPC, "PRC_Augment_Setup_Convo_TempProfile_IsQuickSelection");
    DeleteLocalInt(oPC, "PRC_Augment_Setup_Convo_TempProfile_Index");
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
            if(nStage == STAGE_ENTRY)
            {
                // Set the header
                SetHeaderStrRef(STRREF_ENTRY_HEADER); // "This conversation manages your augmentation profiles and augmentation quickselections."
                // Add responses for the PC
                AddChoiceStrRef(STRREF_VIEWMOD_PROFILES, STAGE_PROFILES, oPC); // "View / modify augmentation profiles"
                AddChoiceStrRef(STRREF_VIEWMOD_QUICKS,   STAGE_QUICKS,   oPC); // "View / modify quickselections"
                AddChoiceStrRef(STRREF_SPECIALOPTIONS,   STAGE_MISC,     oPC); // "Special options"

                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_PROFILES)
            {
                SetHeaderStrRef(STRREF_SELECT_PROFILE); // "Select profile to modify."

                // Back to main choice
                AddChoiceStrRef(STRREF_BACK_TO_MAIN, CHOICE_BACK_TO_MAIN, oPC); // "Back to main menu"

                // Loop over the profiles and add a choice for each
                string sChoice;
                int i;
                for(i = PRC_AUGMENT_PROFILE_INDEX_MIN; i <= PRC_AUGMENT_PROFILE_INDEX_MAX; i++)
                {
                    sChoice = IntToString(i) + " - ";
                    // HACK! Depends on the internal implementation of the profile storage
                    if(GetPersistantLocalInt(oPC, PRC_AUGMENT_PROFILE + IntToString(i)) == PRC_AUGMENT_NULL_PROFILE)
                        sChoice += GetStringByStrRef(16823968); // "Empty profile"
                    else
                        sChoice += UserAugmentationProfileToString(GetUserAugmentationProfile(oPC, i));

                    AddChoice(sChoice, i, oPC);
                }

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_QUICKS)
            {
                SetHeaderStrRef(STRREF_SELECT_QUICKS); // "Select quickselection to modify."

                // Back to main choice
                AddChoiceStrRef(STRREF_BACK_TO_MAIN, CHOICE_BACK_TO_MAIN, oPC); // "Back to main menu"

                // Loop over the quickselections and add a choice for each
                string sChoice;
                int i;
                for(i = PRC_AUGMENT_QUICKSELECTION_MIN; i <= PRC_AUGMENT_QUICKSELECTION_MAX; i++)
                {
                    sChoice = IntToString(i) + " - ";
                    // HACK! Depends on the internal implementation of the profile storage
                    if(GetPersistantLocalInt(oPC, PRC_AUGMENT_QUICKSELECTION + IntToString(i)) == PRC_AUGMENT_NULL_PROFILE)
                        sChoice += GetStringByStrRef(16824180); // "Empty Quickselection"
                    else
                        sChoice += UserAugmentationProfileToString(GetUserAugmentationProfile(oPC, i, TRUE));

                    AddChoice(sChoice, i, oPC);
                }

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_MISC)
            {
                SetHeaderStrRef(STRREF_MAKE_SELECTION); // "Make your selection."

                // Back to main choice
                AddChoiceStrRef(STRREF_BACK_TO_MAIN, STAGE_ENTRY, oPC); // "Back to main menu"

                // The augment levels / PP personal switch
                AddChoiceStrRef(STRREF_ENTERSTAGE_LVLORPP, STAGE_LEV_OR_PP, oPC); // "Set how the values in an augmentation profile are treated."
                // Set the profiles to a default that approximates the old behaviour
                AddChoiceStrRef(STRREF_ENTERSTAGE_SMPLDEF, STAGE_SET_DEFAULTS, oPC); // "Set augmentation profiles to a simple default."
                // Toggle whether metapsionics automatically skips affecting a power if it would cause manifester cap to be exceeded
                AddChoiceStrRef(STRREF_ENTERSTAGE_AUTOMET, STAGE_SET_AUTOMETA, oPC); // "Set whether metapsionics code tries to avoid exceeding manifester level cap."

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_LEV_OR_PP)
            {
                SetHeader(GetStringByStrRef(STRREF_EXPLAIN_LVLORPP) + " " // "You may define how your personal augmentation profiles are treated. The option values may either mean how many times to use that option, or how many power points to use for that option. In the latter case, the number of times the option is used is the number of power points divided by the cost of the option, rounded down.\nCurrent setting: "
                        + (GetPersistantLocalInt(oPC, PRC_PLAYER_SWITCH_AUGMENT_IS_PP) ?
                           GetStringByStrRef(STRREF_POWER_POINTS) : // "Power Points"
                           GetStringByStrRef(STRREF_LEVELS)         // "Levels"
                           )
                          );

                // Back to main choice
                AddChoiceStrRef(STRREF_BACK_TO_MAIN, CHOICE_BACK_TO_MAIN, oPC); // "Back to main menu"

                AddChoice(GetStringByStrRef(STRREF_CHANGETO) + " " + GetStringByStrRef(STRREF_LEVELS) + ".",       FALSE, oPC); // "Change to levels."
                AddChoice(GetStringByStrRef(STRREF_CHANGETO) + " " + GetStringByStrRef(STRREF_POWER_POINTS) + ".", TRUE,  oPC); // "Change to power points."

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_SET_DEFAULTS)
            {
                SetHeaderStrRef(STRREF_SET_SIMPLE_DEFAULT); // "This will set your profiles to a simple progression, where each profile's first augmentation option's value is equal to the profile's number and all the other options are zero.\n\nThis change is irreversible, are you sure you want to do this?"

                AddChoiceStrRef(STRREF_YES, CHOICE_YES, oPC);
                AddChoiceStrRef(STRREF_NO,  CHOICE_NO,  oPC);

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_SET_AUTOMETA)
            {
                SetHeader(GetStringByStrRef(STRREF_EXPLAIN_AUTOMETA) + " " // "Normally, active metapsionics are applied to an eligible power regardless of whether this would bring the PP cost over the manifester level cap\nAt your option, application of activated metapsionics other than quicken will be skipped if applying that metapsionic power would raise the PP cost over manifester level.\nCurrent setting: "
                        + (GetPersistantLocalInt(oPC, PRC_PLAYER_SWITCH_AUTOMETAPSI) ?
                           GetStringByStrRef(STRREF_ON) : // "On"
                           GetStringByStrRef(STRREF_OFF)  // "Off"
                           )
                          );

                // Back to main choice
                AddChoiceStrRef(STRREF_BACK_TO_MAIN, CHOICE_BACK_TO_MAIN, oPC); // "Back to main menu"

                AddChoice(GetStringByStrRef(STRREF_ON),  TRUE,  oPC); // "On"
                AddChoice(GetStringByStrRef(STRREF_OFF), FALSE, oPC); // "Off"

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_MODIFY_PROFILE)
            {
                struct user_augment_profile uapTemp = _DecodeProfile(GetLocalInt(oPC, "PRC_Augment_Setup_Convo_TempProfile"));

                // "Set the profile's values. Current:"
                SetHeader(GetStringByStrRef(STRREF_SET_PROFILEVAL) + "\n"
                        + GetStringByStrRef(STRREF_OPTION) + " 1: " + IntToString(uapTemp.nOption_1) + "\n"
                        + GetStringByStrRef(STRREF_OPTION) + " 2: " + IntToString(uapTemp.nOption_2) + "\n"
                        + GetStringByStrRef(STRREF_OPTION) + " 3: " + IntToString(uapTemp.nOption_3) + "\n"
                        + GetStringByStrRef(STRREF_OPTION) + " 4: " + IntToString(uapTemp.nOption_4) + "\n"
                        + GetStringByStrRef(STRREF_OPTION) + " 5: " + IntToString(uapTemp.nOption_5)
                          );

                // The modification choices
                AddChoice(GetStringByStrRef(STRREF_RAISE_OPTION) + " 1 " + GetStringByStrRef(STRREF_VALUE), CHOICE_RAISE_1, oPC);
                AddChoice(GetStringByStrRef(STRREF_LOWER_OPTION) + " 1 " + GetStringByStrRef(STRREF_VALUE), CHOICE_LOWER_1, oPC);
                AddChoice(GetStringByStrRef(STRREF_RAISE_OPTION) + " 2 " + GetStringByStrRef(STRREF_VALUE), CHOICE_RAISE_2, oPC);
                AddChoice(GetStringByStrRef(STRREF_LOWER_OPTION) + " 2 " + GetStringByStrRef(STRREF_VALUE), CHOICE_LOWER_2, oPC);
                AddChoice(GetStringByStrRef(STRREF_RAISE_OPTION) + " 3 " + GetStringByStrRef(STRREF_VALUE), CHOICE_RAISE_3, oPC);
                AddChoice(GetStringByStrRef(STRREF_LOWER_OPTION) + " 3 " + GetStringByStrRef(STRREF_VALUE), CHOICE_LOWER_3, oPC);
                AddChoice(GetStringByStrRef(STRREF_RAISE_OPTION) + " 4 " + GetStringByStrRef(STRREF_VALUE), CHOICE_RAISE_4, oPC);
                AddChoice(GetStringByStrRef(STRREF_LOWER_OPTION) + " 4 " + GetStringByStrRef(STRREF_VALUE), CHOICE_LOWER_4, oPC);
                AddChoice(GetStringByStrRef(STRREF_RAISE_OPTION) + " 5 " + GetStringByStrRef(STRREF_VALUE), CHOICE_RAISE_5, oPC);
                AddChoice(GetStringByStrRef(STRREF_LOWER_OPTION) + " 5 " + GetStringByStrRef(STRREF_VALUE), CHOICE_LOWER_5, oPC);

                // Add the save choice
                AddChoiceStrRef(STRREF_CLEAR_PROFILE, CHOICE_CLEAR, oPC); // "Clear profile"
                AddChoiceStrRef(STRREF_SAVE_PROFILE,  CHOICE_SAVE,  oPC); // "Save profile"
                AddChoiceStrRef(STRREF_BACK_TO_MAIN_NOSAVE, CHOICE_BACK_TO_MAIN, oPC); // "Return to main menu without saving"

                MarkStageSetUp(nStage, oPC);
            }
        }

        // Do token setup
        SetupTokens();
    }
    // End of conversation cleanup
    else if(nValue == DYNCONV_EXITED)
    {
        ClearLocals(oPC);
    }
    // Abort conversation cleanup.
    // NOTE: This section is only run when the conversation is aborted
    // while aborting is allowed. When it isn't, the dynconvo infrastructure
    // handles restoring the conversation in a transparent manner
    else if(nValue == DYNCONV_ABORTED)
    {
        ClearLocals(oPC);
    }
    // Handle PC responses
    else
    {
        // variable named nChoice is the value of the player's choice as stored when building the choice list
        // variable named nStage determines the current conversation node
        int nChoice = GetChoice(oPC);

        // Clear the current stage's setup marker
        MarkStageNotSetUp(nStage, oPC);

        if(nStage == STAGE_ENTRY)
        {
            // From the mainmenu, the choice is the index of the stage to move to
            nStage = nChoice;
        }
        else if(nStage == STAGE_PROFILES)
        {
            if(nChoice == CHOICE_BACK_TO_MAIN) nStage = STAGE_ENTRY;
            else
            {
                // The choice is the index of the profile to modify
                SetLocalInt(oPC, "PRC_Augment_Setup_Convo_TempProfile", GetPersistantLocalInt(oPC, PRC_AUGMENT_PROFILE + IntToString(nChoice)));
                SetLocalInt(oPC, "PRC_Augment_Setup_Convo_TempProfile_IsQuickSelection", FALSE);
                SetLocalInt(oPC, "PRC_Augment_Setup_Convo_TempProfile_Index", nChoice);

                nStage = STAGE_MODIFY_PROFILE;
            }
        }
        else if(nStage == STAGE_QUICKS)
        {
            if(nChoice == CHOICE_BACK_TO_MAIN) nStage = STAGE_ENTRY;
            else
            {
                // The choice is the index of the profile to modify
                SetLocalInt(oPC, "PRC_Augment_Setup_Convo_TempProfile", GetPersistantLocalInt(oPC, PRC_AUGMENT_QUICKSELECTION + IntToString(nChoice)));
                SetLocalInt(oPC, "PRC_Augment_Setup_Convo_TempProfile_IsQuickSelection", TRUE);
                SetLocalInt(oPC, "PRC_Augment_Setup_Convo_TempProfile_Index", nChoice);

                nStage = STAGE_MODIFY_PROFILE;
            }
        }
        else if(nStage == STAGE_MISC)
        {
            // The choice is the index of the stage to move to
            nStage = nChoice;
        }
        else if(nStage == STAGE_LEV_OR_PP)
        {
            if(nChoice == CHOICE_BACK_TO_MAIN) nStage = STAGE_ENTRY;
            else
            {
                // The value of the choice is the new value of the switch
                SetPersistantLocalInt(oPC, PRC_PLAYER_SWITCH_AUGMENT_IS_PP, nChoice);
                ClearCurrentStage(oPC);
            }
        }
        else if(nStage == STAGE_SET_DEFAULTS)
        {
            if(nChoice == CHOICE_YES)
            {
                // Loop over all profiles and set them to a new value
                struct user_augment_profile uapTemp;
                uapTemp.nOption_1 = 0;
                uapTemp.nOption_2 = 0;
                uapTemp.nOption_3 = 0;
                uapTemp.nOption_4 = 0;
                uapTemp.nOption_5 = 0;

                int i;
                for(i = PRC_AUGMENT_PROFILE_INDEX_MIN; i <= PRC_AUGMENT_PROFILE_INDEX_MAX; i++)
                {
                    uapTemp.nOption_1 = i;
                    StoreUserAugmentationProfile(oPC, i, uapTemp, FALSE);
                }
            }

            nStage = STAGE_ENTRY;
        }
        else if(nStage == STAGE_SET_AUTOMETA)
        {
            if(nChoice == CHOICE_BACK_TO_MAIN) nStage = STAGE_ENTRY;
            else
            {
                // The value of the choice is the new value of the switch
                SetPersistantLocalInt(oPC, PRC_PLAYER_SWITCH_AUTOMETAPSI, nChoice);
                ClearCurrentStage(oPC);
            }
        }
        else if(nStage == STAGE_MODIFY_PROFILE)
        {
            if(nChoice == CHOICE_BACK_TO_MAIN) nStage = STAGE_ENTRY;
            else
            {
                struct user_augment_profile uapTemp = _DecodeProfile(GetLocalInt(oPC, "PRC_Augment_Setup_Convo_TempProfile"));

                // Depends on the values of the choice options being a continuous series
                if(nChoice >= CHOICE_RAISE_1 && nChoice <= CHOICE_LOWER_5)
                {
                    switch(nChoice)
                    {
                        case CHOICE_RAISE_1: uapTemp.nOption_1++; break;
                        case CHOICE_LOWER_1: uapTemp.nOption_1--; break;
                        case CHOICE_RAISE_2: uapTemp.nOption_2++; break;
                        case CHOICE_LOWER_2: uapTemp.nOption_2--; break;
                        case CHOICE_RAISE_3: uapTemp.nOption_3++; break;
                        case CHOICE_LOWER_3: uapTemp.nOption_3--; break;
                        case CHOICE_RAISE_4: uapTemp.nOption_4++; break;
                        case CHOICE_LOWER_4: uapTemp.nOption_4--; break;
                        case CHOICE_RAISE_5: uapTemp.nOption_5++; break;
                        case CHOICE_LOWER_5: uapTemp.nOption_5--; break;
                    }

                    SetLocalInt(oPC, "PRC_Augment_Setup_Convo_TempProfile", _EncodeProfile(uapTemp));
                    ClearCurrentStage(oPC);
                }
                else if(nChoice == CHOICE_CLEAR)
                {
                    uapTemp.nOption_1 = 0;
                    uapTemp.nOption_2 = 0;
                    uapTemp.nOption_3 = 0;
                    uapTemp.nOption_4 = 0;
                    uapTemp.nOption_5 = 0;

                    ClearCurrentStage(oPC);
                }
                else if(nChoice == CHOICE_SAVE)
                {
                    StoreUserAugmentationProfile(oPC, GetLocalInt(oPC, "PRC_Augment_Setup_Convo_TempProfile_Index"),
                                                 uapTemp, GetLocalInt(oPC, "PRC_Augment_Setup_Convo_TempProfile_IsQuickSelection")
                                                 );
                    nStage = STAGE_ENTRY;
                }
            }
        }

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
