/*
    Recover all swordsage maneuvers
    Only functions in combat, otherwise call delayed recovery
*/
#include "tob_inc_recovery"
#include "inc_dynconv"
#include "x0_i0_modes"
#include "prc_nui_mr_const"

void main()
{
	object oInitiator = OBJECT_SELF;
	int nRequestedManeuver = GetLocalInt(
		oInitiator,
		PRC_MANEUVER_RECOVER_PENDING_VAR
	);
	// The NUI selection is one-shot. Consume it at feat impact so a canceled or
	// invalid request can never affect a later ordinary radial feat use.
	DeleteLocalInt(oInitiator, PRC_MANEUVER_RECOVER_PENDING_VAR);
	if (GetIsInCombat(oInitiator))
	{
		int nStealth = FALSE;
		if(GetStealthMode(oInitiator) == STEALTH_MODE_ACTIVATED) nStealth = TRUE;

		if (nRequestedManeuver > 0)
		{
			// RecoverManeuver invokes Vital Recovery even when its ID is stale,
			// so validate both authoritative lists immediately before calling it.
			if (GetLevelByClass(CLASS_TYPE_SWORDSAGE, oInitiator) <= 0
				|| !GetHasFeat(PRC_MANEUVER_RECOVER_FEAT_SWORDSAGE, oInitiator)
				|| !GetIsManeuverReadied(
					oInitiator,
					MANEUVER_LIST_SWORDSAGE,
					nRequestedManeuver
				)
				|| !GetIsManeuverExpended(
					oInitiator,
					MANEUVER_LIST_SWORDSAGE,
					nRequestedManeuver
				))
			{
				SendMessageToPC(
					oInitiator,
					"That Swordsage maneuver is no longer available to recover."
				);
				return;
			}

			AssignCommand(oInitiator, ClearAllActions(TRUE));
			RecoverManeuver(
				oInitiator,
				MANEUVER_LIST_SWORDSAGE,
				nRequestedManeuver
			);
			FloatingTextStringOnCreature(
				GetManeuverName(nRequestedManeuver) + " recovered",
				oInitiator,
				FALSE
			);
		}
		else
		{
			AssignCommand(oInitiator, ClearAllActions(TRUE));
			StartDynamicConversation("tob_swd_rcrcnv", oInitiator, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oInitiator);
		}
		
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
