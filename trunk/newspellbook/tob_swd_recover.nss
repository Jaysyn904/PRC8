/*
    Recover all swordsage maneuvers
    Only functions in combat, otherwise call delayed recovery
*/
#include "tob_inc_tobfunc"
#include "inc_dynconv"
#include "x0_i0_modes" 

void main()
{
	object oInitiator = OBJECT_SELF;
	if (GetIsInCombat(oInitiator))
	{
		int nStealth = FALSE;
		if(GetStealthMode(oInitiator) == STEALTH_MODE_ACTIVATED) nStealth = TRUE;
		
		AssignCommand(oInitiator, ClearAllActions(TRUE));
		StartDynamicConversation("tob_swd_rcrcnv", oInitiator, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oInitiator);
		
		if (nStealth)
		{
    		SetActionMode(oInitiator, ACTION_MODE_STEALTH, TRUE);
    		UseStealthMode();
    		ActionUseSkill(SKILL_HIDE, oInitiator);
    		ActionUseSkill(SKILL_MOVE_SILENTLY, oInitiator); 		
    	}	
	}
	else
	{
		// Delayed Recovery Mechanics
		ExecuteScript("tob_gen_recover", oInitiator);
	}
}