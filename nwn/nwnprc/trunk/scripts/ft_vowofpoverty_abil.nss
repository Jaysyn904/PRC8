//:://////////////////////////////////////////////
//:: Vow of Poverty Ability Boost Conversation
//:: ft_vowofpoverty_abil
//:://////////////////////////////////////////////
/** @file
    This allows you to choose ability to boost.

    @original author Stratovarius
    @date   Created  - 27.12.2019
	@modified by Fencas
	@data modified - 2024-12-03
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_dynconv"
#include "prc_inc_function"
#include "NW_I0_GENERIC"

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
	int nLevel = GetPersistantLocalInt(oPC, "VoPBoostCheck");
	int i, j, nStr, nDex, nCon, nInt, nWis, nCha, nTest;

    // Check which of the conversation scripts called the scripts
    if(nValue == 0) // All of them set the DynConv_Var to non-zero value, so something is wrong -> abort
    {
    	if(DEBUG) DoDebug("ft_vowofpoverty_abil: Aborting due to error.");
        return;
    }

    if(nValue == DYNCONV_SETUP_STAGE)
    {
        // Check if this stage is marked as already set up
        // This stops list duplication when scrolling
        if(!GetIsStageSetUp(nStage, oPC))
        {
            // Maneuver selection stage
            if(nStage == STAGE_SELECT_ABIL)
            {
				for(i = 0; i <= nLevel; i++)
				{
					if(GetPersistantLocalInt(oPC, "VoPBoost"+IntToString(i))>=10) 
					{
						nTest = GetPersistantLocalInt(oPC, "VoPBoost"+IntToString(i))-10;
						if (nTest == ABILITY_STRENGTH) nStr++;
						if (nTest == ABILITY_DEXTERITY) nDex++;
						if (nTest == ABILITY_CONSTITUTION) nCon++;
						if (nTest == ABILITY_INTELLIGENCE) nInt++;
						if (nTest == ABILITY_WISDOM) nWis++;
						if (nTest == ABILITY_CHARISMA) nCha++;
					}
				} 
                SetHeader("Choose which ability to boost for this new level under a Vow of Poverty:");
				//If an ability has already been chosen, do not add it (avoid duplication)
                if (nStr == 0) AddChoice("Strength", ABILITY_STRENGTH, oPC);
                if (nDex == 0) AddChoice("Dexterity", ABILITY_DEXTERITY, oPC);
                if (nCon == 0) AddChoice("Constitution", ABILITY_CONSTITUTION, oPC);
                if (nInt == 0) AddChoice("Intelligence", ABILITY_INTELLIGENCE, oPC);
                if (nWis == 0) AddChoice("Wisdom", ABILITY_WISDOM, oPC);
                if (nCha == 0) AddChoice("Charisma", ABILITY_CHARISMA, oPC);

                MarkStageSetUp(STAGE_SELECT_ABIL, oPC);
            }
        }

        // Do token setup
        SetupTokens();
    }
    else if(nValue == DYNCONV_EXITED)
    {
        if(DEBUG) DoDebug("ft_vowofpoverty_abil: Running exit handler");        
    }
    else if(nValue == DYNCONV_ABORTED)
    {
        // This section should never be run, since aborting this conversation should
        // always be forbidden and as such, any attempts to abort the conversation
        // should be handled transparently by the system
        if(DEBUG) DoDebug("ft_vowofpoverty_abil: ERROR: Conversation abort section run");
    }
    // Handle PC response
    else
    {
        int nChoice = GetChoice(oPC);
	    if(nStage == STAGE_SELECT_ABIL)
        {
                ApplyEffectToObject(DURATION_TYPE_PERMANENT,UnyieldingEffect(EffectAbilityIncrease(nChoice,2)),oPC); //Give the boost for the chosen option
				SetPersistantLocalInt(oPC, "VoPBoost"+IntToString(GetCharacterLevel(oPC)),(nChoice+10)); //Register the boost has been given
				
				//Give the boost for the ones chosen before
                for(i = 0; i < nLevel; i++)
				{
					if(GetPersistantLocalInt(oPC, "VoPBoost"+IntToString(i))>=10)
					{
						nTest = GetPersistantLocalInt(oPC, "VoPBoost"+IntToString(i))-10;
						for(j = 0; j <= 5; j++)
						{
							if(j == nTest) ApplyEffectToObject(DURATION_TYPE_PERMANENT,UnyieldingEffect(EffectAbilityIncrease(j,2)),oPC);
						}
					}
				} 
				DeletePersistantLocalInt(oPC,"VoPBoostCheck");
              
                // And we're all done
                AllowExit(DYNCONV_EXIT_FORCE_EXIT); 
        }

        if(DEBUG) DoDebug("ft_vowofpoverty_abil: New stage: " + IntToString(nStage));

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
