//:://////////////////////////////////////////////
//:: FileName: "contingent_reun"
/*   Purpose: This is the true spell script for Contingent Reunion. The other
        castable script calls the conversation where the player must choose
        a trigger, which then gets transferred to this script, which executes
        the spell effects and results.
     NOTE: This contingency will last indefinitely, unless it triggers or the
        player dispels it in the pre-rest conversation.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On:
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "inc_epicspells"

void MonitorForDeath(object oMonitor, int nCount, object oJumpTo, location lJumpTo, object oPC);
void MonitorForDying(object oMonitor, int nCount, object oJumpTo, location lJumpTo, object oPC);
void MonitorForIncapacitated(object oMonitor, int nCount, object oJumpTo, location lJumpTo, object oPC);
void MonitorForNearDeath(object oMonitor, int nCount, object oJumpTo, location lJumpTo, object oPC);
void MonitorForBadlyWounded(object oMonitor, int nCount, object oJumpTo, location lJumpTo, object oPC);
void MonitorForAfflicted(object oMonitor, int nCount, object oJumpTo, location lJumpTo, object oPC);

void JumpDeadToLocation(object oJumper, location lTarget);

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = GetLocalObject(oPC, "oSpellTarget");
    location lJumpTo = GetLocalLocation(oPC, "lSpellTarget");
    int nTrigger = GetLocalInt(oPC, "nReunionTrigger");
    // Debug
    SendMessageToPC(oPC, IntToString(nTrigger));
    DeleteLocalObject(oPC, "oSpellTarget");
    DeleteLocalLocation(oPC, "lSpellTarget");
    DeleteLocalInt(oPC, "nReunionTrigger");
    DeleteLocalInt(oPC, "nMyTargetIsACreature");
    PenalizeSpellSlotForCaster(oPC);
    // Start monitoring the chosen condition.
    switch (nTrigger)
    {
        // Monitoring self.
        case 0: SetLocalInt(oPC, "nContingentReunion0", TRUE);
                MonitorForDeath(oPC, 1, oTarget, lJumpTo, oPC);
                break;
        case 1: SetLocalInt(oPC, "nContingentReunion1", TRUE);
                MonitorForDying(oPC, 1, oTarget, lJumpTo, oPC);
                break;
        case 2: SetLocalInt(oPC, "nContingentReunion2", TRUE);
                MonitorForIncapacitated(oPC, 1, oTarget, lJumpTo, oPC);
                break;
        case 3: SetLocalInt(oPC, "nContingentReunion3", TRUE);
                MonitorForNearDeath(oPC, 1, oTarget, lJumpTo, oPC);
                break;
        case 4: SetLocalInt(oPC, "nContingentReunion4", TRUE);
                MonitorForBadlyWounded(oPC, 1, oTarget, lJumpTo, oPC);
                break;
        case 5: SetLocalInt(oPC, "nContingentReunion5", TRUE);
                MonitorForAfflicted(oPC, 1, oTarget, lJumpTo, oPC);
                break;
        // Monitoring target.
        case 10: SetLocalInt(oPC, "nContingentReunion0", TRUE);
                MonitorForDeath(oTarget, 1, oTarget, lJumpTo, oPC);
                break;
        case 11: SetLocalInt(oPC, "nContingentReunion1", TRUE);
                MonitorForDying(oTarget, 1, oTarget, lJumpTo, oPC);
                break;
        case 12: SetLocalInt(oPC, "nContingentReunion2", TRUE);
                MonitorForIncapacitated(oTarget, 1, oTarget, lJumpTo, oPC);
                break;
        case 13: SetLocalInt(oPC, "nContingentReunion3", TRUE);
                MonitorForNearDeath(oTarget, 1, oTarget, lJumpTo, oPC);
                break;
        case 14: SetLocalInt(oPC, "nContingentReunion4", TRUE);
                MonitorForBadlyWounded(oTarget, 1, oTarget, lJumpTo, oPC);
                break;
        case 15: SetLocalInt(oPC, "nContingentReunion5", TRUE);
                MonitorForAfflicted(oTarget, 1, oTarget, lJumpTo, oPC);
                break;
    }
}

void MonitorForDeath(object oMonitor, int nCount, object oJumpTo, location lJumpTo, object oPC)
{
    if (GetLocalInt(oPC, "nContingentReunion0") == TRUE) // Is the contingency still active?
    {   // If the target isn't dead.
        if (!GetIsDead(oMonitor) && oMonitor != OBJECT_INVALID)
        {
            if (nCount >= 10) nCount = 0;
            if (nCount == 1)
                FloatingTextStringOnCreature("*Contingency active*", oPC, FALSE);
            if (oJumpTo != OBJECT_INVALID) // Update the JumpTo location each time through.
                lJumpTo = GetLocation(oJumpTo);
            nCount++;
            DelayCommand(6.0, MonitorForDeath(oMonitor, nCount, oJumpTo, lJumpTo, oPC));
        }
        else // Jump oMonitor to the target, and end the contingency.
        {
            FloatingTextStringOnCreature("*Contingency triggered*", oMonitor);
            effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3);
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis,
                GetLocation(oPC));
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lJumpTo);
            if (GetIsDead(oPC))
                JumpDeadToLocation(oPC, lJumpTo);
            else
                AssignCommand(oPC, JumpToLocation(lJumpTo));
            DeleteLocalInt(oPC, "nContingentReunion0");
            MonitorForDeath(oMonitor, nCount, oJumpTo, lJumpTo, oPC);
        }
    }
    else // Restore the lost spell slot.
        RestoreSpellSlotForCaster(oPC);
}

void MonitorForDying(object oMonitor, int nCount, object oJumpTo, location lJumpTo, object oPC)
{
    int nHP = GetCurrentHitPoints(oMonitor);
    if (GetLocalInt(oPC, "nContingentReunion1") == TRUE) // Is the contingency still active?
    {   // If the target isn't dying.
        if (nHP >= 1 && oMonitor != OBJECT_INVALID)
        {
            if (nCount >= 10) nCount = 0;
            if (nCount == 1)
                FloatingTextStringOnCreature("*Contingency active*", oPC, FALSE);
            if (oJumpTo != OBJECT_INVALID) // Update the JumpTo location each time through.
                lJumpTo = GetLocation(oJumpTo);
            nCount++;
            DelayCommand(4.0, MonitorForDying(oMonitor, nCount, oJumpTo, lJumpTo, oPC));
        }
        else // Jump oMonitor to the target, and end the contingency.
        {
            FloatingTextStringOnCreature("*Contingency triggered*", oMonitor);
            effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3);
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis,
                GetLocation(oPC));
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lJumpTo);
            if (GetIsDead(oPC))
                JumpDeadToLocation(oPC, lJumpTo);
            else
                AssignCommand(oPC, JumpToLocation(lJumpTo));
            DeleteLocalInt(oPC, "nContingentReunion1");
            MonitorForDying(oMonitor, nCount, oJumpTo, lJumpTo, oPC);
        }
    }
    else // Restore the lost spell slot.
        RestoreSpellSlotForCaster(oPC);
}

void MonitorForIncapacitated(object oMonitor, int nCount, object oJumpTo, location lJumpTo, object oPC = OBJECT_SELF)
{
    if (GetLocalInt(oPC, "nContingentReunion2") == TRUE) // Is the contingency still active?
    {
        // Is oMonitor incapacitated?
        int nInc;
        effect eX = GetFirstEffect(oMonitor);
        while (GetIsEffectValid(eX))
        {
            if (GetEffectType(eX) == EFFECT_TYPE_PARALYZE) nInc = TRUE;
            if (GetEffectType(eX) == EFFECT_TYPE_PETRIFY) nInc = TRUE;
            if (GetEffectType(eX) == EFFECT_TYPE_SLEEP) nInc = TRUE;
            if (GetEffectType(eX) == EFFECT_TYPE_STUNNED) nInc = TRUE;
            eX = GetNextEffect(oMonitor);
        }
        // If the target isn't incapacitated.
        if (nInc != TRUE && oMonitor != OBJECT_INVALID)
        {
            if (nCount >= 10) nCount = 0;
            if (nCount == 1)
                FloatingTextStringOnCreature("*Contingency active*", oPC, FALSE);
            if (oJumpTo != OBJECT_INVALID) // Update the JumpTo location each time through.
                lJumpTo = GetLocation(oJumpTo);
            nCount++;
            DelayCommand(3.0, MonitorForIncapacitated(oMonitor, nCount, oJumpTo, lJumpTo, oPC));
        }
        else // Jump oMonitor to the target, and end the contingency.
        {
            FloatingTextStringOnCreature("*Contingency triggered*", oMonitor);
            effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3);
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis,
                GetLocation(oPC));
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lJumpTo);
            AssignCommand(oPC, JumpToLocation(lJumpTo));
            DeleteLocalInt(oPC, "nContingentReunion2");
            MonitorForIncapacitated(oMonitor, nCount, oJumpTo, lJumpTo, oPC);
        }
    }
    else // Restore the lost spell slot.
        RestoreSpellSlotForCaster(oPC);
}

void MonitorForNearDeath(object oMonitor, int nCount, object oJumpTo, location lJumpTo, object oPC = OBJECT_SELF)
{
    int nHP = GetCurrentHitPoints(oMonitor);
    int nX = GetMaxHitPoints(oMonitor) / 4;
    if (GetLocalInt(oPC, "nContingentReunion3") == TRUE) // Is the contingency still active?
    {   // If the target isn't near death.
        if (nHP > nX && oMonitor != OBJECT_INVALID)
        {
            if (nCount >= 30) nCount = 0;
            if (nCount == 1)
                FloatingTextStringOnCreature("*Contingency active*", oPC, FALSE);
            if (oJumpTo != OBJECT_INVALID) // Update the JumpTo location each time through.
                lJumpTo = GetLocation(oJumpTo);
            nCount++;
            DelayCommand(2.0, MonitorForNearDeath(oMonitor, nCount, oJumpTo, lJumpTo, oPC));
        }
        else // Jump oMonitor to the target, and end the contingency.
        {
            FloatingTextStringOnCreature("*Contingency triggered*", oMonitor);
            effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3);
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis,
                GetLocation(oPC));
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lJumpTo);
            AssignCommand(oPC, JumpToLocation(lJumpTo));
            DeleteLocalInt(oPC, "nContingentReunion3");
            MonitorForNearDeath(oMonitor, nCount, oJumpTo, lJumpTo, oPC);
        }
    }
    else // Restore the lost spell slot.
        RestoreSpellSlotForCaster(oPC);
}

void MonitorForBadlyWounded(object oMonitor, int nCount, object oJumpTo, location lJumpTo, object oPC = OBJECT_SELF)
{
    int nHP = GetCurrentHitPoints(oMonitor);
    int nX = GetMaxHitPoints(oMonitor) / 2;
    if (GetLocalInt(oPC, "nContingentReunion4") == TRUE) // Is the contingency still active?
    {   // If the target isn't badly wounded.
        if (nHP > nX && oMonitor != OBJECT_INVALID)
        {
            if (nCount >= 30) nCount = 0;
            if (nCount == 1)
                FloatingTextStringOnCreature("*Contingency active*", oPC, FALSE);
            if (oJumpTo != OBJECT_INVALID) // Update the JumpTo location each time through.
                lJumpTo = GetLocation(oJumpTo);
            nCount++;
            DelayCommand(2.0, MonitorForBadlyWounded(oMonitor, nCount, oJumpTo, lJumpTo, oPC));
        }
        else // Jump oMonitor to the target, and end the contingency.
        {
            FloatingTextStringOnCreature("*Contingency triggered*", oMonitor);
            effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3);
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis,
                GetLocation(oPC));
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lJumpTo);
            AssignCommand(oPC, JumpToLocation(lJumpTo));
            DeleteLocalInt(oPC, "nContingentReunion4");
            MonitorForBadlyWounded(oMonitor, nCount, oJumpTo, lJumpTo, oPC);
        }
    }
    else // Restore the lost spell slot.
        RestoreSpellSlotForCaster(oPC);
}

void MonitorForAfflicted(object oMonitor, int nCount, object oJumpTo, location lJumpTo, object oPC = OBJECT_SELF)
{
    if (GetLocalInt(oPC, "nContingentReunion5") == TRUE) // Is the contingency still active?
    {
        // Is oMonitor afflicted?
        int nInc;
        effect eX = GetFirstEffect(oMonitor);
        while (GetIsEffectValid(eX))
        {
            if (GetEffectType(eX) == EFFECT_TYPE_CURSE) nInc = TRUE;
            if (GetEffectType(eX) == EFFECT_TYPE_DISEASE) nInc = TRUE;
            if (GetEffectType(eX) == EFFECT_TYPE_NEGATIVELEVEL) nInc = TRUE;
            if (GetEffectType(eX) == EFFECT_TYPE_POISON) nInc = TRUE;
            eX = GetNextEffect(oMonitor);
        }
        // If the target isn't incapacitated.
        if (nInc != TRUE && oMonitor != OBJECT_INVALID)
        {
            if (nCount >= 10) nCount = 0;
            if (nCount == 1)
                FloatingTextStringOnCreature("*Contingency active*", oPC, FALSE);
            if (oJumpTo != OBJECT_INVALID) // Update the JumpTo location each time through.
                lJumpTo = GetLocation(oJumpTo);
            nCount++;
            DelayCommand(6.0, MonitorForAfflicted(oMonitor, nCount, oJumpTo, lJumpTo, oPC));
        }
        else // Jump oMonitor to the target, and end the contingency.
        {
            FloatingTextStringOnCreature("*Contingency triggered*", oMonitor);
            effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3);
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis,
                GetLocation(oPC));
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lJumpTo);
            AssignCommand(oPC, JumpToLocation(lJumpTo));
            DeleteLocalInt(oPC, "nContingentReunion5");
            MonitorForAfflicted(oMonitor, nCount, oJumpTo, lJumpTo, oPC);
        }
    }
    else // Restore the lost spell slot.
        RestoreSpellSlotForCaster(oPC);
}

void JumpDeadToLocation(object oJumper, location lTarget)
{
    //Debug
    SendMessageToPC(oJumper, "Jumping dead");
    int nDam = 2;
    effect eRez = EffectResurrection();
    effect eKill = EffectDamage(nDam);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eRez, oJumper);
    DelayCommand(0.1, AssignCommand(oJumper, JumpToLocation(lTarget)));
    DelayCommand(0.2, ApplyEffectToObject(DURATION_TYPE_INSTANT, eKill, oJumper));
}
