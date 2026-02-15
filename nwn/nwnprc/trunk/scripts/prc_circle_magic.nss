//:://////////////////////////////////////////////
//::	;-.  ,-.   ,-.  ,-. 
//::	|  ) |  ) /    (   )
//::	|-'  |-<  |     ;-: 
//::	|    |  \ \    (   )
//::	'    '  '  `-'  `-' 
//:://////////////////////////////////////////////
//::  
/*
	Circle Magic
	Type of Feat: Class Specific
	Prerequisite: None
	Specifics: Allows caster to participate in 
	Circle Magic. Caster sacrifices a spell to 
	augment the casting power of the Circle Leader.
	Use: Activate feat, target circle leader, 
	select and cast spell.
	
*/
//::  
//:://////////////////////////////////////////////  
//::	Script:     prc_circle_magic.nss  
//::	Author:     Jaysyn  
//::	Created:    2026-02-10 12:19:50  
//:://////////////////////////////////////////////  
#include "prc_inc_spells"  
#include "x2_inc_spellhook"  
  
void main()  
{  
    int nEvent = GetRunningEvent();  
    object oPC = OBJECT_SELF;  
  
    // Initial feat activation  
    if (nEvent == FALSE)  
    {  
        object oLeader = GetSpellTargetObject();  
  
        // Prevent leader from joining their own circle  
        if (oLeader == oPC)  
        {  
            FloatingTextStringOnCreature("You cannot join a circle you lead as a channeler.", oPC);  
            return;  
        }  
  
        // Validate target is a Circle Leader with active circle  
        if (!GetHasFeat(FEAT_CIRCLE_LEADER_RASHEMAN, oLeader) &&  
            !GetHasFeat(FEAT_CIRCLE_LEADER_THAYAN, oLeader) &&  
            !GetHasFeat(FEAT_GREAT_CIRCLE_LEADER_THAYAN, oLeader) &&  
            !GetHasFeat(FEAT_GREAT_CIRCLE_LEADER_RASHEMAN, oLeader))  
        {  
            FloatingTextStringOnCreature("Target is not a Circle Leader.", oPC);  
            return;  
        }  
  
        if (!GetLocalInt(oLeader, "CircleMagicActive"))  
        {  
            FloatingTextStringOnCreature("Circle is not active.", oPC);  
            return;  
        }  
  
        // Start channeling for 1 in-game hour; concentration/range checks in event script  
        SetLocalInt(oPC, "CircleMagicChanneling", TRUE);  
        SetLocalObject(oPC, "CircleMagicLeader", oLeader);  
        SetLocalFloat(oPC, "CircleMagicTimeLeft", HoursToSeconds(1));  
        // Only make associates non-commandable  
        if (!GetIsPC(oPC))  
            SetCommandable(FALSE, oPC);  
        AssignCommand(oPC, ClearAllActions());  
        AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_SPASM, 1.0, HoursToSeconds(1)));  
        AddEventScript(oPC, EVENT_ONHEARTBEAT, "prc_circle_magic", TRUE, FALSE);  
        AddEventScript(oPC, EVENT_VIRTUAL_ONDAMAGED, "prc_od_conc", TRUE, FALSE);  
        FloatingTextStringOnCreature("Channeling Circle Magic for 1 hour...", oPC);  
    }  
    else if (nEvent == EVENT_ONHEARTBEAT)  
    {  
        if (!GetLocalInt(oPC, "CircleMagicChanneling")) return;  
  
        object oLeader = GetLocalObject(oPC, "CircleMagicLeader");  
        float fTimeLeft = GetLocalFloat(oPC, "CircleMagicTimeLeft") - 6.0f;  
  
        // Concentration break check  
        if (GetLocalInt(oPC, "CONC_BROKEN"))  
        {  
            FloatingTextStringOnCreature("Concentration broken. Channeling failed.", oPC);  
            RemoveEventScript(oPC, EVENT_ONHEARTBEAT, "prc_circle_magic");  
            RemoveEventScript(oPC, EVENT_VIRTUAL_ONDAMAGED, "prc_od_conc");  
            DeleteLocalInt(oPC, "CircleMagicChanneling");  
            DeleteLocalFloat(oPC, "CircleMagicTimeLeft");  
            if (!GetIsPC(oPC))  
                SetCommandable(TRUE, oPC);  
            AssignCommand(oPC, ClearAllActions());  
            return;  
        }  
  
        // Range check  
        if (GetIsObjectValid(oLeader) && GetDistanceBetween(oPC, oLeader) > 4.0f)  
        {  
            FloatingTextStringOnCreature("Too far from leader. Channeling failed.", oPC);  
            RemoveEventScript(oPC, EVENT_ONHEARTBEAT, "prc_circle_magic");  
            RemoveEventScript(oPC, EVENT_VIRTUAL_ONDAMAGED, "prc_od_conc");  
            DeleteLocalInt(oPC, "CircleMagicChanneling");  
            DeleteLocalFloat(oPC, "CircleMagicTimeLeft");  
            if (!GetIsPC(oPC))  
                SetCommandable(TRUE, oPC);  
            AssignCommand(oPC, ClearAllActions());  
            return;  
        }  
  
        if (fTimeLeft <= 0.0f)  
        {  
            // Channeling complete: find highest spell and cast it at the leader  
            int nHighestSpell = GetBestL9Spell(oPC, -1);  
            if (nHighestSpell == -1) nHighestSpell = GetBestL8Spell(oPC, -1);  
            if (nHighestSpell == -1) nHighestSpell = GetBestL7Spell(oPC, -1);  
            if (nHighestSpell == -1) nHighestSpell = GetBestL6Spell(oPC, -1);  
            if (nHighestSpell == -1) nHighestSpell = GetBestL5Spell(oPC, -1);  
            if (nHighestSpell == -1) nHighestSpell = GetBestL4Spell(oPC, -1);  
            if (nHighestSpell == -1) nHighestSpell = GetBestL3Spell(oPC, -1);  
            if (nHighestSpell == -1) nHighestSpell = GetBestL2Spell(oPC, -1);  
            if (nHighestSpell == -1) nHighestSpell = GetBestL1Spell(oPC, -1);  
            if (nHighestSpell == -1) nHighestSpell = GetBestL0Spell(oPC, -1);  
  
            if (nHighestSpell != -1)  
            {  
                // Set flags for spellhook interception, then cast  
                SetLocalInt(oPC, "CircleMagicSacrifice", TRUE);  
                SetLocalObject(oPC, "CircleMagicLeader", oLeader);  
                AssignCommand(oPC, ClearAllActions());  
                AssignCommand(oPC, ActionCastSpellAtObject(nHighestSpell, oLeader));  
            }  
            else  
            {  
                FloatingTextStringOnCreature("No spells available to sacrifice.", oPC);  
            }  
  
            // Cleanup channeling state  
            RemoveEventScript(oPC, EVENT_ONHEARTBEAT, "prc_circle_magic");  
            RemoveEventScript(oPC, EVENT_VIRTUAL_ONDAMAGED, "prc_od_conc");  
            DeleteLocalInt(oPC, "CircleMagicChanneling");  
            DeleteLocalFloat(oPC, "CircleMagicTimeLeft");  
            if (!GetIsPC(oPC))  
                SetCommandable(TRUE, oPC);  
        }  
        else  
        {  
            SetLocalFloat(oPC, "CircleMagicTimeLeft", fTimeLeft);  
        }  
    }  
}