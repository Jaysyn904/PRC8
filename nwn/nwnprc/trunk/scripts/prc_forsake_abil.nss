//:://////////////////////////////////////////////
//:: Forsaker Ability Boost Conversation
//:: prc_forsake_abil
//:://////////////////////////////////////////////
/** @file
    This allows you to choose ability to boost.

    @author    Stratovarius
    @date      Created  - 27.12.2019
	@edited by Stratovarius
    @date      24.12.2024
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_dynconv"
#include "prc_inc_function"

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_SELECT_ABIL        = 0;

//////////////////////////////////////////////////
/* Function defintions                          */
//////////////////////////////////////////////////

void main()
{
    object oPC = GetPCSpeaker();
    int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);
    int nStage = GetStage(oPC);
	int nClass = GetPersistantLocalInt(oPC, "ForsakerBoostCheck");

    // Check which of the conversation scripts called the scripts
    if(nValue == 0) // All of them set the DynConv_Var to non-zero value, so something is wrong -> abort
    {
    	if(DEBUG) DoDebug("prc_forsake_abil: Aborting due to error.");
        return;
    }

    if(nValue == DYNCONV_SETUP_STAGE)
    {
        if(DEBUG) DoDebug("prc_forsake_abil: Running setup stage for stage " + IntToString(nStage));
        // Check if this stage is marked as already set up
        // This stops list duplication when scrolling
        if(!GetIsStageSetUp(nStage, oPC))
        {
            if(DEBUG) DoDebug("prc_forsake_abil: Stage was not set up already. nStage: " + IntToString(nStage));
            // Maneuver selection stage
            if(nStage == STAGE_SELECT_ABIL)
            {
                if(DEBUG) DoDebug("prc_forsake_abil: Building maneuver selection");
                SetHeader("Choose which ability to boost for Forsaker level " + IntToString(nClass) + ":");
                AddChoice("Strength", ABILITY_STRENGTH, oPC);
                AddChoice("Dexterity", ABILITY_DEXTERITY, oPC);
                AddChoice("Constitution", ABILITY_CONSTITUTION, oPC);
                AddChoice("Intelligence", ABILITY_INTELLIGENCE, oPC);
                AddChoice("Wisdom", ABILITY_WISDOM, oPC);
                AddChoice("Charisma", ABILITY_CHARISMA, oPC);

                MarkStageSetUp(STAGE_SELECT_ABIL, oPC);
            }
        }

        // Do token setup
        SetupTokens();
    }
    else if(nValue == DYNCONV_EXITED)
    {
        if(DEBUG) DoDebug("prc_forsake_abil: Running exit handler");        
    }
    else if(nValue == DYNCONV_ABORTED)
    {
        // This section should never be run, since aborting this conversation should
        // always be forbidden and as such, any attempts to abort the conversation
        // should be handled transparently by the system
        if(DEBUG) DoDebug("prc_forsake_abil: ERROR: Conversation abort section run");
    }
    // Handle PC response
    else
    {
        int nChoice = GetChoice(oPC);
        if(DEBUG) DoDebug("prc_forsake_abil: Handling PC response, stage = " + IntToString(nStage) + "; nChoice = " + 
		  IntToString(nChoice) + "; choice text = '" + GetChoiceText(oPC) +  "'");
	    if(nStage == STAGE_SELECT_ABIL)
        {
                if(DEBUG) DoDebug("prc_forsake_abil: nChoice: " + IntToString(nChoice));  
                
				ApplyEffectToObject(DURATION_TYPE_PERMANENT,UnyieldingEffect(EffectAbilityIncrease(nChoice,1)),oPC); //Give the boost
                SetPersistantLocalInt(oPC, "ForsakerBoost"+IntToString(nClass), nChoice+1); //Register the boost has been given
				DeletePersistantLocalInt(oPC,"ForsakerBoostCheck");
				
                // And we're all done
                AllowExit(DYNCONV_EXIT_FORCE_EXIT); 
        }

        if(DEBUG) DoDebug("prc_forsake_abil: New stage: " + IntToString(nStage));

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
