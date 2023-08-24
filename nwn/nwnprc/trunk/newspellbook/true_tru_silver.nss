//:://////////////////////////////////////////////
//:: Truenamer Amulet of the Silver Tongue script
//:: true_tru_silver
//:://////////////////////////////////////////////
/*
    @author Stratovarius - 2019.12.21
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_persist_loca"
#include "inc_dynconv"

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_SELECT_LEVEL        = 0;

const int STRREF_YES                = 4752;     // "Yes"
const int STRREF_NO                 = 4753;     // "No"

void main()
{
    object oPC = GetPCSpeaker();
    int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);
    int nStage = GetStage(oPC);

    string sPowerFile = "cls_spell_sorc"; 

    // Check which of the conversation scripts called the scripts
    if(nValue == 0) // All of them set the DynConv_Var to non-zero value, so something is wrong -> abort
        return;

    if(nValue == DYNCONV_SETUP_STAGE)
    {
        if(DEBUG) DoDebug("true_tru_silver: Running setup stage for stage " + IntToString(nStage));
        // Check if this stage is marked as already set up
        // This stops list duplication when scrolling
        if(!GetIsStageSetUp(nStage, oPC))
        {
            if(DEBUG) DoDebug("true_tru_silver: Stage was not set up already");
            // Level selection stage
            if(nStage == STAGE_SELECT_LEVEL)
            {
                if(DEBUG) DoDebug("true_tru_silver: Purchase choice selection");
                if (GetGold(oPC) >= 10000) SetHeader("Do you wish to purchase an Amulet of the Silver Tongue (Greater) [+10 Truespeak] for 10,000 gold? This is a one-time offer!");
                else SetHeader("Do you wish to purchase an Amulet of the Silver Tongue [+5 Truespeak] for 2,500 gold? This is a one-time offer!");
                	
                AddChoice("Yes", TRUE);
                AddChoice("No", FALSE);
            }
        }

        // Do token setup
        SetupTokens();
    }
    else if(nValue == DYNCONV_EXITED)
    {
        if(DEBUG) DoDebug("true_tru_silver: Running exit handler");
    }
    else if(nValue == DYNCONV_ABORTED)
    {
        // This section should never be run, since aborting this conversation should
        // always be forbidden and as such, any attempts to abort the conversation
        // should be handled transparently by the system
    }
    // Handle PC response
    else
    {
        int nChoice = GetChoice(oPC);
        if(DEBUG) DoDebug("true_tru_silver: Handling PC response, stage = " + IntToString(nStage) + "; nChoice = " + IntToString(nChoice) + "; choice text = '" + GetChoiceText(oPC) +  "'");
        if(nStage == STAGE_SELECT_LEVEL)
        {
           	if(DEBUG) DoDebug("true_tru_silver: Choice selected");
            if (GetGold(oPC) >= 10000) 
            {
            	SetPersistantLocalInt(oPC, "SilverTongueGreater", TRUE);
            	SetPersistantLocalInt(oPC, "SilverTongueLesser", TRUE);
            }	
            else 
            	SetPersistantLocalInt(oPC, "SilverTongueLesser", TRUE); 
            
            if (nChoice)
            {
            	if (GetGold(oPC) >= 10000)
            	{
            		TakeGoldFromCreature(10000, oPC, TRUE);
            		CreateItemOnObject("prc_true_svrtngg", oPC);
            	}
            	else 
            	{
            		TakeGoldFromCreature(2500, oPC, TRUE);
            		CreateItemOnObject("prc_true_svrtng", oPC);
            	}
            }

           	MarkStageNotSetUp(STAGE_SELECT_LEVEL, oPC);
			AllowExit(DYNCONV_EXIT_FORCE_EXIT);
        }

        if(DEBUG) DoDebug("true_tru_silver: New stage: " + IntToString(nStage));

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
