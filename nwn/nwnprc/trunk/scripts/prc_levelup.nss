/*
    Put into: OnLevelup Event
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius and DarkGod
//:: Created On: 2003-07-16
//:://////////////////////////////////////////////

//Added hook into EvalPRCFeats event
//  Aaon Graywolf - Jan 6, 2004
//Added delay to EvalPRCFeats event to allow module setup to take priority
//  Aaon Graywolf - Jan 6, 2004

#include "prc_inc_function"
#include "prc_inc_domain"
#include "psi_inc_psifunc"
#include "true_inc_trufunc"
#include "inv_inc_invfunc"
#include "tob_inc_tobfunc"
#include "prc_inc_wpnrest"

void main()
{
    object oPC = GetPCLevellingUp();
    //if(DEBUG) DoDebug("prc_levelup running for '" + GetName(oPC) + "'");

    // Update class info for EvalPRCFeats()
    SetupCharacterData(oPC);

    object oSkin = GetPCSkin(oPC);
    DelayCommand(0.0, ScrubPCSkin(oPC, oSkin));
    DelayCommand(0.0, DeletePRCLocalInts(oSkin));
    //if(DEBUG) DoDebug("prc_levelup: DeleteLocals");

    // Gives people the proper spells from their bonus domains
    // This should run before EvalPRCFeats, because it sets a variable
    DelayCommand(0.1, CheckBonusDomains(oPC));
    //if(DEBUG) DoDebug("prc_levelup: BonusDomain");
    //All of the PRC feats have been hooked into EvalPRCFeats
    //The code is pretty similar, but much more modular, concise
    //And easy to maintain.
    //  - Aaon Graywolf
    DelayCommand(0.2, EvalPRCFeats(oPC));
    DelayCommand(0.4, DoWeaponsEquip(oPC));
    //if(DEBUG) DoDebug("prc_levelup: PRCFeats");
    // Check to see which special prc requirements (i.e. those that can't be done)
    // through the .2da's, the newly leveled up player meets.
    ExecuteScript("prc_prereq", oPC); // update prereqs now, for prc_enforce_feat
    DelayCommand(0.5, ExecuteScript("prc_prereq", oPC)); // Execute again after delay so that deleveling (if necessary) gets to happen before it.
	//:: Run PrC marker feat check
	ExecuteScript("prc_enforce_mark", oPC);
    ExecuteScript("prc_enforce_feat", oPC);
    ExecuteScript("prc_enforce_psi", oPC);
    //Restore Power Points for Psionics
    ExecuteScript("prc_psi_ppoints", oPC);
    //if(DEBUG) DoDebug("prc_levelup: PowerPoints");
    DelayCommand(0.1, FeatSpecialUsePerDay(oPC));

    // These scripts fire events that should only happen on levelup
    ExecuteScript("prc_vassal_treas", oPC);
    ExecuteScript("tob_evnt_recover", oPC);
    ExecuteScript("moi_wchb_royal", oPC);
	
	// Handle Hidden Talent 
	if(GetHasFeat(FEAT_HIDDEN_TALENT, oPC) && !GetPersistantLocalInt(oPC, "HiddenTalentChosen"))  
	{  
		// Trigger Hidden Talent power selection conversation  
		AssignCommand(oPC, ActionStartConversation(oPC, "hidden_talent_cv", TRUE, FALSE));  
	}   
	
    // Execute scripts hooked to this event for the player triggering it
    ExecuteAllScriptsHookedToEvent(oPC, EVENT_ONPLAYERLEVELUP);
    if(DEBUG) DoDebug("prc_levelup: Exiting");
}