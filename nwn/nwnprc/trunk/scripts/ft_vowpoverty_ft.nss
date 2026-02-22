//:://////////////////////////////////////////////
//:: Vow of Poverty Extra Feat
//:: ft_vowpoverty_ft
//:://////////////////////////////////////////////
/** @file
    This allows you to choose the extra feat each even level.

    @original author Fencas
    @date   Created  - 2025-01-12
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_dynconv"
#include "prc_inc_function"
#include "NW_I0_GENERIC"
#include "inc_persist_loca"

//////////////////////////////////////////////////  
/* Constant definitions                          */  
//////////////////////////////////////////////////  
  
const int STAGE_SELECT_ABIL        = 0;  
const int STAGE_CONFIRM_SELECTION  = 1;  
  
const int STRREF_SELECTED_HEADER2   = 16824210; // "Is this correct?"  
const int STRREF_YES                = 4752;     // "Yes"  
const int STRREF_NO                 = 4753;     // "No" 
  
//////////////////////////////////////////////////  
/* Function definitions                          */  
//////////////////////////////////////////////////  


  
void main()  
{  
    object oPC = GetPCSpeaker();  
    object oSkin = GetPCSkin(oPC);  
    int i, j, nTest, nRow;  
    int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);  
    int nStage = GetStage(oPC);  
    int nLevel = GetPersistantLocalInt(oPC, "VoPFeatCheck");  
  
    // Check which of the conversation scripts called the scripts  
    if(nValue == 0) // All of them set the DynConv_Var to non-zero value, so something is wrong -> abort  
    {  
        if(DEBUG) DoDebug("ft_vowpoverty_ft: Aborting due to error.");  
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
                //Check which Feats have been added by this ability  
                int nTotalRows = Get2DARowCount("prc_vop_feats");  
                effect eCheckEffect = GetFirstEffect(oPC);  
                while (GetIsEffectValid(eCheckEffect))  
                {  
                    for(nRow=0; nRow <= nTotalRows; nRow++)  
                    {  
                        string nFeat = Get2DAString("prc_vop_feats","FeatIndex",nRow);  
                        if(GetEffectTag(eCheckEffect) == "VoPFeat"+nFeat)   SetLocalInt(oPC,"VoPFeat"+nFeat,1);  
                    }  
                    eCheckEffect = GetNextEffect(oPC);  
                }  
  
                SetHeader("Choose an Exalted Feat for this new level under a Vow of Poverty:");  
                //Add new option depending if it was not selected and char has all prereqs  
                for(nRow=0; nRow <= nTotalRows; nRow++)  
                {  
                    //Get prereqs from 2DA  
                    string  sName     = Get2DAString("prc_vop_feats","Name",nRow);  
                    int     nFeat     = StringToInt(Get2DAString("prc_vop_feats","FeatIndex",nRow));  
                    int     nPreReq1  = StringToInt(Get2DAString("prc_vop_feats","PreReq1",nRow));  
                    int     nPreReq2  = StringToInt(Get2DAString("prc_vop_feats","PreReq2",nRow));  
                    int     nCon      = StringToInt(Get2DAString("prc_vop_feats","Con",nRow));  
                    int     nWis      = StringToInt(Get2DAString("prc_vop_feats","Wis",nRow));  
                    int     nCha      = StringToInt(Get2DAString("prc_vop_feats","Cha",nRow));  
                    int     nBAB      = StringToInt(Get2DAString("prc_vop_feats","BAB",nRow));  
                    int     nLaw      = StringToInt(Get2DAString("prc_vop_feats","Law",nRow));  
  
                    int nAllPreReq = 1;  
  
                    //Check if prereqs exist and, if so, if they are met - if not, set bol to 0  
                    if(nPreReq1>0 && !GetHasFeat(nPreReq1, oPC))                        nAllPreReq = 0;  
                    if(nPreReq1==213 && GetLevelByClass(CLASS_TYPE_MONK, oPC) >= 1)    nAllPreReq = 1; //for Ki Strike and monks  
                    if(nPreReq2>0 && !GetHasFeat(nPreReq2, oPC))                        nAllPreReq = 0;  
                    if(nCon>0 && GetAbilityScore(oPC,ABILITY_CONSTITUTION, TRUE) < nCon) nAllPreReq = 0;  
                    if(nWis>0 && GetAbilityScore(oPC,ABILITY_WISDOM, TRUE) < nWis)       nAllPreReq = 0;  
                    if(nCha>0 && GetAbilityScore(oPC,ABILITY_CHARISMA, TRUE) < nCha)     nAllPreReq = 0;  
                    if(nBAB>0 && GetBaseAttackBonus(oPC) < nBAB)                        nAllPreReq = 0;  
                    if(nLaw>0 && !(GetAlignmentLawChaos(oPC) == ALIGNMENT_LAWFUL))       nAllPreReq = 0;  
  
                    if (!GetHasFeat(nFeat, oPC) && !GetLocalInt(oPC, "VoPFeat"+IntToString(nFeat)) && nAllPreReq == 1)  
                    {  
                        // Enforce mutual exclusivity: Favored of the Companions vs Servant of the Heavens  
                        if ((nFeat == FEAT_FAV_COMPANIONS && GetHasFeat(FEAT_SERVHEAVEN, oPC)) ||  
                            (nFeat == FEAT_SERVHEAVEN    && GetHasFeat(FEAT_FAV_COMPANIONS, oPC)))  
                        {  
                            // Skip adding this choice; the mutually exclusive feat is already possessed  
                            continue;  
                        }  
                        AddChoice(sName, nFeat, oPC);  
                    }  
                }  
  
                AddChoice("Cancel (you will get no Exalted Feats this level)", 0, oPC);  
                SetDefaultTokens(); //If there are more than 10 options, add Next  
                MarkStageSetUp(STAGE_SELECT_ABIL, oPC);  
            }  
            else if(nStage == STAGE_CONFIRM_SELECTION)  
            {  
                int nFeat = GetLocalInt(oPC, "VoP_SelectedFeat");  
                string sText = GetStringByStrRef(StringToInt(Get2DAString("feat", "FEAT", nFeat))) + "\n\n";  
                sText += GetStringByStrRef(StringToInt(Get2DAString("feat", "DESCRIPTION", nFeat))) + "\n\n";  
                sText += GetStringByStrRef(STRREF_SELECTED_HEADER2); // "Is this correct?"  
                SetHeader(sText);  
                AddChoice(GetStringByStrRef(STRREF_YES), TRUE, oPC);  
                AddChoice(GetStringByStrRef(STRREF_NO), FALSE, oPC);  
                MarkStageSetUp(STAGE_CONFIRM_SELECTION, oPC);  
            }  
        }  
  
        // Do token setup  
        SetupTokens();  
    } 
	else if(nValue == DYNCONV_EXITED)  
	{  
		if(DEBUG) DoDebug("ft_vowpoverty_ab/ft: Running exit handler");  
		if(GetLocalInt(oPC, "PRC_VoP_Exit_Ran_Forsaker_Check")) return;  
		SetLocalInt(oPC, "PRC_VoP_Exit_Ran_Forsaker_Check", TRUE);  
		DelayCommand(3.0f, DeleteLocalInt(oPC, "PRC_VoP_Exit_Ran_Forsaker_Check"));  
	  
		if (GetLevelByClass(CLASS_TYPE_FORSAKER, oPC) > 0)  
		{  
			int nForsakerLvl = GetLevelByClass(CLASS_TYPE_FORSAKER, oPC);  
			int nLvlCheck;  
			for (nLvlCheck = 1; nLvlCheck <= nForsakerLvl; nLvlCheck++)  
			{  
				if (!GetPersistantLocalInt(oPC, "ForsakerBoost"+IntToString(nLvlCheck)))  
				{  
					AssignCommand(oPC, ClearAllActions(TRUE));  
					SetPersistantLocalInt(oPC, "ForsakerBoostCheck", nLvlCheck);  
					DelayCommand(3.5f, StartDynamicConversation("prc_forsake_abil", oPC, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oPC));  
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
        if(DEBUG) DoDebug("ft_vowpoverty_ft: ERROR: Conversation abort section run");  
        DeleteLocalInt(oPC, "VoP_SelectedFeat");  
    }  
    // Handle PC response  
    else  
    {  
        int nChoice = GetChoice(oPC);  
		
        // Favored of the Companions vs Servant of the Heavens: Choose one  
        if ((nChoice == FEAT_FAV_COMPANIONS && GetHasFeat(FEAT_SERVHEAVEN, oPC)) ||  
            (nChoice == FEAT_SERVHEAVEN    && GetHasFeat(FEAT_FAV_COMPANIONS, oPC)))  
        {  
            FloatingTextStringOnCreature("You cannot select both Favored of the Companions and Servant of the Heavens.", oPC, FALSE);  
            AllowExit(DYNCONV_EXIT_FORCE_EXIT);  
            return;  
        }  
		
        if(nStage == STAGE_SELECT_ABIL)  
        {  
            if (nChoice == 0)  
            {  
                // Cancel chosen  
                DeletePersistantLocalInt(oPC,"VoPFeatCheck");  
                AllowExit(DYNCONV_EXIT_FORCE_EXIT);  
                return;  
            }  
            SetLocalInt(oPC, "VoP_SelectedFeat", nChoice);  
            nStage = STAGE_CONFIRM_SELECTION;  
            MarkStageNotSetUp(STAGE_SELECT_ABIL, oPC);  
        }  
		else if(nStage == STAGE_CONFIRM_SELECTION)  
		{  
			if (nChoice == TRUE) // Yes  
			{  
				int nFeat = GetLocalInt(oPC, "VoP_SelectedFeat");  
				SetPersistantLocalInt(oPC, "VoPFeat"+IntToString(nLevel), 1);  
				SetPersistantLocalInt(oPC, "VoPFeatID" + IntToString(nFeat), 1);  
		  
				if (GetPRCSwitch("PRC_NWNXEE_ENABLED") && GetPRCSwitch("PRC_PRCX_ENABLED"))  
				{  
					PRC_Funcs_AddFeat(oPC, nFeat);  
				}  
				else  
				{  
					effect eBonusFeat = EffectBonusFeat(nFeat);  
					eBonusFeat = UnyieldingEffect(eBonusFeat);  
					eBonusFeat = TagEffect(eBonusFeat, "VoPFeat"+IntToString(nFeat));  
					ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBonusFeat, oPC);  
				}  
		  
				DeleteLocalInt(oPC, "VoP_SelectedFeat");  
				DeletePersistantLocalInt(oPC,"VoPFeatCheck");  
				AllowExit(DYNCONV_EXIT_FORCE_EXIT);  
			}  
			else // No  
			{  
				nStage = STAGE_SELECT_ABIL;  
				MarkStageNotSetUp(STAGE_CONFIRM_SELECTION, oPC);  
			}  
		}
  
        if(DEBUG) DoDebug("ft_vowpoverty_ft: New stage: " + IntToString(nStage));  
  
        // Store the stage value. If it has been changed, this clears out the choices  
        SetStage(nStage, oPC);  
    }  
}



/* void main()
{
    object oPC = GetPCSpeaker();
	object oSkin = GetPCSkin(oPC);
    int i, j, nTest, nRow;
	int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);
    int nStage = GetStage(oPC);
	int nLevel = GetPersistantLocalInt(oPC, "VoPFeatCheck");

    // Check which of the conversation scripts called the scripts
    if(nValue == 0) // All of them set the DynConv_Var to non-zero value, so something is wrong -> abort
    {
    	if(DEBUG) DoDebug("ft_vowpoverty_ft: Aborting due to error.");
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
				//Check which Feats have been added by this ability
				int nTotalRows = Get2DARowCount("prc_vop_feats");
				effect eCheckEffect = GetFirstEffect(oPC);
				while (GetIsEffectValid(eCheckEffect))
				{
					for(nRow=0; nRow <= nTotalRows; nRow++)
					{
						string nFeat = Get2DAString("prc_vop_feats","FeatIndex",nRow);
						if(GetEffectTag(eCheckEffect) == "VoPFeat"+nFeat)   SetLocalInt(oPC,"VoPFeat"+nFeat,1);
					}
					eCheckEffect = GetNextEffect(oPC);
				}
				
                SetHeader("Choose an Exalted Feat for this new level under a Vow of Poverty:");
				//Add new option depending if it was not selected and char has all prereqs
				for(nRow=0; nRow <= nTotalRows; nRow++)
				{
					//Get prereqs from 2DA
					string  sName     = 			Get2DAString("prc_vop_feats","Name",nRow);
					int     nFeat     = StringToInt(Get2DAString("prc_vop_feats","FeatIndex",nRow));
					int     nPreReq1  = StringToInt(Get2DAString("prc_vop_feats","PreReq1",nRow));
					int     nPreReq2  = StringToInt(Get2DAString("prc_vop_feats","PreReq2",nRow));
					int     nCon 	  = StringToInt(Get2DAString("prc_vop_feats","Con",nRow));
					int     nWis 	  = StringToInt(Get2DAString("prc_vop_feats","Wis",nRow));
					int     nCha 	  = StringToInt(Get2DAString("prc_vop_feats","Cha",nRow));
					int     nBAB 	  = StringToInt(Get2DAString("prc_vop_feats","BAB",nRow));
					int     nLaw      = StringToInt(Get2DAString("prc_vop_feats","Law",nRow));
					
					int nAllPreReq = 1;
					
					//Check if prereqs exist and, if so, if they are met - if not, set bol to 0
					if(nPreReq1>0 && !GetHasFeat(nPreReq1, oPC))						nAllPreReq = 0;
					if(nPreReq1==213 && GetLevelByClass(CLASS_TYPE_MONK, oPC) >= 1)		nAllPreReq = 1; //for Ki Strike and monks 
					if(nPreReq2>0 && !GetHasFeat(nPreReq2, oPC)) 						nAllPreReq = 0;
					if(nCon>0 && GetAbilityScore(oPC,ABILITY_CONSTITUTION, TRUE) < nCon)		nAllPreReq = 0;
					if(nWis>0 && GetAbilityScore(oPC,ABILITY_WISDOM, TRUE) < nWis)			nAllPreReq = 0;
					if(nCha>0 && GetAbilityScore(oPC,ABILITY_CHARISMA, TRUE) < nCha)			nAllPreReq = 0;
					if(nBAB>0 && GetBaseAttackBonus(oPC) < nBAB)						nAllPreReq = 0;
					if(nLaw>0 && !(GetAlignmentLawChaos(oPC) == ALIGNMENT_LAWFUL))		nAllPreReq = 0;
					
					if (!GetHasFeat(nFeat, oPC) && !GetLocalInt(oPC, "VoPFeat"+IntToString(nFeat)) && nAllPreReq == 1)	AddChoice(sName, nFeat, oPC);
				}
				
				AddChoice("Cancel (you will get no Exalted Feats this level)", 0, oPC);
				SetDefaultTokens(); //If there are more than 10 options, add Next
                MarkStageSetUp(STAGE_SELECT_ABIL, oPC);
            }
        }

        // Do token setup
        SetupTokens();
    }
    else if(nValue == DYNCONV_EXITED)
    {
        if(DEBUG) DoDebug("ft_vowpoverty_ft: Running exit handler");        
    }
    else if(nValue == DYNCONV_ABORTED)
    {
        // This section should never be run, since aborting this conversation should
        // always be forbidden and as such, any attempts to abort the conversation
        // should be handled transparently by the system
        if(DEBUG) DoDebug("ft_vowpoverty_ft: ERROR: Conversation abort section run");
    }
    // Handle PC response
    else
    {
        int nChoice = GetChoice(oPC);
	    if(nStage == STAGE_SELECT_ABIL)
        {
			SetPersistantLocalInt(oPC, "VoPFeat"+IntToString(nLevel),1); //Register the choice was made
			
			// Store the feat ID for recalling onClientEnter
			SetPersistantLocalInt(oPC, "VoPFeatID" + IntToString(nChoice), 1);			
			
			//If it was not cancelled, give chosen feat to PC (as EffectBonusFeat)
			if(nChoice > 0) 
			{
				effect eBonusFeat = EffectBonusFeat(nChoice);
					   eBonusFeat = UnyieldingEffect(eBonusFeat);
					   eBonusFeat = TagEffect(eBonusFeat, "VoPFeat"+IntToString(nChoice));
				ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBonusFeat, oPC);
			}

			// And we're all done
			DeletePersistantLocalInt(oPC,"VoPFeatCheck");
			AllowExit(DYNCONV_EXIT_FORCE_EXIT); 
        }

        if(DEBUG) DoDebug("ft_vowpoverty_ft: New stage: " + IntToString(nStage));

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
} */

