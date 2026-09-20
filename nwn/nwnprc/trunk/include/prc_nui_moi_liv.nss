//::///////////////////////////////////////////////
//:: PRC Incarnum live allocation NUI helpers
//:: prc_nui_moi_liv
//:://////////////////////////////////////////////
/**
 * NUI-only access to the existing Incarnum investment rules.  This include
 * deliberately leaves the legacy Invest Essentia conversations untouched.
 * Movable allocations are held in a temporary draft; feat and Soulcaster
 * allocations are committed once and remain governed by the PRC core.
 */

#include "prc_nui_moi_lc"
#include "moi_inc_moifunc"
#include "psi_inc_core"
#include "prc_inc_actions"
#include "nw_inc_nui"

int MoiLiveField(json jEntry, string sField)
{
    json jValue = JsonObjectGet(jEntry, sField);
    if (JsonGetType(jValue) != JSON_TYPE_INTEGER)
        return 0;
    return JsonGetInt(jValue);
}

string MoiLiveTextField(json jEntry, string sField)
{
    json jValue = JsonObjectGet(jEntry, sField);
    if (JsonGetType(jValue) != JSON_TYPE_STRING)
        return "";
    return JsonGetString(jValue);
}

string MoiLiveSpellName(int nSpell)
{
    string sName = GetStringByStrRef(StringToInt(Get2DACache(
        "spells", "Name", nSpell
    )));
    if (sName == "")
        sName = Get2DACache("spells", "Label", nSpell);
    if (sName == "" || sName == "****")
        sName = "Incarnum ability";
    return sName;
}

string MoiLiveFeatName(int nFeat)
{
    string sName = GetStringByStrRef(StringToInt(Get2DACache(
        "feat", "FEAT", nFeat
    )));
    if (sName == "")
        sName = Get2DACache("feat", "LABEL", nFeat);
    if (sName == "" || sName == "****")
        sName = "Incarnum feat";
    return sName;
}

string MoiLiveSpellIcon(int nSpell)
{
    string sIcon = Get2DACache("spells", "IconResRef", nSpell);
    if (sIcon == "****")
        return "";
    return sIcon;
}

string MoiLiveFeatIcon(int nFeat)
{
    string sIcon = Get2DACache("feat", "ICON", nFeat);
    if (sIcon == "****")
        return "";
    return sIcon;
}

json MoiLiveMovableEntry(
    int nMeld,
    int nClass,
    int nInvest,
    int nCapacity,
    int nKind,
    string sName)
{
    json jEntry = JsonObject();
    jEntry = JsonObjectSet(jEntry, "m", JsonInt(nMeld));
    jEntry = JsonObjectSet(jEntry, "c", JsonInt(nClass));
    jEntry = JsonObjectSet(jEntry, "i", JsonInt(nInvest));
    jEntry = JsonObjectSet(jEntry, "x", JsonInt(nCapacity));
    jEntry = JsonObjectSet(jEntry, "k", JsonInt(nKind));
    jEntry = JsonObjectSet(jEntry, "n", JsonString(sName));
    return jEntry;
}

int MoiLiveArrayHasMeld(json jEntries, int nMeld)
{
    int i;
    for (i = 0; i < JsonGetLength(jEntries); i++)
        if (MoiLiveField(JsonArrayGet(jEntries, i), "m") == nMeld)
            return TRUE;
    return FALSE;
}

json MoiLiveAppendShapedClass(object oPC, json jEntries, int nClass)
{
    int nSlot;
    for (nSlot = 0; nSlot <= 22; nSlot++)
    {
        int nMeld = GetLocalInt(
            oPC,
            "ShapedMeld" + IntToString(nClass) + IntToString(nSlot)
        );
        if (nMeld <= 0 || MoiLiveArrayHasMeld(jEntries, nMeld))
            continue;

        int nCapacity = GetMaxEssentiaCapacity(oPC, nClass, nMeld);
        jEntries = JsonArrayInsert(jEntries, MoiLiveMovableEntry(
            nMeld,
            nClass,
            GetLocalInt(oPC, "MeldEssentia" + IntToString(nMeld)),
            nCapacity,
            0,
            MoiLiveSpellName(nMeld)
        ));
    }
    return jEntries;
}

int MoiLiveSpecialRequiredLevel(int nMeld)
{
    switch (nMeld)
    {
        case MELD_SPINE_ENHANCEMENT:        return 2;
        case MELD_IRONSOUL_SHIELD:          return 1;
        case MELD_IRONSOUL_ARMOR:           return 5;
        case MELD_IRONSOUL_WEAPON:          return 9;
        case MELD_UMBRAL_STEP:              return 1;
        case MELD_UMBRAL_SHADOW:            return 3;
        case MELD_UMBRAL_SIGHT:             return 7;
        case MELD_UMBRAL_SOUL:              return 9;
        case MELD_UMBRAL_KISS:              return 10;
        case MELD_INCANDESCENT_STRIKE:      return 1;
        case MELD_INCANDESCENT_HEAL:        return 2;
        case MELD_INCANDESCENT_COUNTENANCE: return 3;
        case MELD_INCANDESCENT_RAY:         return 5;
        case MELD_INCANDESCENT_AURA:        return 8;
        case MELD_WITCH_MELDSHIELD:         return 1;
        case MELD_WITCH_DISPEL:             return 2;
        case MELD_WITCH_SHACKLES:           return 4;
        case MELD_WITCH_ABROGATION:         return 6;
        case MELD_WITCH_SPIRITFLAY:         return 8;
        case MELD_WITCH_INTEGUMENT:         return 10;
    }
    return 0;
}

int MoiLiveSpecialClass(int nMeld)
{
    if (nMeld == MELD_SPINE_ENHANCEMENT)
        return CLASS_TYPE_SPINEMELD_WARRIOR;
    if (nMeld == MELD_IRONSOUL_SHIELD
        || nMeld == MELD_IRONSOUL_ARMOR
        || nMeld == MELD_IRONSOUL_WEAPON)
        return CLASS_TYPE_IRONSOUL_FORGEMASTER;
    if (nMeld == MELD_UMBRAL_STEP
        || nMeld == MELD_UMBRAL_SHADOW
        || nMeld == MELD_UMBRAL_SIGHT
        || nMeld == MELD_UMBRAL_SOUL
        || nMeld == MELD_UMBRAL_KISS)
        return CLASS_TYPE_UMBRAL_DISCIPLE;
    if (nMeld == MELD_INCANDESCENT_STRIKE
        || nMeld == MELD_INCANDESCENT_HEAL
        || nMeld == MELD_INCANDESCENT_COUNTENANCE
        || nMeld == MELD_INCANDESCENT_RAY
        || nMeld == MELD_INCANDESCENT_AURA)
        return CLASS_TYPE_INCANDESCENT_CHAMPION;
    if (nMeld == MELD_WITCH_MELDSHIELD
        || nMeld == MELD_WITCH_DISPEL
        || nMeld == MELD_WITCH_SHACKLES
        || nMeld == MELD_WITCH_ABROGATION
        || nMeld == MELD_WITCH_SPIRITFLAY
        || nMeld == MELD_WITCH_INTEGUMENT)
        return CLASS_TYPE_WITCHBORN_BINDER;
    return CLASS_TYPE_INVALID;
}

string MoiLiveSpecialName(int nMeld)
{
    switch (nMeld)
    {
        case MELD_DUSKLING_SPEED:           return "Duskling Speed";
        case MELD_SPINE_ENHANCEMENT:        return "Spine Enhancement";
        case MELD_IRONSOUL_SHIELD:          return "Shield Bond";
        case MELD_IRONSOUL_ARMOR:           return "Armor Bond";
        case MELD_IRONSOUL_WEAPON:          return "Weapon Bond";
        case MELD_UMBRAL_STEP:              return "Step of the Bodiless";
        case MELD_UMBRAL_SHADOW:            return "Embrace of Shadow";
        case MELD_UMBRAL_SIGHT:             return "Sight of the Eyeless";
        case MELD_UMBRAL_SOUL:              return "Soulchilling Strike";
        case MELD_UMBRAL_KISS:              return "Kiss of the Shadows";
        case MELD_INCANDESCENT_STRIKE:      return "Incandescent Strike";
        case MELD_INCANDESCENT_HEAL:        return "Incandescent Heal";
        case MELD_INCANDESCENT_COUNTENANCE: return "Incandescent Countenance";
        case MELD_INCANDESCENT_RAY:         return "Incandescent Ray";
        case MELD_INCANDESCENT_AURA:        return "Incandescent Aura";
        case MELD_WITCH_MELDSHIELD:         return "Meldshield";
        case MELD_WITCH_DISPEL:             return "Dispelling Orb";
        case MELD_WITCH_SHACKLES:           return "Mage Shackles";
        case MELD_WITCH_ABROGATION:         return "Word of Abrogation";
        case MELD_WITCH_SPIRITFLAY:         return "Spiritflay";
        case MELD_WITCH_INTEGUMENT:         return "Grim Integument";
    }
    return "Incarnum ability";
}

int MoiLiveSpecialEligible(object oPC, int nMeld)
{
    if (nMeld == MELD_DUSKLING_SPEED)
        return GetRacialType(oPC) == RACIAL_TYPE_DUSKLING;
    int nClass = MoiLiveSpecialClass(nMeld);
    int nRequired = MoiLiveSpecialRequiredLevel(nMeld);
    return nClass != CLASS_TYPE_INVALID
        && nRequired > 0
        && GetLevelByClass(nClass, oPC) >= nRequired;
}

int MoiLiveSpecialCapacity(object oPC, int nMeld)
{
    if (nMeld == MELD_SPINE_ENHANCEMENT)
        return GetLevelByClass(CLASS_TYPE_SPINEMELD_WARRIOR, oPC) / 2;
    return GetMaxEssentiaCapacity(oPC, -1, nMeld);
}

json MoiLiveAppendSpecial(object oPC, json jEntries, int nMeld)
{
    if (!MoiLiveSpecialEligible(oPC, nMeld)
        || MoiLiveArrayHasMeld(jEntries, nMeld))
        return jEntries;
    jEntries = JsonArrayInsert(jEntries, MoiLiveMovableEntry(
        nMeld,
        MoiLiveSpecialClass(nMeld),
        GetLocalInt(oPC, "MeldEssentia" + IntToString(nMeld)),
        MoiLiveSpecialCapacity(oPC, nMeld),
        1,
        MoiLiveSpecialName(nMeld)
    ));
    return jEntries;
}

json MoiLiveBuildMovable(object oPC)
{
    json jEntries = JsonArray();
    jEntries = MoiLiveAppendShapedClass(oPC, jEntries, CLASS_TYPE_INCARNATE);
    jEntries = MoiLiveAppendShapedClass(oPC, jEntries, CLASS_TYPE_SOULBORN);
    jEntries = MoiLiveAppendShapedClass(oPC, jEntries, CLASS_TYPE_TOTEMIST);
    jEntries = MoiLiveAppendShapedClass(
        oPC, jEntries, CLASS_TYPE_SPINEMELD_WARRIOR
    );

    jEntries = MoiLiveAppendSpecial(oPC, jEntries, MELD_DUSKLING_SPEED);
    jEntries = MoiLiveAppendSpecial(oPC, jEntries, MELD_SPINE_ENHANCEMENT);
    jEntries = MoiLiveAppendSpecial(oPC, jEntries, MELD_IRONSOUL_SHIELD);
    jEntries = MoiLiveAppendSpecial(oPC, jEntries, MELD_IRONSOUL_ARMOR);
    jEntries = MoiLiveAppendSpecial(oPC, jEntries, MELD_IRONSOUL_WEAPON);
    jEntries = MoiLiveAppendSpecial(oPC, jEntries, MELD_UMBRAL_STEP);
    jEntries = MoiLiveAppendSpecial(oPC, jEntries, MELD_UMBRAL_SHADOW);
    jEntries = MoiLiveAppendSpecial(oPC, jEntries, MELD_UMBRAL_SIGHT);
    jEntries = MoiLiveAppendSpecial(oPC, jEntries, MELD_UMBRAL_SOUL);
    jEntries = MoiLiveAppendSpecial(oPC, jEntries, MELD_UMBRAL_KISS);
    jEntries = MoiLiveAppendSpecial(oPC, jEntries, MELD_INCANDESCENT_STRIKE);
    jEntries = MoiLiveAppendSpecial(oPC, jEntries, MELD_INCANDESCENT_HEAL);
    jEntries = MoiLiveAppendSpecial(
        oPC, jEntries, MELD_INCANDESCENT_COUNTENANCE
    );
    jEntries = MoiLiveAppendSpecial(oPC, jEntries, MELD_INCANDESCENT_RAY);
    jEntries = MoiLiveAppendSpecial(oPC, jEntries, MELD_INCANDESCENT_AURA);
    jEntries = MoiLiveAppendSpecial(oPC, jEntries, MELD_WITCH_MELDSHIELD);
    jEntries = MoiLiveAppendSpecial(oPC, jEntries, MELD_WITCH_DISPEL);
    jEntries = MoiLiveAppendSpecial(oPC, jEntries, MELD_WITCH_SHACKLES);
    jEntries = MoiLiveAppendSpecial(oPC, jEntries, MELD_WITCH_ABROGATION);
    jEntries = MoiLiveAppendSpecial(oPC, jEntries, MELD_WITCH_SPIRITFLAY);
    jEntries = MoiLiveAppendSpecial(oPC, jEntries, MELD_WITCH_INTEGUMENT);
    return jEntries;
}

int MoiLiveMovableSum(json jDraft)
{
    int nTotal;
    int i;
    for (i = 0; i < JsonGetLength(jDraft); i++)
        nTotal += MoiLiveField(JsonArrayGet(jDraft, i), "i");
    return nTotal;
}

int MoiLiveMovableAvailable(object oPC)
{
    // The PRC helper already subtracts feat and Soulcaster investments from
    // the pool that may move among soulmeld/class/racial receptacles.
    int nAvailable = GetTotalUsableEssentia(oPC);
    if (nAvailable < 0)
        return 0;
    return nAvailable;
}

int MoiLiveMovableStructureMatches(object oPC, json jDraft)
{
    json jLive = MoiLiveBuildMovable(oPC);
    if (JsonGetLength(jDraft) != JsonGetLength(jLive)
        || JsonGetLength(jDraft) > PRC_MOI_LIVE_MAX_MOVABLE_ENTRIES)
        return FALSE;
    int i;
    for (i = 0; i < JsonGetLength(jDraft); i++)
    {
        json jEntry = JsonArrayGet(jDraft, i);
        json jLiveEntry = JsonArrayGet(jLive, i);
        if (MoiLiveField(jEntry, "m") != MoiLiveField(jLiveEntry, "m")
            || MoiLiveField(jEntry, "c") != MoiLiveField(jLiveEntry, "c")
            || MoiLiveField(jEntry, "k") != MoiLiveField(jLiveEntry, "k"))
            return FALSE;
    }
    return TRUE;
}

string MoiLiveValidateMovable(object oPC, json jDraft)
{
    if (jDraft == JsonNull() || !MoiLiveMovableStructureMatches(oPC, jDraft))
        return "The shaped soulmeld or class-ability list changed. Refresh before applying.";

    int nTotal;
    int i;
    for (i = 0; i < JsonGetLength(jDraft); i++)
    {
        json jEntry = JsonArrayGet(jDraft, i);
        int nMeld = MoiLiveField(jEntry, "m");
        int nInvest = MoiLiveField(jEntry, "i");
        int nKind = MoiLiveField(jEntry, "k");
        int nCapacity = nKind
            ? MoiLiveSpecialCapacity(oPC, nMeld)
            : GetMaxEssentiaCapacity(
                oPC,
                MoiLiveField(jEntry, "c"),
                nMeld
            );
        if (nMeld <= 0 || nInvest < 0 || nInvest > nCapacity)
            return "One movable allocation is outside its current capacity.";
        if (nKind && !MoiLiveSpecialEligible(oPC, nMeld))
            return "A class or racial receptacle is no longer available.";
        nTotal += nInvest;
    }
    if (nTotal > MoiLiveMovableAvailable(oPC))
        return "This draft uses more movable essentia than is currently available.";
    return "";
}

string MoiLiveAdjustMovable(object oPC, int nIndex, int nDelta)
{
    json jDraft = GetLocalJson(oPC, PRC_MOI_LIVE_DRAFT_VAR);
    if (!MoiLiveMovableStructureMatches(oPC, jDraft))
        return "The live receptacle list changed. Refresh and try again.";
    if (nIndex < 0 || nIndex >= JsonGetLength(jDraft))
        return "That receptacle is no longer available.";

    json jEntry = JsonArrayGet(jDraft, nIndex);
    int nInvest = MoiLiveField(jEntry, "i") + nDelta;
    int nCapacity = MoiLiveField(jEntry, "k")
        ? MoiLiveSpecialCapacity(oPC, MoiLiveField(jEntry, "m"))
        : GetMaxEssentiaCapacity(
            oPC,
            MoiLiveField(jEntry, "c"),
            MoiLiveField(jEntry, "m")
        );
    if (nInvest < 0 || nInvest > nCapacity)
        return "That receptacle is already at its limit.";
    if (nDelta > 0
        && MoiLiveMovableSum(jDraft) + nDelta > MoiLiveMovableAvailable(oPC))
        return "No free movable essentia remains.";

    jEntry = JsonObjectSet(jEntry, "i", JsonInt(nInvest));
    jEntry = JsonObjectSet(jEntry, "x", JsonInt(nCapacity));
    jDraft = JsonArraySet(jDraft, nIndex, jEntry);
    SetLocalJson(oPC, PRC_MOI_LIVE_DRAFT_VAR, jDraft);
    return "";
}

string MoiLiveApplyMovable(object oPC)
{
    json jDraft = GetLocalJson(oPC, PRC_MOI_LIVE_DRAFT_VAR);
    string sError = MoiLiveValidateMovable(oPC, jDraft);
    if (sError != "")
        return sError;
    if (GetTemporaryEssentia(oPC) > 0
        || GetLocalInt(oPC, "IncandescentOverload")
        || GetLocalInt(oPC, "InvestingTempEssentia")
        || GetLocalInt(oPC, "PerfectMeldshaper")
        || GetLocalInt(oPC, "TotemEmbodiment")
        || GetLocalInt(oPC, "TotemEmbodiment2"))
        return "Wait for temporary essentia or temporary meldshaping modes to end before redistributing.";
    if (!TakeSwiftAction(oPC))
        return "A swift action is not currently available.";

    WipeMelds(oPC);
    DrainEssentia(oPC);
    int i;
    for (i = 0; i < JsonGetLength(jDraft); i++)
    {
        json jEntry = JsonArrayGet(jDraft, i);
        int nInvest = MoiLiveField(jEntry, "i");
        if (nInvest > 0)
            InvestEssentia(oPC, MoiLiveField(jEntry, "m"), nInvest);
    }
    AssignCommand(oPC, ReshapeMelds(oPC));
    AssignCommand(oPC, ActionDoCommand(ExecuteScript("prc_speed", oPC)));
    return "";
}

int MoiLiveSafeFeat(int nFeat)
{
    // 8884 needs its power-selection conversation; 8886 has no implemented
    // consumer.  8889 is deliberately outside this range because the legacy
    // PRC locked-essentia/rest loops do not account for it safely.
    return nFeat >= 8869 && nFeat <= 8888
        && nFeat != FEAT_AZURE_TALENT
        && nFeat != 8884
        && nFeat != 8886;
}

int MoiLiveFeatCapacity(object oPC, int nFeat)
{
    int nCapacity = GetMaxEssentiaCapacityFeat(oPC);
    if (nFeat == FEAT_COBALT_RAGE
        && GetLevelByClass(CLASS_TYPE_TOTEM_RAGER, oPC) > 0)
        nCapacity++;
    return nCapacity;
}

int MoiLiveFreeEssentia(object oPC)
{
    int nFree = GetTotalEssentia(oPC) - GetTotalEssentiaInvested(oPC);
    if (nFree < 0)
        return 0;
    return nFree;
}

int MoiLiveGetFeatAmount(object oPC, int nFeat)
{
    int nAmount = GetLocalInt(
        oPC,
        PRC_MOI_LIVE_FEAT_AMOUNT_PREFIX + IntToString(nFeat)
    );
    int nCapacity = MoiLiveFeatCapacity(oPC, nFeat);
    int nFree = MoiLiveFreeEssentia(oPC);
    if (nCapacity > nFree)
        nCapacity = nFree;
    if (nAmount < 1)
        nAmount = 1;
    if (nCapacity > 0 && nAmount > nCapacity)
        nAmount = nCapacity;
    return nAmount;
}

string MoiLiveAdjustFeatAmount(object oPC, int nFeat, int nDelta)
{
    if (!MoiLiveSafeFeat(nFeat) || !GetHasFeat(nFeat, oPC)
        || GetEssentiaInvestedFeat(oPC, nFeat) > 0)
        return "That feat cannot receive a new allocation.";
    int nAmount = MoiLiveGetFeatAmount(oPC, nFeat) + nDelta;
    int nCapacity = MoiLiveFeatCapacity(oPC, nFeat);
    int nFree = MoiLiveFreeEssentia(oPC);
    if (nCapacity > nFree)
        nCapacity = nFree;
    if (nAmount < 1 || nAmount > nCapacity)
        return "That amount is outside the feat's current capacity.";
    SetLocalInt(
        oPC,
        PRC_MOI_LIVE_FEAT_AMOUNT_PREFIX + IntToString(nFeat),
        nAmount
    );
    return "";
}

string MoiLiveCommitFeat(object oPC, int nFeat)
{
    if (!MoiLiveSafeFeat(nFeat) || !GetHasFeat(nFeat, oPC))
        return "That feat is not available for NUI investment.";
    if (GetEssentiaInvestedFeat(oPC, nFeat) > 0)
        return "Essentia is already locked in that feat until rest.";
    if (GetTemporaryEssentia(oPC) > 0
        || GetLocalInt(oPC, "IncandescentOverload"))
        return "Temporary essentia cannot be locked into a feat.";

    int nAmount = MoiLiveGetFeatAmount(oPC, nFeat);
    if (nAmount < 1
        || nAmount > MoiLiveFeatCapacity(oPC, nFeat)
        || nAmount > MoiLiveFreeEssentia(oPC))
        return "There is not enough free essentia for that allocation.";
    if (!TakeSwiftAction(oPC))
        return "A swift action is not currently available.";

    InvestEssentiaFeat(oPC, nFeat, nAmount);
    DeleteLocalInt(
        oPC,
        PRC_MOI_LIVE_FEAT_AMOUNT_PREFIX + IntToString(nFeat)
    );
    return "";
}

int MoiLiveSoulcasterAmount(object oPC)
{
    return GetLevelByClass(CLASS_TYPE_SOULCASTER, oPC) >= 7 ? 2 : 1;
}

int MoiLiveSpellTrackerCount(object oPC)
{
    int nCount;
    int i;
    for (i = 1; i <= 10; i++)
        if (GetLocalInt(oPC, "SpellInvestCheck" + IntToString(i)) > 0)
            nCount++;
    return nCount;
}

int MoiLiveSpellKnown(object oPC, int nKind, int nSpell, int nLevel)
{
    if (nSpell <= 0 || nLevel < 1 || nLevel > 9)
        return FALSE;
    string sFile;
    int nRows;
    int i;
    if (nKind == PRC_MOI_LIVE_CAST_ARCANE)
    {
        int nClass = GetPrimaryArcaneClass(oPC);
        if (nClass == CLASS_TYPE_INVALID)
            return FALSE;
        sFile = GetFileForClass(nClass);
        if (nClass == CLASS_TYPE_WIZARD)
            sFile = "cls_spell_sorc";
        nRows = 550;
        for (i = 0; i < nRows; i++)
        {
            if (StringToInt(Get2DACache(sFile, "Level", i)) == nLevel
                && StringToInt(Get2DACache(sFile, "RealSpellID", i)) == nSpell
                && PRCGetHasSpell(nSpell, oPC))
                return TRUE;
        }
        return FALSE;
    }

    int nPsiClass = GetPrimaryPsionicClass(oPC);
    if (nPsiClass == CLASS_TYPE_INVALID)
        return FALSE;
    sFile = GetAMSDefinitionFileName(nPsiClass);
    nRows = 286;
    for (i = 0; i < nRows; i++)
    {
        string sFeat = Get2DACache(sFile, "FeatID", i);
        if (StringToInt(Get2DACache(sFile, "Level", i)) == nLevel
            && StringToInt(Get2DACache(sFile, "RealSpellID", i)) == nSpell
            && sFeat != ""
            && GetHasFeat(StringToInt(sFeat), oPC))
            return TRUE;
    }
    return FALSE;
}

json MoiLiveSpellEntry(int nSpell)
{
    json jEntry = JsonObject();
    jEntry = JsonObjectSet(jEntry, "s", JsonInt(nSpell));
    jEntry = JsonObjectSet(jEntry, "n", JsonString(MoiLiveSpellName(nSpell)));
    return jEntry;
}

int MoiLiveSpellArrayHas(json jEntries, int nSpell)
{
    int i;
    for (i = 0; i < JsonGetLength(jEntries); i++)
        if (MoiLiveField(JsonArrayGet(jEntries, i), "s") == nSpell)
            return TRUE;
    return FALSE;
}

json MoiLiveKnownSpells(object oPC, int nKind, int nLevel)
{
    json jEntries = JsonArray();
    string sFile;
    int nRows;
    int i;
    if (nKind == PRC_MOI_LIVE_CAST_ARCANE)
    {
        int nClass = GetPrimaryArcaneClass(oPC);
        if (nClass == CLASS_TYPE_INVALID)
            return jEntries;
        sFile = GetFileForClass(nClass);
        if (nClass == CLASS_TYPE_WIZARD)
            sFile = "cls_spell_sorc";
        nRows = 550;
        for (i = 0; i < nRows; i++)
        {
            if (StringToInt(Get2DACache(sFile, "Level", i)) != nLevel)
                continue;
            int nSpell = StringToInt(Get2DACache(sFile, "RealSpellID", i));
            if (nSpell > 0
                && !MoiLiveSpellArrayHas(jEntries, nSpell)
                && PRCGetHasSpell(nSpell, oPC))
                jEntries = JsonArrayInsert(jEntries, MoiLiveSpellEntry(nSpell));
        }
        return jEntries;
    }

    int nPsiClass = GetPrimaryPsionicClass(oPC);
    if (nPsiClass == CLASS_TYPE_INVALID)
        return jEntries;
    sFile = GetAMSDefinitionFileName(nPsiClass);
    nRows = 286;
    for (i = 0; i < nRows; i++)
    {
        if (StringToInt(Get2DACache(sFile, "Level", i)) != nLevel)
            continue;
        string sFeat = Get2DACache(sFile, "FeatID", i);
        int nSpell = StringToInt(Get2DACache(sFile, "RealSpellID", i));
        if (nSpell > 0 && sFeat != ""
            && !MoiLiveSpellArrayHas(jEntries, nSpell)
            && GetHasFeat(StringToInt(sFeat), oPC))
            jEntries = JsonArrayInsert(jEntries, MoiLiveSpellEntry(nSpell));
    }
    return jEntries;
}

string MoiLiveCommitSpell(
    object oPC,
    int nKind,
    int nLevel,
    int nSpell)
{
    int nSoulcaster = GetLevelByClass(CLASS_TYPE_SOULCASTER, oPC);
    if (nSoulcaster <= 0)
        return "Soulcaster is required to invest in a spell or power.";
    if (!MoiLiveSpellKnown(oPC, nKind, nSpell, nLevel))
        return "That spell or power is no longer known at the selected level.";
    if (GetLocalInt(oPC, "SpellEssentia" + IntToString(nSpell)) > 0)
        return "That spell or power already has essentia invested.";
    if (GetTemporaryEssentia(oPC) > 0
        || GetLocalInt(oPC, "IncandescentOverload"))
        return "Temporary essentia cannot be locked into a spell or power.";

    if (MoiLiveSpellTrackerCount(oPC) >= nSoulcaster)
        return "Your Soulcaster level already supports the maximum active investments.";
    int nAmount = MoiLiveSoulcasterAmount(oPC);
    if (nAmount > MoiLiveFreeEssentia(oPC))
        return "There is not enough free essentia for that investment.";
    if (!TakeSwiftAction(oPC))
        return "A swift action is not currently available.";

    InvestEssentiaSpell(oPC, nSpell, nAmount);
    return "";
}

int MoiLiveNextGeneration(object oPC)
{
    int nGeneration = GetLocalInt(oPC, PRC_MOI_LIVE_GENERATION_VAR) + 1;
    if (nGeneration <= 0)
        nGeneration = 1;
    SetLocalInt(oPC, PRC_MOI_LIVE_GENERATION_VAR, nGeneration);
    return nGeneration;
}

string MoiLiveStamp(string sBase, int nGeneration)
{
    return sBase + PRC_MOI_LIVE_GENERATION_MARKER
         + IntToString(nGeneration);
}

string MoiLiveStampValue(string sBase, int nValue, int nGeneration)
{
    return sBase + IntToString(nValue)
         + PRC_MOI_LIVE_GENERATION_MARKER
         + IntToString(nGeneration);
}

int MoiLiveElementGeneration(string sElement)
{
    int nMarker = FindSubString(sElement, PRC_MOI_LIVE_GENERATION_MARKER);
    if (nMarker < 0)
        return 0;
    return StringToInt(GetSubString(
        sElement,
        nMarker + GetStringLength(PRC_MOI_LIVE_GENERATION_MARKER),
        GetStringLength(sElement)
    ));
}

int MoiLiveElementValue(string sElement, string sBase)
{
    int nMarker = FindSubString(sElement, PRC_MOI_LIVE_GENERATION_MARKER);
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

void MoiLiveClearState(object oPC)
{
    DeleteLocalJson(oPC, PRC_MOI_LIVE_DRAFT_VAR);
    DeleteLocalInt(oPC, PRC_MOI_LIVE_PAGE_VAR);
    DeleteLocalInt(oPC, PRC_MOI_LIVE_CAST_KIND_VAR);
    DeleteLocalInt(oPC, PRC_MOI_LIVE_CAST_LEVEL_VAR);
    int nFeat;
    for (nFeat = 8869; nFeat <= 8888; nFeat++)
        DeleteLocalInt(
            oPC,
            PRC_MOI_LIVE_FEAT_AMOUNT_PREFIX + IntToString(nFeat)
        );
}
