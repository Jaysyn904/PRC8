//::///////////////////////////////////////////////
//:: PRC Spellbook Script
//:: prc_nui_sb_inc
//:://////////////////////////////////////////////
/*
    This is the script that handles some backend work for the PRC Spellbook
    NUI View
*/
//:://////////////////////////////////////////////
//:: Created By: Rakiov
//:: Created On: 24.05.2005
//:://////////////////////////////////////////////

#include "prc_nui_com_inc"
#include "prc_inc_domain"

//
// GetSpellListForCircle
// Gets the spell list for a specified class at the specified circle.
//
// Arguments:
//   oPlayer:object the player
//   nClass:int the ClassID
//   circle:int the circle we want to grab for
//
// Returns:
//   json:Array<int> a list of all the spellIDs of the given circle
//
json GetSpellListForCircle(object oPlayer, int nClass, int circle);

//
// GetSupportedNUISpellbookClasses
// Gets the list of support PRC classes that can use the NUi spellbook that
// the player has.
//
// Arguments:
//  oPlayer:object the player this is being determined for
//
// Returns:
//   json:int list of class ids that have the player has that can use the
//     NUI spellbook.
//
json GetSupportedNUISpellbookClasses(object oPlayer);

//
// IsSpellKnown
// Returns whether the player with the given class, spell file, and spellbook id
// knows the spell or not
//
// Arguments:
//   oPlayer;Object the player
//   nClass:int the class ID
//   spellId:int the spell ID to check
//
// Returns:
//   int:Boolean TRUE if spell is known, FALSE otherwise
//
int IsSpellKnown(object oPlayer, int nClass, int spellId);

//
// IsClassAllowedToUseNUISpellbook
// Takes a player and a classId and determines if thee class is allowed to
// be using the NUI spellbook.
//
// Arguments:
//   oPlayer:Object the player
//   nClass:int the ClassID
//
// Returns:
//   int:Boolean TRUE if allowed to use the spellbook, FALSE otherwise
//
int IsClassAllowedToUseNUISpellbook(object oPlayer, int nClass);

//
// CanClassUseMetamagicFeats
// Given a class id determines if it is allowed to use the Metamagic feats
//
// Arguments:
//   nClass:int the ClassID
//
// Returns:
//   int:Boolean TRUE if allowed to use the set of feats, FALSE otherwise
//
int CanClassUseMetamagicFeats(int nClass);

//
// CanClassUseSuddenMetamagicFeats
// Given a class id determines if it is allowed to use the Sudden Metamagic feats
//
// Arguments:
//   nClass:int the ClassID
//
// Returns:
//   int:Boolean TRUE if allowed to use the set of feats, FALSE otherwise
//
int CanClassUseSuddenMetamagicFeats(int nClass);

//
// CanClassUseMetaPsionicFeats
// Given a class id determines if it is allowed to use the MetaPsionic feats
//
// Arguments:
//   nClass:int the ClassID
//
// Returns:
//   int:Boolean TRUE if allowed to use the set of feats, FALSE otherwise
//
int CanClassUseMetaPsionicFeats(int nClass);

//
// CanClassUseMetaMysteryFeats
// Given a class id determines if it is allowed to use the MetaMystery feats
//
// Arguments:
//   nClass:int the ClassID
//
// Returns:
//   int:Boolean TRUE if allowed to use the set of feats, FALSE otherwise
//
int CanClassUseMetaMysteryFeats(int nClass);

//
// GetMetaMagicFeatList
// Gets the list of MetaMagic featIDs
//
// Returns:
//   json:Array<int> the list of FeatIDs associated with the meta feats
//
json GetMetaMagicFeatList();

//
// GetSuddenMetaMagicFeatList
// Gets the list of Sudden MetaMagic featIDs
//
// Returns:
//   json:Array<int> the list of FeatIDs associated with the meta feats
//
json GetSuddenMetaMagicFeatList();

//
// GetMetaPsionicFeatList
// Gets the list of MetaPsionic featIDs
//
// Returns:
//   json:Array<int> the list of FeatIDs associated with the meta feats
//
json GetMetaPsionicFeatList();

//
// GetMetaMagicMysteryList
// Gets the list of MetaMystery featIDs
//
// Returns:
//   json:Array<int> the list of FeatIDs associated with the meta feats
//
json GetMetaMysteryFeatList();

//
// GetTrueClassIfRHD
// Checks to make sure if the provided RHD class and player's race
// match up to give them their proper spell caster class (ie Glouras have
// bard spells and thus should be treated like a bard class)
//
// Arguments:
//   oPlayer:object the player
//   nClass:int the ClassID
//
// Returns:
//   int the true ClassID to use, otherwise nClass
//
int GetTrueClassIfRHD(object oPlayer, int nClass);

//
// ShouldAddSpell
// Given a spellId and a class, determines if the spell should be added to the
// spellbook (as some are added in it's own special row or for other reasons)
//
// Arguments:
//   nClass:int the ClassID
//   spellId:int the SpellID
//   oPlayer:object the player
//
// Returns:
//   int:Boolean TRUE if the spell should be added, FALSE otherwise
//
int ShouldAddSpell(int nClass, int spellId, object oPlayer=OBJECT_SELF);

//
// NUISpellbookGetPreparedStorageRow
// Resolves the persistent NewSpellbookMem_* row that owns the remaining uses
// for a displayed PRC spellbook entry. Archivist subradial children spend the
// prepared master entry rather than their own non-preparable child rows.
//
int NUISpellbookGetPreparedStorageRow(int nClass, int nSpellbookID, int nSpellID);

// Updates the already-rendered Archivist spell buttons without destroying the
// spellbook window. Each radial child is mapped to the prepared master row that
// owns its remaining-use count. Exhausted spells stay visible, but are disabled
// so the prepared roster and layout remain stable.
void NUISpellbookRefreshArchivistButtons(object oPlayer, int nToken);

// Returns TRUE when the currently rendered Archivist map and the rebuilt
// prepared index contain the same unique storage rows for one spell circle.
int NUISpellbookArchivistRosterMatchesCurrentMap(
    object oPlayer,
    int nCircle
);

// Refreshes only the binds of an already-open Archivist tier after the
// new-spellbook rest rebuild has settled. It replaces the root in place only
// when the selected circle's prepared-row membership actually changed.
void NUISpellbookRefreshOpenArchivistAfterRest(object oPlayer);

// Updates only the displayed Archivist buttons that spend one prepared
// storage row. Radial children that share a master preparation update together.
void NUISpellbookRefreshArchivistStorageRow(
    object oPlayer,
    int nToken,
    int nStorageRow
);

// Applies a cast result only if the same Archivist tier/layout is still open.
// A tier change therefore wins over an in-flight cast update.
void NUISpellbookApplyArchivistCastUpdate(
    object oPlayer,
    int nToken,
    int nLayoutGeneration,
    int nCircle,
    int nStorageRow
);

// Clears one exact cast fence. If navigation was requested while that cast was
// unresolved, the coalesced destination is rendered once after the fence ends.
void NUISpellbookReleaseArchivistCastFence(
    object oPlayer,
    int nFenceGeneration,
    int nToken,
    int nLayoutGeneration
);

// Applies the captured cast row to the still-live old root during the proven
// NUI settling gap, before a requested destination is rendered.
void NUISpellbookSettleArchivistCastResult(
    object oPlayer,
    int nFenceGeneration,
    int nToken,
    int nLayoutGeneration,
    int nStorageRow
);

// Starts a bounded, cast-scoped watcher for one Archivist preparation. It
// updates that row only while the player remains on the same live tier/layout.
void NUISpellbookStartArchivistCastWatch(
    object oPlayer,
    int nSpell,
    int nStorageRow,
    int nCircle,
    int nInitialReady
);

//
// GetToBStanceSpellList
// Gets the ToB Stance Spell List for the given class
//
// Arguments:
//   nClass:int ClassID
//   oPlayer:object the player
//
// Returns:
//   json:Array<Int> the list of stances' SpellIDs
//
json GetToBStanceSpellList(int nClass, object oPlayer=OBJECT_SELF);

//
// GetInvokerShapeSpellList
// Gets the Invoker Shapes Spell List for the given class
//
// Arguments:
//   nClass:int ClassID
//   oPlayer:object the player
//
// Returns:
//   json:Array<Int> the list of shapes' SpellIDs
//
json GetInvokerShapeSpellList(int nClass, object oPlayer=OBJECT_SELF);

//
// GetInvokerEssenceSpellList
// Gets the Invoker Essences Spell List for the given class
//
// Arguments:
//   nClass:int ClassID
//   oPlayer:object the player
//
// Returns:
//   json:Array<Int> the list of essences' SpellIDs
//
json GetInvokerEssenceSpellList(int nClass, object oPlayer=OBJECT_SELF);

//
// JsonArrayContainsInt
// A helper function that takes a json array list and sees if the int item is within i
//
// Arguments:
//   list:json:Array<Int> the list of ints
//   item:int the item we are looking for
//
// Returns:
//   int:Boolean TRUE if item is found, FALSE otherwise
//
int JsonArrayContainsInt(json list, int item);

//
// IsSpellbookNUIOpen
// Checks to see if the Spellbook NUI is open on a given player.
//
// Arguments:
//   oPC:object the player
//
// Returns:
//   int:Boolean TRUE if window is open, FALSE otherwise
//
int IsSpellbookNUIOpen(object oPC);

// Domain-mode helpers. PRC bonus domains are stored separately from native
// prepared domain slots, but both are character-wide rather than class-tab
// resources.
int NUISpellbookHasBonusDomains(object oPlayer);
int NUISpellbookHasNativeDomains(object oPlayer);
int NUISpellbookHasNativePreparedDomainSpells(object oPlayer);
int NUISpellbookHasDomainContent(object oPlayer);
int NUISpellbookGetBonusDomainSpell(object oPlayer, int nSlot, int nLevel);
int NUISpellbookIsNativePreparedClass(int nClass);
int NUISpellbookIsNativeSpontaneousClass(int nClass);
int NUISpellbookUsesNativeClassAdapter(object oPlayer, int nClass);
int NUISpellbookNativeLevelHasContent(object oPlayer, int nClass, int nLevel);
int NUISpellbookNativePreparedCount(object oPlayer, int nClass, int nLevel,
    int nSpell, int nMetamagic, int bDomain, int bReadyOnly=FALSE);
int NUISpellbookNativeKnownAtLevel(object oPlayer, int nClass, int nLevel, int nSpell);

int NUISpellbookIsNativePreparedClass(int nClass)
{
    // Compare the raw strings. Blank/**** cells must not be coerced to zero
    // and mistaken for an intentional class flag.
    return Get2DACache("classes", "SpellCaster", nClass) == "1"
        && Get2DACache("classes", "MemorizesSpells", nClass) == "1";
}

int NUISpellbookIsNativeSpontaneousClass(int nClass)
{
    // In this PRC tree, only the two stock restricted spontaneous books are
    // engine-owned. PRC spontaneous classes use NewSpellbookMem_* and must not
    // be temporarily hijacked before their persistent arrays initialize.
    return (nClass == CLASS_TYPE_BARD || nClass == CLASS_TYPE_SORCERER)
        && Get2DACache("classes", "SpellCaster", nClass) == "1"
        && Get2DACache("classes", "MemorizesSpells", nClass) == "0"
        && Get2DACache("classes", "SpellbookRestricted", nClass) == "1";
}

int NUISpellbookUsesNativeClassAdapter(object oPlayer, int nClass)
{
    if (GetLevelByClass(nClass, oPlayer) <= 0)
        return FALSE;

    // A PRC new-spellbook array remains authoritative whenever it exists.
    if (persistant_array_exists(oPlayer, "NewSpellbookMem_" + IntToString(nClass)))
        return FALSE;

    return NUISpellbookIsNativePreparedClass(nClass)
        || NUISpellbookIsNativeSpontaneousClass(nClass);
}

int NUISpellbookNativeLevelHasContent(object oPlayer, int nClass, int nLevel)
{
    if (nLevel < 0 || nLevel > 9
        || !NUISpellbookUsesNativeClassAdapter(oPlayer, nClass))
        return FALSE;

    if (NUISpellbookIsNativePreparedClass(nClass))
        return GetMemorizedSpellCountByLevel(oPlayer, nClass, nLevel) > 0;

    return GetKnownSpellCount(oPlayer, nClass, nLevel) > 0;
}

int NUISpellbookNativePreparedCount(object oPlayer, int nClass, int nLevel,
    int nSpell, int nMetamagic, int bDomain, int bReadyOnly=FALSE)
{
    if (!NUISpellbookUsesNativeClassAdapter(oPlayer, nClass)
        || !NUISpellbookIsNativePreparedClass(nClass)
        || nLevel < 0 || nLevel > 9 || nSpell < 0)
        return 0;

    int nMatches;
    int nCount = GetMemorizedSpellCountByLevel(oPlayer, nClass, nLevel);
    int nIndex;
    for (nIndex = 0; nIndex < nCount; nIndex++)
    {
        if (GetMemorizedSpellId(oPlayer, nClass, nLevel, nIndex) == nSpell
            && GetMemorizedSpellMetaMagic(oPlayer, nClass, nLevel, nIndex) == nMetamagic
            && GetMemorizedSpellIsDomainSpell(oPlayer, nClass, nLevel, nIndex) == bDomain
            && (!bReadyOnly
                || GetMemorizedSpellReady(oPlayer, nClass, nLevel, nIndex) == TRUE))
            nMatches++;
    }

    return nMatches;
}

int NUISpellbookNativeKnownAtLevel(object oPlayer, int nClass, int nLevel, int nSpell)
{
    if (!NUISpellbookUsesNativeClassAdapter(oPlayer, nClass)
        || !NUISpellbookIsNativeSpontaneousClass(nClass)
        || nLevel < 0 || nLevel > 9 || nSpell < 0)
        return FALSE;

    int nCount = GetKnownSpellCount(oPlayer, nClass, nLevel);
    int nIndex;
    for (nIndex = 0; nIndex < nCount; nIndex++)
    {
        if (GetKnownSpellId(oPlayer, nClass, nLevel, nIndex) == nSpell)
            return TRUE;
    }

    return FALSE;
}

int NUISpellbookHasBonusDomains(object oPlayer)
{
    int nSlot;
    for (nSlot = 1; nSlot <= 5; nSlot++)
    {
        if (GetBonusDomain(oPlayer, nSlot) > 0)
            return TRUE;
    }

    return FALSE;
}

int NUISpellbookHasNativeDomains(object oPlayer)
{
    int nPosition = 1;
    int nClass = GetClassByPosition(nPosition, oPlayer);

    while (nClass != CLASS_TYPE_INVALID)
    {
        if (StringToInt(Get2DACache("classes", "PickDomains", nClass))
            && (GetDomain(oPlayer, 1, nClass) >= 0
                || GetDomain(oPlayer, 2, nClass) >= 0))
            return TRUE;

        nPosition++;
        nClass = GetClassByPosition(nPosition, oPlayer);
    }

    return FALSE;
}

int NUISpellbookHasNativePreparedDomainSpells(object oPlayer)
{
    int nPosition = 1;
    int nClass = GetClassByPosition(nPosition, oPlayer);

    while (nClass != CLASS_TYPE_INVALID)
    {
        if (StringToInt(Get2DACache("classes", "MemorizesSpells", nClass)))
        {
            int nLevel;
            for (nLevel = 1; nLevel <= 9; nLevel++)
            {
                int nCount = GetMemorizedSpellCountByLevel(oPlayer, nClass, nLevel);
                int nIndex;
                for (nIndex = 0; nIndex < nCount; nIndex++)
                {
                    if (GetMemorizedSpellIsDomainSpell(oPlayer, nClass, nLevel, nIndex) == TRUE
                        && GetMemorizedSpellId(oPlayer, nClass, nLevel, nIndex) >= 0)
                        return TRUE;
                }
            }
        }

        nPosition++;
        nClass = GetClassByPosition(nPosition, oPlayer);
    }

    return FALSE;
}

int NUISpellbookHasDomainContent(object oPlayer)
{
    return NUISpellbookHasBonusDomains(oPlayer)
        || NUISpellbookHasNativeDomains(oPlayer);
}

int NUISpellbookGetBonusDomainSpell(object oPlayer, int nSlot, int nLevel)
{
    if (nSlot < 1 || nSlot > 5 || nLevel < 1 || nLevel > 9)
        return -1;

    int nDomain = GetBonusDomain(oPlayer, nSlot);
    if (nDomain <= 0)
        return -1;

    // Read the table directly instead of calling GetDomainSpell(). That public
    // helper displays an error message for blank domain levels, which must not
    // happen while merely rendering the NUI.
    string sSpell = Get2DACache(
        "prc_domains",
        "Level_" + IntToString(nLevel),
        nDomain - 1
    );

    if (sSpell == "" || sSpell == "****")
        return -1;

    return StringToInt(sSpell);
}

json GetSpellListForCircle(object oPlayer, int nClass, int circle)
{
    json retValue = JsonArray();
    string sFile = GetClassSpellbookFile(nClass);
    int totalSpells;
    json binderDictKeys;
    //Special case for Binder since they don't have their own spellbook 2da
    if (nClass == CLASS_TYPE_BINDER)
    {
        json binderDict = GetBinderSpellToFeatDictionary(oPlayer);

        // we loop through the list of SpellIDs
        binderDictKeys = JsonObjectKeys(binderDict);
        totalSpells = JsonGetLength(binderDictKeys);
    }
    else
        totalSpells = Get2DARowCount(sFile);

    int i;
    for (i = 0; i < totalSpells; i++)
    {
        int currentSpell;
        if (nClass == CLASS_TYPE_BINDER)
            currentSpell = StringToInt(JsonGetString(JsonArrayGet(binderDictKeys, i)));
        else
            currentSpell = StringToInt(Get2DACache(sFile, "SpellID", i));

        if (ShouldAddSpell(nClass, currentSpell, oPlayer))
        {
            string sSpellLevel = Get2DACache("spells", "Innate", currentSpell);
            int iSpellLevel = StringToInt(sSpellLevel);

            if (nClass == CLASS_TYPE_BINDER && IsSpellKnown(oPlayer, nClass, currentSpell))
            {
                retValue = JsonArrayInsert(retValue, JsonInt(currentSpell));
            }
            else if ((iSpellLevel == circle && IntToString(iSpellLevel) == sSpellLevel))
            {
                //  We add the spell if it is known and is not a radial master spell (since those don't work)
                if (IsSpellKnown(oPlayer, nClass, currentSpell))
                   retValue = JsonArrayInsert(retValue, JsonInt(i));
            }
        }
    }

    return retValue;
}

int ShouldAddSpell(int nClass, int spellId, object oPlayer=OBJECT_SELF)
{
    int isRadialMasterSpell = StringToInt(Get2DACache("spells", "SubRadSpell1", spellId));
    // We don't add radial master spells
    if (isRadialMasterSpell)
        return FALSE;
    // we don't add essences and shapes
    if (nClass == CLASS_TYPE_WARLOCK
        || nClass == CLASS_TYPE_DRAGONFIRE_ADEPT
        || nClass == CLASS_TYPE_DRAGON_SHAMAN)
    {
        json ignoreList = GetInvokerShapeSpellList(nClass, oPlayer);
        if (JsonArrayContainsInt(ignoreList, spellId))
            return FALSE;
        ignoreList = GetInvokerEssenceSpellList(nClass, oPlayer);
        if (JsonArrayContainsInt(ignoreList, spellId))
            return FALSE;
    }
    // we don't add stances
    if (nClass == CLASS_TYPE_WARBLADE
        || nClass == CLASS_TYPE_SWORDSAGE
        || nClass == CLASS_TYPE_CRUSADER)
    {
        json ignoreList = GetToBStanceSpellList(nClass, oPlayer);
        if (JsonArrayContainsInt(ignoreList, spellId))
            return FALSE;
    }

    return TRUE;
}

int NUISpellbookGetPreparedStorageRow(int nClass, int nSpellbookID, int nSpellID)
{
    if (nClass != CLASS_TYPE_ARCHIVIST)
        return nSpellbookID;

    int nMasterSpell = StringToInt(Get2DACache("spells", "Master", nSpellID));
    if (nMasterSpell > 0)
    {
        int nMasterRow = SpellToSpellbookID(nMasterSpell);
        if (nMasterRow > 0)
            return nMasterRow;
    }

    return nSpellbookID;
}

void NUISpellbookSetArchivistButtonState(
    object oPlayer,
    int nToken,
    json jEntry,
    int nReady
)
{
    int nSpellbookID = JsonGetInt(JsonObjectGet(jEntry, "b"));
    string sTooltip = JsonGetString(JsonObjectGet(jEntry, "t"));
    string sReadyBind = NUI_SPELLBOOK_ARCHIVIST_VISIBLE_BIND_BASE
                      + IntToString(nSpellbookID);

    NuiSetBind(oPlayer, nToken, sReadyBind, JsonBool(nReady > 0));
    sTooltip += " - Ready copies remaining: " + IntToString(nReady);
    NuiSetBind(
        oPlayer,
        nToken,
        NUI_SPELLBOOK_ARCHIVIST_TOOLTIP_BIND_BASE + IntToString(nSpellbookID),
        JsonString(sTooltip)
    );
}

void NUISpellbookRefreshArchivistButtons(object oPlayer, int nToken)
{
    if (nToken <= 0)
        return;

    json jMap = GetLocalJson(oPlayer, NUI_SPELLBOOK_ARCHIVIST_BUTTON_MAP_VAR);
    if (jMap == JsonNull())
        return;

    string sMemory = "NewSpellbookMem_" + IntToString(CLASS_TYPE_ARCHIVIST);
    int i;
    for (i = 0; i < JsonGetLength(jMap); i++)
    {
        json jEntry = JsonArrayGet(jMap, i);
        int nStorageRow = JsonGetInt(JsonObjectGet(jEntry, "r"));
        int nReady = nStorageRow >= 0
                   ? persistant_array_get_int(oPlayer, sMemory, nStorageRow)
                   : 0;
        NUISpellbookSetArchivistButtonState(oPlayer, nToken, jEntry, nReady);
    }
}

int NUISpellbookArchivistRosterMatchesCurrentMap(
    object oPlayer,
    int nCircle
)
{
    json jMap = GetLocalJson(oPlayer, NUI_SPELLBOOK_ARCHIVIST_BUTTON_MAP_VAR);
    if (jMap == JsonNull())
        return FALSE;

    json jMappedRows = JsonObject();
    int nMappedUnique;
    int i;
    for (i = 0; i < JsonGetLength(jMap); i++)
    {
        int nStorageRow = JsonGetInt(JsonObjectGet(JsonArrayGet(jMap, i), "r"));
        string sStorageRow = IntToString(nStorageRow);
        if (JsonObjectGet(jMappedRows, sStorageRow) == JsonNull())
        {
            jMappedRows = JsonObjectSet(
                jMappedRows,
                sStorageRow,
                JsonBool(TRUE)
            );
            nMappedUnique++;
        }
    }

    string sPreparedIndex = "SpellbookIDX" + IntToString(nCircle) + "_"
                          + IntToString(CLASS_TYPE_ARCHIVIST);
    json jPreparedRows = JsonObject();
    int nPreparedUnique;
    int nPreparedSize = persistant_array_get_size(oPlayer, sPreparedIndex);
    for (i = 0; i < nPreparedSize; i++)
    {
        int nPreparedRow = persistant_array_get_int(
            oPlayer,
            sPreparedIndex,
            i
        );
        string sPreparedRow = IntToString(nPreparedRow);
        if (JsonObjectGet(jPreparedRows, sPreparedRow) == JsonNull())
        {
            jPreparedRows = JsonObjectSet(
                jPreparedRows,
                sPreparedRow,
                JsonBool(TRUE)
            );
            nPreparedUnique++;
        }
    }

    if (nMappedUnique != nPreparedUnique)
        return FALSE;

    // Equal unique counts plus complete membership in the prepared set proves
    // set equality, while tolerating radial children that share one map row.
    for (i = 0; i < JsonGetLength(jMap); i++)
    {
        int nStorageRow = JsonGetInt(JsonObjectGet(JsonArrayGet(jMap, i), "r"));
        if (JsonObjectGet(jPreparedRows, IntToString(nStorageRow)) == JsonNull())
            return FALSE;
    }

    return TRUE;
}

void NUISpellbookRefreshOpenArchivistAfterRest(object oPlayer)
{
    // Resolve the live window at callback time. The player may have opened,
    // closed, or navigated the spellbook while the rest rebuild was settling.
    int nToken = NuiFindWindow(oPlayer, PRC_SPELLBOOK_NUI_WINDOW_ID);
    int nLayoutGeneration = GetLocalInt(
        oPlayer,
        PRC_SPELLBOOK_NUI_REFRESH_GENERATION_VAR
    );
    int nMode = GetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_MODE_VAR);
    int nClass = GetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_CLASSID_VAR);
    if (nToken <= 0
        || nLayoutGeneration <= 0
        || nMode != PRC_SPELLBOOK_MODE_CLASS
        || nClass != CLASS_TYPE_ARCHIVIST)
        return;

    int nNavigationPending = GetLocalInt(
        oPlayer,
        PRC_SPELLBOOK_NUI_NAVIGATION_PENDING_VAR
    );
    int nFenceGeneration = GetLocalInt(
        oPlayer,
        NUI_SPELLBOOK_ARCHIVIST_CAST_FENCE_VAR
    );
    int nCircle = GetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_CIRCLE_VAR);
    if (nNavigationPending || nFenceGeneration)
    {
        return;
    }

    if (nCircle < 0 || nCircle > 9)
    {
        return;
    }

    int bRosterMatches = NUISpellbookArchivistRosterMatchesCurrentMap(
        oPlayer,
        nCircle
    );

    if (bRosterMatches)
    {
        NUISpellbookRefreshArchivistButtons(oPlayer, nToken);
        return;
    }

    // The existing window remains alive: the view replaces only its dynamic
    // root, preserving token, geometry, and position while exposing the new
    // prepared roster exactly once after rest.
    ExecuteScript("prc_nui_sb_view", oPlayer);
}

void NUISpellbookRefreshArchivistStorageRow(
    object oPlayer,
    int nToken,
    int nStorageRow
)
{
    if (nToken <= 0 || nStorageRow < 0)
        return;

    json jMap = GetLocalJson(oPlayer, NUI_SPELLBOOK_ARCHIVIST_BUTTON_MAP_VAR);
    if (jMap == JsonNull())
        return;

    int nReady = persistant_array_get_int(
        oPlayer,
        "NewSpellbookMem_" + IntToString(CLASS_TYPE_ARCHIVIST),
        nStorageRow
    );
    int i;
    for (i = 0; i < JsonGetLength(jMap); i++)
    {
        json jEntry = JsonArrayGet(jMap, i);
        if (JsonGetInt(JsonObjectGet(jEntry, "r")) == nStorageRow)
            NUISpellbookSetArchivistButtonState(oPlayer, nToken, jEntry, nReady);
    }
}

void NUISpellbookApplyArchivistCastUpdate(
    object oPlayer,
    int nToken,
    int nLayoutGeneration,
    int nCircle,
    int nStorageRow
)
{
    if (NuiFindWindow(oPlayer, PRC_SPELLBOOK_NUI_WINDOW_ID) != nToken
        || GetLocalInt(oPlayer, PRC_SPELLBOOK_NUI_REFRESH_GENERATION_VAR) != nLayoutGeneration
        || GetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_MODE_VAR) != PRC_SPELLBOOK_MODE_CLASS
        || GetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_CLASSID_VAR) != CLASS_TYPE_ARCHIVIST
        || GetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_CIRCLE_VAR) != nCircle
        || GetLocalInt(oPlayer, PRC_SPELLBOOK_NUI_NAVIGATION_PENDING_VAR))
        return;

    NUISpellbookRefreshArchivistStorageRow(oPlayer, nToken, nStorageRow);
}

void NUISpellbookReleaseArchivistCastFence(
    object oPlayer,
    int nFenceGeneration,
    int nToken,
    int nLayoutGeneration
)
{
    // A newer cast owns the fence now; this delayed callback is stale.
    if (GetLocalInt(oPlayer, NUI_SPELLBOOK_ARCHIVIST_CAST_FENCE_VAR)
        != nFenceGeneration)
        return;

    int bNavigationPending = GetLocalInt(
        oPlayer,
        PRC_SPELLBOOK_NUI_NAVIGATION_PENDING_VAR
    );
    int nLiveToken = NuiFindWindow(oPlayer, PRC_SPELLBOOK_NUI_WINDOW_ID);
    int nLiveLayoutGeneration = GetLocalInt(
        oPlayer,
        PRC_SPELLBOOK_NUI_REFRESH_GENERATION_VAR
    );

    DeleteLocalInt(oPlayer, NUI_SPELLBOOK_ARCHIVIST_CAST_FENCE_VAR);

    if (!bNavigationPending)
    {
        if (GetLocalInt(oPlayer, PRC_SPELLBOOK_NUI_INPUT_LOCK_VAR)
            == nLayoutGeneration)
            DeleteLocalInt(oPlayer, PRC_SPELLBOOK_NUI_INPUT_LOCK_VAR);
        return;
    }

    DeleteLocalInt(oPlayer, PRC_SPELLBOOK_NUI_NAVIGATION_PENDING_VAR);

    // Closing or independently replacing the window invalidates the deferred
    // navigation. Do not let this callback disturb the successor's input lock.
    if (nLiveToken != nToken
        || nLiveLayoutGeneration != nLayoutGeneration)
    {
        if (GetLocalInt(oPlayer, PRC_SPELLBOOK_NUI_INPUT_LOCK_VAR)
            == nLayoutGeneration)
            DeleteLocalInt(oPlayer, PRC_SPELLBOOK_NUI_INPUT_LOCK_VAR);
        return;
    }

    // The selected mode/class/circle locals were updated by every navigation
    // click while fenced, so this single render naturally uses the last one.
    ExecuteScript("prc_nui_sb_view", oPlayer);
}

void NUISpellbookSettleArchivistCastResult(
    object oPlayer,
    int nFenceGeneration,
    int nToken,
    int nLayoutGeneration,
    int nStorageRow
)
{
    if (GetLocalInt(oPlayer, NUI_SPELLBOOK_ARCHIVIST_CAST_FENCE_VAR)
            != nFenceGeneration
        || NuiFindWindow(oPlayer, PRC_SPELLBOOK_NUI_WINDOW_ID) != nToken
        || GetLocalInt(oPlayer, PRC_SPELLBOOK_NUI_REFRESH_GENERATION_VAR)
            != nLayoutGeneration)
        return;

    // The physical root is still the captured Archivist tier even when the
    // selected locals already name a deferred destination.
    NUISpellbookRefreshArchivistStorageRow(oPlayer, nToken, nStorageRow);
}

void NUISpellbookPollArchivistCast(
    object oPlayer,
    int nToken,
    int nLayoutGeneration,
    int nCircle,
    int nStorageRow,
    int nLastReady,
    int nWatchGeneration,
    int nFenceGeneration,
    int nAttemptsRemaining
)
{
    string sWatchVar = NUI_SPELLBOOK_ARCHIVIST_CAST_WATCH_BASE
                     + IntToString(nStorageRow);
    if (GetLocalInt(oPlayer, sWatchVar) != nWatchGeneration)
        return;

    int bNavigationPending = GetLocalInt(
        oPlayer,
        PRC_SPELLBOOK_NUI_NAVIGATION_PENDING_VAR
    );
    int bLiveLayout = NuiFindWindow(oPlayer, PRC_SPELLBOOK_NUI_WINDOW_ID) == nToken
        && GetLocalInt(oPlayer, PRC_SPELLBOOK_NUI_REFRESH_GENERATION_VAR)
            == nLayoutGeneration;
    int bStillOnCastTier = GetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_MODE_VAR)
            == PRC_SPELLBOOK_MODE_CLASS
        && GetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_CLASSID_VAR)
            == CLASS_TYPE_ARCHIVIST
        && GetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_CIRCLE_VAR) == nCircle;

    // A requested destination is allowed to differ from the cast tier while
    // the old root remains live. Otherwise, an independently replaced layout,
    // a closed window, or the hard timeout ends this finite fence safely.
    if (nAttemptsRemaining <= 0
        || !bLiveLayout
        || (!bNavigationPending && !bStillOnCastTier))
    {
        DelayCommand(0.10f, NUISpellbookReleaseArchivistCastFence(
            oPlayer,
            nFenceGeneration,
            nToken,
            nLayoutGeneration
        ));
        return;
    }

    int nReady = persistant_array_get_int(
        oPlayer,
        "NewSpellbookMem_" + IntToString(CLASS_TYPE_ARCHIVIST),
        nStorageRow
    );
    if (nReady != nLastReady)
    {
        // The persistent ready-count transition is the authoritative signal
        // that this queued ActionUseFeat has resolved. Navigation can now win;
        // staying on the tier keeps the stable root and refreshes only its row.
        if (GetLocalInt(oPlayer, NUI_SPELLBOOK_ARCHIVIST_CAST_FENCE_VAR)
            == nFenceGeneration)
        {
            // Preserve the old root through the same settling gap used by the
            // stable stay-on-tier path. Apply its captured row first, then make
            // the one deferred render (if any) after the bind has settled.
            DelayCommand(0.40f, NUISpellbookSettleArchivistCastResult(
                oPlayer,
                nFenceGeneration,
                nToken,
                nLayoutGeneration,
                nStorageRow
            ));
            DelayCommand(0.45f, NUISpellbookReleaseArchivistCastFence(
                oPlayer,
                nFenceGeneration,
                nToken,
                nLayoutGeneration
            ));
        }
        else if (!bNavigationPending)
        {
            // A newer fence owns navigation; this older row may still update
            // in place without releasing or unlocking the newer cast.
            DelayCommand(0.40f, NUISpellbookApplyArchivistCastUpdate(
                oPlayer,
                nToken,
                nLayoutGeneration,
                nCircle,
                nStorageRow
            ));
        }
        return;
    }

    DelayCommand(0.25f, NUISpellbookPollArchivistCast(
        oPlayer,
        nToken,
        nLayoutGeneration,
        nCircle,
        nStorageRow,
        nLastReady,
        nWatchGeneration,
        nFenceGeneration,
        nAttemptsRemaining - 1
    ));
}

void NUISpellbookStartArchivistCastWatch(
    object oPlayer,
    int nSpell,
    int nStorageRow,
    int nCircle,
    int nInitialReady
)
{
    int nToken = NuiFindWindow(oPlayer, PRC_SPELLBOOK_NUI_WINDOW_ID);
    int nLayoutGeneration = GetLocalInt(
        oPlayer,
        PRC_SPELLBOOK_NUI_REFRESH_GENERATION_VAR
    );
    if (nToken <= 0 || nLayoutGeneration <= 0 || nStorageRow < 0)
        return;

    string sWatchVar = NUI_SPELLBOOK_ARCHIVIST_CAST_WATCH_BASE
                     + IntToString(nStorageRow);
    int nWatchGeneration = GetLocalInt(oPlayer, sWatchVar) + 1;
    if (nWatchGeneration <= 0)
        nWatchGeneration = 1;
    SetLocalInt(oPlayer, sWatchVar, nWatchGeneration);

    int nFenceGeneration = GetLocalInt(
        oPlayer,
        NUI_SPELLBOOK_ARCHIVIST_CAST_GENERATION_VAR
    ) + 1;
    if (nFenceGeneration <= 0)
        nFenceGeneration = 1;
    SetLocalInt(
        oPlayer,
        NUI_SPELLBOOK_ARCHIVIST_CAST_GENERATION_VAR,
        nFenceGeneration
    );
    SetLocalInt(
        oPlayer,
        NUI_SPELLBOOK_ARCHIVIST_CAST_FENCE_VAR,
        nFenceGeneration
    );

    // Permit tier/class/mode navigation, but reject another generated cast
    // button until this ActionUseFeat has resolved or the bounded fallback fires.
    SetLocalInt(
        oPlayer,
        PRC_SPELLBOOK_NUI_INPUT_LOCK_VAR,
        nLayoutGeneration
    );

    // This is deliberately finite rather than a permanent spellbook refresh:
    // 48 checks at 0.25 seconds gives the queued cast up to 12 seconds to
    // resolve. A failed/interrupted cast then releases the UI without rebuilding
    // it unless navigation was explicitly requested.
    DelayCommand(0.25f, NUISpellbookPollArchivistCast(
        oPlayer,
        nToken,
        nLayoutGeneration,
        nCircle,
        nStorageRow,
        nInitialReady,
        nWatchGeneration,
        nFenceGeneration,
        48
    ));
}

json GetSupportedNUISpellbookClasses(object oPlayer)
{
    json retValue = JsonArray();
    int i = 1;
    while(i >= 1)
    {
        int classId = GetClassByPosition(i, oPlayer);
        if (classId != CLASS_TYPE_INVALID)
        {
            if (IsClassAllowedToUseNUISpellbook(oPlayer, classId))
            {
                classId = GetTrueClassIfRHD(oPlayer, classId);
                retValue = JsonArrayInsert(retValue, JsonInt(classId));
            }
            i++;
        }
        else
        {
            i = -1;
        }
    }

    return retValue;
}

int IsSpellKnown(object oPlayer, int nClass, int spellId)
{
    // special case for Binders since they don't have a spell book 2da.
    if (nClass == CLASS_TYPE_BINDER)
    {
        return IsBinderSpellActive(oPlayer, spellId);
    }

    int currentSpell = spellId;
    int masterSpell = StringToInt(Get2DACache("spells", "Master", currentSpell));
        if (masterSpell) // If this is not 0 then this is a radial spell, check the radial master
            currentSpell = masterSpell;

    string sFeatID = Get2DACache("spells", "FeatID", currentSpell);
    int iFeatID = StringToInt(sFeatID);

    if (IntToString(iFeatID) == sFeatID)
        return GetHasFeat(iFeatID, oPlayer);

    return FALSE;
}

int IsClassAllowedToUseNUISpellbook(object oPlayer, int nClass)
{
    // This controls who can use the Spellbook NUI, if for some reason you don't
    // want a class to be allowed to use this you can comment out their line here

    // Native prepared casters and native restricted spontaneous casters are
    // data-driven. PRC new-spellbook arrays deliberately remain on the legacy
    // route below.
    if (NUISpellbookUsesNativeClassAdapter(oPlayer, nClass))
        return TRUE;

    // Bard and Sorc are allowed if they took a PRC that makes them use the spellbook
    if ((nClass == CLASS_TYPE_BARD || nClass == CLASS_TYPE_SORCERER)
         && GetPrCAdjustedClassLevel(nClass, oPlayer) > GetLevelByClass(nClass, oPlayer))
         return TRUE;

    // Arcane Spont
    if (nClass == CLASS_TYPE_BEGUILER
        || nClass == CLASS_TYPE_CELEBRANT_SHARESS
        || nClass == CLASS_TYPE_DREAD_NECROMANCER
        || nClass == CLASS_TYPE_DUSKBLADE
        || nClass == CLASS_TYPE_HARPER
        || nClass == CLASS_TYPE_HEXBLADE
        || nClass == CLASS_TYPE_KNIGHT_WEAVE
        || nClass == CLASS_TYPE_SHADOWLORD
        || nClass == CLASS_TYPE_SUBLIME_CHORD
        || nClass == CLASS_TYPE_SUEL_ARCHANAMACH
        || nClass == CLASS_TYPE_WARMAGE)
        return TRUE;

    // Psionics
    if  (nClass == CLASS_TYPE_FIST_OF_ZUOKEN
        || nClass == CLASS_TYPE_PSION
        || nClass == CLASS_TYPE_PSYWAR
        || nClass == CLASS_TYPE_WILDER
        || nClass == CLASS_TYPE_PSYCHIC_ROGUE
        || nClass == CLASS_TYPE_WARMIND)
        return TRUE;

    // Invokers
    if (nClass == CLASS_TYPE_WARLOCK
        || nClass == CLASS_TYPE_DRAGON_SHAMAN
        || nClass == CLASS_TYPE_DRAGONFIRE_ADEPT)
        return TRUE;

    // Divine Spont
    if (nClass == CLASS_TYPE_ARCHIVIST //while technically prepared, they use the spont system of casting
        || nClass == CLASS_TYPE_FAVOURED_SOUL
        || nClass == CLASS_TYPE_JUSTICEWW)
        return TRUE;

    // ToB Classes
    if (nClass == CLASS_TYPE_WARBLADE
        || nClass == CLASS_TYPE_SWORDSAGE
        || nClass == CLASS_TYPE_CRUSADER)
        return TRUE;

    // Mystery Classes
    if (nClass == CLASS_TYPE_SHADOWCASTER
        || nClass == CLASS_TYPE_SHADOWSMITH)
        return TRUE;

    // Truenamers
    if (nClass == CLASS_TYPE_TRUENAMER)
         return TRUE;

    // RHD Casters
    if ((nClass == CLASS_TYPE_SHAPECHANGER
                && GetRacialType(oPlayer) == RACIAL_TYPE_ARANEA
                && !GetLevelByClass(CLASS_TYPE_SORCERER))
         || (nClass == CLASS_TYPE_OUTSIDER
                && GetRacialType(oPlayer) == RACIAL_TYPE_RAKSHASA
                && !GetLevelByClass(CLASS_TYPE_SORCERER))
         || (nClass == CLASS_TYPE_ABERRATION
                && GetRacialType(oPlayer) == RACIAL_TYPE_DRIDER
                && !GetLevelByClass(CLASS_TYPE_SORCERER))
         || (nClass == CLASS_TYPE_MONSTROUS
                && GetRacialType(oPlayer) == RACIAL_TYPE_ARKAMOI
                && !GetLevelByClass(CLASS_TYPE_SORCERER))
         || (nClass == CLASS_TYPE_MONSTROUS
                && GetRacialType(oPlayer) == RACIAL_TYPE_HOBGOBLIN_WARSOUL
                && !GetLevelByClass(CLASS_TYPE_SORCERER))
         || (nClass == CLASS_TYPE_MONSTROUS
                && GetRacialType(oPlayer) == RACIAL_TYPE_REDSPAWN_ARCANISS
                && !GetLevelByClass(CLASS_TYPE_SORCERER))
         || (nClass == CLASS_TYPE_MONSTROUS
                && GetRacialType(oPlayer) == RACIAL_TYPE_MARRUTACT
                && !GetLevelByClass(CLASS_TYPE_SORCERER))
         || (nClass == CLASS_TYPE_FEY
                && GetRacialType(oPlayer) == RACIAL_TYPE_GLOURA
                && !GetLevelByClass(CLASS_TYPE_BARD)))
         return TRUE;

    // Binders
    if (nClass == CLASS_TYPE_BINDER)
        return TRUE;

    return FALSE;
}

int GetTrueClassIfRHD(object oPlayer, int nClass)
{
    if (nClass == CLASS_TYPE_SHAPECHANGER
            && GetRacialType(oPlayer) == RACIAL_TYPE_ARANEA)
        return CLASS_TYPE_SORCERER;
    if (nClass == CLASS_TYPE_OUTSIDER
            && GetRacialType(oPlayer) == RACIAL_TYPE_RAKSHASA)
        return CLASS_TYPE_SORCERER;
    if (nClass == CLASS_TYPE_ABERRATION
            && GetRacialType(oPlayer) == RACIAL_TYPE_DRIDER)
        return CLASS_TYPE_SORCERER;
    if (nClass == CLASS_TYPE_MONSTROUS
            && GetRacialType(oPlayer) == RACIAL_TYPE_ARKAMOI)
        return CLASS_TYPE_SORCERER;
    if (nClass == CLASS_TYPE_MONSTROUS
            && GetRacialType(oPlayer) == RACIAL_TYPE_HOBGOBLIN_WARSOUL)
        return CLASS_TYPE_SORCERER;
    if (nClass == CLASS_TYPE_MONSTROUS
            && GetRacialType(oPlayer) == RACIAL_TYPE_REDSPAWN_ARCANISS)
        return CLASS_TYPE_SORCERER;
    if (nClass == CLASS_TYPE_MONSTROUS
            && GetRacialType(oPlayer) == RACIAL_TYPE_MARRUTACT)
        return CLASS_TYPE_SORCERER;
    if (nClass == CLASS_TYPE_FEY
            && GetRacialType(oPlayer) == RACIAL_TYPE_GLOURA)
        return CLASS_TYPE_BARD;

    return nClass;
}

int CanClassUseMetamagicFeats(int nClass)
{
    // I don't want to spend the time looping through each class's
    // feat 2da so this is the list of all classes that are allowed to use the
    // Spellbook NUI and can use Metamagic
    return (nClass == CLASS_TYPE_BARD
        || nClass == CLASS_TYPE_SORCERER
        || nClass == CLASS_TYPE_BEGUILER
        || nClass == CLASS_TYPE_DREAD_NECROMANCER
        || nClass == CLASS_TYPE_DUSKBLADE
        || nClass == CLASS_TYPE_HEXBLADE
        || nClass == CLASS_TYPE_JUSTICEWW
        || nClass == CLASS_TYPE_SUBLIME_CHORD
        || nClass == CLASS_TYPE_SUEL_ARCHANAMACH
        || nClass == CLASS_TYPE_FAVOURED_SOUL
        || nClass == CLASS_TYPE_WARMAGE);
}

int CanClassUseSuddenMetamagicFeats(int nClass)
{
    // I don't want to spend the time looping through each class's
    // feat 2da so this is the list of all classes that are allowed to use the
    // Spellbook NUI and can use Sudden Metamagic
    return (nClass == CLASS_TYPE_SHADOWLORD
        || nClass == CLASS_TYPE_ARCHIVIST
        || nClass == CLASS_TYPE_BARD
        || nClass == CLASS_TYPE_BEGUILER
        || nClass == CLASS_TYPE_DREAD_NECROMANCER
        || nClass == CLASS_TYPE_DUSKBLADE
        || nClass == CLASS_TYPE_FAVOURED_SOUL
        || nClass == CLASS_TYPE_HEXBLADE
        || nClass == CLASS_TYPE_JUSTICEWW
        || nClass == CLASS_TYPE_KNIGHT_WEAVE
        || nClass == CLASS_TYPE_SUBLIME_CHORD
        || nClass == CLASS_TYPE_SORCERER
        || nClass == CLASS_TYPE_SUEL_ARCHANAMACH
        || nClass == CLASS_TYPE_WARMAGE);
}

int CanClassUseMetaPsionicFeats(int nClass)
{
    // I don't want to spend the time looping through each class's
    // feat 2da so this is the list of all classes that are allowed to use the
    // Spellbook NUI and can use Metapsionics
    return (nClass == CLASS_TYPE_FIST_OF_ZUOKEN
        || nClass == CLASS_TYPE_PSION
        || nClass == CLASS_TYPE_PSYCHIC_ROGUE
        || nClass == CLASS_TYPE_PSYWAR
        || nClass == CLASS_TYPE_WARMIND
        || nClass == CLASS_TYPE_WILDER);
}

int CanClassUseMetaMysteryFeats(int nClass)
{
    // I don't want to spend the time looping through each class's
    // feat 2da so this is the list of all classes that are allowed to use the
    // Spellbook NUI and can use Metamysteries
    return (nClass == CLASS_TYPE_SHADOWCASTER
        || nClass == CLASS_TYPE_SHADOWSMITH);
}

json GetMetaMagicFeatList()
{
    json metaFeats = JsonArray();
    int spellId = StringToInt(Get2DACache("feat", "SPELLID", FEAT_EXTEND_SPELL_ABILITY));
    metaFeats = JsonArrayInsert(metaFeats, JsonInt(spellId));
    spellId = StringToInt(Get2DACache("feat", "SPELLID", FEAT_EMPOWER_SPELL_ABILITY));
    metaFeats = JsonArrayInsert(metaFeats, JsonInt(spellId));
    spellId = StringToInt(Get2DACache("feat", "SPELLID", FEAT_MAXIMIZE_SPELL_ABILITY));
    metaFeats = JsonArrayInsert(metaFeats, JsonInt(spellId));
    spellId = StringToInt(Get2DACache("feat", "SPELLID", FEAT_QUICKEN_SPELL_ABILITY));
    metaFeats = JsonArrayInsert(metaFeats, JsonInt(spellId));
    spellId = StringToInt(Get2DACache("feat", "SPELLID", FEAT_STILL_SPELL_ABILITY));
    metaFeats = JsonArrayInsert(metaFeats, JsonInt(spellId));
    spellId = StringToInt(Get2DACache("feat", "SPELLID", FEAT_SILENT_SPELL_ABILITY));
    metaFeats = JsonArrayInsert(metaFeats, JsonInt(spellId));

    return metaFeats;
}

json GetSuddenMetaMagicFeatList()
{
    json metaFeats = JsonArray();
    int spellId = StringToInt(Get2DACache("feat", "SPELLID", FEAT_SUDDEN_EXTEND));
    metaFeats = JsonArrayInsert(metaFeats, JsonInt(spellId));
    spellId = StringToInt(Get2DACache("feat", "SPELLID", FEAT_SUDDEN_EMPOWER));
    metaFeats = JsonArrayInsert(metaFeats, JsonInt(spellId));
    spellId = StringToInt(Get2DACache("feat", "SPELLID", FEAT_SUDDEN_MAXIMIZE));
    metaFeats = JsonArrayInsert(metaFeats, JsonInt(spellId));
    spellId = StringToInt(Get2DACache("feat", "SPELLID", FEAT_SUDDEN_WIDEN));
    metaFeats = JsonArrayInsert(metaFeats, JsonInt(spellId));

    return metaFeats;
}

json GetMetaPsionicFeatList()
{
    json metaFeats = JsonArray();
    int spellId = StringToInt(Get2DACache("feat", "SPELLID", FEAT_EXTEND_POWER));
    metaFeats = JsonArrayInsert(metaFeats, JsonInt(spellId));
    spellId = StringToInt(Get2DACache("feat", "SPELLID", FEAT_EMPOWER_POWER));
    metaFeats = JsonArrayInsert(metaFeats, JsonInt(spellId));
    spellId = StringToInt(Get2DACache("feat", "SPELLID", FEAT_MAXIMIZE_POWER));
    metaFeats = JsonArrayInsert(metaFeats, JsonInt(spellId));
    spellId = StringToInt(Get2DACache("feat", "SPELLID", FEAT_QUICKEN_POWER));
    metaFeats = JsonArrayInsert(metaFeats, JsonInt(spellId));
    spellId = StringToInt(Get2DACache("feat", "SPELLID", FEAT_WIDEN_POWER));
    metaFeats = JsonArrayInsert(metaFeats, JsonInt(spellId));
    spellId = StringToInt(Get2DACache("feat", "SPELLID", FEAT_CHAIN_POWER));
    metaFeats = JsonArrayInsert(metaFeats, JsonInt(spellId));
    spellId = StringToInt(Get2DACache("feat", "SPELLID", FEAT_TWIN_POWER));
    metaFeats = JsonArrayInsert(metaFeats, JsonInt(spellId));
    spellId = StringToInt(Get2DACache("feat", "SPELLID", FEAT_SPLIT_PSIONIC_RAY));
    metaFeats = JsonArrayInsert(metaFeats, JsonInt(spellId));
    spellId = StringToInt(Get2DACache("feat", "SPELLID", FEAT_GREATER_PSIONIC_ENDOWMENT));
    metaFeats = JsonArrayInsert(metaFeats, JsonInt(spellId));

    return metaFeats;
}

json GetMetaMysteryFeatList()
{
    json metaFeats = JsonArray();
    int spellId = StringToInt(Get2DACache("feat", "SPELLID", FEAT_EXTEND_MYSTERY));
    metaFeats = JsonArrayInsert(metaFeats, JsonInt(spellId));
    spellId = StringToInt(Get2DACache("feat", "SPELLID", FEAT_EMPOWER_MYSTERY));
    metaFeats = JsonArrayInsert(metaFeats, JsonInt(spellId));
    spellId = StringToInt(Get2DACache("feat", "SPELLID", FEAT_MAXIMIZE_MYSTERY));
    metaFeats = JsonArrayInsert(metaFeats, JsonInt(spellId));
    spellId = StringToInt(Get2DACache("feat", "SPELLID", FEAT_QUICKEN_MYSTERY));
    metaFeats = JsonArrayInsert(metaFeats, JsonInt(spellId));
    spellId = StringToInt(Get2DACache("feat", "SPELLID", FEAT_STILL_MYSTERY));
    metaFeats = JsonArrayInsert(metaFeats, JsonInt(spellId));

    return metaFeats;
}

json GetToBStanceSpellList(int nClass, object oPlayer=OBJECT_SELF)
{
    // caching
    json stanceSpells = GetLocalJson(oPlayer, NUI_SPELLBOOK_CLASS_STANCES_CACHE_BASE_VAR + IntToString(nClass));
    if (stanceSpells == JsonNull())
        stanceSpells = JsonArray();
    else
        return stanceSpells;

    string sFile = GetClassSpellbookFile(nClass);
    int totalRows = Get2DARowCount(sFile);

    int i;
    for (i = 0; i < totalRows; i++)
    {
        int Type = StringToInt(Get2DACache(sFile, "Type", i));
        if (Type == 1)
        {
            int spellId = StringToInt(Get2DACache(sFile, "SpellID", i));
            stanceSpells = JsonArrayInsert(stanceSpells, JsonInt(spellId));
        }
    }

    SetLocalJson(oPlayer, NUI_SPELLBOOK_CLASS_STANCES_CACHE_BASE_VAR + IntToString(nClass), stanceSpells);
    return stanceSpells;
}

json GetInvokerShapeSpellList(int nClass, object oPlayer=OBJECT_SELF)
{
    // caching
    json shapeSpells = GetLocalJson(oPlayer, NUI_SPELLBOOK_CLASS_SHAPES_CACHE_BASE_VAR + IntToString(nClass));
    if (shapeSpells == JsonNull())
        shapeSpells = JsonArray();
    else
        return shapeSpells;

    string sFile = GetClassSpellbookFile(nClass);
    int totalRows = Get2DARowCount(sFile);

    if (nClass == CLASS_TYPE_WARLOCK)
    {
        // Add the ELdritch Blast shapes
        // TODO: Replace these magic SpellID ints with consts
        shapeSpells = JsonArrayInsert(shapeSpells, JsonInt(INVOKE_ELDRITCH_BLAST));
        shapeSpells = JsonArrayInsert(shapeSpells, JsonInt(18216)); // Eldritch Chain
        shapeSpells = JsonArrayInsert(shapeSpells, JsonInt(18245)); // Eldritch Cone
        shapeSpells = JsonArrayInsert(shapeSpells, JsonInt(18261)); // Eldritch Doom
        shapeSpells = JsonArrayInsert(shapeSpells, JsonInt(18172)); // Glaive
        shapeSpells = JsonArrayInsert(shapeSpells, JsonInt(18246)); // Eldritch Line
        shapeSpells = JsonArrayInsert(shapeSpells, JsonInt(18173)); // Eldritch Spear
    }

    if (nClass == CLASS_TYPE_DRAGON_SHAMAN)
    {
        // Add the Dragon Shaman Auras
        int spellId = StringToInt(Get2DACache("feat", "SPELLID", FEAT_DRAGONSHAMAN_AURA_ENERGY));
        shapeSpells = JsonArrayInsert(shapeSpells, JsonInt(spellId));
        spellId = StringToInt(Get2DACache("feat", "SPELLID", FEAT_DRAGONSHAMAN_AURA_ENERGYSHLD));
        shapeSpells = JsonArrayInsert(shapeSpells, JsonInt(spellId));
        spellId = StringToInt(Get2DACache("feat", "SPELLID", FEAT_DRAGONSHAMAN_AURA_INSIGHT));
        shapeSpells = JsonArrayInsert(shapeSpells, JsonInt(spellId));
        spellId = StringToInt(Get2DACache("feat", "SPELLID", FEAT_DRAGONSHAMAN_AURA_MAGICPOWER));
        shapeSpells = JsonArrayInsert(shapeSpells, JsonInt(spellId));
        spellId = StringToInt(Get2DACache("feat", "SPELLID", FEAT_DRAGONSHAMAN_AURA_POWER));
        shapeSpells = JsonArrayInsert(shapeSpells, JsonInt(spellId));
        spellId = StringToInt(Get2DACache("feat", "SPELLID", FEAT_DRAGONSHAMAN_AURA_PRESENCE));
        shapeSpells = JsonArrayInsert(shapeSpells, JsonInt(spellId));
        spellId = StringToInt(Get2DACache("feat", "SPELLID", FEAT_DRAGONSHAMAN_AURA_RESISTANCE));
        shapeSpells = JsonArrayInsert(shapeSpells, JsonInt(spellId));
        spellId = StringToInt(Get2DACache("feat", "SPELLID", FEAT_DRAGONSHAMAN_AURA_RESOLVE));
        shapeSpells = JsonArrayInsert(shapeSpells, JsonInt(spellId));
        spellId = StringToInt(Get2DACache("feat", "SPELLID", FEAT_DRAGONSHAMAN_AURA_SENSES));
        shapeSpells = JsonArrayInsert(shapeSpells, JsonInt(spellId));
        spellId = StringToInt(Get2DACache("feat", "SPELLID", FEAT_DRAGONSHAMAN_AURA_STAMINA));
        shapeSpells = JsonArrayInsert(shapeSpells, JsonInt(spellId));
        spellId = StringToInt(Get2DACache("feat", "SPELLID", FEAT_DRAGONSHAMAN_AURA_SWIFTNESS));
        shapeSpells = JsonArrayInsert(shapeSpells, JsonInt(spellId));
        spellId = StringToInt(Get2DACache("feat", "SPELLID", FEAT_DRAGONSHAMAN_AURA_TOUGHNESS));
        shapeSpells = JsonArrayInsert(shapeSpells, JsonInt(spellId));
        spellId = StringToInt(Get2DACache("feat", "SPELLID", FEAT_DRAGONSHAMAN_AURA_VIGOR));
        shapeSpells = JsonArrayInsert(shapeSpells, JsonInt(spellId));
    }

    if (nClass == CLASS_TYPE_DRAGONFIRE_ADEPT)
    {
        // Add Dragon Adept Breaths
        // TODO: Replace these magic SpellID ints with consts
        shapeSpells = JsonArrayInsert(shapeSpells, JsonInt(2102)); // Fire Cone
        shapeSpells = JsonArrayInsert(shapeSpells, JsonInt(2103)); // Fire Line
        shapeSpells = JsonArrayInsert(shapeSpells, JsonInt(2104)); // Frost Cone
        shapeSpells = JsonArrayInsert(shapeSpells, JsonInt(2105)); // Electric Line
        shapeSpells = JsonArrayInsert(shapeSpells, JsonInt(2106)); // Sickness Cone
        shapeSpells = JsonArrayInsert(shapeSpells, JsonInt(2108)); // Acid Cone
        shapeSpells = JsonArrayInsert(shapeSpells, JsonInt(2109)); // Acid Line
        shapeSpells = JsonArrayInsert(shapeSpells, JsonInt(2111)); // Slow Cone
        shapeSpells = JsonArrayInsert(shapeSpells, JsonInt(2112)); // Weakening Cone
        shapeSpells = JsonArrayInsert(shapeSpells, JsonInt(2115)); // Sleep Cone
        shapeSpells = JsonArrayInsert(shapeSpells, JsonInt(2116)); // Thunder Cone
        shapeSpells = JsonArrayInsert(shapeSpells, JsonInt(2117)); // Bahamut Line
        shapeSpells = JsonArrayInsert(shapeSpells, JsonInt(2118)); // Force Line
        shapeSpells = JsonArrayInsert(shapeSpells, JsonInt(2119)); // Paralyzation Line
        shapeSpells = JsonArrayInsert(shapeSpells, JsonInt(2120)); // Tiamat Breath
    }


    SetLocalJson(oPlayer, NUI_SPELLBOOK_CLASS_SHAPES_CACHE_BASE_VAR + IntToString(nClass), shapeSpells);
    return shapeSpells;
}

json GetInvokerEssenceSpellList(int nClass, object oPlayer=OBJECT_SELF)
{
    //caching
    json essenceSpells = GetLocalJson(oPlayer, NUI_SPELLBOOK_CLASS_ESSENCE_CACHE_BASE_VAR + IntToString(nClass));
    if (essenceSpells == JsonNull())
        essenceSpells = JsonArray();
    else
        return essenceSpells;

    if (nClass == CLASS_TYPE_WARLOCK)
    {
        // Add Eldritch Essences
        // TODO: Replace these magic SpellID ints with consts
        essenceSpells = JsonArrayInsert(essenceSpells, JsonInt(18177)); // Hideous Blow
        essenceSpells = JsonArrayInsert(essenceSpells, JsonInt(18189)); // Baneful Abberation
        essenceSpells = JsonArrayInsert(essenceSpells, JsonInt(18190)); // Baneful Beast
        essenceSpells = JsonArrayInsert(essenceSpells, JsonInt(18191)); // Baneful Construct
        essenceSpells = JsonArrayInsert(essenceSpells, JsonInt(18192)); // Baneful Dragon
        essenceSpells = JsonArrayInsert(essenceSpells, JsonInt(18193)); // Baneful Dwarf
        essenceSpells = JsonArrayInsert(essenceSpells, JsonInt(18194)); // Baneful Elemental
        essenceSpells = JsonArrayInsert(essenceSpells, JsonInt(18195)); // Baneful Elf
        essenceSpells = JsonArrayInsert(essenceSpells, JsonInt(18196)); // baneful Fey
        essenceSpells = JsonArrayInsert(essenceSpells, JsonInt(18197)); // Baneful Giant
        essenceSpells = JsonArrayInsert(essenceSpells, JsonInt(18198)); // Baneful Goblinoid
        essenceSpells = JsonArrayInsert(essenceSpells, JsonInt(18199)); // Baneful Gnome
        essenceSpells = JsonArrayInsert(essenceSpells, JsonInt(18200)); // Baneful Halfling
        essenceSpells = JsonArrayInsert(essenceSpells, JsonInt(18201)); // Baneful Human
        essenceSpells = JsonArrayInsert(essenceSpells, JsonInt(18202)); // Baneful Monsterous
        essenceSpells = JsonArrayInsert(essenceSpells, JsonInt(18203)); // Baneful Orc
        essenceSpells = JsonArrayInsert(essenceSpells, JsonInt(18204)); // Baneful Outsider
        essenceSpells = JsonArrayInsert(essenceSpells, JsonInt(18205)); // Baneful Plant
        essenceSpells = JsonArrayInsert(essenceSpells, JsonInt(18206)); // Baneful Reptilian
        essenceSpells = JsonArrayInsert(essenceSpells, JsonInt(18207)); // Baneful Shapechanger
        essenceSpells = JsonArrayInsert(essenceSpells, JsonInt(18208)); // Baneful Undead
        essenceSpells = JsonArrayInsert(essenceSpells, JsonInt(18209)); // Baneful Vermin
        essenceSpells = JsonArrayInsert(essenceSpells, JsonInt(18210)); // Beshadowed Blast
        essenceSpells = JsonArrayInsert(essenceSpells, JsonInt(18240)); // Bewitching Blast
        essenceSpells = JsonArrayInsert(essenceSpells, JsonInt(18257)); // Binding Blast
        essenceSpells = JsonArrayInsert(essenceSpells, JsonInt(18211)); // Brimstone Blast
        essenceSpells = JsonArrayInsert(essenceSpells, JsonInt(18175)); // Frightful Blast
        essenceSpells = JsonArrayInsert(essenceSpells, JsonInt(18176)); // Hammer Blast
        essenceSpells = JsonArrayInsert(essenceSpells, JsonInt(18183)); // Sickening Blast
        essenceSpells = JsonArrayInsert(essenceSpells, JsonInt(INVOKE_HEALING_BLAST));
        essenceSpells = JsonArrayInsert(essenceSpells, JsonInt(INVOKE_HELLFIRE_BLAST));
        essenceSpells = JsonArrayInsert(essenceSpells, JsonInt(INVOKE_HELLFIRE_BLOW));
        essenceSpells = JsonArrayInsert(essenceSpells, JsonInt(INVOKE_HELLFIRE_CHAIN));
        essenceSpells = JsonArrayInsert(essenceSpells, JsonInt(INVOKE_HELLFIRE_CONE));
        essenceSpells = JsonArrayInsert(essenceSpells, JsonInt(INVOKE_HELLFIRE_DOOM));
        essenceSpells = JsonArrayInsert(essenceSpells, JsonInt(INVOKE_HELLFIRE_GLAIVE));
        essenceSpells = JsonArrayInsert(essenceSpells, JsonInt(INVOKE_HELLFIRE_LINE));
        essenceSpells = JsonArrayInsert(essenceSpells, JsonInt(INVOKE_HELLFIRE_SPEAR));
        essenceSpells = JsonArrayInsert(essenceSpells, JsonInt(18220)); // Hellrime Blast
        essenceSpells = JsonArrayInsert(essenceSpells, JsonInt(18177)); // Hideous Blow
        essenceSpells = JsonArrayInsert(essenceSpells, JsonInt(18249)); // Hindering Blast
        essenceSpells = JsonArrayInsert(essenceSpells, JsonInt(18251)); // Noxious Blast
        essenceSpells = JsonArrayInsert(essenceSpells, JsonInt(18253)); // Penetrating Blast
        essenceSpells = JsonArrayInsert(essenceSpells, JsonInt(18267)); // Utterdark Blast
        essenceSpells = JsonArrayInsert(essenceSpells, JsonInt(18255)); // Vitriolic Blast
    }

    if (nClass == CLASS_TYPE_DRAGONFIRE_ADEPT)
    {
        // Add the Dragonfire Adept Shapes
        int spellId = StringToInt(Get2DACache("feat", "SPELLID", FEAT_SHAPED_ADEPTBREATH));
        essenceSpells = JsonArrayInsert(essenceSpells, JsonInt(spellId));
        spellId = StringToInt(Get2DACache("feat", "SPELLID", FEAT_CLOUD_ADEPTBREATH));
        essenceSpells = JsonArrayInsert(essenceSpells, JsonInt(spellId));
        spellId = StringToInt(Get2DACache("feat", "SPELLID", FEAT_ENDURE_ADEPTBREATH));
        essenceSpells = JsonArrayInsert(essenceSpells, JsonInt(spellId));
    }

    SetLocalJson(oPlayer, NUI_SPELLBOOK_CLASS_ESSENCE_CACHE_BASE_VAR + IntToString(nClass), essenceSpells);
    return essenceSpells;
}

int JsonArrayContainsInt(json list, int item)
{
    int totalCount = JsonGetLength(list);

    int i;
    for (i = 0; i < totalCount; i++)
    {
        if (JsonGetInt(JsonArrayGet(list, i)) == item)
            return TRUE;
    }

    return FALSE;
}

int IsSpellbookNUIOpen(object oPC)
{
    int nPreviousToken = NuiFindWindow(oPC, PRC_SPELLBOOK_NUI_WINDOW_ID);
    if (nPreviousToken != 0)
    {
        return TRUE;
    }

    return FALSE;
}
