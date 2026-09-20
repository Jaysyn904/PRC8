//::///////////////////////////////////////////////
//:: PRC Maneuver Readying NUI helpers
//:: prc_nui_mr_inc
//:://////////////////////////////////////////////
/**
 * Stages a complete base-initiator maneuver loadout without touching the live
 * readied roster. The draft is validated and committed atomically on Save.
 */

#include "prc_nui_com_inc"
#include "tob_inc_recovery"
#include "prc_nui_mr_const"

int ManeuverReadyIsInitiatorClass(int nClass)
{
    return nClass == CLASS_TYPE_CRUSADER
        || nClass == CLASS_TYPE_SWORDSAGE
        || nClass == CLASS_TYPE_WARBLADE;
}

int ManeuverReadyGetReadyFeat(int nClass)
{
    switch (nClass)
    {
        case CLASS_TYPE_CRUSADER:
            return PRC_MANEUVER_READY_FEAT_CRUSADER;
        case CLASS_TYPE_SWORDSAGE:
            return PRC_MANEUVER_READY_FEAT_SWORDSAGE;
        case CLASS_TYPE_WARBLADE:
            return PRC_MANEUVER_READY_FEAT_WARBLADE;
    }
    return -1;
}

string ManeuverReadyCooldownVar(int nClass)
{
    switch (nClass)
    {
        case CLASS_TYPE_CRUSADER:
            return "ReadyManeuverCru";
        case CLASS_TYPE_SWORDSAGE:
            return "ReadyManeuverSwd";
        case CLASS_TYPE_WARBLADE:
            return "ReadyManeuverWar";
    }
    return "";
}

string ManeuverReadyClassName(int nClass)
{
    return GetStringByStrRef(StringToInt(Get2DACache("classes", "Name", nClass)));
}

int ManeuverReadyGetDefinitionRow(int nClass, int nManeuver)
{
    if (!ManeuverReadyIsInitiatorClass(nClass) || nManeuver <= 0)
        return -1;

    string sFile = GetAMSDefinitionFileName(nClass);
    int nRows = Get2DARowCount(sFile);
    int i;
    for (i = 1; i < nRows; i++)
    {
        if (Get2DACache(sFile, "Type", i) != "1"
            && StringToInt(Get2DACache(sFile, "RealSpellID", i)) == nManeuver)
            return i;
    }
    return -1;
}

int ManeuverReadyIsKnown(object oPC, int nClass, int nManeuver)
{
    return ManeuverReadyGetDefinitionRow(nClass, nManeuver) > 0
        && GetHasManeuver(nManeuver, nClass, oPC);
}

int ManeuverReadyGetLevel(int nClass, int nManeuver)
{
    int nRow = ManeuverReadyGetDefinitionRow(nClass, nManeuver);
    if (nRow <= 0)
        return -1;
    return StringToInt(Get2DACache(GetAMSDefinitionFileName(nClass), "Level", nRow));
}

int ManeuverReadyMaxLevel(object oPC, int nClass)
{
    if (!ManeuverReadyIsInitiatorClass(nClass)
        || GetLevelByClass(nClass, oPC) <= 0)
        return 0;
    return PRCMin(9, (GetInitiatorLevel(oPC, nClass) + 1) / 2);
}

int ManeuverReadyTargetCount(object oPC, int nClass)
{
    if (!ManeuverReadyIsInitiatorClass(nClass)
        || GetLevelByClass(nClass, oPC) <= 0)
        return 0;

    int nReady = GetMaxReadiedCount(oPC, nClass);
    int nKnown = GetManeuverCount(oPC, nClass, MANEUVER_TYPE_MANEUVER);
    return nReady < nKnown ? nReady : nKnown;
}

int ManeuverReadyHasKnownAtLevel(object oPC, int nClass, int nLevel)
{
    string sFile = GetAMSDefinitionFileName(nClass);
    int nRows = Get2DARowCount(sFile);
    int i;
    for (i = 1; i < nRows; i++)
    {
        if (Get2DACache(sFile, "Type", i) == "1"
            || StringToInt(Get2DACache(sFile, "Level", i)) != nLevel)
            continue;

        int nManeuver = StringToInt(Get2DACache(sFile, "RealSpellID", i));
        if (nManeuver > 0 && GetHasManeuver(nManeuver, nClass, oPC))
            return TRUE;
    }
    return FALSE;
}

string ManeuverReadyCurrentSignature(object oPC, int nClass)
{
    string sBase = "ManeuverReadied" + IntToString(nClass);
    int nCount = GetLocalInt(oPC, sBase);
    string sSignature = IntToString(nClass) + "|"
                      + IntToString(ManeuverReadyTargetCount(oPC, nClass)) + "|"
                      + IntToString(nCount);
    int i;
    for (i = 1; i <= nCount; i++)
        sSignature += ":" + IntToString(GetLocalInt(oPC, sBase + IntToString(i)));
    return sSignature;
}

json ManeuverReadyGetDraft(object oPC)
{
    json jDraft = GetLocalJson(oPC, PRC_MANEUVER_READY_DRAFT_VAR);
    if (JsonGetType(jDraft) != JSON_TYPE_ARRAY)
        return JsonArray();
    return jDraft;
}

int ManeuverReadyDraftContains(object oPC, int nManeuver)
{
    json jDraft = ManeuverReadyGetDraft(oPC);
    int i;
    for (i = 0; i < JsonGetLength(jDraft); i++)
    {
        if (JsonGetInt(JsonArrayGet(jDraft, i)) == nManeuver)
            return TRUE;
    }
    return FALSE;
}

int ManeuverReadyDraftCount(object oPC)
{
    return JsonGetLength(ManeuverReadyGetDraft(oPC));
}

int ManeuverReadyInitializeDraft(object oPC, int nClass, int nMode)
{
    if (!GetIsObjectValid(oPC)
        || nMode != PRC_MANEUVER_READY_MODE_NORMAL
        || !ManeuverReadyIsInitiatorClass(nClass)
        || GetLevelByClass(nClass, oPC) <= 0)
        return FALSE;

    json jDraft = JsonArray();
    json jSeen = JsonObject();
    int nTarget = ManeuverReadyTargetCount(oPC, nClass);
    string sBase = "ManeuverReadied" + IntToString(nClass);
    int nCount = GetLocalInt(oPC, sBase);
    int i;
    for (i = 1; i <= nCount && JsonGetLength(jDraft) < nTarget; i++)
    {
        int nManeuver = GetLocalInt(oPC, sBase + IntToString(i));
        string sKey = IntToString(nManeuver);
        if (ManeuverReadyIsKnown(oPC, nClass, nManeuver)
            && JsonObjectGet(jSeen, sKey) == JsonNull())
        {
            jDraft = JsonArrayInsert(jDraft, JsonInt(nManeuver));
            jSeen = JsonObjectSet(jSeen, sKey, JsonBool(TRUE));
        }
    }

    int nLevel = 1;
    int nMaxLevel = ManeuverReadyMaxLevel(oPC, nClass);
    while (nLevel <= nMaxLevel
        && !ManeuverReadyHasKnownAtLevel(oPC, nClass, nLevel))
        nLevel++;
    if (nLevel > nMaxLevel)
        nLevel = 1;

    SetLocalJson(oPC, PRC_MANEUVER_READY_DRAFT_VAR, jDraft);
    SetLocalString(
        oPC,
        PRC_MANEUVER_READY_BASELINE_VAR,
        ManeuverReadyCurrentSignature(oPC, nClass)
    );
    SetLocalInt(oPC, PRC_MANEUVER_READY_ACTIVE_VAR, TRUE);
    SetLocalInt(oPC, PRC_MANEUVER_READY_CLASS_VAR, nClass);
    SetLocalInt(oPC, PRC_MANEUVER_READY_LEVEL_VAR, nLevel);
    SetLocalInt(oPC, PRC_MANEUVER_READY_MODE_VAR, nMode);
    return TRUE;
}

int ManeuverReadyAdd(object oPC, int nManeuver)
{
    int nClass = GetLocalInt(oPC, PRC_MANEUVER_READY_CLASS_VAR);
    json jDraft = ManeuverReadyGetDraft(oPC);
    if (!GetLocalInt(oPC, PRC_MANEUVER_READY_ACTIVE_VAR)
        || !ManeuverReadyIsKnown(oPC, nClass, nManeuver)
        || ManeuverReadyDraftContains(oPC, nManeuver)
        || JsonGetLength(jDraft) >= ManeuverReadyTargetCount(oPC, nClass))
        return FALSE;

    SetLocalJson(
        oPC,
        PRC_MANEUVER_READY_DRAFT_VAR,
        JsonArrayInsert(jDraft, JsonInt(nManeuver))
    );
    return TRUE;
}

int ManeuverReadyRemove(object oPC, int nManeuver)
{
    json jDraft = ManeuverReadyGetDraft(oPC);
    json jNewDraft = JsonArray();
    int bRemoved;
    int i;
    for (i = 0; i < JsonGetLength(jDraft); i++)
    {
        int nCurrent = JsonGetInt(JsonArrayGet(jDraft, i));
        if (!bRemoved && nCurrent == nManeuver)
            bRemoved = TRUE;
        else
            jNewDraft = JsonArrayInsert(jNewDraft, JsonInt(nCurrent));
    }

    if (bRemoved)
        SetLocalJson(oPC, PRC_MANEUVER_READY_DRAFT_VAR, jNewDraft);
    return bRemoved;
}

void ManeuverReadyClear(object oPC)
{
    SetLocalJson(oPC, PRC_MANEUVER_READY_DRAFT_VAR, JsonArray());
}

string ManeuverReadyValidateDraft(object oPC)
{
    int nClass = GetLocalInt(oPC, PRC_MANEUVER_READY_CLASS_VAR);
    int nMode = GetLocalInt(oPC, PRC_MANEUVER_READY_MODE_VAR);
    json jDraft = GetLocalJson(oPC, PRC_MANEUVER_READY_DRAFT_VAR);
    if (!GetLocalInt(oPC, PRC_MANEUVER_READY_ACTIVE_VAR)
        || JsonGetType(jDraft) != JSON_TYPE_ARRAY)
        return "The maneuver draft is no longer active. Reopen it and try again.";
    if (!ManeuverReadyIsInitiatorClass(nClass)
        || GetLevelByClass(nClass, oPC) <= 0)
        return "You no longer have access to this initiator class.";
    if (GetLocalString(oPC, PRC_MANEUVER_READY_BASELINE_VAR)
        != ManeuverReadyCurrentSignature(oPC, nClass))
        return "Your readied maneuvers changed while this window was open. Reopen it to load the current roster.";

    string sCooldown = ManeuverReadyCooldownVar(nClass);
    if (nMode == PRC_MANEUVER_READY_MODE_NORMAL)
    {
        if (GetIsInCombat(oPC))
            return "You cannot finish normal maneuver readying while in combat.";
        if (sCooldown != "" && GetLocalInt(oPC, sCooldown))
            return "You may not ready maneuvers again yet.";
    }
    else
        return "The maneuver readying mode is no longer valid.";

    int nTarget = ManeuverReadyTargetCount(oPC, nClass);
    if (JsonGetLength(jDraft) != nTarget)
        return "Select exactly " + IntToString(nTarget) + " maneuvers before saving.";

    json jSeen = JsonObject();
    int i;
    for (i = 0; i < JsonGetLength(jDraft); i++)
    {
        int nManeuver = JsonGetInt(JsonArrayGet(jDraft, i));
        string sKey = IntToString(nManeuver);
        if (!ManeuverReadyIsKnown(oPC, nClass, nManeuver)
            || JsonObjectGet(jSeen, sKey) != JsonNull())
            return "The maneuver plan contains a choice you no longer know or a duplicate entry.";
        jSeen = JsonObjectSet(jSeen, sKey, JsonBool(TRUE));
    }
    return "";
}

void ManeuverReadyExpireCooldown(object oPC, int nClass, int nGeneration)
{
    string sCooldown = ManeuverReadyCooldownVar(nClass);
    string sGeneration = PRC_MANEUVER_READY_COOLDOWN_GENERATION_VAR_BASE
                       + IntToString(nClass);
    if (sCooldown == ""
        || GetLocalInt(oPC, sGeneration) != nGeneration)
        return;
    DeleteLocalInt(oPC, sCooldown);
}

int ManeuverReadyCommitDraft(object oPC)
{
    if (ManeuverReadyValidateDraft(oPC) != "")
        return FALSE;

    int nClass = GetLocalInt(oPC, PRC_MANEUVER_READY_CLASS_VAR);
    int nMode = GetLocalInt(oPC, PRC_MANEUVER_READY_MODE_VAR);
    json jDraft = ManeuverReadyGetDraft(oPC);

    ClearReadiedManeuvers(oPC, nClass);
    int i;
    for (i = 0; i < JsonGetLength(jDraft); i++)
        ReadyManeuver(oPC, nClass, JsonGetInt(JsonArrayGet(jDraft, i)));

    // Both legacy readying conversations recover the completed loadout.
    // Crusader recovery also rebuilds the granted/withheld roster here.
    RecoverExpendedManeuvers(oPC, nClass);

    if (nMode == PRC_MANEUVER_READY_MODE_NORMAL)
    {
        string sCooldown = ManeuverReadyCooldownVar(nClass);
        if (sCooldown != "")
        {
            string sGeneration = PRC_MANEUVER_READY_COOLDOWN_GENERATION_VAR_BASE
                               + IntToString(nClass);
            int nGeneration = GetLocalInt(oPC, sGeneration) + 1;
            if (nGeneration <= 0)
                nGeneration = 1;
            SetLocalInt(oPC, sGeneration, nGeneration);
            SetLocalInt(oPC, sCooldown, TRUE);
            DelayCommand(
                300.0f,
                ManeuverReadyExpireCooldown(oPC, nClass, nGeneration)
            );
        }
    }
    return TRUE;
}

void ManeuverReadyDiscardDraft(object oPC, int bCloseWindow = TRUE)
{
    if (bCloseWindow && GetIsPC(oPC))
    {
        int nToken = NuiFindWindow(oPC, PRC_MANEUVER_READY_NUI_WINDOW_ID);
        if (nToken)
            NuiDestroy(oPC, nToken);
    }

    DeleteLocalJson(oPC, PRC_MANEUVER_READY_DRAFT_VAR);
    DeleteLocalString(oPC, PRC_MANEUVER_READY_BASELINE_VAR);
    DeleteLocalInt(oPC, PRC_MANEUVER_READY_ACTIVE_VAR);
    DeleteLocalInt(oPC, PRC_MANEUVER_READY_CLASS_VAR);
    DeleteLocalInt(oPC, PRC_MANEUVER_READY_LEVEL_VAR);
    DeleteLocalInt(oPC, PRC_MANEUVER_READY_MODE_VAR);
    DeleteLocalInt(oPC, PRC_MANEUVER_READY_REBUILD_TOKEN_VAR);
    DeleteLocalJson(oPC, PRC_MANEUVER_READY_KNOWN_MAP_VAR);
    DeleteLocalJson(oPC, PRC_MANEUVER_READY_KNOWN_NAMES_VAR);
    DeleteLocalJson(oPC, PRC_MANEUVER_READY_PLAN_MAP_VAR);
    DeleteLocalJson(oPC, PRC_MANEUVER_READY_PLAN_NAMES_VAR);
}

void ManeuverReadyOpenDescription(object oPC, int nClass, int nManeuver)
{
    int nRow = ManeuverReadyGetDefinitionRow(nClass, nManeuver);
    if (nRow <= 0)
        return;

    string sFile = GetAMSDefinitionFileName(nClass);
    int nFeat = StringToInt(Get2DACache(sFile, "FeatID", nRow));
    int nSpell = StringToInt(Get2DACache(sFile, "SpellID", nRow));
    if (nFeat > 0 && nSpell > 0)
        CreateSpellDescriptionNUI(oPC, nFeat, nSpell, nManeuver, nClass);
}

void ManeuverReadyOpenEditor(object oPC, int nClass, int nMode)
{
    if (!GetIsPC(oPC)
        || nMode != PRC_MANEUVER_READY_MODE_NORMAL
        || !ManeuverReadyIsInitiatorClass(nClass)
        || GetLevelByClass(nClass, oPC) <= 0)
        return;

    int bActive = GetLocalInt(oPC, PRC_MANEUVER_READY_ACTIVE_VAR);
    int nDraftClass = GetLocalInt(oPC, PRC_MANEUVER_READY_CLASS_VAR);
    int nWindow = NuiFindWindow(oPC, PRC_MANEUVER_READY_NUI_WINDOW_ID);

    // A missing client window is a fresh entry. Do not resurrect a draft left
    // behind by a disconnect; internal refreshes call the view directly.
    if (bActive
        && (!nWindow
            || nDraftClass != nClass
            || GetLocalInt(oPC, PRC_MANEUVER_READY_MODE_VAR) != nMode))
    {
        ManeuverReadyDiscardDraft(oPC);
        bActive = FALSE;
    }

    if (!bActive)
    {
        if (!ManeuverReadyInitializeDraft(oPC, nClass, nMode))
            return;
    }
    ExecuteScript("prc_nui_mr_view", oPC);
}
