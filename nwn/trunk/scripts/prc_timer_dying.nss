// Dying Heartbeat timer by ElgarL

#include "inc_persist_loca"
#include "prc_inc_switch"
#include "prc_feat_const"
#include "prc_misc_const"	// Status constants
#include "inc_eventhook"
#include "prc_class_const"

///////////////////////////////////////////////
// 			Local Functions
///////////////////////////////////////////////

// Place the restrictions on the player to
// behave as if they are alive, but disabled.
//
void prc_death_disabled(object oPC)
{
	FloatingTextStringOnCreature("* "+GetName(oPC)+" is Disabled *", oPC, TRUE);
	if (GetCutsceneMode(oPC))
	{
		SetCutsceneMode(oPC, FALSE);
		SetPlotFlag(oPC, FALSE);
	}		
	effect eDisabled = SupernaturalEffect(EffectSlow());
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDisabled, oPC,
		6.1f);
}

void prc_death_become_unstable(object oPC)
{
	FloatingTextStringOnCreature("* "+GetName(oPC)+" started bleeding again *", oPC, TRUE);
	SetPersistantLocalInt(oPC, "STATUS", BLEEDING);
}

// Tidy everything up as we are leaving the death timer
//
void prc_death_cleanup(object oPC)
{
	//cleanup
	DeleteLocalInt(oPC, "prc_Disabled");
	DeletePersistantLocalInt(oPC, "STATUS");
	if(GetPRCSwitch(PRC_PW_DEATH_TRACKING))
		DeletePersistantLocalInt(oPC, "persist_dead");
	if(GetIsPC(oPC) && GetCutsceneMode(oPC))
	{
		SetCutsceneMode(oPC, FALSE);
		SetPlotFlag(oPC, FALSE);
	}
	SetCommandable(TRUE, oPC);
	
	// Delayed so it fires after this event finishes.
	DelayCommand(0.0, RemoveEventScript(oPC, EVENT_ONHEARTBEAT, "prc_timer_dying", TRUE, FALSE));
}

void PRC_DIE(object oPC)
{
	effect eDeath = EffectDeath(FALSE, FALSE);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, GetLastPlayerDying());
	SetPersistantLocalInt(oPC, "STATUS", DEAD);	//Flag dead
	FloatingTextStringOnCreature("* "+GetName(oPC)+" died *", oPC, TRUE);
}

void prc_death_speak(object oPC)
{
	//play a voicesound
    int nVoice = -1;
    switch(Random(39))
    {
        case 0: nVoice = VOICE_CHAT_HEALME; break;
        case 1: nVoice = VOICE_CHAT_HEALME; break;
        case 2: nVoice = VOICE_CHAT_NEARDEATH; break;
        case 3: nVoice = VOICE_CHAT_HELP; break;
        case 4: nVoice = VOICE_CHAT_PAIN1; break;
        case 5: nVoice = VOICE_CHAT_PAIN2; break;
        case 6: nVoice = VOICE_CHAT_PAIN3; break;
        case 7: nVoice = VOICE_CHAT_PAIN1; break;
        case 8: nVoice = VOICE_CHAT_PAIN2; break;
        case 9: nVoice = VOICE_CHAT_PAIN3; break;
        case 10: nVoice = VOICE_CHAT_PAIN1; break;
        case 11: nVoice = VOICE_CHAT_PAIN2; break;
        case 12: nVoice = VOICE_CHAT_PAIN3; break;
        //rest of them dont play anything
    }
    if(nVoice != -1)
        DelayCommand(IntToFloat(Random(60))/10.0,
            PlayVoiceChat(nVoice, oPC));
}
		
///////////////////////////////////////////////


void main()
{
	object oPC 			= OBJECT_SELF;
	object oArea 		= GetArea(oPC);
	int nStatus 		= GetPersistantLocalInt(oPC, "STATUS");
	int nHP 			= GetCurrentHitPoints(oPC);
	int nOldHP 			= GetLocalInt(oPC, "prc_death_hp");
	
	if (DEBUG)
	{
		DoDebug("Dying timer status = " + IntToString(nStatus));
		DoDebug("        Current HP = " + IntToString(nHP));
		DoDebug("            Old HP = " + IntToString(nOldHP));
	}
	
	// Check to see if we really need to be in here, or have been healed/raised.
	if(((nHP > 10) && (nStatus == ALTERED_STATE)) || ((nHP > 0) && (nStatus == DEAD)))
    {
        //back to life via heal spell or similar
        FloatingTextStringOnCreature("* "+GetName(oPC)+" is no longer dying *", oPC, TRUE);
        //For ALTERED_STATE if more than 10 HP remove the 10 free HP
        if(nHP > 10 && nStatus == ALTERED_STATE)
            ApplyEffectToObject(DURATION_TYPE_INSTANT,
                EffectDamage(10),
                oPC);
        prc_death_cleanup(oPC);
        //do not continue HeartBeat
        return;
    }
	
	//mark it as cutscene, nonplot if appropriate
    if(!GetCutsceneMode(oPC) && (nStatus != ALTERED_STATE) && (nStatus != DISABLED))
    {
        //SetCutsceneMode(oPC, TRUE, TRUE);
        SetPlotFlag(oPC, FALSE);
    }
    
    if (GetLevelByClass(CLASS_TYPE_FROSTRAGER, oPC)) nStatus = STABLE;
    
    if (GetLocalInt(oPC, "BullybashersDeath"))
    {
    	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(1), oPC);
    	nHP += 1;
    	nStatus = STABLE;
    }    	
	
	switch (nStatus)
	{
		case BLEEDING:
		{
			//bleed a bit					
			if(GetPRCSwitch(PRC_DEATH_OR_BLEED))
			{
				ApplyEffectToObject(DURATION_TYPE_INSTANT,
					EffectDamage(GetPRCSwitch(PRC_DEATH_DAMAGE_FROM_BLEEDING)),
					oPC);
				FloatingTextStringOnCreature("* "+GetName(oPC)+" continues to bleed *", oPC, TRUE);
			}
			else {
				// No timer set so we die instead of bleed
				PRC_DIE(oPC);
				break;
			}
			
			// Chance of becoming stable.
			if(Random(100) < GetPRCSwitch(PRC_DEATH_BLEED_TO_STABLE_CHANCE))
			{
				FloatingTextStringOnCreature("* "+GetName(oPC)+" stabilized *", oPC, TRUE);
				SetPersistantLocalInt(oPC, "STATUS", STABLE);
			}
			
			if (GetCurrentHitPoints(oPC) <= -10)
			{
				// Dead
				PRC_DIE(oPC);
			}
			else
			{
				// random utterances
				prc_death_speak(oPC);
			}
		}
		break;
		
		case STABLE:
		{
			// You are stable, but still unconscious
			// You will gradually heal (if set),
			// unless set to take damage too.
			
			// Check to see if we have regained any Health
			// By means other than the natural healing of stabled
			// or we have regained enough health to become conscious
			// If we have take us to disabled
            // Frostragers are always disabled, not bleeding
            if ((nHP > nOldHP) || (nHP >= 1) || (GetLevelByClass(CLASS_TYPE_FROSTRAGER, oPC)>0))
			{
				// We gained health by means other than stable recovery
				ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oPC);
				SetPersistantLocalInt(oPC, "STATUS", DISABLED);
				prc_death_disabled(oPC);
				break;
			} 
			else if(nHP < nOldHP)
			{
				// We took damage so set us bleeding again
				SetPersistantLocalInt(oPC, "STATUS", BLEEDING);
				break;
			}
		
			//is stable, gradually recover HP
			if (GetPRCSwitch(PRC_DEATH_HEAL_FROM_STABLE))
				ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetPRCSwitch(PRC_DEATH_HEAL_FROM_STABLE)), oPC);
				
			// damage too?	
			if (GetPRCSwitch(PRC_DEATH_DAMAGE_FROM_STABLE))
				ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(GetPRCSwitch(PRC_DEATH_DAMAGE_FROM_STABLE)), oPC);
			
			// Chance of becoming disabled
			if(Random(100) < GetPRCSwitch(PRC_DEATH_STABLE_TO_DISABLED_CHANCE))
			{
				ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oPC);
				SetPersistantLocalInt(oPC, "STATUS", DISABLED);
				prc_death_disabled(oPC);
			} 
			else 
			{
				// Chance of becoming unstable
				if(Random(100) < GetPRCSwitch(PRC_DEATH_STABLE_TO_BLEED_CHANCE))
				{
					//become unstable
					prc_death_become_unstable(oPC);
				}
				
				// random utterances
				prc_death_speak(oPC);
				FloatingTextStringOnCreature("* "+GetName(oPC)+" is stable but unconscious *", oPC, TRUE);
			}
		}
		break;
		
		case DISABLED:
		{			
			// If we are still at Zero then we took damage (probably through an action)
			// so should be bleeding. We can't check at the entry test as it may be an
			// error for a player logging back in.
			if (nHP == 0)
			{
				//become unstable
				prc_death_become_unstable(oPC);
				AssignCommand(oPC, DelayCommand(0.03, PlayAnimation(ANIMATION_LOOPING_DEAD_BACK, 1.0, 4.0)));
			}
				
				
			// By pnp rules we have a 10% chance of improving from disabled.
			// or we get healed.
			if((Random(100) < 10) || (nHP > nOldHP))
			{
				// remove all effects so the player can act normally
				FloatingTextStringOnCreature("* "+GetName(oPC)+" is no longer disabled *", oPC, TRUE);
				prc_death_cleanup(oPC);
			} else {
				//Continue Disabled
				if (DEBUG) DoDebug("Continue Disabled.");
				prc_death_disabled(oPC);
			}
		
		}
		break;
		
		case ALIVE:
		{
			// We are dieing or we'd not be here. Better set things up.
            // Frostragers don't bleed
            if (nHP == 0 || (GetLevelByClass(CLASS_TYPE_FROSTRAGER, oPC)>0))
			{
					if (DEBUG) DoDebug("Disabled on entry.");
					ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oPC);
					SetPersistantLocalInt(oPC, "STATUS", DISABLED);
					prc_death_disabled(oPC); // Set to disabled
			} else if (nHP < 0) {
				if (DEBUG) DoDebug("Bleeding on entry.");
				SetPersistantLocalInt(oPC, "STATUS", BLEEDING);	//Set to bleeding.
				AssignCommand(oPC, DelayCommand(0.03, PlayAnimation(ANIMATION_LOOPING_DEAD_BACK, 1.0, 4.0)));
			} else {
				// If we fell through this far it means we are healed and alive.
				// We should exit with no ill effects.
				prc_death_cleanup(oPC);
				break;
			}
			
			
			// Not dead so DON'T fall through to dead.
			if (nHP > -10)
				break;
			//*********** This will fall through if we are dead ***********\\
			PRC_DIE(oPC);
			if (DEBUG) DoDebug("Fall through to dead.");
		}
		
		case DEAD:
		{
			//I guess we are dead
			if (DEBUG) DoDebug("Died in timer.");
			
			//PCs get an option to reload
			if(GetIsPC(oPC))
			{
				string sMessage;
				//panel title says "You are Dead."
				sMessage = "Press Respawn to return to the game, or wait for someone to raise you.\n";
				if(GetPCPublicCDKey(oPC) == "")
					sMessage += "Alternatively, you may load a saved game.\n";
				PopUpDeathGUIPanel(oPC, TRUE, TRUE, 0, sMessage);
			}
		
		}
		break;	// Continue the timer in case we are ressurected.
		
		case ALTERED_STATE: // Altered health through Feats/abilities
		{
			// Here we will deal with things like feats
			// which allow players to remain concious.
			
			//Currently does nothing
		
		}
		break;
		
	}
	
	// Store our current HP so we can check later for improvement.
	SetLocalInt(oPC, "prc_death_hp", GetCurrentHitPoints(oPC));
}