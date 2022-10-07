//:://////////////////////////////////////////////
//:: Anima Mage Vestige Metamagic Conversation
//:: bnd_anim_metacnv
//:://////////////////////////////////////////////
/** @file
    This allows you to choose which vestige to forgo


    @author Stratovarius
    @date   Created  - 04.03.2021
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_dynconv"
#include "bnd_inc_bndfunc"

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_SELECT_VESTIGE        = 0;
const int STAGE_SELECT_METAMAGIC      = 1;

const int CHOICE_BACK_TO_LSELECT    = -1;

const int STRREF_BACK_TO_LSELECT    = 16829723; // "Return to maneuver level selection."
const int STRREF_LEVELLIST_HEADER   = 16829724; // "Select level of maneuver to gain.\n\nNOTE:\nThis may take a while when first browsing a particular level's maneuvers."
const int STRREF_MOVELIST_HEADER1   = 16829725; // "Select a maneuver to gain.\nYou can select"
const int STRREF_MOVELIST_HEADER2   = 16829726; // "more maneuvers"
const int STRREF_SELECTED_HEADER1   = 16824209; // "You have selected:"
const int STRREF_SELECTED_HEADER2   = 16824210; // "Is this correct?"
const int STRREF_END_HEADER         = 16829727; // "You will be able to select more maneuvers after you gain another level in a blade magic initiator class."
const int STRREF_END_CONVO_SELECT   = 16824212; // "Finish"
const int LEVEL_STRREF_START        = 16824809;
const int STRREF_YES                = 4752;     // "Yes"
const int STRREF_NO                 = 4753;     // "No"
const int STRREF_MOVESTANCE_HEADER  = 16829729; // "Choose Maneuver or Stances."
const int STRREF_STANCE             = 16829730; // "Stances"
const int STRREF_MANEUVER           = 16829731; // "Maneuvers"


//////////////////////////////////////////////////
/* Aid Functions                                */
//////////////////////////////////////////////////

int _GetLoopEnd(int nClass)
{
	if (nClass == CLASS_TYPE_SWORDSAGE) return 141;
	
	return -1;
}

void ReapplyVestige(object oBinder, int nVestige)
{
	if (!GetLocalInt(oBinder, "BinderRested")) ActionCastSpellOnSelf(nVestige);
}

//////////////////////////////////////////////////
/* Function defintions                          */
//////////////////////////////////////////////////

void main()
{
    object oBinder = GetPCSpeaker();
    int nValue = GetLocalInt(oBinder, DYNCONV_VARIABLE);
    int nStage = GetStage(oBinder);

    // Check which of the conversation scripts called the scripts
    if(nValue == 0) // All of them set the DynConv_Var to non-zero value, so something is wrong -> abort
    {
    	if(DEBUG) DoDebug("bnd_anim_metacnv: Aborting due to error.");
        return;
    }

    if(nValue == DYNCONV_SETUP_STAGE)
    {
        if(DEBUG) DoDebug("bnd_anim_metacnv: Running setup stage for stage " + IntToString(nStage));
        // Check if this stage is marked as already set up
        // This stops list duplication when scrolling
        if(!GetIsStageSetUp(nStage, oBinder))
        {
            if(DEBUG) DoDebug("bnd_anim_metacnv: Stage was not set up already. nStage: " + IntToString(nStage));
            // Maneuver selection stage
            if(nStage == STAGE_SELECT_VESTIGE)
            {
                if(DEBUG) DoDebug("bnd_anim_metacnv: Building vestige selection");
                string sToken = "Select a vestige to suspend.";
                SetHeader(sToken);
                
    			int i, nCount;
    			for(i = VESTIGE_AMON; i <= VESTIGE_ABYSM; i++)
    			{
    				if(GetHasSpellEffect(i, oBinder))
    					AddChoice(GetStringByStrRef(StringToInt(Get2DACache("Spells", "Name", i))), i, oBinder);
    			}		

                MarkStageSetUp(STAGE_SELECT_VESTIGE, oBinder);
            }
            else if(nStage == STAGE_SELECT_METAMAGIC)
            {
                if(DEBUG) DoDebug("bnd_anim_metacnv: Building vestige selection");
                string sToken = "Select a metamagic to gain. You will have one round to cast a spell.";
                SetHeader(sToken);
                
				if (GetHasFeat(FEAT_EMPOWER_SPELL, oBinder))  AddChoice("Empower",  1, oBinder);	
				if (GetHasFeat(FEAT_EXTEND_SPELL, oBinder))   AddChoice("Extend",   2, oBinder);	
				if (GetHasFeat(FEAT_MAXIMIZE_SPELL, oBinder)) AddChoice("Maximize", 3, oBinder);	
				if (GetHasFeat(FEAT_QUICKEN_SPELL, oBinder))  AddChoice("Quicken",  4, oBinder);	
				if (GetHasFeat(FEAT_SILENCE_SPELL, oBinder))  AddChoice("Silent",   5, oBinder);	
				if (GetHasFeat(FEAT_STILL_SPELL, oBinder))    AddChoice("Still",    6, oBinder);	

                MarkStageSetUp(STAGE_SELECT_VESTIGE, oBinder);
            }            
        }

        // Do token setup
        SetupTokens();
    }
    else if(nValue == DYNCONV_EXITED)
    {
        if(DEBUG) DoDebug("bnd_anim_metacnv: Running exit handler");
        // End of conversation cleanup
        DeleteLocalInt(oBinder, "nVestige");
    }
    else if(nValue == DYNCONV_ABORTED)
    {
        // This section should never be run, since aborting this conversation should
        // always be forbidden and as such, any attempts to abort the conversation
        // should be handled transparently by the system
        if(DEBUG) DoDebug("bnd_anim_metacnv: ERROR: Conversation abort section run");
    }
    // Handle PC response
    else
    {
        int nChoice = GetChoice(oBinder);
        if(DEBUG) DoDebug("bnd_anim_metacnv: Handling PC response, stage = " + IntToString(nStage) + "; nChoice = " + IntToString(nChoice) + "; choice text = '" + GetChoiceText(oBinder) +  "'");
        if(nStage == STAGE_SELECT_VESTIGE)
        {
           	if(DEBUG) DoDebug("bnd_anim_metacnv: Vestige selected");
           	SetLocalInt(oBinder, "nVestige", nChoice);
			nStage = STAGE_SELECT_METAMAGIC;          	
		}	
        else if(nStage == STAGE_SELECT_METAMAGIC)
        {
           	if(DEBUG) DoDebug("bnd_anim_metacnv: Metamagic selected");
           	int nVestige = GetLocalInt(oBinder, "nVestige");
           	object oSkin = GetPCSkin(oBinder);
           	// Remove the vestige for 5 rounds
			PRCRemoveSpellEffects(nVestige, oBinder, oBinder);
			GZPRCRemoveSpellEffects(nVestige, oBinder, FALSE);
			DelayCommand(RoundsToSeconds(5), ReapplyVestige(oBinder, nVestige));
           	
           	if (nChoice == 1) 
           	{
    			int nMeta = GetLocalInt(oBinder, "SuddenMeta");
    		    nMeta |= METAMAGIC_EMPOWER;
    			SetLocalInt(oBinder, "SuddenMeta", nMeta);           	
           	}
           	if (nChoice == 2) 
           	{
    			int nMeta = GetLocalInt(oBinder, "SuddenMeta");
    		    nMeta |= METAMAGIC_EXTEND;
    			SetLocalInt(oBinder, "SuddenMeta", nMeta);           	
           	}
           	if (nChoice == 3) 
           	{
    			int nMeta = GetLocalInt(oBinder, "SuddenMeta");
    		    nMeta |= METAMAGIC_MAXIMIZE;
    			SetLocalInt(oBinder, "SuddenMeta", nMeta);           	
           	}     
           	if (nChoice == 4) 
           	{
				IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_AUTO_QUICKEN_I), 6.0);
				IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_AUTO_QUICKEN_II), 6.0);
				IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_AUTO_QUICKEN_III), 6.0);          	
           	}
           	if (nChoice == 5) 
           	{
				IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_AUTO_SILENT_I), 6.0);
				IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_AUTO_SILENT_II), 6.0);
				IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_AUTO_SILENT_III), 6.0);         	
           	}
           	if (nChoice == 6) 
           	{
				IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_AUTO_STILL_I), 6.0);
				IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_AUTO_STILL_II), 6.0);
				IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_AUTO_STILL_III), 6.0);          	
           	}           	
           	
			AllowExit(DYNCONV_EXIT_FORCE_EXIT);          	
		}           	
          

        if(DEBUG) DoDebug("bnd_anim_metacnv: New stage: " + IntToString(nStage));

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oBinder);
    }
}
