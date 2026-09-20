//::///////////////////////////////////////////////
//:: PRC Binder pact-management NUI shared code
//:: prc_nui_bnd_inc
//:://////////////////////////////////////////////
/**
 * Staged, server-authoritative Binder pact management.  Nothing in this
 * include replaces the legacy conversations; it is a parallel opt-in path.
 * Draft choices use private locals/JSON and are copied to the legacy Binder
 * locals only after complete validation and explicit confirmation.
 */

#include "nw_inc_nui"
#include "bnd_inc_bndfunc"
#include "prc_nui_consts"
#include "prc_nui_bnd_cst"

const string PRC_BINDER_NUI_ACTIVE_VAR          = "PRC_BinderNUI_Active";
const string PRC_BINDER_NUI_STAGE_VAR           = "PRC_BinderNUI_Stage";
const string PRC_BINDER_NUI_SESSION_VAR         = "PRC_BinderNUI_Session";
const string PRC_BINDER_NUI_VIEW_GEN_VAR        = "PRC_BinderNUI_ViewGen";
const string PRC_BINDER_NUI_MAP_GEN_VAR         = "PRC_BinderNUI_MapGen";
const string PRC_BINDER_NUI_REBUILD_TOKEN_VAR   = "PRC_BinderNUI_RebuildToken";
const string PRC_BINDER_NUI_GEOMETRY_VAR        = "PRC_BinderNUI_Geometry";
const string PRC_BINDER_NUI_BASELINE_VAR        = "PRC_BinderNUI_Baseline";

const string PRC_BINDER_NUI_HOME_BIND_MAP_VAR   = "PRC_BinderNUI_HomeBindMap";
const string PRC_BINDER_NUI_HOME_BIND_NAMES_VAR = "PRC_BinderNUI_HomeBindNames";
const string PRC_BINDER_NUI_HOME_BOUND_MAP_VAR  = "PRC_BinderNUI_HomeBoundMap";
const string PRC_BINDER_NUI_HOME_BOUND_NAMES_VAR= "PRC_BinderNUI_HomeBoundNames";
const string PRC_BINDER_NUI_CHOICE_MAP_VAR      = "PRC_BinderNUI_ChoiceMap";
const string PRC_BINDER_NUI_CHOICE_NAMES_VAR    = "PRC_BinderNUI_ChoiceNames";

const string PRC_BINDER_NUI_SELECTED_ROW_VAR    = "PRC_BinderNUI_SelectedRow";
const string PRC_BINDER_NUI_METHOD_VAR          = "PRC_BinderNUI_Method";
const string PRC_BINDER_NUI_AUGMENT_VAR         = "PRC_BinderNUI_Augment";
const string PRC_BINDER_NUI_NABERIUS_VAR        = "PRC_BinderNUI_Naberius";
const string PRC_BINDER_NUI_EXPLOIT_VAR         = "PRC_BinderNUI_Exploit";
const string PRC_BINDER_NUI_ASTAROTH_VAR        = "PRC_BinderNUI_Astaroth";

const string PRC_BINDER_NUI_RITUAL_GEN_VAR      = "PRC_BinderNUI_RitualGen";
const string PRC_BINDER_NUI_RITUAL_TYPE_VAR     = "PRC_BinderNUI_RitualType";
const string PRC_BINDER_NUI_RITUAL_ROW_VAR      = "PRC_BinderNUI_RitualRow";
const string PRC_BINDER_NUI_RITUAL_NAB_VAR      = "PRC_BinderNUI_RitualNab";
const string PRC_BINDER_NUI_PENDING_SPELL_VAR   = "PRC_BinderNUI_PendingSpell";

// Function prototypes required by recursive delayed ritual callbacks.
int BinderNUIHasAccess(object oPC = OBJECT_SELF);
void BinderNUIOpen(object oPC = OBJECT_SELF);
void BinderNUIStartSession(object oPC = OBJECT_SELF);
void BinderNUIDiscardDraft(object oPC = OBJECT_SELF, int bCloseWindow = TRUE);
void BinderNUIContactTick(object oPC, int nTime, int nVestigeRow, int nRitualType, int nGeneration);
void BinderNUIBindTick(object oPC, int nTime, int nVestigeRow, int nRitualType, int nGeneration);
void BinderNUIOpenExploitSpell(object oPC, int nGeneration);
void BinderNUIApplyAstarothFeat(object oPC, int nFeat, int nGeneration);

int BinderNUIHasAccess(object oPC = OBJECT_SELF)
{
    if (!GetIsObjectValid(oPC) || !GetIsPC(oPC))
        return FALSE;
    return GetLevelByClass(CLASS_TYPE_BINDER, oPC) > 0
        || GetHasFeat(FEAT_BIND_VESTIGE, oPC);
}

// Public lightweight opener hook for spellbook/radial integrations.
void BinderNUIOpen(object oPC = OBJECT_SELF)
{
    if (GetIsObjectValid(oPC))
        ExecuteScript(PRC_BINDER_NUI_OPEN_SCRIPT, oPC);
}

string BinderNUIVestigeName(int nVestigeRow)
{
    string sName = GetStringByStrRef(StringToInt(
        Get2DACache(GetVestigeFile(), "Name", nVestigeRow)
    ));
    if (sName == "")
        sName = Get2DACache(GetVestigeFile(), "Label", nVestigeRow);
    return sName;
}

string BinderNUIVestigeDescription(int nVestigeRow)
{
    return GetStringByStrRef(StringToInt(
        Get2DACache(GetVestigeFile(), "Description", nVestigeRow)
    ));
}

int BinderNUIVestigeSpell(int nVestigeRow)
{
    return StringToInt(Get2DACache(GetVestigeFile(), "SpellID", nVestigeRow));
}

int BinderNUIIsValidVestigeRow(int nVestigeRow)
{
    if (nVestigeRow < 1 || nVestigeRow >= 50)
        return FALSE;
    return BinderNUIVestigeSpell(nVestigeRow) > 0
        && BinderNUIVestigeName(nVestigeRow) != "";
}

string BinderNUIBuildBaseline(object oPC)
{
    string sResult = IntToString(GetBinderLevel(oPC)) + ":"
        + IntToString(GetMaxVestigeLevel(oPC)) + ":"
        + IntToString(GetMaxVestigeCount(oPC)) + ":"
        + IntToString(GetBindCount(oPC)) + ":";

    int i;
    for (i = 1; i < 50; i++)
    {
        int nSpell = BinderNUIVestigeSpell(i);
        if (nSpell > 0 && GetHasSpellEffect(nSpell, oPC))
            sResult += IntToString(i) + ",";
    }
    return sResult;
}

int BinderNUIMapContains(json jMap, int nValue)
{
    if (JsonGetType(jMap) != JSON_TYPE_ARRAY)
        return FALSE;
    int i;
    for (i = 0; i < JsonGetLength(jMap); i++)
    {
        if (JsonGetType(JsonArrayGet(jMap, i)) == JSON_TYPE_INTEGER
            && JsonGetInt(JsonArrayGet(jMap, i)) == nValue)
            return TRUE;
    }
    return FALSE;
}

int BinderNUIGetMappedChoice(object oPC, int nIndex)
{
    if (GetLocalInt(oPC, PRC_BINDER_NUI_MAP_GEN_VAR)
            != GetLocalInt(oPC, PRC_BINDER_NUI_VIEW_GEN_VAR))
        return -1;

    json jMap = GetLocalJson(oPC, PRC_BINDER_NUI_CHOICE_MAP_VAR);
    if (JsonGetType(jMap) != JSON_TYPE_ARRAY
        || nIndex < 0 || nIndex >= JsonGetLength(jMap))
        return -1;

    json jValue = JsonArrayGet(jMap, nIndex);
    if (JsonGetType(jValue) != JSON_TYPE_INTEGER)
        return -1;
    return JsonGetInt(jValue);
}

void BinderNUISetChoiceMap(object oPC, json jMap, json jNames)
{
    SetLocalJson(oPC, PRC_BINDER_NUI_CHOICE_MAP_VAR, jMap);
    SetLocalJson(oPC, PRC_BINDER_NUI_CHOICE_NAMES_VAR, jNames);
}

json BinderNUINewAugmentDraft()
{
    json jDraft = JsonArray();
    int i;
    for (i = 1; i <= 11; i++)
        jDraft = JsonArrayInsert(jDraft, JsonInt(0));
    return jDraft;
}

int BinderNUIAugmentTotal(object oPC)
{
    json jDraft = GetLocalJson(oPC, PRC_BINDER_NUI_AUGMENT_VAR);
    if (JsonGetType(jDraft) != JSON_TYPE_ARRAY || JsonGetLength(jDraft) != 11)
        return 0;
    int nTotal;
    int i;
    for (i = 0; i < 11; i++)
        nTotal += JsonGetInt(JsonArrayGet(jDraft, i));
    return nTotal;
}

int BinderNUIAugmentAdd(object oPC, int nChoice)
{
    int nTarget = GetPactAugmentCount(oPC);
    if (nChoice < 1 || nChoice > 11
        || BinderNUIAugmentTotal(oPC) >= nTarget)
        return FALSE;

    json jDraft = GetLocalJson(oPC, PRC_BINDER_NUI_AUGMENT_VAR);
    if (JsonGetType(jDraft) != JSON_TYPE_ARRAY || JsonGetLength(jDraft) != 11)
        return FALSE;
    int nValue = JsonGetInt(JsonArrayGet(jDraft, nChoice - 1));
    jDraft = JsonArraySet(jDraft, nChoice - 1, JsonInt(nValue + 1));
    SetLocalJson(oPC, PRC_BINDER_NUI_AUGMENT_VAR, jDraft);
    return TRUE;
}

string BinderNUIAugmentName(int nChoice)
{
    switch (nChoice)
    {
        case 1:  return "5 temporary hit points";
        case 2:  return "Resist Acid 5";
        case 3:  return "Resist Cold 5";
        case 4:  return "Resist Electricity 5";
        case 5:  return "Resist Fire 5";
        case 6:  return "Resist Sonic 5";
        case 7:  return "+1 all saving throws";
        case 8:  return "Damage resistance 1/-";
        case 9:  return "+1 Armor Class";
        case 10: return "+1 attack";
        case 11: return "+1 damage";
    }
    return "Unknown augmentation";
}

string BinderNUIAugmentSummary(object oPC)
{
    json jDraft = GetLocalJson(oPC, PRC_BINDER_NUI_AUGMENT_VAR);
    if (JsonGetType(jDraft) != JSON_TYPE_ARRAY || JsonGetLength(jDraft) != 11)
        return "None";

    string sResult;
    int i;
    for (i = 1; i <= 11; i++)
    {
        int nCount = JsonGetInt(JsonArrayGet(jDraft, i - 1));
        if (nCount > 0)
        {
            if (sResult != "")
                sResult += ", ";
            if (nCount > 1)
                sResult += IntToString(nCount) + "x ";
            sResult += BinderNUIAugmentName(i);
        }
    }
    if (sResult == "")
        return "None";
    return sResult;
}

int BinderNUINaberiusContains(object oPC, int nSkill)
{
    return BinderNUIMapContains(
        GetLocalJson(oPC, PRC_BINDER_NUI_NABERIUS_VAR),
        nSkill
    );
}

int BinderNUINaberiusAdd(object oPC, int nSkill)
{
    int nTarget = GetAbilityModifier(ABILITY_CONSTITUTION, oPC);
    json jDraft = GetLocalJson(oPC, PRC_BINDER_NUI_NABERIUS_VAR);
    if (JsonGetType(jDraft) != JSON_TYPE_ARRAY
        || JsonGetLength(jDraft) >= nTarget
        || nSkill < 0 || nSkill >= 40
        || BinderNUINaberiusContains(oPC, nSkill)
        || GetLocalInt(oPC, "NaberiusSkill" + IntToString(nSkill))
        || GetSkillRank(nSkill, oPC, TRUE) != 0
        || !StringToInt(Get2DACache("skills", "Untrained", nSkill)))
        return FALSE;

    string sName = GetStringByStrRef(StringToInt(Get2DACache("skills", "Name", nSkill)));
    if (sName == "")
        return FALSE;
    jDraft = JsonArrayInsert(jDraft, JsonInt(nSkill));
    SetLocalJson(oPC, PRC_BINDER_NUI_NABERIUS_VAR, jDraft);
    return TRUE;
}

string BinderNUINaberiusSummary(object oPC)
{
    json jDraft = GetLocalJson(oPC, PRC_BINDER_NUI_NABERIUS_VAR);
    if (JsonGetType(jDraft) != JSON_TYPE_ARRAY || JsonGetLength(jDraft) == 0)
        return "None";
    string sResult;
    int i;
    for (i = 0; i < JsonGetLength(jDraft); i++)
    {
        int nSkill = JsonGetInt(JsonArrayGet(jDraft, i));
        string sName = GetStringByStrRef(StringToInt(Get2DACache("skills", "Name", nSkill)));
        if (sResult != "")
            sResult += ", ";
        sResult += sName;
    }
    return sResult;
}

void BinderNUIClearTransientMaps(object oPC)
{
    DeleteLocalJson(oPC, PRC_BINDER_NUI_CHOICE_MAP_VAR);
    DeleteLocalJson(oPC, PRC_BINDER_NUI_CHOICE_NAMES_VAR);
    DeleteLocalInt(oPC, PRC_BINDER_NUI_MAP_GEN_VAR);
}

void BinderNUIResetDraft(object oPC)
{
    DeleteLocalInt(oPC, PRC_BINDER_NUI_SELECTED_ROW_VAR);
    DeleteLocalInt(oPC, PRC_BINDER_NUI_METHOD_VAR);
    DeleteLocalJson(oPC, PRC_BINDER_NUI_AUGMENT_VAR);
    DeleteLocalJson(oPC, PRC_BINDER_NUI_NABERIUS_VAR);
    DeleteLocalInt(oPC, PRC_BINDER_NUI_EXPLOIT_VAR);
    DeleteLocalInt(oPC, PRC_BINDER_NUI_ASTAROTH_VAR);
    BinderNUIClearTransientMaps(oPC);
}

void BinderNUIDiscardDraft(object oPC = OBJECT_SELF, int bCloseWindow = TRUE)
{
    if (bCloseWindow && GetIsPC(oPC))
    {
        int nToken = NuiFindWindow(oPC, PRC_BINDER_NUI_WINDOW_ID);
        if (nToken)
            NuiDestroy(oPC, nToken);
    }

    BinderNUIResetDraft(oPC);
    DeleteLocalJson(oPC, PRC_BINDER_NUI_HOME_BIND_MAP_VAR);
    DeleteLocalJson(oPC, PRC_BINDER_NUI_HOME_BIND_NAMES_VAR);
    DeleteLocalJson(oPC, PRC_BINDER_NUI_HOME_BOUND_MAP_VAR);
    DeleteLocalJson(oPC, PRC_BINDER_NUI_HOME_BOUND_NAMES_VAR);
    DeleteLocalString(oPC, PRC_BINDER_NUI_BASELINE_VAR);
    DeleteLocalInt(oPC, PRC_BINDER_NUI_ACTIVE_VAR);
    DeleteLocalInt(oPC, PRC_BINDER_NUI_STAGE_VAR);
    DeleteLocalInt(oPC, PRC_BINDER_NUI_REBUILD_TOKEN_VAR);
}

int BinderNUIBasicCanBindRow(object oPC, int nVestigeRow)
{
    if (!BinderNUIHasAccess(oPC)
        || !BinderNUIIsValidVestigeRow(nVestigeRow)
        || GetBindCount(oPC) >= GetMaxVestigeCount(oPC)
        || GetVestigeLevel(nVestigeRow) > GetMaxVestigeLevel(oPC))
        return FALSE;

    int nSpell = BinderNUIVestigeSpell(nVestigeRow);
    return !GetHasSpellEffect(nSpell, oPC);
}

void BinderNUIBuildHomeMaps(object oPC)
{
    json jBindMap = JsonArray();
    json jBindNames = JsonArray();
    json jBoundMap = JsonArray();
    json jBoundNames = JsonArray();
    int bHasRoom = GetBindCount(oPC) < GetMaxVestigeCount(oPC);

    int i;
    for (i = 1; i < 50; i++)
    {
        if (!BinderNUIIsValidVestigeRow(i))
            continue;
        int nSpell = BinderNUIVestigeSpell(i);
        string sName = BinderNUIVestigeName(i);

        if (GetHasSpellEffect(nSpell, oPC))
        {
            string sQuality = "bad pact";
            if (GetLocalInt(oPC, "PactQuality" + IntToString(nSpell)))
                sQuality = "good pact";
            jBoundMap = JsonArrayInsert(jBoundMap, JsonInt(i));
            jBoundNames = JsonArrayInsert(jBoundNames, JsonString(
                sName + " (level " + IntToString(GetVestigeLevel(i))
                + ", " + sQuality + ")"
            ));
        }
        else if (bHasRoom
            && GetVestigeLevel(i) <= GetMaxVestigeLevel(oPC)
            // This is deliberately evaluated once per session, matching the
            // legacy conversation's setup-stage requirement check.
            && DoSpecialRequirements(oPC, nSpell))
        {
            jBindMap = JsonArrayInsert(jBindMap, JsonInt(i));
            jBindNames = JsonArrayInsert(jBindNames, JsonString(
                sName + " (level " + IntToString(GetVestigeLevel(i)) + ")"
            ));
        }
    }

    SetLocalJson(oPC, PRC_BINDER_NUI_HOME_BIND_MAP_VAR, jBindMap);
    SetLocalJson(oPC, PRC_BINDER_NUI_HOME_BIND_NAMES_VAR, jBindNames);
    SetLocalJson(oPC, PRC_BINDER_NUI_HOME_BOUND_MAP_VAR, jBoundMap);
    SetLocalJson(oPC, PRC_BINDER_NUI_HOME_BOUND_NAMES_VAR, jBoundNames);
    SetLocalString(oPC, PRC_BINDER_NUI_BASELINE_VAR, BinderNUIBuildBaseline(oPC));
}

void BinderNUIStartSession(object oPC = OBJECT_SELF)
{
    if (!BinderNUIHasAccess(oPC))
    {
        SendMessageToPC(oPC, "You do not have Soul Binding or the Bind Vestige feat.");
        return;
    }

    int nSession = GetLocalInt(oPC, PRC_BINDER_NUI_SESSION_VAR) + 1;
    SetLocalInt(oPC, PRC_BINDER_NUI_SESSION_VAR, nSession);
    SetLocalInt(oPC, PRC_BINDER_NUI_ACTIVE_VAR, TRUE);
    SetLocalInt(oPC, PRC_BINDER_NUI_STAGE_VAR, PRC_BINDER_NUI_STAGE_HOME);
    BinderNUIResetDraft(oPC);
    BinderNUIBuildHomeMaps(oPC);
}

void BinderNUIBuildExploitChoices(object oPC, int nVestigeRow)
{
    json jMap = JsonArray();
    json jNames = JsonArray();
    int i;
    for (i = 0; i < 150; i++)
    {
        int nOwner = StringToInt(Get2DACache("vestigeabil", "VestigeNum", i));
        if (nOwner < nVestigeRow)
            continue;
        if (nOwner > nVestigeRow)
            break;
        string sAbility = Get2DACache("vestigeabil", "Ability", i);
        if (sAbility != "")
        {
            jMap = JsonArrayInsert(jMap, JsonInt(i));
            jNames = JsonArrayInsert(jNames, JsonString(sAbility));
        }
    }
    jMap = JsonArrayInsert(jMap, JsonInt(0));
    jNames = JsonArrayInsert(jNames, JsonString("None - keep every granted ability"));
    BinderNUISetChoiceMap(oPC, jMap, jNames);
}

void BinderNUIBuildMethodChoices(object oPC)
{
    json jMap = JsonArray();
    json jNames = JsonArray();
    jMap = JsonArrayInsert(jMap, JsonInt(PRC_BINDER_NUI_METHOD_NORMAL));
    jNames = JsonArrayInsert(jNames, JsonString("Normal pact (normal binding check)"));
    jMap = JsonArrayInsert(jMap, JsonInt(PRC_BINDER_NUI_METHOD_RUSHED));
    jNames = JsonArrayInsert(jNames, JsonString(
        "Rushed bind (one round, -10 binding check)"
    ));
    if (GetHasFeat(FEAT_RAPID_PACT_MAKING, oPC)
        && !GetLocalInt(oPC, "RapidPactMaking"))
    {
        jMap = JsonArrayInsert(jMap, JsonInt(PRC_BINDER_NUI_METHOD_RAPID));
        jNames = JsonArrayInsert(jNames, JsonString(
            "Rapid Pact Making (one round, no check penalty; once per rest)"
        ));
    }
    BinderNUISetChoiceMap(oPC, jMap, jNames);
}

void BinderNUIBuildAugmentChoices(object oPC)
{
    json jMap = JsonArray();
    json jNames = JsonArray();
    int i;
    for (i = 1; i <= 11; i++)
    {
        jMap = JsonArrayInsert(jMap, JsonInt(i));
        jNames = JsonArrayInsert(jNames, JsonString(BinderNUIAugmentName(i)));
    }
    BinderNUISetChoiceMap(oPC, jMap, jNames);
}

void BinderNUIBuildNaberiusChoices(object oPC)
{
    json jMap = JsonArray();
    json jNames = JsonArray();
    int i;
    for (i = 0; i < 40; i++)
    {
        string sName = GetStringByStrRef(StringToInt(Get2DACache("skills", "Name", i)));
        if (sName != ""
            && GetSkillRank(i, oPC, TRUE) == 0
            && StringToInt(Get2DACache("skills", "Untrained", i))
            && !GetLocalInt(oPC, "NaberiusSkill" + IntToString(i))
            && !BinderNUINaberiusContains(oPC, i))
        {
            jMap = JsonArrayInsert(jMap, JsonInt(i));
            jNames = JsonArrayInsert(jNames, JsonString(sName));
        }
    }
    BinderNUISetChoiceMap(oPC, jMap, jNames);
}

int BinderNUIIsAstarothFeatValid(object oPC, int nFeat)
{
    int nBinderLevel = GetBinderLevel(oPC, VESTIGE_ASTAROTH);
    if (nFeat == FEAT_SCRIBE_SCROLL
        || nFeat == FEAT_BREW_POTION
        || nFeat == FEAT_CRAFT_WONDROUS
        || nFeat == FEAT_CRAFT_ARMS_ARMOR
        || nFeat == FEAT_CRAFT_WAND)
        return TRUE;
    if (nFeat == FEAT_CRAFT_ROD)
        return nBinderLevel >= 9;
    if (nFeat == FEAT_CRAFT_STAFF || nFeat == FEAT_FORGE_RING)
        return nBinderLevel >= 12;
    return FALSE;
}

string BinderNUIAstarothFeatName(int nFeat)
{
    if (nFeat == FEAT_SCRIBE_SCROLL)    return "Scribe Scroll";
    if (nFeat == FEAT_BREW_POTION)      return "Brew Potion";
    if (nFeat == FEAT_CRAFT_WONDROUS)   return "Craft Wondrous Item";
    if (nFeat == FEAT_CRAFT_ARMS_ARMOR) return "Craft Magic Arms and Armor";
    if (nFeat == FEAT_CRAFT_WAND)       return "Craft Wand";
    if (nFeat == FEAT_CRAFT_ROD)        return "Craft Rod";
    if (nFeat == FEAT_CRAFT_STAFF)      return "Craft Staff";
    if (nFeat == FEAT_FORGE_RING)       return "Forge Ring";
    return "None";
}

void BinderNUIBuildAstarothChoices(object oPC)
{
    json jMap = JsonArray();
    json jNames = JsonArray();
    int i;
    int nFeats = 8;
    int nFeat;
    for (i = 0; i < nFeats; i++)
    {
        if (i == 0) nFeat = FEAT_SCRIBE_SCROLL;
        if (i == 1) nFeat = FEAT_BREW_POTION;
        if (i == 2) nFeat = FEAT_CRAFT_WONDROUS;
        if (i == 3) nFeat = FEAT_CRAFT_ARMS_ARMOR;
        if (i == 4) nFeat = FEAT_CRAFT_WAND;
        if (i == 5) nFeat = FEAT_CRAFT_ROD;
        if (i == 6) nFeat = FEAT_CRAFT_STAFF;
        if (i == 7) nFeat = FEAT_FORGE_RING;
        if (BinderNUIIsAstarothFeatValid(oPC, nFeat))
        {
            jMap = JsonArrayInsert(jMap, JsonInt(nFeat));
            jNames = JsonArrayInsert(jNames, JsonString(BinderNUIAstarothFeatName(nFeat)));
        }
    }
    BinderNUISetChoiceMap(oPC, jMap, jNames);
}

int BinderNUIHighestExploitSpellLevel(object oPC)
{
    if (!GetLocalInt(oPC, "PRC_ArcSpell9")) return 9;
    if (!GetLocalInt(oPC, "PRC_ArcSpell8")) return 8;
    if (!GetLocalInt(oPC, "PRC_ArcSpell7")) return 7;
    if (!GetLocalInt(oPC, "PRC_ArcSpell6")) return 6;
    if (!GetLocalInt(oPC, "PRC_ArcSpell5")) return 5;
    if (!GetLocalInt(oPC, "PRC_ArcSpell4")) return 4;
    if (!GetLocalInt(oPC, "PRC_ArcSpell3")) return 3;
    return 2;
}

void BinderNUIBuildExploitSpellChoices(object oPC)
{
    int nClass = GetPrimaryArcaneClass(oPC);
    string sFile = GetFileForClass(nClass);
    // The legacy selector uses the Sorcerer table for Wizard spells because
    // this is a spontaneous bonus cast rather than a prepared spell slot.
    if (nClass == CLASS_TYPE_WIZARD)
        sFile = "cls_spell_sorc";

    json jMap = JsonArray();
    json jNames = JsonArray();
    json jSeen = JsonObject();
    int nLevel = BinderNUIHighestExploitSpellLevel(oPC);
    int i;
    for (i = 0; i < 600; i++)
    {
        string sLevel = Get2DACache(sFile, "Level", i);
        if (sLevel == "" || sLevel == "****")
            continue;
        int nRowLevel = StringToInt(sLevel);
        if (nRowLevel < nLevel)
            continue;
        if (nRowLevel > nLevel)
            break;

        string sFeat = Get2DACache(sFile, "FeatID", i);
        int nSpell = StringToInt(Get2DACache(sFile, "RealSpellID", i));
        string sKey = IntToString(nSpell);
        if (sFeat != "" && sFeat != "****" && nSpell > 0
            && JsonObjectGet(jSeen, sKey) == JsonNull())
        {
            jSeen = JsonObjectSet(jSeen, sKey, JsonBool(TRUE));
            string sName = GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSpell)));
            if (sName != "")
            {
                jMap = JsonArrayInsert(jMap, JsonInt(nSpell));
                jNames = JsonArrayInsert(jNames, JsonString(sName));
            }
        }
    }
    BinderNUISetChoiceMap(oPC, jMap, jNames);
}

void BinderNUIAdvanceAfterMethod(object oPC)
{
    int nRow = GetLocalInt(oPC, PRC_BINDER_NUI_SELECTED_ROW_VAR);
    if (GetPactAugmentCount(oPC) > 0)
    {
        SetLocalJson(oPC, PRC_BINDER_NUI_AUGMENT_VAR, BinderNUINewAugmentDraft());
        SetLocalInt(oPC, PRC_BINDER_NUI_STAGE_VAR, PRC_BINDER_NUI_STAGE_AUGMENT);
        BinderNUIBuildAugmentChoices(oPC);
    }
    else if (nRow == 4 && GetAbilityModifier(ABILITY_CONSTITUTION, oPC) >= 1)
    {
        SetLocalJson(oPC, PRC_BINDER_NUI_NABERIUS_VAR, JsonArray());
        SetLocalInt(oPC, PRC_BINDER_NUI_STAGE_VAR, PRC_BINDER_NUI_STAGE_NABERIUS);
        BinderNUIBuildNaberiusChoices(oPC);
    }
    else if (nRow == 20)
    {
        SetLocalInt(oPC, PRC_BINDER_NUI_STAGE_VAR, PRC_BINDER_NUI_STAGE_ASTAROTH);
        BinderNUIBuildAstarothChoices(oPC);
    }
    else
    {
        SetLocalInt(oPC, PRC_BINDER_NUI_STAGE_VAR, PRC_BINDER_NUI_STAGE_BIND_CONFIRM);
        BinderNUIClearTransientMaps(oPC);
    }
}

void BinderNUIAdvanceAfterAugment(object oPC)
{
    int nRow = GetLocalInt(oPC, PRC_BINDER_NUI_SELECTED_ROW_VAR);
    if (nRow == 4 && GetAbilityModifier(ABILITY_CONSTITUTION, oPC) >= 1)
    {
        SetLocalJson(oPC, PRC_BINDER_NUI_NABERIUS_VAR, JsonArray());
        SetLocalInt(oPC, PRC_BINDER_NUI_STAGE_VAR, PRC_BINDER_NUI_STAGE_NABERIUS);
        BinderNUIBuildNaberiusChoices(oPC);
    }
    else if (nRow == 20)
    {
        SetLocalInt(oPC, PRC_BINDER_NUI_STAGE_VAR, PRC_BINDER_NUI_STAGE_ASTAROTH);
        BinderNUIBuildAstarothChoices(oPC);
    }
    else
    {
        SetLocalInt(oPC, PRC_BINDER_NUI_STAGE_VAR, PRC_BINDER_NUI_STAGE_BIND_CONFIRM);
        BinderNUIClearTransientMaps(oPC);
    }
}

void BinderNUIAdvanceAfterNaberius(object oPC)
{
    if (GetLocalInt(oPC, PRC_BINDER_NUI_SELECTED_ROW_VAR) == 20)
    {
        SetLocalInt(oPC, PRC_BINDER_NUI_STAGE_VAR, PRC_BINDER_NUI_STAGE_ASTAROTH);
        BinderNUIBuildAstarothChoices(oPC);
    }
    else
    {
        SetLocalInt(oPC, PRC_BINDER_NUI_STAGE_VAR, PRC_BINDER_NUI_STAGE_BIND_CONFIRM);
        BinderNUIClearTransientMaps(oPC);
    }
}

string BinderNUIValidateDraft(object oPC)
{
    if (!BinderNUIHasAccess(oPC))
        return "You no longer have access to vestige binding.";
    if (!GetLocalInt(oPC, PRC_BINDER_NUI_ACTIVE_VAR))
        return "This pact draft is no longer active.";
    if (GetLocalString(oPC, PRC_BINDER_NUI_BASELINE_VAR)
            != BinderNUIBuildBaseline(oPC))
        return "Your bound vestiges or binding limits changed while this pact was being configured. Reopen the pact window.";

    int nRow = GetLocalInt(oPC, PRC_BINDER_NUI_SELECTED_ROW_VAR);
    if (!BinderNUIBasicCanBindRow(oPC, nRow)
        || !BinderNUIMapContains(GetLocalJson(oPC, PRC_BINDER_NUI_HOME_BIND_MAP_VAR), nRow))
        return "That vestige is no longer available to bind.";
    // Unlike a modal conversation, an NUI does not stop the player moving or
    // waiting for time-of-day changes.  Recheck the authoritative situational
    // requirements immediately before committing the ritual.
    if (!DoSpecialRequirements(oPC, BinderNUIVestigeSpell(nRow)))
        return "You no longer meet that vestige's special requirements.";

    int nMethod = GetLocalInt(oPC, PRC_BINDER_NUI_METHOD_VAR);
    if (nMethod < PRC_BINDER_NUI_METHOD_NORMAL
        || nMethod > PRC_BINDER_NUI_METHOD_RAPID)
        return "Choose a binding method.";
    if (nMethod == PRC_BINDER_NUI_METHOD_RAPID
        && (!GetHasFeat(FEAT_RAPID_PACT_MAKING, oPC)
            || GetLocalInt(oPC, "RapidPactMaking")))
        return "Rapid Pact Making is not currently available.";

    int nAugmentTarget = GetPactAugmentCount(oPC);
    if (BinderNUIAugmentTotal(oPC) != nAugmentTarget)
        return "Choose exactly " + IntToString(nAugmentTarget) + " Pact Augmentation benefits.";

    if (nRow == 4 && GetAbilityModifier(ABILITY_CONSTITUTION, oPC) >= 1)
    {
        json jNab = GetLocalJson(oPC, PRC_BINDER_NUI_NABERIUS_VAR);
        int nTarget = GetAbilityModifier(ABILITY_CONSTITUTION, oPC);
        if (JsonGetType(jNab) != JSON_TYPE_ARRAY || JsonGetLength(jNab) != nTarget)
            return "Choose exactly " + IntToString(nTarget) + " Naberius skills.";
        int i;
        for (i = 0; i < JsonGetLength(jNab); i++)
        {
            int nSkill = JsonGetInt(JsonArrayGet(jNab, i));
            if (nSkill < 0 || nSkill >= 40
                || GetSkillRank(nSkill, oPC, TRUE) != 0
                || !StringToInt(Get2DACache("skills", "Untrained", nSkill))
                || GetLocalInt(oPC, "NaberiusSkill" + IntToString(nSkill)))
                return "A selected Naberius skill is no longer eligible.";
        }
    }

    if (nRow == 20
        && !BinderNUIIsAstarothFeatValid(oPC,
            GetLocalInt(oPC, PRC_BINDER_NUI_ASTAROTH_VAR)))
        return "Choose an Astaroth crafting feat for which your effective Binder level qualifies.";

    int nExploit = GetLocalInt(oPC, PRC_BINDER_NUI_EXPLOIT_VAR);
    if (nExploit > 0)
    {
        if (GetLevelByClass(CLASS_TYPE_ANIMA_MAGE, oPC) < 2
            || GetLocalInt(oPC, "ExploitVestige")
            || StringToInt(Get2DACache("vestigeabil", "VestigeNum", nExploit)) != nRow)
            return "The selected Exploit Vestige ability is no longer valid.";
    }
    return "";
}

void BinderNUICopyDraftToLegacyLocals(object oPC)
{
    json jAug = GetLocalJson(oPC, PRC_BINDER_NUI_AUGMENT_VAR);
    int i;
    for (i = 1; i <= 11; i++)
    {
        DeleteLocalInt(oPC, "PactAugment" + IntToString(i));
        if (JsonGetType(jAug) == JSON_TYPE_ARRAY && JsonGetLength(jAug) == 11)
        {
            int nCount = JsonGetInt(JsonArrayGet(jAug, i - 1));
            if (nCount > 0)
                SetLocalInt(oPC, "PactAugment" + IntToString(i), nCount);
        }
    }

    json jNab = GetLocalJson(oPC, PRC_BINDER_NUI_NABERIUS_VAR);
    SetLocalJson(oPC, PRC_BINDER_NUI_RITUAL_NAB_VAR, jNab);
    if (JsonGetType(jNab) == JSON_TYPE_ARRAY)
    {
        for (i = 0; i < JsonGetLength(jNab); i++)
        {
            int nSkill = JsonGetInt(JsonArrayGet(jNab, i));
            SetLocalInt(oPC, "NaberiusSkill" + IntToString(nSkill), TRUE);
        }
    }

    int nExploit = GetLocalInt(oPC, PRC_BINDER_NUI_EXPLOIT_VAR);
    if (nExploit > 0)
    {
        // Equivalent to SetIsVestigeExploited except that the legacy follow-up
        // conversation flag is intentionally omitted; this NUI supplies the
        // good-pact-only spell choice itself.
        SetLocalInt(oPC, "ExploitVestige", nExploit);
        SetLocalInt(oPC, "ExploitVestigeTemp", TRUE);
        DeleteLocalInt(oPC, "ExploitVestigeConv");
        DeleteLocalInt(oPC, "ExploitVestigeSpell");
        SetLocalInt(oPC, PRC_BINDER_NUI_PENDING_SPELL_VAR, TRUE);
    }
}

void BinderNUICleanupFailedBinding(object oPC)
{
    int i;
    for (i = 1; i <= 11; i++)
        DeleteLocalInt(oPC, "PactAugment" + IntToString(i));

    json jNab = GetLocalJson(oPC, PRC_BINDER_NUI_RITUAL_NAB_VAR);
    if (JsonGetType(jNab) == JSON_TYPE_ARRAY)
    {
        for (i = 0; i < JsonGetLength(jNab); i++)
            DeleteLocalInt(oPC, "NaberiusSkill" + IntToString(
                JsonGetInt(JsonArrayGet(jNab, i))
            ));
    }
    DeleteLocalJson(oPC, PRC_BINDER_NUI_RITUAL_NAB_VAR);

    if (GetLocalInt(oPC, PRC_BINDER_NUI_PENDING_SPELL_VAR))
    {
        DeleteLocalInt(oPC, "ExploitVestige");
        DeleteLocalInt(oPC, "ExploitVestigeTemp");
        DeleteLocalInt(oPC, "ExploitVestigeConv");
        DeleteLocalInt(oPC, "ExploitVestigeSpell");
        DeleteLocalInt(oPC, PRC_BINDER_NUI_PENDING_SPELL_VAR);
    }
    DeleteLocalInt(oPC, "RushedBinding");
}

void BinderNUIClearRitualState(object oPC)
{
    DeleteLocalInt(oPC, PRC_BINDER_NUI_RITUAL_TYPE_VAR);
    DeleteLocalInt(oPC, PRC_BINDER_NUI_RITUAL_ROW_VAR);
    DeleteLocalJson(oPC, PRC_BINDER_NUI_RITUAL_NAB_VAR);
}

int BinderNUIBeginBinding(object oPC)
{
    string sError = BinderNUIValidateDraft(oPC);
    if (sError != "")
    {
        SendMessageToPC(oPC, sError);
        return FALSE;
    }

    int nRow = GetLocalInt(oPC, PRC_BINDER_NUI_SELECTED_ROW_VAR);
    int nMethod = GetLocalInt(oPC, PRC_BINDER_NUI_METHOD_VAR);
    BinderNUICopyDraftToLegacyLocals(oPC);
    if (nMethod == PRC_BINDER_NUI_METHOD_RUSHED)
        SetLocalInt(oPC, "RushedBinding", TRUE);
    else if (nMethod == PRC_BINDER_NUI_METHOD_RAPID)
        SetLocalInt(oPC, "RapidPactMaking", TRUE);

    int nGeneration = GetLocalInt(oPC, PRC_BINDER_NUI_RITUAL_GEN_VAR) + 1;
    SetLocalInt(oPC, PRC_BINDER_NUI_RITUAL_GEN_VAR, nGeneration);
    SetLocalInt(oPC, PRC_BINDER_NUI_RITUAL_TYPE_VAR, PRC_BINDER_NUI_RITUAL_BIND);
    SetLocalInt(oPC, PRC_BINDER_NUI_RITUAL_ROW_VAR, nRow);
    SetLocalInt(oPC, PRC_BINDER_NUI_ACTIVE_VAR, FALSE);

    int nContactTime = VESTIGE_CONTACT_TIME;
    if (GetPRCSwitch(PRC_CONTACT_VESTIGE_TIMER) >= 6)
        nContactTime = GetPRCSwitch(PRC_CONTACT_VESTIGE_TIMER);
    BinderNUIContactTick(oPC, nContactTime, nRow, PRC_BINDER_NUI_RITUAL_BIND, nGeneration);
    return TRUE;
}

int BinderNUIBeginExpel(object oPC)
{
    int nRow = GetLocalInt(oPC, PRC_BINDER_NUI_SELECTED_ROW_VAR);
    int nSpell = BinderNUIVestigeSpell(nRow);
    if (!BinderNUIHasAccess(oPC)
        || !BinderNUIIsValidVestigeRow(nRow)
        || !BinderNUIMapContains(GetLocalJson(oPC, PRC_BINDER_NUI_HOME_BOUND_MAP_VAR), nRow)
        || !GetHasSpellEffect(nSpell, oPC))
    {
        SendMessageToPC(oPC, "That vestige is no longer bound.");
        return FALSE;
    }
    if (!GetHasFeat(FEAT_EXPEL_VESTIGE, oPC))
    {
        SendMessageToPC(oPC, "You need the Expel Vestige feat to do that.");
        return FALSE;
    }
    if (GetFeatRemainingUses(FEAT_EXPEL_VESTIGE, oPC) <= 0)
    {
        SendMessageToPC(oPC, "You have already used Expel Vestige today.");
        return FALSE;
    }

    // A radial activation would spend the same once-per-day feat use before
    // its conversation starts.  The NUI must account for that engine cost.
    DecrementRemainingFeatUses(oPC, FEAT_EXPEL_VESTIGE);
    int nGeneration = GetLocalInt(oPC, PRC_BINDER_NUI_RITUAL_GEN_VAR) + 1;
    SetLocalInt(oPC, PRC_BINDER_NUI_RITUAL_GEN_VAR, nGeneration);
    SetLocalInt(oPC, PRC_BINDER_NUI_RITUAL_TYPE_VAR, PRC_BINDER_NUI_RITUAL_EXPEL);
    SetLocalInt(oPC, PRC_BINDER_NUI_RITUAL_ROW_VAR, nRow);
    SetLocalInt(oPC, PRC_BINDER_NUI_ACTIVE_VAR, FALSE);

    int nContactTime = VESTIGE_CONTACT_TIME;
    if (GetPRCSwitch(PRC_CONTACT_VESTIGE_TIMER) >= 6)
        nContactTime = GetPRCSwitch(PRC_CONTACT_VESTIGE_TIMER);
    BinderNUIContactTick(oPC, nContactTime, nRow, PRC_BINDER_NUI_RITUAL_EXPEL, nGeneration);
    return TRUE;
}

void BinderNUIAbortRitual(object oPC, int nRitualType, string sReason)
{
    SetCutsceneMode(oPC, FALSE);
    if (sReason != "")
        FloatingTextStringOnCreature(sReason, oPC, FALSE);
    if (nRitualType == PRC_BINDER_NUI_RITUAL_BIND)
        BinderNUICleanupFailedBinding(oPC);
    BinderNUIClearRitualState(oPC);
}

void BinderNUIContactTick(object oPC, int nTime, int nVestigeRow, int nRitualType, int nGeneration)
{
    if (!GetIsObjectValid(oPC)
        || GetLocalInt(oPC, PRC_BINDER_NUI_RITUAL_GEN_VAR) != nGeneration
        || GetLocalInt(oPC, PRC_BINDER_NUI_RITUAL_TYPE_VAR) != nRitualType
        || GetLocalInt(oPC, PRC_BINDER_NUI_RITUAL_ROW_VAR) != nVestigeRow)
        return;

    if (nTime <= 0)
    {
        SetCutsceneMode(oPC, FALSE);
        if (!DoSummonRequirements(oPC, nVestigeRow))
        {
            BinderNUIAbortRitual(oPC, nRitualType, "The vestige refuses your call.");
            return;
        }
        int nBindTime = VESTIGE_BINDING_TIME;
        if (GetPRCSwitch(PRC_BIND_VESTIGE_TIMER) >= 12)
            nBindTime = GetPRCSwitch(PRC_BIND_VESTIGE_TIMER);
        if (GetLocalInt(oPC, "RushedBinding")
            || GetLocalInt(oPC, "RapidPactMaking"))
            nBindTime = 6;
        BinderNUIBindTick(oPC, nBindTime, nVestigeRow, nRitualType, nGeneration);
        return;
    }

    if (GetIsInCombat(oPC))
    {
        BinderNUIAbortRitual(oPC, nRitualType, "Combat interrupted the vestige contact.");
        return;
    }

    FloatingTextStringOnCreature(
        "You must draw the symbol for another " + IntToString(nTime) + " seconds",
        oPC,
        FALSE
    );
    DelayCommand(6.0f, BinderNUIContactTick(
        oPC, nTime - 6, nVestigeRow, nRitualType, nGeneration
    ));
    SetCutsceneMode(oPC, TRUE);
    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_MEDITATE, 1.0f, 6.0f));
    ApplyEffectAtLocation(
        DURATION_TYPE_TEMPORARY,
        EffectVisualEffect(VFX_DUR_SYMB_INSAN),
        GetLocation(oPC),
        6.0f
    );
}

void BinderNUIBindTick(object oPC, int nTime, int nVestigeRow, int nRitualType, int nGeneration)
{
    if (!GetIsObjectValid(oPC)
        || GetLocalInt(oPC, PRC_BINDER_NUI_RITUAL_GEN_VAR) != nGeneration
        || GetLocalInt(oPC, PRC_BINDER_NUI_RITUAL_TYPE_VAR) != nRitualType
        || GetLocalInt(oPC, PRC_BINDER_NUI_RITUAL_ROW_VAR) != nVestigeRow)
        return;

    if (nTime <= 0)
    {
        SetCutsceneMode(oPC, FALSE);
        int nVestigeSpell = DoBindingCheck(oPC, nVestigeRow);
        // DoBindingCheck normally consumes these one-check markers itself,
        // but its automatic-good-pact branches return early.  Do not let a
        // NUI attempt leak either marker into the next pact.
        DeleteLocalInt(oPC, "RushedBinding");
        DeleteLocalInt(oPC, "ExploitVestigeTemp");
        if (nRitualType == PRC_BINDER_NUI_RITUAL_EXPEL)
        {
            ExpelVestige(oPC, nVestigeSpell);
            BinderNUIClearRitualState(oPC);
            return;
        }

        ApplyVestige(oPC, nVestigeSpell);
        int nAstarothFeat = GetLocalInt(oPC, PRC_BINDER_NUI_ASTAROTH_VAR);
        if (nVestigeRow == 20 && BinderNUIIsAstarothFeatValid(oPC, nAstarothFeat))
            DelayCommand(0.5f, BinderNUIApplyAstarothFeat(oPC, nAstarothFeat, nGeneration));

        int bGoodPact = GetLocalInt(oPC, "PactQuality" + IntToString(nVestigeSpell));
        int bPendingSpell = GetLocalInt(oPC, PRC_BINDER_NUI_PENDING_SPELL_VAR);
        BinderNUIClearRitualState(oPC);
        if (bGoodPact && bPendingSpell)
            DelayCommand(0.5f, BinderNUIOpenExploitSpell(oPC, nGeneration));
        else
            DeleteLocalInt(oPC, PRC_BINDER_NUI_PENDING_SPELL_VAR);
        return;
    }

    if (GetIsInCombat(oPC))
    {
        BinderNUIAbortRitual(oPC, nRitualType, "Combat interrupted the binding ritual.");
        return;
    }

    FloatingTextStringOnCreature(
        "You must spend " + IntToString(nTime) + " more seconds to complete the binding",
        oPC,
        FALSE
    );
    DelayCommand(6.0f, BinderNUIBindTick(
        oPC, nTime - 6, nVestigeRow, nRitualType, nGeneration
    ));
    SetCutsceneMode(oPC, TRUE);
    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_TALK_PLEADING, 1.0f, 6.0f));
    ApplyEffectAtLocation(
        DURATION_TYPE_TEMPORARY,
        EffectVisualEffect(VFX_DUR_MAZE),
        GetLocation(oPC),
        6.0f
    );
}

void BinderNUIApplyAstarothFeat(object oPC, int nFeat, int nGeneration)
{
    if (!GetIsObjectValid(oPC)
        || GetLocalInt(oPC, PRC_BINDER_NUI_RITUAL_GEN_VAR) != nGeneration
        || !BinderNUIIsAstarothFeatValid(oPC, nFeat))
        return;

    effect eFeat = TagEffect(EffectBonusFeat(nFeat), "AstarothCraftingFeat");
    ApplyEffectToObject(
        DURATION_TYPE_TEMPORARY,
        SupernaturalEffect(eFeat),
        oPC,
        HoursToSeconds(24)
    );
}

void BinderNUIOpenExploitSpell(object oPC, int nGeneration)
{
    if (!GetIsObjectValid(oPC)
        || GetLocalInt(oPC, PRC_BINDER_NUI_RITUAL_GEN_VAR) != nGeneration
        || !GetLocalInt(oPC, PRC_BINDER_NUI_PENDING_SPELL_VAR)
        || !GetLocalInt(oPC, "ExploitVestige"))
        return;

    SetLocalInt(oPC, PRC_BINDER_NUI_ACTIVE_VAR, TRUE);
    SetLocalInt(oPC, PRC_BINDER_NUI_STAGE_VAR, PRC_BINDER_NUI_STAGE_EXPLOIT_SPELL);
    BinderNUIBuildExploitSpellChoices(oPC);
    ExecuteScript("prc_nui_bnd_view", oPC);
}

string BinderNUIMethodName(int nMethod)
{
    if (nMethod == PRC_BINDER_NUI_METHOD_NORMAL) return "Normal pact";
    if (nMethod == PRC_BINDER_NUI_METHOD_RUSHED) return "Rushed bind (-10 check)";
    if (nMethod == PRC_BINDER_NUI_METHOD_RAPID)  return "Rapid Pact Making";
    return "Not selected";
}

string BinderNUIBindingSummary(object oPC)
{
    int nRow = GetLocalInt(oPC, PRC_BINDER_NUI_SELECTED_ROW_VAR);
    string sResult = "Vestige: " + BinderNUIVestigeName(nRow)
        + "\nMethod: " + BinderNUIMethodName(GetLocalInt(oPC, PRC_BINDER_NUI_METHOD_VAR));
    if (GetPactAugmentCount(oPC) > 0)
        sResult += "\nPact Augmentation: " + BinderNUIAugmentSummary(oPC);
    if (nRow == 4 && GetAbilityModifier(ABILITY_CONSTITUTION, oPC) >= 1)
        sResult += "\nNaberius skills: " + BinderNUINaberiusSummary(oPC);
    if (nRow == 20)
        sResult += "\nAstaroth feat: " + BinderNUIAstarothFeatName(
            GetLocalInt(oPC, PRC_BINDER_NUI_ASTAROTH_VAR)
        );
    int nExploit = GetLocalInt(oPC, PRC_BINDER_NUI_EXPLOIT_VAR);
    if (nExploit > 0)
        sResult += "\nExploit Vestige: forgo " + Get2DACache("vestigeabil", "Ability", nExploit);
    return sResult;
}
