//::///////////////////////////////////////////////
//:: OnPlayerDying eventscript
//:: prc_ondying
//:://////////////////////////////////////////////

#include "inc_utility"
#include "x0_i0_position"
#include "moi_inc_moifunc"

//////////////////////////////////////////
// 			Private Functions			//
//////////////////////////////////////////

void Kill_PC(object oPC)
{
	effect eDeath = EffectDeath(FALSE, FALSE);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oPC);
}

void feat_save(object oDying)
{
	//////////////////////////////////////////
	// 			FEAT_SHADOWDISCOPOR
	//////////////////////////////////////////
	
	// Telflammar Shadowlord Shadow Discorporation. If successfull, prevents the rest of the script from executing
    /// @todo TLK the feedback strings
    if(GetHasFeat(FEAT_SHADOWDISCOPOR, oDying) &&
       (GetIsAreaAboveGround(GetArea(oDying)) == AREA_UNDERGROUND ||
        GetIsNight()                                           ||
        PRCGetHasEffect(EFFECT_TYPE_DARKNESS, oDying)
       ))
    {
        int nRoll    = d20();
        int nDC      = 5 + GetLocalInt(oDying, "PRC_LastDamageTaken");
        int bSuccess = nRoll + GetReflexSavingThrow(oDying) >= nDC;

        // Some informational spam
        string sFeedback = "*Reflex Save vs Death : "
                         + (bSuccess ? "*success*" : "*failure*")
                         + " :(" + IntToString(nRoll) + " + " + IntToString(GetReflexSavingThrow(oDying)) + " = " + IntToString(nRoll + GetReflexSavingThrow(oDying)) + " vs. DC:" + IntToString(nDC) + ")";
        FloatingTextStringOnCreature(sFeedback, oDying);

        // Handle keeping the character alive
        if(bSuccess)
        {// Resurrect the character. Necessary because the game considers them already dead at this point
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oDying);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(1 - (GetCurrentHitPoints(oDying))), oDying);
            SignalEvent(oDying, EventSpellCastAt(OBJECT_SELF, SPELL_RESTORATION, FALSE));

            // Move the character to a random nearby location
            location locJump = GetRandomLocation(GetArea(oDying), oDying, 30.0f);
            AssignCommand(oDying, ClearAllActions(TRUE));
            AssignCommand(oDying, ActionJumpToLocation(locJump));

            // The character is not dying after all, so skip the rest of the script to avoid complications
            // Though, the module's own OnDying script may very well supply complications anyway
			return;
        }
    }
	
	//////////////////////////////////////////
	// 			FEAT_REMAIN_CONSCIOUS
	//////////////////////////////////////////

    // Code added by Oni5115 for Remain Concious
    if(GetHasFeat(FEAT_REMAIN_CONSCIOUS, oDying) && GetCurrentHitPoints(oDying) > -10)
	{
		int pc_Damage = (GetCurrentHitPoints(oDying) * -1) + 1;
		int prev_Damage = GetLocalInt(oDying, "PC_Damage");

		// Store damage taken in a local variable
		pc_Damage = pc_Damage + prev_Damage;
		SetLocalInt(oDying, "PC_Damage", pc_Damage);

		if(pc_Damage < 10)
		{
			ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oDying);
		}


		string sFeedback = GetName(oDying) + " : Current HP = " + IntToString(pc_Damage * -1);
		SendMessageToPC(oDying, sFeedback);
    }
	
	//////////////////////////////////////////
	// 			FEAT_DIEHARD
	//////////////////////////////////////////
	
	// When your hit points are reduced to 0 or below, you automatically become stable.
	// You heal to 1 HP, but behave as if disabled.
	
	int nHP 			= GetCurrentHitPoints(oDying);
	if ((GetHasFeat(FEAT_DIEHARD, oDying)) && (nHP > -10) && (nHP <= 0))
	{
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oDying);
		SetPersistantLocalInt(oDying, "STATUS", DISABLED);
	}

	//////////////////////////////////////////
	// 			Rageclaws Meld
	//////////////////////////////////////////
	nHP    = GetCurrentHitPoints(oDying);
	int nLimit = (10 + GetEssentiaInvested(oDying, MELD_RAGECLAWS)) * -1;
	if ((GetHasSpellEffect(MELD_RAGECLAWS, oDying)) && (nHP > nLimit) && (nHP <= 0))
	{
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oDying);
	}	
	
	//////////////////////////////////////////
	// End of Feat/abilities
	//////////////////////////////////////////
}

//////////////////////////////////////////
// 		End of private Functions		//
//////////////////////////////////////////

void main()
{
    object oDying = GetLastPlayerDying();
	
	// Fire code for ANY Feats or abilities which can prevent death here.
	feat_save(oDying);

    // Execute scripts hooked to this event for the player triggering it
    ExecuteAllScriptsHookedToEvent(oDying, EVENT_ONPLAYERDYING);
	
	// Trigger the death/bleed if the PRC Death system is enabled (ElgarL).
	if(GetPRCSwitch(PRC_PNP_DEATH_ENABLE))
		AddEventScript(oDying, EVENT_ONHEARTBEAT, "prc_timer_dying", TRUE, FALSE);


}


