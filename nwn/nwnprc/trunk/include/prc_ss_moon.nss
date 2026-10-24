// Silverstar Moon Spells: ordinary slots in the selected divine spellbook.
// Keep this independent of prc_inc_domain: bonus domains use this shared code.
#include "prc_inc_spells"
#include "prc_ss_cast"

const string SSP_WINDOW = "silverstar_moon_prep";
const string SSP_LEVEL = "SSP_Level";
const string SSP_META = "SSP_Meta";
const string SSP_SLOT_MAP = "SSP_Slots";
const string SSP_CAST_SERIAL = "SSP_CastSerial";
const string SSP_CAST_ACTIVE = "SSP_CastActive";
const string SSP_MOON_BASE_LEVEL = "SSP_MoonBaseLevel";
const string SSP_MOON_TRADE_LEVEL = "SSP_MoonTradeLevel";
const int SSP_SLOT_NONE = 0;
const int SSP_SLOT_NATIVE_PREPARED = 1;
const int SSP_SLOT_NSB_PREPARED = 2;
const int SSP_SLOT_NSB_SPONTANEOUS = 3;

int SSPGetClass(object oPC)
{
    if(GetLevelByClass(173, oPC) < 1 || !GetHasFeat(26428, oPC))
        return CLASS_TYPE_INVALID;
    int nClass = SSGetSelectedDivineClass(oPC);
    if(nClass != GetPrimaryDivineClass(oPC)) return CLASS_TYPE_INVALID;
    return nClass;
}

// Match PRC's spellbook adapter: an existing persistent spell-use array owns
// the book, even for an older character whose class now uses native slots.
// Never create a missing array or refill a book while checking/casting Moon.
int SSPGetSlotBackend(object oPC, int nClass)
{
    if(nClass == CLASS_TYPE_INVALID || GetLevelByClass(nClass, oPC) < 1)
        return SSP_SLOT_NONE;
    if(persistant_array_exists(oPC, "NewSpellbookMem_" + IntToString(nClass)))
    {
        int nType = GetSpellbookTypeForClass(nClass);
        if(nType == SPELLBOOK_TYPE_PREPARED) return SSP_SLOT_NSB_PREPARED;
        if(nType == SPELLBOOK_TYPE_SPONTANEOUS) return SSP_SLOT_NSB_SPONTANEOUS;
        return SSP_SLOT_NONE;
    }
    if(Get2DACache("classes", "SpellCaster", nClass) == "1"
        && Get2DACache("classes", "MemorizesSpells", nClass) == "1")
        return SSP_SLOT_NATIVE_PREPARED;
    // Current spontaneous divine books use PRC arrays. A native spontaneous
    // book needs a class-specific debit API; the spell-ID-only decrement can
    // consume a different class's slot and must not be used as a fallback.
    return SSP_SLOT_NONE;
}

int SSPIsNativePrepared(object oPC, int nClass)
{
    return SSPGetSlotBackend(oPC, nClass) == SSP_SLOT_NATIVE_PREPARED;
}

int SSPMoonSpell(int nLevel)
{
    if(nLevel < 1 || nLevel > 9) return -1;
    string sSpell = Get2DACache("prc_domains", "Level_" + IntToString(nLevel),
        PRC_DOMAIN_MOON - 1);
    if(sSpell == "" || sSpell == "****") return -1;
    return StringToInt(sSpell);
}

int SSPMoonLevel(int nSpell)
{
    int nLevel;
    for(nLevel = 1; nLevel <= 9; nLevel++)
        if(SSPMoonSpell(nLevel) == nSpell) return nLevel;
    return -1;
}

// Only the selected Moon bonus-domain route receives the Silverstar exception.
// Owning any other domain (or just its power) never removes its daily limit.
int SSPIsMoonTrade(object oPC, int nDomain)
{
    return nDomain == PRC_DOMAIN_MOON && SSPGetClass(oPC) != CLASS_TYPE_INVALID;
}

// Return a payment token in the selected book: native slot index, PRC prepared
// storage row, or PRC spontaneous spell level. Negative means unavailable.
// Prepared slots pay at their actual slot level; the Moon spell is unmodified.
// Native domain slots never pay this cost. PRC's per-level prepared index is
// authoritative, including canonical parent rows for subradial spells.
int SSPFindTradeSlot(object oPC, int nLevel)
{
    int nClass = SSPGetClass(oPC);
    if(nClass == CLASS_TYPE_INVALID || nLevel < 1 || nLevel > 9
        || GetAbilityScoreForClass(nClass, oPC) < 10 + nLevel) return -1;
    int nBackend = SSPGetSlotBackend(oPC, nClass);
    string sMemory = "NewSpellbookMem_" + IntToString(nClass);
    if(nBackend == SSP_SLOT_NSB_SPONTANEOUS)
    {
        if(persistant_array_get_int(oPC, sMemory, nLevel) > 0) return nLevel;
        return -1;
    }
    int i;
    if(nBackend == SSP_SLOT_NSB_PREPARED)
    {
        string sIndex = "SpellbookIDX" + IntToString(nLevel) + "_"
            + IntToString(nClass);
        if(!persistant_array_exists(oPC, sIndex)) return -1;
        int nRows = persistant_array_get_size(oPC, sIndex);
        for(i = 0; i < nRows; i++)
        {
            int nRow = persistant_array_get_int(oPC, sIndex, i);
            if(nRow > 0 && persistant_array_get_int(oPC, sMemory, nRow) > 0)
                return nRow;
        }
        return -1;
    }
    if(nBackend != SSP_SLOT_NATIVE_PREPARED) return -1;
    int nCount = GetMemorizedSpellCountByLevel(oPC, nClass, nLevel);
    for(i = 0; i < nCount; i++)
    {
        int nSpell = GetMemorizedSpellId(oPC, nClass, nLevel, i);
        if(nSpell >= 0 && nSpell != 65535
            && GetMemorizedSpellReady(oPC, nClass, nLevel, i) == TRUE
            && GetMemorizedSpellIsDomainSpell(oPC, nClass, nLevel, i) == FALSE)
            return i;
    }
    return -1;
}

// Revalidate and debit synchronously, before queueing a cast. Do not arm the
// generic NSB/bonus-domain burner: this slot has already been paid, and a
// cancelled queued cast intentionally does not refund it.
int SSPSpendTradeSlot(object oPC, int nLevel)
{
    int nToken = SSPFindTradeSlot(oPC, nLevel);
    if(nToken < 0) return FALSE;
    int nClass = SSPGetClass(oPC);
    int nBackend = SSPGetSlotBackend(oPC, nClass);
    if(nBackend == SSP_SLOT_NATIVE_PREPARED)
    {
        SetMemorizedSpellReady(oPC, nClass, nLevel, nToken, FALSE);
        return TRUE;
    }
    if(nBackend == SSP_SLOT_NSB_PREPARED || nBackend == SSP_SLOT_NSB_SPONTANEOUS)
    {
        string sMemory = "NewSpellbookMem_" + IntToString(nClass);
        int nRemaining = persistant_array_get_int(oPC, sMemory, nToken);
        if(nRemaining < 1) return FALSE;
        persistant_array_set_int(oPC, sMemory, nToken, nRemaining - 1);
        return TRUE;
    }
    return FALSE;
}

int SSPIsMoonCastChoice(int nSpell, int nCastSpell)
{
    if(nCastSpell < 0) return FALSE;
    string sFirst = Get2DACache("spells", "SubRadSpell1", nSpell);
    int bSubradial = sFirst != "" && sFirst != "****";
    if(!bSubradial) return nCastSpell == nSpell;
    int i;
    for(i = 1; i <= 5; i++)
    {
        string sChild = Get2DACache("spells", "SubRadSpell" + IntToString(i), nSpell);
        if(sChild != "" && sChild != "****" && StringToInt(sChild) == nCastSpell)
            return TRUE;
    }
    return FALSE;
}

int SSPMoonTargetValid(object oPC, int nSpell, object oTarget, location lTarget)
{
    int nTypes = HexToInt(Get2DACache("spells", "TargetType", nSpell));
    if(GetIsObjectValid(oTarget))
    {
        if(GetArea(oTarget) != GetArea(oPC)) return FALSE;
        if(oTarget == oPC) return (nTypes & 1) != 0;
        int nObjectType = GetObjectType(oTarget);
        if(nObjectType == OBJECT_TYPE_CREATURE) return (nTypes & 2) != 0;
        if(nObjectType == OBJECT_TYPE_ITEM) return (nTypes & 8) != 0;
        if(nObjectType == OBJECT_TYPE_DOOR) return (nTypes & 16) != 0;
        if(nObjectType == OBJECT_TYPE_PLACEABLE) return (nTypes & 32) != 0;
        return FALSE;
    }
    return (nTypes & 4) != 0 && GetIsObjectValid(GetAreaFromLocation(lTarget))
        && GetAreaFromLocation(lTarget) == GetArea(oPC);
}

void SSPClearMoonTrade(object oPC)
{
    DeleteLocalInt(oPC, SSP_MOON_TRADE_LEVEL);
    DeleteLocalInt(oPC, "DomainOrigSpell");
    DeleteLocalInt(oPC, "DomainSubChoice");
    DeleteLocalObject(oPC, "DomainTarget");
    DeleteLocalLocation(oPC, "DomainTarget");
    DeleteLocalInt(oPC, "DomainTargetSaved");
}

int SSPMetaFeat(int nMeta)
{
    switch(nMeta)
    {
        case METAMAGIC_EMPOWER: return FEAT_EMPOWER_SPELL;
        case METAMAGIC_EXTEND: return FEAT_EXTEND_SPELL;
        case METAMAGIC_MAXIMIZE: return FEAT_MAXIMIZE_SPELL;
        case METAMAGIC_QUICKEN: return FEAT_QUICKEN_SPELL;
        case METAMAGIC_SILENT: return FEAT_SILENCE_SPELL;
        case METAMAGIC_STILL: return FEAT_STILL_SPELL;
    }
    return -1;
}

int SSPMetaAllowed(object oPC, int nSpell, int nMeta)
{
    if(nMeta == METAMAGIC_NONE) return TRUE;
    int nFeat = SSPMetaFeat(nMeta);
    return nFeat >= 0 && GetHasFeat(nFeat, oPC)
        && (HexToInt(Get2DACache("spells", "MetaMagic", nSpell)) & nMeta);
}

string SSPSpellName(int nSpell)
{
    if(nSpell < 0) return "Empty";
    return GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSpell)));
}

int SSPIsPreparedMoon(object oPC, int nClass, int nLevel, int nSpell,
    int nMeta, int bDomain)
{
    int nBase = SSPMoonLevel(nSpell);
    return !bDomain && nClass == SSPGetClass(oPC)
        && SSPIsNativePrepared(oPC, nClass)
        && nBase >= 1 && SSPMetaAllowed(oPC, nSpell, nMeta)
        && nLevel == nBase + GetMetaMagicSpellLevelAdjustment(nMeta)
        && GetAbilityScoreForClass(nClass, oPC) >= 10 + nBase;
}

void SSPClearCastOverrides(int nSerial, int nClass, int nBaseLevel, int nMeta,
    object oTarget)
{
    if(GetLocalInt(OBJECT_SELF, SSP_CAST_ACTIVE) != nSerial) return;
    // This cleanup runs on the action queue. Do not erase values changed by
    // another casting system since our spell set them.
    if(GetLocalInt(OBJECT_SELF, PRC_CASTERCLASS_OVERRIDE) == nClass)
        DeleteLocalInt(OBJECT_SELF, PRC_CASTERCLASS_OVERRIDE);
    if(GetLocalInt(OBJECT_SELF, PRC_DC_BASE_OVERRIDE) == -1)
        DeleteLocalInt(OBJECT_SELF, PRC_DC_BASE_OVERRIDE);
    if(GetLocalInt(OBJECT_SELF, SSP_MOON_BASE_LEVEL) == nBaseLevel)
        DeleteLocalInt(OBJECT_SELF, SSP_MOON_BASE_LEVEL);
    if(nMeta != METAMAGIC_NONE
        && GetLocalInt(OBJECT_SELF, PRC_METAMAGIC_ADJUSTMENT) == nMeta)
        DeleteLocalInt(OBJECT_SELF, PRC_METAMAGIC_ADJUSTMENT);
    if(GetLocalObject(OBJECT_SELF, PRC_SPELL_TARGET_OBJECT_OVERRIDE) == oTarget)
    {
        DeleteLocalInt(OBJECT_SELF, PRC_SPELL_TARGET_OBJECT_OVERRIDE);
        DeleteLocalObject(OBJECT_SELF, PRC_SPELL_TARGET_OBJECT_OVERRIDE);
        DeleteLocalInt(OBJECT_SELF, PRC_SPELL_TARGET_LOCATION_OVERRIDE);
    }
    DeleteLocalInt(OBJECT_SELF, "UsingActionCastSpell");
    DeleteLocalInt(OBJECT_SELF, SSP_CAST_ACTIVE);
}

void SSPWatchCastOverrides(int nSerial, int nClass, int nBaseLevel, int nMeta,
    object oTarget, int nAttempts)
{
    if(GetLocalInt(OBJECT_SELF, SSP_CAST_ACTIVE) != nSerial) return;
    int nAction = GetCurrentAction(OBJECT_SELF);
    if((nAction == ACTION_CASTSPELL || nAction == ACTION_ITEMCASTSPELL)
        && nAttempts < 120)
    {
        DelayCommand(0.5f, SSPWatchCastOverrides(nSerial, nClass, nBaseLevel,
            nMeta, oTarget, nAttempts + 1));
        return;
    }
    // Like the native NUI metamagic watchdog, queue the guarded cleanup after
    // any newer action rather than modifying another spell from a timer.
    ActionDoCommand(SSPClearCastOverrides(nSerial, nClass, nBaseLevel, nMeta, oTarget));
    if(nAttempts < 120)
        DelayCommand(1.0f, SSPWatchCastOverrides(nSerial, nClass, nBaseLevel,
            nMeta, oTarget, nAttempts + 1));
}

void SSPArmCastOverrides(int nSerial, int nClass, int nBaseLevel, int nMeta,
    object oTarget)
{
    SetLocalInt(OBJECT_SELF, SSP_CAST_ACTIVE, nSerial);
    SetLocalInt(OBJECT_SELF, SSP_MOON_BASE_LEVEL, nBaseLevel);
    // Registered before the cast, so cancellation or spell-side
    // ClearAllActions does not discard the independent cleanup watchdog.
    DelayCommand(1.0f, SSPWatchCastOverrides(nSerial, nClass, nBaseLevel,
        nMeta, oTarget, 0));
}

// Both Moon routes use the same normal-time PRC cast and guarded metadata.
// The caller must validate the request and spend its exact slot first.
void SSPQueueMoonCast(object oPC, int nClass, int nSpell, int nCastSpell,
    int nMeta, object oTarget, location lTarget)
{
    int nBaseLevel = SSPMoonLevel(nSpell);

    // ActionCastSpell snapshots its target while it queues the cast. Preserve
    // any caller location, and let its queued setter/cleanup own this cast.
    int bPrevious = GetLocalInt(oPC, PRC_SPELL_TARGET_LOCATION_OVERRIDE);
    location lPrevious = GetLocalLocation(oPC, PRC_SPELL_TARGET_LOCATION_OVERRIDE);
    int bPreviousObject = GetLocalInt(oPC, PRC_SPELL_TARGET_OBJECT_OVERRIDE);
    object oPrevious = GetLocalObject(oPC, PRC_SPELL_TARGET_OBJECT_OVERRIDE);
    SetLocalInt(oPC, PRC_SPELL_TARGET_LOCATION_OVERRIDE, TRUE);
    SetLocalLocation(oPC, PRC_SPELL_TARGET_LOCATION_OVERRIDE, lTarget);
    ActionDoCommand(SetLocalLocation(oPC,
        PRC_SPELL_TARGET_LOCATION_OVERRIDE, lTarget));
    // Moon Path uses the selected location as its endpoint while the engine
    // targets self, matching the accepted portable domain cast route.
    object oCastTarget = oTarget;
    if(nSpell == 19400) oCastTarget = oPC;
    int nSerial = GetLocalInt(oPC, SSP_CAST_SERIAL) + 1;
    if(nSerial <= 0) nSerial = 1;
    SetLocalInt(oPC, SSP_CAST_SERIAL, nSerial);
    ActionDoCommand(SSPArmCastOverrides(nSerial, nClass, nBaseLevel, nMeta, oCastTarget));
    SetLocalInt(oPC, PRC_SPELL_TARGET_OBJECT_OVERRIDE, TRUE);
    SetLocalObject(oPC, PRC_SPELL_TARGET_OBJECT_OVERRIDE, oCastTarget);
    // -1 requests PRC's dynamic DC, preserving the class's DC ability, Spell Focus and
    // other modifiers. The staged PRC helper reads SSP_MoonBaseLevel solely
    // during this validated Moon cast to replace its spell-level term.
    ActionCastSpell(nCastSpell, 0, -1, 0, nMeta, nClass,
        TRUE, TRUE, oCastTarget, FALSE);
    ActionDoCommand(SSPClearCastOverrides(nSerial, nClass, nBaseLevel, nMeta, oCastTarget));
    if(bPrevious)
    {
        SetLocalInt(oPC, PRC_SPELL_TARGET_LOCATION_OVERRIDE, bPrevious);
        SetLocalLocation(oPC, PRC_SPELL_TARGET_LOCATION_OVERRIDE, lPrevious);
    }
    else
    {
        DeleteLocalInt(oPC, PRC_SPELL_TARGET_LOCATION_OVERRIDE);
        DeleteLocalLocation(oPC, PRC_SPELL_TARGET_LOCATION_OVERRIDE);
    }
    if(bPreviousObject)
    {
        SetLocalInt(oPC, PRC_SPELL_TARGET_OBJECT_OVERRIDE, bPreviousObject);
        SetLocalObject(oPC, PRC_SPELL_TARGET_OBJECT_OVERRIDE, oPrevious);
    }
    else
    {
        DeleteLocalInt(oPC, PRC_SPELL_TARGET_OBJECT_OVERRIDE);
        DeleteLocalObject(oPC, PRC_SPELL_TARGET_OBJECT_OVERRIDE);
    }
}

// Legacy preparation remains supported. Spend before queuing; cancelling a
// cast never refunds the slot, so repeated requests cannot reuse its charge.
int SSPCastPreparedMoon(object oPC, int nClass, int nLevel, int nSpell,
    int nCastSpell, int nMeta, object oTarget, location lTarget)
{
    if(!SSPIsPreparedMoon(oPC, nClass, nLevel, nSpell, nMeta, FALSE)
        || !SSPIsMoonCastChoice(nSpell, nCastSpell)
        || !SSPMoonTargetValid(oPC, nCastSpell, oTarget, lTarget)) return FALSE;
    int nIndex = -1;
    int nCount = GetMemorizedSpellCountByLevel(oPC, nClass, nLevel);
    int i;
    for(i = 0; i < nCount; i++)
    {
        if(GetMemorizedSpellId(oPC, nClass, nLevel, i) == nSpell
            && GetMemorizedSpellMetaMagic(oPC, nClass, nLevel, i) == nMeta
            && !GetMemorizedSpellIsDomainSpell(oPC, nClass, nLevel, i)
            && GetMemorizedSpellReady(oPC, nClass, nLevel, i))
        {
            nIndex = i;
            break;
        }
    }
    if(nIndex < 0) return FALSE;
    SetMemorizedSpellReady(oPC, nClass, nLevel, nIndex, FALSE);
    SSPQueueMoonCast(oPC, nClass, nSpell, nCastSpell, nMeta, oTarget, lTarget);
    return TRUE;
}

// Silverstar's accepted NWN adaptation: trade an ordinary divine slot for
// the Moon spell of that exact level. This deliberately never sets DomainCast
// or DomainCastSpell: PRC's legacy burner and per-level daily gate do not run.
int SSPCastTradedMoon(object oPC, int nLevel, int nSpell, int nCastSpell,
    object oTarget, location lTarget)
{
    if(!SSPIsMoonTrade(oPC, PRC_DOMAIN_MOON)
        || nLevel < 1 || nLevel > 9 || SSPMoonSpell(nLevel) != nSpell
        || !SSPIsMoonCastChoice(nSpell, nCastSpell)
        || !SSPMoonTargetValid(oPC, nCastSpell, oTarget, lTarget)
        || GetLocalInt(oPC, "DomainCast")) return FALSE;
    if(!SSPSpendTradeSlot(oPC, nLevel)) return FALSE;
    int nClass = SSPGetClass(oPC);
    SSPQueueMoonCast(oPC, nClass, nSpell, nCastSpell,
        METAMAGIC_NONE, oTarget, lTarget);
    return TRUE;
}
