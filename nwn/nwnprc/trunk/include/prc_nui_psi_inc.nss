//::///////////////////////////////////////////////
//:: PRC psionic configuration NUI helpers
//:: prc_nui_psi_inc
//:://////////////////////////////////////////////
/**
 * Standalone, embeddable NUI controls for the existing PRC psionic toggles.
 *
 * This module deliberately uses the same locals, persistent switches, profile
 * encoder, and level gates as the legacy radial/conversation scripts.  It does
 * not replace those scripts.  Call NUISpellbookPsiCreatePanel() once while
 * building a layout, then pass left-button mouseup element ids to
 * NUISpellbookPsiHandleAction().
 */

#include "prc_nui_psi_cst"
#include "psi_inc_augment"
#include "nw_inc_nui"

int NUISpellbookPsiHasContent(object oPC)
{
    return GetIsPsionicCharacter(oPC)
        || GetLevelByClass(CLASS_TYPE_WILDER, oPC) > 0
        || GetHasFeat(FEAT_OVERCHANNEL, oPC)
        || GetLocalInt(oPC, PRC_WILD_SURGE) != 0
        || GetLocalInt(oPC, PRC_OVERCHANNEL) != 0;
}

int NUISpellbookPsiNextGeneration(object oPC)
{
    int nGeneration = GetLocalInt(oPC, PRC_NUI_PSI_GENERATION_VAR) + 1;
    if (nGeneration <= 0)
        nGeneration = 1;
    SetLocalInt(oPC, PRC_NUI_PSI_GENERATION_VAR, nGeneration);
    return nGeneration;
}

string NUISpellbookPsiStampValue(
    string sBase,
    int nValue,
    int nGeneration
)
{
    return sBase + IntToString(nValue)
         + PRC_NUI_PSI_GENERATION_MARKER + IntToString(nGeneration);
}

int NUISpellbookPsiElementGeneration(string sElement)
{
    int nMarker = FindSubString(sElement, PRC_NUI_PSI_GENERATION_MARKER);
    if (nMarker < 0)
        return 0;
    string sGeneration = GetSubString(
        sElement,
        nMarker + GetStringLength(PRC_NUI_PSI_GENERATION_MARKER),
        GetStringLength(sElement)
    );
    if (sGeneration == ""
        || IntToString(StringToInt(sGeneration)) != sGeneration)
        return 0;
    return StringToInt(sGeneration);
}

int NUISpellbookPsiElementValue(string sElement, string sBase)
{
    int nMarker = FindSubString(sElement, PRC_NUI_PSI_GENERATION_MARKER);
    if (FindSubString(sElement, sBase) != 0 || nMarker < 0)
        return -1;
    string sValue = GetSubString(
        sElement,
        GetStringLength(sBase),
        nMarker - GetStringLength(sBase)
    );
    if (sValue == "" || IntToString(StringToInt(sValue)) != sValue)
        return -1;
    return StringToInt(sValue);
}

int NUISpellbookPsiIsActionElement(string sElement)
{
    return FindSubString(sElement, PRC_NUI_PSI_ID_PREFIX) == 0;
}

int NUISpellbookPsiEditorKind(object oPC)
{
    int nKind = GetLocalInt(oPC, PRC_NUI_PSI_EDITOR_KIND_VAR);
    if (nKind != PRC_NUI_PSI_EDIT_QUICK)
        nKind = PRC_NUI_PSI_EDIT_PROFILE;
    return nKind;
}

int NUISpellbookPsiEditorIndex(object oPC, int nKind)
{
    int nIndex = GetLocalInt(oPC, PRC_NUI_PSI_EDITOR_INDEX_VAR);
    int nMaximum = nKind == PRC_NUI_PSI_EDIT_QUICK
        ? PRC_AUGMENT_QUICKSELECTION_MAX
        : PRC_AUGMENT_PROFILE_INDEX_MAX;
    if (nIndex < 1 || nIndex > nMaximum)
    {
        int nCurrent = GetLocalInt(oPC, PRC_CURRENT_AUGMENT_PROFILE);
        if (nKind == PRC_NUI_PSI_EDIT_PROFILE
            && nCurrent >= PRC_AUGMENT_PROFILE_INDEX_MIN
            && nCurrent <= PRC_AUGMENT_PROFILE_INDEX_MAX)
            nIndex = nCurrent;
        else if (nKind == PRC_NUI_PSI_EDIT_QUICK
            && nCurrent <= -PRC_AUGMENT_QUICKSELECTION_MIN
            && nCurrent >= -PRC_AUGMENT_QUICKSELECTION_MAX)
            nIndex = -nCurrent;
        else
            nIndex = 1;
        SetLocalInt(oPC, PRC_NUI_PSI_EDITOR_INDEX_VAR, nIndex);
    }
    return nIndex;
}

int NUISpellbookPsiWildSurgeMaximum(object oPC)
{
    int nWilderLevel = GetLevelByClass(CLASS_TYPE_WILDER, oPC);
    if (nWilderLevel <= 0)
        return 0;
    int nMaximum = nWilderLevel < 3
        ? 1
        : ((nWilderLevel + 1) / 4) + 1;
    if (nMaximum > 11)
        nMaximum = 11;
    return nMaximum;
}

string NUISpellbookPsiValidateProfileSelection(object oPC, int nSelection)
{
    if (!GetIsPC(oPC) || !GetIsPsionicCharacter(oPC))
        return "Psionic manifestation is required to change augmentation settings.";
    if (nSelection == PRC_AUGMENT_PROFILE_NONE)
        return "";
    if (nSelection >= PRC_AUGMENT_PROFILE_INDEX_MIN
        && nSelection <= PRC_AUGMENT_PROFILE_INDEX_MAX)
        return "";
    int nQuick = nSelection - PRC_NUI_PSI_QUICK_ACTION_BASE;
    if (nQuick >= PRC_AUGMENT_QUICKSELECTION_MIN
        && nQuick <= PRC_AUGMENT_QUICKSELECTION_MAX)
        return "";
    return "That augmentation profile is not valid.";
}

string NUISpellbookPsiValidateWildSurge(object oPC, int nLevel)
{
    if (!GetIsPC(oPC) || !GetIsPsionicCharacter(oPC))
        return "Psionic manifestation is required to change Wild Surge.";
    if (nLevel < 0 || nLevel > 11)
        return "That Wild Surge level is not valid.";
    if (nLevel == 0)
        return "";
    if (GetLevelByClass(CLASS_TYPE_WILDER, oPC) <= 0
        || nLevel > NUISpellbookPsiWildSurgeMaximum(oPC))
        return GetStringByStrRef(16824027);
    if (GetLocalInt(oPC, PRC_OVERCHANNEL))
        return GetStringByStrRef(16824026);
    return "";
}

string NUISpellbookPsiValidateOverchannel(object oPC, int nLevel)
{
    if (!GetIsPC(oPC) || !GetIsPsionicCharacter(oPC))
        return "Psionic manifestation is required to change Overchannel.";
    if (nLevel < 0 || nLevel > 3)
        return "That Overchannel level is not valid.";
    // Clearing a stranded local is harmless even if the feat was removed.
    if (nLevel == 0)
        return "";
    if (!GetHasFeat(FEAT_OVERCHANNEL, oPC))
        return "You do not have the Overchannel feat.";
    if (GetLocalInt(oPC, PRC_WILD_SURGE))
        return GetStringByStrRef(16824029);
    if (nLevel == 2 && GetHitDice(oPC) < 8)
        return GetStringByStrRef(16824031);
    if (nLevel == 3 && GetHitDice(oPC) < 15)
        return GetStringByStrRef(16824033);
    return "";
}

int NUISpellbookPsiProfileOption(
    struct user_augment_profile uap,
    int nOption
)
{
    if (nOption == 1) return uap.nOption_1;
    if (nOption == 2) return uap.nOption_2;
    if (nOption == 3) return uap.nOption_3;
    if (nOption == 4) return uap.nOption_4;
    if (nOption == 5) return uap.nOption_5;
    return 0;
}

struct user_augment_profile NUISpellbookPsiSetProfileOption(
    struct user_augment_profile uap,
    int nOption,
    int nValue
)
{
    if (nValue < 0)
        nValue = 0;
    else if (nValue > 63)
        nValue = 63;
    if (nOption == 1) uap.nOption_1 = nValue;
    else if (nOption == 2) uap.nOption_2 = nValue;
    else if (nOption == 3) uap.nOption_3 = nValue;
    else if (nOption == 4) uap.nOption_4 = nValue;
    else if (nOption == 5) uap.nOption_5 = nValue;
    return uap;
}

int NUISpellbookPsiApplySimpleDefaults(object oPC)
{
    if (!GetIsPC(oPC) || !GetIsPsionicCharacter(oPC))
        return FALSE;

    struct user_augment_profile uap;
    uap.nOption_1 = 0;
    uap.nOption_2 = 0;
    uap.nOption_3 = 0;
    uap.nOption_4 = 0;
    uap.nOption_5 = 0;

    int i;
    for (i = PRC_AUGMENT_PROFILE_INDEX_MIN;
         i <= PRC_AUGMENT_PROFILE_INDEX_MAX;
         i++)
    {
        uap.nOption_1 = i;
        StoreUserAugmentationProfile(oPC, i, uap, FALSE);
    }
    return TRUE;
}

string NUISpellbookPsiProfileShort(
    struct user_augment_profile uap
)
{
    return IntToString(uap.nOption_1) + "/"
         + IntToString(uap.nOption_2) + "/"
         + IntToString(uap.nOption_3) + "/"
         + IntToString(uap.nOption_4) + "/"
         + IntToString(uap.nOption_5);
}

string NUISpellbookPsiCurrentSummary(object oPC)
{
    int nCurrent = GetLocalInt(oPC, PRC_CURRENT_AUGMENT_PROFILE);
    if (nCurrent == PRC_AUGMENT_PROFILE_NONE)
        return "Current augmentation: Off";
    int bQuick = nCurrent < 0;
    int nIndex = bQuick ? -nCurrent : nCurrent;
    if ((!bQuick && (nIndex < PRC_AUGMENT_PROFILE_INDEX_MIN
                  || nIndex > PRC_AUGMENT_PROFILE_INDEX_MAX))
        || (bQuick && (nIndex < PRC_AUGMENT_QUICKSELECTION_MIN
                    || nIndex > PRC_AUGMENT_QUICKSELECTION_MAX)))
        return "Current augmentation: invalid legacy selection";
    struct user_augment_profile uap = GetUserAugmentationProfile(
        oPC, nIndex, bQuick
    );
    return "Current augmentation: "
         + (bQuick ? "Quick " : "Profile ") + IntToString(nIndex)
         + " [" + NUISpellbookPsiProfileShort(uap) + "]";
}

void NUISpellbookPsiReport(object oPC, string sMessage)
{
    if (sMessage != "")
        SendMessageToPC(oPC, sMessage);
}

int NUISpellbookPsiSetCurrent(object oPC, int nSelection)
{
    string sError = NUISpellbookPsiValidateProfileSelection(oPC, nSelection);
    if (sError != "")
    {
        NUISpellbookPsiReport(oPC, sError);
        return FALSE;
    }
    if (nSelection == PRC_AUGMENT_PROFILE_NONE)
    {
        SetLocalInt(oPC, PRC_CURRENT_AUGMENT_PROFILE, 0);
        SetLocalInt(oPC, PRC_AUGMENT_MAXAUGMENT, FALSE);
        FloatingTextStrRefOnCreature(16823588, oPC, FALSE);
        return TRUE;
    }

    int bQuick = nSelection > PRC_NUI_PSI_QUICK_ACTION_BASE;
    int nIndex = bQuick
        ? nSelection - PRC_NUI_PSI_QUICK_ACTION_BASE
        : nSelection;
    SetLocalInt(
        oPC,
        PRC_CURRENT_AUGMENT_PROFILE,
        bQuick ? -nIndex : nIndex
    );
    FloatingTextStringOnCreature(
        GetStringByStrRef(16823589) + " - "
        + UserAugmentationProfileToString(
            GetUserAugmentationProfile(oPC, nIndex, bQuick)
        ),
        oPC,
        FALSE
    );
    return TRUE;
}

int NUISpellbookPsiSetWildSurge(object oPC, int nLevel)
{
    string sError = NUISpellbookPsiValidateWildSurge(oPC, nLevel);
    if (sError != "")
    {
        NUISpellbookPsiReport(oPC, sError);
        return FALSE;
    }
    SetLocalInt(oPC, PRC_WILD_SURGE, nLevel);
    if (nLevel == 0)
        FloatingTextStrRefOnCreature(16823612, oPC, FALSE);
    else
    {
        int nSpell = 2379 + nLevel;
        FloatingTextStringOnCreature(
            GetStringByStrRef(StringToInt(Get2DACache(
                "spells", "Name", nSpell
            ))),
            oPC,
            FALSE
        );
    }
    return TRUE;
}

int NUISpellbookPsiSetOverchannel(object oPC, int nLevel)
{
    string sError = NUISpellbookPsiValidateOverchannel(oPC, nLevel);
    if (sError != "")
    {
        NUISpellbookPsiReport(oPC, sError);
        return FALSE;
    }
    SetLocalInt(oPC, PRC_OVERCHANNEL, nLevel);
    if (nLevel == 0)
        FloatingTextStrRefOnCreature(16824034, oPC, FALSE);
    else if (nLevel == 1)
        FloatingTextStrRefOnCreature(16824028, oPC, FALSE);
    else if (nLevel == 2)
        FloatingTextStrRefOnCreature(16824030, oPC, FALSE);
    else
        FloatingTextStrRefOnCreature(16824032, oPC, FALSE);
    return TRUE;
}

/**
 * Handles one generation-stamped left-click action.
 *
 * Return values are PRC_NUI_PSI_ACTION_NONE, _HANDLED, or _REFRESH.  Invalid
 * and stale ids are consumed without mutating state.  The optional expected
 * generation lets an enclosing window impose the same fence as this module.
 */
int NUISpellbookPsiHandleAction(
    object oPC,
    string sElement,
    int nExpectedGeneration = 0
)
{
    if (!NUISpellbookPsiIsActionElement(sElement))
        return PRC_NUI_PSI_ACTION_NONE;
    if (nExpectedGeneration <= 0)
        nExpectedGeneration = GetLocalInt(oPC, PRC_NUI_PSI_GENERATION_VAR);
    int nGeneration = NUISpellbookPsiElementGeneration(sElement);
    if (nGeneration <= 0 || nGeneration != nExpectedGeneration
        || nGeneration != GetLocalInt(oPC, PRC_NUI_PSI_GENERATION_VAR))
        return PRC_NUI_PSI_ACTION_HANDLED;
    if (!GetIsPC(oPC) || !NUISpellbookPsiHasContent(oPC))
        return PRC_NUI_PSI_ACTION_HANDLED;

    int nValue;
    if (FindSubString(sElement, PRC_NUI_PSI_USE_BUTTON) == 0)
    {
        nValue = NUISpellbookPsiElementValue(
            sElement, PRC_NUI_PSI_USE_BUTTON
        );
        return NUISpellbookPsiSetCurrent(oPC, nValue)
            ? PRC_NUI_PSI_ACTION_REFRESH
            : PRC_NUI_PSI_ACTION_HANDLED;
    }
    if (FindSubString(sElement, PRC_NUI_PSI_EDIT_KIND_BUTTON) == 0)
    {
        nValue = NUISpellbookPsiElementValue(
            sElement, PRC_NUI_PSI_EDIT_KIND_BUTTON
        );
        if (nValue != PRC_NUI_PSI_EDIT_PROFILE
            && nValue != PRC_NUI_PSI_EDIT_QUICK)
            return PRC_NUI_PSI_ACTION_HANDLED;
        DeleteLocalInt(oPC, PRC_NUI_PSI_DEFAULT_CONFIRM_VAR);
        SetLocalInt(oPC, PRC_NUI_PSI_EDITOR_KIND_VAR, nValue);
        int nIndex = GetLocalInt(oPC, PRC_NUI_PSI_EDITOR_INDEX_VAR);
        int nMaximum = nValue == PRC_NUI_PSI_EDIT_QUICK ? 7 : 49;
        if (nIndex < 1 || nIndex > nMaximum)
            SetLocalInt(oPC, PRC_NUI_PSI_EDITOR_INDEX_VAR, 1);
        return PRC_NUI_PSI_ACTION_REFRESH;
    }
    if (FindSubString(sElement, PRC_NUI_PSI_EDIT_INDEX_BUTTON) == 0)
    {
        nValue = NUISpellbookPsiElementValue(
            sElement, PRC_NUI_PSI_EDIT_INDEX_BUTTON
        );
        int nKind = NUISpellbookPsiEditorKind(oPC);
        int nMaximum = nKind == PRC_NUI_PSI_EDIT_QUICK ? 7 : 49;
        if (nValue < 1 || nValue > nMaximum)
            return PRC_NUI_PSI_ACTION_HANDLED;
        DeleteLocalInt(oPC, PRC_NUI_PSI_DEFAULT_CONFIRM_VAR);
        SetLocalInt(oPC, PRC_NUI_PSI_EDITOR_INDEX_VAR, nValue);
        return PRC_NUI_PSI_ACTION_REFRESH;
    }
    if (FindSubString(sElement, PRC_NUI_PSI_OPTION_DOWN_BUTTON) == 0
        || FindSubString(sElement, PRC_NUI_PSI_OPTION_UP_BUTTON) == 0)
    {
        int bUp = FindSubString(
            sElement, PRC_NUI_PSI_OPTION_UP_BUTTON
        ) == 0;
        string sBase = bUp
            ? PRC_NUI_PSI_OPTION_UP_BUTTON
            : PRC_NUI_PSI_OPTION_DOWN_BUTTON;
        int nOption = NUISpellbookPsiElementValue(sElement, sBase);
        if (nOption < 1 || nOption > 5
            || !GetIsPsionicCharacter(oPC))
            return PRC_NUI_PSI_ACTION_HANDLED;
        int nKind = NUISpellbookPsiEditorKind(oPC);
        int nIndex = NUISpellbookPsiEditorIndex(oPC, nKind);
        int bQuick = nKind == PRC_NUI_PSI_EDIT_QUICK;
        struct user_augment_profile uap = GetUserAugmentationProfile(
            oPC, nIndex, bQuick
        );
        int nOld = NUISpellbookPsiProfileOption(uap, nOption);
        if ((!bUp && nOld <= 0) || (bUp && nOld >= 63))
            return PRC_NUI_PSI_ACTION_HANDLED;
        uap = NUISpellbookPsiSetProfileOption(
            uap, nOption, nOld + (bUp ? 1 : -1)
        );
        StoreUserAugmentationProfile(oPC, nIndex, uap, bQuick);
        return PRC_NUI_PSI_ACTION_REFRESH;
    }
    if (FindSubString(sElement, PRC_NUI_PSI_CLEAR_BUTTON) == 0)
    {
        nValue = NUISpellbookPsiElementValue(
            sElement, PRC_NUI_PSI_CLEAR_BUTTON
        );
        if (nValue != 0 || !GetIsPsionicCharacter(oPC))
            return PRC_NUI_PSI_ACTION_HANDLED;
        int nKind = NUISpellbookPsiEditorKind(oPC);
        int nIndex = NUISpellbookPsiEditorIndex(oPC, nKind);
        struct user_augment_profile uap;
        StoreUserAugmentationProfile(
            oPC, nIndex, uap, nKind == PRC_NUI_PSI_EDIT_QUICK
        );
        return PRC_NUI_PSI_ACTION_REFRESH;
    }
    if (FindSubString(sElement, PRC_NUI_PSI_VALUE_MODE_BUTTON) == 0)
    {
        nValue = NUISpellbookPsiElementValue(
            sElement, PRC_NUI_PSI_VALUE_MODE_BUTTON
        );
        if ((nValue != FALSE && nValue != TRUE)
            || !GetIsPsionicCharacter(oPC))
            return PRC_NUI_PSI_ACTION_HANDLED;
        SetPersistantLocalInt(oPC, PRC_PLAYER_SWITCH_AUGMENT_IS_PP, nValue);
        return PRC_NUI_PSI_ACTION_REFRESH;
    }
    if (FindSubString(sElement, PRC_NUI_PSI_AUTOMETA_BUTTON) == 0)
    {
        nValue = NUISpellbookPsiElementValue(
            sElement, PRC_NUI_PSI_AUTOMETA_BUTTON
        );
        if ((nValue != FALSE && nValue != TRUE)
            || !GetIsPsionicCharacter(oPC))
            return PRC_NUI_PSI_ACTION_HANDLED;
        SetPersistantLocalInt(oPC, PRC_PLAYER_SWITCH_AUTOMETAPSI, nValue);
        return PRC_NUI_PSI_ACTION_REFRESH;
    }
    if (FindSubString(sElement, PRC_NUI_PSI_MAX_BUTTON) == 0)
    {
        nValue = NUISpellbookPsiElementValue(
            sElement, PRC_NUI_PSI_MAX_BUTTON
        );
        if ((nValue != FALSE && nValue != TRUE)
            || !GetIsPsionicCharacter(oPC))
            return PRC_NUI_PSI_ACTION_HANDLED;
        SetLocalInt(oPC, PRC_AUGMENT_MAXAUGMENT, nValue);
        FloatingTextStringOnCreature(
            GetStringByStrRef(16823677) + " "
            + GetStringByStrRef(nValue ? 63798 : 63799),
            oPC,
            FALSE
        );
        return PRC_NUI_PSI_ACTION_REFRESH;
    }
    if (FindSubString(sElement, PRC_NUI_PSI_SURGE_BUTTON) == 0)
    {
        nValue = NUISpellbookPsiElementValue(
            sElement, PRC_NUI_PSI_SURGE_BUTTON
        );
        return NUISpellbookPsiSetWildSurge(oPC, nValue)
            ? PRC_NUI_PSI_ACTION_REFRESH
            : PRC_NUI_PSI_ACTION_HANDLED;
    }
    if (FindSubString(sElement, PRC_NUI_PSI_OVERCHANNEL_BUTTON) == 0)
    {
        nValue = NUISpellbookPsiElementValue(
            sElement, PRC_NUI_PSI_OVERCHANNEL_BUTTON
        );
        return NUISpellbookPsiSetOverchannel(oPC, nValue)
            ? PRC_NUI_PSI_ACTION_REFRESH
            : PRC_NUI_PSI_ACTION_HANDLED;
    }
    if (FindSubString(sElement, PRC_NUI_PSI_DEFAULT_CONFIRM_BUTTON) == 0)
    {
        nValue = NUISpellbookPsiElementValue(
            sElement, PRC_NUI_PSI_DEFAULT_CONFIRM_BUTTON
        );
        if (nValue != 0 || !GetIsPsionicCharacter(oPC)
            || !GetLocalInt(oPC, PRC_NUI_PSI_DEFAULT_CONFIRM_VAR))
            return PRC_NUI_PSI_ACTION_HANDLED;
        if (!NUISpellbookPsiApplySimpleDefaults(oPC))
            return PRC_NUI_PSI_ACTION_HANDLED;
        DeleteLocalInt(oPC, PRC_NUI_PSI_DEFAULT_CONFIRM_VAR);
        return PRC_NUI_PSI_ACTION_REFRESH;
    }
    if (FindSubString(sElement, PRC_NUI_PSI_DEFAULT_CANCEL_BUTTON) == 0)
    {
        nValue = NUISpellbookPsiElementValue(
            sElement, PRC_NUI_PSI_DEFAULT_CANCEL_BUTTON
        );
        if (nValue != 0
            || !GetLocalInt(oPC, PRC_NUI_PSI_DEFAULT_CONFIRM_VAR))
            return PRC_NUI_PSI_ACTION_HANDLED;
        DeleteLocalInt(oPC, PRC_NUI_PSI_DEFAULT_CONFIRM_VAR);
        return PRC_NUI_PSI_ACTION_REFRESH;
    }
    if (FindSubString(sElement, PRC_NUI_PSI_DEFAULT_BUTTON) == 0)
    {
        nValue = NUISpellbookPsiElementValue(
            sElement, PRC_NUI_PSI_DEFAULT_BUTTON
        );
        if (nValue != 0 || !GetIsPsionicCharacter(oPC))
            return PRC_NUI_PSI_ACTION_HANDLED;
        SetLocalInt(oPC, PRC_NUI_PSI_DEFAULT_CONFIRM_VAR, TRUE);
        return PRC_NUI_PSI_ACTION_REFRESH;
    }
    if (FindSubString(sElement, PRC_NUI_PSI_LEGACY_BUTTON) == 0)
    {
        nValue = NUISpellbookPsiElementValue(
            sElement, PRC_NUI_PSI_LEGACY_BUTTON
        );
        if (nValue != 0 || !GetIsPsionicCharacter(oPC))
            return PRC_NUI_PSI_ACTION_HANDLED;
        ExecuteScript("psi_aug_strtconv", oPC);
        return PRC_NUI_PSI_ACTION_HANDLED;
    }
    return PRC_NUI_PSI_ACTION_HANDLED;
}

json NUISpellbookPsiHeader(string sText)
{
    json jLabel = NuiLabel(
        JsonString(sText),
        JsonInt(NUI_HALIGN_LEFT),
        JsonInt(NUI_VALIGN_MIDDLE)
    );
    jLabel = NuiHeight(jLabel, 28.0f);
    return NuiStyleForegroundColor(jLabel, NuiColor(220, 185, 105));
}

json NUISpellbookPsiLabel(string sText, float fWidth)
{
    json jLabel = NuiLabel(
        JsonString(sText),
        JsonInt(NUI_HALIGN_CENTER),
        JsonInt(NUI_VALIGN_MIDDLE)
    );
    jLabel = NuiWidth(jLabel, fWidth);
    return NuiHeight(jLabel, 32.0f);
}

json NUISpellbookPsiButton(
    string sLabel,
    string sBase,
    int nValue,
    int nGeneration,
    float fWidth,
    int bEnabled,
    int bSelected = FALSE
)
{
    json jButton = NuiId(
        NuiButton(JsonString(sLabel)),
        NUISpellbookPsiStampValue(sBase, nValue, nGeneration)
    );
    jButton = NuiWidth(jButton, fWidth);
    jButton = NuiHeight(jButton, 34.0f);
    jButton = NuiMargin(jButton, 1.0f);
    jButton = NuiEnabled(jButton, JsonBool(bEnabled));
    if (bSelected)
        jButton = NuiEncouraged(jButton, JsonBool(TRUE));
    return jButton;
}

json NUISpellbookPsiEditor(object oPC, int nGeneration)
{
    int nKind = NUISpellbookPsiEditorKind(oPC);
    int nIndex = NUISpellbookPsiEditorIndex(oPC, nKind);
    int bQuick = nKind == PRC_NUI_PSI_EDIT_QUICK;
    int nMaximum = bQuick ? 7 : 49;
    struct user_augment_profile uap = GetUserAugmentationProfile(
        oPC, nIndex, bQuick
    );

    json jChildren = JsonArray();
    json jSelector = JsonArray();
    jSelector = JsonArrayInsert(jSelector, NUISpellbookPsiButton(
        "Profiles", PRC_NUI_PSI_EDIT_KIND_BUTTON,
        PRC_NUI_PSI_EDIT_PROFILE, nGeneration, 100.0f, TRUE, !bQuick
    ));
    jSelector = JsonArrayInsert(jSelector, NUISpellbookPsiButton(
        "Quick sets", PRC_NUI_PSI_EDIT_KIND_BUTTON,
        PRC_NUI_PSI_EDIT_QUICK, nGeneration, 100.0f, TRUE, bQuick
    ));
    jSelector = JsonArrayInsert(jSelector, NUISpellbookPsiButton(
        "<", PRC_NUI_PSI_EDIT_INDEX_BUTTON,
        nIndex > 1 ? nIndex - 1 : nMaximum,
        nGeneration, 42.0f, TRUE
    ));
    jSelector = JsonArrayInsert(
        jSelector,
        NUISpellbookPsiLabel(
            (bQuick ? "Quick " : "Profile ") + IntToString(nIndex),
            112.0f
        )
    );
    jSelector = JsonArrayInsert(jSelector, NUISpellbookPsiButton(
        ">", PRC_NUI_PSI_EDIT_INDEX_BUTTON,
        nIndex < nMaximum ? nIndex + 1 : 1,
        nGeneration, 42.0f, TRUE
    ));
    jSelector = JsonArrayInsert(jSelector, NUISpellbookPsiButton(
        "Use this", PRC_NUI_PSI_USE_BUTTON,
        bQuick ? PRC_NUI_PSI_QUICK_ACTION_BASE + nIndex : nIndex,
        nGeneration, 100.0f, TRUE,
        GetLocalInt(oPC, PRC_CURRENT_AUGMENT_PROFILE)
            == (bQuick ? -nIndex : nIndex)
    ));
    jSelector = JsonArrayInsert(jSelector, NUISpellbookPsiButton(
        "Clear", PRC_NUI_PSI_CLEAR_BUTTON,
        0, nGeneration, 78.0f, TRUE
    ));
    jChildren = JsonArrayInsert(jChildren, NuiRow(jSelector));

    json jOptions = JsonArray();
    int nOption;
    for (nOption = 1; nOption <= 5; nOption++)
    {
        int nCurrent = NUISpellbookPsiProfileOption(uap, nOption);
        json jOption = JsonArray();
        jOption = JsonArrayInsert(
            jOption,
            NUISpellbookPsiLabel("Option " + IntToString(nOption), 110.0f)
        );
        json jCounter = JsonArray();
        jCounter = JsonArrayInsert(jCounter, NUISpellbookPsiButton(
            "-", PRC_NUI_PSI_OPTION_DOWN_BUTTON,
            nOption, nGeneration, 34.0f, nCurrent > 0
        ));
        jCounter = JsonArrayInsert(
            jCounter,
            NUISpellbookPsiLabel(IntToString(nCurrent), 42.0f)
        );
        jCounter = JsonArrayInsert(jCounter, NUISpellbookPsiButton(
            "+", PRC_NUI_PSI_OPTION_UP_BUTTON,
            nOption, nGeneration, 34.0f, nCurrent < 63
        ));
        jOption = JsonArrayInsert(jOption, NuiRow(jCounter));
        json jColumn = NuiCol(jOption);
        jColumn = NuiWidth(jColumn, 116.0f);
        jOptions = JsonArrayInsert(jOptions, jColumn);
    }
    jChildren = JsonArrayInsert(jChildren, NuiRow(jOptions));
    return NuiCol(jChildren);
}

json NUISpellbookPsiAugmentSettings(object oPC, int nGeneration)
{
    int bPP = GetPersistantLocalInt(
        oPC, PRC_PLAYER_SWITCH_AUGMENT_IS_PP
    ) != 0;
    int bAutometa = GetPersistantLocalInt(
        oPC, PRC_PLAYER_SWITCH_AUTOMETAPSI
    ) != 0;
    int bMaximum = GetLocalInt(oPC, PRC_AUGMENT_MAXAUGMENT) != 0;

    json jSettings = JsonArray();
    jSettings = JsonArrayInsert(
        jSettings,
        NUISpellbookPsiLabel("Values mean", 96.0f)
    );
    json jLevels = NUISpellbookPsiButton(
        "Uses", PRC_NUI_PSI_VALUE_MODE_BUTTON,
        FALSE, nGeneration, 76.0f, TRUE, !bPP
    );
    jLevels = NuiTooltip(jLevels, JsonString(
        "Each option value is the number of times to apply that augmentation."
    ));
    jSettings = JsonArrayInsert(jSettings, jLevels);
    json jPP = NUISpellbookPsiButton(
        "PP", PRC_NUI_PSI_VALUE_MODE_BUTTON,
        TRUE, nGeneration, 64.0f, TRUE, bPP
    );
    jPP = NuiTooltip(jPP, JsonString(
        "Each option value is a PP budget divided by that option's PP cost."
    ));
    jSettings = JsonArrayInsert(jSettings, jPP);
    json jAutometa = NUISpellbookPsiButton(
        "Autometa: " + (bAutometa ? "On" : "Off"),
        PRC_NUI_PSI_AUTOMETA_BUTTON,
        !bAutometa, nGeneration, 136.0f, TRUE, bAutometa
    );
    jAutometa = NuiTooltip(jAutometa, JsonString(
        "When on, eligible metapsionics other than Quicken are skipped if they would exceed the manifester-level PP cap."
    ));
    jSettings = JsonArrayInsert(jSettings, jAutometa);
    json jMaximum = NUISpellbookPsiButton(
        "Max augment: " + (bMaximum ? "On" : "Off"),
        PRC_NUI_PSI_MAX_BUTTON,
        !bMaximum, nGeneration, 150.0f, TRUE, bMaximum
    );
    jMaximum = NuiTooltip(jMaximum, JsonString(
        "Auto-distribute remaining legal PP across available augmentation options."
    ));
    jSettings = JsonArrayInsert(jSettings, jMaximum);
    return NuiRow(jSettings);
}

json NUISpellbookPsiSimpleDefaults(object oPC, int nGeneration)
{
    json jChildren = JsonArray();
    if (!GetLocalInt(oPC, PRC_NUI_PSI_DEFAULT_CONFIRM_VAR))
    {
        json jButton = NUISpellbookPsiButton(
            "Simple defaults...",
            PRC_NUI_PSI_DEFAULT_BUTTON,
            0,
            nGeneration,
            180.0f,
            GetIsPsionicCharacter(oPC)
        );
        jButton = NuiTooltip(jButton, JsonString(
            "Set profiles 1-49 to the original PRC simple progression."
        ));
        jChildren = JsonArrayInsert(jChildren, jButton);
        return NuiRow(jChildren);
    }

    json jWarning = NuiText(
        JsonString(
            "Profiles 1-49 will become 1/0/0/0/0 through "
            + "49/0/0/0/0. Quick sets are unchanged. "
            + "This cannot be undone."
        ),
        FALSE,
        NUI_SCROLLBARS_NONE
    );
    jWarning = NuiWidth(jWarning, 390.0f);
    jWarning = NuiHeight(jWarning, 54.0f);
    jChildren = JsonArrayInsert(jChildren, jWarning);

    json jApply = NUISpellbookPsiButton(
        "Apply",
        PRC_NUI_PSI_DEFAULT_CONFIRM_BUTTON,
        0,
        nGeneration,
        88.0f,
        GetIsPsionicCharacter(oPC),
        TRUE
    );
    jChildren = JsonArrayInsert(jChildren, jApply);
    jChildren = JsonArrayInsert(jChildren, NUISpellbookPsiButton(
        "Cancel",
        PRC_NUI_PSI_DEFAULT_CANCEL_BUTTON,
        0,
        nGeneration,
        88.0f,
        TRUE
    ));
    return NuiRow(jChildren);
}

json NUISpellbookPsiQuickRow(object oPC, int nGeneration)
{
    int nCurrent = GetLocalInt(oPC, PRC_CURRENT_AUGMENT_PROFILE);
    json jRow = JsonArray();
    jRow = JsonArrayInsert(jRow, NUISpellbookPsiButton(
        "Off", PRC_NUI_PSI_USE_BUTTON, 0,
        nGeneration, 64.0f, TRUE, nCurrent == 0
    ));
    int i;
    for (i = 1; i <= 7; i++)
    {
        struct user_augment_profile uap = GetUserAugmentationProfile(
            oPC, i, TRUE
        );
        json jQuick = NUISpellbookPsiButton(
            "Q" + IntToString(i),
            PRC_NUI_PSI_USE_BUTTON,
            PRC_NUI_PSI_QUICK_ACTION_BASE + i,
            nGeneration,
            60.0f,
            TRUE,
            nCurrent == -i
        );
        jQuick = NuiTooltip(jQuick, JsonString(
            "Quick " + IntToString(i) + ": "
            + NUISpellbookPsiProfileShort(uap)
        ));
        jRow = JsonArrayInsert(jRow, jQuick);
    }
    return NuiRow(jRow);
}

json NUISpellbookPsiWildSurgeRow(object oPC, int nGeneration)
{
    int nMaximum = NUISpellbookPsiWildSurgeMaximum(oPC);
    int nCurrent = GetLocalInt(oPC, PRC_WILD_SURGE);
    json jRow = JsonArray();
    jRow = JsonArrayInsert(
        jRow,
        NUISpellbookPsiLabel("Wild Surge", 110.0f)
    );
    jRow = JsonArrayInsert(jRow, NUISpellbookPsiButton(
        "Off", PRC_NUI_PSI_SURGE_BUTTON, 0,
        nGeneration, 58.0f, TRUE, nCurrent == 0
    ));
    int i;
    for (i = 1; i <= nMaximum; i++)
    {
        jRow = JsonArrayInsert(jRow, NUISpellbookPsiButton(
            IntToString(i), PRC_NUI_PSI_SURGE_BUTTON, i,
            nGeneration, 44.0f,
            GetLocalInt(oPC, PRC_OVERCHANNEL) == 0,
            nCurrent == i
        ));
    }
    return NuiRow(jRow);
}

json NUISpellbookPsiOverchannelRow(object oPC, int nGeneration)
{
    int nCurrent = GetLocalInt(oPC, PRC_OVERCHANNEL);
    int bHasFeat = GetHasFeat(FEAT_OVERCHANNEL, oPC);
    int nHD = GetHitDice(oPC);
    int bNoSurge = GetLocalInt(oPC, PRC_WILD_SURGE) == 0;
    json jRow = JsonArray();
    jRow = JsonArrayInsert(
        jRow,
        NUISpellbookPsiLabel("Overchannel", 110.0f)
    );
    jRow = JsonArrayInsert(jRow, NUISpellbookPsiButton(
        "Off", PRC_NUI_PSI_OVERCHANNEL_BUTTON, 0,
        nGeneration, 58.0f, TRUE, nCurrent == 0
    ));
    jRow = JsonArrayInsert(jRow, NUISpellbookPsiButton(
        "+1", PRC_NUI_PSI_OVERCHANNEL_BUTTON, 1,
        nGeneration, 58.0f, bHasFeat && bNoSurge, nCurrent == 1
    ));
    jRow = JsonArrayInsert(jRow, NUISpellbookPsiButton(
        "+2", PRC_NUI_PSI_OVERCHANNEL_BUTTON, 2,
        nGeneration, 58.0f,
        bHasFeat && bNoSurge && nHD >= 8, nCurrent == 2
    ));
    jRow = JsonArrayInsert(jRow, NUISpellbookPsiButton(
        "+3", PRC_NUI_PSI_OVERCHANNEL_BUTTON, 3,
        nGeneration, 58.0f,
        bHasFeat && bNoSurge && nHD >= 15, nCurrent == 3
    ));
    return NuiRow(jRow);
}

/**
 * Builds an embeddable psionic configuration column.  Passing no generation
 * starts a new module generation.  If an enclosing layout supplies one, that
 * value becomes the module generation and must also be passed to the handler.
 */
json NUISpellbookPsiCreatePanel(
    object oPC,
    int nGeneration = 0
)
{
    if (nGeneration <= 0)
        nGeneration = NUISpellbookPsiNextGeneration(oPC);
    else
        SetLocalInt(oPC, PRC_NUI_PSI_GENERATION_VAR, nGeneration);

    json jChildren = JsonArray();
    if (!NUISpellbookPsiHasContent(oPC))
    {
        jChildren = JsonArrayInsert(
            jChildren,
            NUISpellbookPsiHeader("No psionic configuration is available.")
        );
        return NuiCol(jChildren);
    }

    jChildren = JsonArrayInsert(
        jChildren,
        NUISpellbookPsiHeader("Augmentation")
    );
    jChildren = JsonArrayInsert(
        jChildren,
        NUISpellbookPsiLabel(NUISpellbookPsiCurrentSummary(oPC), 620.0f)
    );
    jChildren = JsonArrayInsert(
        jChildren,
        NUISpellbookPsiQuickRow(oPC, nGeneration)
    );
    jChildren = JsonArrayInsert(
        jChildren,
        NUISpellbookPsiEditor(oPC, nGeneration)
    );
    jChildren = JsonArrayInsert(
        jChildren,
        NUISpellbookPsiAugmentSettings(oPC, nGeneration)
    );
    jChildren = JsonArrayInsert(
        jChildren,
        NUISpellbookPsiSimpleDefaults(oPC, nGeneration)
    );

    int nMaximumSurge = NUISpellbookPsiWildSurgeMaximum(oPC);
    if (nMaximumSurge > 0 || GetLocalInt(oPC, PRC_WILD_SURGE) != 0)
    {
        jChildren = JsonArrayInsert(
            jChildren,
            NUISpellbookPsiHeader(
                "Wild Surge (maximum " + IntToString(nMaximumSurge) + ")"
            )
        );
        jChildren = JsonArrayInsert(
            jChildren,
            NUISpellbookPsiWildSurgeRow(oPC, nGeneration)
        );
    }
    if (GetHasFeat(FEAT_OVERCHANNEL, oPC)
        || GetLocalInt(oPC, PRC_OVERCHANNEL) != 0)
    {
        jChildren = JsonArrayInsert(
            jChildren,
            NUISpellbookPsiHeader("Overchannel")
        );
        jChildren = JsonArrayInsert(
            jChildren,
            NUISpellbookPsiOverchannelRow(oPC, nGeneration)
        );
    }

    json jLegacy = NUISpellbookPsiButton(
        "Open legacy augmentation setup",
        PRC_NUI_PSI_LEGACY_BUTTON,
        0,
        nGeneration,
        250.0f,
        GetIsPsionicCharacter(oPC)
    );
    jLegacy = NuiTooltip(jLegacy, JsonString(
        "Opens the original PRC augmentation conversation as an alternate interface."
    ));
    json jFooter = JsonArray();
    jFooter = JsonArrayInsert(jFooter, jLegacy);
    jChildren = JsonArrayInsert(jChildren, NuiRow(jFooter));
    return NuiCol(jChildren);
}
