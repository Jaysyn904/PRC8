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
		if(GetLocalInt(oPC, "PRC_Forsaker_Exit_Ran_VoP_Check")) return;  
		SetLocalInt(oPC, "PRC_Forsaker_Exit_Ran_VoP_Check", TRUE);  
		DelayCommand(3.0f, DeleteLocalInt(oPC, "PRC_Forsaker_Exit_Ran_VoP_Check"));  
	  
		if (GetHasFeat(FEAT_VOWOFPOVERTY, oPC))  
		{  
			int nLevel = GetHitDice(oPC) - GetPersistantLocalInt(oPC, "VoPLevel1") + 1;  
			int nLevelCheck;  
			for (nLevelCheck = 1; nLevelCheck <= nLevel; nLevelCheck++)  
			{  
				if (!GetPersistantLocalInt(oPC, "VoPBoost"+IntToString(nLevelCheck))  
					&& (nLevelCheck-(nLevelCheck/4)*4 == 3) && (nLevelCheck >= 7) && (nLevelCheck <= 27))  
				{  
					AssignCommand(oPC, ClearAllActions(TRUE));  
					SetPersistantLocalInt(oPC, "VoPBoostCheck", nLevelCheck);  
					DelayCommand(3.5f, StartDynamicConversation("ft_vowpoverty_ab", oPC, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oPC));  
					break;  
				}  
				if (!GetPersistantLocalInt(oPC, "VoPFeat"+IntToString(nLevelCheck)) && (nLevelCheck-(nLevelCheck/2)*2 == 0))  
				{  
					AssignCommand(oPC, ClearAllActions(TRUE));  
					SetPersistantLocalInt(oPC, "VoPFeatCheck", nLevelCheck);  
					DelayCommand(3.5f, StartDynamicConversation("ft_vowpoverty_ft", oPC, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oPC));  
					break;  
				}  
			}  
		}  
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
			  IntToString(nChoice) + "; choice text = '" + GetChoiceText(oPC) + "'");  
		if(nStage == STAGE_SELECT_ABIL)  
		{  
			if(DEBUG) DoDebug("prc_forsake_abil: nChoice: " + IntToString(nChoice));  
	  
			if (GetPRCSwitch("PRC_NWNXEE_ENABLED") && GetPRCSwitch("PRC_PRCX_ENABLED"))  
			{  
				// Apply intrinsic ability bonus via NWNxEE  
				PRC_Funcs_ModAbilityScore(oPC, nChoice, 1);  
			}  
			else  
			{  
				// Fallback to effect-based  
				effect eAbility = EffectAbilityIncrease(nChoice, 1);  
				eAbility = UnyieldingEffect(eAbility);  
				eAbility = TagEffect(eAbility, "ForsakerAbilityBoost");  
				ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAbility, oPC);  
			}  
	  
			SetPersistantLocalInt(oPC, "ForsakerBoost"+IntToString(nClass), nChoice+1);  
			DeletePersistantLocalInt(oPC,"ForsakerBoostCheck");  
			AllowExit(DYNCONV_EXIT_FORCE_EXIT);  
		}  
	  
		if(DEBUG) DoDebug("prc_forsake_abil: New stage: " + IntToString(nStage));  
	  
		// Store the stage value. If it has been changed, this clears out the choices  
		SetStage(nStage, oPC);  
	}	
/*     // Handle PC response
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
    } */
}
