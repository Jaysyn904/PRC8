//::///////////////////////////////////////////////
//:: PRC Spellbook - Magic of Incarnum support
//:: prc_nui_moi_inc
//:://////////////////////////////////////////////
/*
    Character-wide Incarnum presentation and action helpers for /sb.

    This include deliberately delegates shaping, binding, investment, use
    limits, and effect application to the existing Magic of Incarnum feats and
    scripts.  The NUI only discovers live state, presents it, and launches the
    authoritative feat action after validating it again.
*/
//::///////////////////////////////////////////////

#include "prc_nui_consts"
#include "prc_nui_moi_cst"
#include "moi_inc_moifunc"
#include "nw_inc_nui"

// Incarnum is character-wide, like the domain browser, rather than belonging
// to one class tab.  Keep its navigation button stable; only actionable result
// buttons carry the layout generation.
const int PRC_SPELLBOOK_MODE_INCARNUM = 2;
const string PRC_SPELLBOOK_NUI_INCARNUM_MODE_BUTTON = "spellbookIncarnumModeButton";
const string PRC_SPELLBOOK_NUI_INCARNUM_CHAKRA_BUTTON_BASEID = "spellbookIncarnumChakraButton_";
const string PRC_SPELLBOOK_NUI_INCARNUM_ACTION_BUTTON_BASEID = "spellbookIncarnumActionButton_";

const string NUI_SPELLBOOK_INCARNUM_ACTION_BUTTON_MAP_VAR = "NUI_IncarnumActionButtonMap";
const string NUI_SPELLBOOK_INCARNUM_SELECTED_CHAKRA_VAR = "NUI_IncarnumSelectedChakra";
const string NUI_SPELLBOOK_INCARNUM_HEADER_BIND = "sbMoiHeader";
const string NUI_SPELLBOOK_INCARNUM_INVEST_BIND_BASE = "sbMoiInvest";
const string NUI_SPELLBOOK_INCARNUM_TOOLTIP_BIND_BASE = "sbMoiTooltip";
const string NUI_SPELLBOOK_INCARNUM_ENABLED_BIND_BASE = "sbMoiEnabled";
const string NUI_SPELLBOOK_INCARNUM_RESULT_HEIGHT_VAR = "NUI_IncarnumResultHeight";

const string NUI_SPELLBOOK_INCARNUM_PENDING_VAR = "NUI_IncarnumPending";
const string NUI_SPELLBOOK_INCARNUM_PENDING_INDEX_VAR = "NUI_IncarnumPendingIndex";
const string NUI_SPELLBOOK_INCARNUM_PENDING_GENERATION_VAR = "NUI_IncarnumPendingGeneration";

const int NUI_SPELLBOOK_INCARNUM_ACTION_SHAPED_MELD = 1;
const int NUI_SPELLBOOK_INCARNUM_ACTION_FEAT = 2;

const int NUI_SPELLBOOK_INCARNUM_MELDS_PER_ROW = 7;
const int NUI_SPELLBOOK_INCARNUM_ACTIONS_PER_ROW = 9;
const int NUI_SPELLBOOK_INCARNUM_MELD_ROW_HEIGHT = 74;
const int NUI_SPELLBOOK_INCARNUM_ACTION_ROW_HEIGHT = 46;
const int NUI_SPELLBOOK_INCARNUM_RESULT_HEIGHT = 140;

int NUISpellbookMoiHasContent(object oPlayer);
void NUISpellbookMoiClearActionMap(object oPlayer);
json NUISpellbookMoiCreateModeButton(object oPlayer, int bSelected);
json NUISpellbookMoiCreateHeaderRow();
json NUISpellbookMoiCreateChakraButtons(object oPlayer);
json NUISpellbookMoiCreateResultRows(object oPlayer);
json NUISpellbookMoiCreateResultRegion(json jRows);
string NUISpellbookMoiGetStructuralSignature(object oPlayer);
void NUISpellbookMoiRefreshBinds(object oPlayer, int nToken);
void NUISpellbookMoiStartRefreshLoop(object oPlayer, int nToken, int nGeneration);
int NUISpellbookMoiGetActionIndex(string sElement);
int NUISpellbookMoiValidateFeatEntry(object oPlayer, json jEntry);
json NUISpellbookMoiGetValidatedActionEntry(object oPlayer, int nIndex);
int NUISpellbookMoiSetPendingAction(object oPlayer, int nIndex);
void NUISpellbookMoiClearPendingAction(object oPlayer);
int NUISpellbookMoiTriggerPendingAction(object oPlayer);

string NUISpellbookMoiGeneratedId(object oPlayer, string sBase)
{
    return sBase
         + PRC_SPELLBOOK_NUI_LAYOUT_GENERATION_MARKER
         + IntToString(GetLocalInt(
             oPlayer,
             PRC_SPELLBOOK_NUI_REFRESH_GENERATION_VAR
         ));
}

string NUISpellbookMoiSpellName(int nSpell)
{
    if (nSpell <= 0)
        return "Incarnum ability";

    string sName = GetStringByStrRef(StringToInt(Get2DACache(
        "spells", "Name", nSpell
    )));
    if (sName == "")
        sName = Get2DACache("spells", "Label", nSpell);
    if (sName == "" || sName == "****")
        sName = "Incarnum ability";
    return sName;
}

string NUISpellbookMoiFeatName(int nFeat, int nDisplaySpell)
{
    string sName = GetStringByStrRef(StringToInt(Get2DACache(
        "feat", "FEAT", nFeat
    )));
    if (sName == "")
        sName = NUISpellbookMoiSpellName(nDisplaySpell);
    return sName;
}

string NUISpellbookMoiActionIcon(object oPlayer, int nFeat, int nClass)
{
    string sIcon;
    if (nFeat > 0)
        sIcon = Get2DACache("feat", "ICON", nFeat);

    // Incarnum actions should visually identify the feat that grants them.
    // If that feat has no icon, fall back to the owning Incarnum class rather
    // than the often-generic spell wrapper icon.
    if (sIcon == "" || sIcon == "****")
    {
        if (nClass <= 0 || nClass == CLASS_TYPE_INVALID)
            nClass = GetPrimaryIncarnumClass(oPlayer);
        if (nClass >= 0 && nClass != CLASS_TYPE_INVALID)
            sIcon = Get2DACache("classes", "Icon", nClass);
    }
    return sIcon;
}

int NUISpellbookMoiFeatHasLimitedUses(int nFeat)
{
    string sUsesPerDay = Get2DACache("feat", "USESPERDAY", nFeat);

    // Get2DACache normalizes **** to an empty string.  Both that value and
    // PRC's explicit -1 mean that the feat is not use-limited.
    return sUsesPerDay != ""
        && sUsesPerDay != "****"
        && sUsesPerDay != "-1"
        && StringToInt(sUsesPerDay) > 0;
}

int NUISpellbookMoiFeatHasRemainingUse(object oPlayer, int nFeat)
{
    return !NUISpellbookMoiFeatHasLimitedUses(nFeat)
        || GetFeatRemainingUses(nFeat, oPlayer) > 0;
}

string NUISpellbookMoiActionTooltip(object oPlayer, json jEntry)
{
    int nFeat = JsonGetInt(JsonObjectGet(jEntry, "f"));
    int nSpell = JsonGetInt(JsonObjectGet(jEntry, "s"));
    string sName = nFeat == 8834
        ? NUISpellbookMoiSpellName(nSpell)
        : NUISpellbookMoiFeatName(nFeat, nSpell);
    string sTooltip = sName
        + ". Left-click to use; right-click for details.";

    if (NUISpellbookMoiFeatHasLimitedUses(nFeat))
    {
        int nRemaining = GetFeatRemainingUses(nFeat, oPlayer);
        if (nRemaining < 0)
            nRemaining = 0;
        sTooltip += " Uses remaining: " + IntToString(nRemaining) + ".";
    }
    return sTooltip;
}

int NUISpellbookMoiFindSoulmeldRow(int nMeld)
{
    if (nMeld <= 0)
        return -1;

    int nRows = Get2DARowCount("soulmelds");
    int i;
    for (i = 1; i < nRows; i++)
    {
        if (StringToInt(Get2DACache("soulmelds", "SpellID", i)) == nMeld)
            return i;
    }
    return -1;
}

int NUISpellbookMoiIsMeldShapedAnywhere(object oPlayer, int nMeld)
{
    return GetIsMeldShaped(oPlayer, nMeld, CLASS_TYPE_INCARNATE)
        || GetIsMeldShaped(oPlayer, nMeld, CLASS_TYPE_SOULBORN)
        || GetIsMeldShaped(oPlayer, nMeld, CLASS_TYPE_TOTEMIST)
        || GetIsMeldShaped(oPlayer, nMeld, CLASS_TYPE_SPINEMELD_WARRIOR);
}

int NUISpellbookMoiEntryListHasMeld(json jEntries, int nMeld)
{
    int i;
    for (i = 0; i < JsonGetLength(jEntries); i++)
    {
        if (JsonGetInt(JsonObjectGet(JsonArrayGet(jEntries, i), "m")) == nMeld)
            return TRUE;
    }
    return FALSE;
}

int NUISpellbookMoiGetShapingClass(int nIndex)
{
    if (nIndex == 1)
        return CLASS_TYPE_SOULBORN;
    if (nIndex == 2)
        return CLASS_TYPE_TOTEMIST;
    if (nIndex == 3)
        return CLASS_TYPE_SPINEMELD_WARRIOR;
    return CLASS_TYPE_INCARNATE;
}

string NUISpellbookMoiClassName(int nClass)
{
    string sName = GetStringByStrRef(StringToInt(Get2DACache(
        "classes", "Name", nClass
    )));
    if (sName == "")
        sName = "Incarnum";
    return sName;
}

string NUISpellbookMoiAppendOwnedClassName(
    object oPlayer,
    string sNames,
    int nClass)
{
    if (GetLevelByClass(nClass, oPlayer) <= 0)
        return sNames;

    string sName = NUISpellbookMoiClassName(nClass);
    if (sNames == "")
        return sName;
    return sNames + " / " + sName;
}

string NUISpellbookMoiGetModeLabel(object oPlayer)
{
    string sNames;
    sNames = NUISpellbookMoiAppendOwnedClassName(
        oPlayer, sNames, CLASS_TYPE_INCARNATE
    );
    sNames = NUISpellbookMoiAppendOwnedClassName(
        oPlayer, sNames, CLASS_TYPE_SOULBORN
    );
    sNames = NUISpellbookMoiAppendOwnedClassName(
        oPlayer, sNames, CLASS_TYPE_TOTEMIST
    );
    sNames = NUISpellbookMoiAppendOwnedClassName(
        oPlayer, sNames, CLASS_TYPE_SPINEMELD_WARRIOR
    );
    sNames = NUISpellbookMoiAppendOwnedClassName(
        oPlayer, sNames, CLASS_TYPE_IRONSOUL_FORGEMASTER
    );
    sNames = NUISpellbookMoiAppendOwnedClassName(
        oPlayer, sNames, CLASS_TYPE_UMBRAL_DISCIPLE
    );
    sNames = NUISpellbookMoiAppendOwnedClassName(
        oPlayer, sNames, CLASS_TYPE_SAPPHIRE_HIERARCH
    );
    sNames = NUISpellbookMoiAppendOwnedClassName(
        oPlayer, sNames, CLASS_TYPE_SOULCASTER
    );
    sNames = NUISpellbookMoiAppendOwnedClassName(
        oPlayer, sNames, CLASS_TYPE_TOTEM_RAGER
    );
    sNames = NUISpellbookMoiAppendOwnedClassName(
        oPlayer, sNames, CLASS_TYPE_INCANDESCENT_CHAMPION
    );
    sNames = NUISpellbookMoiAppendOwnedClassName(
        oPlayer, sNames, CLASS_TYPE_NECROCARNATE
    );
    sNames = NUISpellbookMoiAppendOwnedClassName(
        oPlayer, sNames, CLASS_TYPE_WITCHBORN_BINDER
    );
    sNames = NUISpellbookMoiAppendOwnedClassName(
        oPlayer, sNames, CLASS_TYPE_INCARNUM_BLADE
    );

    if (sNames == "")
        return "Incarnum";
    return sNames;
}

json NUISpellbookMoiMakeEntry(
    object oPlayer,
    int nKind,
    int nFeat,
    int nWrapperSpell,
    int nTargetSpell,
    int nDescriptionSpell,
    int nSubSpell,
    int nMeld,
    int nClass,
    int bPersonal)
{
    json jEntry = JsonObject();
    jEntry = JsonObjectSet(jEntry, "k", JsonInt(nKind));
    jEntry = JsonObjectSet(jEntry, "f", JsonInt(nFeat));
    jEntry = JsonObjectSet(jEntry, "w", JsonInt(nWrapperSpell));
    jEntry = JsonObjectSet(jEntry, "s", JsonInt(nTargetSpell));
    jEntry = JsonObjectSet(jEntry, "d", JsonInt(nDescriptionSpell));
    jEntry = JsonObjectSet(jEntry, "u", JsonInt(nSubSpell));
    jEntry = JsonObjectSet(jEntry, "m", JsonInt(nMeld));
    jEntry = JsonObjectSet(jEntry, "c", JsonInt(nClass));
    jEntry = JsonObjectSet(jEntry, "p", JsonInt(bPersonal));
    jEntry = JsonObjectSet(jEntry, "g", JsonInt(GetLocalInt(
        oPlayer,
        PRC_SPELLBOOK_NUI_REFRESH_GENERATION_VAR
    )));
    return jEntry;
}

json NUISpellbookMoiMakeShapedEntry(
    object oPlayer,
    int nMeld,
    int nClass,
    int nRawChakra,
    int nViewChakra)
{
    int nRow = NUISpellbookMoiFindSoulmeldRow(nMeld);
    if (nRow < 1)
        return JsonNull();

    int nFeat = StringToInt(Get2DACache("soulmelds", "FeatID", nRow));
    int nInvestSpell = StringToInt(Get2DACache(
        "soulmelds", "EssentiaID", nRow
    ));
    if (nFeat <= 0 || nInvestSpell <= 0)
        return JsonNull();

    json jEntry = NUISpellbookMoiMakeEntry(
        oPlayer,
        NUI_SPELLBOOK_INCARNUM_ACTION_SHAPED_MELD,
        nFeat,
        nInvestSpell,
        nInvestSpell,
        nMeld,
        0,
        nMeld,
        nClass,
        TRUE
    );
    jEntry = JsonObjectSet(jEntry, "h", JsonInt(nRawChakra));
    jEntry = JsonObjectSet(jEntry, "v", JsonInt(nViewChakra));
    return jEntry;
}

json NUISpellbookMoiAddShapedClass(
    object oPlayer,
    json jEntries,
    int nClass)
{
    int nSlot;
    for (nSlot = 0; nSlot <= 22; nSlot++)
    {
        int nMeld = GetLocalInt(
            oPlayer,
            "ShapedMeld" + IntToString(nClass) + IntToString(nSlot)
        );
        if (nMeld <= 0 || NUISpellbookMoiEntryListHasMeld(jEntries, nMeld))
            continue;

        json jEntry = NUISpellbookMoiMakeShapedEntry(
            oPlayer, nMeld, nClass, 0, 0
        );
        if (jEntry != JsonNull())
            jEntries = JsonArrayInsert(jEntries, jEntry);
    }
    return jEntries;
}

json NUISpellbookMoiGetShapedEntries(object oPlayer)
{
    json jEntries = JsonArray();
    jEntries = NUISpellbookMoiAddShapedClass(
        oPlayer, jEntries, CLASS_TYPE_INCARNATE
    );
    jEntries = NUISpellbookMoiAddShapedClass(
        oPlayer, jEntries, CLASS_TYPE_SOULBORN
    );
    jEntries = NUISpellbookMoiAddShapedClass(
        oPlayer, jEntries, CLASS_TYPE_TOTEMIST
    );
    jEntries = NUISpellbookMoiAddShapedClass(
        oPlayer, jEntries, CLASS_TYPE_SPINEMELD_WARRIOR
    );
    return jEntries;
}

int NUISpellbookMoiGetChakraOccupantCount(object oPlayer, int nChakra)
{
    int nCount;
    if (nChakra == CHAKRA_TOTEM)
    {
        if (GetLocalInt(oPlayer, "BoundMeld" + IntToString(CHAKRA_TOTEM)) > 0)
            nCount++;
        if (GetLocalInt(
                oPlayer,
                "BoundMeld" + IntToString(CHAKRA_DOUBLE_TOTEM)
            ) > 0)
            nCount++;
        return nCount;
    }

    int nClassIndex;
    for (nClassIndex = 0; nClassIndex < 4; nClassIndex++)
    {
        int nClass = NUISpellbookMoiGetShapingClass(nClassIndex);
        if (GetIsChakraUsed(oPlayer, nChakra, nClass) > 0)
            nCount++;
        if (GetIsChakraUsed(oPlayer, nChakra + 11, nClass) > 0)
            nCount++;
    }
    return nCount;
}

int NUISpellbookMoiGetSelectedChakra(object oPlayer)
{
    int nSelected = GetLocalInt(
        oPlayer,
        NUI_SPELLBOOK_INCARNUM_SELECTED_CHAKRA_VAR
    );
    if (nSelected >= CHAKRA_CROWN && nSelected <= CHAKRA_TOTEM)
        return nSelected;

    for (nSelected = CHAKRA_CROWN; nSelected <= CHAKRA_TOTEM; nSelected++)
    {
        if (NUISpellbookMoiGetChakraOccupantCount(oPlayer, nSelected) > 0)
        {
            SetLocalInt(
                oPlayer,
                NUI_SPELLBOOK_INCARNUM_SELECTED_CHAKRA_VAR,
                nSelected
            );
            return nSelected;
        }
    }

    SetLocalInt(
        oPlayer,
        NUI_SPELLBOOK_INCARNUM_SELECTED_CHAKRA_VAR,
        CHAKRA_CROWN
    );
    return CHAKRA_CROWN;
}

int NUISpellbookMoiFindRawShapingChakra(
    object oPlayer,
    int nMeld,
    int nClass)
{
    int nRawChakra;
    for (nRawChakra = CHAKRA_CROWN;
         nRawChakra <= CHAKRA_DOUBLE_SOUL;
         nRawChakra++)
    {
        if (nRawChakra == CHAKRA_TOTEM)
            continue;
        if (GetIsChakraUsed(oPlayer, nRawChakra, nClass) == nMeld)
            return nRawChakra;
    }
    return 0;
}

json NUISpellbookMoiAppendSelectedShapedEntry(
    object oPlayer,
    json jEntries,
    int nMeld,
    int nClass,
    int nRawChakra,
    int nViewChakra)
{
    if (nMeld <= 0 || NUISpellbookMoiEntryListHasMeld(jEntries, nMeld))
        return jEntries;
    if (!GetIsMeldShaped(oPlayer, nMeld, nClass))
        return jEntries;

    json jEntry = NUISpellbookMoiMakeShapedEntry(
        oPlayer, nMeld, nClass, nRawChakra, nViewChakra
    );
    if (jEntry != JsonNull())
        jEntries = JsonArrayInsert(jEntries, jEntry);
    return jEntries;
}

json NUISpellbookMoiGetSelectedShapedEntries(object oPlayer)
{
    json jEntries = JsonArray();
    int nSelected = NUISpellbookMoiGetSelectedChakra(oPlayer);
    int nClassIndex;

    if (nSelected != CHAKRA_TOTEM)
    {
        for (nClassIndex = 0; nClassIndex < 4; nClassIndex++)
        {
            int nClass = NUISpellbookMoiGetShapingClass(nClassIndex);
            int nRawChakra = nSelected;
            int nMeld = GetIsChakraUsed(oPlayer, nRawChakra, nClass);
            jEntries = NUISpellbookMoiAppendSelectedShapedEntry(
                oPlayer,
                jEntries,
                nMeld,
                nClass,
                nRawChakra,
                nSelected
            );

            nRawChakra = nSelected + 11;
            nMeld = GetIsChakraUsed(oPlayer, nRawChakra, nClass);
            jEntries = NUISpellbookMoiAppendSelectedShapedEntry(
                oPlayer,
                jEntries,
                nMeld,
                nClass,
                nRawChakra,
                nSelected
            );
        }
        return jEntries;
    }

    int nBoundChakra;
    for (nBoundChakra = CHAKRA_TOTEM;
         nBoundChakra <= CHAKRA_DOUBLE_TOTEM;
         nBoundChakra += 11)
    {
        int nMeld = GetLocalInt(
            oPlayer,
            "BoundMeld" + IntToString(nBoundChakra)
        );
        if (nMeld <= 0 || NUISpellbookMoiEntryListHasMeld(jEntries, nMeld))
            continue;

        for (nClassIndex = 0; nClassIndex < 4; nClassIndex++)
        {
            int nClass = NUISpellbookMoiGetShapingClass(nClassIndex);
            int nRawChakra = NUISpellbookMoiFindRawShapingChakra(
                oPlayer, nMeld, nClass
            );
            if (nRawChakra <= 0)
                continue;

            jEntries = NUISpellbookMoiAppendSelectedShapedEntry(
                oPlayer,
                jEntries,
                nMeld,
                nClass,
                nRawChakra,
                nSelected
            );
            break;
        }
    }
    return jEntries;
}

int NUISpellbookMoiFeatInAuditedActionSet(int nFeat)
{
    if (nFeat == 8841 || nFeat == 8869)
        return FALSE;

    return (nFeat >= 8800 && nFeat <= 8868)
        || nFeat == 8882
        || nFeat == 8884
        || nFeat == 8887
        || nFeat == 8891
        || nFeat == 8896
        || (nFeat >= 8915 && nFeat <= 8931)
        || (nFeat >= 8951 && nFeat <= 8964)
        || (nFeat >= 8993 && nFeat <= 9019);
}

int NUISpellbookMoiIsSoulmeldGrantedAction(int nFeat)
{
    // These actions are not character feats.  Their shaped/bound soulmeld
    // scripts add them to the PRC skin and remove them with the meld.  Requiring
    // the live skin property prevents stale or fixture-injected FeatList copies
    // from surviving a rest with no corresponding soulmeld state.
    return (nFeat >= 8801 && nFeat <= 8853)
        || nFeat == 8868
        || (nFeat >= 9014 && nFeat <= 9019);
}

int NUISpellbookMoiSkinGrantsFeat(object oPlayer, int nFeat)
{
    object oSkin = GetPCSkin(oPlayer);
    if (!GetIsObjectValid(oSkin))
        return FALSE;

    itemproperty ipTest = GetFirstItemProperty(oSkin);
    while (GetIsItemPropertyValid(ipTest))
    {
        if (GetItemPropertyType(ipTest) == ITEM_PROPERTY_BONUS_FEAT)
        {
            int nIPFeat = GetItemPropertySubType(ipTest);
            if (StringToInt(Get2DACache(
                    "iprp_feats", "FeatIndex", nIPFeat
                )) == nFeat)
                return TRUE;
        }
        ipTest = GetNextItemProperty(oSkin);
    }
    return FALSE;
}

int NUISpellbookMoiHasAnyShapedMeld(object oPlayer)
{
    int nClassIndex;
    for (nClassIndex = 0; nClassIndex < 4; nClassIndex++)
    {
        int nClass = NUISpellbookMoiGetShapingClass(nClassIndex);
        int nSlot;
        for (nSlot = 0; nSlot <= 22; nSlot++)
        {
            if (GetLocalInt(
                    oPlayer,
                    "ShapedMeld" + IntToString(nClass) + IntToString(nSlot)
                ) > 0)
                return TRUE;
        }
    }
    return FALSE;
}

int NUISpellbookMoiCanRebindChakra(object oPlayer, int nFeat)
{
    if (nFeat < 9003 || nFeat > 9013)
        return FALSE;

    int nChakra = nFeat - 9002;
    int nClass = GetPrimaryIncarnumClass(oPlayer);
    int nBound = GetIsChakraBound(oPlayer, nChakra);
    int nFirst = GetIsChakraUsed(oPlayer, nChakra, nClass);
    int nSecond = GetIsChakraUsed(oPlayer, nChakra + 11, nClass);

    return nBound > 0
        && nFirst > 0
        && nSecond > 0
        && (nBound == nFirst || nBound == nSecond);
}

int NUISpellbookMoiCanUseTotemAction(object oPlayer, int nFeat)
{
    int nTotem = GetIsChakraUsed(
        oPlayer, CHAKRA_TOTEM, CLASS_TYPE_TOTEMIST
    );
    int nDoubleTotem = GetIsChakraUsed(
        oPlayer, CHAKRA_DOUBLE_TOTEM, CLASS_TYPE_TOTEMIST
    );

    if (nFeat == 8867)
        return nTotem > 0 || nDoubleTotem > 0;

    if (nFeat == 8866)
    {
        if (GetIsChakraBound(oPlayer, CHAKRA_TOTEM) <= 0)
            return FALSE;
        // The stock action reapplies the double-Totem meld whenever the feat
        // exists, so do not let an empty second slot fall through as meld 0.
        return !GetHasFeat(FEAT_DOUBLE_CHAKRA_TOTEM, oPlayer)
            || GetIsChakraBound(oPlayer, CHAKRA_DOUBLE_TOTEM) > 0;
    }
    return FALSE;
}

int NUISpellbookMoiFeatHasLiveContext(object oPlayer, int nFeat)
{
    if (NUISpellbookMoiIsSoulmeldGrantedAction(nFeat))
        return NUISpellbookMoiSkinGrantsFeat(oPlayer, nFeat);

    // Both normal/epic Rapid Meldshaping and Perfect Meldshaper operate on an
    // existing shaped meld.  Hide them while there is nothing they can affect.
    if (nFeat == 8862
        || nFeat == 8863
        || (nFeat >= 8993 && nFeat <= 9002))
        return NUISpellbookMoiHasAnyShapedMeld(oPlayer);

    // Rebind assumes two occupants and an existing bind.  Its underlying PRC
    // script does not safely handle an empty chakra, so enforce that state both
    // while building the row and again on mouseup.
    if (nFeat >= 9003 && nFeat <= 9013)
        return NUISpellbookMoiCanRebindChakra(oPlayer, nFeat);

    if (nFeat == 8866 || nFeat == 8867)
        return NUISpellbookMoiCanUseTotemAction(oPlayer, nFeat);

    return TRUE;
}

int NUISpellbookMoiFeatHasSafeScript(int nFeat, int nSpell)
{
    if (nFeat <= 0 || nSpell <= 0)
        return FALSE;
    if (!NUISpellbookMoiFeatInAuditedActionSet(nFeat))
        return FALSE;
    if (StringToInt(Get2DACache("feat", "SPELLID", nFeat)) != nSpell)
        return FALSE;

    string sScript = GetStringLowerCase(Get2DACache(
        "spells", "ImpactScript", nSpell
    ));
    // The compact spellbook is for using Incarnum abilities.  Essentia
    // allocation belongs to the dedicated Live Essentia/loadout windows, so
    // never expose the legacy investment conversation or max-invest actions
    // here as if they were activatable meld powers.
    return FindSubString(sScript, "moi_") == 0
        && sScript != "moi_invessentia"
        && sScript != "moi_mld_maxess";
}

int NUISpellbookMoiHighestEpicRapidFeat(object oPlayer)
{
    int nFeat;
    for (nFeat = 9002; nFeat >= 8993; nFeat--)
    {
        if (GetHasFeat(nFeat, oPlayer))
            return nFeat;
    }
    return 0;
}

int NUISpellbookMoiIsPersonalAction(int nFeat, int nSpell)
{
    // These scripts act on the user despite legacy non-personal Range values.
    // Necrocarnum Circlet (8849) is intentionally not here: its ground target
    // is real and must continue through targeting mode.
    if (nFeat == 8812
        || nFeat == 8840
        || nFeat == 8843
        || nFeat == 8853
        || nFeat == 8896)
        return TRUE;

    return GetStringUpperCase(Get2DACache("spells", "Range", nSpell)) == "P";
}

json NUISpellbookMoiAppendFeatAction(
    object oPlayer,
    json jEntries,
    int nFeat)
{
    if (!GetHasFeat(nFeat, oPlayer))
        return jEntries;
    if (!NUISpellbookMoiFeatHasLiveContext(oPlayer, nFeat))
        return jEntries;

    int nWrapperSpell = StringToInt(Get2DACache("feat", "SPELLID", nFeat));
    if (!NUISpellbookMoiFeatHasSafeScript(nFeat, nWrapperSpell))
        return jEntries;

    // Lucky Dice is a radial master.  Expose only its three real choices and
    // retain the master feat plus child subspell for ActionUseFeat.
    if (nFeat == 8834)
    {
        int nChild;
        for (nChild = 18935; nChild <= 18937; nChild++)
        {
            if (StringToInt(Get2DACache("spells", "Master", nChild))
                    != nWrapperSpell
                || FindSubString(GetStringLowerCase(Get2DACache(
                    "spells", "ImpactScript", nChild
                )), "moi_") != 0)
                continue;

            jEntries = JsonArrayInsert(jEntries, NUISpellbookMoiMakeEntry(
                oPlayer,
                NUI_SPELLBOOK_INCARNUM_ACTION_FEAT,
                nFeat,
                nWrapperSpell,
                nChild,
                nChild,
                nChild,
                0,
                0,
                TRUE
            ));
        }
        return jEntries;
    }

    jEntries = JsonArrayInsert(jEntries, NUISpellbookMoiMakeEntry(
        oPlayer,
        NUI_SPELLBOOK_INCARNUM_ACTION_FEAT,
        nFeat,
        nWrapperSpell,
        nWrapperSpell,
        nWrapperSpell,
        0,
        0,
        0,
        NUISpellbookMoiIsPersonalAction(nFeat, nWrapperSpell)
    ));
    return jEntries;
}

json NUISpellbookMoiGetFeatActionEntries(object oPlayer)
{
    json jEntries = JsonArray();
    int nFeat;

    for (nFeat = 8800; nFeat <= 8868; nFeat++)
        jEntries = NUISpellbookMoiAppendFeatAction(oPlayer, jEntries, nFeat);

    jEntries = NUISpellbookMoiAppendFeatAction(oPlayer, jEntries, 8882);
    jEntries = NUISpellbookMoiAppendFeatAction(oPlayer, jEntries, 8884);
    jEntries = NUISpellbookMoiAppendFeatAction(oPlayer, jEntries, 8887);
    jEntries = NUISpellbookMoiAppendFeatAction(oPlayer, jEntries, 8891);
    jEntries = NUISpellbookMoiAppendFeatAction(oPlayer, jEntries, 8896);

    for (nFeat = 8915; nFeat <= 8931; nFeat++)
        jEntries = NUISpellbookMoiAppendFeatAction(oPlayer, jEntries, nFeat);
    for (nFeat = 8951; nFeat <= 8964; nFeat++)
        jEntries = NUISpellbookMoiAppendFeatAction(oPlayer, jEntries, nFeat);

    // All ten epic progression feats launch the same Rapid Meldshaping spell.
    // Show only the highest owned row so the grid contains one usable action.
    nFeat = NUISpellbookMoiHighestEpicRapidFeat(oPlayer);
    if (nFeat > 0)
        jEntries = NUISpellbookMoiAppendFeatAction(oPlayer, jEntries, nFeat);

    for (nFeat = 9003; nFeat <= 9019; nFeat++)
        jEntries = NUISpellbookMoiAppendFeatAction(oPlayer, jEntries, nFeat);

    return jEntries;
}

int NUISpellbookMoiHasIncarnumClass(object oPlayer)
{
    return GetLevelByClass(CLASS_TYPE_INCARNATE, oPlayer) > 0
        || GetLevelByClass(CLASS_TYPE_SOULBORN, oPlayer) > 0
        || GetLevelByClass(CLASS_TYPE_TOTEMIST, oPlayer) > 0
        || GetLevelByClass(CLASS_TYPE_SPINEMELD_WARRIOR, oPlayer) > 0
        || GetLevelByClass(CLASS_TYPE_IRONSOUL_FORGEMASTER, oPlayer) > 0
        || GetLevelByClass(CLASS_TYPE_UMBRAL_DISCIPLE, oPlayer) > 0
        || GetLevelByClass(CLASS_TYPE_SAPPHIRE_HIERARCH, oPlayer) > 0
        || GetLevelByClass(CLASS_TYPE_SOULCASTER, oPlayer) > 0
        || GetLevelByClass(CLASS_TYPE_TOTEM_RAGER, oPlayer) > 0
        || GetLevelByClass(CLASS_TYPE_INCANDESCENT_CHAMPION, oPlayer) > 0
        || GetLevelByClass(CLASS_TYPE_NECROCARNATE, oPlayer) > 0
        || GetLevelByClass(CLASS_TYPE_WITCHBORN_BINDER, oPlayer) > 0
        || GetLevelByClass(CLASS_TYPE_INCARNUM_BLADE, oPlayer) > 0;
}

int NUISpellbookMoiHasLoadoutShapingClass(object oPlayer)
{
    int nClassIndex;
    for (nClassIndex = 0; nClassIndex < 4; nClassIndex++)
    {
        int nClass = NUISpellbookMoiGetShapingClass(nClassIndex);
        if (GetLevelByClass(nClass, oPlayer) <= 0)
            continue;
        if (nClass == CLASS_TYPE_INCARNATE && !IncarnateAlignment(oPlayer))
            continue;
        if (GetMaxShapeSoulmeldCount(oPlayer, nClass) > 0)
            return TRUE;
    }
    return FALSE;
}

int NUISpellbookMoiHasContent(object oPlayer)
{
    if (NUISpellbookMoiHasIncarnumClass(oPlayer)
        || GetTotalEssentia(oPlayer) > 0
        || JsonGetLength(NUISpellbookMoiGetShapedEntries(oPlayer)) > 0)
        return TRUE;

    return JsonGetLength(NUISpellbookMoiGetFeatActionEntries(oPlayer)) > 0;
}

void NUISpellbookMoiClearActionMap(object oPlayer)
{
    DeleteLocalJson(oPlayer, NUI_SPELLBOOK_INCARNUM_ACTION_BUTTON_MAP_VAR);
}

json NUISpellbookMoiGreyOverlay(float fWidth, float fHeight)
{
    json jPoints = JsonArray();
    jPoints = JsonArrayInsert(jPoints, JsonFloat(0.0f));
    jPoints = JsonArrayInsert(jPoints, JsonFloat(0.0f));
    jPoints = JsonArrayInsert(jPoints, JsonFloat(0.0f));
    jPoints = JsonArrayInsert(jPoints, JsonFloat(fHeight));
    jPoints = JsonArrayInsert(jPoints, JsonFloat(fWidth));
    jPoints = JsonArrayInsert(jPoints, JsonFloat(fHeight));
    jPoints = JsonArrayInsert(jPoints, JsonFloat(fWidth));
    jPoints = JsonArrayInsert(jPoints, JsonFloat(0.0f));
    jPoints = JsonArrayInsert(jPoints, JsonFloat(0.0f));
    jPoints = JsonArrayInsert(jPoints, JsonFloat(0.0f));
    return NuiDrawListPolyLine(
        JsonBool(TRUE),
        NuiColor(0, 0, 0, 127),
        JsonBool(TRUE),
        JsonFloat(2.0f),
        jPoints
    );
}

json NUISpellbookMoiCreateModeButton(object oPlayer, int bSelected)
{
    string sIcon = NUISpellbookMoiActionIcon(
        oPlayer,
        FEAT_INVEST_ESSENTIA_CONV,
        GetPrimaryIncarnumClass(oPlayer)
    );
    json jButton = NuiId(
        NuiButtonImage(JsonString(sIcon)),
        PRC_SPELLBOOK_NUI_INCARNUM_MODE_BUTTON
    );
    jButton = NuiWidth(jButton, 32.0f);
    jButton = NuiHeight(jButton, 32.0f);
    jButton = NuiTooltip(
        jButton,
        JsonString(NUISpellbookMoiGetModeLabel(oPlayer))
    );

    if (!bSelected)
    {
        json jDraw = JsonArray();
        jDraw = JsonArrayInsert(jDraw, NUISpellbookMoiGreyOverlay(32.0f, 32.0f));
        jButton = NuiDrawList(jButton, JsonBool(FALSE), jDraw);
    }
    return jButton;
}

json NUISpellbookMoiCreateTextRow(json jText, float fHeight)
{
    json jItems = JsonArray();
    json jLabel = NuiLabel(
        jText,
        JsonInt(NUI_HALIGN_LEFT),
        JsonInt(NUI_VALIGN_MIDDLE)
    );
    jLabel = NuiWidth(jLabel, 470.0f);
    jLabel = NuiHeight(jLabel, fHeight);
    jItems = JsonArrayInsert(jItems, jLabel);
    return NuiRow(jItems);
}

json NUISpellbookMoiCreateHeaderRow()
{
    return NUISpellbookMoiCreateTextRow(
        NuiBind(NUI_SPELLBOOK_INCARNUM_HEADER_BIND),
        22.0f
    );
}

string NUISpellbookMoiGetChakraShortLabel(int nChakra)
{
    if (nChakra == CHAKRA_CROWN)
        return "Cr";
    if (nChakra == CHAKRA_FEET)
        return "Ft";
    if (nChakra == CHAKRA_HANDS)
        return "Hn";
    if (nChakra == CHAKRA_ARMS)
        return "Ar";
    if (nChakra == CHAKRA_BROW)
        return "Br";
    if (nChakra == CHAKRA_SHOULDERS)
        return "Sh";
    if (nChakra == CHAKRA_THROAT)
        return "Th";
    if (nChakra == CHAKRA_WAIST)
        return "Wa";
    if (nChakra == CHAKRA_HEART)
        return "He";
    if (nChakra == CHAKRA_SOUL)
        return "So";
    return "To";
}

string NUISpellbookMoiGetChakraTooltip(object oPlayer, int nChakra)
{
    int nCount = NUISpellbookMoiGetChakraOccupantCount(oPlayer, nChakra);
    string sKind = nChakra == CHAKRA_TOTEM ? "bound" : "shaped";
    string sMeld = nCount == 1 ? " soulmeld" : " soulmelds";
    return ChakraToString(nChakra) + ": " + IntToString(nCount) + " "
         + sKind + sMeld + ". Click to view.";
}

json NUISpellbookMoiCreateChakraCell(
    object oPlayer,
    int nChakra,
    int nSelected)
{
    float fMargin = 2.0f;
    string sTooltip = NUISpellbookMoiGetChakraTooltip(oPlayer, nChakra);

    json jCount = NuiButton(JsonString(IntToString(
        NUISpellbookMoiGetChakraOccupantCount(oPlayer, nChakra)
    )));
    jCount = NuiWidth(jCount, 42.0f);
    jCount = NuiHeight(jCount, 24.0f);
    jCount = NuiTooltip(jCount, JsonString(sTooltip));
    jCount = NuiMargin(jCount, fMargin);

    json jButton = NuiId(
        NuiButton(JsonString(NUISpellbookMoiGetChakraShortLabel(nChakra))),
        NUISpellbookMoiGeneratedId(
            oPlayer,
            PRC_SPELLBOOK_NUI_INCARNUM_CHAKRA_BUTTON_BASEID
                + IntToString(nChakra)
        )
    );
    jButton = NuiWidth(jButton, 42.0f);
    jButton = NuiHeight(jButton, 42.0f);
    jButton = NuiTooltip(jButton, JsonString(sTooltip));
    if (nChakra != nSelected)
    {
        json jDraw = JsonArray();
        jDraw = JsonArrayInsert(jDraw, NUISpellbookMoiGreyOverlay(42.0f, 42.0f));
        jButton = NuiDrawList(jButton, JsonBool(FALSE), jDraw);
    }
    jButton = NuiMargin(jButton, fMargin);

    json jCell = JsonArray();
    jCell = JsonArrayInsert(jCell, jCount);
    jCell = JsonArrayInsert(jCell, jButton);
    return NuiMargin(NuiCol(jCell), 0.0f);
}

json NUISpellbookMoiCreateChakraButtons(object oPlayer)
{
    json jRow = JsonArray();
    int nSelected = NUISpellbookMoiGetSelectedChakra(oPlayer);
    int nChakra;
    for (nChakra = CHAKRA_CROWN; nChakra <= CHAKRA_TOTEM; nChakra++)
    {
        jRow = JsonArrayInsert(
            jRow,
            NUISpellbookMoiCreateChakraCell(oPlayer, nChakra, nSelected)
        );
    }
    return NuiRow(jRow);
}

json NUISpellbookMoiCreateSlotCounter(json jValue, json jTooltip)
{
    // Use the same fixed button box as caster slot counters. A bordered group
    // around a fixed-size label can become unsatisfiable once shaped melds are
    // inserted into the live layout, while this control remains compact at
    // every GUI scale.
    json jCounter = NuiButton(jValue);
    jCounter = NuiWidth(jCounter, 50.0f);
    jCounter = NuiHeight(jCounter, 24.0f);
    jCounter = NuiTooltip(jCounter, jTooltip);
    return NuiMargin(jCounter, 2.0f);
}

json NUISpellbookMoiCreateShapedCell(
    object oPlayer,
    json jEntry,
    int nIndex)
{
    string sIndex = IntToString(nIndex);
    int nFeat = JsonGetInt(JsonObjectGet(jEntry, "f"));
    int nMeld = JsonGetInt(JsonObjectGet(jEntry, "m"));
    int nClass = JsonGetInt(JsonObjectGet(jEntry, "c"));

    json jButton = NuiId(
        NuiButtonImage(JsonString(NUISpellbookMoiActionIcon(
            oPlayer, nFeat, nClass
        ))),
        NUISpellbookMoiGeneratedId(
            oPlayer,
            PRC_SPELLBOOK_NUI_INCARNUM_ACTION_BUTTON_BASEID + sIndex
        )
    );
    jButton = NuiWidth(jButton, 42.0f);
    jButton = NuiHeight(jButton, 42.0f);
    jButton = NuiMargin(jButton, 2.0f);
    jButton = NuiEnabled(jButton, NuiBind(
        NUI_SPELLBOOK_INCARNUM_ENABLED_BIND_BASE + sIndex
    ));
    jButton = NuiTooltip(jButton, NuiBind(
        NUI_SPELLBOOK_INCARNUM_TOOLTIP_BIND_BASE + sIndex
    ));
    jButton = NuiDisabledTooltip(jButton, NuiBind(
        NUI_SPELLBOOK_INCARNUM_TOOLTIP_BIND_BASE + sIndex
    ));

    json jButtonRow = JsonArray();
    jButtonRow = JsonArrayInsert(jButtonRow, NuiSpacer());
    jButtonRow = JsonArrayInsert(jButtonRow, jButton);
    jButtonRow = JsonArrayInsert(jButtonRow, NuiSpacer());

    json jCell = JsonArray();
    jCell = JsonArrayInsert(jCell, NUISpellbookMoiCreateSlotCounter(
        NuiBind(NUI_SPELLBOOK_INCARNUM_INVEST_BIND_BASE + sIndex),
        NuiBind(NUI_SPELLBOOK_INCARNUM_TOOLTIP_BIND_BASE + sIndex)
    ));
    jCell = JsonArrayInsert(jCell, NuiRow(jButtonRow));
    return NuiMargin(NuiWidth(NuiCol(jCell), 54.0f), 0.0f);
}

json NUISpellbookMoiCreateActionButton(
    object oPlayer,
    json jEntry,
    int nIndex)
{
    int nFeat = JsonGetInt(JsonObjectGet(jEntry, "f"));
    int nClass = JsonGetInt(JsonObjectGet(jEntry, "c"));
    string sIndex = IntToString(nIndex);

    json jButton = NuiId(
        NuiButtonImage(JsonString(NUISpellbookMoiActionIcon(
            oPlayer, nFeat, nClass
        ))),
        NUISpellbookMoiGeneratedId(
            oPlayer,
            PRC_SPELLBOOK_NUI_INCARNUM_ACTION_BUTTON_BASEID
                + sIndex
        )
    );
    jButton = NuiWidth(jButton, 38.0f);
    jButton = NuiHeight(jButton, 38.0f);
    jButton = NuiEnabled(jButton, NuiBind(
        NUI_SPELLBOOK_INCARNUM_ENABLED_BIND_BASE + sIndex
    ));
    jButton = NuiTooltip(jButton, NuiBind(
        NUI_SPELLBOOK_INCARNUM_TOOLTIP_BIND_BASE + sIndex
    ));
    jButton = NuiDisabledTooltip(jButton, NuiBind(
        NUI_SPELLBOOK_INCARNUM_TOOLTIP_BIND_BASE + sIndex
    ));
    return jButton;
}

json NUISpellbookMoiCreateResultRows(object oPlayer)
{
    json jRows = JsonArray();
    json jMap = JsonArray();
    json jActions = NUISpellbookMoiGetFeatActionEntries(oPlayer);
    json jRow = JsonArray();
    int nActionRows = (JsonGetLength(jActions)
                     + NUI_SPELLBOOK_INCARNUM_ACTIONS_PER_ROW - 1)
                    / NUI_SPELLBOOK_INCARNUM_ACTIONS_PER_ROW;
    int i;

    for (i = 0; i < JsonGetLength(jActions); i++)
    {
        json jEntry = JsonArrayGet(jActions, i);
        int nIndex = JsonGetLength(jMap);
        jMap = JsonArrayInsert(jMap, jEntry);
        jRow = JsonArrayInsert(
            jRow,
            NUISpellbookMoiCreateActionButton(oPlayer, jEntry, nIndex)
        );
        if (JsonGetLength(jRow) >= NUI_SPELLBOOK_INCARNUM_ACTIONS_PER_ROW)
        {
            jRows = JsonArrayInsert(jRows, NuiRow(jRow));
            jRow = JsonArray();
        }
    }
    if (JsonGetLength(jRow) > 0)
        jRows = JsonArrayInsert(jRows, NuiRow(jRow));

    SetLocalJson(oPlayer, NUI_SPELLBOOK_INCARNUM_ACTION_BUTTON_MAP_VAR, jMap);
    SetLocalInt(
        oPlayer,
        NUI_SPELLBOOK_INCARNUM_RESULT_HEIGHT_VAR,
        nActionRows * NUI_SPELLBOOK_INCARNUM_ACTION_ROW_HEIGHT
    );
    return jRows;
}

json NUISpellbookMoiCreateResultRegion(json jRows)
{
    int nScrollbars = GetLocalInt(
        OBJECT_SELF,
        NUI_SPELLBOOK_INCARNUM_RESULT_HEIGHT_VAR
    ) > NUI_SPELLBOOK_INCARNUM_RESULT_HEIGHT
                    ? NUI_SCROLLBARS_Y
                    : NUI_SCROLLBARS_NONE;
    json jRegion = NuiId(
        NuiGroup(NuiCol(jRows), FALSE, nScrollbars),
        PRC_SPELLBOOK_NUI_RESULT_HOST_ID
    );
    jRegion = NuiWidth(jRegion, 480.0f);
    jRegion = NuiHeight(
        jRegion,
        IntToFloat(NUI_SPELLBOOK_INCARNUM_RESULT_HEIGHT)
    );
    return jRegion;
}

string NUISpellbookMoiGetHeaderText(object oPlayer)
{
    int nTotal = GetTotalEssentia(oPlayer);
    int nLocked = GetFeatLockedEssentia(oPlayer);
    int nUsable = GetTotalUsableEssentia(oPlayer);
    int nInvested = GetTotalEssentiaInvested(oPlayer);
    int nMovableInvested = nInvested - nLocked;
    if (nMovableInvested < 0)
        nMovableInvested = 0;
    int nFree = nUsable - nMovableInvested;
    if (nFree < 0)
        nFree = 0;

    string sText = "Essentia: " + IntToString(nFree)
                 + " free / " + IntToString(nUsable)
                 + " usable (" + IntToString(nTotal)
                 + " total, " + IntToString(nLocked) + " locked)";
    int nTemporary = GetTemporaryEssentia(oPlayer);
    if (nTemporary > 0)
        sText += " + " + IntToString(nTemporary) + " temporary";
    return sText;
}

string NUISpellbookMoiMeldTooltip(
    object oPlayer,
    int nMeld,
    int nClass,
    int nRawChakra)
{
    int nInvested = GetEssentiaInvested(oPlayer, nMeld);
    int nCapacity = GetMaxEssentiaCapacity(oPlayer, nClass, nMeld);
    string sShaped = nRawChakra > 0
        ? ChakraToString(nRawChakra)
        : "unknown chakra";
    if (nRawChakra > CHAKRA_TOTEM)
        sShaped += " II";

    string sBound;
    int nBoundChakra;
    for (nBoundChakra = CHAKRA_CROWN;
         nBoundChakra <= CHAKRA_DOUBLE_TOTEM;
         nBoundChakra++)
    {
        if (GetLocalInt(
                oPlayer,
                "BoundMeld" + IntToString(nBoundChakra)
            ) != nMeld)
            continue;

        if (sBound != "")
            sBound += ", ";
        sBound += ChakraToString(nBoundChakra);
        if (nBoundChakra > CHAKRA_TOTEM)
            sBound += " II";
    }
    if (sBound == "")
        sBound = "none";

    return NUISpellbookMoiSpellName(nMeld)
         + ". Shaped: " + sShaped
         + " (" + NUISpellbookMoiClassName(nClass) + ")"
         + ". Bound: " + sBound
         + ". Essentia: " + IntToString(nInvested)
         + "/" + IntToString(nCapacity)
         + ". Left-click to maximize essentia; right-click for details.";
}

void NUISpellbookMoiRefreshBinds(object oPlayer, int nToken)
{
    if (nToken <= 0
        || NuiFindWindow(oPlayer, PRC_SPELLBOOK_NUI_WINDOW_ID) != nToken)
        return;

    NuiSetBind(
        oPlayer,
        nToken,
        NUI_SPELLBOOK_INCARNUM_HEADER_BIND,
        JsonString(NUISpellbookMoiGetHeaderText(oPlayer))
    );

    json jMap = GetLocalJson(
        oPlayer,
        NUI_SPELLBOOK_INCARNUM_ACTION_BUTTON_MAP_VAR
    );
    if (jMap == JsonNull())
        return;

    int i;
    for (i = 0; i < JsonGetLength(jMap); i++)
    {
        json jEntry = JsonArrayGet(jMap, i);
        int nKind = JsonGetInt(JsonObjectGet(jEntry, "k"));
        string sIndex = IntToString(i);

        if (nKind == NUI_SPELLBOOK_INCARNUM_ACTION_SHAPED_MELD)
        {
            int nMeld = JsonGetInt(JsonObjectGet(jEntry, "m"));
            int nClass = JsonGetInt(JsonObjectGet(jEntry, "c"));
            int nRawChakra = JsonGetInt(JsonObjectGet(jEntry, "h"));
            int nFeat = JsonGetInt(JsonObjectGet(jEntry, "f"));
            int nInvested = GetEssentiaInvested(oPlayer, nMeld);
            int nCapacity = GetMaxEssentiaCapacity(oPlayer, nClass, nMeld);

            NuiSetBind(
                oPlayer,
                nToken,
                NUI_SPELLBOOK_INCARNUM_INVEST_BIND_BASE + sIndex,
                JsonString(IntToString(nInvested) + "/"
                    + IntToString(nCapacity))
            );
            NuiSetBind(
                oPlayer,
                nToken,
                NUI_SPELLBOOK_INCARNUM_TOOLTIP_BIND_BASE + sIndex,
                JsonString(NUISpellbookMoiMeldTooltip(
                    oPlayer, nMeld, nClass, nRawChakra
                ))
            );
            NuiSetBind(
                oPlayer,
                nToken,
                NUI_SPELLBOOK_INCARNUM_ENABLED_BIND_BASE + sIndex,
                JsonBool(GetHasFeat(nFeat, oPlayer)
                    && (nRawChakra > 0
                        ? GetIsChakraUsed(
                            oPlayer, nRawChakra, nClass
                        ) == nMeld
                        : NUISpellbookMoiIsMeldShapedAnywhere(
                            oPlayer, nMeld
                        )))
            );
        }
        else if (nKind == NUI_SPELLBOOK_INCARNUM_ACTION_FEAT)
        {
            NuiSetBind(
                oPlayer,
                nToken,
                NUI_SPELLBOOK_INCARNUM_TOOLTIP_BIND_BASE + sIndex,
                JsonString(NUISpellbookMoiActionTooltip(oPlayer, jEntry))
            );
            NuiSetBind(
                oPlayer,
                nToken,
                NUI_SPELLBOOK_INCARNUM_ENABLED_BIND_BASE + sIndex,
                JsonBool(NUISpellbookMoiValidateFeatEntry(oPlayer, jEntry))
            );
        }
    }
}

string NUISpellbookMoiGetStructuralSignature(object oPlayer)
{
    string sState;
    int nClassIndex;
    for (nClassIndex = 0; nClassIndex < 4; nClassIndex++)
    {
        int nClass = CLASS_TYPE_INCARNATE;
        if (nClassIndex == 1)
            nClass = CLASS_TYPE_SOULBORN;
        else if (nClassIndex == 2)
            nClass = CLASS_TYPE_TOTEMIST;
        else if (nClassIndex == 3)
            nClass = CLASS_TYPE_SPINEMELD_WARRIOR;

        int nSlot;
        for (nSlot = 0; nSlot <= 22; nSlot++)
        {
            sState += "S" + IntToString(nClass) + "." + IntToString(nSlot)
                   + ":" + IntToString(GetLocalInt(
                       oPlayer,
                       "ShapedMeld" + IntToString(nClass) + IntToString(nSlot)
                   )) + ";";
            sState += "U" + IntToString(nClass) + "." + IntToString(nSlot)
                   + ":" + IntToString(GetLocalInt(
                       oPlayer,
                       "UsedMeld" + IntToString(nClass) + IntToString(nSlot)
                   )) + ";";
        }
    }

    int nBoundSlot;
    for (nBoundSlot = CHAKRA_CROWN;
         nBoundSlot <= CHAKRA_DOUBLE_TOTEM;
         nBoundSlot++)
    {
        sState += "B" + IntToString(nBoundSlot)
               + ":" + IntToString(GetLocalInt(
                   oPlayer,
                   "BoundMeld" + IntToString(nBoundSlot)
               )) + ";";
    }

    json jActions = NUISpellbookMoiGetFeatActionEntries(oPlayer);
    int i;
    for (i = 0; i < JsonGetLength(jActions); i++)
    {
        json jEntry = JsonArrayGet(jActions, i);
        sState += "A" + IntToString(JsonGetInt(JsonObjectGet(jEntry, "f")))
               + "." + IntToString(JsonGetInt(JsonObjectGet(jEntry, "s")))
               + "." + IntToString(JsonGetInt(JsonObjectGet(jEntry, "u")))
               + ";";
    }
    return sState;
}

void NUISpellbookMoiRefreshLoop(
    object oPlayer,
    int nToken,
    int nGeneration,
    string sStructuralState)
{
    if (NuiFindWindow(oPlayer, PRC_SPELLBOOK_NUI_WINDOW_ID) != nToken
        || GetLocalInt(oPlayer, PRC_SPELLBOOK_NUI_REFRESH_GENERATION_VAR)
            != nGeneration
        || GetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_MODE_VAR)
            != PRC_SPELLBOOK_MODE_INCARNUM)
        return;

    string sCurrentState = NUISpellbookMoiGetStructuralSignature(oPlayer);
    if (sCurrentState != sStructuralState)
    {
        ExecuteScript("prc_nui_sb_view", oPlayer);
        return;
    }

    NUISpellbookMoiRefreshBinds(oPlayer, nToken);
    DelayCommand(1.0f, NUISpellbookMoiRefreshLoop(
        oPlayer,
        nToken,
        nGeneration,
        sStructuralState
    ));
}

void NUISpellbookMoiStartRefreshLoop(
    object oPlayer,
    int nToken,
    int nGeneration)
{
    if (nToken <= 0)
        return;
    NUISpellbookMoiRefreshBinds(oPlayer, nToken);
    DelayCommand(1.0f, NUISpellbookMoiRefreshLoop(
        oPlayer,
        nToken,
        nGeneration,
        NUISpellbookMoiGetStructuralSignature(oPlayer)
    ));
}

int NUISpellbookMoiValidateShapedEntry(object oPlayer, json jEntry)
{
    int nFeat = JsonGetInt(JsonObjectGet(jEntry, "f"));
    int nInvestSpell = JsonGetInt(JsonObjectGet(jEntry, "w"));
    int nTargetSpell = JsonGetInt(JsonObjectGet(jEntry, "s"));
    int nDescriptionSpell = JsonGetInt(JsonObjectGet(jEntry, "d"));
    int nMeld = JsonGetInt(JsonObjectGet(jEntry, "m"));
    int nClass = JsonGetInt(JsonObjectGet(jEntry, "c"));
    int nRawChakra = JsonGetInt(JsonObjectGet(jEntry, "h"));
    int nViewChakra = JsonGetInt(JsonObjectGet(jEntry, "v"));
    int nRow = NUISpellbookMoiFindSoulmeldRow(nMeld);
    int bViewMatches = nViewChakra == CHAKRA_TOTEM
        ? (GetLocalInt(
                oPlayer,
                "BoundMeld" + IntToString(CHAKRA_TOTEM)
            ) == nMeld
            || GetLocalInt(
                oPlayer,
                "BoundMeld" + IntToString(CHAKRA_DOUBLE_TOTEM)
            ) == nMeld)
        : DoubleChakraToChakra(nRawChakra) == nViewChakra;

    return nRow > 0
        && (nClass == CLASS_TYPE_INCARNATE
            || nClass == CLASS_TYPE_SOULBORN
            || nClass == CLASS_TYPE_TOTEMIST
            || nClass == CLASS_TYPE_SPINEMELD_WARRIOR)
        && nRawChakra >= CHAKRA_CROWN
        && nRawChakra <= CHAKRA_DOUBLE_SOUL
        && nRawChakra != CHAKRA_TOTEM
        && nViewChakra >= CHAKRA_CROWN
        && nViewChakra <= CHAKRA_TOTEM
        && GetLocalInt(
            oPlayer,
            NUI_SPELLBOOK_INCARNUM_SELECTED_CHAKRA_VAR
        ) == nViewChakra
        && bViewMatches
        && GetIsChakraUsed(oPlayer, nRawChakra, nClass) == nMeld
        && GetIsMeldShaped(oPlayer, nMeld, nClass)
        && GetHasFeat(nFeat, oPlayer)
        && StringToInt(Get2DACache("soulmelds", "FeatID", nRow)) == nFeat
        && StringToInt(Get2DACache("soulmelds", "EssentiaID", nRow))
            == nInvestSpell
        && StringToInt(Get2DACache("soulmelds", "SpellID", nRow))
            == nDescriptionSpell
        && nTargetSpell == nInvestSpell
        && StringToInt(Get2DACache("feat", "SPELLID", nFeat))
            == nInvestSpell
        && FindSubString(GetStringLowerCase(Get2DACache(
            "spells", "ImpactScript", nInvestSpell
        )), "moi_") == 0
        && JsonGetInt(JsonObjectGet(jEntry, "u")) == 0
        && JsonGetInt(JsonObjectGet(jEntry, "p")) == TRUE;
}

int NUISpellbookMoiValidateFeatEntry(object oPlayer, json jEntry)
{
    int nFeat = JsonGetInt(JsonObjectGet(jEntry, "f"));
    int nWrapperSpell = JsonGetInt(JsonObjectGet(jEntry, "w"));
    int nTargetSpell = JsonGetInt(JsonObjectGet(jEntry, "s"));
    int nSubSpell = JsonGetInt(JsonObjectGet(jEntry, "u"));

    if (!GetHasFeat(nFeat, oPlayer)
        || !NUISpellbookMoiFeatHasLiveContext(oPlayer, nFeat)
        || !NUISpellbookMoiFeatHasRemainingUse(oPlayer, nFeat)
        || !NUISpellbookMoiFeatHasSafeScript(nFeat, nWrapperSpell))
        return FALSE;

    if (nFeat >= 8993 && nFeat <= 9002
        && nFeat != NUISpellbookMoiHighestEpicRapidFeat(oPlayer))
        return FALSE;

    if (nFeat == 8834)
    {
        if (nSubSpell < 18935 || nSubSpell > 18937
            || nTargetSpell != nSubSpell
            || JsonGetInt(JsonObjectGet(jEntry, "d")) != nSubSpell
            || StringToInt(Get2DACache("spells", "Master", nSubSpell))
                != nWrapperSpell
            || FindSubString(GetStringLowerCase(Get2DACache(
                "spells", "ImpactScript", nSubSpell
            )), "moi_") != 0)
            return FALSE;
    }
    else if (nSubSpell != 0
        || nTargetSpell != nWrapperSpell
        || JsonGetInt(JsonObjectGet(jEntry, "d")) != nWrapperSpell)
        return FALSE;

    return JsonGetInt(JsonObjectGet(jEntry, "p"))
        == NUISpellbookMoiIsPersonalAction(nFeat, nTargetSpell);
}

int NUISpellbookMoiValidateActionEntry(object oPlayer, json jEntry)
{
    if (jEntry == JsonNull()
        || GetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_MODE_VAR)
            != PRC_SPELLBOOK_MODE_INCARNUM
        || JsonGetInt(JsonObjectGet(jEntry, "g"))
            != GetLocalInt(
                oPlayer,
                PRC_SPELLBOOK_NUI_REFRESH_GENERATION_VAR
            ))
        return FALSE;

    int nKind = JsonGetInt(JsonObjectGet(jEntry, "k"));
    if (nKind == NUI_SPELLBOOK_INCARNUM_ACTION_SHAPED_MELD)
        return NUISpellbookMoiValidateShapedEntry(oPlayer, jEntry);
    if (nKind == NUI_SPELLBOOK_INCARNUM_ACTION_FEAT)
        return NUISpellbookMoiValidateFeatEntry(oPlayer, jEntry);
    return FALSE;
}

int NUISpellbookMoiGetActionIndex(string sElement)
{
    if (FindSubString(
            sElement,
            PRC_SPELLBOOK_NUI_INCARNUM_ACTION_BUTTON_BASEID
        ) != 0)
        return -1;

    int nMarker = FindSubString(
        sElement,
        PRC_SPELLBOOK_NUI_LAYOUT_GENERATION_MARKER
    );
    if (nMarker >= 0)
        sElement = GetSubString(sElement, 0, nMarker);

    string sIndex = GetSubString(
        sElement,
        GetStringLength(PRC_SPELLBOOK_NUI_INCARNUM_ACTION_BUTTON_BASEID),
        GetStringLength(sElement)
            - GetStringLength(PRC_SPELLBOOK_NUI_INCARNUM_ACTION_BUTTON_BASEID)
    );
    if (sIndex == "")
        return -1;
    int nIndex = StringToInt(sIndex);
    if (IntToString(nIndex) != sIndex)
        return -1;
    return nIndex;
}

json NUISpellbookMoiGetValidatedActionEntry(object oPlayer, int nIndex)
{
    json jMap = GetLocalJson(
        oPlayer,
        NUI_SPELLBOOK_INCARNUM_ACTION_BUTTON_MAP_VAR
    );
    if (jMap == JsonNull()
        || nIndex < 0
        || nIndex >= JsonGetLength(jMap))
        return JsonNull();

    json jEntry = JsonArrayGet(jMap, nIndex);
    if (!NUISpellbookMoiValidateActionEntry(oPlayer, jEntry))
        return JsonNull();
    return jEntry;
}

void NUISpellbookMoiClearPendingAction(object oPlayer)
{
    int bPending = GetLocalInt(oPlayer, NUI_SPELLBOOK_INCARNUM_PENDING_VAR);
    DeleteLocalInt(oPlayer, NUI_SPELLBOOK_INCARNUM_PENDING_VAR);
    DeleteLocalInt(oPlayer, NUI_SPELLBOOK_INCARNUM_PENDING_INDEX_VAR);
    DeleteLocalInt(oPlayer, NUI_SPELLBOOK_INCARNUM_PENDING_GENERATION_VAR);
    if (bPending)
    {
        DeleteLocalInt(oPlayer, NUI_SPELLBOOK_SELECTED_FEATID_VAR);
        DeleteLocalInt(oPlayer, NUI_SPELLBOOK_SELECTED_SUBSPELL_SPELLID_VAR);
        DeleteLocalInt(oPlayer, NUI_SPELLBOOK_ON_TARGET_IS_PERSONAL_FEAT);
        DeleteLocalString(oPlayer, NUI_SPELLBOOK_ON_TARGET_ACTION_VAR);
    }
}

int NUISpellbookMoiSetPendingAction(object oPlayer, int nIndex)
{
    json jEntry = NUISpellbookMoiGetValidatedActionEntry(oPlayer, nIndex);
    if (jEntry == JsonNull())
        return FALSE;

    NUISpellbookMoiClearPendingAction(oPlayer);
    SetLocalInt(oPlayer, NUI_SPELLBOOK_INCARNUM_PENDING_VAR, TRUE);
    SetLocalInt(oPlayer, NUI_SPELLBOOK_INCARNUM_PENDING_INDEX_VAR, nIndex);
    SetLocalInt(
        oPlayer,
        NUI_SPELLBOOK_INCARNUM_PENDING_GENERATION_VAR,
        GetLocalInt(oPlayer, PRC_SPELLBOOK_NUI_REFRESH_GENERATION_VAR)
    );
    SetLocalInt(
        oPlayer,
        NUI_SPELLBOOK_SELECTED_FEATID_VAR,
        JsonGetInt(JsonObjectGet(jEntry, "f"))
    );

    int nSubSpell = JsonGetInt(JsonObjectGet(jEntry, "u"));
    if (nSubSpell > 0)
        SetLocalInt(
            oPlayer,
            NUI_SPELLBOOK_SELECTED_SUBSPELL_SPELLID_VAR,
            nSubSpell
        );
    else
        DeleteLocalInt(oPlayer, NUI_SPELLBOOK_SELECTED_SUBSPELL_SPELLID_VAR);

    if (JsonGetInt(JsonObjectGet(jEntry, "p")))
        SetLocalInt(
            oPlayer,
            NUI_SPELLBOOK_ON_TARGET_IS_PERSONAL_FEAT,
            TRUE
        );
    else
        DeleteLocalInt(oPlayer, NUI_SPELLBOOK_ON_TARGET_IS_PERSONAL_FEAT);
    return TRUE;
}

int NUISpellbookMoiTriggerPendingAction(object oPlayer)
{
    if (!GetLocalInt(oPlayer, NUI_SPELLBOOK_INCARNUM_PENDING_VAR))
        return FALSE;

    int nIndex = GetLocalInt(
        oPlayer,
        NUI_SPELLBOOK_INCARNUM_PENDING_INDEX_VAR
    );
    int nGeneration = GetLocalInt(
        oPlayer,
        NUI_SPELLBOOK_INCARNUM_PENDING_GENERATION_VAR
    );
    json jEntry = NUISpellbookMoiGetValidatedActionEntry(oPlayer, nIndex);
    if (jEntry == JsonNull()
        || nGeneration != GetLocalInt(
            oPlayer,
            PRC_SPELLBOOK_NUI_REFRESH_GENERATION_VAR
        ))
    {
        NUISpellbookMoiClearPendingAction(oPlayer);
        return TRUE;
    }

    int nFeat = JsonGetInt(JsonObjectGet(jEntry, "f"));
    int nSubSpell = JsonGetInt(JsonObjectGet(jEntry, "u"));
    int bPersonal = JsonGetInt(JsonObjectGet(jEntry, "p"));
    object oTarget = bPersonal
                   ? oPlayer
                   : GetLocalObject(oPlayer, "TARGETING_OBJECT");
    location lTarget = GetLocalLocation(oPlayer, "TARGETING_POSITION");

    if (bPersonal)
        AssignCommand(oPlayer, ActionUseFeat(nFeat, oPlayer, nSubSpell));
    else if (GetIsObjectValid(oTarget) && GetObjectType(oTarget))
        AssignCommand(oPlayer, ActionUseFeat(
            nFeat,
            oTarget,
            nSubSpell,
            LOCATION_INVALID
        ));
    else if (GetIsObjectValid(GetAreaFromLocation(lTarget)))
        AssignCommand(oPlayer, ActionUseFeat(
            nFeat,
            OBJECT_INVALID,
            nSubSpell,
            lTarget
        ));

    NUISpellbookMoiClearPendingAction(oPlayer);
    return TRUE;
}
