//::///////////////////////////////////////////////
//:: D&D 3.0 werewolf template helpers
//:: prc_inc_wwolf
//:://////////////////////////////////////////////
/*
    Shared support for templates.2da rows 9 and 19.

    PRC 4.947 has no Control Shape skill. Afflicted lycanthropes therefore
    use the original 3.0 DCs with a Wisdom ability check. The engine's
    NWN's stock item-property model cannot express a silver-only bypass.
    DR 15/+1 retains PRC 4.947's closest native approximation to the printed
    DR 15/silver; an exact material bypass requires a module damage hook.
*/

#include "prc_wwhyb_inc"

const int PRC_WW_CURE_EARLY_CLERIC = 1;
const int PRC_WW_CURE_FULL_MOON = 2;
// New rows are appended after PRC 4.947's last stock/custom entry. Rows
// 136/137 have legacy constant aliases and are intentionally left untouched.
const int PRC_WW_POLYMORPH_WOLF = 165;
const int PRC_WW_POLYMORPH_HYBRID = 166;
const string PRC_WW_FORM_TRANSITION = "PRC_WW_FormTransition";
const string PRC_WW_FORM_EVAL_QUEUED = "PRC_WW_FormEvalQueued";
const string PRC_WW_FORM_LIGHT_EVAL = "PRC_WW_FormLightEval";
const string PRC_WW_DEBUG_SWITCH = "PRC_WEREWOLF_DEBUG";
const string PRC_WW_STATE_LOADED = "PRC_WW_StateLoaded";
const string PRC_WW_RECONSTRUCTING = "PRC_WW_Reconstructing";
const string PRC_WW_VOLUNTARY_TRANSITION = "PRC_WW_VoluntaryTransition";
const string PRC_WW_FORM_SWITCH_PENDING = "PRC_WW_FormSwitchPending";
const string PRC_WW_FORM_SWITCH_SOURCE = "PRC_WW_FormSwitchSource";
const string PRC_WW_FORM_SWITCH_RESUME = "PRC_WW_FormSwitchResume";
const string PRC_WW_FORM_SWITCH_FAILED = "PRC_WW_FormSwitchFailed";
const int PRC_WW_STATE_VERSION_CURRENT = 1;
const int PRC_WW_FORM_NONE = 0;
const int PRC_WW_FORM_WOLF = 1;
const int PRC_WW_FORM_HYBRID = 2;
const string PRC_WW_SELUNITE_AWARE_GRANTED = "PRC_WW_SS_AwareGranted";

int PRCWWHasNaturalTemplate(object oCreature);
int PRCWWHasAfflictedTemplate(object oCreature);
int PRCWWHasTemplate(object oCreature);
int PRCWWHasSeluniteControl(object oCreature);
int PRCWWSyncSeluniteControl(object oCreature);
int PRCWWIsWerewolf(object oCreature);
int PRCWWIsHumanoidType(int nRace);
int PRCWWIsHumanoid(object oCreature);
int PRCWWDebugEnabled();
void PRCWWDebug(string sEvent, object oCreature = OBJECT_INVALID,
    string sDetail = "");
int PRCWWDateKey();
int PRCWWHourKey();
int PRCWWNextDawnHourKey();
void PRCWWSetStateInt(object oPC, string sKey, int nValue);
void PRCWWDeleteStateInt(object oPC, string sKey);
void PRCWWLoadPersistentState(object oPC);
int PRCWWGetActiveForm(object oPC);
void PRCWWSetActiveForm(object oPC, int nForm);
void PRCWWClearInjuryState(object oPC, string sReason = "reset");
void PRCWWBaselineInjury(object oPC, string sReason = "initialize");
void PRCWWResetRuntimeState(object oPC);
int PRCWWFullMoonStartDay();
int PRCWWIsFullMoon();
int PRCWWFirstFullMoonReached(object oPC);
int PRCWWWithinEarlyCureWindow(object oPC);
int PRCWWControlCheck(object oPC, int nDC, string sTask,
    int bReportToPlayer = TRUE);
void PRCWWSetAlignment(object oPC, int nLawChaos, int nGoodEvil,
    string sReason = "");
void PRCWWCommitVoluntaryAlignment(object oPC);
int PRCWWCanChange(object oPC, int bReturning);
int PRCWWHasPolymorphEffect(object oPC);
int PRCWWDetectTemplateForm(object oPC);
int PRCWWHasTemplateFormEffect(object oPC);
void PRCWWRemoveFormSpeed(object oPC);
void PRCWWUpdateTemplateSkin(object oPC, int bHybrid);
void PRCWWApplyFormProperties(object oPC, int bHybrid);
void PRCWWRefreshWolfForm(object oPC);
void PRCWWRefreshHybridForm(object oPC);
void PRCWWOnAssumeForm(object oPC);
void PRCWWOnReturnHumanoid(object oPC);
void PRCWWBeginFormTransition(object oPC);
void PRCWWClearFormSwitchState(object oPC);
int PRCWWStartFormSwitch(object oPC, int nTargetForm);
void PRCWWWaitForFormSwitchRemoval(object oPC, object oOldFormSkin,
    int nTargetForm, int nRepeats);
void PRCWWCompleteFormSwitch(object oPC, int nTargetForm);
void PRCWWFinalizeFormSwitch(object oPC, int nTargetForm);
void PRCWWWaitForFormSwitchRollback(object oPC, object oFailedFormSkin,
    int nSourceForm, int nRepeats);
void PRCWWRestoreFormSwitchSource(object oPC, int nSourceForm);
void PRCWWFinalizeFormSwitchRollback(object oPC, int nSourceForm);
void PRCWWWaitForFailedRollbackRemoval(object oPC, object oFailedFormSkin,
    int nSourceForm, int nRepeats);
int PRCWWShouldCoalesceEquipEval(object oPC);
void PRCWWRunTransitionEquipEval(object oPC);
void PRCWWQueueFormTransitionEval(object oPC);
void PRCWWFinishFormTransition(object oPC);
void PRCWWRevertTemplateForm(object oPC, int bVisual = TRUE);
void PRCWWForceWolfForm(object oPC, string sReason = "unspecified");
void PRCWWReconstructForm(object oPC, int nForm);
void PRCWWCheckInjury(object oPC);
void PRCWWHeartbeat(object oPC);
int PRCWWTryCure(object oCaster, object oTarget, int nMethod);

int PRCWWHasNaturalTemplate(object oCreature)
{
    return GetPersistantLocalInt(oCreature, "template_" + IntToString(TEMPLATE_LYCAN_NAT_WOLF));
}

int PRCWWHasAfflictedTemplate(object oCreature)
{
    return GetPersistantLocalInt(oCreature, "template_" + IntToString(TEMPLATE_LYCAN_ACQ_WOLF));
}

int PRCWWHasTemplate(object oCreature)
{
    return PRCWWHasNaturalTemplate(oCreature) || PRCWWHasAfflictedTemplate(oCreature);
}

int PRCWWHasSeluniteControl(object oCreature)
{
    // Silverstar does not confer lycanthropy. The benefit exists only while
    // a real natural/acquired template is present and class level 6 is held.
    return PRCWWHasTemplate(oCreature)
        && GetLevelByClass(CLASS_TYPE_SILVERSTAR, oCreature) >= 6;
}

int PRCWWSyncSeluniteControl(object oCreature)
{
    int bTemplate = PRCWWHasTemplate(oCreature);
    int bBenefit = bTemplate && PRCWWHasSeluniteControl(oCreature);
    int bGranted = GetPersistantLocalInt(oCreature,
        PRC_WW_SELUNITE_AWARE_GRANTED);
    int bAware = GetPersistantLocalInt(oCreature, "PRC_WW_Aware");

    if(!bTemplate)
    {
        if(bGranted)
            DeletePersistantLocalInt(oCreature,
                PRC_WW_SELUNITE_AWARE_GRANTED);
        return FALSE;
    }

    if(bBenefit && !bAware)
    {
        SetPersistantLocalInt(oCreature, "PRC_WW_Aware", TRUE);
        SetPersistantLocalInt(oCreature,
            PRC_WW_SELUNITE_AWARE_GRANTED, TRUE);
        PRCWWDebug("selunite-control", oCreature,
            "state=enabled awareness=granted");
        return TRUE;
    }

    // If a delevel removes the feature, revoke only awareness which this
    // feature granted. Natural lycanthropes and already-aware afflicted
    // lycanthropes never receive the marker and keep their own awareness.
    if(!bBenefit && bGranted)
    {
        DeletePersistantLocalInt(oCreature,
            PRC_WW_SELUNITE_AWARE_GRANTED);
        SetPersistantLocalInt(oCreature, "PRC_WW_Aware", FALSE);
        PRCWWDebug("selunite-control", oCreature,
            "state=disabled awareness=revoked");
        return TRUE;
    }

    return FALSE;
}

int PRCWWIsWerewolf(object oCreature)
{
    return PRCWWHasTemplate(oCreature)
        || GetHasFeat(FEAT_PRESTIGE_LYCANTHROPE, oCreature);
}

int PRCWWIsHumanoidType(int nRace)
{
    return nRace == RACIAL_TYPE_DWARF
        || nRace == RACIAL_TYPE_ELF
        || nRace == RACIAL_TYPE_GNOME
        || nRace == RACIAL_TYPE_HALFLING
        || nRace == RACIAL_TYPE_HALFELF
        || nRace == RACIAL_TYPE_HALFORC
        || nRace == RACIAL_TYPE_HUMAN
        || nRace == RACIAL_TYPE_HUMANOID_GOBLINOID
        || nRace == RACIAL_TYPE_HUMANOID_ORC
        || nRace == RACIAL_TYPE_HUMANOID_REPTILIAN;
}

int PRCWWIsHumanoid(object oCreature)
{
    int nResolved = MyPRCGetRacialType(oCreature);
    if(PRCWWIsHumanoidType(nResolved))
        return TRUE;

    // These PRC races are published as Humanoid but are not normalized to a
    // core humanoid type. Preserve higher-priority changes such as Undead or
    // Outsider instead of accepting the raw race unconditionally.
    int nRaw = GetRacialType(oCreature);
    if(nRaw == RACIAL_TYPE_STONEHUNTER_GNOME
    || nRaw == RACIAL_TYPE_GLIMMERSKIN_HALFING
    || nRaw == RACIAL_TYPE_NEZUMI)
        return nResolved == nRaw;

    if(nRaw == RACIAL_TYPE_SHIFTER || nRaw == RACIAL_TYPE_CHANGELING)
        return nResolved == RACIAL_TYPE_SHAPECHANGER;

    return FALSE;
}

int PRCWWDebugEnabled()
{
    return GetLocalInt(GetModule(), PRC_WW_DEBUG_SWITCH);
}

void PRCWWDebug(string sEvent, object oCreature = OBJECT_INVALID,
    string sDetail = "")
{
    if(!PRCWWDebugEnabled())
        return;

    string sLine = "[WWTPL] " + sEvent;
    if(GetIsObjectValid(oCreature))
    {
        sLine += " name=" + GetName(oCreature)
            + " tag=" + GetTag(oCreature)
            + " oid=" + ObjectToString(oCreature);
    }
    if(sDetail != "")
        sLine += " " + sDetail;
    WriteTimestampedLogEntry(sLine);
}

int PRCWWDateKey()
{
    return GetCalendarYear() * 10000 + GetCalendarMonth() * 100 + GetCalendarDay();
}

int PRCWWHourKey()
{
    // The standard Aurora calendar has 28-day months. PRC already uses this
    // conversion for persistent time windows (for example half-vampires).
    return (GetCalendarYear() * 336 + GetCalendarMonth() * 28
        + GetCalendarDay()) * 24 + GetTimeHour();
}

int PRCWWNextDawnHourKey()
{
    int nHour = GetTimeHour();
    int nDayStart = PRCWWHourKey() - nHour;
    if(nHour < 6)
        return nDayStart + 6;
    return nDayStart + 30;
}

void PRCWWSetStateInt(object oPC, string sKey, int nValue)
{
    SetPersistantLocalInt(oPC, sKey, nValue);
    SetLocalInt(oPC, sKey, nValue);
}

void PRCWWDeleteStateInt(object oPC, string sKey)
{
    DeletePersistantLocalInt(oPC, sKey);
    DeleteLocalInt(oPC, sKey);
}

int PRCWWLegacyDawnHourKey(int nDate, int nHour)
{
    if(!nDate)
        return 0;

    int nYear = nDate / 10000;
    int nMonth = (nDate / 100) - nYear * 100;
    int nDay = nDate - (nDate / 100) * 100;
    int nDayStart = (nYear * 336 + nMonth * 28 + nDay) * 24;
    if(nHour < 6)
        return nDayStart + 6;
    return nDayStart + 30;
}

void PRCWWLoadPersistentState(object oPC)
{
    if(GetLocalInt(oPC, PRC_WW_STATE_LOADED))
        return;

    int nVersion = GetPersistantLocalInt(oPC, "PRC_WW_StateVersion");
    if(nVersion < PRC_WW_STATE_VERSION_CURRENT)
    {
        // Upgrade live pre-hardening episodes once. Marker values are copied
        // first so companion values of zero (notably chaotic/evil alignment)
        // remain meaningful.
        if(GetLocalInt(oPC, "PRC_WW_Involuntary"))
        {
            SetPersistantLocalInt(oPC, "PRC_WW_Involuntary", TRUE);
            SetPersistantLocalInt(oPC, "PRC_WW_ForcedDate",
                GetLocalInt(oPC, "PRC_WW_ForcedDate"));
            SetPersistantLocalInt(oPC, "PRC_WW_ForcedHour",
                GetLocalInt(oPC, "PRC_WW_ForcedHour"));
        }
        if(GetLocalInt(oPC, "PRC_WW_SavedAlignment"))
        {
            SetPersistantLocalInt(oPC, "PRC_WW_SavedAlignment", TRUE);
            SetPersistantLocalInt(oPC, "PRC_WW_SavedLawChaos",
                GetLocalInt(oPC, "PRC_WW_SavedLawChaos"));
            SetPersistantLocalInt(oPC, "PRC_WW_SavedGoodEvil",
                GetLocalInt(oPC, "PRC_WW_SavedGoodEvil"));
        }
        if(GetLocalInt(oPC, "PRC_WW_ReturnLocked"))
        {
            SetPersistantLocalInt(oPC, "PRC_WW_ReturnLocked", TRUE);
            SetPersistantLocalInt(oPC, "PRC_WW_ReturnFailDate",
                GetLocalInt(oPC, "PRC_WW_ReturnFailDate"));
            SetPersistantLocalInt(oPC, "PRC_WW_ReturnFailHour",
                GetLocalInt(oPC, "PRC_WW_ReturnFailHour"));
        }
        if(GetLocalInt(oPC, "WWWolf"))
            SetPersistantLocalInt(oPC, "PRC_WW_ActiveForm", PRC_WW_FORM_WOLF);
        else if(GetLocalInt(oPC, "WWHybrid"))
            SetPersistantLocalInt(oPC, "PRC_WW_ActiveForm", PRC_WW_FORM_HYBRID);

        int nLegacy = GetLocalInt(oPC, "PRC_WW_LastMoonCheck");
        if(nLegacy)
            SetPersistantLocalInt(oPC, "PRC_WW_LastMoonCheck", nLegacy);
        nLegacy = GetLocalInt(oPC, "PRC_WW_HPQuarter");
        if(nLegacy)
            SetPersistantLocalInt(oPC, "PRC_WW_HPQuarter", nLegacy);

        SetPersistantLocalInt(oPC, "PRC_WW_StateVersion",
            PRC_WW_STATE_VERSION_CURRENT);
        nVersion = PRC_WW_STATE_VERSION_CURRENT;
    }

    SetLocalInt(oPC, "PRC_WW_StateVersion", nVersion);
    SetLocalInt(oPC, "PRC_WW_ActiveForm",
        GetPersistantLocalInt(oPC, "PRC_WW_ActiveForm"));
    SetLocalInt(oPC, "PRC_WW_Involuntary",
        GetPersistantLocalInt(oPC, "PRC_WW_Involuntary"));
    SetLocalInt(oPC, "PRC_WW_SavedAlignment",
        GetPersistantLocalInt(oPC, "PRC_WW_SavedAlignment"));
    SetLocalInt(oPC, "PRC_WW_SavedLawChaos",
        GetPersistantLocalInt(oPC, "PRC_WW_SavedLawChaos"));
    SetLocalInt(oPC, "PRC_WW_SavedGoodEvil",
        GetPersistantLocalInt(oPC, "PRC_WW_SavedGoodEvil"));
    SetLocalInt(oPC, "PRC_WW_ForcedDate",
        GetPersistantLocalInt(oPC, "PRC_WW_ForcedDate"));
    SetLocalInt(oPC, "PRC_WW_ForcedHour",
        GetPersistantLocalInt(oPC, "PRC_WW_ForcedHour"));
    SetLocalInt(oPC, "PRC_WW_DawnHourKey",
        GetPersistantLocalInt(oPC, "PRC_WW_DawnHourKey"));
    SetLocalInt(oPC, "PRC_WW_ReturnLocked",
        GetPersistantLocalInt(oPC, "PRC_WW_ReturnLocked"));
    SetLocalInt(oPC, "PRC_WW_ReturnFailDate",
        GetPersistantLocalInt(oPC, "PRC_WW_ReturnFailDate"));
    SetLocalInt(oPC, "PRC_WW_ReturnFailHour",
        GetPersistantLocalInt(oPC, "PRC_WW_ReturnFailHour"));
    SetLocalInt(oPC, "PRC_WW_ReturnDawnHourKey",
        GetPersistantLocalInt(oPC, "PRC_WW_ReturnDawnHourKey"));
    SetLocalInt(oPC, "PRC_WW_LastMoonCheck",
        GetPersistantLocalInt(oPC, "PRC_WW_LastMoonCheck"));
    SetLocalInt(oPC, "PRC_WW_HPQuarter",
        GetPersistantLocalInt(oPC, "PRC_WW_HPQuarter"));
    SetLocalInt(oPC, "PRC_WW_HPMax",
        GetPersistantLocalInt(oPC, "PRC_WW_HPMax"));
    SetLocalInt(oPC, "PRC_WW_FormAlignmentCommitted",
        GetPersistantLocalInt(oPC, "PRC_WW_FormAlignmentCommitted"));

    int nDawn = GetLocalInt(oPC, "PRC_WW_DawnHourKey");
    if(GetLocalInt(oPC, "PRC_WW_Involuntary") && !nDawn)
    {
        nDawn = PRCWWLegacyDawnHourKey(
            GetLocalInt(oPC, "PRC_WW_ForcedDate"),
            GetLocalInt(oPC, "PRC_WW_ForcedHour"));
        if(!nDawn)
            nDawn = PRCWWNextDawnHourKey();
        PRCWWSetStateInt(oPC, "PRC_WW_DawnHourKey", nDawn);
    }

    nDawn = GetLocalInt(oPC, "PRC_WW_ReturnDawnHourKey");
    if(GetLocalInt(oPC, "PRC_WW_ReturnLocked") && !nDawn)
    {
        nDawn = PRCWWLegacyDawnHourKey(
            GetLocalInt(oPC, "PRC_WW_ReturnFailDate"),
            GetLocalInt(oPC, "PRC_WW_ReturnFailHour"));
        if(!nDawn)
            nDawn = PRCWWNextDawnHourKey();
        PRCWWSetStateInt(oPC, "PRC_WW_ReturnDawnHourKey", nDawn);
    }

    SetLocalInt(oPC, PRC_WW_STATE_LOADED, TRUE);
}

int PRCWWGetActiveForm(object oPC)
{
    PRCWWLoadPersistentState(oPC);
    return GetLocalInt(oPC, "PRC_WW_ActiveForm");
}

void PRCWWSetActiveForm(object oPC, int nForm)
{
    if(nForm == PRC_WW_FORM_NONE)
        PRCWWDeleteStateInt(oPC, "PRC_WW_ActiveForm");
    else
        PRCWWSetStateInt(oPC, "PRC_WW_ActiveForm", nForm);
}

void PRCWWClearInjuryState(object oPC, string sReason = "reset")
{
    PRCWWDeleteStateInt(oPC, "PRC_WW_HPQuarter");
    PRCWWDeleteStateInt(oPC, "PRC_WW_HPMax");
    PRCWWDebug("injury-baseline", oPC, "reason=" + sReason + " cleared=1");
}

void PRCWWBaselineInjury(object oPC, string sReason = "initialize")
{
    if(GetIsDead(oPC))
    {
        PRCWWClearInjuryState(oPC, "death-reset");
        return;
    }

    int nMaxHP = GetMaxHitPoints(oPC);
    if(nMaxHP < 1)
    {
        PRCWWClearInjuryState(oPC, sReason);
        return;
    }

    int nHP = GetCurrentHitPoints(oPC);
    if(nHP < 0)
        nHP = 0;
    if(nHP > nMaxHP)
        nHP = nMaxHP;
    int nQuarter = (nHP * 4 + nMaxHP - 1) / nMaxHP;
    PRCWWSetStateInt(oPC, "PRC_WW_HPQuarter", nQuarter + 1);
    PRCWWSetStateInt(oPC, "PRC_WW_HPMax", nMaxHP);
    PRCWWDebug("injury-baseline", oPC,
        "reason=" + sReason
        + " quarter=" + IntToString(nQuarter)
        + " hp=" + IntToString(nHP)
        + " max=" + IntToString(nMaxHP));
}

void PRCWWResetRuntimeState(object oPC)
{
    PRCWWDeleteStateInt(oPC, "PRC_WW_ActiveForm");
    PRCWWDeleteStateInt(oPC, "PRC_WW_Involuntary");
    PRCWWDeleteStateInt(oPC, "PRC_WW_SavedAlignment");
    PRCWWDeleteStateInt(oPC, "PRC_WW_SavedLawChaos");
    PRCWWDeleteStateInt(oPC, "PRC_WW_SavedGoodEvil");
    PRCWWDeleteStateInt(oPC, "PRC_WW_ForcedDate");
    PRCWWDeleteStateInt(oPC, "PRC_WW_ForcedHour");
    PRCWWDeleteStateInt(oPC, "PRC_WW_DawnHourKey");
    PRCWWDeleteStateInt(oPC, "PRC_WW_ReturnLocked");
    PRCWWDeleteStateInt(oPC, "PRC_WW_ReturnFailDate");
    PRCWWDeleteStateInt(oPC, "PRC_WW_ReturnFailHour");
    PRCWWDeleteStateInt(oPC, "PRC_WW_ReturnDawnHourKey");
    PRCWWDeleteStateInt(oPC, "PRC_WW_FormAlignmentCommitted");
    PRCWWDeleteStateInt(oPC, "PRC_WW_LastMoonCheck");
    PRCWWClearInjuryState(oPC, "reset");
    DeleteLocalInt(oPC, "WWWolf");
    DeleteLocalInt(oPC, "WWHybrid");
    DeleteLocalInt(oPC, "PRC_WW_ControlBypass");
    DeleteLocalInt(oPC, PRC_WW_RECONSTRUCTING);
    DeleteLocalInt(oPC, PRC_WW_VOLUNTARY_TRANSITION);
    PRCWWClearFormSwitchState(oPC);
    DeleteLocalInt(oPC, "PRC_WW_ReconstructFailed");
    DeleteLocalInt(oPC, PRC_WW_FORM_TRANSITION);
    DeleteLocalInt(oPC, PRC_WW_FORM_EVAL_QUEUED);
    DeleteLocalInt(oPC, PRC_WW_FORM_LIGHT_EVAL);
    DeletePersistantLocalInt(oPC, "PRC_WW_StateVersion");
    DeleteLocalInt(oPC, "PRC_WW_StateVersion");
    DeleteLocalInt(oPC, PRC_WW_STATE_LOADED);
}

int PRCWWFullMoonStartDay()
{
    int nStart = GetLocalInt(GetModule(), "PRC_WEREWOLF_FULL_MOON_START_DAY");
    if(nStart < 1 || nStart > 26)
        nStart = 13;
    return nStart;
}

int PRCWWIsFullMoon()
{
    int nStart = PRCWWFullMoonStartDay();
    int nDay = GetCalendarDay();
    return nDay >= nStart && nDay <= nStart + 2;
}

int PRCWWFirstFullMoonReached(object oPC)
{
    if(GetPersistantLocalInt(oPC, "PRC_WW_Manifested"))
        return TRUE;

    int nInfectionDate = GetPersistantLocalInt(oPC, "PRC_WW_InfectionDate");
    if(!nInfectionDate)
        return TRUE;

    int nInfectionMonth = nInfectionDate / 100;
    int nInfectionDay = nInfectionDate - nInfectionMonth * 100;
    int nCurrentMonth = GetCalendarYear() * 100 + GetCalendarMonth();
    int nStart = PRCWWFullMoonStartDay();

    if(nCurrentMonth > nInfectionMonth)
        return TRUE;
    if(nCurrentMonth < nInfectionMonth)
        return FALSE;

    if(nInfectionDay < nStart)
        return TRUE;
    if(nInfectionDay == nStart
    && GetPersistantLocalInt(oPC, "PRC_WW_InfectionHour") < 18)
        return TRUE;
    return FALSE;
}

int PRCWWWithinEarlyCureWindow(object oPC)
{
    int nInfectionHour = GetPersistantLocalInt(oPC, "PRC_WW_InfectionHourKey");
    if(!nInfectionHour)
        return FALSE;

    int nElapsed = PRCWWHourKey() - nInfectionHour;
    return nElapsed >= 0 && nElapsed <= 72;
}

int PRCWWControlCheck(object oPC, int nDC, string sTask,
    int bReportToPlayer = TRUE)
{
    int nModifier = GetAbilityModifier(ABILITY_WISDOM, oPC);
    int nRoll = d20() + nModifier;
    int bSuccess = nRoll >= nDC;
    string sResult = bSuccess ? "PASS" : "FAIL";

    if(bReportToPlayer && GetIsPC(oPC))
        SendMessageToPC(oPC, "Control Shape (Wisdom) - " + sTask + ": "
            + IntToString(nRoll) + " vs DC " + IntToString(nDC)
            + " (" + sResult + ")");

    PRCWWDebug("control-check", oPC,
        "task=" + sTask
        + " wis_mod=" + IntToString(nModifier)
        + " total=" + IntToString(nRoll)
        + " dc=" + IntToString(nDC)
        + " result=" + sResult
        + " player_report=" + IntToString(bReportToPlayer));
    return bSuccess;
}

void PRCWWSetAlignment(object oPC, int nLawChaos, int nGoodEvil,
    string sReason = "")
{
    int nOldLawChaos = GetLawChaosValue(oPC);
    int nOldGoodEvil = GetGoodEvilValue(oPC);
    int nCurrent = nOldLawChaos;
    if(nLawChaos > nCurrent)
        AdjustAlignment(oPC, ALIGNMENT_LAWFUL, nLawChaos - nCurrent, FALSE);
    else if(nLawChaos < nCurrent)
        AdjustAlignment(oPC, ALIGNMENT_CHAOTIC, nCurrent - nLawChaos, FALSE);

    nCurrent = GetGoodEvilValue(oPC);
    if(nGoodEvil > nCurrent)
        AdjustAlignment(oPC, ALIGNMENT_GOOD, nGoodEvil - nCurrent, FALSE);
    else if(nGoodEvil < nCurrent)
        AdjustAlignment(oPC, ALIGNMENT_EVIL, nCurrent - nGoodEvil, FALSE);

    int nNewLawChaos = GetLawChaosValue(oPC);
    int nNewGoodEvil = GetGoodEvilValue(oPC);
    if(nOldLawChaos != nNewLawChaos || nOldGoodEvil != nNewGoodEvil)
        PRCWWDebug("alignment-change", oPC,
            "reason=" + sReason
            + " law_chaos=" + IntToString(nOldLawChaos)
            + "->" + IntToString(nNewLawChaos)
            + " good_evil=" + IntToString(nOldGoodEvil)
            + "->" + IntToString(nNewGoodEvil));
}

void PRCWWCommitVoluntaryAlignment(object oPC)
{
    if(PRCWWHasSeluniteControl(oPC))
        return;

    int bVoluntaryTransition = GetLocalInt(oPC, PRC_WW_VOLUNTARY_TRANSITION);
    if(!PRCWWHasAfflictedTemplate(oPC)
    || !GetPersistantLocalInt(oPC, "PRC_WW_Aware")
    || (GetLocalInt(oPC, "PRC_WW_Involuntary") && !bVoluntaryTransition)
    || GetLocalInt(oPC, "PRC_WW_FormAlignmentCommitted"))
        return;

    int bFirstEmbrace = !GetPersistantLocalInt(oPC, "PRC_WW_Embraced");
    PRCWWSetAlignment(oPC, 0, 0, "voluntary-change");
    SetPersistantLocalInt(oPC, "PRC_WW_Embraced", TRUE);
    PRCWWSetStateInt(oPC, "PRC_WW_FormAlignmentCommitted", TRUE);

    // Voluntarily switching forms during a forced episode embraces the
    // werewolf alignment permanently. Keep the dawn deadline/return lock,
    // but discard the old alignment so dawn cannot undo that choice.
    if(bVoluntaryTransition && GetLocalInt(oPC, "PRC_WW_Involuntary"))
    {
        PRCWWDeleteStateInt(oPC, "PRC_WW_SavedAlignment");
        PRCWWDeleteStateInt(oPC, "PRC_WW_SavedLawChaos");
        PRCWWDeleteStateInt(oPC, "PRC_WW_SavedGoodEvil");
    }
    if(bFirstEmbrace && GetIsPC(oPC))
        FloatingTextStringOnCreature(
            "You embrace the beast within; your alignment becomes chaotic evil.",
            oPC, FALSE);
    if(bFirstEmbrace)
        PRCWWDebug("alignment-embraced", oPC,
            "permanent=1 alignment=chaotic-evil");
}

int PRCWWCanChange(object oPC, int bReturning)
{
    // Trusted forced/reconstruction paths must be able to finish even while a
    // failed staged handoff still owns the pending guard.
    if(GetLocalInt(oPC, "PRC_WW_ControlBypass"))
        return TRUE;

    if(GetLocalInt(oPC, PRC_WW_FORM_SWITCH_PENDING)
    || PRCWWIsHybridSettling(oPC))
    {
        FloatingTextStringOnCreature(
            "Your current transformation is still settling.", oPC, FALSE);
        PRCWWDebug("voluntary-change-denied", oPC,
            "reason=form-switch-pending");
        return FALSE;
    }

    if(!PRCWWHasAfflictedTemplate(oPC))
        return TRUE;

    PRCWWLoadPersistentState(oPC);

    if(PRCWWHasSeluniteControl(oPC))
        return TRUE;

    if(!GetPersistantLocalInt(oPC, "PRC_WW_Aware"))
    {
        FloatingTextStringOnCreature("That change is beyond your conscious control.", oPC, FALSE);
        PRCWWDebug("voluntary-change-denied", oPC, "reason=unaware");
        return FALSE;
    }

    if(bReturning && GetLocalInt(oPC, "PRC_WW_ReturnLocked"))
    {
        FloatingTextStringOnCreature("A failed Control Shape check keeps you in this form until dawn.", oPC, FALSE);
        return FALSE;
    }

    int nDC;
    if(bReturning)
        nDC = PRCWWIsFullMoon() ? 25 : 20;
    else
        nDC = PRCWWIsFullMoon() ? 10 : 15;

    if(!PRCWWControlCheck(oPC, nDC, bReturning ? "return to humanoid form" : "voluntary change"))
    {
        if(bReturning)
        {
            PRCWWSetStateInt(oPC, "PRC_WW_ReturnLocked", TRUE);
            PRCWWSetStateInt(oPC, "PRC_WW_ReturnFailDate", PRCWWDateKey());
            PRCWWSetStateInt(oPC, "PRC_WW_ReturnFailHour", GetTimeHour());
            PRCWWSetStateInt(oPC, "PRC_WW_ReturnDawnHourKey",
                PRCWWNextDawnHourKey());
        }
        return FALSE;
    }

    return TRUE;
}

int PRCWWHasPolymorphEffect(object oPC)
{
    effect eEffect = GetFirstEffect(oPC);
    while(GetIsEffectValid(eEffect))
    {
        if(GetEffectType(eEffect) == EFFECT_TYPE_POLYMORPH)
            return TRUE;
        eEffect = GetNextEffect(oPC);
    }
    return FALSE;
}

int PRCWWDetectTemplateForm(object oPC)
{
    if(PRCWWHasHybrid(oPC))
        return PRC_WW_FORM_HYBRID;

    if(!PRCWWHasPolymorphEffect(oPC))
        return PRC_WW_FORM_NONE;

    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);
    if(!GetIsObjectValid(oSkin) || GetResRef(oSkin) != "werewolfskin2s")
        return PRC_WW_FORM_NONE;

    int nAppearance = GetAppearanceType(oPC);
    if(nAppearance == 181)
        return PRC_WW_FORM_WOLF;
    if(nAppearance == 171)
        return PRC_WW_FORM_HYBRID;
    return PRC_WW_FORM_NONE;
}

int PRCWWHasTemplateFormEffect(object oPC)
{
    return PRCWWDetectTemplateForm(oPC) != PRC_WW_FORM_NONE;
}

void PRCWWRemoveFormSpeed(object oPC)
{
    effect eEffect = GetFirstEffect(oPC);
    while(GetIsEffectValid(eEffect))
    {
        if(GetEffectTag(eEffect) == "PRCWWFormSpeed")
            RemoveEffect(oPC, eEffect);
        eEffect = GetNextEffect(oPC);
    }
}

void PRCWWApplyFormProperties(object oPC, int bHybrid)
{
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);
    int bEquippedHybrid = bHybrid && PRCWWHasHybrid(oPC);
    if(!GetIsObjectValid(oSkin)
    || (!bEquippedHybrid && GetResRef(oSkin) != "werewolfskin2s"))
        return;

    // The printed wolf and hybrid speed is 50 feet. Request +67% from a
    // normal 30-foot base; stock NWN's default movement cap may clamp this
    // to +50%, but tagging the supernatural effect makes cleanup exact.
    PRCWWRemoveFormSpeed(oPC);
    effect eSpeed = SupernaturalEffect(EffectMovementSpeedIncrease(67));
    eSpeed = TagEffect(eSpeed, "PRCWWFormSpeed");
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSpeed, oPC);

    // PnP-style hybrid keeps the real PRC skin and all ordinary equipment.
    // Do not copy replacement-hide totals onto it or scrub unrelated traits.
    if(bEquippedHybrid)
    {
        PRCWWUpdateTemplateSkin(oPC, TRUE);
        PRCWWRefreshHybrid(oPC);
        return;
    }

    // The existing "s" form hides carry DR 5/+1. Replace that staged
    // value with the D&D 3.0 werewolf's DR 15. NWN represents the +1
    // bypass natively but cannot combine it with a material bypass.
    RemoveSpecificProperty(oSkin, ITEM_PROPERTY_DAMAGE_REDUCTION,
        IP_CONST_DAMAGEREDUCTION_1, IP_CONST_DAMAGESOAK_5_HP, -1);
    RemoveSpecificProperty(oSkin, ITEM_PROPERTY_DAMAGE_REDUCTION,
        IP_CONST_DAMAGEREDUCTION_1, IP_CONST_DAMAGESOAK_10_HP, -1);
    RemoveSpecificProperty(oSkin, ITEM_PROPERTY_DAMAGE_REDUCTION,
        IP_CONST_DAMAGEREDUCTION_1, IP_CONST_DAMAGESOAK_15_HP, -1);
    IPSafeAddItemProperty(oSkin,
        ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_1, IP_CONST_DAMAGESOAK_15_HP),
        0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);

    SetCompositeBonus(oSkin, "PRCWWFormFort", 2,
        ITEM_PROPERTY_SAVING_THROW_BONUS, SAVING_THROW_FORT);
    SetCompositeBonus(oSkin, "PRCWWFormWill", 2,
        ITEM_PROPERTY_SAVING_THROW_BONUS, SAVING_THROW_WILL);
    SetCompositeBonus(oSkin, "PRCWWFormListen", 8,
        ITEM_PROPERTY_SKILL_BONUS, SKILL_LISTEN);
    SetCompositeBonus(oSkin, "PRCWWFormSearch", 8,
        ITEM_PROPERTY_SKILL_BONUS, SKILL_SEARCH);
    SetCompositeBonus(oSkin, "PRCWWFormSpot", 8,
        ITEM_PROPERTY_SKILL_BONUS, SKILL_SPOT);
    SetCompositeBonus(oSkin, "PRCWWFormEmpathy", 4,
        ITEM_PROPERTY_SKILL_BONUS, SKILL_ANIMAL_EMPATHY);

    IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_LOWLIGHT_VISION),
        0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_SCENT),
        0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_BLINDFIGHT),
        0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_INIT),
        0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_FINESSE),
        0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    // The dedicated template polymorph rows do not merge the humanoid PRC
    // skin. Put the radial controls and marker on the form hide as well, but
    // do not disclose the forms to an afflicted victim before the printed
    // post-episode awareness check succeeds.
    if(!PRCWWHasAfflictedTemplate(oPC)
    || GetPersistantLocalInt(oPC, "PRC_WW_Aware"))
    {
        IPSafeAddItemProperty(oSkin,
            PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_WEREWOLF_WOLF_FORM),
            0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        IPSafeAddItemProperty(oSkin,
            PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_WEREWOLF_HYBRID_FORM),
            0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        IPSafeAddItemProperty(oSkin,
            PRCItemPropertyBonusFeat(IP_CONST_FEAT_TEMPLATE_WEREWOLF_SHAPECHANGER),
            0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    }
    else
    {
        RemoveSpecificProperty(oSkin, ITEM_PROPERTY_BONUS_FEAT,
            IP_CONST_FEAT_TEMPLATE_WEREWOLF_WOLF_FORM, -1, -1);
        RemoveSpecificProperty(oSkin, ITEM_PROPERTY_BONUS_FEAT,
            IP_CONST_FEAT_TEMPLATE_WEREWOLF_HYBRID_FORM, -1, -1);
        RemoveSpecificProperty(oSkin, ITEM_PROPERTY_BONUS_FEAT,
            IP_CONST_FEAT_TEMPLATE_WEREWOLF_SHAPECHANGER, -1, -1);
    }

    object oBite = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oPC);
    if(GetIsObjectValid(oBite))
    {
        IPSafeAddItemProperty(oBite,
            ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1),
            0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        AddEventScript(oBite, EVENT_ITEM_ONHIT, "prc_wwcurse", TRUE, FALSE);
    }

    // The 3.0 werewolf sample uses bite in hybrid form, not the later
    // claw/claw/bite routine encoded by the old staged class asset.
    if(bHybrid)
    {
        object oClaw = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC);
        string sResRef;
        if(GetIsObjectValid(oClaw))
        {
            sResRef = GetResRef(oClaw);
            if(sResRef == "werewolfclaw" || sResRef == "werewolfclawl")
                DestroyObject(oClaw);
        }

        oClaw = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oPC);
        if(GetIsObjectValid(oClaw))
        {
            sResRef = GetResRef(oClaw);
            if(sResRef == "werewolfclaw" || sResRef == "werewolfclawl")
                DestroyObject(oClaw);
        }
    }
}

void PRCWWUpdateTemplateSkin(object oPC, int bHybrid)
{
    object oSkin = GetPCSkin(oPC);
    if(!GetIsObjectValid(oSkin))
        return;

    // Update the existing template contribution, not a second stacking copy.
    SetCompositeBonus(oSkin, "Template_WWerewolf_AC", bHybrid ? 4 : 2,
        ITEM_PROPERTY_AC_BONUS);
    SetCompositeBonus(oSkin, "Template_WWerewolf_Fort", 2,
        ITEM_PROPERTY_SAVING_THROW_BONUS, SAVING_THROW_FORT);
    SetCompositeBonus(oSkin, "Template_WWerewolf_Will", 2,
        ITEM_PROPERTY_SAVING_THROW_BONUS, SAVING_THROW_WILL);
    SetCompositeBonus(oSkin, "Template_WWerewolf_Listen", bHybrid ? 8 : 4,
        ITEM_PROPERTY_SKILL_BONUS, SKILL_LISTEN);
    SetCompositeBonus(oSkin, "Template_WWerewolf_Search", bHybrid ? 8 : 4,
        ITEM_PROPERTY_SKILL_BONUS, SKILL_SEARCH);
    SetCompositeBonus(oSkin, "Template_WWerewolf_Spot", bHybrid ? 8 : 4,
        ITEM_PROPERTY_SKILL_BONUS, SKILL_SPOT);
    SetCompositeBonus(oSkin, "Template_WWerewolf_Empathy", 4,
        ITEM_PROPERTY_SKILL_BONUS, SKILL_ANIMAL_EMPATHY);
}

void PRCWWRefreshWolfForm(object oPC)
{
    if(PRCWWHasTemplate(oPC) && GetLocalInt(oPC, "WWWolf")
    && PRCWWHasTemplateFormEffect(oPC))
        PRCWWApplyFormProperties(oPC, FALSE);
}

void PRCWWRefreshHybridForm(object oPC)
{
    if(PRCWWHasTemplate(oPC) && GetLocalInt(oPC, "WWHybrid")
    && PRCWWHasTemplateFormEffect(oPC))
        PRCWWApplyFormProperties(oPC, TRUE);
}

void PRCWWOnAssumeForm(object oPC)
{
    PRCWWLoadPersistentState(oPC);
    DeleteLocalInt(oPC, "PRC_WW_ReconstructFailed");
    if(GetLocalInt(oPC, "WWWolf"))
        PRCWWSetActiveForm(oPC, PRC_WW_FORM_WOLF);
    else if(GetLocalInt(oPC, "WWHybrid"))
        PRCWWSetActiveForm(oPC, PRC_WW_FORM_HYBRID);

    // Commit the permanent alignment consequence only after the form really
    // exists. A passed check followed by an engine polymorph failure must not
    // change alignment.
    PRCWWCommitVoluntaryAlignment(oPC);
    DeleteLocalInt(oPC, PRC_WW_VOLUNTARY_TRANSITION);

    // Rebuilding an interrupted form is continuity, not a new change, and
    // must not grant the normal transformation healing a second time.
    if(GetLocalInt(oPC, PRC_WW_RECONSTRUCTING))
        return;

    int nHealing = GetHitDice(oPC);
    // A wolf has 2 HD; D&D 3.0 uses the character's or animal's HD,
    // whichever is greater, when the number of Hit Dice matters.
    if(nHealing < 2)
        nHealing = 2;
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nHealing), oPC);
}

void PRCWWRestoreInvoluntaryAlignment(object oPC)
{
    PRCWWLoadPersistentState(oPC);
    if(!GetLocalInt(oPC, "PRC_WW_SavedAlignment"))
        return;

    PRCWWSetAlignment(oPC,
        GetLocalInt(oPC, "PRC_WW_SavedLawChaos"),
        GetLocalInt(oPC, "PRC_WW_SavedGoodEvil"),
        "involuntary-form-ended");
    PRCWWDeleteStateInt(oPC, "PRC_WW_SavedAlignment");
    PRCWWDeleteStateInt(oPC, "PRC_WW_SavedLawChaos");
    PRCWWDeleteStateInt(oPC, "PRC_WW_SavedGoodEvil");
}

void PRCWWOnReturnHumanoid(object oPC)
{
    PRCWWRemoveHybrid(oPC);
    PRCWWUpdateTemplateSkin(oPC, FALSE);
    DeleteLocalInt(oPC, "PRC_WW_HybSuspended");
    PRCWWLoadPersistentState(oPC);
    int bInvoluntary = GetLocalInt(oPC, "PRC_WW_Involuntary");
    PRCWWClearFormSwitchState(oPC);
    DeleteLocalInt(oPC, PRC_WW_VOLUNTARY_TRANSITION);
    PRCWWRemoveFormSpeed(oPC);

    if(GetLocalInt(oPC, "PRC_WW_SavedAlignment"))
        PRCWWRestoreInvoluntaryAlignment(oPC);

    PRCWWSetActiveForm(oPC, PRC_WW_FORM_NONE);
    PRCWWDeleteStateInt(oPC, "PRC_WW_Involuntary");
    PRCWWDeleteStateInt(oPC, "PRC_WW_ForcedDate");
    PRCWWDeleteStateInt(oPC, "PRC_WW_ForcedHour");
    PRCWWDeleteStateInt(oPC, "PRC_WW_DawnHourKey");
    DeleteLocalInt(oPC, "PRC_WW_ControlBypass");
    PRCWWDeleteStateInt(oPC, "PRC_WW_ReturnLocked");
    PRCWWDeleteStateInt(oPC, "PRC_WW_ReturnFailDate");
    PRCWWDeleteStateInt(oPC, "PRC_WW_ReturnFailHour");
    PRCWWDeleteStateInt(oPC, "PRC_WW_ReturnDawnHourKey");
    PRCWWDeleteStateInt(oPC, "PRC_WW_FormAlignmentCommitted");
    if(PRCWWHasAfflictedTemplate(oPC)
    && GetPersistantLocalInt(oPC, "PRC_WW_Manifested"))
        PRCWWBaselineInjury(oPC, "form-return");
    PRCWWDebug("return-humanoid", oPC,
        "involuntary=" + IntToString(bInvoluntary));
}

void PRCWWBeginFormTransition(object oPC)
{
    SetLocalInt(oPC, PRC_WW_FORM_TRANSITION, TRUE);
}

void PRCWWClearFormSwitchState(object oPC)
{
    DeleteLocalInt(oPC, PRC_WW_FORM_SWITCH_PENDING);
    DeleteLocalInt(oPC, PRC_WW_FORM_SWITCH_SOURCE);
    DeleteLocalInt(oPC, PRC_WW_FORM_SWITCH_RESUME);
    DeleteLocalInt(oPC, PRC_WW_FORM_SWITCH_FAILED);
}

int PRCWWStartFormSwitch(object oPC, int nTargetForm)
{
    if(!PRCWWHasTemplate(oPC)
    || (nTargetForm != PRC_WW_FORM_WOLF
        && nTargetForm != PRC_WW_FORM_HYBRID))
        return FALSE;

    if(GetLocalInt(oPC, PRC_WW_FORM_SWITCH_PENDING))
    {
        FloatingTextStringOnCreature(
            "Your current transformation is still settling.", oPC, FALSE);
        return FALSE;
    }

    int nSourceForm = nTargetForm == PRC_WW_FORM_WOLF
        ? PRC_WW_FORM_HYBRID : PRC_WW_FORM_WOLF;
    if((nSourceForm == PRC_WW_FORM_WOLF && !GetLocalInt(oPC, "WWWolf"))
    || (nSourceForm == PRC_WW_FORM_HYBRID && !GetLocalInt(oPC, "WWHybrid")))
        return FALSE;
    if(PRCWWDetectTemplateForm(oPC) != nSourceForm)
    {
        PRCWWDebug("form-switch-result", oPC,
            "result=CANCEL reason=source-form-mismatch source="
            + IntToString(nSourceForm)
            + " target=" + IntToString(nTargetForm));
        return FALSE;
    }

    // Animal <-> hybrid is one voluntary change. Roll once here; the delayed
    // destination script consumes the already-approved transition.
    if(!PRCWWCanChange(oPC, FALSE))
        return FALSE;

    object oOldFormSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);
    SetLocalInt(oPC, PRC_WW_VOLUNTARY_TRANSITION, TRUE);
    SetLocalInt(oPC, PRC_WW_FORM_SWITCH_PENDING, nTargetForm);
    SetLocalInt(oPC, PRC_WW_FORM_SWITCH_SOURCE, nSourceForm);
    PRCWWBeginFormTransition(oPC);
    PRCWWDebug("form-switch-start", oPC,
        "source=" + IntToString(nSourceForm)
        + " target=" + IntToString(nTargetForm));

    ExecuteScript("prc_wwunpoly", oPC);

    // Removing EffectPolymorph drops it from the effect list immediately, but
    // NWN restores the real appearance/equipment later. PRC shifting already
    // uses this creature-armour watch to detect genuine teardown completion.
    DelayCommand(0.1f, PRCWWWaitForFormSwitchRemoval(
        oPC, oOldFormSkin, nTargetForm, 0));
    return TRUE;
}

void PRCWWWaitForFormSwitchRemoval(object oPC, object oOldFormSkin,
    int nTargetForm, int nRepeats)
{
    if(!GetIsObjectValid(oPC)
    || GetLocalInt(oPC, PRC_WW_FORM_SWITCH_PENDING) != nTargetForm)
        return;

    if(GetIsDead(oPC) || !PRCWWHasTemplate(oPC))
    {
        PRCWWClearFormSwitchState(oPC);
        DeleteLocalInt(oPC, PRC_WW_VOLUNTARY_TRANSITION);
        PRCWWQueueFormTransitionEval(oPC);
        return;
    }

    int nSourceForm = GetLocalInt(oPC, PRC_WW_FORM_SWITCH_SOURCE);
    if(nRepeats > 100)
    {
        PRCWWDebug("form-switch-result", oPC,
            "result=TIMEOUT stage=remove source=" + IntToString(nSourceForm)
            + " target=" + IntToString(nTargetForm));

        // If the outgoing form never actually left, cancel cleanly in place.
        if(PRCWWDetectTemplateForm(oPC) == nSourceForm)
        {
            PRCWWClearFormSwitchState(oPC);
            DeleteLocalInt(oPC, PRC_WW_VOLUNTARY_TRANSITION);
            PRCWWQueueFormTransitionEval(oPC);
            FloatingTextStringOnCreature(
                "The transformation does not complete; you remain in your current form.",
                oPC, FALSE);
        }
        else
            DelayCommand(1.0f, PRCWWRestoreFormSwitchSource(oPC, nSourceForm));
        return;
    }

    object oCurrentSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);
    // Appearance-only hybrid retains the same real skin on return. A native
    // wolf (including the older native hybrid) still needs the skin swap.
    int bOldSkinStillPresent = oCurrentSkin == oOldFormSkin
        && GetResRef(oOldFormSkin) == "werewolfskin2s";
    if(!GetIsObjectValid(oCurrentSkin) || bOldSkinStillPresent
    || PRCWWHasTemplateFormEffect(oPC) || PRCWWIsHybridSettling(oPC))
    {
        DelayCommand(0.15f, PRCWWWaitForFormSwitchRemoval(
            oPC, oOldFormSkin, nTargetForm, nRepeats + 1));
        return;
    }

    PRCWWDebug("form-switch-humanoid", oPC,
        "source=" + IntToString(nSourceForm)
        + " target=" + IntToString(nTargetForm)
        + " teardown_checks=" + IntToString(nRepeats + 1));

    // Match PRC's conservative reshift gap. This visibly passes through the
    // character's true humanoid form and lets all equipment callbacks settle.
    DelayCommand(1.0f, PRCWWCompleteFormSwitch(oPC, nTargetForm));
}

void PRCWWCompleteFormSwitch(object oPC, int nTargetForm)
{
    if(!GetIsObjectValid(oPC)
    || GetLocalInt(oPC, PRC_WW_FORM_SWITCH_PENDING) != nTargetForm)
        return;

    int nSourceForm = GetLocalInt(oPC, PRC_WW_FORM_SWITCH_SOURCE);
    if(GetIsDead(oPC) || !PRCWWHasTemplate(oPC))
    {
        PRCWWClearFormSwitchState(oPC);
        DeleteLocalInt(oPC, PRC_WW_VOLUNTARY_TRANSITION);
        PRCWWQueueFormTransitionEval(oPC);
        return;
    }

    // Do not overwrite an unrelated polymorph applied during the humanoid gap.
    if(PRCWWHybHasOtherShape(oPC))
    {
        PRCWWDebug("form-switch-result", oPC,
            "result=CANCEL reason=intervening-polymorph source="
            + IntToString(nSourceForm)
            + " target=" + IntToString(nTargetForm));
        PRCWWClearFormSwitchState(oPC);
        DeleteLocalInt(oPC, PRC_WW_VOLUNTARY_TRANSITION);
        PRCWWQueueFormTransitionEval(oPC);
        return;
    }

    DeleteLocalInt(oPC, "WWWolf");
    DeleteLocalInt(oPC, "WWHybrid");
    DeleteLocalInt(oPC, PRC_WW_FORM_SWITCH_FAILED);
    SetLocalInt(oPC, PRC_WW_FORM_SWITCH_RESUME, nTargetForm);
    PRCWWDeleteStateInt(oPC, "PRC_WW_FormAlignmentCommitted");
    PRCWWDebug("form-switch-apply", oPC,
        "source=" + IntToString(nSourceForm)
        + " target=" + IntToString(nTargetForm));

    if(nTargetForm == PRC_WW_FORM_HYBRID)
        ExecuteScript("prc_wwhybridwolf", oPC);
    else
        ExecuteScript("prc_wwformwolf", oPC);
    DeleteLocalInt(oPC, PRC_WW_FORM_SWITCH_RESUME);

    int nDetectedForm = PRCWWDetectTemplateForm(oPC);
    int bTargetFlag = nTargetForm == PRC_WW_FORM_HYBRID
        ? GetLocalInt(oPC, "WWHybrid") : GetLocalInt(oPC, "WWWolf");
    int bSuccess = nDetectedForm == nTargetForm && bTargetFlag
        && !GetLocalInt(oPC, PRC_WW_FORM_SWITCH_FAILED);

    if(bSuccess)
    {
        // Keep the pending guard through the destination's own equipment
        // callbacks. The original unpoly evaluator may be on any 0.3-second
        // phase, so releasing immediately could run it before the 0.15/0.2
        // weapon queues have settled.
        PRCWWDebug("form-switch-applied", oPC,
            "source=" + IntToString(nSourceForm)
            + " target=" + IntToString(nTargetForm)
            + " settle=0.3");
        DelayCommand(0.3f, PRCWWFinalizeFormSwitch(oPC, nTargetForm));
        return;
    }

    // No polymorph existed immediately before the destination call, so any
    // effect now present belongs to that failed application even when its
    // generated skin is malformed and template-form detection cannot name it.
    int bHadFailedForm = PRCWWHasPolymorphEffect(oPC)
        || PRCWWHasHybridData(oPC);
    object oFailedFormSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);
    if(bHadFailedForm)
        ExecuteScript("prc_wwunpoly", oPC);
    DeleteLocalInt(oPC, PRC_WW_VOLUNTARY_TRANSITION);
    DeleteLocalInt(oPC, PRC_WW_FORM_SWITCH_FAILED);
    PRCWWDebug("form-switch-result", oPC,
        "result=FAIL stage=apply source=" + IntToString(nSourceForm)
        + " target=" + IntToString(nTargetForm)
        + " rollback=1");

    if(bHadFailedForm)
        DelayCommand(0.1f, PRCWWWaitForFormSwitchRollback(
            oPC, oFailedFormSkin, nSourceForm, 0));
    else
        DelayCommand(1.0f, PRCWWRestoreFormSwitchSource(oPC, nSourceForm));
}

void PRCWWFinalizeFormSwitch(object oPC, int nTargetForm)
{
    if(!GetIsObjectValid(oPC)
    || GetLocalInt(oPC, PRC_WW_FORM_SWITCH_PENDING) != nTargetForm)
        return;

    int nSourceForm = GetLocalInt(oPC, PRC_WW_FORM_SWITCH_SOURCE);
    int bTargetFlag = nTargetForm == PRC_WW_FORM_HYBRID
        ? GetLocalInt(oPC, "WWHybrid") : GetLocalInt(oPC, "WWWolf");
    if(PRCWWDetectTemplateForm(oPC) == nTargetForm && bTargetFlag)
    {
        // Only now is the destination stable enough to count as a successful
        // voluntary assumption. Commit active form, healing, and any permanent
        // alignment consequence atomically at this point.
        PRCWWOnAssumeForm(oPC);
        PRCWWClearFormSwitchState(oPC);
        PRCWWDebug("form-switch-result", oPC,
            "result=PASS source=" + IntToString(nSourceForm)
            + " target=" + IntToString(nTargetForm));
        PRCWWQueueFormTransitionEval(oPC);
        return;
    }

    int bHadFailedForm = PRCWWHasPolymorphEffect(oPC)
        || PRCWWHasHybridData(oPC);
    object oFailedFormSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);
    if(bHadFailedForm)
        ExecuteScript("prc_wwunpoly", oPC);
    DeleteLocalInt(oPC, PRC_WW_VOLUNTARY_TRANSITION);
    PRCWWDebug("form-switch-result", oPC,
        "result=FAIL stage=post-apply-settle source="
        + IntToString(nSourceForm)
        + " target=" + IntToString(nTargetForm)
        + " rollback=1");

    if(bHadFailedForm)
        DelayCommand(0.1f, PRCWWWaitForFormSwitchRollback(
            oPC, oFailedFormSkin, nSourceForm, 0));
    else
        DelayCommand(1.0f, PRCWWRestoreFormSwitchSource(oPC, nSourceForm));
}

void PRCWWWaitForFormSwitchRollback(object oPC, object oFailedFormSkin,
    int nSourceForm, int nRepeats)
{
    if(!GetIsObjectValid(oPC)
    || GetLocalInt(oPC, PRC_WW_FORM_SWITCH_SOURCE) != nSourceForm)
        return;

    if(GetIsDead(oPC) || !PRCWWHasTemplate(oPC))
    {
        PRCWWClearFormSwitchState(oPC);
        DeleteLocalInt(oPC, PRC_WW_VOLUNTARY_TRANSITION);
        PRCWWQueueFormTransitionEval(oPC);
        return;
    }

    if(nRepeats > 100)
    {
        PRCWWDebug("form-switch-result", oPC,
            "result=FAIL stage=rollback-timeout source="
            + IntToString(nSourceForm));
        PRCWWClearFormSwitchState(oPC);
        DeleteLocalInt(oPC, "WWWolf");
        DeleteLocalInt(oPC, "WWHybrid");
        PRCWWOnReturnHumanoid(oPC);
        PRCWWQueueFormTransitionEval(oPC);
        return;
    }

    object oCurrentSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);
    int bFailedSkinStillPresent = oCurrentSkin == oFailedFormSkin
        && GetResRef(oFailedFormSkin) == "werewolfskin2s";
    if(!GetIsObjectValid(oCurrentSkin) || bFailedSkinStillPresent
    || PRCWWHasPolymorphEffect(oPC) || PRCWWHasHybridData(oPC)
    || PRCWWIsHybridSettling(oPC))
    {
        DelayCommand(0.15f, PRCWWWaitForFormSwitchRollback(
            oPC, oFailedFormSkin, nSourceForm, nRepeats + 1));
        return;
    }

    DelayCommand(1.0f, PRCWWRestoreFormSwitchSource(oPC, nSourceForm));
}

void PRCWWRestoreFormSwitchSource(object oPC, int nSourceForm)
{
    if(!GetIsObjectValid(oPC)
    || GetLocalInt(oPC, PRC_WW_FORM_SWITCH_SOURCE) != nSourceForm)
        return;

    // Keep pending set while the rollback form and its generated equipment
    // settle, just as on the successful destination path.
    DeleteLocalInt(oPC, PRC_WW_FORM_SWITCH_RESUME);
    DeleteLocalInt(oPC, PRC_WW_FORM_SWITCH_FAILED);
    DeleteLocalInt(oPC, PRC_WW_VOLUNTARY_TRANSITION);
    DeleteLocalInt(oPC, "WWWolf");
    DeleteLocalInt(oPC, "WWHybrid");
    DeleteLocalInt(oPC, "PRC_WW_ReconstructFailed");
    PRCWWDebug("form-switch-rollback", oPC,
        "source=" + IntToString(nSourceForm));

    if(!GetIsDead(oPC) && PRCWWHasTemplate(oPC))
        PRCWWReconstructForm(oPC, nSourceForm);

    int bRestored = PRCWWDetectTemplateForm(oPC) == nSourceForm;
    if(!bRestored)
    {
        PRCWWClearFormSwitchState(oPC);
        DeleteLocalInt(oPC, "WWWolf");
        DeleteLocalInt(oPC, "WWHybrid");
        PRCWWOnReturnHumanoid(oPC);
        FloatingTextStringOnCreature(
            "The transformation fails; you return to humanoid form.",
            oPC, FALSE);
    }
    else
    {
        PRCWWDebug("form-switch-rollback-applied", oPC,
            "source=" + IntToString(nSourceForm) + " settle=0.3");
        DelayCommand(0.3f, PRCWWFinalizeFormSwitchRollback(oPC, nSourceForm));
        return;
    }

    PRCWWDebug("form-switch-rollback-result", oPC,
        "source=" + IntToString(nSourceForm)
        + " result=" + (bRestored ? "PASS" : "FAIL"));
    PRCWWQueueFormTransitionEval(oPC);
}

void PRCWWFinalizeFormSwitchRollback(object oPC, int nSourceForm)
{
    if(!GetIsObjectValid(oPC)
    || GetLocalInt(oPC, PRC_WW_FORM_SWITCH_SOURCE) != nSourceForm)
        return;

    int bRestored = PRCWWDetectTemplateForm(oPC) == nSourceForm;
    if(bRestored)
    {
        PRCWWClearFormSwitchState(oPC);
        FloatingTextStringOnCreature(
            "The transformation fails; your previous form is restored.",
            oPC, FALSE);
    }
    else
    {
        if(PRCWWHasPolymorphEffect(oPC) || PRCWWHasHybridData(oPC))
        {
            object oFailedFormSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);
            ExecuteScript("prc_wwunpoly", oPC);
            DelayCommand(0.1f, PRCWWWaitForFailedRollbackRemoval(
                oPC, oFailedFormSkin, nSourceForm, 0));
            return;
        }

        PRCWWClearFormSwitchState(oPC);
        DeleteLocalInt(oPC, "WWWolf");
        DeleteLocalInt(oPC, "WWHybrid");
        PRCWWOnReturnHumanoid(oPC);
        FloatingTextStringOnCreature(
            "The transformation fails; you return to humanoid form.",
            oPC, FALSE);
    }

    PRCWWDebug("form-switch-rollback-result", oPC,
        "source=" + IntToString(nSourceForm)
        + " result=" + (bRestored ? "PASS" : "FAIL"));
    PRCWWQueueFormTransitionEval(oPC);
}

void PRCWWWaitForFailedRollbackRemoval(object oPC, object oFailedFormSkin,
    int nSourceForm, int nRepeats)
{
    if(!GetIsObjectValid(oPC)
    || GetLocalInt(oPC, PRC_WW_FORM_SWITCH_SOURCE) != nSourceForm)
        return;

    if(!GetIsDead(oPC) && PRCWWHasTemplate(oPC) && nRepeats <= 100)
    {
        object oCurrentSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);
        if(!GetIsObjectValid(oCurrentSkin)
        || (oCurrentSkin == oFailedFormSkin
            && GetResRef(oFailedFormSkin) == "werewolfskin2s")
        || PRCWWHasPolymorphEffect(oPC) || PRCWWHasHybridData(oPC)
        || PRCWWIsHybridSettling(oPC))
        {
            DelayCommand(0.15f, PRCWWWaitForFailedRollbackRemoval(
                oPC, oFailedFormSkin, nSourceForm, nRepeats + 1));
            return;
        }
    }

    if(nRepeats > 100)
        PRCWWDebug("form-switch-rollback-cleanup", oPC,
            "result=TIMEOUT source=" + IntToString(nSourceForm));

    PRCWWClearFormSwitchState(oPC);
    DeleteLocalInt(oPC, "WWWolf");
    DeleteLocalInt(oPC, "WWHybrid");
    if(PRCWWHasTemplate(oPC))
        PRCWWOnReturnHumanoid(oPC);
    FloatingTextStringOnCreature(
        "The transformation fails; you return to humanoid form.",
        oPC, FALSE);
    PRCWWDebug("form-switch-rollback-result", oPC,
        "source=" + IntToString(nSourceForm) + " result=FAIL");
    PRCWWQueueFormTransitionEval(oPC);
}

int PRCWWShouldCoalesceEquipEval(object oPC)
{
    // The engine unequips/equips every polymorph-created item while applying
    // or removing EffectPolymorph. Only coalesce those generated events for
    // template werewolves; legacy class forms retain their existing behavior.
    if(!PRCWWHasTemplate(oPC))
        return FALSE;

    if(GetLocalInt(oPC, PRC_WW_FORM_TRANSITION))
        return TRUE;

    // A native/external removal can fire equipment events after the effect is
    // already gone but before the persistent form flags are reconciled.
    return (GetLocalInt(oPC, "WWWolf") || GetLocalInt(oPC, "WWHybrid"))
        && !PRCWWHasTemplateFormEffect(oPC);
}

void PRCWWRunTransitionEquipEval(object oPC)
{
    if(!GetIsObjectValid(oPC) || GetIsDead(oPC)
    || oPC == GetLocalObject(GetModule(), "ccc_active_pc")
    || GetLocalInt(oPC, PRC_WW_FORM_LIGHT_EVAL))
        return;

    SetLocalInt(oPC, PRC_WW_FORM_LIGHT_EVAL, TRUE);

    // Preserve the stock ONEQUIP event context while it is still valid, but
    // avoid the non-equipment branches (especially template maintenance) that
    // make every polymorph-created item launch another complete PRC rebuild.
    ExecuteScript("ft_sanctmartial", oPC);

    int i;
    string sScript;
    for(i = 1; i <= 8; i++)
    {
        sScript = GetPersistantLocalString(oPC,
            "PRC_Class_Script" + IntToString(i));
        if(sScript != "")
            ExecuteScript(sScript, oPC);
    }

    int iData = GetPersistantLocalInt(oPC, "PRC_Class_Data");
    if(iData & 0x04)
        ExecuteScript("prc_reducedasf", oPC);

    if(GetPersistantLocalInt(oPC, "PRC_UNI_SHIFT_SCRIPT"))
        ExecuteScript("prc_uni_shift", oPC);

    ExecuteScript("prc_feats", oPC);

    if(!GetLocalInt(oPC, "PRCSpeedDelay"))
    {
        ExecuteScript("prc_speed", oPC);
        SetLocalInt(oPC, "PRCSpeedDelay", TRUE);
        DelayCommand(0.15f, DeleteLocalInt(oPC, "PRCSpeedDelay"));
    }

    DeleteLocalInt(oPC, PRC_WW_FORM_LIGHT_EVAL);
}

void PRCWWFinishFormTransition(object oPC)
{
    if(!GetIsObjectValid(oPC))
        return;

    // A successful cure can remove the template while this delayed pass is
    // queued. Do not recreate persistence metadata after that cleanup.
    if(!PRCWWHasTemplate(oPC))
    {
        PRCWWClearFormSwitchState(oPC);
        DeleteLocalInt(oPC, PRC_WW_VOLUNTARY_TRANSITION);
        DeleteLocalInt(oPC, PRC_WW_FORM_TRANSITION);
        DeleteLocalInt(oPC, PRC_WW_FORM_EVAL_QUEUED);
        DeleteLocalInt(oPC, PRC_WW_FORM_LIGHT_EVAL);
        return;
    }

    // A form-to-form change intentionally spends a short interval in the
    // restored humanoid body. Do not mistake that handoff for a true return or
    // clear its forced-episode/alignment state; retry after the next stage.
    if(GetLocalInt(oPC, PRC_WW_FORM_SWITCH_PENDING)
    || PRCWWIsHybridSettling(oPC))
    {
        DelayCommand(0.3f, PRCWWFinishFormTransition(oPC));
        return;
    }

    PRCWWLoadPersistentState(oPC);
    int bHadFormState = GetLocalInt(oPC, "WWWolf")
        || GetLocalInt(oPC, "WWHybrid")
        || PRCWWGetActiveForm(oPC) != PRC_WW_FORM_NONE;

    // A locked template form normally exits through the form feat. Keep this
    // reconciliation for death, dispel/removal hooks, and saves made before
    // locked polymorphs were introduced.
    if(bHadFormState && !PRCWWHasTemplateFormEffect(oPC)
    && !PRCWWHasPolymorphEffect(oPC))
    {
        DeleteLocalInt(oPC, "WWWolf");
        DeleteLocalInt(oPC, "WWHybrid");
        PRCWWOnReturnHumanoid(oPC);
    }

    // Death cleanup needs no equipment-driven feature evaluation. Avoid
    // rebuilding the skin while the creature is in its death transition.
    // The generated item callbacks already ran their ONEQUIP-sensitive routes
    // in their real event contexts. Run one neutral full evaluation now that
    // the final equipment state is stable. Keep the queue guard set through
    // EvalPRCFeats so any synchronous item events it causes cannot enqueue a
    // second pass.
    if(!GetIsDead(oPC))
        EvalPRCFeats(oPC);

    DeleteLocalInt(oPC, PRC_WW_FORM_TRANSITION);
    DeleteLocalInt(oPC, PRC_WW_FORM_EVAL_QUEUED);
    DeleteLocalInt(oPC, PRC_WW_FORM_LIGHT_EVAL);
}

void PRCWWQueueFormTransitionEval(object oPC)
{
    if(!GetIsObjectValid(oPC))
        return;

    PRCWWBeginFormTransition(oPC);
    if(GetLocalInt(oPC, PRC_WW_FORM_EVAL_QUEUED))
        return;

    SetLocalInt(oPC, PRC_WW_FORM_EVAL_QUEUED, TRUE);
    // prc_unequip schedules its natural-weapon update at 0.15 seconds and
    // prc_equip schedules its weapon update at 0.2 seconds. Run once after
    // both queues have settled instead of a complete PRC rebuild for every
    // generated event.
    DelayCommand(0.3f, PRCWWFinishFormTransition(oPC));
}

void PRCWWRevertTemplateForm(object oPC, int bVisual)
{
    PRCWWLoadPersistentState(oPC);
    PRCWWClearFormSwitchState(oPC);
    DeleteLocalInt(oPC, PRC_WW_VOLUNTARY_TRANSITION);
    PRCWWRemoveFormSpeed(oPC);

    int bHadWerewolfForm = GetLocalInt(oPC, "WWWolf")
        || GetLocalInt(oPC, "WWHybrid")
        || PRCWWGetActiveForm(oPC) != PRC_WW_FORM_NONE
        || PRCWWDetectTemplateForm(oPC) != PRC_WW_FORM_NONE;
    int bHadEpisode = GetLocalInt(oPC, "PRC_WW_Involuntary")
        || GetLocalInt(oPC, "PRC_WW_ReturnLocked")
        || GetLocalInt(oPC, "PRC_WW_SavedAlignment");

    if(!bHadWerewolfForm && !bHadEpisode)
    {
        if(GetIsDead(oPC))
            PRCWWClearInjuryState(oPC, "death-reset");
        return;
    }

    PRCWWBeginFormTransition(oPC);

    PRCWWRemoveHybrid(oPC);

    // Episode metadata alone must never remove an unrelated polymorph.
    if(bHadWerewolfForm && PRCWWHasTemplateFormEffect(oPC))
    {
        effect ePoly = GetFirstEffect(oPC);
        while(GetIsEffectValid(ePoly))
        {
            if(GetEffectType(ePoly) == EFFECT_TYPE_POLYMORPH)
            {
                RemoveEffect(oPC, ePoly);
                break;
            }
            ePoly = GetNextEffect(oPC);
        }
    }

    if(bVisual && bHadWerewolfForm)
        ApplyEffectToObject(DURATION_TYPE_INSTANT,
            EffectVisualEffect(VFX_IMP_POLYMORPH), oPC);

    DeleteLocalInt(oPC, "WWWolf");
    DeleteLocalInt(oPC, "WWHybrid");
    PRCWWOnReturnHumanoid(oPC);
    PRCWWQueueFormTransitionEval(oPC);
}

void PRCWWForceWolfForm(object oPC, string sReason = "unspecified")
{
    PRCWWLoadPersistentState(oPC);
    if(PRCWWHasSeluniteControl(oPC))
    {
        PRCWWDebug("forced-form-suppressed", oPC,
            "reason=" + sReason + " source=selunite-control");
        return;
    }

    if(GetLocalInt(oPC, "WWWolf") || GetLocalInt(oPC, "WWHybrid")
    || PRCWWGetActiveForm(oPC) != PRC_WW_FORM_NONE)
        return;

    PRCWWDebug("forced-form-start", oPC, "reason=" + sReason);

    if(GetPersistantLocalInt(oPC, "PRC_WW_Aware") && GetIsPC(oPC))
    {
        if(sReason == "full-moon")
            FloatingTextStringOnCreature(
                "The full moon overwhelms your control.", oPC, FALSE);
        else if(sReason == "injury")
            FloatingTextStringOnCreature(
                "Your wounds awaken the beast within.", oPC, FALSE);
    }

    if(!GetLocalInt(oPC, "PRC_WW_SavedAlignment"))
    {
        PRCWWSetStateInt(oPC, "PRC_WW_SavedAlignment", TRUE);
        PRCWWSetStateInt(oPC, "PRC_WW_SavedLawChaos", GetLawChaosValue(oPC));
        PRCWWSetStateInt(oPC, "PRC_WW_SavedGoodEvil", GetGoodEvilValue(oPC));
    }

    PRCWWSetStateInt(oPC, "PRC_WW_Involuntary", TRUE);
    PRCWWDeleteStateInt(oPC, "PRC_WW_FormAlignmentCommitted");
    PRCWWSetStateInt(oPC, "PRC_WW_ForcedDate", PRCWWDateKey());
    PRCWWSetStateInt(oPC, "PRC_WW_ForcedHour", GetTimeHour());
    PRCWWSetStateInt(oPC, "PRC_WW_DawnHourKey", PRCWWNextDawnHourKey());
    SetLocalInt(oPC, "PRC_WW_ControlBypass", TRUE);
    PRCWWSetAlignment(oPC, 0, 0, "involuntary-" + sReason);
    ExecuteScript("prc_wwformwolf", oPC);

    // Do not leave an unshifted character carrying the involuntary-form
    // alignment state if the scripted transformation fails.
    if(!GetLocalInt(oPC, "WWWolf"))
    {
        PRCWWRestoreInvoluntaryAlignment(oPC);
        PRCWWDeleteStateInt(oPC, "PRC_WW_Involuntary");
        PRCWWDeleteStateInt(oPC, "PRC_WW_ForcedDate");
        PRCWWDeleteStateInt(oPC, "PRC_WW_ForcedHour");
        PRCWWDeleteStateInt(oPC, "PRC_WW_DawnHourKey");
        PRCWWDebug("forced-form-result", oPC,
            "reason=" + sReason + " result=FAIL");
    }
    else
        PRCWWDebug("forced-form-result", oPC,
            "reason=" + sReason + " result=PASS form=wolf");
    DeleteLocalInt(oPC, "PRC_WW_ControlBypass");
}

int PRCWWEpisodeDawnDue(object oPC)
{
    string sDeadline;
    if(GetLocalInt(oPC, "PRC_WW_Involuntary"))
        sDeadline = "PRC_WW_DawnHourKey";
    else if(GetLocalInt(oPC, "PRC_WW_ReturnLocked"))
        sDeadline = "PRC_WW_ReturnDawnHourKey";
    else
        return FALSE;

    int nNow = PRCWWHourKey();
    int nDeadline = GetLocalInt(oPC, sDeadline);
    if(!nDeadline || nDeadline > nNow + 24)
    {
        int nOldDeadline = nDeadline;
        nDeadline = PRCWWNextDawnHourKey();
        PRCWWSetStateInt(oPC, sDeadline, nDeadline);
        PRCWWDebug("dawn-deadline-rebased", oPC,
            "old=" + IntToString(nOldDeadline)
            + " new=" + IntToString(nDeadline)
            + " now=" + IntToString(nNow));
    }
    return nNow >= nDeadline;
}

void PRCWWReconstructForm(object oPC, int nForm)
{
    if(nForm == PRC_WW_FORM_NONE || PRCWWHasTemplateFormEffect(oPC)
    || GetLocalInt(oPC, "PRC_WW_ReconstructFailed"))
        return;

    // Do not overwrite a different polymorph. The persisted episode remains
    // authoritative and can resume when that unrelated effect ends.
    if(PRCWWHybHasOtherShape(oPC))
    {
        PRCWWDebug("form-reconstruct-deferred", oPC,
            "reason=unrelated-polymorph form=" + IntToString(nForm));
        return;
    }

    DeleteLocalInt(oPC, "WWWolf");
    DeleteLocalInt(oPC, "WWHybrid");
    SetLocalInt(oPC, PRC_WW_RECONSTRUCTING, TRUE);
    SetLocalInt(oPC, "PRC_WW_ControlBypass", TRUE);
    PRCWWDebug("form-reconstruct-start", oPC,
        "form=" + IntToString(nForm));

    if(nForm == PRC_WW_FORM_HYBRID)
        ExecuteScript("prc_wwhybridwolf", oPC);
    else
        ExecuteScript("prc_wwformwolf", oPC);

    DeleteLocalInt(oPC, "PRC_WW_ControlBypass");
    DeleteLocalInt(oPC, PRC_WW_RECONSTRUCTING);
    int bSuccess = PRCWWHasTemplateFormEffect(oPC)
        && (GetLocalInt(oPC, "WWWolf") || GetLocalInt(oPC, "WWHybrid"));
    if(!bSuccess)
        SetLocalInt(oPC, "PRC_WW_ReconstructFailed", TRUE);
    else
        DeleteLocalInt(oPC, "PRC_WW_ReconstructFailed");
    PRCWWDebug("form-reconstruct-result", oPC,
        "form=" + IntToString(nForm)
        + " result=" + (bSuccess ? "PASS" : "FAIL")
        + " healing=0");
}

void PRCWWCheckInjury(object oPC)
{
    int nMaxHP = GetMaxHitPoints(oPC);
    if(nMaxHP < 1)
        return;

    int nHP = GetCurrentHitPoints(oPC);
    if(nHP < 0)
        nHP = 0;
    if(nHP > nMaxHP)
        nHP = nMaxHP;
    int nQuarter = (nHP * 4 + nMaxHP - 1) / nMaxHP;
    int nStoredQuarter = GetLocalInt(oPC, "PRC_WW_HPQuarter");
    int nStoredMaxHP = GetLocalInt(oPC, "PRC_WW_HPMax");

    if(!nStoredQuarter)
    {
        PRCWWBaselineInjury(oPC, "initialize");
        return;
    }
    if(nStoredMaxHP != nMaxHP)
    {
        PRCWWBaselineInjury(oPC, "max-hp-change");
        return;
    }

    int nPreviousQuarter = nStoredQuarter - 1;
    if(nQuarter > nPreviousQuarter)
    {
        PRCWWBaselineInjury(oPC, "healing");
        return;
    }
    if(nQuarter == nPreviousQuarter)
        return;

    // Save the final band before rolling so reconnecting cannot repeat any
    // of the crossed thresholds. Each lost quarter requires its own check.
    PRCWWSetStateInt(oPC, "PRC_WW_HPQuarter", nQuarter + 1);
    int nCrossed = nPreviousQuarter - nQuarter;
    int bAware = GetPersistantLocalInt(oPC, "PRC_WW_Aware");
    PRCWWDebug("injury-threshold-batch", oPC,
        "old_band=" + IntToString(nPreviousQuarter)
        + " new_band=" + IntToString(nQuarter)
        + " crossed=" + IntToString(nCrossed)
        + " hp=" + IntToString(nHP)
        + " max=" + IntToString(nMaxHP)
        + " aware=" + IntToString(bAware));

    int nThreshold;
    for(nThreshold = nPreviousQuarter - 1;
        nThreshold >= nQuarter; nThreshold--)
    {
        int nIndex = nPreviousQuarter - nThreshold;
        PRCWWDebug("injury-threshold", oPC,
            "lost_quarter=" + IntToString(4 - nThreshold)
            + " index=" + IntToString(nIndex)
            + "/" + IntToString(nCrossed));
        int bPassed = PRCWWControlCheck(oPC, 25,
            "resist injury-triggered change", bAware);
        PRCWWDebug("injury-check", oPC,
            "result=" + (bPassed ? "PASS" : "FAIL")
            + " dc=25 index=" + IntToString(nIndex)
            + "/" + IntToString(nCrossed));
        if(!bPassed)
        {
            PRCWWForceWolfForm(oPC, "injury");
            return;
        }
    }
}

void PRCWWHeartbeat(object oPC)
{
    int bNaturalTemplate = PRCWWHasNaturalTemplate(oPC);
    int bAfflictedTemplate = PRCWWHasAfflictedTemplate(oPC);
    if(!bNaturalTemplate && !bAfflictedTemplate)
        return;

    PRCWWLoadPersistentState(oPC);
    int bSeluniteStateChanged = PRCWWSyncSeluniteControl(oPC);
    int bSeluniteControl = PRCWWHasSeluniteControl(oPC);
    if(bSeluniteStateChanged)
    {
        // Rebuild humanoid/form radials after the heartbeat event unwinds.
        DelayCommand(0.1f, ExecuteScript("tmp_m_wwolf", oPC));
    }

    if(PRCWWHasHybridData(oPC))
    {
        PRCWWRefreshHybrid(oPC);
        if(!PRCWWHasHybrid(oPC))
        {
            // An unrelated shape can temporarily cover the hybrid. Suspend
            // only its owned bonuses; do not overwrite the other body.
            PRCWWRemoveFormSpeed(oPC);
            PRCWWUpdateTemplateSkin(oPC, FALSE);
            SetLocalInt(oPC, "PRC_WW_HybSuspended", TRUE);
        }
        else if(GetLocalInt(oPC, "PRC_WW_HybSuspended"))
        {
            // The covering form may expire straight back to hybrid, with
            // no reconstruction or equipment event to restore these deltas.
            PRCWWApplyFormProperties(oPC, TRUE);
            DeleteLocalInt(oPC, "PRC_WW_HybSuspended");
        }
    }

    // A logout can interrupt the appearance/creature-slot restore callback.
    // Resume only this adapter's pending cleanup, not an unrelated shift.
    if(PRCWWIsHybridSettling(oPC))
    {
        PRCWWRemoveHybrid(oPC);
        return;
    }

    // The staged animal <-> hybrid handoff owns form state until its delayed
    // destination or rollback completes. Reconstructing here would race it and
    // reapply the outgoing form during the intentional humanoid interval.
    if(GetLocalInt(oPC, PRC_WW_FORM_SWITCH_PENDING))
        return;

    int nDate = PRCWWDateKey();
    int nHour = GetTimeHour();
    int nActiveForm = PRCWWGetActiveForm(oPC);
    int nDetectedForm = PRCWWDetectTemplateForm(oPC);

    // Restore the legacy session mirrors when the engine retained the
    // polymorph effect but object locals were lost.
    int bHasTemplateForm = nDetectedForm != PRC_WW_FORM_NONE;
    if(bHasTemplateForm)
    {
        if(nActiveForm != nDetectedForm)
        {
            PRCWWSetActiveForm(oPC, nDetectedForm);
            nActiveForm = nDetectedForm;
        }
        if(nActiveForm == PRC_WW_FORM_WOLF)
        {
            SetLocalInt(oPC, "WWWolf", TRUE);
            DeleteLocalInt(oPC, "WWHybrid");
        }
        else if(nActiveForm == PRC_WW_FORM_HYBRID)
        {
            SetLocalInt(oPC, "WWHybrid", TRUE);
            DeleteLocalInt(oPC, "WWWolf");
        }
        PRCWWCommitVoluntaryAlignment(oPC);
    }

    // If the feature came online between a forced episode being persisted and
    // its form being reconstructed, restore the saved alignment and cancel
    // that stale episode. Existing voluntary form continuity is untouched.
    if(bSeluniteControl && !bHasTemplateForm
    && GetLocalInt(oPC, "PRC_WW_Involuntary"))
    {
        DeleteLocalInt(oPC, "WWWolf");
        DeleteLocalInt(oPC, "WWHybrid");
        PRCWWOnReturnHumanoid(oPC);
        nActiveForm = PRC_WW_FORM_NONE;
    }

    // ForceWolf writes the episode before applying the polymorph. If a reset
    // lands in that small window, the involuntary marker proves that Wolf is
    // the form which must be resumed.
    if(bAfflictedTemplate
    && GetLocalInt(oPC, "PRC_WW_Involuntary")
    && nActiveForm == PRC_WW_FORM_NONE
    && !bHasTemplateForm)
    {
        PRCWWSetActiveForm(oPC, PRC_WW_FORM_WOLF);
        nActiveForm = PRC_WW_FORM_WOLF;
        PRCWWDebug("form-state-recovered", oPC,
            "source=involuntary-marker form=wolf");
    }

    int bInForm = GetLocalInt(oPC, "WWWolf")
        || GetLocalInt(oPC, "WWHybrid")
        || nActiveForm != PRC_WW_FORM_NONE;

    // Natural template forms have no involuntary episode rules, but use the
    // same persisted form reconstruction after reconnects and module resets.
    if(!bAfflictedTemplate)
    {
        if(bInForm && !GetIsDead(oPC) && !bHasTemplateForm)
            PRCWWReconstructForm(oPC, nActiveForm);
        return;
    }

    int bDawnReturn = PRCWWEpisodeDawnDue(oPC);

    if(bDawnReturn)
    {
        int bWasAware = GetPersistantLocalInt(oPC, "PRC_WW_Aware");
        PRCWWDebug("dawn-return-start", oPC,
            "hour=" + IntToString(nHour)
            + " aware=" + IntToString(bWasAware)
            + " active_form=" + IntToString(nActiveForm));
        if(bHasTemplateForm)
            ExecuteScript("prc_wwunpoly", oPC);
        if(bHasTemplateForm && PRCWWHasTemplateFormEffect(oPC))
        {
            PRCWWDebug("dawn-return-result", oPC, "result=FAIL polymorph=1");
            return;
        }

        DeleteLocalInt(oPC, "WWWolf");
        DeleteLocalInt(oPC, "WWHybrid");
        PRCWWOnReturnHumanoid(oPC);
        PRCWWDebug("dawn-return-result", oPC, "result=PASS polymorph=0");

        if(bWasAware && GetIsPC(oPC))
            FloatingTextStringOnCreature(
                "At dawn, you return to humanoid form.", oPC, FALSE);

        if(!bWasAware)
        {
            int bRecognized = PRCWWControlCheck(oPC, 15,
                "recognize the affliction", FALSE);
            PRCWWDebug("awareness-check", oPC,
                "dc=15 result=" + (bRecognized ? "PASS" : "FAIL"));
            if(bRecognized)
            {
                SetPersistantLocalInt(oPC, "PRC_WW_Aware", TRUE);
                // Run after the heartbeat eventhook unwinds so the maintenance
                // script sees a neutral event context and grants the radials.
                DelayCommand(0.1f, ExecuteScript("tmp_m_wwolf", oPC));
                if(GetIsPC(oPC))
                    FloatingTextStringOnCreature(
                        "You realize that you are afflicted with lycanthropy.",
                        oPC, FALSE);
            }
        }
        return;
    }

    if(bInForm)
    {
        if(!GetIsDead(oPC) && !bHasTemplateForm)
            PRCWWReconstructForm(oPC, nActiveForm);
        return;
    }
    if(GetIsDead(oPC))
    {
        if(GetLocalInt(oPC, "PRC_WW_HPQuarter")
        || GetLocalInt(oPC, "PRC_WW_HPMax"))
            PRCWWClearInjuryState(oPC, "death-reset");
        return;
    }

    if(bSeluniteControl)
    {
        if(GetLocalInt(oPC, "PRC_WW_HPQuarter")
        || GetLocalInt(oPC, "PRC_WW_HPMax"))
            PRCWWClearInjuryState(oPC, "selunite-control");
        return;
    }

    // No symptoms occur until the first night of the next full moon. Once
    // that moonrise has occurred, injury checks begin as well.
    if(PRCWWIsFullMoon() && nHour >= 18
        && GetLocalInt(oPC, "PRC_WW_LastMoonCheck") != nDate
        && PRCWWFirstFullMoonReached(oPC))
    {
        int bFirstManifestation = !GetPersistantLocalInt(oPC, "PRC_WW_Manifested");
        int bAware = GetPersistantLocalInt(oPC, "PRC_WW_Aware");
        SetPersistantLocalInt(oPC, "PRC_WW_Manifested", TRUE);
        PRCWWSetStateInt(oPC, "PRC_WW_LastMoonCheck", nDate);
        PRCWWDebug("moonrise-trigger", oPC,
            "date=" + IntToString(nDate)
            + " hour=" + IntToString(nHour)
            + " first=" + IntToString(bFirstManifestation)
            + " aware=" + IntToString(bAware));
        if(bFirstManifestation
        || !PRCWWControlCheck(oPC, 25, "resist full-moon change", bAware))
        {
            if(bFirstManifestation)
                PRCWWDebug("moonrise-check", oPC,
                    "result=AUTOMATIC first-manifestation=1");
            PRCWWForceWolfForm(oPC, "full-moon");
            return;
        }
        PRCWWDebug("moonrise-check", oPC, "result=RESISTED dc=25");
    }

    if(GetPersistantLocalInt(oPC, "PRC_WW_Manifested"))
        PRCWWCheckInjury(oPC);
}

int PRCWWTryCure(object oCaster, object oTarget, int nMethod)
{
    if(!PRCWWHasAfflictedTemplate(oTarget))
    {
        PRCWWDebug("cure-result", oTarget,
            "method=" + IntToString(nMethod) + " result=INELIGIBLE");
        return FALSE;
    }

    PRCWWDebug("cure-start", oTarget,
        "method=" + IntToString(nMethod)
        + " caster=" + GetName(oCaster));

    int bTargetAware = GetPersistantLocalInt(oTarget, "PRC_WW_Aware");
    int bCured = FALSE;
    if(nMethod == PRC_WW_CURE_EARLY_CLERIC)
    {
        bCured = GetLevelByClass(CLASS_TYPE_CLERIC, oCaster) >= 12
            && PRCWWWithinEarlyCureWindow(oTarget);
    }
    else if(nMethod == PRC_WW_CURE_FULL_MOON && PRCWWIsFullMoon())
    {
        bCured = WillSave(oTarget, 20, SAVING_THROW_TYPE_NONE, oCaster);
    }

    if(!bCured)
    {
        string sFailureReason = "requirements-not-met";
        if(nMethod == PRC_WW_CURE_EARLY_CLERIC)
        {
            if(GetLevelByClass(CLASS_TYPE_CLERIC, oCaster) < 12)
                sFailureReason = "cleric-level-below-12";
            else if(!PRCWWWithinEarlyCureWindow(oTarget))
                sFailureReason = "three-day-window-expired";
        }
        else if(nMethod == PRC_WW_CURE_FULL_MOON)
            sFailureReason = PRCWWIsFullMoon()
                ? "will-save-failed" : "not-full-moon";

        // D&D 3.0 explicitly tells the caster whether the full-moon
        // remove-curse/break-enchantment cure worked.
        if(nMethod == PRC_WW_CURE_FULL_MOON && GetIsPC(oCaster))
            SendMessageToPC(oCaster,
                "The lycanthropic curse remains on " + GetName(oTarget) + ".");
        PRCWWDebug("cure-result", oTarget,
            "method=" + IntToString(nMethod)
            + " result=FAIL reason=" + sFailureReason);
        return FALSE;
    }

    PRCWWRevertTemplateForm(oTarget);

    // Appearance/body-part and creature-slot restoration is asynchronous.
    // Keep its recovery hook through a logout or delayed equipment action.
    if(!PRCWWHasHybridData(oTarget))
        RemoveEventScript(oTarget, EVENT_ONHEARTBEAT, "tmp_m_wwolf", TRUE, FALSE);
    if(GetIsPC(oTarget))
        RemoveEventScript(oTarget, EVENT_ONPLAYERDEATH,
            "tmp_m_wwolf", TRUE, FALSE);
    else
        RemoveEventScript(oTarget, EVENT_NPC_ONDEATH,
            "tmp_m_wwolf", TRUE, FALSE);

    // EvalPRCFeats only reapplies templates that remain in the template
    // array; it does not know the composite-property names owned by a
    // removed template. Clear this template's humanoid-skin state explicitly.
    object oSkin = GetPCSkin(oTarget);
    if(GetIsObjectValid(oSkin))
    {
        SetCompositeBonus(oSkin, "Template_WWerewolf_AC", 0,
            ITEM_PROPERTY_AC_BONUS);
        SetCompositeBonus(oSkin, "Template_WWerewolf_Fort", 0,
            ITEM_PROPERTY_SAVING_THROW_BONUS, SAVING_THROW_FORT);
        SetCompositeBonus(oSkin, "Template_WWerewolf_Will", 0,
            ITEM_PROPERTY_SAVING_THROW_BONUS, SAVING_THROW_WILL);
        SetCompositeBonus(oSkin, "Template_WWerewolf_Listen", 0,
            ITEM_PROPERTY_SKILL_BONUS, SKILL_LISTEN);
        SetCompositeBonus(oSkin, "Template_WWerewolf_Search", 0,
            ITEM_PROPERTY_SKILL_BONUS, SKILL_SEARCH);
        SetCompositeBonus(oSkin, "Template_WWerewolf_Spot", 0,
            ITEM_PROPERTY_SKILL_BONUS, SKILL_SPOT);
        SetCompositeBonus(oSkin, "Template_WWerewolf_Empathy", 0,
            ITEM_PROPERTY_SKILL_BONUS, SKILL_ANIMAL_EMPATHY);
        RemoveSpecificProperty(oSkin, ITEM_PROPERTY_BONUS_FEAT,
            IP_CONST_FEAT_TEMPLATE_WEREWOLF_WOLF_FORM, -1, -1);
        RemoveSpecificProperty(oSkin, ITEM_PROPERTY_BONUS_FEAT,
            IP_CONST_FEAT_TEMPLATE_WEREWOLF_HYBRID_FORM, -1, -1);
        RemoveSpecificProperty(oSkin, ITEM_PROPERTY_BONUS_FEAT,
            IP_CONST_FEAT_TEMPLATE_WEREWOLF_SHAPECHANGER, -1, -1);
    }

    RemoveTemplateFromObject(TEMPLATE_LYCAN_ACQ_WOLF, oTarget);

    PRCWWResetRuntimeState(oTarget);
    DeletePersistantLocalInt(oTarget, "PRC_WW_Aware");
    DeletePersistantLocalInt(oTarget,
        PRC_WW_SELUNITE_AWARE_GRANTED);
    DeletePersistantLocalInt(oTarget, "PRC_WW_Embraced");
    DeletePersistantLocalInt(oTarget, "PRC_WW_Manifested");
    DeletePersistantLocalInt(oTarget, "PRC_WW_InfectionDate");
    DeletePersistantLocalInt(oTarget, "PRC_WW_InfectionHour");
    DeletePersistantLocalInt(oTarget, "PRC_WW_InfectionHourKey");

    // Do not identify a hidden curse to a victim who never recognized it.
    if(bTargetAware)
        FloatingTextStringOnCreature(
            "The lycanthropic affliction is cured.", oTarget, FALSE);
    if(GetIsPC(oCaster) && oCaster != oTarget)
        SendMessageToPC(oCaster, GetName(oTarget) + " is cured of lycanthropy.");
    else if(nMethod == PRC_WW_CURE_FULL_MOON && GetIsPC(oCaster)
    && !bTargetAware)
        SendMessageToPC(oCaster, "The lycanthropic curse is broken.");
    PRCWWDebug("cure-result", oTarget,
        "method=" + IntToString(nMethod) + " result=PASS");
    return TRUE;
}
