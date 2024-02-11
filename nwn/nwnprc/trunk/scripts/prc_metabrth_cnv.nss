//::///////////////////////////////////////////////
//:: Metabreath options conversation
//:: prc_metabrth_con
//:://////////////////////////////////////////////
/** @file
    A conversation where the user may set up and
    modify their quickslots for self-stackable 
    metabreaths


    @author Fox
    @date   Created  - 2008.1.23
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_dynconv"
#include "prc_spell_const"
#include "inc_persist_loca"

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_ENTRY          = 0;
const int STAGE_SLOT1          = 1;
const int STAGE_SLOT2          = 2;
const int STAGE_SLOT3          = 3;

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

const int STRREF_ENTRY_HEADER        = 16832891; // "This conversation manages your quickslots for your metabreath feats."
const int STRREF_SET_SLOT1           = 16832887; // "Quickslot 1"
const int STRREF_SET_SLOT2           = 16832888; // "Quickslot 2"
const int STRREF_SET_SLOT3           = 16832889; // "Quickslot 3"
const int STRREF_RAISE_BY            = 16832892; // "Raise value by"
const int STRREF_LOWER_BY            = 16832893; // "Lower value by"
const int STRREF_CLEAR_VALUE         = 16832894; // "Clear value"
const int STRREF_SAVE_VALUE          = 16832895; // "Save value"
const int STRREF_CURRENT_FEAT        = 16832896; // "Current feat: "
const int STRREF_CURRENT_VALUE       = 16832897; // "Current value: "
const int STRREF_BACK_TO_MAIN_NOSAVE = 16828434; // "Return to main menu without saving"

//////////////////////////////////////////////////
/* Aid functions                                */
//////////////////////////////////////////////////

void ClearLocals(object oPC)
{
    DeleteLocalInt(oPC, "MetabreathTempValue");
    DeleteLocalInt(oPC, "MetabreathSpellId");
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
                SetHeaderStrRef(STRREF_ENTRY_HEADER); 
                // Add responses for the PC
                AddChoiceStrRef(STRREF_SET_SLOT1, STAGE_SLOT1, oPC); // "Quickslot 1"
                AddChoiceStrRef(STRREF_SET_SLOT2, STAGE_SLOT2, oPC); // "Quickslot 2"
                if(GetLocalInt(oPC, "MetabreathSpellId") != SPELL_HEIGHTEN_CONV) AddChoiceStrRef(STRREF_SET_SLOT3, STAGE_SLOT3, oPC); // "Quickslot 3"

                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_SLOT1)
            {
                int nValue = GetLocalInt(oPC, "MetabreathTempValue");
                string sFeatSelected;
                if(GetLocalInt(oPC, "MetabreathSpellId") == SPELL_HEIGHTEN_CONV) sFeatSelected = "Heighten Breath";
                else if(GetLocalInt(oPC, "MetabreathSpellId") == SPELL_CLINGING_CONV) sFeatSelected = "Clinging Breath";
                else if(GetLocalInt(oPC, "MetabreathSpellId") == SPELL_LINGERING_CONV) sFeatSelected = "Lingering Breath";

                // "Current Feat: <feat> Quickslot 1 Current Value: <value>"
                SetHeader(GetStringByStrRef(STRREF_CURRENT_FEAT) + sFeatSelected + "\n"
                        + GetStringByStrRef(STRREF_SET_SLOT1) + "\n"
                        + GetStringByStrRef(STRREF_CURRENT_VALUE) + IntToString(nValue)
                        );

                // The modification choices
                AddChoice(GetStringByStrRef(STRREF_RAISE_BY) + " 1", CHOICE_RAISE_1, oPC);
                AddChoice(GetStringByStrRef(STRREF_LOWER_BY) + " 1", CHOICE_LOWER_1, oPC);
                AddChoice(GetStringByStrRef(STRREF_RAISE_BY) + " 2", CHOICE_RAISE_2, oPC);
                AddChoice(GetStringByStrRef(STRREF_LOWER_BY) + " 2", CHOICE_LOWER_2, oPC);
                AddChoice(GetStringByStrRef(STRREF_RAISE_BY) + " 3", CHOICE_RAISE_3, oPC);
                AddChoice(GetStringByStrRef(STRREF_LOWER_BY) + " 3", CHOICE_LOWER_3, oPC);
                AddChoice(GetStringByStrRef(STRREF_RAISE_BY) + " 4", CHOICE_RAISE_4, oPC);
                AddChoice(GetStringByStrRef(STRREF_LOWER_BY) + " 4", CHOICE_LOWER_4, oPC);
                AddChoice(GetStringByStrRef(STRREF_RAISE_BY) + " 5", CHOICE_RAISE_5, oPC);
                AddChoice(GetStringByStrRef(STRREF_LOWER_BY) + " 5", CHOICE_LOWER_5, oPC);

                // Add the save choice
                AddChoiceStrRef(STRREF_CLEAR_VALUE, CHOICE_CLEAR, oPC); // "Clear value"
                AddChoiceStrRef(STRREF_SAVE_VALUE,  CHOICE_SAVE,  oPC); // "Save value"
                AddChoiceStrRef(STRREF_BACK_TO_MAIN_NOSAVE, CHOICE_BACK_TO_MAIN, oPC); // "Return to main menu without saving"

                MarkStageSetUp(nStage, oPC);
            }
            
            else if(nStage == STAGE_SLOT2)
            {
                int nValue = GetLocalInt(oPC, "MetabreathTempValue");
                string sFeatSelected;
                if(GetLocalInt(oPC, "MetabreathSpellId") == SPELL_HEIGHTEN_CONV) sFeatSelected = "Heighten Breath";
                else if(GetLocalInt(oPC, "MetabreathSpellId") == SPELL_CLINGING_CONV) sFeatSelected = "Clinging Breath";
                else if(GetLocalInt(oPC, "MetabreathSpellId") == SPELL_LINGERING_CONV) sFeatSelected = "Lingering Breath";

                // "Current Feat: <feat> Quickslot 2 Current Value: <value>"
                SetHeader(GetStringByStrRef(STRREF_CURRENT_FEAT) + sFeatSelected + "\n"
                        + GetStringByStrRef(STRREF_SET_SLOT2) + "\n"
                        + GetStringByStrRef(STRREF_CURRENT_VALUE) + IntToString(nValue)
                        );

                // The modification choices
                AddChoice(GetStringByStrRef(STRREF_RAISE_BY) + " 1", CHOICE_RAISE_1, oPC);
                AddChoice(GetStringByStrRef(STRREF_LOWER_BY) + " 1", CHOICE_LOWER_1, oPC);
                AddChoice(GetStringByStrRef(STRREF_RAISE_BY) + " 2", CHOICE_RAISE_2, oPC);
                AddChoice(GetStringByStrRef(STRREF_LOWER_BY) + " 2", CHOICE_LOWER_2, oPC);
                AddChoice(GetStringByStrRef(STRREF_RAISE_BY) + " 3", CHOICE_RAISE_3, oPC);
                AddChoice(GetStringByStrRef(STRREF_LOWER_BY) + " 3", CHOICE_LOWER_3, oPC);
                AddChoice(GetStringByStrRef(STRREF_RAISE_BY) + " 4", CHOICE_RAISE_4, oPC);
                AddChoice(GetStringByStrRef(STRREF_LOWER_BY) + " 4", CHOICE_LOWER_4, oPC);
                AddChoice(GetStringByStrRef(STRREF_RAISE_BY) + " 5", CHOICE_RAISE_5, oPC);
                AddChoice(GetStringByStrRef(STRREF_LOWER_BY) + " 5", CHOICE_LOWER_5, oPC);

                // Add the save choice
                AddChoiceStrRef(STRREF_CLEAR_VALUE, CHOICE_CLEAR, oPC); // "Clear value"
                AddChoiceStrRef(STRREF_SAVE_VALUE,  CHOICE_SAVE,  oPC); // "Save value"
                AddChoiceStrRef(STRREF_BACK_TO_MAIN_NOSAVE, CHOICE_BACK_TO_MAIN, oPC); // "Return to main menu without saving"

                MarkStageSetUp(nStage, oPC);
            }
            
            else if(nStage == STAGE_SLOT3)
            {
                int nValue = GetLocalInt(oPC, "MetabreathTempValue");
                string sFeatSelected;
                if(GetLocalInt(oPC, "MetabreathSpellId") == SPELL_CLINGING_CONV) sFeatSelected = "Clinging Breath";
                else if(GetLocalInt(oPC, "MetabreathSpellId") == SPELL_LINGERING_CONV) sFeatSelected = "Lingering Breath";

                // "Current Feat: <feat> Quickslot 3 Current Value: <value>"
                SetHeader(GetStringByStrRef(STRREF_CURRENT_FEAT) + sFeatSelected + "\n"
                        + GetStringByStrRef(STRREF_SET_SLOT3) + "\n"
                        + GetStringByStrRef(STRREF_CURRENT_VALUE) + IntToString(nValue)
                        );

                // The modification choices
                AddChoice(GetStringByStrRef(STRREF_RAISE_BY) + " 1", CHOICE_RAISE_1, oPC);
                AddChoice(GetStringByStrRef(STRREF_LOWER_BY) + " 1", CHOICE_LOWER_1, oPC);
                AddChoice(GetStringByStrRef(STRREF_RAISE_BY) + " 2", CHOICE_RAISE_2, oPC);
                AddChoice(GetStringByStrRef(STRREF_LOWER_BY) + " 2", CHOICE_LOWER_2, oPC);
                AddChoice(GetStringByStrRef(STRREF_RAISE_BY) + " 3", CHOICE_RAISE_3, oPC);
                AddChoice(GetStringByStrRef(STRREF_LOWER_BY) + " 3", CHOICE_LOWER_3, oPC);
                AddChoice(GetStringByStrRef(STRREF_RAISE_BY) + " 4", CHOICE_RAISE_4, oPC);
                AddChoice(GetStringByStrRef(STRREF_LOWER_BY) + " 4", CHOICE_LOWER_4, oPC);
                AddChoice(GetStringByStrRef(STRREF_RAISE_BY) + " 5", CHOICE_RAISE_5, oPC);
                AddChoice(GetStringByStrRef(STRREF_LOWER_BY) + " 5", CHOICE_LOWER_5, oPC);

                // Add the save choice
                AddChoiceStrRef(STRREF_CLEAR_VALUE, CHOICE_CLEAR, oPC); // "Clear value"
                AddChoiceStrRef(STRREF_SAVE_VALUE,  CHOICE_SAVE,  oPC); // "Save value"
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
            int nValue;
            if(GetLocalInt(oPC, "MetabreathSpellId") == SPELL_HEIGHTEN_CONV)
            {
            	if(nChoice == STAGE_SLOT1)
            	    nValue = GetPersistantLocalInt(oPC, "HeightenBreathSlot1");
            	if(nChoice == STAGE_SLOT2)
            	    nValue = GetPersistantLocalInt(oPC, "HeightenBreathSlot2");
            }
            else if(GetLocalInt(oPC, "MetabreathSpellId") == SPELL_CLINGING_CONV)
            {
            	if(nChoice == STAGE_SLOT1)
            	    nValue = GetPersistantLocalInt(oPC, "ClingingBreathSlot1");
            	if(nChoice == STAGE_SLOT2)
            	    nValue = GetPersistantLocalInt(oPC, "ClingingBreathSlot2");
            	if(nChoice == STAGE_SLOT3)
            	    nValue = GetPersistantLocalInt(oPC, "ClingingBreathSlot3");
            }
            else if(GetLocalInt(oPC, "MetabreathSpellId") == SPELL_LINGERING_CONV) 
            {
            	if(nChoice == STAGE_SLOT1)
            	    nValue = GetPersistantLocalInt(oPC, "LingeringBreathSlot1");
            	if(nChoice == STAGE_SLOT2)
            	    nValue = GetPersistantLocalInt(oPC, "LingeringBreathSlot2");
            	if(nChoice == STAGE_SLOT3)
            	    nValue = GetPersistantLocalInt(oPC, "LingeringBreathSlot3");
            }
            SetLocalInt(oPC, "MetabreathTempValue", nValue);
            // From the mainmenu, the choice is the index of the stage to move to
            nStage = nChoice;
        }
        else if(nStage == STAGE_SLOT1)
        {
            if(nChoice == CHOICE_BACK_TO_MAIN) nStage = STAGE_ENTRY;
            else
            {
                string sQuickslotSelected;
                if(GetLocalInt(oPC, "MetabreathSpellId") == SPELL_HEIGHTEN_CONV) sQuickslotSelected = "HeightenBreath";
                else if(GetLocalInt(oPC, "MetabreathSpellId") == SPELL_CLINGING_CONV) sQuickslotSelected = "ClingingBreath";
                else if(GetLocalInt(oPC, "MetabreathSpellId") == SPELL_LINGERING_CONV) sQuickslotSelected = "LingeringBreath";
                
                sQuickslotSelected += "Slot1";
                
                int nValue = GetLocalInt(oPC, "MetabreathTempValue");

                // Depends on the values of the choice options being a continuous series
                if(nChoice >= CHOICE_RAISE_1 && nChoice <= CHOICE_LOWER_5)
                {
                    switch(nChoice)
                    {
                        case CHOICE_RAISE_1: nValue++; break;
                        case CHOICE_LOWER_1: nValue--; break;
                        case CHOICE_RAISE_2: nValue += 2; break;
                        case CHOICE_LOWER_2: nValue -= 2; break;
                        case CHOICE_RAISE_3: nValue += 3; break;
                        case CHOICE_LOWER_3: nValue -= 3; break;
                        case CHOICE_RAISE_4: nValue += 4; break;
                        case CHOICE_LOWER_4: nValue -= 4; break;
                        case CHOICE_RAISE_5: nValue += 5; break;
                        case CHOICE_LOWER_5: nValue -= 5; break;
                    }
                    
                    if(GetLocalInt(oPC, "MetabreathSpellId") == SPELL_HEIGHTEN_CONV 
                       && nValue > GetAbilityModifier(ABILITY_CONSTITUTION, oPC))
                       nValue = GetAbilityModifier(ABILITY_CONSTITUTION, oPC);
                       
                    if (nValue < 0) nValue = 0;

                    SetLocalInt(oPC, "MetabreathTempValue", nValue);
                    ClearCurrentStage(oPC);
                }
                else if(nChoice == CHOICE_CLEAR)
                {
                    nValue = 0;

                    ClearCurrentStage(oPC);
                }
                else if(nChoice == CHOICE_SAVE)
                {
                    SetPersistantLocalInt(oPC, sQuickslotSelected, nValue);
                    nStage = STAGE_ENTRY;
                }
            }
        }
        else if(nStage == STAGE_SLOT2)
        {
            if(nChoice == CHOICE_BACK_TO_MAIN) nStage = STAGE_ENTRY;
            else
            {
                string sQuickslotSelected;
                if(GetLocalInt(oPC, "MetabreathSpellId") == SPELL_HEIGHTEN_CONV) sQuickslotSelected = "HeightenBreath";
                else if(GetLocalInt(oPC, "MetabreathSpellId") == SPELL_CLINGING_CONV) sQuickslotSelected = "ClingingBreath";
                else if(GetLocalInt(oPC, "MetabreathSpellId") == SPELL_LINGERING_CONV) sQuickslotSelected = "LingeringBreath";
                
                sQuickslotSelected += "Slot2";
                
                int nValue = GetLocalInt(oPC, "MetabreathTempValue");

                // Depends on the values of the choice options being a continuous series
                if(nChoice >= CHOICE_RAISE_1 && nChoice <= CHOICE_LOWER_5)
                {
                    switch(nChoice)
                    {
                        case CHOICE_RAISE_1: nValue++; break;
                        case CHOICE_LOWER_1: nValue--; break;
                        case CHOICE_RAISE_2: nValue += 2; break;
                        case CHOICE_LOWER_2: nValue -= 2; break;
                        case CHOICE_RAISE_3: nValue += 3; break;
                        case CHOICE_LOWER_3: nValue -= 3; break;
                        case CHOICE_RAISE_4: nValue += 4; break;
                        case CHOICE_LOWER_4: nValue -= 4; break;
                        case CHOICE_RAISE_5: nValue += 5; break;
                        case CHOICE_LOWER_5: nValue -= 5; break;
                    }
                    
                    if(GetLocalInt(oPC, "MetabreathSpellId") == SPELL_HEIGHTEN_CONV 
                       && nValue > GetAbilityModifier(ABILITY_CONSTITUTION, oPC))
                       nValue = GetAbilityModifier(ABILITY_CONSTITUTION, oPC);
                       
                    if (nValue < 0) nValue = 0;

                    SetLocalInt(oPC, "MetabreathTempValue", nValue);
                    ClearCurrentStage(oPC);
                }
                else if(nChoice == CHOICE_CLEAR)
                {
                    nValue = 0;

                    ClearCurrentStage(oPC);
                }
                else if(nChoice == CHOICE_SAVE)
                {
                    SetPersistantLocalInt(oPC, sQuickslotSelected, nValue);
                    nStage = STAGE_ENTRY;
                }
            }
        }
        else if(nStage == STAGE_SLOT3)
        {
            if(nChoice == CHOICE_BACK_TO_MAIN) nStage = STAGE_ENTRY;
            else
            {
                string sQuickslotSelected;
                if(GetLocalInt(oPC, "MetabreathSpellId") == SPELL_CLINGING_CONV) sQuickslotSelected = "ClingingBreath";
                else if(GetLocalInt(oPC, "MetabreathSpellId") == SPELL_LINGERING_CONV) sQuickslotSelected = "LingeringBreath";
                
                sQuickslotSelected += "Slot3";
                
                int nValue = GetLocalInt(oPC, "MetabreathTempValue");

                // Depends on the values of the choice options being a continuous series
                if(nChoice >= CHOICE_RAISE_1 && nChoice <= CHOICE_LOWER_5)
                {
                    switch(nChoice)
                    {
                        case CHOICE_RAISE_1: nValue++; break;
                        case CHOICE_LOWER_1: nValue--; break;
                        case CHOICE_RAISE_2: nValue += 2; break;
                        case CHOICE_LOWER_2: nValue -= 2; break;
                        case CHOICE_RAISE_3: nValue += 3; break;
                        case CHOICE_LOWER_3: nValue -= 3; break;
                        case CHOICE_RAISE_4: nValue += 4; break;
                        case CHOICE_LOWER_4: nValue -= 4; break;
                        case CHOICE_RAISE_5: nValue += 5; break;
                        case CHOICE_LOWER_5: nValue -= 5; break;
                    }
                       
                    if (nValue < 0) nValue = 0;

                    SetLocalInt(oPC, "MetabreathTempValue", nValue);
                    ClearCurrentStage(oPC);
                }
                else if(nChoice == CHOICE_CLEAR)
                {
                    nValue = 0;

                    ClearCurrentStage(oPC);
                }
                else if(nChoice == CHOICE_SAVE)
                {
                    SetPersistantLocalInt(oPC, sQuickslotSelected, nValue);
                    nStage = STAGE_ENTRY;
                }
            }
        }

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
