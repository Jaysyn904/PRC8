//:://////////////////////////////////////////////
//:: Shifter shifting options management conversation
//:: prc_shift_convo
//:://////////////////////////////////////////////
/** @file
    PnP Shifter shifting & shifting options management
    conversation script.


    @author Ornedan
    @date   Created  - 2006.03.01
    @date   Modified - 2006.10.07 - Finished
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_dynconv"
#include "prc_inc_shifting"

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_ENTRY                   = 0;
const int STAGE_CHANGESHAPE             = 1;
const int STAGE_LISTQUICKSHIFTS         = 2;
const int STAGE_DELETESHAPE             = 3;
const int STAGE_SETTINGS                = 4;
const int STAGE_SELECTQUICKSHIFTSHAPE   = 5;
const int STAGE_COULDNTSHIFT            = 6;


const int CHOICE_CHANGESHAPE            = 1;
const int CHOICE_LISTQUICKSHIFTS        = 2;
const int CHOICE_DELETESHAPE            = 3;
const int CHOICE_SETTINGS               = 4;

const int CHOICE_STORE_TRUEAPPEARANCE   = 1;

const int CHOICE_BACK_TO_MAIN           = -1;
const int STRREF_BACK_TO_MAIN           = 16824794; // "Back to main menu"

const string QSMODIFYVAR    = "PRC_ShiftConvo_QSToModify";

//////////////////////////////////////////////////
/* Aid functions                                */
//////////////////////////////////////////////////

void GenerateShapeList(object oPC, int nShiftType)
{
    int i, nArraySize = GetNumberOfStoredTemplates(oPC, nShiftType);

    for(i = 0; i < nArraySize; i++)
        AddChoice(GetStoredTemplateName(oPC, nShiftType, i), i, oPC);
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
    int nShiftType;
    string sQuickslotSource;
    int nSourceSpellId = GetLocalInt(oPC, "ChangeShapeConfig");

    // Check which of the conversation scripts called the scripts
    if(nValue == 0) // All of them set the DynConv_Var to non-zero value, so something is wrong -> abort
        return;
        
    switch(nSourceSpellId)
    {
        case SPELL_CHANGLING_CHANGE_SHAPE_OPTIONS:
        case SPELL_QUICK_CHANGE_SHAPE_OPTIONS:     nShiftType = SHIFTER_TYPE_DISGUISE_SELF; sQuickslotSource = "Changeling_Shape_Quick_"; break;
        
        case SPELL_IRDA_CHANGE_SHAPE_OPTIONS:      nShiftType = SHIFTER_TYPE_HUMANOIDSHAPE; sQuickslotSource = "Irda_Shape_Quick_"; break;
        
        case INVOKE_HUMANOID_SHAPE_OPTION:         nShiftType = SHIFTER_TYPE_HUMANOIDSHAPE; sQuickslotSource = "Humanoid_Shape_Quick_"; 
                                                   SetLocalInt(oPC, "HumanoidShapeInvocation", TRUE); break;
        
        case SPELL_FEYRI_CHANGE_SHAPE_OPTIONS:     nShiftType = SHIFTER_TYPE_HUMANOIDSHAPE; sQuickslotSource = "Feyri_Shape_Quick_"; break;
        
        case SPELL_RAKSHASA_CHANGE_SHAPE_OPTIONS:  nShiftType = SHIFTER_TYPE_HUMANOIDSHAPE; sQuickslotSource = "Rakshasa_Shape_Quick_"; break;
        
        case SPELL_DISGUISE_SELF_OPTIONS:          nShiftType = SHIFTER_TYPE_DISGUISE_SELF; sQuickslotSource = "Disguise_Self_Quick_"; break;
        case SPELL_FACECHANGER_OPTIONS:            nShiftType = SHIFTER_TYPE_DISGUISE_SELF; sQuickslotSource = "Disguise_Self_Quick_"; break;
        case SPELL_ALTER_SELF_OPTIONS:             nShiftType = SHIFTER_TYPE_ALTER_SELF; sQuickslotSource = "Alter_Self_Quick_"; break;
    }
    
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
                SetHeader(GetStringByStrRef(16824364) + " :"); // "Shifter Options :"


                AddChoiceStrRef(16828366,     CHOICE_CHANGESHAPE,      oPC); // "Change shape"
                AddChoiceStrRef(16828368,     CHOICE_LISTQUICKSHIFTS,  oPC); // "View / Assign shapes to your 'Quick Shift Slots'"
                AddChoiceStrRef(16828369,     CHOICE_DELETESHAPE,      oPC); // "Delete shapes you do not want anymore"
                AddChoiceStrRef(16828370,     CHOICE_SETTINGS,         oPC); // "Special settings"

                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens();          // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_CHANGESHAPE)
            {
                SetHeaderStrRef(16828372);   // "Select shape to become"

                // The list may be long, so list the back choice first
                AddChoiceStrRef(STRREF_BACK_TO_MAIN, CHOICE_BACK_TO_MAIN, oPC);

                GenerateShapeList(oPC, nShiftType);

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_COULDNTSHIFT)
            {
                SetHeaderStrRef(16828373); // "You didn't have Change Shape uses available."

                AddChoiceStrRef(STRREF_BACK_TO_MAIN, CHOICE_BACK_TO_MAIN, oPC);
            }
            else if(nStage == STAGE_LISTQUICKSHIFTS)
            {
                SetHeader("Select a 'Quick Shift Slot' to change the shape stored in it");

                int i;
                //3 quickslots for the spells, 2 otherwise
                int nLimit = (nSourceSpellId == SPELL_DISGUISE_SELF_OPTIONS || nSourceSpellId == SPELL_ALTER_SELF_OPTIONS || nSourceSpellId == SPELL_FACECHANGER_OPTIONS) ? 3 : 2;
                for(i = 1; i <= nLimit; i++)
                    AddChoice(GetStringByStrRef(16828374) + " " + IntToString(i) + " - " // "Quick Shift Slot N - "
                            + (GetPersistantLocalString(oPC, sQuickslotSource + IntToString(i) + "_ResRef") != "" ?
                               GetPersistantLocalString(oPC, sQuickslotSource + IntToString(i) + "_Name") :
                               GetStringByStrRef(16825282) // "Blank"
                               ),
                              i, oPC);

                AddChoiceStrRef(STRREF_BACK_TO_MAIN, CHOICE_BACK_TO_MAIN, oPC);

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_SELECTQUICKSHIFTSHAPE)
            {
                SetHeaderStrRef(16828377);   // "Select shape to store"

                // The list may be long, so list the back choice first
                AddChoiceStrRef(STRREF_BACK_TO_MAIN, CHOICE_BACK_TO_MAIN, oPC);

                GenerateShapeList(oPC, nShiftType);

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_DELETESHAPE)
            {
                SetHeaderStrRef(16828378); // "Select shape to delete.\nNote that if the shape is stored in any quickslots, the shape will still remain in those until you change their contents."

                // The list may be long, so list the back choice first
                AddChoiceStrRef(STRREF_BACK_TO_MAIN, CHOICE_BACK_TO_MAIN, oPC);

                GenerateShapeList(oPC, nShiftType);

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_SETTINGS)
            {
                SetHeaderStrRef(16828384); // "Select special setting to alter."

                AddChoiceStrRef(16828385, CHOICE_STORE_TRUEAPPEARANCE, oPC); // "Store your current appearance as your true appearance (will not work if polymorphed or shifted)."

                AddChoiceStrRef(STRREF_BACK_TO_MAIN, CHOICE_BACK_TO_MAIN, oPC);

                MarkStageSetUp(nStage, oPC);
            }
        }

        // Do token setup
        SetupTokens();
    }
    // End of conversation cleanup
    else if(nValue == DYNCONV_EXITED)
    {
        // Add any locals set through this conversation
        DeleteLocalInt(oPC, QSMODIFYVAR);
        DeleteLocalInt(oPC, "ChangeShapeConfig");
        DeleteLocalInt(oPC, "HumanoidShapeInvocation");
    }
    // Abort conversation cleanup.
    // NOTE: This section is only run when the conversation is aborted
    // while aborting is allowed. When it isn't, the dynconvo infrastructure
    // handles restoring the conversation in a transparent manner
    else if(nValue == DYNCONV_ABORTED)
    {
        // Add any locals set through this conversation
        DeleteLocalInt(oPC, QSMODIFYVAR);
    }
    // Handle PC responses
    else
    {
        // variable named nChoice is the value of the player's choice as stored when building the choice list
        // variable named nStage determines the current conversation node
        int nChoice = GetChoice(oPC);
        ClearCurrentStage(oPC);
        if(nStage == STAGE_ENTRY)
        {
            switch(nChoice)
            {
                case CHOICE_CHANGESHAPE:
                    nStage = STAGE_CHANGESHAPE;
                    break;

                case CHOICE_LISTQUICKSHIFTS:
                    nStage = STAGE_LISTQUICKSHIFTS;
                    break;
                case CHOICE_DELETESHAPE:
                    nStage = STAGE_DELETESHAPE;
                    break;
                case CHOICE_SETTINGS:
                    nStage = STAGE_SETTINGS;
                    break;

                default:
                    DoDebug("prc_shift_convo: ERROR: Unknown choice value at STAGE_ENTRY: " + IntToString(nChoice));
            }
        }
        else if(nStage == STAGE_CHANGESHAPE)
        {
            // Return to main menu?
            if(nChoice == CHOICE_BACK_TO_MAIN)
                nStage = STAGE_ENTRY;
            // Something chosen to be shifted into
            else
            {
                // Make sure the character has uses left for shifting
                int bPaid = FALSE;
                // Pay if Irda
                if(nSourceSpellId == SPELL_IRDA_CHANGE_SHAPE_OPTIONS)
                {
                    DecrementRemainingFeatUses(oPC, FEAT_IRDA_CHANGE_SHAPE);
                    bPaid = TRUE;
                }
                
                else
                    bPaid = TRUE;

                // If the user could pay for the shifting, do it
                if(bPaid)
                {
                    // Choice is index into the template list
                    if(!ShiftIntoResRef(oPC, nShiftType,
                                        GetStoredTemplate(oPC, nShiftType, nChoice)
                                        )
                       )
                    {
                        // In case of shifting failure, refund the shifting use
                        if(nSourceSpellId == SPELL_IRDA_CHANGE_SHAPE_OPTIONS)
                            IncrementRemainingFeatUses(oPC, FEAT_IRDA_CHANGE_SHAPE);
                    }

                    // The convo should end now
                    AllowExit(DYNCONV_EXIT_FORCE_EXIT);
                }
                // Otherwise, move to nag at them about it
                else
                    nStage = STAGE_COULDNTSHIFT;
            }
        }
        else if(nStage == STAGE_COULDNTSHIFT)
        {
            // Return to main menu

            nStage = STAGE_ENTRY;
        }
        else if(nStage == STAGE_LISTQUICKSHIFTS)
        {
            // Return to main menu?
            if(nChoice == CHOICE_BACK_TO_MAIN)
                nStage = STAGE_ENTRY;
            // Something slot chosen to be modified
            else
            {
                // Store the number of the slot to be modified
                SetLocalInt(oPC, QSMODIFYVAR, nChoice);
                nStage = STAGE_SELECTQUICKSHIFTSHAPE;
            }
        }
        else if(nStage == STAGE_SELECTQUICKSHIFTSHAPE)
        {
            // Return to main menu?
            if(nChoice == CHOICE_BACK_TO_MAIN)
                nStage = STAGE_ENTRY;
            // Something chosen to be stored
            else
            {
                // Store the chosen template into the quickslot, choice is the template's index in the main list
                int nSlot = GetLocalInt(oPC, QSMODIFYVAR);
                SetPersistantLocalString(oPC, sQuickslotSource + IntToString(nSlot) + "_ResRef",
                                         GetStoredTemplate(oPC, nShiftType, nChoice)
                                         );
                SetPersistantLocalString(oPC, sQuickslotSource + IntToString(nSlot) + "_Name",
                                         GetStoredTemplateName(oPC, nShiftType, nChoice)
                                         );

                // Clean up
                DeleteLocalInt(oPC, QSMODIFYVAR);

                // Return to main menu
                nStage = STAGE_ENTRY;
            }
        }
        else if(nStage == STAGE_DELETESHAPE)
        {
            // Something was chosen for deletion?
            if(nChoice != CHOICE_BACK_TO_MAIN)
            {
                // Choice is index into the template list
                DeleteStoredTemplate(oPC, nShiftType, nChoice);
            }

            // Return to main menu in any case
            nStage = STAGE_ENTRY;
        }
        else if(nStage == STAGE_SETTINGS)
        {
            // Return to main menu?
            if(nChoice == CHOICE_BACK_TO_MAIN)
                nStage = STAGE_ENTRY;
            else if(nChoice == CHOICE_STORE_TRUEAPPEARANCE)
            {
                // Probably should give feedback about whether this was successfull or not. Though the warning in the selection text could be enough
                StoreCurrentAppearanceAsTrueAppearance(oPC, TRUE);
                nStage = STAGE_ENTRY;
            }
        }

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
