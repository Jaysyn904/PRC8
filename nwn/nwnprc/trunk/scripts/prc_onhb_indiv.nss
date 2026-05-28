/** @file prc_onhb_indiv

    Invidual Heartbeat event

    This script is run every heartbeat for every PC via the prc_onheartbeat event
    This script is run every heartbeat for every NPC via the prc_npc_hb event

    Its main purposes is to provide a unified individual hb script interface
    Slighly less efficient because things like switches are checked for each individual.

*/

#include "prc_alterations"
#include "prc_inc_nat_hb"
#include "inc_ecl"

void main()
{
    object oPC = OBJECT_SELF;

    // HB code removed from the Module OnHeartbeat (ElgarL)
    // This is now executed as a delayed timer when the player logs in.

    if(!GetIsObjectValid(oPC))
        return;

    // no running stuff for DMs or NPC's
    if((!GetIsDM(oPC)) && (GetIsPC(oPC)))
    {
        int bPWPCAutoexport = GetPRCSwitch(PRC_PW_PC_AUTOEXPORT);

        // Persistent World time tracking
        if(GetPRCSwitch(PRC_PW_TIME))
        {
            //store it on all PCs separately
            SetPersistantLocalTime(oPC, "persist_Time", GetTimeAndDate());
        }
        // Automatic character export every 6n seconds
        // Check the counter to see if it is time to export
        if(bPWPCAutoexport)
        {
            int nCount = GetLocalInt(oPC, "AutoexportCount");
            if(nCount == bPWPCAutoexport)
                DeleteLocalInt(oPC, "AutoexportCount");
            else
            {
                nCount++;
                SetLocalInt(oPC, "AutoexportCount", nCount);
                bPWPCAutoexport = FALSE;
            }
        }
        // Export if the counter has run down
        if(bPWPCAutoexport)
        {
            if(!GetIsPolyMorphedOrShifted(oPC))
                ExportSingleCharacter(oPC);
        }
        // Persistant hit point tracking
        if(GetPRCSwitch(PRC_PW_HP_TRACKING))
        {
            //Flag that we have saved the HP as testing for Zero is faulty logic
            //
            SetPersistantLocalInt(oPC, "persist_HP_stored", -1);
            // Now store the current HP.
            SetPersistantLocalInt(oPC, "persist_HP", GetCurrentHitPoints(oPC));
        }
        // Persistant location tracking
        if(GetPRCSwitch(PRC_PW_LOCATION_TRACKING) && GetStartingLocation() != GetLocation(oPC))
            SetPersistantLocalMetalocation(oPC, "persist_loc", LocationToMetalocation(GetLocation(oPC)));
        // Persistant map pin tracking
        if(GetPRCSwitch(PRC_PW_MAPPIN_TRACKING))
        {
            int i;
            int nMapPinCount = GetNumberOfMapPins(oPC);
            struct metalocation mLoc;
            for(i = 1; i <= nMapPinCount; i++)
            {
                mLoc = CreateMetalocationFromMapPin(oPC, i);
                SetPersistantLocalMetalocation(oPC, "MapPin_" + IntToString(i), mLoc);
            }
            SetPersistantLocalInt(oPC, "MapPinCount", nMapPinCount);
        }

        // Death - Bleed - ElgarL
        if(GetPRCSwitch(PRC_PNP_DEATH_ENABLE))
        {
            // PC doing anything that requires attention while disabled take damage
            if(GetPersistantLocalInt(oPC, "STATUS") == 3)
            {
                int nAction = GetCurrentAction(oPC);
                if(nAction == ACTION_DISABLETRAP  || nAction == ACTION_TAUNT
                 || nAction == ACTION_PICKPOCKET   || nAction == ACTION_ATTACKOBJECT
                 || nAction == ACTION_COUNTERSPELL || nAction == ACTION_FLAGTRAP
                 || nAction == ACTION_CASTSPELL    || nAction == ACTION_ITEMCASTSPELL)
                {
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(1), oPC);
                }
            }
        }

        // Continue the HeartBeat Timer.
        DelayCommand(6.0, ExecuteScript("prc_onhb_indiv", oPC));
    }

	// Check for Morality Undone expiration  
	if(GetPersistantLocalInt(oPC, "MoralityUndone_Expire") > 0)  
	{  
		if(GetTimeSecond() >= GetPersistantLocalInt(oPC, "MoralityUndone_Expire"))  
		{  
			int nShiftAmount = GetPersistantLocalInt(oPC, "MoralityUndone_ShiftAmount");  
			AdjustAlignment(oPC, ALIGNMENT_GOOD, nShiftAmount, FALSE);  
			DeletePersistantLocalInt(oPC, "MoralityUndone_Expire");  
			DeletePersistantLocalInt(oPC, "MoralityUndone_ShiftAmount");  
		}  
	}
	
	/* PC_damage code to support oni's scripts
     * If HP is over 1 apply the damage and let
     * the OnDying deal with the consequences
     */
    int nDamage = GetLocalInt(oPC, "PC_Damage");
    if(nDamage && GetCurrentHitPoints(oPC) > 1)
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDamage), oPC);
        SetLocalInt(oPC, "PC_Damage", 0);
    }

    // ECL
    if(GetIsPC(oPC) || (!GetIsPC(oPC) && GetPRCSwitch(PRC_XP_GIVE_XP_TO_NPCS)))
        ApplyECLToXP(oPC);

    // Check if the character has lost a level since last HB
    if(GetHitDice(oPC) != GetLocalInt(oPC, "PRC_HitDiceTracking"))
    {
        if(GetHitDice(oPC) < GetLocalInt(oPC, "PRC_HitDiceTracking"))
        {
            SetLocalInt(oPC, "PRC_OnLevelDown_OldLevel", GetLocalInt(oPC, "PRC_HitDiceTracking"));
            DelayCommand(0.0f, ExecuteScript("prc_onleveldown", oPC));
        }
        SetLocalInt(oPC, "PRC_HitDiceTracking", GetHitDice(oPC));
    }

    // Race Pack Code
    ExecuteScript("race_hb", oPC);
    //natural weapons
    //SpawnScriptDebugger();
    DoNaturalWeaponHB(oPC);

    // Eventhook
    ExecuteAllScriptsHookedToEvent(oPC, EVENT_ONHEARTBEAT);
}