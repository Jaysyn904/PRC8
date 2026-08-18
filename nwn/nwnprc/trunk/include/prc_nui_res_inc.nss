//::///////////////////////////////////////////////
//:: PRC Character Resource NUI - shared code
//:: prc_nui_res_inc
//:://////////////////////////////////////////////

#include "nw_inc_nui"
#include "prc_nui_consts"
#include "inc_newspellbook"
#include "psi_inc_ppoints"
#include "psi_inc_core"
#include "prc_feat_const"
#include "inc_epicspells"

// Psionic Focus is a radial master. 2836 is its stock "Gain Focus" child.
const int NUI_PRC_RESOURCE_FOCUS_GAIN_SPELL = 2836;

int NUIResourceUsesNewSpellbook(object oPC, int nClass)
{
    return persistant_array_exists(oPC, "NewSpellbookMem_" + IntToString(nClass));
}

int NUIResourceGetMaxSlotsFromState(
    object oPC,
    int nClass,
    int nSpellLevel,
    int nCasterLevel,
    int nAbility
)
{
    int nSlots = GetSlotCount(nCasterLevel, nSpellLevel, nAbility, nClass, oPC);
    return nSlots < 0 ? 0 : nSlots;
}

int NUIResourceGetMaxSlots(object oPC, int nClass, int nSpellLevel)
{
    // GetSpellslotLevel is authoritative for both PRC and native spellbooks;
    // it includes prestige advancement that a base class-level lookup misses.
    int nCasterLevel = GetSpellslotLevel(nClass, oPC);
    int nAbility = GetAbilityScoreForClass(nClass, oPC);
    return NUIResourceGetMaxSlotsFromState(
        oPC,
        nClass,
        nSpellLevel,
        nCasterLevel,
        nAbility
    );
}

int NUIResourceGetCurrentSlots(object oPC, int nClass, int nSpellLevel)
{
    int nSlots;

    if (NUIResourceUsesNewSpellbook(oPC, nClass))
    {
        nSlots = persistant_array_get_int(
            oPC,
            "NewSpellbookMem_" + IntToString(nClass),
            nSpellLevel
        );
    }
    else
    {
        // Core EE exposes class-specific uses through any spell known at the
        // requested level. This keeps native Bard/Sorcerer support portable.
        int nKnown = GetKnownSpellCount(oPC, nClass, nSpellLevel);
        if (nKnown <= 0)
            return 0;

        int nSpell = GetKnownSpellId(oPC, nClass, nSpellLevel, 0);
        if (nSpell < 0)
            return 0;

        nSlots = GetSpellUsesLeft(oPC, nClass, nSpell);
    }

    return nSlots < 0 ? 0 : nSlots;
}

int NUIResourceClassHasSpellSlots(object oPC, int nClass)
{
    if (GetSpellbookTypeForClass(nClass) != SPELLBOOK_TYPE_SPONTANEOUS)
        return FALSE;

    // Snapshot progression and casting ability once for this scan. Repeating
    // GetSpellslotLevel for every circle is expensive and floods PRC_DEBUG.
    int nCasterLevel = GetSpellslotLevel(nClass, oPC);
    int nAbility = GetAbilityScoreForClass(nClass, oPC);
    int nLevel;
    for (nLevel = 0; nLevel <= 9; nLevel++)
    {
        if (NUIResourceGetMaxSlotsFromState(
                oPC,
                nClass,
                nLevel,
                nCasterLevel,
                nAbility
            ) > 0)
            return TRUE;
    }

    return FALSE;
}

json NUIResourceGetSpontaneousClasses(object oPC)
{
    json jClasses = JsonArray();
    int nPosition = 1;
    int nClass = GetClassByPosition(nPosition, oPC);

    while (nClass != CLASS_TYPE_INVALID)
    {
        if (NUIResourceClassHasSpellSlots(oPC, nClass))
            jClasses = JsonArrayInsert(jClasses, JsonInt(nClass));

        nPosition++;
        nClass = GetClassByPosition(nPosition, oPC);
    }

    return jClasses;
}

string NUIResourceGetClassName(int nClass)
{
    int nName = StringToInt(Get2DACache("classes", "Name", nClass));
    return GetStringByStrRef(nName);
}

string NUIResourceGetSlotText(object oPC, int nClass)
{
    string sLowLevels;
    string sHighLevels;
    int nCasterLevel = GetSpellslotLevel(nClass, oPC);
    int nAbility = GetAbilityScoreForClass(nClass, oPC);
    int nLevel;

    for (nLevel = 0; nLevel <= 9; nLevel++)
    {
        int nMaximum = NUIResourceGetMaxSlotsFromState(
            oPC,
            nClass,
            nLevel,
            nCasterLevel,
            nAbility
        );
        if (nMaximum > 0)
        {
            string sEntry = "L" + IntToString(nLevel) + " "
                          + IntToString(NUIResourceGetCurrentSlots(oPC, nClass, nLevel))
                          + "/" + IntToString(nMaximum);

            if (nLevel <= 4)
            {
                if (sLowLevels != "")
                    sLowLevels += "   ";
                sLowLevels += sEntry;
            }
            else
            {
                if (sHighLevels != "")
                    sHighLevels += "   ";
                sHighLevels += sEntry;
            }
        }
    }

    if (sLowLevels != "" && sHighLevels != "")
        return sLowLevels + "\n" + sHighLevels;

    return sLowLevels + sHighLevels;
}

string NUIResourceGetCompactSlotBind(int nClass, int nSpellLevel)
{
    return NUI_PRC_RESOURCE_SB_SLOT_BIND_BASE
         + IntToString(nClass) + "_" + IntToString(nSpellLevel);
}

string NUIResourceGetCompactSlotText(object oPC, int nClass, int nSpellLevel)
{
    return "L" + IntToString(nSpellLevel) + " "
         + IntToString(NUIResourceGetCurrentSlots(oPC, nClass, nSpellLevel))
         + "/" + IntToString(NUIResourceGetMaxSlots(oPC, nClass, nSpellLevel));
}

int NUIResourceHasEpicSpells(object oPC)
{
    return GetHasFeat(FEAT_EPIC_SPELLCASTING, oPC) && GetIsEpicSpellcaster(oPC);
}

string NUIResourceGetEpicText(object oPC)
{
    return "Epic Spells " + IntToString(GetSpellSlots(oPC))
         + " / " + IntToString(GetEpicSpellSlotLimit(oPC));
}

json NUIResourceCreatePsionicRow()
{
    json jRow = JsonArray();

    json jFocus = NuiId(
        NuiButtonImage(JsonString("ife_psi_focus")),
        NUI_PRC_RESOURCE_FOCUS_BUTTON
    );
    jFocus = NuiWidth(jFocus, 42.0f);
    jFocus = NuiHeight(jFocus, 42.0f);
    jFocus = NuiEnabled(jFocus, NuiBind(NUI_PRC_RESOURCE_FOCUS_ENABLED_BIND));
    jFocus = NuiTooltip(jFocus, JsonString("Attempt to gain Psionic Focus"));
    jRow = JsonArrayInsert(jRow, jFocus);

    json jStatus = NuiId(
        NuiButton(NuiBind(NUI_PRC_RESOURCE_FOCUS_BIND)),
        NUI_PRC_RESOURCE_FOCUS_STATUS_BUTTON
    );
    jStatus = NuiWidth(jStatus, 105.0f);
    jStatus = NuiHeight(jStatus, 42.0f);
    jRow = JsonArrayInsert(jRow, jStatus);

    json jPP = NuiId(
        NuiButton(NuiBind(NUI_PRC_RESOURCE_PP_BIND)),
        NUI_PRC_RESOURCE_PP_BUTTON
    );
    jPP = NuiWidth(jPP, 155.0f);
    jPP = NuiHeight(jPP, 42.0f);
    jRow = JsonArrayInsert(jRow, jPP);

    return NuiRow(jRow);
}

json NUIResourceCreateSpellRow(int nClass)
{
    json jRow = JsonArray();

    string sIcon = Get2DACache("classes", "Icon", nClass);
    json jIcon = NuiImage(
        JsonString(sIcon),
        JsonInt(NUI_ASPECT_FIT),
        JsonInt(NUI_HALIGN_LEFT),
        JsonInt(NUI_VALIGN_MIDDLE)
    );
    jIcon = NuiWidth(jIcon, 28.0f);
    jIcon = NuiHeight(jIcon, 56.0f);
    jIcon = NuiTooltip(jIcon, JsonString(NUIResourceGetClassName(nClass)));
    jRow = JsonArrayInsert(jRow, jIcon);

    json jName = NuiText(JsonString(NUIResourceGetClassName(nClass)), FALSE, NUI_SCROLLBARS_NONE);
    jName = NuiWidth(jName, 135.0f);
    jName = NuiHeight(jName, 56.0f);
    jRow = JsonArrayInsert(jRow, jName);

    json jSlots = NuiText(
        NuiBind(NUI_PRC_RESOURCE_SLOT_BIND_BASE + IntToString(nClass)),
        FALSE,
        NUI_SCROLLBARS_NONE
    );
    jSlots = NuiWidth(jSlots, 470.0f);
    jSlots = NuiHeight(jSlots, 56.0f);
    jRow = JsonArrayInsert(jRow, jSlots);

    return NuiRow(jRow);
}

json NUIResourceAppendEpicControls(json jRow)
{
    string sIcon = Get2DACache("feat", "ICON", FEAT_EPIC_SPELLCASTING);

    json jIcon = NuiId(
        NuiButtonImage(JsonString(sIcon)),
        NUI_PRC_RESOURCE_EPIC_ICON_BUTTON
    );
    jIcon = NuiWidth(jIcon, 32.0f);
    jIcon = NuiHeight(jIcon, 32.0f);
    jIcon = NuiTooltip(jIcon, JsonString("Epic Spellcasting"));
    jRow = JsonArrayInsert(jRow, jIcon);

    json jEpic = NuiId(
        NuiButton(NuiBind(NUI_PRC_RESOURCE_EPIC_BIND)),
        NUI_PRC_RESOURCE_EPIC_BUTTON
    );
    jEpic = NuiWidth(jEpic, 170.0f);
    jEpic = NuiHeight(jEpic, 32.0f);
    jRow = JsonArrayInsert(jRow, jEpic);

    return jRow;
}

json NUIResourceCreateEpicRow()
{
    return NuiRow(NUIResourceAppendEpicControls(JsonArray()));
}

json NUIResourceCreateCompactSpellRow(int nClass)
{
    json jRow = JsonArray();
    int nCasterLevel = GetSpellslotLevel(nClass, OBJECT_SELF);
    int nAbility = GetAbilityScoreForClass(nClass, OBJECT_SELF);
    int nLevel;
    for (nLevel = 0; nLevel <= 9; nLevel++)
    {
        if (NUIResourceGetMaxSlotsFromState(
                OBJECT_SELF,
                nClass,
                nLevel,
                nCasterLevel,
                nAbility
            ) > 0)
        {
            string sSuffix = IntToString(nClass) + "_" + IntToString(nLevel);
            json jSlot = NuiId(
                NuiButton(NuiBind(NUIResourceGetCompactSlotBind(nClass, nLevel))),
                NUI_PRC_RESOURCE_SB_SLOT_BUTTON_BASE + sSuffix
            );
            jSlot = NuiWidth(jSlot, 62.0f);
            jSlot = NuiHeight(jSlot, 24.0f);
            jSlot = NuiTooltip(jSlot, JsonString(
                NUIResourceGetClassName(nClass) + " level " + IntToString(nLevel) + " spell slots"
            ));
            jRow = JsonArrayInsert(jRow, jSlot);
        }
    }

    return NuiRow(jRow);
}

json NUIResourceCreateSpellbookRows(object oPC, int nSelectedClass)
{
    json jRows = JsonArray();
    if (GetMaximumPowerPoints(oPC) > 0)
        jRows = JsonArrayInsert(jRows, NUIResourceCreatePsionicRow());

    json jClasses = NUIResourceGetSpontaneousClasses(oPC);
    int nClassCount = JsonGetLength(jClasses);
    int bShowClassLabels = nClassCount > 1;
    if (nClassCount == 1
        && JsonGetInt(JsonArrayGet(jClasses, 0)) != nSelectedClass)
        bShowClassLabels = TRUE;

    int i;
    for (i = 0; i < nClassCount; i++)
    {
        int nClass = JsonGetInt(JsonArrayGet(jClasses, i));
        if (bShowClassLabels)
        {
            json jLabelRow = JsonArray();
            json jLabel = NuiLabel(
                JsonString(NUIResourceGetClassName(nClass) + " Spell Slots"),
                JsonInt(NUI_HALIGN_LEFT),
                JsonInt(NUI_VALIGN_MIDDLE)
            );
            jLabel = NuiWidth(jLabel, 300.0f);
            jLabel = NuiHeight(jLabel, 22.0f);
            jLabelRow = JsonArrayInsert(jLabelRow, jLabel);
            jRows = JsonArrayInsert(jRows, NuiRow(jLabelRow));
        }

        jRows = JsonArrayInsert(jRows, NUIResourceCreateCompactSpellRow(nClass));
    }

    return jRows;
}

json NUIResourceCreateRows(object oPC)
{
    json jRows = JsonArray();
    if (GetMaximumPowerPoints(oPC) > 0)
        jRows = JsonArrayInsert(jRows, NUIResourceCreatePsionicRow());

    json jClasses = NUIResourceGetSpontaneousClasses(oPC);
    int i;
    for (i = 0; i < JsonGetLength(jClasses); i++)
    {
        int nClass = JsonGetInt(JsonArrayGet(jClasses, i));
        jRows = JsonArrayInsert(jRows, NUIResourceCreateSpellRow(nClass));
    }

    if (NUIResourceHasEpicSpells(oPC))
        jRows = JsonArrayInsert(jRows, NUIResourceCreateEpicRow());

    return jRows;
}

float NUIResourceGetLayoutHeight(object oPC)
{
    float fHeight;
    if (GetMaximumPowerPoints(oPC) > 0)
        fHeight += 44.0f;

    fHeight += IntToFloat(JsonGetLength(NUIResourceGetSpontaneousClasses(oPC)) * 58);

    if (NUIResourceHasEpicSpells(oPC))
        fHeight += 34.0f;

    return fHeight;
}

float NUIResourceGetSpellbookLayoutHeight(object oPC, int nSelectedClass)
{
    float fHeight;
    if (GetMaximumPowerPoints(oPC) > 0)
        fHeight += 44.0f;

    json jClasses = NUIResourceGetSpontaneousClasses(oPC);
    int nClassCount = JsonGetLength(jClasses);
    int bShowClassLabels = nClassCount > 1;
    if (nClassCount == 1
        && JsonGetInt(JsonArrayGet(jClasses, 0)) != nSelectedClass)
        bShowClassLabels = TRUE;

    fHeight += IntToFloat(nClassCount * 26);
    if (bShowClassLabels)
        fHeight += IntToFloat(nClassCount * 24);

    return fHeight;
}

void NUIResourceSetBindIfChanged(
    object oPC,
    int nToken,
    string sBind,
    json jValue
)
{
    if (JsonDump(NuiGetBind(oPC, nToken, sBind)) != JsonDump(jValue))
        NuiSetBind(oPC, nToken, sBind, jValue);
}

void NUIResourceRefreshTokenMode(
    object oPC,
    int nToken,
    int bFullSlots,
    int bCompactSlots
)
{
    if (!nToken)
        return;

    int nMaxPP = GetMaximumPowerPoints(oPC);
    if (nMaxPP > 0)
    {
        int bFocused = GetIsPsionicallyFocused(oPC);
        int nCurrentPP = GetCurrentPowerPoints(oPC);

        NUIResourceSetBindIfChanged(oPC, nToken, NUI_PRC_RESOURCE_PP_BIND,
            JsonString("PP " + IntToString(nCurrentPP) + " / " + IntToString(nMaxPP)));
        NUIResourceSetBindIfChanged(oPC, nToken, NUI_PRC_RESOURCE_FOCUS_BIND,
            JsonString(bFocused ? "Focused" : "Not focused"));
        NUIResourceSetBindIfChanged(oPC, nToken, NUI_PRC_RESOURCE_FOCUS_ENABLED_BIND,
            JsonBool(!bFocused && nCurrentPP > 0));
    }

    if (bFullSlots || bCompactSlots)
    {
        int nPosition = 1;
        int nClass = GetClassByPosition(nPosition, oPC);
        while (nClass != CLASS_TYPE_INVALID)
        {
            if (GetSpellbookTypeForClass(nClass) == SPELLBOOK_TYPE_SPONTANEOUS)
            {
                // One authoritative snapshot per class per refresh. Maxima are
                // still recomputed every second, so progression, ability, and
                // item-granted slot changes remain live.
                int nCasterLevel = GetSpellslotLevel(nClass, oPC);
                int nAbility = GetAbilityScoreForClass(nClass, oPC);
                int bHasSlots;
                string sLowLevels;
                string sHighLevels;
                int nLevel;

                for (nLevel = 0; nLevel <= 9; nLevel++)
                {
                    int nMaximum = NUIResourceGetMaxSlotsFromState(
                        oPC,
                        nClass,
                        nLevel,
                        nCasterLevel,
                        nAbility
                    );
                    if (nMaximum > 0)
                    {
                        bHasSlots = TRUE;
                        int nCurrent = NUIResourceGetCurrentSlots(
                            oPC,
                            nClass,
                            nLevel
                        );
                        string sEntry = "L" + IntToString(nLevel) + " "
                                      + IntToString(nCurrent) + "/"
                                      + IntToString(nMaximum);

                        if (bFullSlots)
                        {
                            if (nLevel <= 4)
                            {
                                if (sLowLevels != "")
                                    sLowLevels += "   ";
                                sLowLevels += sEntry;
                            }
                            else
                            {
                                if (sHighLevels != "")
                                    sHighLevels += "   ";
                                sHighLevels += sEntry;
                            }
                        }

                        if (bCompactSlots)
                            NUIResourceSetBindIfChanged(
                                oPC,
                                nToken,
                                NUIResourceGetCompactSlotBind(nClass, nLevel),
                                JsonString(sEntry)
                            );
                    }
                }

                if (bFullSlots && bHasSlots)
                {
                    string sSlots = sLowLevels;
                    if (sLowLevels != "" && sHighLevels != "")
                        sSlots += "\n";
                    sSlots += sHighLevels;

                    NUIResourceSetBindIfChanged(
                        oPC,
                        nToken,
                        NUI_PRC_RESOURCE_SLOT_BIND_BASE + IntToString(nClass),
                        JsonString(sSlots)
                    );
                }
            }

            nPosition++;
            nClass = GetClassByPosition(nPosition, oPC);
        }
    }

    if (NUIResourceHasEpicSpells(oPC))
        NUIResourceSetBindIfChanged(oPC, nToken, NUI_PRC_RESOURCE_EPIC_BIND,
            JsonString(NUIResourceGetEpicText(oPC)));
}

void NUIResourceRefreshToken(object oPC, int nToken)
{
    NUIResourceRefreshTokenMode(oPC, nToken, TRUE, TRUE);
}

void NUIResourceRefreshWindow(object oPC)
{
    NUIResourceRefreshTokenMode(
        oPC,
        NuiFindWindow(oPC, NUI_PRC_RESOURCE_WINDOW),
        TRUE,
        FALSE
    );
}

void NUIResourceRefreshLoop(object oPC, int nGeneration)
{
    if (GetLocalInt(oPC, NUI_PRC_RESOURCE_GENERATION_VAR) != nGeneration)
        return;

    if (!NuiFindWindow(oPC, NUI_PRC_RESOURCE_WINDOW))
        return;

    NUIResourceRefreshWindow(oPC);
    DelayCommand(1.0f, NUIResourceRefreshLoop(oPC, nGeneration));
}

void NUIResourceRefreshSpellbookLoop(object oPC, int nToken, int nGeneration)
{
    if (NuiFindWindow(oPC, PRC_SPELLBOOK_NUI_WINDOW_ID) != nToken
        || GetLocalInt(oPC, PRC_SPELLBOOK_NUI_REFRESH_GENERATION_VAR) != nGeneration)
        return;

    NUIResourceRefreshTokenMode(oPC, nToken, FALSE, TRUE);
    DelayCommand(1.0f, NUIResourceRefreshSpellbookLoop(oPC, nToken, nGeneration));
}
