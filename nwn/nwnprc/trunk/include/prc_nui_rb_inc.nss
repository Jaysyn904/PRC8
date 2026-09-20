//::///////////////////////////////////////////////
//:: PRC Runescar Scribing NUI helpers
//:: prc_nui_rb_inc
//:://////////////////////////////////////////////
/**
 * Stages one Runescarred Berserker scar without altering the legacy radial
 * conversation.  Save revalidates the complete selection and then applies the
 * same immediate gold, XP, damage, persistent-location, and daily-use changes
 * as rune_convb.
 */

#include "prc_nui_rb_const"
#include "prc_nui_sb_inc"

int RunescarScribeGetSpellByIndex(int nIndex);
int RunescarScribeIsAllowedSpell(int nSpell);
int RunescarScribeGetMaximumTier(object oPC);
int RunescarScribeTierIsAvailable(object oPC, int nTier);
int RunescarScribePositionIsAvailable(object oPC, int nPosition);
int RunescarScribeGetFirstOpenPosition(object oPC);
int RunescarScribeGetFirstAvailableTier(object oPC);
int RunescarScribeGetFirstSpellAtTier(int nTier);
int RunescarScribeGetMinimumCasterLevel(int nTier);
int RunescarScribeGetGoldCost(int nTier, int nCasterLevel);
int RunescarScribeGetXPCost(int nTier, int nCasterLevel);
int RunescarScribeHasActiveSession(object oPC);
int RunescarScribeAdvanceLayoutGeneration(object oPC);
string RunescarScribeStampId(string sBase, int nGeneration);
string RunescarScribeStampValueId(
    string sBase,
    int nValue,
    int nGeneration
);
int RunescarScribeGetElementGeneration(string sElement);
int RunescarScribeGetElementValue(string sElement, string sBase);
void RunescarScribeSetSpellMap(
    object oPC,
    json jMap,
    json jNames,
    int nGeneration
);
int RunescarScribeGetMappedSpell(
    object oPC,
    int nArrayIndex,
    int nGeneration
);
void RunescarScribeSelectTier(object oPC, int nTier);
int RunescarScribeSelectPosition(object oPC, int nPosition);
int RunescarScribeInitializeDraft(object oPC);
string RunescarScribeValidateSelection(
    object oPC,
    int nPosition,
    int nSpell,
    int nCasterLevel
);
int RunescarScribeCommitSelection(
    object oPC,
    int nPosition,
    int nSpell,
    int nCasterLevel
);
string RunescarScribeValidateDraft(object oPC);
int RunescarScribeCommitDraft(object oPC);
int RunescarDefaultHasSet(object oPC);
int RunescarDefaultGetSpell(object oPC, int nPosition);
int RunescarDefaultGetCasterLevel(object oPC, int nPosition);
string RunescarDefaultValidateCurrentSet(object oPC);
string RunescarDefaultValidateSavedSet(object oPC);
int RunescarDefaultSaveCurrentSet(object oPC);
void RunescarDefaultClearSet(object oPC);
string RunescarDefaultScribeSavedSet(object oPC);
void RunescarScribeDiscardDraft(
    object oPC = OBJECT_SELF,
    int bCloseWindow = TRUE
);
int RunescarScribeOpenEditor(object oPC = OBJECT_SELF);
void RunescarScribeOpenDescription(object oPC, int nSpell);

int RunescarScribeGetSpellByIndex(int nIndex)
{
    // This is deliberately the exact 32-spell table in rune_convb.  Do not
    // add the three spells mentioned by that script's historical TODO without
    // an explicit rules change.
    switch (nIndex)
    {
        case  0: return SPELL_CURE_MODERATE_WOUNDS;
        case  1: return SPELL_DIVINE_FAVOR;
        case  2: return SPELL_PROTECTION__FROM_CHAOS;
        case  3: return SPELL_PROTECTION_FROM_EVIL;
        case  4: return SPELL_PROTECTION_FROM_GOOD;
        case  5: return SPELL_PROTECTION_FROM_LAW;
        case  6: return SPELL_RESIST_ELEMENTS;
        case  7: return SPELL_SEE_INVISIBILITY;
        case  8: return SPELL_TRUE_STRIKE;

        case  9: return SPELL_ENDURANCE;
        case 10: return SPELL_BULLS_STRENGTH;
        case 11: return SPELL_CURE_SERIOUS_WOUNDS;
        case 12: return SPELL_DARKVISION;
        case 13: return SPELL_INVISIBILITY;
        case 14: return SPELL_KEEN_EDGE;
        case 15: return SPELL_PROTECTION_FROM_ELEMENTS;

        case 16: return SPELL_CURE_CRITICAL_WOUNDS;
        case 17: return SPELL_DEATH_WARD;
        case 18: return SPELL_DIVINE_POWER;
        case 19: return SPELL_FREEDOM_OF_MOVEMENT;
        case 20: return SPELL_HASTE;
        case 21: return SPELL_GREATER_MAGIC_WEAPON;

        case 22: return SPELL_IMPROVED_INVISIBILITY;
        case 23: return SPELL_NEUTRALIZE_POISON;
        case 24: return SPELL_RESTORATION;
        case 25: return SPELL_RIGHTEOUS_MIGHT;
        case 26: return SPELL_STONESKIN;

        case 27: return SPELL_ANTIMAGIC_FIELD;
        case 28: return SPELL_RUNE_DIMENSION_DOOR;
        case 29: return SPELL_HEAL;
        case 30: return SPELL_POLYMORPH_SELF;
        case 31: return SPELL_SPELL_RESISTANCE;
    }

    return -1;
}

int RunescarScribeIsAllowedSpell(int nSpell)
{
    int i;
    for (i = 0; i < PRC_RUNESCAR_SCRIBE_SPELL_COUNT; i++)
    {
        if (RunescarScribeGetSpellByIndex(i) == nSpell)
            return TRUE;
    }

    return FALSE;
}

int RunescarScribeGetMaximumTier(object oPC)
{
    int nTier = (GetLevelByClass(CLASS_TYPE_RUNESCARRED, oPC) + 1) / 2;
    if (nTier > PRC_RUNESCAR_SCRIBE_TIER_COUNT)
        nTier = PRC_RUNESCAR_SCRIBE_TIER_COUNT;
    if (nTier < 0)
        nTier = 0;
    return nTier;
}

int RunescarScribeTierIsAvailable(object oPC, int nTier)
{
    return GetIsObjectValid(oPC)
        && nTier >= 1
        && nTier <= RunescarScribeGetMaximumTier(oPC)
        && NUISpellbookGetRunescarScribeUses(oPC, nTier) > 0
        && GetAbilityScore(oPC, ABILITY_WISDOM) >= 10 + nTier;
}

int RunescarScribePositionIsAvailable(object oPC, int nPosition)
{
    return GetIsObjectValid(oPC)
        && nPosition >= 1
        && nPosition <= PRC_RUNESCAR_SCRIBE_POSITION_COUNT
        && NUISpellbookGetRunescarPersistedSpell(oPC, nPosition) < 0;
}

int RunescarScribeGetFirstOpenPosition(object oPC)
{
    int nPosition;
    for (nPosition = 1;
         nPosition <= PRC_RUNESCAR_SCRIBE_POSITION_COUNT;
         nPosition++)
    {
        if (RunescarScribePositionIsAvailable(oPC, nPosition))
            return nPosition;
    }

    return -1;
}

int RunescarScribeGetFirstAvailableTier(object oPC)
{
    int nTier;
    for (nTier = 1; nTier <= PRC_RUNESCAR_SCRIBE_TIER_COUNT; nTier++)
    {
        if (RunescarScribeTierIsAvailable(oPC, nTier))
            return nTier;
    }

    return -1;
}

int RunescarScribeGetFirstSpellAtTier(int nTier)
{
    int i;
    for (i = 0; i < PRC_RUNESCAR_SCRIBE_SPELL_COUNT; i++)
    {
        int nSpell = RunescarScribeGetSpellByIndex(i);
        if (NUISpellbookGetRunescarSpellTier(nSpell) == nTier)
            return nSpell;
    }

    return -1;
}

int RunescarScribeGetMinimumCasterLevel(int nTier)
{
    if (nTier < 1 || nTier > PRC_RUNESCAR_SCRIBE_TIER_COUNT)
        return 0;
    return (nTier * 2) - 1;
}

int RunescarScribeGetGoldCost(int nTier, int nCasterLevel)
{
    if (nTier < 1 || nCasterLevel < 1)
        return 0;
    return 5 * nTier * nCasterLevel;
}

int RunescarScribeGetXPCost(int nTier, int nCasterLevel)
{
    return RunescarScribeGetGoldCost(nTier, nCasterLevel) / 25;
}

int RunescarScribeHasActiveSession(object oPC)
{
    int nActive = GetLocalInt(
        oPC,
        PRC_RUNESCAR_SCRIBE_ACTIVE_SESSION_VAR
    );
    return nActive > 0
        && nActive == GetLocalInt(
            oPC,
            PRC_RUNESCAR_SCRIBE_SESSION_GENERATION_VAR
        );
}

int RunescarScribeAdvanceLayoutGeneration(object oPC)
{
    int nGeneration = GetLocalInt(
        oPC,
        PRC_RUNESCAR_SCRIBE_LAYOUT_GENERATION_VAR
    ) + 1;
    if (nGeneration <= 0)
        nGeneration = 1;
    SetLocalInt(
        oPC,
        PRC_RUNESCAR_SCRIBE_LAYOUT_GENERATION_VAR,
        nGeneration
    );
    return nGeneration;
}

string RunescarScribeStampId(string sBase, int nGeneration)
{
    return sBase
         + PRC_RUNESCAR_SCRIBE_GENERATION_MARKER
         + IntToString(nGeneration);
}

string RunescarScribeStampValueId(
    string sBase,
    int nValue,
    int nGeneration
)
{
    return sBase + IntToString(nValue)
         + PRC_RUNESCAR_SCRIBE_GENERATION_MARKER
         + IntToString(nGeneration);
}

int RunescarScribeGetElementGeneration(string sElement)
{
    int nMarker = FindSubString(
        sElement,
        PRC_RUNESCAR_SCRIBE_GENERATION_MARKER
    );
    if (nMarker <= 0)
        return -1;

    int nStart = nMarker + GetStringLength(
        PRC_RUNESCAR_SCRIBE_GENERATION_MARKER
    );
    if (nStart >= GetStringLength(sElement))
        return -1;

    int nGeneration = StringToInt(GetStringRight(
        sElement,
        GetStringLength(sElement) - nStart
    ));
    return nGeneration > 0 ? nGeneration : -1;
}

int RunescarScribeGetElementValue(string sElement, string sBase)
{
    int nMarker = FindSubString(
        sElement,
        PRC_RUNESCAR_SCRIBE_GENERATION_MARKER
    );
    int nBaseLength = GetStringLength(sBase);
    if (nMarker <= nBaseLength || FindSubString(sElement, sBase) != 0)
        return -1;

    string sBare = GetStringLeft(sElement, nMarker);
    return StringToInt(GetStringRight(
        sBare,
        GetStringLength(sBare) - nBaseLength
    ));
}

void RunescarScribeSetSpellMap(
    object oPC,
    json jMap,
    json jNames,
    int nGeneration
)
{
    if (JsonGetType(jMap) != JSON_TYPE_ARRAY)
        jMap = JsonArray();
    if (JsonGetType(jNames) != JSON_TYPE_ARRAY)
        jNames = JsonArray();

    SetLocalJson(oPC, PRC_RUNESCAR_SCRIBE_SPELL_MAP_VAR, jMap);
    SetLocalJson(oPC, PRC_RUNESCAR_SCRIBE_SPELL_NAMES_VAR, jNames);
    SetLocalInt(
        oPC,
        PRC_RUNESCAR_SCRIBE_MAP_GENERATION_VAR,
        nGeneration
    );
}

int RunescarScribeGetMappedSpell(
    object oPC,
    int nArrayIndex,
    int nGeneration
)
{
    if (nGeneration <= 0
        || nGeneration != GetLocalInt(
            oPC,
            PRC_RUNESCAR_SCRIBE_LAYOUT_GENERATION_VAR
        )
        || nGeneration != GetLocalInt(
            oPC,
            PRC_RUNESCAR_SCRIBE_MAP_GENERATION_VAR
        ))
        return -1;

    json jMap = GetLocalJson(oPC, PRC_RUNESCAR_SCRIBE_SPELL_MAP_VAR);
    if (JsonGetType(jMap) != JSON_TYPE_ARRAY
        || nArrayIndex < 0
        || nArrayIndex >= JsonGetLength(jMap))
        return -1;

    int nSpell = JsonGetInt(JsonArrayGet(jMap, nArrayIndex));
    int nTier = GetLocalInt(oPC, PRC_RUNESCAR_SCRIBE_TIER_VAR);
    if (!RunescarScribeIsAllowedSpell(nSpell)
        || NUISpellbookGetRunescarSpellTier(nSpell) != nTier)
        return -1;
    return nSpell;
}

void RunescarScribeSelectTier(object oPC, int nTier)
{
    if (!RunescarScribeTierIsAvailable(oPC, nTier))
        return;

    SetLocalInt(oPC, PRC_RUNESCAR_SCRIBE_TIER_VAR, nTier);
    SetLocalInt(
        oPC,
        PRC_RUNESCAR_SCRIBE_SPELL_VAR,
        RunescarScribeGetFirstSpellAtTier(nTier)
    );

    int nCasterLevel = GetLocalInt(
        oPC,
        PRC_RUNESCAR_SCRIBE_CASTER_LEVEL_VAR
    );
    int nMinimum = RunescarScribeGetMinimumCasterLevel(nTier);
    int nMaximum = GetLevelByClass(CLASS_TYPE_RUNESCARRED, oPC);
    if (nCasterLevel < nMinimum || nCasterLevel > nMaximum)
        nCasterLevel = nMaximum;
    SetLocalInt(
        oPC,
        PRC_RUNESCAR_SCRIBE_CASTER_LEVEL_VAR,
        nCasterLevel
    );
}

int RunescarDefaultGetSpell(object oPC, int nPosition)
{
    if (GetPersistantLocalInt(oPC, PRC_RUNESCAR_DEFAULT_VERSION_VAR)
            != PRC_RUNESCAR_DEFAULT_VERSION
        || nPosition < 1
        || nPosition > PRC_RUNESCAR_SCRIBE_POSITION_COUNT)
        return -1;

    return GetPersistantLocalInt(
        oPC,
        PRC_RUNESCAR_DEFAULT_SPELL_VAR_BASE + IntToString(nPosition)
    ) - 1;
}

int RunescarDefaultGetCasterLevel(object oPC, int nPosition)
{
    if (GetPersistantLocalInt(oPC, PRC_RUNESCAR_DEFAULT_VERSION_VAR)
            != PRC_RUNESCAR_DEFAULT_VERSION
        || nPosition < 1
        || nPosition > PRC_RUNESCAR_SCRIBE_POSITION_COUNT)
        return 0;

    return GetPersistantLocalInt(
        oPC,
        PRC_RUNESCAR_DEFAULT_LEVEL_VAR_BASE + IntToString(nPosition)
    );
}

string RunescarDefaultValidateSavedSet(object oPC)
{
    if (!GetIsPC(oPC)
        || GetPersistantLocalInt(oPC, PRC_RUNESCAR_DEFAULT_VERSION_VAR)
            != PRC_RUNESCAR_DEFAULT_VERSION)
        return "No saved runescar set was found.";

    int nPosition;
    for (nPosition = 1;
         nPosition <= PRC_RUNESCAR_SCRIBE_POSITION_COUNT;
         nPosition++)
    {
        int nSpell = RunescarDefaultGetSpell(oPC, nPosition);
        int nTier = NUISpellbookGetRunescarSpellTier(nSpell);
        int nCasterLevel = RunescarDefaultGetCasterLevel(oPC, nPosition);
        if (!RunescarScribeIsAllowedSpell(nSpell)
            || nTier < 1
            || nTier > PRC_RUNESCAR_SCRIBE_TIER_COUNT
            || nCasterLevel < RunescarScribeGetMinimumCasterLevel(nTier))
            return "The saved runescar set is incomplete or invalid. Save a new complete set.";
    }

    return "";
}

int RunescarDefaultHasSet(object oPC)
{
    return RunescarDefaultValidateSavedSet(oPC) == "";
}

int RunescarScribeSelectPosition(object oPC, int nPosition)
{
    if (!RunescarScribePositionIsAvailable(oPC, nPosition))
        return FALSE;

    SetLocalInt(oPC, PRC_RUNESCAR_SCRIBE_LOCATION_VAR, nPosition);

    // A saved body-slot choice is a convenience for the one-at-a-time editor
    // too.  Only preload it when that tier is currently usable; otherwise the
    // editor retains its existing valid tier/spell choice.
    if (RunescarDefaultHasSet(oPC))
    {
        int nSpell = RunescarDefaultGetSpell(oPC, nPosition);
        int nTier = NUISpellbookGetRunescarSpellTier(nSpell);
        int nCasterLevel = RunescarDefaultGetCasterLevel(oPC, nPosition);
        int nMaximum = GetLevelByClass(CLASS_TYPE_RUNESCARRED, oPC);
        if (RunescarScribeIsAllowedSpell(nSpell)
            && RunescarScribeTierIsAvailable(oPC, nTier)
            && nCasterLevel >= RunescarScribeGetMinimumCasterLevel(nTier)
            && nCasterLevel <= nMaximum)
        {
            SetLocalInt(oPC, PRC_RUNESCAR_SCRIBE_TIER_VAR, nTier);
            SetLocalInt(oPC, PRC_RUNESCAR_SCRIBE_SPELL_VAR, nSpell);
            SetLocalInt(
                oPC,
                PRC_RUNESCAR_SCRIBE_CASTER_LEVEL_VAR,
                nCasterLevel
            );
        }
    }

    return TRUE;
}

int RunescarScribeInitializeDraft(object oPC)
{
    if (!GetIsPC(oPC)
        || GetLevelByClass(CLASS_TYPE_RUNESCARRED, oPC) <= 0
        || !GetHasFeat(NUI_SPELLBOOK_RUNESCAR_SCRIBE_FEAT, oPC))
        return FALSE;

    int nPosition = RunescarScribeGetFirstOpenPosition(oPC);
    int nTier = RunescarScribeGetFirstAvailableTier(oPC);
    int nSpell = RunescarScribeGetFirstSpellAtTier(nTier);
    if (nPosition < 1 || nTier < 1 || nSpell < 0)
        return FALSE;

    SetLocalInt(oPC, PRC_RUNESCAR_SCRIBE_TIER_VAR, nTier);
    SetLocalInt(oPC, PRC_RUNESCAR_SCRIBE_SPELL_VAR, nSpell);
    SetLocalInt(
        oPC,
        PRC_RUNESCAR_SCRIBE_CASTER_LEVEL_VAR,
        GetLevelByClass(CLASS_TYPE_RUNESCARRED, oPC)
    );
    return RunescarScribeSelectPosition(oPC, nPosition);
}

string RunescarScribeValidateSelection(
    object oPC,
    int nPosition,
    int nSpell,
    int nCasterLevel
)
{
    if (!GetIsPC(oPC)
        || GetLevelByClass(CLASS_TYPE_RUNESCARRED, oPC) <= 0
        || !GetHasFeat(NUI_SPELLBOOK_RUNESCAR_SCRIBE_FEAT, oPC))
        return "Runescar scribing is no longer available.";

    if (!RunescarScribePositionIsAvailable(oPC, nPosition))
        return "That body location is no longer empty.";

    int nTier = NUISpellbookGetRunescarSpellTier(nSpell);
    if (!RunescarScribeIsAllowedSpell(nSpell)
        || nTier < 1
        || nTier > PRC_RUNESCAR_SCRIBE_TIER_COUNT)
        return "Select a valid runescar spell.";

    if (nTier < 1 || nTier > RunescarScribeGetMaximumTier(oPC))
        return "You have not unlocked that runescar tier.";
    if (NUISpellbookGetRunescarScribeUses(oPC, nTier) <= 0)
        return "You have no level " + IntToString(nTier)
             + " runescars left to scribe today.";
    if (GetAbilityScore(oPC, ABILITY_WISDOM) < 10 + nTier)
        return "Your Wisdom is too low to scribe that runescar tier.";

    int nMinimum = RunescarScribeGetMinimumCasterLevel(nTier);
    int nMaximum = GetLevelByClass(CLASS_TYPE_RUNESCARRED, oPC);
    if (nCasterLevel < nMinimum || nCasterLevel > nMaximum)
        return "Select a caster level from " + IntToString(nMinimum)
             + " to " + IntToString(nMaximum) + ".";

    int nGoldCost = RunescarScribeGetGoldCost(nTier, nCasterLevel);
    int nXPCost = RunescarScribeGetXPCost(nTier, nCasterLevel);
    if (GetGold(oPC) < nGoldCost)
        return "You need " + IntToString(nGoldCost)
             + " gp to scribe this runescar.";

    int nHitDice = GetHitDice(oPC);
    int nExperienceFloor = 500 * nHitDice * (nHitDice - 1);
    if (GetXP(oPC) - nExperienceFloor < nXPCost)
        return "You cannot spend " + IntToString(nXPCost)
             + " XP without losing your current level.";

    return "";
}

string RunescarScribeValidateDraft(object oPC)
{
    if (!RunescarScribeHasActiveSession(oPC))
        return "Runescar scribing is no longer available.";

    int nSpell = GetLocalInt(oPC, PRC_RUNESCAR_SCRIBE_SPELL_VAR);
    int nTier = GetLocalInt(oPC, PRC_RUNESCAR_SCRIBE_TIER_VAR);
    if (NUISpellbookGetRunescarSpellTier(nSpell) != nTier)
        return "Select a valid runescar spell.";

    return RunescarScribeValidateSelection(
        oPC,
        GetLocalInt(oPC, PRC_RUNESCAR_SCRIBE_LOCATION_VAR),
        nSpell,
        GetLocalInt(oPC, PRC_RUNESCAR_SCRIBE_CASTER_LEVEL_VAR)
    );
}

int RunescarScribeCommitSelection(
    object oPC,
    int nPosition,
    int nSpell,
    int nCasterLevel
)
{
    if (RunescarScribeValidateSelection(
            oPC,
            nPosition,
            nSpell,
            nCasterLevel
        ) != "")
        return FALSE;

    int nTier = NUISpellbookGetRunescarSpellTier(nSpell);
    int nGoldCost = RunescarScribeGetGoldCost(nTier, nCasterLevel);
    int nXPCost = RunescarScribeGetXPCost(nTier, nCasterLevel);
    string sPositionVar = NUISpellbookGetRunescarPositionVar(nPosition);
    if (sPositionVar == "")
        return FALSE;

    // Preserve rune_convb's immediate order and side effects exactly.
    SetXP(oPC, GetXP(oPC) - nXPCost);
    TakeGoldFromCreature(nGoldCost, oPC, TRUE);
    ApplyEffectToObject(
        DURATION_TYPE_INSTANT,
        EffectDamage(d6(nTier)),
        oPC
    );
    SetPersistantLocalInt(oPC, sPositionVar, nSpell + 1);
    SetPersistantLocalInt(oPC, sPositionVar + "_level", nCasterLevel);
    SetLocalInt(
        oPC,
        "Runescar_slot_" + IntToString(nTier),
        GetLocalInt(oPC, "Runescar_slot_" + IntToString(nTier)) - 1
    );

    // The seven legacy radial cast scripts read this transient value for save
    // DC.  `/sb` also reconstructs it before casting, but a newly-created scar
    // must remain correct when used from the radial menu in the same session.
    SetLocalInt(
        oPC,
        "Runescar_spell_level_" + IntToString(nSpell),
        nTier
    );
    return TRUE;
}

int RunescarScribeCommitDraft(object oPC)
{
    if (RunescarScribeValidateDraft(oPC) != "")
        return FALSE;

    return RunescarScribeCommitSelection(
        oPC,
        GetLocalInt(oPC, PRC_RUNESCAR_SCRIBE_LOCATION_VAR),
        GetLocalInt(oPC, PRC_RUNESCAR_SCRIBE_SPELL_VAR),
        GetLocalInt(oPC, PRC_RUNESCAR_SCRIBE_CASTER_LEVEL_VAR)
    );
}

string RunescarDefaultValidateCurrentSet(object oPC)
{
    if (!GetIsPC(oPC)
        || GetLevelByClass(CLASS_TYPE_RUNESCARRED, oPC) <= 0
        || !GetHasFeat(NUI_SPELLBOOK_RUNESCAR_SCRIBE_FEAT, oPC))
        return "Runescar scribing is not available.";

    int nPosition;
    for (nPosition = 1;
         nPosition <= PRC_RUNESCAR_SCRIBE_POSITION_COUNT;
         nPosition++)
    {
        int nSpell = NUISpellbookGetRunescarPersistedSpell(oPC, nPosition);
        int nTier = NUISpellbookGetRunescarSpellTier(nSpell);
        int nCasterLevel = NUISpellbookGetRunescarPersistedCasterLevel(
            oPC,
            nPosition
        );
        if (nSpell < 0)
            return "Fill all seven body locations before saving a default set.";
        if (!RunescarScribeIsAllowedSpell(nSpell)
            || nTier < 1
            || nTier > PRC_RUNESCAR_SCRIBE_TIER_COUNT
            || nCasterLevel < RunescarScribeGetMinimumCasterLevel(nTier)
            || nCasterLevel > GetLevelByClass(CLASS_TYPE_RUNESCARRED, oPC))
            return "One of your current runescars is not a valid saved-set choice.";
    }

    return "";
}

void RunescarDefaultClearSet(object oPC)
{
    // Remove the marker first so a partially-cleared record can never appear
    // usable if persistence is interrupted between writes.
    DeletePersistantLocalInt(oPC, PRC_RUNESCAR_DEFAULT_VERSION_VAR);

    int nPosition;
    for (nPosition = 1;
         nPosition <= PRC_RUNESCAR_SCRIBE_POSITION_COUNT;
         nPosition++)
    {
        DeletePersistantLocalInt(
            oPC,
            PRC_RUNESCAR_DEFAULT_SPELL_VAR_BASE + IntToString(nPosition)
        );
        DeletePersistantLocalInt(
            oPC,
            PRC_RUNESCAR_DEFAULT_LEVEL_VAR_BASE + IntToString(nPosition)
        );
    }
}

int RunescarDefaultSaveCurrentSet(object oPC)
{
    if (RunescarDefaultValidateCurrentSet(oPC) != "")
        return FALSE;

    RunescarDefaultClearSet(oPC);

    int nPosition;
    for (nPosition = 1;
         nPosition <= PRC_RUNESCAR_SCRIBE_POSITION_COUNT;
         nPosition++)
    {
        SetPersistantLocalInt(
            oPC,
            PRC_RUNESCAR_DEFAULT_SPELL_VAR_BASE + IntToString(nPosition),
            NUISpellbookGetRunescarPersistedSpell(oPC, nPosition) + 1
        );
        SetPersistantLocalInt(
            oPC,
            PRC_RUNESCAR_DEFAULT_LEVEL_VAR_BASE + IntToString(nPosition),
            NUISpellbookGetRunescarPersistedCasterLevel(oPC, nPosition)
        );
    }

    SetPersistantLocalInt(
        oPC,
        PRC_RUNESCAR_DEFAULT_VERSION_VAR,
        PRC_RUNESCAR_DEFAULT_VERSION
    );
    return TRUE;
}

string RunescarDefaultScribeSavedSet(object oPC)
{
    string sSavedError = RunescarDefaultValidateSavedSet(oPC);
    if (sSavedError != "")
        return sSavedError;

    int nScribed;
    int nOccupied;
    int nUnavailable;
    int nGoldSpent;
    int nXPSpent;
    int bStoppedByDeath;
    string sFirstIssue;
    int nPosition;
    for (nPosition = 1;
         nPosition <= PRC_RUNESCAR_SCRIBE_POSITION_COUNT;
         nPosition++)
    {
        if (GetIsDead(oPC))
        {
            bStoppedByDeath = TRUE;
            break;
        }

        if (!RunescarScribePositionIsAvailable(oPC, nPosition))
        {
            nOccupied++;
            continue;
        }

        int nSpell = RunescarDefaultGetSpell(oPC, nPosition);
        int nCasterLevel = RunescarDefaultGetCasterLevel(oPC, nPosition);
        string sError = RunescarScribeValidateSelection(
            oPC,
            nPosition,
            nSpell,
            nCasterLevel
        );
        if (sError != "")
        {
            nUnavailable++;
            if (sFirstIssue == "")
                sFirstIssue = NUISpellbookGetRunescarPositionName(nPosition)
                            + ": " + sError;
            continue;
        }

        int nTier = NUISpellbookGetRunescarSpellTier(nSpell);
        int nGoldCost = RunescarScribeGetGoldCost(nTier, nCasterLevel);
        int nXPCost = RunescarScribeGetXPCost(nTier, nCasterLevel);
        if (RunescarScribeCommitSelection(
                oPC,
                nPosition,
                nSpell,
                nCasterLevel
            ))
        {
            nScribed++;
            nGoldSpent += nGoldCost;
            nXPSpent += nXPCost;
        }
        else
        {
            nUnavailable++;
            if (sFirstIssue == "")
                sFirstIssue = NUISpellbookGetRunescarPositionName(nPosition)
                            + ": the runescar could not be scribed.";
        }
    }

    string sResult;
    if (nScribed > 0)
        sResult = "Scribed " + IntToString(nScribed)
                + " saved runescar" + ((nScribed == 1) ? "" : "s")
                + ", spending " + IntToString(nGoldSpent) + " gp and "
                + IntToString(nXPSpent) + " XP.";
    else
        sResult = "No saved runescars were scribed.";

    if (nOccupied > 0)
        sResult += " " + IntToString(nOccupied)
                + " body location" + ((nOccupied == 1) ? " was" : "s were")
                + " already occupied.";
    if (nUnavailable > 0)
        sResult += " " + IntToString(nUnavailable)
                + " saved choice" + ((nUnavailable == 1) ? " was" : "s were")
                + " left for later.";
    if (sFirstIssue != "")
        sResult += " First issue: " + sFirstIssue;
    if (bStoppedByDeath)
        sResult += " Scribing stopped when you died from the normal runescar damage.";
    return sResult;
}

void RunescarScribeClearDraftState(object oPC)
{
    DeleteLocalInt(oPC, PRC_RUNESCAR_SCRIBE_ACTIVE_SESSION_VAR);
    DeleteLocalInt(oPC, PRC_RUNESCAR_SCRIBE_LOCATION_VAR);
    DeleteLocalInt(oPC, PRC_RUNESCAR_SCRIBE_TIER_VAR);
    DeleteLocalInt(oPC, PRC_RUNESCAR_SCRIBE_SPELL_VAR);
    DeleteLocalInt(oPC, PRC_RUNESCAR_SCRIBE_CASTER_LEVEL_VAR);
    DeleteLocalInt(oPC, PRC_RUNESCAR_SCRIBE_MAP_GENERATION_VAR);
    DeleteLocalInt(oPC, PRC_RUNESCAR_SCRIBE_BOOTSTRAP_VAR);
    DeleteLocalJson(oPC, PRC_RUNESCAR_SCRIBE_SPELL_MAP_VAR);
    DeleteLocalJson(oPC, PRC_RUNESCAR_SCRIBE_SPELL_NAMES_VAR);
}

void RunescarScribeDiscardDraft(object oPC = OBJECT_SELF, int bCloseWindow = TRUE)
{
    if (bCloseWindow && GetIsPC(oPC))
    {
        int nToken = NuiFindWindow(oPC, PRC_RUNESCAR_SCRIBE_NUI_WINDOW_ID);
        if (nToken)
        {
            SetLocalInt(
                oPC,
                PRC_RUNESCAR_SCRIBE_REBUILD_TOKEN_VAR,
                nToken
            );
            NuiDestroy(oPC, nToken);
        }
    }

    RunescarScribeClearDraftState(oPC);
    int nSession = GetLocalInt(
        oPC,
        PRC_RUNESCAR_SCRIBE_SESSION_GENERATION_VAR
    ) + 1;
    if (nSession <= 0)
        nSession = 1;
    SetLocalInt(
        oPC,
        PRC_RUNESCAR_SCRIBE_SESSION_GENERATION_VAR,
        nSession
    );
}

int RunescarScribeOpenEditor(object oPC = OBJECT_SELF)
{
    if (!GetIsPC(oPC)
        || GetLevelByClass(CLASS_TYPE_RUNESCARRED, oPC) <= 0
        || !GetHasFeat(NUI_SPELLBOOK_RUNESCAR_SCRIBE_FEAT, oPC))
        return FALSE;

    int nPrevious = NuiFindWindow(oPC, PRC_RUNESCAR_SCRIBE_NUI_WINDOW_ID);
    if (nPrevious)
    {
        json jGeometry = NuiGetBind(oPC, nPrevious, "geometry");
        if (jGeometry != JsonNull())
            SetLocalJson(oPC, PRC_RUNESCAR_SCRIBE_GEOMETRY_VAR, jGeometry);
        SetLocalInt(
            oPC,
            PRC_RUNESCAR_SCRIBE_REBUILD_TOKEN_VAR,
            nPrevious
        );
        NuiDestroy(oPC, nPrevious);
    }

    RunescarScribeClearDraftState(oPC);
    int nSession = GetLocalInt(
        oPC,
        PRC_RUNESCAR_SCRIBE_SESSION_GENERATION_VAR
    ) + 1;
    if (nSession <= 0)
        nSession = 1;
    SetLocalInt(
        oPC,
        PRC_RUNESCAR_SCRIBE_SESSION_GENERATION_VAR,
        nSession
    );
    SetLocalInt(
        oPC,
        PRC_RUNESCAR_SCRIBE_ACTIVE_SESSION_VAR,
        nSession
    );

    if (!RunescarScribeInitializeDraft(oPC))
    {
        RunescarScribeClearDraftState(oPC);
        if (!NUISpellbookHasOpenRunescarPosition(oPC))
            SendMessageToPC(oPC, "All seven runescar locations are occupied.");
        else
            SendMessageToPC(
                oPC,
                "No runescar tier is currently available. Check your remaining scribing uses and Wisdom."
            );
        return FALSE;
    }

    SetLocalInt(oPC, PRC_RUNESCAR_SCRIBE_BOOTSTRAP_VAR, nSession);
    ExecuteScript("prc_nui_rb_view", oPC);
    return TRUE;
}

void RunescarScribeOpenDescription(object oPC, int nSpell)
{
    if (!RunescarScribeIsAllowedSpell(nSpell))
        return;
    CreateSpellDescriptionNUI(
        oPC,
        0,
        nSpell,
        0,
        CLASS_TYPE_RUNESCARRED
    );
}
