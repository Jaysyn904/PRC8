//::///////////////////////////////////////////////
//:: PRC Spellbook - Archmage High Arcana support
//:: prc_nui_arch_inc
//:://////////////////////////////////////////////
/*
    Presents the active Archmage High Arcana controls inside /sb while the
    existing feats and spell scripts remain the sole rules authority.  The
    legacy radial feats remain available as an alternate interface.
*/
//::///////////////////////////////////////////////

#include "prc_nui_consts"
#include "prc_class_const"
#include "prc_feat_const"
#include "inc_lookups"
#include "inc_persist_loca"
#include "nw_inc_nui"

const string PRC_SPELLBOOK_NUI_ARCHMAGE_BUTTON_BASEID = "spellbookArchmageButton_";
const string NUI_SPELLBOOK_ARCHMAGE_BUTTON_MAP_VAR = "NUI_ArchmageButtonMap";
const string NUI_SPELLBOOK_ARCHMAGE_MAP_GENERATION_VAR = "NUI_ArchmageMapGeneration";
const string NUI_SPELLBOOK_ARCHMAGE_PENDING_VAR = "NUI_ArchmagePending";
const string NUI_SPELLBOOK_ARCHMAGE_PENDING_ENTRY_VAR = "NUI_ArchmagePendingEntry";
const string NUI_SPELLBOOK_ARCHMAGE_PENDING_GENERATION_VAR = "NUI_ArchmagePendingGeneration";

const int NUI_SPELLBOOK_ARCHMAGE_ACTION_ELEMENT = 1;
const int NUI_SPELLBOOK_ARCHMAGE_ACTION_SHAPING = 2;
const int NUI_SPELLBOOK_ARCHMAGE_ACTION_ARCANE_FIRE = 3;
const int NUI_SPELLBOOK_ARCHMAGE_ACTION_SLA = 4;

// feat.2da exposes this legacy companion feat but prc_feat_const does not.
const int NUI_SPELLBOOK_ARCHMAGE_MASTERY_ELEMENTS_OFF_FEAT = 3000;
const int NUI_SPELLBOOK_ARCHMAGE_MASTERY_ELEMENTS_FEAT = 3005;
const int NUI_SPELLBOOK_ARCHMAGE_MASTERY_ELEMENTS_MASTER = 2009;
const int NUI_SPELLBOOK_ARCHMAGE_MASTERY_SHAPING_SPELL = 2006;
const int NUI_SPELLBOOK_ARCHMAGE_ARCANE_FIRE_SPELL = 2007;
const int NUI_SPELLBOOK_ARCHMAGE_SLA_FIRST_FEAT = 2825;
const int NUI_SPELLBOOK_ARCHMAGE_SLA_FIRST_SPELL = 2036;

string NUISpellbookArchmageSpellName(int nSpell)
{
    if (nSpell < 0)
        return "Unassigned";

    string sName = GetStringByStrRef(StringToInt(Get2DACache(
        "spells", "Name", nSpell
    )));
    if (sName == "")
        sName = Get2DACache("spells", "Label", nSpell);
    if (sName == "" || sName == "****")
        sName = "High Arcana";
    return sName;
}

string NUISpellbookArchmageIcon(int nSpell, int nFeat)
{
    string sIcon;
    if (nSpell >= 0)
        sIcon = Get2DACache("spells", "IconResRef", nSpell);
    if ((sIcon == "" || sIcon == "****") && nFeat > 0)
        sIcon = Get2DACache("feat", "ICON", nFeat);
    if (sIcon == "" || sIcon == "****")
        sIcon = Get2DACache("classes", "Icon", CLASS_TYPE_ARCHMAGE);
    return sIcon;
}

string NUISpellbookArchmageElementName(object oPlayer)
{
    string sName = GetLocalString(
        oPlayer, "archmage_mastery_elements_name"
    );
    return sName == "" ? "Normal" : sName;
}

int NUISpellbookArchmageSpellPower(object oPlayer)
{
    int nPower;
    int nFeat;
    for (nFeat = 3007; nFeat <= 3011; nFeat++)
    {
        if (GetHasFeat(nFeat, oPlayer))
            nPower = nFeat - 3006;
    }
    return nPower;
}

json NUISpellbookArchmageMakeEntry(
    object oPlayer,
    int nKind,
    int nFeat,
    int nActionSpell,
    int nTargetSpell,
    int nDescriptionSpell,
    int nSubSpell,
    int nSlot,
    int bPersonal,
    string sTooltip)
{
    json jEntry = JsonObject();
    jEntry = JsonObjectSet(jEntry, "k", JsonInt(nKind));
    jEntry = JsonObjectSet(jEntry, "f", JsonInt(nFeat));
    jEntry = JsonObjectSet(jEntry, "a", JsonInt(nActionSpell));
    jEntry = JsonObjectSet(jEntry, "s", JsonInt(nTargetSpell));
    jEntry = JsonObjectSet(jEntry, "d", JsonInt(nDescriptionSpell));
    jEntry = JsonObjectSet(jEntry, "u", JsonInt(nSubSpell));
    jEntry = JsonObjectSet(jEntry, "q", JsonInt(nSlot));
    jEntry = JsonObjectSet(jEntry, "p", JsonInt(bPersonal));
    jEntry = JsonObjectSet(jEntry, "n", JsonString(sTooltip));
    jEntry = JsonObjectSet(jEntry, "g", JsonInt(GetLocalInt(
        oPlayer, PRC_SPELLBOOK_NUI_REFRESH_GENERATION_VAR
    )));
    return jEntry;
}

json NUISpellbookArchmageCreateButton(
    object oPlayer,
    json jEntry,
    int nIndex)
{
    int nFeat = JsonGetInt(JsonObjectGet(jEntry, "f"));
    int nDisplaySpell = JsonGetInt(JsonObjectGet(jEntry, "d"));
    int nKind = JsonGetInt(JsonObjectGet(jEntry, "k"));
    int bCurrent = FALSE;

    if (nKind == NUI_SPELLBOOK_ARCHMAGE_ACTION_ELEMENT)
    {
        string sChosen = NUISpellbookArchmageElementName(oPlayer);
        string sButtonName = NUISpellbookArchmageSpellName(nDisplaySpell);
        bCurrent = FindSubString(sButtonName, sChosen) >= 0
            || (sChosen == "Normal" && nDisplaySpell == 2000);
    }
    else if (nKind == NUI_SPELLBOOK_ARCHMAGE_ACTION_SHAPING)
        bCurrent = GetLocalInt(oPlayer, "archmage_mastery_shaping") != 0;
    else if (nKind == NUI_SPELLBOOK_ARCHMAGE_ACTION_SLA)
        bCurrent = GetLocalInt(oPlayer, "PRC_SLA_Store")
            == JsonGetInt(JsonObjectGet(jEntry, "q"));

    json jButton = NuiId(
        NuiButtonImage(JsonString(NUISpellbookArchmageIcon(
            nDisplaySpell, nFeat
        ))),
        PRC_SPELLBOOK_NUI_ARCHMAGE_BUTTON_BASEID
            + IntToString(nIndex)
            + PRC_SPELLBOOK_NUI_LAYOUT_GENERATION_MARKER
            + IntToString(GetLocalInt(
                oPlayer, PRC_SPELLBOOK_NUI_REFRESH_GENERATION_VAR
            ))
    );
    jButton = NuiWidth(jButton, 38.0f);
    jButton = NuiHeight(jButton, 38.0f);
    jButton = NuiTooltip(jButton, JsonObjectGet(jEntry, "n"));
    if (bCurrent)
        jButton = NuiEncouraged(jButton, JsonBool(TRUE));
    return jButton;
}

json NUISpellbookArchmageCreateHeaderRow(object oPlayer)
{
    string sHeader = "High Arcana  |  Elements: "
        + NUISpellbookArchmageElementName(oPlayer)
        + "  |  Shaping: "
        + (GetLocalInt(oPlayer, "archmage_mastery_shaping")
            ? "On" : "Off")
        + "  |  Spell Power +"
        + IntToString(NUISpellbookArchmageSpellPower(oPlayer));

    json jRow = JsonArray();
    json jLabel = NuiLabel(
        JsonString(sHeader),
        JsonInt(NUI_HALIGN_LEFT),
        JsonInt(NUI_VALIGN_MIDDLE)
    );
    jLabel = NuiWidth(jLabel, 470.0f);
    jLabel = NuiHeight(jLabel, 24.0f);
    jRow = JsonArrayInsert(jRow, jLabel);
    return NuiRow(jRow);
}

json NUISpellbookArchmageCreateActionRows(object oPlayer)
{
    json jRows = JsonArray();
    json jMap = JsonArray();
    json jRow = JsonArray();
    int nGeneration = GetLocalInt(
        oPlayer, PRC_SPELLBOOK_NUI_REFRESH_GENERATION_VAR
    );

    if (GetLevelByClass(CLASS_TYPE_ARCHMAGE, oPlayer) <= 0)
    {
        SetLocalJson(oPlayer, NUI_SPELLBOOK_ARCHMAGE_BUTTON_MAP_VAR, jMap);
        SetLocalInt(
            oPlayer,
            NUI_SPELLBOOK_ARCHMAGE_MAP_GENERATION_VAR,
            nGeneration
        );
        return jRows;
    }

    // The separate legacy "back" feat owns the normal/no-conversion choice.
    if (GetHasFeat(
            NUI_SPELLBOOK_ARCHMAGE_MASTERY_ELEMENTS_OFF_FEAT,
            oPlayer
        ) && GetHasFeat(
            NUI_SPELLBOOK_ARCHMAGE_MASTERY_ELEMENTS_FEAT,
            oPlayer
        ))
    {
        json jEntry = NUISpellbookArchmageMakeEntry(
            oPlayer,
            NUI_SPELLBOOK_ARCHMAGE_ACTION_ELEMENT,
            NUI_SPELLBOOK_ARCHMAGE_MASTERY_ELEMENTS_OFF_FEAT,
            2000,
            2000,
            2000,
            0,
            0,
            TRUE,
            "Mastery of Elements: Normal damage"
        );
        int nIndex = JsonGetLength(jMap);
        jMap = JsonArrayInsert(jMap, jEntry);
        jRow = JsonArrayInsert(jRow, NUISpellbookArchmageCreateButton(
            oPlayer, jEntry, nIndex
        ));
    }

    if (GetHasFeat(NUI_SPELLBOOK_ARCHMAGE_MASTERY_ELEMENTS_FEAT, oPlayer))
    {
        int nChild;
        for (nChild = 2001; nChild <= 2005; nChild++)
        {
            json jEntry = NUISpellbookArchmageMakeEntry(
                oPlayer,
                NUI_SPELLBOOK_ARCHMAGE_ACTION_ELEMENT,
                NUI_SPELLBOOK_ARCHMAGE_MASTERY_ELEMENTS_FEAT,
                NUI_SPELLBOOK_ARCHMAGE_MASTERY_ELEMENTS_MASTER,
                nChild,
                nChild,
                nChild,
                0,
                TRUE,
                NUISpellbookArchmageSpellName(nChild)
            );
            int nIndex = JsonGetLength(jMap);
            jMap = JsonArrayInsert(jMap, jEntry);
            jRow = JsonArrayInsert(jRow, NUISpellbookArchmageCreateButton(
                oPlayer, jEntry, nIndex
            ));
        }
    }

    if (GetHasFeat(FEAT_MASTERY_SHAPES, oPlayer))
    {
        string sState = GetLocalInt(oPlayer, "archmage_mastery_shaping")
            ? "On; click to disable" : "Off; click to enable";
        json jEntry = NUISpellbookArchmageMakeEntry(
            oPlayer,
            NUI_SPELLBOOK_ARCHMAGE_ACTION_SHAPING,
            FEAT_MASTERY_SHAPES,
            NUI_SPELLBOOK_ARCHMAGE_MASTERY_SHAPING_SPELL,
            NUI_SPELLBOOK_ARCHMAGE_MASTERY_SHAPING_SPELL,
            NUI_SPELLBOOK_ARCHMAGE_MASTERY_SHAPING_SPELL,
            0,
            0,
            TRUE,
            "Mastery of Shaping: " + sState
        );
        int nIndex = JsonGetLength(jMap);
        jMap = JsonArrayInsert(jMap, jEntry);
        jRow = JsonArrayInsert(jRow, NUISpellbookArchmageCreateButton(
            oPlayer, jEntry, nIndex
        ));
    }

    if (GetHasFeat(FEAT_ARCANE_FIRE, oPlayer))
    {
        json jEntry = NUISpellbookArchmageMakeEntry(
            oPlayer,
            NUI_SPELLBOOK_ARCHMAGE_ACTION_ARCANE_FIRE,
            FEAT_ARCANE_FIRE,
            NUI_SPELLBOOK_ARCHMAGE_ARCANE_FIRE_SPELL,
            NUI_SPELLBOOK_ARCHMAGE_ARCANE_FIRE_SPELL,
            NUI_SPELLBOOK_ARCHMAGE_ARCANE_FIRE_SPELL,
            0,
            0,
            FALSE,
            "Arcane Fire: choose a target, then cast the arcane spell to consume"
        );
        int nIndex = JsonGetLength(jMap);
        jMap = JsonArrayInsert(jMap, jEntry);
        jRow = JsonArrayInsert(jRow, NUISpellbookArchmageCreateButton(
            oPlayer, jEntry, nIndex
        ));
    }

    if (JsonGetLength(jRow) > 0)
    {
        jRows = JsonArrayInsert(jRows, NuiRow(jRow));
        jRow = JsonArray();
    }

    int nSlot;
    for (nSlot = 1; nSlot <= 5; nSlot++)
    {
        int nFeat = NUI_SPELLBOOK_ARCHMAGE_SLA_FIRST_FEAT + nSlot - 1;
        if (!GetHasFeat(nFeat, oPlayer))
            continue;

        int nActionSpell = NUI_SPELLBOOK_ARCHMAGE_SLA_FIRST_SPELL
                         + nSlot - 1;
        int nStoredSpell = GetPersistantLocalInt(
            oPlayer,
            "PRC_SLA_SpellID_" + IntToString(nSlot)
        ) - 1;
        int bAssigned = nStoredSpell >= 0;
        int nDisplaySpell = bAssigned ? nStoredSpell : nActionSpell;
        int bPersonal = !bAssigned
            || GetStringUpperCase(Get2DACache(
                "spells", "Range", nStoredSpell
            )) == "P";
        string sTooltip = "Spell-Like Ability " + IntToString(nSlot) + ": ";
        if (bAssigned)
        {
            sTooltip += NUISpellbookArchmageSpellName(nStoredSpell)
                     + " - "
                     + IntToString(GetFeatRemainingUses(nFeat, oPlayer))
                     + " uses remaining";
        }
        else
        {
            if (GetLocalInt(oPlayer, "PRC_SLA_Store") == nSlot)
                sTooltip += "armed; cast the spell you want to store";
            else
                sTooltip += "unassigned; click to arm this slot, then cast the spell to store";
        }

        json jEntry = NUISpellbookArchmageMakeEntry(
            oPlayer,
            NUI_SPELLBOOK_ARCHMAGE_ACTION_SLA,
            nFeat,
            nActionSpell,
            bAssigned ? nStoredSpell : nActionSpell,
            nDisplaySpell,
            0,
            nSlot,
            bPersonal,
            sTooltip
        );
        int nIndex = JsonGetLength(jMap);
        jMap = JsonArrayInsert(jMap, jEntry);
        jRow = JsonArrayInsert(jRow, NUISpellbookArchmageCreateButton(
            oPlayer, jEntry, nIndex
        ));
    }

    if (JsonGetLength(jRow) > 0)
        jRows = JsonArrayInsert(jRows, NuiRow(jRow));

    SetLocalJson(oPlayer, NUI_SPELLBOOK_ARCHMAGE_BUTTON_MAP_VAR, jMap);
    SetLocalInt(
        oPlayer,
        NUI_SPELLBOOK_ARCHMAGE_MAP_GENERATION_VAR,
        nGeneration
    );
    return jRows;
}

void NUISpellbookArchmageClearMap(object oPlayer)
{
    DeleteLocalJson(oPlayer, NUI_SPELLBOOK_ARCHMAGE_BUTTON_MAP_VAR);
    DeleteLocalInt(oPlayer, NUI_SPELLBOOK_ARCHMAGE_MAP_GENERATION_VAR);
}

int NUISpellbookArchmageGetActionIndex(string sElement)
{
    if (FindSubString(
            sElement,
            PRC_SPELLBOOK_NUI_ARCHMAGE_BUTTON_BASEID
        ) != 0)
        return -1;
    return StringToInt(RegExpReplace(
        PRC_SPELLBOOK_NUI_ARCHMAGE_BUTTON_BASEID,
        sElement,
        ""
    ));
}

int NUISpellbookArchmageValidateEntry(object oPlayer, json jEntry)
{
    if (jEntry == JsonNull()
        || GetLevelByClass(CLASS_TYPE_ARCHMAGE, oPlayer) <= 0
        || GetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_MODE_VAR)
            != PRC_SPELLBOOK_MODE_CLASS
        || GetLocalInt(oPlayer, PRC_SPELLBOOK_SELECTED_CLASSID_VAR)
            != CLASS_TYPE_ARCHMAGE)
        return FALSE;

    int nGeneration = JsonGetInt(JsonObjectGet(jEntry, "g"));
    if (nGeneration <= 0
        || nGeneration != GetLocalInt(
            oPlayer, PRC_SPELLBOOK_NUI_REFRESH_GENERATION_VAR
        )
        || nGeneration != GetLocalInt(
            oPlayer, NUI_SPELLBOOK_ARCHMAGE_MAP_GENERATION_VAR
        ))
        return FALSE;

    int nKind = JsonGetInt(JsonObjectGet(jEntry, "k"));
    int nFeat = JsonGetInt(JsonObjectGet(jEntry, "f"));
    int nActionSpell = JsonGetInt(JsonObjectGet(jEntry, "a"));
    int nTargetSpell = JsonGetInt(JsonObjectGet(jEntry, "s"));
    int nSubSpell = JsonGetInt(JsonObjectGet(jEntry, "u"));
    int nSlot = JsonGetInt(JsonObjectGet(jEntry, "q"));
    if (nFeat <= 0 || !GetHasFeat(nFeat, oPlayer)
        || StringToInt(Get2DACache("feat", "SPELLID", nFeat))
            != nActionSpell)
        return FALSE;

    if (nKind == NUI_SPELLBOOK_ARCHMAGE_ACTION_ELEMENT)
    {
        if (nFeat == NUI_SPELLBOOK_ARCHMAGE_MASTERY_ELEMENTS_OFF_FEAT)
            return GetHasFeat(
                    NUI_SPELLBOOK_ARCHMAGE_MASTERY_ELEMENTS_FEAT,
                    oPlayer
                )
                && nActionSpell == 2000
                && nTargetSpell == 2000
                && nSubSpell == 0;
        return nFeat == NUI_SPELLBOOK_ARCHMAGE_MASTERY_ELEMENTS_FEAT
            && nActionSpell == NUI_SPELLBOOK_ARCHMAGE_MASTERY_ELEMENTS_MASTER
            && nSubSpell >= 2001 && nSubSpell <= 2005
            && nTargetSpell == nSubSpell;
    }

    if (nKind == NUI_SPELLBOOK_ARCHMAGE_ACTION_SHAPING)
        return nFeat == FEAT_MASTERY_SHAPES
            && nActionSpell == NUI_SPELLBOOK_ARCHMAGE_MASTERY_SHAPING_SPELL
            && nTargetSpell == nActionSpell;

    if (nKind == NUI_SPELLBOOK_ARCHMAGE_ACTION_ARCANE_FIRE)
        return nFeat == FEAT_ARCANE_FIRE
            && nActionSpell == NUI_SPELLBOOK_ARCHMAGE_ARCANE_FIRE_SPELL
            && nTargetSpell == nActionSpell;

    if (nKind != NUI_SPELLBOOK_ARCHMAGE_ACTION_SLA
        || nSlot < 1 || nSlot > 5
        || nFeat != NUI_SPELLBOOK_ARCHMAGE_SLA_FIRST_FEAT + nSlot - 1
        || nActionSpell != NUI_SPELLBOOK_ARCHMAGE_SLA_FIRST_SPELL + nSlot - 1)
        return FALSE;

    int nStoredSpell = GetPersistantLocalInt(
        oPlayer,
        "PRC_SLA_SpellID_" + IntToString(nSlot)
    ) - 1;
    return (nStoredSpell < 0 && nTargetSpell == nActionSpell)
        || (nStoredSpell >= 0 && nTargetSpell == nStoredSpell);
}

json NUISpellbookArchmageGetValidatedEntry(object oPlayer, int nIndex)
{
    json jMap = GetLocalJson(
        oPlayer, NUI_SPELLBOOK_ARCHMAGE_BUTTON_MAP_VAR
    );
    if (jMap == JsonNull()
        || nIndex < 0
        || nIndex >= JsonGetLength(jMap))
        return JsonNull();

    json jEntry = JsonArrayGet(jMap, nIndex);
    return NUISpellbookArchmageValidateEntry(oPlayer, jEntry)
        ? jEntry : JsonNull();
}

void NUISpellbookArchmageClearPending(object oPlayer)
{
    DeleteLocalInt(oPlayer, NUI_SPELLBOOK_ARCHMAGE_PENDING_VAR);
    DeleteLocalJson(oPlayer, NUI_SPELLBOOK_ARCHMAGE_PENDING_ENTRY_VAR);
    DeleteLocalInt(oPlayer, NUI_SPELLBOOK_ARCHMAGE_PENDING_GENERATION_VAR);
}

int NUISpellbookArchmageSetPending(object oPlayer, json jEntry)
{
    if (!NUISpellbookArchmageValidateEntry(oPlayer, jEntry))
        return FALSE;
    SetLocalInt(oPlayer, NUI_SPELLBOOK_ARCHMAGE_PENDING_VAR, TRUE);
    SetLocalJson(oPlayer, NUI_SPELLBOOK_ARCHMAGE_PENDING_ENTRY_VAR, jEntry);
    SetLocalInt(
        oPlayer,
        NUI_SPELLBOOK_ARCHMAGE_PENDING_GENERATION_VAR,
        JsonGetInt(JsonObjectGet(jEntry, "g"))
    );
    return TRUE;
}

int NUISpellbookArchmageValidatePending(object oPlayer, int nFeat)
{
    if (!GetLocalInt(oPlayer, NUI_SPELLBOOK_ARCHMAGE_PENDING_VAR))
        return TRUE;
    json jEntry = GetLocalJson(
        oPlayer, NUI_SPELLBOOK_ARCHMAGE_PENDING_ENTRY_VAR
    );
    return JsonGetInt(JsonObjectGet(jEntry, "f")) == nFeat
        && NUISpellbookArchmageValidateEntry(oPlayer, jEntry);
}

string NUISpellbookArchmageGetStructuralSignature(object oPlayer)
{
    string sState = "E="
        + IntToString(GetLocalInt(oPlayer, "archmage_mastery_elements"))
        + "/" + GetLocalString(oPlayer, "archmage_mastery_elements_name")
        + ";H="
        + IntToString(GetLocalInt(oPlayer, "archmage_mastery_shaping"))
        + ";F="
        + IntToString(GetLocalInt(oPlayer, "arcane_fire_active"))
        + ";P=" + IntToString(NUISpellbookArchmageSpellPower(oPlayer))
        + ";A=" + IntToString(GetLocalInt(oPlayer, "PRC_SLA_Store"))
        + ";";

    int nSlot;
    for (nSlot = 1; nSlot <= 5; nSlot++)
    {
        int nFeat = NUI_SPELLBOOK_ARCHMAGE_SLA_FIRST_FEAT + nSlot - 1;
        sState += "S" + IntToString(nSlot) + "="
            + IntToString(GetHasFeat(nFeat, oPlayer)) + "/"
            + IntToString(GetPersistantLocalInt(
                oPlayer,
                "PRC_SLA_SpellID_" + IntToString(nSlot)
            )) + "/"
            + IntToString(GetPersistantLocalInt(
                oPlayer,
                "PRC_SLA_Class_" + IntToString(nSlot)
            )) + "/"
            + IntToString(GetPersistantLocalInt(
                oPlayer,
                "PRC_SLA_Meta_" + IntToString(nSlot)
            )) + "/"
            + IntToString(GetFeatRemainingUses(nFeat, oPlayer)) + ";";
    }
    return sState;
}
