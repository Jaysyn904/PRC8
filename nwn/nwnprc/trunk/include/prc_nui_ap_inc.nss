//::///////////////////////////////////////////////
//:: PRC Archivist Preparation NUI helpers
//:: prc_nui_ap_inc
//:://////////////////////////////////////////////
/**
 * Keeps Archivist preparation editing separate from both the native Wizard
 * spellbook and the Archivist's live PRC casting resources.
 *
 * The draft is a local JSON object with one exact-slot array for each circle.
 * Only ArchivistPrepCommitDraft() writes persistent state, and it writes only
 * Spellbook<circle>_190 after validating the complete draft and its baseline.
 */

#include "prc_nui_com_inc"

const string PRC_ARCHIVIST_PREP_DRAFT_VAR       = "PRC_ArchivistPrep_Draft";
const string PRC_ARCHIVIST_PREP_BASELINE_VAR    = "PRC_ArchivistPrep_Baseline";
const string PRC_ARCHIVIST_PREP_ACTIVE_VAR      = "PRC_ArchivistPrep_Active";
const string PRC_ARCHIVIST_PREP_CIRCLE_VAR      = "PRC_ArchivistPrep_Circle";
const string PRC_ARCHIVIST_PREP_METAMAGIC_VAR   = "PRC_ArchivistPrep_Metamagic";
const string PRC_ARCHIVIST_PREP_GEOMETRY_VAR    = "PRC_ArchivistPrep_Geometry";
const string PRC_ARCHIVIST_PREP_REBUILD_TOKEN_VAR = "PRC_ArchivistPrep_RebuildToken";

const string PRC_ARCHIVIST_PREP_CIRCLE_BUTTON   = "archivistPrepCircle_";
const string PRC_ARCHIVIST_PREP_META_BUTTON     = "archivistPrepMeta_";
const string PRC_ARCHIVIST_PREP_KNOWN_BUTTON    = "archivistPrepKnown_";
const string PRC_ARCHIVIST_PREP_PLAN_BUTTON     = "archivistPrepPlan_";
const string PRC_ARCHIVIST_PREP_REMOVE_BUTTON   = "archivistPrepRemove_";
const string PRC_ARCHIVIST_PREP_CLEAR_BUTTON    = "archivistPrepClear";
const string PRC_ARCHIVIST_PREP_SAVE_BUTTON     = "archivistPrepSave";
const string PRC_ARCHIVIST_PREP_CANCEL_BUTTON   = "archivistPrepCancel";
const string PRC_ARCHIVIST_PREP_FILTER_BIND     = "archivistPrepFilter";
const string PRC_ARCHIVIST_PREP_FILTER_BUTTON   = "archivistPrepFilterButton";
const string PRC_ARCHIVIST_PREP_KNOWN_LIST_BTN  = "archivistPrepKnownList";
// Keep virtual-list bind names short and distinct. Long names which share a
// prefix can alias in the client and make adjacent list cells consume
// different spell-name entries.
const string PRC_ARCHIVIST_PREP_KNOWN_NAMES_BIND = "ap_kn_name";
const string PRC_ARCHIVIST_PREP_KNOWN_COUNT_BIND = "ap_kn_count";
const string PRC_ARCHIVIST_PREP_FILTER_VAR       = "PRC_ArchivistPrep_Filter";
const string PRC_ARCHIVIST_PREP_KNOWN_MAP_VAR    = "PRC_ArchivistPrep_KnownMap";
const string PRC_ARCHIVIST_PREP_KNOWN_NAMES_VAR  = "PRC_ArchivistPrep_KnownNames";

const string PRC_ARCHIVIST_PREP_SPELL_FILE      = "cls_spell_archv";
const int PRC_ARCHIVIST_PREP_VARIANT_SCAN_LIMIT = 32;

string ArchivistPrepPlanArrayName(int nCircle);
string ArchivistPrepKnownArrayName(int nCircle);
int ArchivistPrepGetSlotCount(object oPC, int nCircle);
string ArchivistPrepBuildPlanSignature(object oPC);
json ArchivistPrepBuildDraft(object oPC);
int ArchivistPrepInitializeDraft(object oPC = OBJECT_SELF);
void ArchivistPrepDiscardDraft(object oPC = OBJECT_SELF, int bCloseWindow = TRUE);
json ArchivistPrepGetDraftCircle(object oPC, int nCircle);
void ArchivistPrepSetDraftCircle(object oPC, int nCircle, json jCircle);
int ArchivistPrepFindVariant(int nBaseRow, int nMetamagic);
int ArchivistPrepIsKnownRow(object oPC, int nSpellbookRow, int nSlotCircle);
int ArchivistPrepDraftFilled(object oPC, int nCircle);
int ArchivistPrepDraftCountRow(object oPC, int nCircle, int nSpellbookRow);
int ArchivistPrepAddRow(object oPC, int nCircle, int nSpellbookRow);
int ArchivistPrepRemoveRow(object oPC, int nCircle, int nSpellbookRow);
void ArchivistPrepClearCircle(object oPC, int nCircle);
string ArchivistPrepValidateDraft(object oPC);
int ArchivistPrepCommitDraft(object oPC);
string ArchivistPrepSpellName(int nSpellbookRow);
void ArchivistPrepOpenDescription(object oPC, int nSpellbookRow);

string ArchivistPrepPlanArrayName(int nCircle)
{
    return GetSpellsToBeMemorized_Array(CLASS_TYPE_ARCHIVIST, nCircle);
}

string ArchivistPrepKnownArrayName(int nCircle)
{
    return GetSpellsKnown_Array(CLASS_TYPE_ARCHIVIST, nCircle);
}

int ArchivistPrepGetSlotCount(object oPC, int nCircle)
{
    if (!GetIsObjectValid(oPC) || nCircle < 0 || nCircle > 9)
        return 0;

    return GetSlotCount(
        GetSpellslotLevel(CLASS_TYPE_ARCHIVIST, oPC),
        nCircle,
        GetAbilityScoreForClass(CLASS_TYPE_ARCHIVIST, oPC),
        CLASS_TYPE_ARCHIVIST,
        oPC
    );
}

// Include both the stored size and every stored value. A legacy conversation
// edit, or another NUI instance, therefore invalidates an older draft.
string ArchivistPrepBuildPlanSignature(object oPC)
{
    string sSignature;
    int nCircle;
    for (nCircle = 0; nCircle <= 9; nCircle++)
    {
        string sArray = ArchivistPrepPlanArrayName(nCircle);
        int nSize = persistant_array_get_size(oPC, sArray);
        sSignature += IntToString(nCircle) + ":" + IntToString(nSize) + "[";

        int i;
        for (i = 0; i < nSize; i++)
            sSignature += IntToString(persistant_array_get_int(oPC, sArray, i)) + ",";

        sSignature += "];";
    }
    return sSignature;
}

json ArchivistPrepBuildDraft(object oPC)
{
    json jDraft = JsonObject();
    int nCircle;
    for (nCircle = 0; nCircle <= 9; nCircle++)
    {
        json jCircle = JsonArray();
        int nSlots = ArchivistPrepGetSlotCount(oPC, nCircle);
        string sArray = ArchivistPrepPlanArrayName(nCircle);
        int nStored = persistant_array_get_size(oPC, sArray);

        int i;
        for (i = 0; i < nSlots; i++)
        {
            int nRow;
            if (i < nStored)
                nRow = persistant_array_get_int(oPC, sArray, i);
            jCircle = JsonArrayInsert(jCircle, JsonInt(nRow));
        }

        jDraft = JsonObjectSet(jDraft, IntToString(nCircle), jCircle);
    }
    return jDraft;
}

int ArchivistPrepInitializeDraft(object oPC = OBJECT_SELF)
{
    if (!GetIsObjectValid(oPC) || GetLevelByClass(CLASS_TYPE_ARCHIVIST, oPC) <= 0)
        return FALSE;

    SetLocalJson(oPC, PRC_ARCHIVIST_PREP_DRAFT_VAR, ArchivistPrepBuildDraft(oPC));
    SetLocalString(oPC, PRC_ARCHIVIST_PREP_BASELINE_VAR, ArchivistPrepBuildPlanSignature(oPC));
    SetLocalInt(oPC, PRC_ARCHIVIST_PREP_ACTIVE_VAR, TRUE);
    SetLocalInt(oPC, PRC_ARCHIVIST_PREP_CIRCLE_VAR, 0);
    DeleteLocalInt(oPC, PRC_ARCHIVIST_PREP_METAMAGIC_VAR);
    return TRUE;
}

// Public integration hook. Rest start should call this so an unsaved draft
// cannot survive while the authoritative spellbook state is being rebuilt.
void ArchivistPrepDiscardDraft(object oPC = OBJECT_SELF, int bCloseWindow = TRUE)
{
    if (bCloseWindow && GetIsPC(oPC))
    {
        int nToken = NuiFindWindow(oPC, PRC_ARCHIVIST_PREP_NUI_WINDOW_ID);
        if (nToken)
            NuiDestroy(oPC, nToken);
    }

    DeleteLocalJson(oPC, PRC_ARCHIVIST_PREP_DRAFT_VAR);
    DeleteLocalString(oPC, PRC_ARCHIVIST_PREP_BASELINE_VAR);
    DeleteLocalInt(oPC, PRC_ARCHIVIST_PREP_ACTIVE_VAR);
    DeleteLocalInt(oPC, PRC_ARCHIVIST_PREP_CIRCLE_VAR);
    DeleteLocalInt(oPC, PRC_ARCHIVIST_PREP_METAMAGIC_VAR);
    DeleteLocalInt(oPC, PRC_ARCHIVIST_PREP_REBUILD_TOKEN_VAR);
    DeleteLocalString(oPC, PRC_ARCHIVIST_PREP_FILTER_VAR);
    DeleteLocalJson(oPC, PRC_ARCHIVIST_PREP_KNOWN_MAP_VAR);
    DeleteLocalJson(oPC, PRC_ARCHIVIST_PREP_KNOWN_NAMES_VAR);
}

json ArchivistPrepGetDraftCircle(object oPC, int nCircle)
{
    json jDraft = GetLocalJson(oPC, PRC_ARCHIVIST_PREP_DRAFT_VAR);
    if (JsonGetType(jDraft) != JSON_TYPE_OBJECT)
        return JsonNull();
    return JsonObjectGet(jDraft, IntToString(nCircle));
}

void ArchivistPrepSetDraftCircle(object oPC, int nCircle, json jCircle)
{
    json jDraft = GetLocalJson(oPC, PRC_ARCHIVIST_PREP_DRAFT_VAR);
    if (JsonGetType(jDraft) != JSON_TYPE_OBJECT)
        return;

    jDraft = JsonObjectSet(jDraft, IntToString(nCircle), jCircle);
    SetLocalJson(oPC, PRC_ARCHIVIST_PREP_DRAFT_VAR, jDraft);
}

int ArchivistPrepFindVariant(int nBaseRow, int nMetamagic)
{
    string sBaseReal = Get2DACache(PRC_ARCHIVIST_PREP_SPELL_FILE, "RealSpellID", nBaseRow);
    if (sBaseReal == "" || sBaseReal == "****")
        return 0;

    if (nMetamagic == METAMAGIC_NONE)
    {
        int nBaseReq = StringToInt(Get2DACache(PRC_ARCHIVIST_PREP_SPELL_FILE, "ReqFeat", nBaseRow));
        return nBaseReq == 0 ? nBaseRow : 0;
    }

    int i;
    for (i = nBaseRow + 1; i <= nBaseRow + PRC_ARCHIVIST_PREP_VARIANT_SCAN_LIMIT; i++)
    {
        string sReal = Get2DACache(PRC_ARCHIVIST_PREP_SPELL_FILE, "RealSpellID", i);
        if (sReal == "" || sReal == "****" || sReal != sBaseReal)
            break;

        int nReqFeat = StringToInt(Get2DACache(PRC_ARCHIVIST_PREP_SPELL_FILE, "ReqFeat", i));
        if (nReqFeat && GetMetaMagicFromFeat(nReqFeat) == nMetamagic)
            return i;
    }
    return 0;
}

// Proves that a stored row is a normal or metamagic version of a base row in
// the Archivist's learned library for the matching source circle.
int ArchivistPrepIsKnownRow(object oPC, int nSpellbookRow, int nSlotCircle)
{
    if (nSpellbookRow <= 0 || nSlotCircle < 0 || nSlotCircle > 9)
        return FALSE;

    string sLevel = Get2DACache(PRC_ARCHIVIST_PREP_SPELL_FILE, "Level", nSpellbookRow);
    string sReal = Get2DACache(PRC_ARCHIVIST_PREP_SPELL_FILE, "RealSpellID", nSpellbookRow);
    if (sLevel == "" || sLevel == "****" || StringToInt(sLevel) != nSlotCircle
        || sReal == "" || sReal == "****")
        return FALSE;

    int nReqFeat = StringToInt(Get2DACache(PRC_ARCHIVIST_PREP_SPELL_FILE, "ReqFeat", nSpellbookRow));
    int nMetamagic = GetMetaMagicFromFeat(nReqFeat);
    if (nReqFeat && (!nMetamagic || !GetHasFeat(nReqFeat, oPC)))
        return FALSE;

    int nSourceCircle = nSlotCircle - GetMetaMagicSpellLevelAdjustment(nMetamagic);
    if (nSourceCircle < 0 || nSourceCircle > 9)
        return FALSE;

    string sKnown = ArchivistPrepKnownArrayName(nSourceCircle);
    int nKnown = persistant_array_get_size(oPC, sKnown);
    int i;
    for (i = 0; i < nKnown; i++)
    {
        int nBaseRow = persistant_array_get_int(oPC, sKnown, i);
        string sBaseLevel = Get2DACache(PRC_ARCHIVIST_PREP_SPELL_FILE, "Level", nBaseRow);
        int nBaseReqFeat = StringToInt(Get2DACache(PRC_ARCHIVIST_PREP_SPELL_FILE, "ReqFeat", nBaseRow));
        if (sBaseLevel == "" || sBaseLevel == "****"
            || StringToInt(sBaseLevel) != nSourceCircle || nBaseReqFeat != 0)
            continue;
        if (ArchivistPrepFindVariant(nBaseRow, nMetamagic) == nSpellbookRow)
            return TRUE;
    }
    return FALSE;
}

int ArchivistPrepDraftFilled(object oPC, int nCircle)
{
    json jCircle = ArchivistPrepGetDraftCircle(oPC, nCircle);
    if (JsonGetType(jCircle) != JSON_TYPE_ARRAY)
        return 0;

    int nFilled;
    int i;
    for (i = 0; i < JsonGetLength(jCircle); i++)
    {
        if (JsonGetInt(JsonArrayGet(jCircle, i)) > 0)
            nFilled++;
    }
    return nFilled;
}

int ArchivistPrepDraftCountRow(object oPC, int nCircle, int nSpellbookRow)
{
    json jCircle = ArchivistPrepGetDraftCircle(oPC, nCircle);
    if (JsonGetType(jCircle) != JSON_TYPE_ARRAY)
        return 0;

    int nCount;
    int i;
    for (i = 0; i < JsonGetLength(jCircle); i++)
    {
        if (JsonGetInt(JsonArrayGet(jCircle, i)) == nSpellbookRow)
            nCount++;
    }
    return nCount;
}

int ArchivistPrepAddRow(object oPC, int nCircle, int nSpellbookRow)
{
    json jCircle = ArchivistPrepGetDraftCircle(oPC, nCircle);
    if (JsonGetType(jCircle) != JSON_TYPE_ARRAY
        || JsonGetLength(jCircle) != ArchivistPrepGetSlotCount(oPC, nCircle)
        || !ArchivistPrepIsKnownRow(oPC, nSpellbookRow, nCircle))
        return FALSE;

    int i;
    for (i = 0; i < JsonGetLength(jCircle); i++)
    {
        if (JsonGetInt(JsonArrayGet(jCircle, i)) == 0)
        {
            jCircle = JsonArraySet(jCircle, i, JsonInt(nSpellbookRow));
            ArchivistPrepSetDraftCircle(oPC, nCircle, jCircle);
            return TRUE;
        }
    }
    return FALSE;
}

int ArchivistPrepRemoveRow(object oPC, int nCircle, int nSpellbookRow)
{
    json jCircle = ArchivistPrepGetDraftCircle(oPC, nCircle);
    if (JsonGetType(jCircle) != JSON_TYPE_ARRAY)
        return FALSE;

    int i;
    for (i = JsonGetLength(jCircle) - 1; i >= 0; i--)
    {
        if (JsonGetInt(JsonArrayGet(jCircle, i)) == nSpellbookRow)
        {
            jCircle = JsonArraySet(jCircle, i, JsonInt(0));
            ArchivistPrepSetDraftCircle(oPC, nCircle, jCircle);
            return TRUE;
        }
    }
    return FALSE;
}

void ArchivistPrepClearCircle(object oPC, int nCircle)
{
    json jCircle = ArchivistPrepGetDraftCircle(oPC, nCircle);
    if (JsonGetType(jCircle) != JSON_TYPE_ARRAY)
        return;

    int i;
    for (i = 0; i < JsonGetLength(jCircle); i++)
        jCircle = JsonArraySet(jCircle, i, JsonInt(0));
    ArchivistPrepSetDraftCircle(oPC, nCircle, jCircle);
}

string ArchivistPrepValidateDraft(object oPC)
{
    if (!GetIsObjectValid(oPC) || GetLevelByClass(CLASS_TYPE_ARCHIVIST, oPC) <= 0)
        return "You no longer have Archivist spellcasting.";

    json jDraft = GetLocalJson(oPC, PRC_ARCHIVIST_PREP_DRAFT_VAR);
    if (!GetLocalInt(oPC, PRC_ARCHIVIST_PREP_ACTIVE_VAR)
        || JsonGetType(jDraft) != JSON_TYPE_OBJECT)
        return "The preparation draft is no longer active. Reopen it and try again.";

    if (GetLocalString(oPC, PRC_ARCHIVIST_PREP_BASELINE_VAR)
        != ArchivistPrepBuildPlanSignature(oPC))
        return "Your next-rest preparation changed elsewhere while this window was open. Reopen the window to load the current plan.";

    int nCircle;
    for (nCircle = 0; nCircle <= 9; nCircle++)
    {
        json jCircle = JsonObjectGet(jDraft, IntToString(nCircle));
        int nSlots = ArchivistPrepGetSlotCount(oPC, nCircle);
        if (JsonGetType(jCircle) != JSON_TYPE_ARRAY || JsonGetLength(jCircle) != nSlots)
            return "Your available Archivist slots changed while this window was open. Reopen it before saving.";

        int i;
        for (i = 0; i < nSlots; i++)
        {
            json jValue = JsonArrayGet(jCircle, i);
            if (JsonGetType(jValue) != JSON_TYPE_INTEGER)
                return "The preparation draft contains an invalid slot value.";

            int nRow = JsonGetInt(jValue);
            if (nRow < 0)
                return "The preparation draft contains an invalid spell row.";
            if (nRow > 0 && !ArchivistPrepIsKnownRow(oPC, nRow, nCircle))
                return "A prepared spell or metamagic choice is no longer valid. Reopen the window and choose it again.";
        }
    }
    return "";
}

int ArchivistPrepCommitDraft(object oPC)
{
    if (ArchivistPrepValidateDraft(oPC) != "")
        return FALSE;

    json jDraft = GetLocalJson(oPC, PRC_ARCHIVIST_PREP_DRAFT_VAR);
    int nCircle;
    for (nCircle = 0; nCircle <= 9; nCircle++)
    {
        json jCircle = JsonObjectGet(jDraft, IntToString(nCircle));
        string sArray = ArchivistPrepPlanArrayName(nCircle);
        int nSlots = JsonGetLength(jCircle);

        int nOldSize = persistant_array_get_size(oPC, sArray);
        if (nOldSize < 0)
        {
            if (persistant_array_create(oPC, sArray) != SDL_SUCCESS)
                return FALSE;
            nOldSize = 0;
        }

        // Shrink synchronously so entries above the new capacity cannot
        // reappear if the character later regains slots. Growing is handled
        // by the indexed writes below, which update the +1 size marker.
        if (nOldSize > nSlots
            && persistant_array_shrink(oPC, sArray, nSlots) != SDL_SUCCESS)
            return FALSE;

        int i;
        for (i = 0; i < nSlots; i++)
        {
            if (persistant_array_set_int(oPC, sArray, i, JsonGetInt(JsonArrayGet(jCircle, i))) != SDL_SUCCESS)
                return FALSE;
        }
    }
    return TRUE;
}

string ArchivistPrepSpellName(int nSpellbookRow)
{
    int nRealSpell = StringToInt(Get2DACache(PRC_ARCHIVIST_PREP_SPELL_FILE, "RealSpellID", nSpellbookRow));
    string sName = GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nRealSpell)));
    int nReqFeat = StringToInt(Get2DACache(PRC_ARCHIVIST_PREP_SPELL_FILE, "ReqFeat", nSpellbookRow));
    int nMetamagic = GetMetaMagicFromFeat(nReqFeat);
    if (nMetamagic)
        sName += " (" + GetMetaMagicString(nMetamagic) + ")";
    return sName;
}

void ArchivistPrepOpenDescription(object oPC, int nSpellbookRow)
{
    int nFeat = StringToInt(Get2DACache(PRC_ARCHIVIST_PREP_SPELL_FILE, "FeatID", nSpellbookRow));
    int nSpell = StringToInt(Get2DACache(PRC_ARCHIVIST_PREP_SPELL_FILE, "SpellID", nSpellbookRow));
    int nRealSpell = StringToInt(Get2DACache(PRC_ARCHIVIST_PREP_SPELL_FILE, "RealSpellID", nSpellbookRow));
    CreateSpellDescriptionNUI(oPC, nFeat, nSpell, nRealSpell, CLASS_TYPE_ARCHIVIST);
}
