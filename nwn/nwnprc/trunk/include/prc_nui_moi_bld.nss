//::///////////////////////////////////////////////
//:: Incarnum Blade NUI helpers
//:: prc_nui_moi_bld
//:://////////////////////////////////////////////
/**
 * Optional blademeld selection and a versioned completed-rest default.
 * The original Incarnum Blade conversations remain the fallback whenever no
 * valid saved default is active.
 */

#include "prc_nui_moi_cst"
#include "moi_inc_moifunc"
#include "nw_inc_nui"

int MoiBladeRequiredChoices(object oPC)
{
    int nLevel = GetLevelByClass(CLASS_TYPE_INCARNUM_BLADE, oPC);
    if (nLevel <= 0)
        return 0;
    return nLevel >= 5 ? 2 : 1;
}

int MoiBladeChakraUnlocked(object oPC, int nChakra)
{
    int nLevel = GetLevelByClass(CLASS_TYPE_INCARNUM_BLADE, oPC);
    if (nLevel <= 0)
        return FALSE;
    if (nChakra == CHAKRA_CROWN
        || nChakra == CHAKRA_FEET
        || nChakra == CHAKRA_HANDS)
        return TRUE;
    if (nLevel >= 2
        && (nChakra == CHAKRA_ARMS
            || nChakra == CHAKRA_BROW
            || nChakra == CHAKRA_SHOULDERS))
        return TRUE;
    if (nLevel >= 3
        && (nChakra == CHAKRA_THROAT
            || nChakra == CHAKRA_WAIST))
        return TRUE;
    if (nLevel >= 4 && nChakra == CHAKRA_HEART)
        return TRUE;
    return nLevel >= 5 && nChakra == CHAKRA_SOUL;
}

string MoiBladeChakraName(int nChakra)
{
    if (nChakra == CHAKRA_CROWN) return "Crown";
    if (nChakra == CHAKRA_FEET) return "Feet";
    if (nChakra == CHAKRA_HANDS) return "Hands";
    if (nChakra == CHAKRA_ARMS) return "Arms";
    if (nChakra == CHAKRA_BROW) return "Brow";
    if (nChakra == CHAKRA_SHOULDERS) return "Shoulders";
    if (nChakra == CHAKRA_THROAT) return "Throat";
    if (nChakra == CHAKRA_WAIST) return "Waist";
    if (nChakra == CHAKRA_HEART) return "Heart";
    if (nChakra == CHAKRA_SOUL) return "Soul";
    return "";
}

string MoiBladeChakraShort(int nChakra)
{
    if (nChakra == CHAKRA_CROWN) return "Cr";
    if (nChakra == CHAKRA_FEET) return "Ft";
    if (nChakra == CHAKRA_HANDS) return "Hn";
    if (nChakra == CHAKRA_ARMS) return "Ar";
    if (nChakra == CHAKRA_BROW) return "Br";
    if (nChakra == CHAKRA_SHOULDERS) return "Sh";
    if (nChakra == CHAKRA_THROAT) return "Th";
    if (nChakra == CHAKRA_WAIST) return "Wa";
    if (nChakra == CHAKRA_HEART) return "He";
    if (nChakra == CHAKRA_SOUL) return "So";
    return "?";
}

string MoiBladeValidateChoices(object oPC, int nFirst, int nSecond)
{
    int nRequired = MoiBladeRequiredChoices(oPC);
    if (nRequired <= 0)
        return "You no longer have Incarnum Blade levels.";
    if (!MoiBladeChakraUnlocked(oPC, nFirst))
        return "Choose an unlocked blademeld chakra.";
    if (nRequired == 1)
    {
        if (nSecond != 0)
            return "This Incarnum Blade level allows one blademeld.";
        return "";
    }
    if (!MoiBladeChakraUnlocked(oPC, nSecond))
        return "Choose two unlocked blademeld chakras.";
    if (nFirst == nSecond)
        return "The two blademeld chakras must be different.";
    return "";
}

string MoiBladeChoiceSummary(int nFirst, int nSecond)
{
    if (nFirst <= 0)
        return "None";
    string sSummary = MoiBladeChakraName(nFirst);
    if (nSecond > 0)
        sSummary += " + " + MoiBladeChakraName(nSecond);
    return sSummary;
}

int MoiBladeHasSavedDefault(object oPC)
{
    return GetPersistantLocalInt(oPC, PRC_MOI_BLADE_VERSION_VAR)
        == PRC_MOI_BLADE_VERSION;
}

json MoiBladeReadSaved(object oPC)
{
    if (!MoiBladeHasSavedDefault(oPC))
        return JsonNull();
    json jPlan = JsonObject();
    jPlan = JsonObjectSet(
        jPlan,
        "a",
        JsonInt(GetPersistantLocalInt(oPC, PRC_MOI_BLADE_FIRST_VAR))
    );
    jPlan = JsonObjectSet(
        jPlan,
        "b",
        JsonInt(GetPersistantLocalInt(oPC, PRC_MOI_BLADE_SECOND_VAR))
    );
    return jPlan;
}

int MoiBladePlanFirst(json jPlan)
{
    json jValue = JsonObjectGet(jPlan, "a");
    if (JsonGetType(jValue) != JSON_TYPE_INTEGER)
        return 0;
    return JsonGetInt(jValue);
}

int MoiBladePlanSecond(json jPlan)
{
    json jValue = JsonObjectGet(jPlan, "b");
    if (JsonGetType(jValue) != JSON_TYPE_INTEGER)
        return 0;
    return JsonGetInt(jValue);
}

string MoiBladeValidatePlan(object oPC, json jPlan)
{
    if (jPlan == JsonNull())
        return "no saved blademeld default exists";
    return MoiBladeValidateChoices(
        oPC,
        MoiBladePlanFirst(jPlan),
        MoiBladePlanSecond(jPlan)
    );
}

int MoiBladeWriteSaved(object oPC, int nFirst, int nSecond)
{
    if (MoiBladeValidateChoices(oPC, nFirst, nSecond) != "")
        return FALSE;

    SetPersistantLocalInt(oPC, PRC_MOI_BLADE_VERSION_VAR, 0);
    SetPersistantLocalInt(oPC, PRC_MOI_BLADE_FIRST_VAR, nFirst);
    SetPersistantLocalInt(oPC, PRC_MOI_BLADE_SECOND_VAR, nSecond);
    SetPersistantLocalInt(
        oPC,
        PRC_MOI_BLADE_VERSION_VAR,
        PRC_MOI_BLADE_VERSION
    );
    return TRUE;
}

void MoiBladeClearSaved(object oPC)
{
    SetPersistantLocalInt(oPC, PRC_MOI_BLADE_VERSION_VAR, 0);
}

void MoiBladeSetDraft(object oPC, int nFirst, int nSecond)
{
    SetLocalInt(oPC, PRC_MOI_BLADE_DRAFT_FIRST_VAR, nFirst);
    if (nSecond > 0)
        SetLocalInt(oPC, PRC_MOI_BLADE_DRAFT_SECOND_VAR, nSecond);
    else
        DeleteLocalInt(oPC, PRC_MOI_BLADE_DRAFT_SECOND_VAR);
}

void MoiBladeOpenDraft(object oPC)
{
    json jSaved = MoiBladeReadSaved(oPC);
    int nFirst;
    int nSecond;
    if (MoiBladeValidatePlan(oPC, jSaved) == "")
    {
        nFirst = MoiBladePlanFirst(jSaved);
        nSecond = MoiBladePlanSecond(jSaved);
    }

    MoiBladeSetDraft(oPC, nFirst, nSecond);
    SetLocalInt(oPC, PRC_MOI_BLADE_ACTIVE_VAR, TRUE);
}

void MoiBladeDiscardDraft(object oPC, int bDestroyWindow = TRUE)
{
    if (bDestroyWindow)
    {
        int nToken = NuiFindWindow(oPC, PRC_MOI_BLADE_NUI_WINDOW_ID);
        if (nToken)
            NuiDestroy(oPC, nToken);
    }
    DeleteLocalInt(oPC, PRC_MOI_BLADE_ACTIVE_VAR);
    DeleteLocalInt(oPC, PRC_MOI_BLADE_DRAFT_FIRST_VAR);
    DeleteLocalInt(oPC, PRC_MOI_BLADE_DRAFT_SECOND_VAR);
    DeleteLocalInt(oPC, PRC_MOI_BLADE_REBUILD_TOKEN_VAR);
    DeleteLocalInt(oPC, PRC_MOI_BLADE_APPLY_MODE_VAR);
}

void MoiBladeToggleDraft(object oPC, int nChakra)
{
    if (!MoiBladeChakraUnlocked(oPC, nChakra))
        return;

    int nFirst = GetLocalInt(oPC, PRC_MOI_BLADE_DRAFT_FIRST_VAR);
    int nSecond = GetLocalInt(oPC, PRC_MOI_BLADE_DRAFT_SECOND_VAR);
    int nRequired = MoiBladeRequiredChoices(oPC);
    if (nFirst == nChakra)
    {
        nFirst = nSecond;
        nSecond = 0;
    }
    else if (nSecond == nChakra)
        nSecond = 0;
    else if (nRequired == 1)
    {
        nFirst = nChakra;
        nSecond = 0;
    }
    else if (nFirst <= 0)
        nFirst = nChakra;
    else if (nSecond <= 0)
        nSecond = nChakra;
    else
    {
        nFirst = nSecond;
        nSecond = nChakra;
    }
    MoiBladeSetDraft(oPC, nFirst, nSecond);
}

int MoiBladeAdvanceGeneration(object oPC)
{
    int nGeneration = GetLocalInt(oPC, PRC_MOI_BLADE_GENERATION_VAR) + 1;
    if (nGeneration <= 0)
        nGeneration = 1;
    SetLocalInt(oPC, PRC_MOI_BLADE_GENERATION_VAR, nGeneration);
    return nGeneration;
}

string MoiBladeStampId(string sBase, int nGeneration)
{
    return sBase + PRC_MOI_BLADE_GENERATION_MARKER
         + IntToString(nGeneration);
}

string MoiBladeStampValueId(string sBase, int nValue, int nGeneration)
{
    return sBase + IntToString(nValue)
         + PRC_MOI_BLADE_GENERATION_MARKER
         + IntToString(nGeneration);
}

int MoiBladeElementGeneration(string sElement)
{
    int nMarker = FindSubString(sElement, PRC_MOI_BLADE_GENERATION_MARKER);
    if (nMarker < 0)
        return 0;
    int nStart = nMarker + GetStringLength(PRC_MOI_BLADE_GENERATION_MARKER);
    return StringToInt(GetSubString(
        sElement,
        nStart,
        GetStringLength(sElement) - nStart
    ));
}

int MoiBladeElementValue(string sElement, string sBase)
{
    int nMarker = FindSubString(sElement, PRC_MOI_BLADE_GENERATION_MARKER);
    int nStart = GetStringLength(sBase);
    if (FindSubString(sElement, sBase) != 0 || nMarker <= nStart)
        return 0;
    return StringToInt(GetSubString(sElement, nStart, nMarker - nStart));
}

void MoiBladeRemoveLiveEffects(object oPC)
{
    int nSpell;
    for (nSpell = MELD_BLADEMELD_CROWN;
         nSpell <= MELD_BLADEMELD_SOUL;
         nSpell++)
    {
        PRCRemoveSpellEffects(nSpell, oPC, oPC);
        GZPRCRemoveSpellEffects(nSpell, oPC, FALSE);
    }
}

int MoiBladeApplyChoices(object oPC, int nFirst, int nSecond)
{
    if (MoiBladeValidateChoices(oPC, nFirst, nSecond) != "")
        return FALSE;

    MoiBladeRemoveLiveEffects(oPC);
    ShapeSoulmeld(oPC, ChakraToBlademeld(nFirst));
    if (nSecond > 0)
        ShapeSoulmeld(oPC, ChakraToBlademeld(nSecond));
    return TRUE;
}
