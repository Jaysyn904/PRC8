//::///////////////////////////////////////////////
//:: PRC Incarnum Loadout planner helpers
//:: prc_nui_moi_pln
//:://////////////////////////////////////////////
/**
 * A versioned, character-persistent rest loadout for the three pieces of
 * meldshaping: shape placement, chakra binding, and raw essentia assigned to
 * soulmelds or movable class/racial receptacles.
 * Editing is isolated in a local JSON draft.  Saving validates the complete
 * draft before writing the persistent marker last; applying validates again
 * before touching any live Incarnum state.
 */

#include "prc_nui_moi_cst"
#include "moi_inc_moifunc"
#include "prc_inc_dragsham"
#include "inc_pers_array"
#include "nw_inc_nui"

json MoiLoadoutEntry(
    int nClass,
    int nChakra,
    int nMeld,
    int nInvest = 0,
    int bExpanded = FALSE,
    int nBind = 0,
    int nTotemBind = 0,
    int nAspect = 0,
    int nKind = PRC_MOI_LOADOUT_KIND_SOULMELD
)
{
    json jEntry = JsonObject();
    jEntry = JsonObjectSet(jEntry, "c", JsonInt(nClass));
    jEntry = JsonObjectSet(jEntry, "k", JsonInt(nChakra));
    jEntry = JsonObjectSet(jEntry, "m", JsonInt(nMeld));
    jEntry = JsonObjectSet(jEntry, "i", JsonInt(nInvest));
    jEntry = JsonObjectSet(jEntry, "e", JsonInt(bExpanded));
    jEntry = JsonObjectSet(jEntry, "b", JsonInt(nBind));
    jEntry = JsonObjectSet(jEntry, "t", JsonInt(nTotemBind));
    jEntry = JsonObjectSet(jEntry, "a", JsonInt(nAspect));
    jEntry = JsonObjectSet(jEntry, "q", JsonInt(nKind));
    return jEntry;
}

int MoiLoadoutField(json jEntry, string sField)
{
    json jValue = JsonObjectGet(jEntry, sField);
    if (JsonGetType(jValue) != JSON_TYPE_INTEGER)
        return 0;
    return JsonGetInt(jValue);
}

int MoiLoadoutIsSoulmeldEntry(json jEntry)
{
    return MoiLoadoutField(jEntry, "q") == PRC_MOI_LOADOUT_KIND_SOULMELD;
}

int MoiLoadoutIsReceptacleEntry(json jEntry)
{
    return MoiLoadoutField(jEntry, "q") == PRC_MOI_LOADOUT_KIND_RECEPTACLE;
}

int MoiLoadoutClassByIndex(int nIndex)
{
    switch (nIndex)
    {
        case 0: return CLASS_TYPE_INCARNATE;
        case 1: return CLASS_TYPE_SOULBORN;
        case 2: return CLASS_TYPE_TOTEMIST;
        case 3: return CLASS_TYPE_SPINEMELD_WARRIOR;
    }
    return -1;
}

int MoiLoadoutIsSupportedClass(int nClass)
{
    return nClass == CLASS_TYPE_INCARNATE
        || nClass == CLASS_TYPE_SOULBORN
        || nClass == CLASS_TYPE_TOTEMIST
        || nClass == CLASS_TYPE_SPINEMELD_WARRIOR;
}

string MoiLoadoutClassColumn(int nClass)
{
    if (nClass == CLASS_TYPE_INCARNATE) return "Incarnate";
    if (nClass == CLASS_TYPE_SOULBORN) return "Soulborn";
    if (nClass == CLASS_TYPE_TOTEMIST) return "Totemist";
    if (nClass == CLASS_TYPE_SPINEMELD_WARRIOR) return "Spinemeld";
    return "";
}

string MoiLoadoutClassName(int nClass)
{
    string sName = GetStringByStrRef(StringToInt(Get2DACache(
        "classes", "Name", nClass
    )));
    if (sName == "" || sName == "****")
        sName = MoiLoadoutClassColumn(nClass);
    return sName;
}

int MoiLoadoutClassMaximum(object oPC, int nClass)
{
    if (!MoiLoadoutIsSupportedClass(nClass)
        || GetLevelByClass(nClass, oPC) <= 0)
        return 0;
    if (nClass == CLASS_TYPE_INCARNATE && !IncarnateAlignment(oPC))
        return 0;

    int nMaximum = GetMaxShapeSoulmeldCount(oPC, nClass);
    if (nMaximum < 0)
        nMaximum = 0;
    if (nMaximum > PRC_MOI_LOADOUT_MAX_PER_CLASS)
        nMaximum = PRC_MOI_LOADOUT_MAX_PER_CLASS;
    return nMaximum;
}

int MoiLoadoutHasShapingClass(object oPC)
{
    int i;
    for (i = 0; i < 4; i++)
    {
        if (MoiLoadoutClassMaximum(oPC, MoiLoadoutClassByIndex(i)) > 0)
            return TRUE;
    }
    return FALSE;
}

int MoiLoadoutFirstClass(object oPC)
{
    int i;
    for (i = 0; i < 4; i++)
    {
        int nClass = MoiLoadoutClassByIndex(i);
        if (MoiLoadoutClassMaximum(oPC, nClass) > 0)
            return nClass;
    }
    return -1;
}

int MoiLoadoutFindMeldRow(int nMeld)
{
    if (nMeld <= 0)
        return -1;
    int nRows = Get2DARowCount(GetMeldFile());
    int i;
    for (i = 1; i < nRows; i++)
    {
        if (StringToInt(Get2DACache(GetMeldFile(), "SpellID", i)) == nMeld)
            return i;
    }
    return -1;
}

string MoiLoadoutMeldName(int nMeld)
{
    string sName = GetStringByStrRef(StringToInt(Get2DACache(
        "spells", "Name", nMeld
    )));
    if (sName == "" || sName == "****")
    {
        int nRow = MoiLoadoutFindMeldRow(nMeld);
        if (nRow > 0)
            sName = GetStringByStrRef(StringToInt(Get2DACache(
                GetMeldFile(), "Name", nRow
            )));
    }
    if (sName == "" || sName == "****")
        sName = "Soulmeld";
    return sName;
}

string MoiLoadoutMeldIcon(
    int nMeld,
    int nClass = CLASS_TYPE_INVALID,
    int bSoulmeld = TRUE
)
{
    string sIcon;

    // Soulmelds are granted by feats.  Use that feat's artwork throughout the
    // loadout editor; the wrapper spell icons are commonly shared placeholders.
    if (bSoulmeld)
    {
        int nRow = MoiLoadoutFindMeldRow(nMeld);
        if (nRow > 0)
        {
            int nFeat = StringToInt(Get2DACache(
                GetMeldFile(),
                "FeatID",
                nRow
            ));
            if (nFeat > 0)
                sIcon = Get2DACache("feat", "ICON", nFeat);
        }

        // A missing feat icon falls back to the class whose shaping slot owns
        // this entry.  Every soulmeld loadout row carries that class explicitly.
        if ((sIcon == "" || sIcon == "****")
            && MoiLoadoutIsSupportedClass(nClass))
            sIcon = Get2DACache("classes", "Icon", nClass);
    }
    else
    {
        // Non-soulmeld receptacles retain their existing spell-backed artwork.
        sIcon = Get2DACache("spells", "IconResRef", nMeld);
    }

    if (sIcon == "****")
        sIcon = "";
    return sIcon;
}

int MoiLoadoutSpecialCount()
{
    return 21;
}

int MoiLoadoutSpecialByIndex(int nIndex)
{
    switch (nIndex)
    {
        case 0: return MELD_DUSKLING_SPEED;
        case 1: return MELD_SPINE_ENHANCEMENT;
        case 2: return MELD_IRONSOUL_SHIELD;
        case 3: return MELD_IRONSOUL_ARMOR;
        case 4: return MELD_IRONSOUL_WEAPON;
        case 5: return MELD_UMBRAL_STEP;
        case 6: return MELD_UMBRAL_SHADOW;
        case 7: return MELD_UMBRAL_SIGHT;
        case 8: return MELD_UMBRAL_SOUL;
        case 9: return MELD_UMBRAL_KISS;
        case 10: return MELD_INCANDESCENT_STRIKE;
        case 11: return MELD_INCANDESCENT_HEAL;
        case 12: return MELD_INCANDESCENT_COUNTENANCE;
        case 13: return MELD_INCANDESCENT_RAY;
        case 14: return MELD_INCANDESCENT_AURA;
        case 15: return MELD_WITCH_MELDSHIELD;
        case 16: return MELD_WITCH_DISPEL;
        case 17: return MELD_WITCH_SHACKLES;
        case 18: return MELD_WITCH_ABROGATION;
        case 19: return MELD_WITCH_SPIRITFLAY;
        case 20: return MELD_WITCH_INTEGUMENT;
    }
    return 0;
}

int MoiLoadoutSpecialSource(int nMeld)
{
    if (nMeld == MELD_DUSKLING_SPEED) return -1;
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
    return -2;
}

int MoiLoadoutSpecialMinimumLevel(int nMeld)
{
    if (nMeld == MELD_SPINE_ENHANCEMENT) return 2;
    if (nMeld == MELD_IRONSOUL_SHIELD) return 1;
    if (nMeld == MELD_IRONSOUL_ARMOR) return 5;
    if (nMeld == MELD_IRONSOUL_WEAPON) return 9;
    if (nMeld == MELD_UMBRAL_STEP) return 1;
    if (nMeld == MELD_UMBRAL_SHADOW) return 3;
    if (nMeld == MELD_UMBRAL_SIGHT) return 7;
    if (nMeld == MELD_UMBRAL_SOUL) return 9;
    if (nMeld == MELD_UMBRAL_KISS) return 10;
    if (nMeld == MELD_INCANDESCENT_STRIKE) return 1;
    if (nMeld == MELD_INCANDESCENT_HEAL) return 2;
    if (nMeld == MELD_INCANDESCENT_COUNTENANCE) return 3;
    if (nMeld == MELD_INCANDESCENT_RAY) return 5;
    if (nMeld == MELD_INCANDESCENT_AURA) return 8;
    if (nMeld == MELD_WITCH_MELDSHIELD) return 1;
    if (nMeld == MELD_WITCH_DISPEL) return 2;
    if (nMeld == MELD_WITCH_SHACKLES) return 4;
    if (nMeld == MELD_WITCH_ABROGATION) return 6;
    if (nMeld == MELD_WITCH_SPIRITFLAY) return 8;
    if (nMeld == MELD_WITCH_INTEGUMENT) return 10;
    return 0;
}

int MoiLoadoutSpecialEligible(object oPC, int nMeld)
{
    if (nMeld == MELD_DUSKLING_SPEED)
        return GetRacialType(oPC) == RACIAL_TYPE_DUSKLING;
    int nClass = MoiLoadoutSpecialSource(nMeld);
    int nMinimum = MoiLoadoutSpecialMinimumLevel(nMeld);
    return nClass >= 0 && nMinimum > 0
        && GetLevelByClass(nClass, oPC) >= nMinimum;
}

string MoiLoadoutSpecialName(int nMeld)
{
    if (nMeld == MELD_DUSKLING_SPEED) return "Duskling Speed";
    if (nMeld == MELD_SPINE_ENHANCEMENT) return "Spine Enhancement";
    if (nMeld == MELD_IRONSOUL_SHIELD) return "Shield Bond";
    if (nMeld == MELD_IRONSOUL_ARMOR) return "Armor Bond";
    if (nMeld == MELD_IRONSOUL_WEAPON) return "Weapon Bond";
    if (nMeld == MELD_UMBRAL_STEP) return "Step of the Bodiless";
    if (nMeld == MELD_UMBRAL_SHADOW) return "Embrace of Shadow";
    if (nMeld == MELD_UMBRAL_SIGHT) return "Sight of the Eyeless";
    if (nMeld == MELD_UMBRAL_SOUL) return "Soulchilling Strike";
    if (nMeld == MELD_UMBRAL_KISS) return "Kiss of the Shadows";
    if (nMeld == MELD_INCANDESCENT_STRIKE) return "Incandescent Strike";
    if (nMeld == MELD_INCANDESCENT_HEAL) return "Incandescent Heal";
    if (nMeld == MELD_INCANDESCENT_COUNTENANCE)
        return "Incandescent Countenance";
    if (nMeld == MELD_INCANDESCENT_RAY) return "Incandescent Ray";
    if (nMeld == MELD_INCANDESCENT_AURA) return "Incandescent Aura";
    if (nMeld == MELD_WITCH_MELDSHIELD) return "Meldshield";
    if (nMeld == MELD_WITCH_DISPEL) return "Dispelling Orb";
    if (nMeld == MELD_WITCH_SHACKLES) return "Mage Shackles";
    if (nMeld == MELD_WITCH_ABROGATION) return "Word of Abrogation";
    if (nMeld == MELD_WITCH_SPIRITFLAY) return "Spiritflay";
    if (nMeld == MELD_WITCH_INTEGUMENT) return "Grim Integument";
    return "Incarnum receptacle";
}

string MoiLoadoutSpecialSourceName(int nMeld)
{
    int nClass = MoiLoadoutSpecialSource(nMeld);
    if (nClass == -1) return "Duskling";
    if (nClass >= 0) return MoiLoadoutClassName(nClass);
    return "Incarnum";
}

string MoiLoadoutChakraShort(int nChakra)
{
    int nBase = DoubleChakraToChakra(nChakra);
    if (nBase == CHAKRA_CROWN) return "Cr";
    if (nBase == CHAKRA_FEET) return "Ft";
    if (nBase == CHAKRA_HANDS) return "Hn";
    if (nBase == CHAKRA_ARMS) return "Ar";
    if (nBase == CHAKRA_BROW) return "Br";
    if (nBase == CHAKRA_SHOULDERS) return "Sh";
    if (nBase == CHAKRA_THROAT) return "Th";
    if (nBase == CHAKRA_WAIST) return "Wa";
    if (nBase == CHAKRA_HEART) return "He";
    if (nBase == CHAKRA_SOUL) return "So";
    if (nBase == CHAKRA_TOTEM) return "To";
    return "?";
}

string MoiLoadoutChakraName(int nChakra)
{
    string sName = ChakraToString(nChakra);
    if (nChakra >= CHAKRA_DOUBLE_CROWN)
        sName = "Double " + sName;
    return sName;
}

int MoiLoadoutDoubleChakraFeat(int nChakra)
{
    int nBase = DoubleChakraToChakra(nChakra);
    if (nBase == CHAKRA_CROWN) return FEAT_DOUBLE_CHAKRA_CROWN;
    if (nBase == CHAKRA_FEET) return FEAT_DOUBLE_CHAKRA_FEET;
    if (nBase == CHAKRA_HANDS) return FEAT_DOUBLE_CHAKRA_HANDS;
    if (nBase == CHAKRA_ARMS) return FEAT_DOUBLE_CHAKRA_ARMS;
    if (nBase == CHAKRA_BROW) return FEAT_DOUBLE_CHAKRA_BROW;
    if (nBase == CHAKRA_SHOULDERS) return FEAT_DOUBLE_CHAKRA_SHOULDERS;
    if (nBase == CHAKRA_THROAT) return FEAT_DOUBLE_CHAKRA_THROAT;
    if (nBase == CHAKRA_WAIST) return FEAT_DOUBLE_CHAKRA_WAIST;
    if (nBase == CHAKRA_HEART) return FEAT_DOUBLE_CHAKRA_HEART;
    if (nBase == CHAKRA_SOUL) return FEAT_DOUBLE_CHAKRA_SOUL;
    if (nBase == CHAKRA_TOTEM) return FEAT_DOUBLE_CHAKRA_TOTEM;
    return 0;
}

int MoiLoadoutSoulmeldAlignment(object oPC, int nMeld, int nClass)
{
    int bLaw = GetHasDescriptor(nMeld, DESCRIPTOR_LAWFUL);
    int bChaos = GetHasDescriptor(nMeld, DESCRIPTOR_CHAOTIC);
    int bGood = GetHasDescriptor(nMeld, DESCRIPTOR_GOOD);
    int bEvil = GetHasDescriptor(nMeld, DESCRIPTOR_EVIL);
    int bAllowed = TRUE;

    if (nClass == CLASS_TYPE_SOULBORN)
    {
        if (GetAlignmentLawChaos(oPC) == ALIGNMENT_CHAOTIC
            && GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL
            && (bGood || bLaw)) bAllowed = FALSE;
        if (GetAlignmentLawChaos(oPC) == ALIGNMENT_CHAOTIC
            && GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD
            && (bEvil || bLaw)) bAllowed = FALSE;
        if (GetAlignmentLawChaos(oPC) == ALIGNMENT_LAWFUL
            && GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD
            && (bChaos || bEvil)) bAllowed = FALSE;
        if (GetAlignmentLawChaos(oPC) == ALIGNMENT_LAWFUL
            && GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL
            && (bGood || bChaos)) bAllowed = FALSE;
    }
    else if (nClass == CLASS_TYPE_INCARNATE)
    {
        if (GetAlignmentLawChaos(oPC) == ALIGNMENT_CHAOTIC
            && (bGood || bLaw || bEvil)) bAllowed = FALSE;
        if (GetAlignmentLawChaos(oPC) == ALIGNMENT_LAWFUL
            && (bGood || bChaos || bEvil)) bAllowed = FALSE;
        if (GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD
            && (bChaos || bLaw || bEvil)) bAllowed = FALSE;
        if (GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL
            && (bChaos || bLaw || bGood)) bAllowed = FALSE;
    }

    if (GetAlignmentGoodEvil(oPC) != ALIGNMENT_GOOD
        && GetHasFeat(FEAT_NECROCARNUM_ACOLYTE, oPC)
        && GetIsNecrocarnumMeld(nMeld))
        bAllowed = TRUE;
    return bAllowed;
}

int MoiLoadoutDragonbloodAllowed(object oPC, int nMeld)
{
    if (nMeld == MELD_CLAW_OF_THE_WYRM
        || nMeld == MELD_DRAGON_MANTLE
        || nMeld == MELD_DRAGON_TAIL
        || nMeld == MELD_DRAGONFIRE_MASK
        || nMeld == MELD_ELDER_SPIRIT)
        return GetIsDragonblooded(oPC);
    return TRUE;
}

int MoiLoadoutMeldEligible(
    object oPC,
    int nClass,
    int nRawChakra,
    int nMeld
)
{
    if (MoiLoadoutClassMaximum(oPC, nClass) <= 0
        || nRawChakra < CHAKRA_CROWN
        || nRawChakra > CHAKRA_DOUBLE_SOUL
        || nRawChakra == CHAKRA_TOTEM)
        return FALSE;

    int nRow = MoiLoadoutFindMeldRow(nMeld);
    if (nRow <= 0)
        return FALSE;

    string sClassColumn = MoiLoadoutClassColumn(nClass);
    int nBaseChakra = DoubleChakraToChakra(nRawChakra);
    if (StringToInt(Get2DACache(GetMeldFile(), sClassColumn, nRow)) <= 0
        || StringToInt(Get2DACache(
            GetMeldFile(), ChakraToString(nBaseChakra), nRow
        )) != nBaseChakra)
        return FALSE;

    return MoiLoadoutSoulmeldAlignment(oPC, nMeld, nClass)
        && MoiLoadoutDragonbloodAllowed(oPC, nMeld);
}

int MoiLoadoutMeldSupportsTotem(int nMeld)
{
    int nRow = MoiLoadoutFindMeldRow(nMeld);
    return nRow > 0
        && StringToInt(Get2DACache(GetMeldFile(), "Totem", nRow))
            == CHAKRA_TOTEM;
}

json MoiLoadoutGetDraft(object oPC)
{
    json jDraft = GetLocalJson(oPC, PRC_MOI_LOADOUT_DRAFT_VAR);
    if (JsonGetType(jDraft) != JSON_TYPE_ARRAY)
        return JsonArray();
    return jDraft;
}

void MoiLoadoutSetDraft(object oPC, json jDraft)
{
    if (JsonGetType(jDraft) != JSON_TYPE_ARRAY)
        jDraft = JsonArray();
    SetLocalJson(oPC, PRC_MOI_LOADOUT_DRAFT_VAR, jDraft);
}

int MoiLoadoutFindClassChakra(json jDraft, int nClass, int nChakra)
{
    int i;
    for (i = 0; i < JsonGetLength(jDraft); i++)
    {
        json jEntry = JsonArrayGet(jDraft, i);
        if (MoiLoadoutIsSoulmeldEntry(jEntry)
            && MoiLoadoutField(jEntry, "c") == nClass
            && MoiLoadoutField(jEntry, "k") == nChakra)
            return i;
    }
    return -1;
}

int MoiLoadoutFindMeld(json jDraft, int nMeld)
{
    int i;
    for (i = 0; i < JsonGetLength(jDraft); i++)
    {
        json jEntry = JsonArrayGet(jDraft, i);
        if (MoiLoadoutIsSoulmeldEntry(jEntry)
            && MoiLoadoutField(jEntry, "m") == nMeld)
            return i;
    }
    return -1;
}

int MoiLoadoutClassCount(json jDraft, int nClass)
{
    int nCount;
    int i;
    for (i = 0; i < JsonGetLength(jDraft); i++)
    {
        json jEntry = JsonArrayGet(jDraft, i);
        if (MoiLoadoutIsSoulmeldEntry(jEntry)
            && MoiLoadoutField(jEntry, "c") == nClass)
            nCount++;
    }
    return nCount;
}

int MoiLoadoutSoulmeldCount(json jDraft)
{
    int nCount;
    int i;
    for (i = 0; i < JsonGetLength(jDraft); i++)
        nCount += MoiLoadoutIsSoulmeldEntry(JsonArrayGet(jDraft, i));
    return nCount;
}

int MoiLoadoutFindSpecial(json jDraft, int nMeld)
{
    int i;
    for (i = 0; i < JsonGetLength(jDraft); i++)
    {
        json jEntry = JsonArrayGet(jDraft, i);
        if (MoiLoadoutIsReceptacleEntry(jEntry)
            && MoiLoadoutField(jEntry, "m") == nMeld)
            return i;
    }
    return -1;
}

json MoiLoadoutEnsureSpecialEntries(
    object oPC,
    json jDraft,
    int bCaptureLive = FALSE
)
{
    int i;
    for (i = 0; i < MoiLoadoutSpecialCount(); i++)
    {
        int nMeld = MoiLoadoutSpecialByIndex(i);
        if (!MoiLoadoutSpecialEligible(oPC, nMeld)
            || MoiLoadoutFindSpecial(jDraft, nMeld) >= 0)
            continue;
        int nInvest;
        if (bCaptureLive)
            nInvest = GetLocalInt(
                oPC,
                "MeldEssentia" + IntToString(nMeld)
            );
        jDraft = JsonArrayInsert(jDraft, MoiLoadoutEntry(
            MoiLoadoutSpecialSource(nMeld),
            0,
            nMeld,
            nInvest,
            FALSE,
            0,
            0,
            0,
            PRC_MOI_LOADOUT_KIND_RECEPTACLE
        ));
    }
    return jDraft;
}

int MoiLoadoutHasClassChakra(json jDraft, int nClass, int nChakra)
{
    return MoiLoadoutFindClassChakra(jDraft, nClass, nChakra) >= 0;
}

json MoiLoadoutRemoveIndex(json jDraft, int nRemove)
{
    json jNew = JsonArray();
    int i;
    for (i = 0; i < JsonGetLength(jDraft); i++)
    {
        if (i != nRemove)
            jNew = JsonArrayInsert(jNew, JsonArrayGet(jDraft, i));
    }
    return jNew;
}

int MoiLoadoutRemoveSlot(object oPC, int nClass, int nChakra)
{
    json jDraft = MoiLoadoutGetDraft(oPC);
    int nIndex = MoiLoadoutFindClassChakra(jDraft, nClass, nChakra);
    if (nIndex < 0)
        return FALSE;
    jDraft = MoiLoadoutRemoveIndex(jDraft, nIndex);

    // A double placement is only legal while its matching base is occupied.
    if (nChakra >= CHAKRA_CROWN && nChakra <= CHAKRA_SOUL)
    {
        int nDouble = nChakra + 11;
        nIndex = MoiLoadoutFindClassChakra(jDraft, nClass, nDouble);
        if (nIndex >= 0)
            jDraft = MoiLoadoutRemoveIndex(jDraft, nIndex);
    }
    MoiLoadoutSetDraft(oPC, jDraft);
    return TRUE;
}

string MoiLoadoutSelectMeld(
    object oPC,
    int nClass,
    int nChakra,
    int nMeld
)
{
    if (!MoiLoadoutMeldEligible(oPC, nClass, nChakra, nMeld))
        return "That soulmeld is not legal for this class and chakra.";

    json jDraft = MoiLoadoutGetDraft(oPC);
    int nExistingMeld = MoiLoadoutFindMeld(jDraft, nMeld);
    int nSlot = MoiLoadoutFindClassChakra(jDraft, nClass, nChakra);
    if (nExistingMeld >= 0 && nExistingMeld != nSlot)
        return "A soulmeld may appear only once in a saved loadout.";
    if (nSlot >= 0
        && MoiLoadoutField(JsonArrayGet(jDraft, nSlot), "m") == nMeld)
        return "";

    if (nChakra >= CHAKRA_DOUBLE_CROWN)
    {
        int nBase = DoubleChakraToChakra(nChakra);
        int nFeat = MoiLoadoutDoubleChakraFeat(nChakra);
        if (!MoiLoadoutHasClassChakra(jDraft, nClass, nBase)
            || nFeat <= 0 || !GetHasFeat(nFeat, oPC))
            return "Fill the matching base chakra and learn its Double Chakra feat first.";
    }

    if (nSlot < 0
        && MoiLoadoutClassCount(jDraft, nClass)
            >= MoiLoadoutClassMaximum(oPC, nClass))
        return "Every shaped-soulmeld slot for this class is already filled.";

    json jEntry = MoiLoadoutEntry(nClass, nChakra, nMeld);
    if (nSlot >= 0)
        jDraft = JsonArraySet(jDraft, nSlot, jEntry);
    else
        jDraft = JsonArrayInsert(jDraft, jEntry);
    MoiLoadoutSetDraft(oPC, jDraft);
    return "";
}

int MoiLoadoutExpandedFeatCount(object oPC)
{
    int nCount;
    if (GetHasFeat(FEAT_EXPANDED_SOULMELD_CAPACITY_1, oPC)) nCount++;
    if (GetHasFeat(FEAT_EXPANDED_SOULMELD_CAPACITY_2, oPC)) nCount++;
    if (GetHasFeat(FEAT_EXPANDED_SOULMELD_CAPACITY_3, oPC)) nCount++;
    if (GetHasFeat(FEAT_EXPANDED_SOULMELD_CAPACITY_4, oPC)) nCount++;
    if (GetHasFeat(FEAT_EXPANDED_SOULMELD_CAPACITY_5, oPC)) nCount++;
    return nCount;
}

int MoiLoadoutExpandedCount(json jDraft)
{
    int nCount;
    int i;
    for (i = 0; i < JsonGetLength(jDraft); i++)
    {
        json jEntry = JsonArrayGet(jDraft, i);
        if (MoiLoadoutIsSoulmeldEntry(jEntry))
            nCount += MoiLoadoutField(jEntry, "e") != 0;
    }
    return nCount;
}

int MoiLoadoutInvestedTotal(json jDraft)
{
    int nTotal;
    int i;
    for (i = 0; i < JsonGetLength(jDraft); i++)
        nTotal += MoiLoadoutField(JsonArrayGet(jDraft, i), "i");
    return nTotal;
}

int MoiLoadoutCapacity(object oPC, json jEntry)
{
    int nClass = MoiLoadoutField(jEntry, "c");
    int nMeld = MoiLoadoutField(jEntry, "m");
    int nHD = GetHitDice(oPC);
    int nMaximum = 1;
    if (nHD >= 61) nMaximum = 8;
    else if (nHD >= 51) nMaximum = 7;
    else if (nHD >= 41) nMaximum = 6;
    else if (nHD >= 31) nMaximum = 5;
    else if (nHD >= 18) nMaximum = 4;
    else if (nHD >= 12) nMaximum = 3;
    else if (nHD >= 6) nMaximum = 2;

    // Class and racial receptacles use the generic hit-die capacity.  Spine
    // Enhancement is the sole special exception in the PRC investment path.
    if (MoiLoadoutIsReceptacleEntry(jEntry))
    {
        if (nMeld == MELD_SPINE_ENHANCEMENT)
            nMaximum = GetLevelByClass(
                CLASS_TYPE_SPINEMELD_WARRIOR,
                oPC
            ) / 2;
        return nMaximum;
    }

    if (nClass == CLASS_TYPE_INCARNATE
        && GetLevelByClass(CLASS_TYPE_INCARNATE, oPC) >= 3) nMaximum++;
    if (nClass == CLASS_TYPE_INCARNATE
        && GetLevelByClass(CLASS_TYPE_INCARNATE, oPC) >= 15) nMaximum++;

    int nPhysicalBind = MoiLoadoutField(jEntry, "b");
    int nTotemBind = MoiLoadoutField(jEntry, "t");
    // Mirror GetIsMeldBound/GetMaxEssentiaCapacity exactly: the highest
    // numbered destination wins, and only regular Totem grants this bonus.
    int nReportedBind = PRCMax(nPhysicalBind, nTotemBind);
    if (nClass == CLASS_TYPE_TOTEMIST
        && nReportedBind == CHAKRA_TOTEM)
    {
        nMaximum++;
        if (GetLevelByClass(CLASS_TYPE_TOTEMIST, oPC) >= 15)
            nMaximum++;
        if (GetLevelByClass(CLASS_TYPE_TOTEM_RAGER, oPC) >= 10)
            nMaximum++;
    }

    if (GetIsNecrocarnumMeld(nMeld)
        && GetLevelByClass(CLASS_TYPE_NECROCARNATE, oPC) >= 9)
        nMaximum++;
    // A completed-rest default must not depend on six-second capacity buffs
    // such as Divine Soultouch or Incandescent Overload.
    if (MoiLoadoutField(jEntry, "e"))
        nMaximum++;

    return nMaximum;
}

string MoiLoadoutAdjustInvestment(object oPC, int nIndex, int nDelta)
{
    json jDraft = MoiLoadoutGetDraft(oPC);
    if (nIndex < 0 || nIndex >= JsonGetLength(jDraft))
        return "That essentia selection is stale. Reopen the loadout.";

    json jEntry = JsonArrayGet(jDraft, nIndex);
    int nOld = MoiLoadoutField(jEntry, "i");
    int nNew = nOld + nDelta;
    int nMaximum = MoiLoadoutCapacity(oPC, jEntry);
    if (nNew < 0) nNew = 0;
    if (nNew > nMaximum) nNew = nMaximum;
    if (nNew > nOld
        && MoiLoadoutInvestedTotal(jDraft) - nOld + nNew
            > GetTotalEssentia(oPC))
        return "The saved Incarnum pool has no free essentia.";

    jEntry = JsonObjectSet(jEntry, "i", JsonInt(nNew));
    jDraft = JsonArraySet(jDraft, nIndex, jEntry);
    MoiLoadoutSetDraft(oPC, jDraft);
    return "";
}

string MoiLoadoutToggleExpanded(object oPC, int nIndex)
{
    json jDraft = MoiLoadoutGetDraft(oPC);
    if (nIndex < 0 || nIndex >= JsonGetLength(jDraft))
        return "That soulmeld selection is stale. Reopen the loadout.";

    json jEntry = JsonArrayGet(jDraft, nIndex);
    if (!MoiLoadoutIsSoulmeldEntry(jEntry))
        return "Expanded Soulmeld Capacity applies only to shaped soulmelds.";
    int bExpanded = MoiLoadoutField(jEntry, "e");
    if (!bExpanded
        && MoiLoadoutExpandedCount(jDraft)
            >= MoiLoadoutExpandedFeatCount(oPC))
        return "Every Expanded Soulmeld Capacity choice is already assigned.";

    jEntry = JsonObjectSet(jEntry, "e", JsonInt(!bExpanded));
    int nInvest = MoiLoadoutField(jEntry, "i");
    int nMaximum = MoiLoadoutCapacity(oPC, jEntry);
    if (nInvest > nMaximum)
        jEntry = JsonObjectSet(jEntry, "i", JsonInt(nMaximum));
    jDraft = JsonArraySet(jDraft, nIndex, jEntry);
    MoiLoadoutSetDraft(oPC, jDraft);
    return "";
}

int MoiLoadoutBindCount(json jDraft, int nClass)
{
    int nCount;
    int i;
    for (i = 0; i < JsonGetLength(jDraft); i++)
    {
        json jEntry = JsonArrayGet(jDraft, i);
        if (MoiLoadoutIsSoulmeldEntry(jEntry)
            && MoiLoadoutField(jEntry, "c") == nClass)
        {
            if (MoiLoadoutField(jEntry, "b")) nCount++;
            if (MoiLoadoutField(jEntry, "t")) nCount++;
        }
    }
    return nCount;
}

int MoiLoadoutBindDestinationUsed(json jDraft, int nDestination, int nIgnore)
{
    int i;
    for (i = 0; i < JsonGetLength(jDraft); i++)
    {
        if (i == nIgnore)
            continue;
        json jEntry = JsonArrayGet(jDraft, i);
        if (!MoiLoadoutIsSoulmeldEntry(jEntry))
            continue;
        if (MoiLoadoutField(jEntry, "b") == nDestination
            || MoiLoadoutField(jEntry, "t") == nDestination)
            return TRUE;
    }
    return FALSE;
}

string MoiLoadoutToggleStandardBind(object oPC, int nIndex)
{
    json jDraft = MoiLoadoutGetDraft(oPC);
    if (nIndex < 0 || nIndex >= JsonGetLength(jDraft))
        return "That soulmeld selection is stale. Reopen the loadout.";
    json jEntry = JsonArrayGet(jDraft, nIndex);
    if (!MoiLoadoutIsSoulmeldEntry(jEntry))
        return "Class and racial receptacles cannot be chakra-bound.";
    int nClass = MoiLoadoutField(jEntry, "c");
    int nChakra = MoiLoadoutField(jEntry, "k");
    int nCurrent = MoiLoadoutField(jEntry, "b");

    if (nCurrent)
        jEntry = JsonObjectSet(jEntry, "b", JsonInt(0));
    else
    {
        if (!GetCanBindChakra(oPC, nChakra)
            || (nChakra >= CHAKRA_DOUBLE_CROWN
                && !GetCanBindChakra(oPC, DoubleChakraToChakra(nChakra))))
            return "That chakra is not open for binding.";
        if (MoiLoadoutBindDestinationUsed(jDraft, nChakra, nIndex))
            return "That bind destination is already occupied.";
        if (MoiLoadoutBindCount(jDraft, nClass)
            >= GetMaxBindCount(oPC, nClass))
            return "Every chakra bind available to this class is already assigned.";
        if (MoiLoadoutField(jEntry, "t")
            && GetLevelByClass(CLASS_TYPE_TOTEMIST, oPC) < 11)
            return "Totemist level 11 is required to bind one meld to both Totem and its physical chakra.";
        jEntry = JsonObjectSet(jEntry, "b", JsonInt(nChakra));
        if (MoiLoadoutField(jEntry, "m") == MELD_ASTRAL_VAMBRACES
            && DoubleChakraToChakra(nChakra) == CHAKRA_ARMS
            && MoiLoadoutField(jEntry, "a") == 0)
            jEntry = JsonObjectSet(jEntry, "a", JsonInt(1));
    }

    int nInvest = MoiLoadoutField(jEntry, "i");
    int nMaximum = MoiLoadoutCapacity(oPC, jEntry);
    if (nInvest > nMaximum)
        jEntry = JsonObjectSet(jEntry, "i", JsonInt(nMaximum));
    jDraft = JsonArraySet(jDraft, nIndex, jEntry);
    MoiLoadoutSetDraft(oPC, jDraft);
    return "";
}

string MoiLoadoutToggleTotemBind(
    object oPC,
    int nIndex,
    int nDestination
)
{
    json jDraft = MoiLoadoutGetDraft(oPC);
    if (nIndex < 0 || nIndex >= JsonGetLength(jDraft))
        return "That soulmeld selection is stale. Reopen the loadout.";
    json jEntry = JsonArrayGet(jDraft, nIndex);
    if (!MoiLoadoutIsSoulmeldEntry(jEntry))
        return "Class and racial receptacles cannot be Totem-bound.";
    int nClass = MoiLoadoutField(jEntry, "c");
    int nMeld = MoiLoadoutField(jEntry, "m");
    int nCurrent = MoiLoadoutField(jEntry, "t");

    if (nCurrent == nDestination)
    {
        // Do not strand a Double Totem assignment without regular Totem.
        if (nDestination == CHAKRA_TOTEM
            && MoiLoadoutBindDestinationUsed(
                jDraft,
                CHAKRA_DOUBLE_TOTEM,
                nIndex
            ))
            return "Clear the Double Totem bind before clearing regular Totem.";
        jEntry = JsonObjectSet(jEntry, "t", JsonInt(0));
        int nInvest = MoiLoadoutField(jEntry, "i");
        int nMaximum = MoiLoadoutCapacity(oPC, jEntry);
        if (nInvest > nMaximum)
            jEntry = JsonObjectSet(jEntry, "i", JsonInt(nMaximum));
    }
    else
    {
        if (nClass != CLASS_TYPE_TOTEMIST
            || GetLevelByClass(CLASS_TYPE_TOTEMIST, oPC) < 2
            || !MoiLoadoutMeldSupportsTotem(nMeld))
            return "Only an eligible Totemist soulmeld may bind to Totem.";
        if (nDestination != CHAKRA_TOTEM
            && nDestination != CHAKRA_DOUBLE_TOTEM)
            return "That is not a Totem bind destination.";
        if (nDestination == CHAKRA_DOUBLE_TOTEM)
        {
            if (!GetHasFeat(FEAT_DOUBLE_CHAKRA_TOTEM, oPC))
                return "Double Chakra (Totem) is required.";
            if (!MoiLoadoutBindDestinationUsed(
                jDraft,
                CHAKRA_TOTEM,
                nIndex
            ))
                return "Assign a different soulmeld to regular Totem first.";
        }
        if (MoiLoadoutBindDestinationUsed(jDraft, nDestination, nIndex))
            return "That Totem bind destination is already occupied.";
        if (MoiLoadoutBindCount(jDraft, nClass)
            - (nCurrent != 0)
            >= GetMaxBindCount(oPC, nClass))
            return "Every chakra bind available to Totemist is already assigned.";
        if (MoiLoadoutField(jEntry, "b")
            && GetLevelByClass(CLASS_TYPE_TOTEMIST, oPC) < 11)
            return "Totemist level 11 is required to bind one meld to both Totem and its physical chakra.";
        jEntry = JsonObjectSet(jEntry, "t", JsonInt(nDestination));
    }

    int nInvest = MoiLoadoutField(jEntry, "i");
    int nMaximum = MoiLoadoutCapacity(oPC, jEntry);
    if (nInvest > nMaximum)
        jEntry = JsonObjectSet(jEntry, "i", JsonInt(nMaximum));
    jDraft = JsonArraySet(jDraft, nIndex, jEntry);
    MoiLoadoutSetDraft(oPC, jDraft);
    return "";
}

string MoiLoadoutAstralName(int nAspect)
{
    if (nAspect == 1) return "Buff";
    if (nAspect == 2) return "Celerity";
    if (nAspect == 3) return "Cleave";
    if (nAspect == 4) return "Deflection";
    if (nAspect == 5) return "Improved Bull Rush";
    if (nAspect == 6) return "Mobility";
    if (nAspect == 7) return "Power Attack";
    if (nAspect == 8) return "Resist Acid";
    if (nAspect == 9) return "Resist Cold";
    if (nAspect == 10) return "Resist Electrical";
    if (nAspect == 11) return "Resist Fire";
    if (nAspect == 12) return "Resist Sonic";
    return "Choose aspect";
}

string MoiLoadoutAdjustAspect(object oPC, int nIndex, int nDelta)
{
    json jDraft = MoiLoadoutGetDraft(oPC);
    if (nIndex < 0 || nIndex >= JsonGetLength(jDraft))
        return "That soulmeld selection is stale. Reopen the loadout.";
    json jEntry = JsonArrayGet(jDraft, nIndex);
    if (!MoiLoadoutIsSoulmeldEntry(jEntry))
        return "Only Astral Vambraces has an aspect choice.";
    if (MoiLoadoutField(jEntry, "m") != MELD_ASTRAL_VAMBRACES
        || DoubleChakraToChakra(MoiLoadoutField(jEntry, "b"))
            != CHAKRA_ARMS)
        return "Astral Vambraces is not bound to Arms.";

    int nAspect = MoiLoadoutField(jEntry, "a") + nDelta;
    if (nAspect < 1) nAspect = 12;
    if (nAspect > 12) nAspect = 1;
    jEntry = JsonObjectSet(jEntry, "a", JsonInt(nAspect));
    jDraft = JsonArraySet(jDraft, nIndex, jEntry);
    MoiLoadoutSetDraft(oPC, jDraft);
    return "";
}

int MoiLoadoutClassBindCount(json jDraft, int nClass)
{
    return MoiLoadoutBindCount(jDraft, nClass);
}

string MoiLoadoutValidate(object oPC, json jDraft)
{
    if (!GetIsObjectValid(oPC) || !GetIsPC(oPC))
        return "The Incarnum loadout has no valid character owner.";
    if (JsonGetType(jDraft) != JSON_TYPE_ARRAY)
        return "The Incarnum loadout data is not an array.";

    int nLength = JsonGetLength(jDraft);
    if (nLength <= 0)
        return "Choose the soulmelds you want to shape before saving.";
    if (nLength > PRC_MOI_LOADOUT_MAX_ENTRIES)
        return "The Incarnum loadout contains too many entries.";

    json jMelds = JsonObject();
    json jSpecials = JsonObject();
    json jSlots = JsonObject();
    json jBinds = JsonObject();
    int nExpanded;
    int nInvested;
    int nRegularTotem;
    int nDoubleTotem;
    int i;
    for (i = 0; i < nLength; i++)
    {
        json jEntry = JsonArrayGet(jDraft, i);
        if (JsonGetType(jEntry) != JSON_TYPE_OBJECT)
            return "The Incarnum loadout contains a malformed entry.";

        int nClass = MoiLoadoutField(jEntry, "c");
        int nChakra = MoiLoadoutField(jEntry, "k");
        int nMeld = MoiLoadoutField(jEntry, "m");
        int nInvest = MoiLoadoutField(jEntry, "i");
        int bExpanded = MoiLoadoutField(jEntry, "e");
        int nBind = MoiLoadoutField(jEntry, "b");
        int nTotem = MoiLoadoutField(jEntry, "t");
        int nAspect = MoiLoadoutField(jEntry, "a");
        int nKind = MoiLoadoutField(jEntry, "q");

        if (nKind != PRC_MOI_LOADOUT_KIND_SOULMELD
            && nKind != PRC_MOI_LOADOUT_KIND_RECEPTACLE)
            return "The Incarnum loadout contains an unknown entry kind.";

        if (nKind == PRC_MOI_LOADOUT_KIND_RECEPTACLE)
        {
            if (!MoiLoadoutSpecialEligible(oPC, nMeld)
                || nClass != MoiLoadoutSpecialSource(nMeld))
                return MoiLoadoutSpecialName(nMeld)
                     + " is no longer available to this character.";
            if (nChakra || bExpanded || nBind || nTotem || nAspect)
                return MoiLoadoutSpecialName(nMeld)
                     + " contains invalid soulmeld-only settings.";
            string sSpecialKey = IntToString(nMeld);
            if (JsonObjectGet(jSpecials, sSpecialKey) != JsonNull())
                return MoiLoadoutSpecialName(nMeld)
                     + " appears more than once.";
            jSpecials = JsonObjectSet(
                jSpecials,
                sSpecialKey,
                JsonBool(TRUE)
            );
            if (nInvest < 0 || nInvest > MoiLoadoutCapacity(oPC, jEntry))
                return MoiLoadoutSpecialName(nMeld)
                     + " exceeds its current essentia capacity.";
            nInvested += nInvest;
            continue;
        }

        if (!MoiLoadoutIsSupportedClass(nClass)
            || MoiLoadoutClassMaximum(oPC, nClass) <= 0)
            return "A saved meldshaping class is no longer available.";
        if (!MoiLoadoutMeldEligible(oPC, nClass, nChakra, nMeld))
            return MoiLoadoutMeldName(nMeld)
                 + " is no longer legal for its saved class and chakra.";

        string sMeldKey = IntToString(nMeld);
        if (JsonObjectGet(jMelds, sMeldKey) != JsonNull())
            return MoiLoadoutMeldName(nMeld)
                 + " appears more than once. Soulmeld allocations are character-wide.";
        jMelds = JsonObjectSet(jMelds, sMeldKey, JsonBool(TRUE));

        string sSlotKey = IntToString(nClass) + "_" + IntToString(nChakra);
        if (JsonObjectGet(jSlots, sSlotKey) != JsonNull())
            return "Two soulmelds occupy the same class chakra slot.";
        jSlots = JsonObjectSet(jSlots, sSlotKey, JsonBool(TRUE));

        if (nChakra >= CHAKRA_DOUBLE_CROWN)
        {
            int nBase = DoubleChakraToChakra(nChakra);
            int nFeat = MoiLoadoutDoubleChakraFeat(nChakra);
            if (nFeat <= 0 || !GetHasFeat(nFeat, oPC))
                return MoiLoadoutChakraName(nChakra)
                     + " is no longer unlocked.";
        }

        if (bExpanded != 0 && bExpanded != 1)
            return "An Expanded Soulmeld Capacity assignment is malformed.";
        nExpanded += bExpanded;

        if (nInvest < 0 || nInvest > MoiLoadoutCapacity(oPC, jEntry))
            return MoiLoadoutMeldName(nMeld)
                 + " exceeds its current essentia capacity.";
        nInvested += nInvest;

        if (nBind)
        {
            if (nBind != nChakra)
                return MoiLoadoutMeldName(nMeld)
                     + " is bound to a chakra it does not occupy.";
            if (!GetCanBindChakra(oPC, nBind)
                || (nBind >= CHAKRA_DOUBLE_CROWN
                    && !GetCanBindChakra(
                        oPC,
                        DoubleChakraToChakra(nBind)
                    )))
                return MoiLoadoutChakraName(nBind)
                     + " is not open for binding.";
            string sBindKey = IntToString(nBind);
            if (JsonObjectGet(jBinds, sBindKey) != JsonNull())
                return "Two soulmelds use the same bind destination.";
            jBinds = JsonObjectSet(jBinds, sBindKey, JsonBool(TRUE));
        }

        if (nTotem)
        {
            if (nClass != CLASS_TYPE_TOTEMIST
                || GetLevelByClass(CLASS_TYPE_TOTEMIST, oPC) < 2
                || !MoiLoadoutMeldSupportsTotem(nMeld))
                return MoiLoadoutMeldName(nMeld)
                     + " can no longer bind to Totem.";
            if (nTotem != CHAKRA_TOTEM
                && nTotem != CHAKRA_DOUBLE_TOTEM)
                return "A Totem bind destination is malformed.";
            if (nTotem == CHAKRA_DOUBLE_TOTEM
                && !GetHasFeat(FEAT_DOUBLE_CHAKRA_TOTEM, oPC))
                return "Double Chakra (Totem) is no longer available.";
            string sTotemKey = IntToString(nTotem);
            if (JsonObjectGet(jBinds, sTotemKey) != JsonNull())
                return "Two soulmelds use the same Totem bind destination.";
            jBinds = JsonObjectSet(jBinds, sTotemKey, JsonBool(TRUE));
            if (nTotem == CHAKRA_TOTEM) nRegularTotem++;
            if (nTotem == CHAKRA_DOUBLE_TOTEM) nDoubleTotem++;
        }

        if (nBind && nTotem
            && (nClass != CLASS_TYPE_TOTEMIST
                || GetLevelByClass(CLASS_TYPE_TOTEMIST, oPC) < 11))
            return "Totemist level 11 is required for a meld to bind twice.";

        if (nMeld == MELD_ASTRAL_VAMBRACES
            && nBind
            && DoubleChakraToChakra(nBind) == CHAKRA_ARMS)
        {
            if (nAspect < 1 || nAspect > 12)
                return "Choose an Astral Vambraces Arms aspect.";
        }
    }

    // Every double physical slot needs its matching base occupied by the same
    // class.  This second pass is order-independent.
    for (i = 0; i < nLength; i++)
    {
        json jEntry = JsonArrayGet(jDraft, i);
        if (!MoiLoadoutIsSoulmeldEntry(jEntry))
            continue;
        int nClass = MoiLoadoutField(jEntry, "c");
        int nChakra = MoiLoadoutField(jEntry, "k");
        if (nChakra >= CHAKRA_DOUBLE_CROWN)
        {
            string sBaseKey = IntToString(nClass) + "_"
                            + IntToString(DoubleChakraToChakra(nChakra));
            if (JsonObjectGet(jSlots, sBaseKey) == JsonNull())
                return MoiLoadoutChakraName(nChakra)
                     + " requires its matching base chakra to be filled.";
        }
    }

    if (nDoubleTotem && !nRegularTotem)
        return "Double Totem requires a different meld in regular Totem first.";
    if (nExpanded > MoiLoadoutExpandedFeatCount(oPC))
        return "The loadout assigns more Expanded Soulmeld Capacity choices than you have.";
    if (nInvested > GetTotalEssentia(oPC))
        return "The loadout assigns " + IntToString(nInvested)
             + " essentia, but this character has only "
             + IntToString(GetTotalEssentia(oPC)) + ".";

    for (i = 0; i < 4; i++)
    {
        int nClass = MoiLoadoutClassByIndex(i);
        int nRequired = MoiLoadoutClassMaximum(oPC, nClass);
        int nSelected = MoiLoadoutClassCount(jDraft, nClass);
        if (nSelected != nRequired)
            return MoiLoadoutClassName(nClass) + " needs exactly "
                 + IntToString(nRequired) + " shaped soulmelds; the loadout has "
                 + IntToString(nSelected) + ".";
        if (MoiLoadoutClassBindCount(jDraft, nClass)
            > GetMaxBindCount(oPC, nClass))
            return MoiLoadoutClassName(nClass)
                 + " exceeds its available chakra binds.";
    }
    return "";
}

json MoiLoadoutReadSaved(object oPC)
{
    if (GetPersistantLocalInt(oPC, PRC_MOI_LOADOUT_VERSION_VAR)
            != PRC_MOI_LOADOUT_VERSION)
        return JsonNull();

    int nSize = persistant_array_get_size(oPC, PRC_MOI_LOADOUT_CLASS_ARRAY);
    int nKindSize = persistant_array_get_size(
        oPC,
        PRC_MOI_LOADOUT_KIND_ARRAY
    );
    if (nSize <= 0 || nSize > PRC_MOI_LOADOUT_MAX_ENTRIES
        || persistant_array_get_size(oPC, PRC_MOI_LOADOUT_CHAKRA_ARRAY) != nSize
        || persistant_array_get_size(oPC, PRC_MOI_LOADOUT_MELD_ARRAY) != nSize
        || persistant_array_get_size(oPC, PRC_MOI_LOADOUT_INVEST_ARRAY) != nSize
        || persistant_array_get_size(oPC, PRC_MOI_LOADOUT_EXPANDED_ARRAY) != nSize
        || persistant_array_get_size(oPC, PRC_MOI_LOADOUT_BIND_ARRAY) != nSize
        || persistant_array_get_size(oPC, PRC_MOI_LOADOUT_TOTEM_ARRAY) != nSize
        || persistant_array_get_size(oPC, PRC_MOI_LOADOUT_ASPECT_ARRAY) != nSize)
        return JsonNull();
    // Version-1 plans written before receptacle support have no kind array.
    // Treat every one of those rows as a shaped soulmeld.  A nonempty but
    // mismatched array is a partial/corrupt write and remains unusable.
    if (nKindSize > 0 && nKindSize != nSize)
        return JsonNull();
    int bHasKind = nKindSize == nSize;

    json jDraft = JsonArray();
    int i;
    for (i = 0; i < nSize; i++)
    {
        jDraft = JsonArrayInsert(jDraft, MoiLoadoutEntry(
            persistant_array_get_int(oPC, PRC_MOI_LOADOUT_CLASS_ARRAY, i),
            persistant_array_get_int(oPC, PRC_MOI_LOADOUT_CHAKRA_ARRAY, i),
            persistant_array_get_int(oPC, PRC_MOI_LOADOUT_MELD_ARRAY, i),
            persistant_array_get_int(oPC, PRC_MOI_LOADOUT_INVEST_ARRAY, i),
            persistant_array_get_int(oPC, PRC_MOI_LOADOUT_EXPANDED_ARRAY, i),
            persistant_array_get_int(oPC, PRC_MOI_LOADOUT_BIND_ARRAY, i),
            persistant_array_get_int(oPC, PRC_MOI_LOADOUT_TOTEM_ARRAY, i),
            persistant_array_get_int(oPC, PRC_MOI_LOADOUT_ASPECT_ARRAY, i),
            bHasKind
                ? persistant_array_get_int(
                    oPC,
                    PRC_MOI_LOADOUT_KIND_ARRAY,
                    i
                )
                : PRC_MOI_LOADOUT_KIND_SOULMELD
        ));
    }
    return jDraft;
}

int MoiLoadoutPrepareArray(object oPC, string sArray, int nSize)
{
    int nOldSize = persistant_array_get_size(oPC, sArray);
    if (nOldSize < 0)
    {
        if (persistant_array_create(oPC, sArray) != SDL_SUCCESS)
            return FALSE;
        nOldSize = 0;
    }
    if (nOldSize > nSize
        && persistant_array_shrink(oPC, sArray, nSize) != SDL_SUCCESS)
        return FALSE;
    return TRUE;
}

int MoiLoadoutWriteDraft(object oPC, json jDraft)
{
    string sError = MoiLoadoutValidate(oPC, jDraft);
    if (sError != "")
        return FALSE;

    SetPersistantLocalInt(oPC, PRC_MOI_LOADOUT_VERSION_VAR, 0);
    int nSize = JsonGetLength(jDraft);
    if (!MoiLoadoutPrepareArray(oPC, PRC_MOI_LOADOUT_CLASS_ARRAY, nSize)
        || !MoiLoadoutPrepareArray(oPC, PRC_MOI_LOADOUT_CHAKRA_ARRAY, nSize)
        || !MoiLoadoutPrepareArray(oPC, PRC_MOI_LOADOUT_MELD_ARRAY, nSize)
        || !MoiLoadoutPrepareArray(oPC, PRC_MOI_LOADOUT_INVEST_ARRAY, nSize)
        || !MoiLoadoutPrepareArray(oPC, PRC_MOI_LOADOUT_EXPANDED_ARRAY, nSize)
        || !MoiLoadoutPrepareArray(oPC, PRC_MOI_LOADOUT_BIND_ARRAY, nSize)
        || !MoiLoadoutPrepareArray(oPC, PRC_MOI_LOADOUT_TOTEM_ARRAY, nSize)
        || !MoiLoadoutPrepareArray(oPC, PRC_MOI_LOADOUT_ASPECT_ARRAY, nSize)
        || !MoiLoadoutPrepareArray(oPC, PRC_MOI_LOADOUT_KIND_ARRAY, nSize))
        return FALSE;

    int i;
    for (i = 0; i < nSize; i++)
    {
        json jEntry = JsonArrayGet(jDraft, i);
        if (persistant_array_set_int(
                oPC, PRC_MOI_LOADOUT_CLASS_ARRAY, i,
                MoiLoadoutField(jEntry, "c")
            ) != SDL_SUCCESS
            || persistant_array_set_int(
                oPC, PRC_MOI_LOADOUT_CHAKRA_ARRAY, i,
                MoiLoadoutField(jEntry, "k")
            ) != SDL_SUCCESS
            || persistant_array_set_int(
                oPC, PRC_MOI_LOADOUT_MELD_ARRAY, i,
                MoiLoadoutField(jEntry, "m")
            ) != SDL_SUCCESS
            || persistant_array_set_int(
                oPC, PRC_MOI_LOADOUT_INVEST_ARRAY, i,
                MoiLoadoutField(jEntry, "i")
            ) != SDL_SUCCESS
            || persistant_array_set_int(
                oPC, PRC_MOI_LOADOUT_EXPANDED_ARRAY, i,
                MoiLoadoutField(jEntry, "e")
            ) != SDL_SUCCESS
            || persistant_array_set_int(
                oPC, PRC_MOI_LOADOUT_BIND_ARRAY, i,
                MoiLoadoutField(jEntry, "b")
            ) != SDL_SUCCESS
            || persistant_array_set_int(
                oPC, PRC_MOI_LOADOUT_TOTEM_ARRAY, i,
                MoiLoadoutField(jEntry, "t")
            ) != SDL_SUCCESS
            || persistant_array_set_int(
                oPC, PRC_MOI_LOADOUT_ASPECT_ARRAY, i,
                MoiLoadoutField(jEntry, "a")
            ) != SDL_SUCCESS
            || persistant_array_set_int(
                oPC, PRC_MOI_LOADOUT_KIND_ARRAY, i,
                MoiLoadoutField(jEntry, "q")
            ) != SDL_SUCCESS)
            return FALSE;
    }

    SetPersistantLocalInt(
        oPC,
        PRC_MOI_LOADOUT_VERSION_VAR,
        PRC_MOI_LOADOUT_VERSION
    );
    return TRUE;
}

void MoiLoadoutClearSaved(object oPC)
{
    SetPersistantLocalInt(oPC, PRC_MOI_LOADOUT_VERSION_VAR, 0);
}

json MoiLoadoutCaptureCurrent(object oPC)
{
    json jDraft = JsonArray();
    json jSeen = JsonObject();
    int nClassIndex;
    for (nClassIndex = 0; nClassIndex < 4; nClassIndex++)
    {
        int nClass = MoiLoadoutClassByIndex(nClassIndex);
        int nChakra;
        for (nChakra = CHAKRA_CROWN;
             nChakra <= CHAKRA_DOUBLE_SOUL;
             nChakra++)
        {
            if (nChakra == CHAKRA_TOTEM)
                continue;
            int nMeld = GetLocalInt(
                oPC,
                "UsedMeld" + IntToString(nClass) + IntToString(nChakra)
            );
            if (nMeld <= 0)
                continue;

            string sKey = IntToString(nMeld);
            if (JsonObjectGet(jSeen, sKey) != JsonNull())
                return JsonNull();
            jSeen = JsonObjectSet(jSeen, sKey, JsonBool(TRUE));

            int nBind;
            int nTotem;
            int nDestination;
            for (nDestination = CHAKRA_CROWN;
                 nDestination <= CHAKRA_DOUBLE_TOTEM;
                 nDestination++)
            {
                if (GetLocalInt(
                    oPC,
                    "BoundMeld" + IntToString(nDestination)
                ) != nMeld)
                    continue;
                if (nDestination == CHAKRA_TOTEM
                    || nDestination == CHAKRA_DOUBLE_TOTEM)
                    nTotem = nDestination;
                else if (nDestination == nChakra)
                    nBind = nDestination;
            }

            int bExpanded = GetExpandedSoulmeld(oPC, nMeld);
            int nAspect;
            if (nMeld == MELD_ASTRAL_VAMBRACES
                && nBind
                && DoubleChakraToChakra(nBind) == CHAKRA_ARMS)
                nAspect = GetLocalInt(oPC, "AstralVambraces");
            jDraft = JsonArrayInsert(jDraft, MoiLoadoutEntry(
                nClass,
                nChakra,
                nMeld,
                GetLocalInt(oPC, "MeldEssentia" + IntToString(nMeld)),
                bExpanded,
                nBind,
                nTotem,
                nAspect
            ));
        }
    }
    return MoiLoadoutEnsureSpecialEntries(oPC, jDraft, TRUE);
}

int MoiLoadoutNextGeneration(object oPC)
{
    int nGeneration = GetLocalInt(oPC, PRC_MOI_LOADOUT_GENERATION_VAR) + 1;
    if (nGeneration <= 0)
        nGeneration = 1;
    SetLocalInt(oPC, PRC_MOI_LOADOUT_GENERATION_VAR, nGeneration);
    return nGeneration;
}

string MoiLoadoutStamp(string sBase, int nGeneration)
{
    return sBase + PRC_MOI_LOADOUT_GENERATION_MARKER
         + IntToString(nGeneration);
}

string MoiLoadoutStampValue(string sBase, int nValue, int nGeneration)
{
    return sBase + IntToString(nValue)
         + PRC_MOI_LOADOUT_GENERATION_MARKER
         + IntToString(nGeneration);
}

int MoiLoadoutElementGeneration(string sElement)
{
    int nMarker = FindSubString(sElement, PRC_MOI_LOADOUT_GENERATION_MARKER);
    if (nMarker <= 0)
        return -1;
    int nStart = nMarker + GetStringLength(PRC_MOI_LOADOUT_GENERATION_MARKER);
    if (nStart >= GetStringLength(sElement))
        return -1;
    int nGeneration = StringToInt(GetStringRight(
        sElement,
        GetStringLength(sElement) - nStart
    ));
    return nGeneration > 0 ? nGeneration : -1;
}

int MoiLoadoutElementValue(string sElement, string sBase)
{
    int nMarker = FindSubString(sElement, PRC_MOI_LOADOUT_GENERATION_MARKER);
    int nBaseLength = GetStringLength(sBase);
    if (nMarker <= nBaseLength || FindSubString(sElement, sBase) != 0)
        return -1;
    string sBare = GetStringLeft(sElement, nMarker);
    return StringToInt(GetStringRight(
        sBare,
        GetStringLength(sBare) - nBaseLength
    ));
}

void MoiLoadoutDiscardDraft(object oPC, int bCloseWindow = TRUE)
{
    if (bCloseWindow && GetIsPC(oPC))
    {
        int nToken = NuiFindWindow(oPC, PRC_MOI_LOADOUT_NUI_WINDOW_ID);
        if (nToken)
            NuiDestroy(oPC, nToken);
    }
    DeleteLocalJson(oPC, PRC_MOI_LOADOUT_DRAFT_VAR);
    DeleteLocalInt(oPC, PRC_MOI_LOADOUT_ACTIVE_VAR);
    DeleteLocalInt(oPC, PRC_MOI_LOADOUT_STAGE_VAR);
    DeleteLocalInt(oPC, PRC_MOI_LOADOUT_CLASS_VAR);
    DeleteLocalInt(oPC, PRC_MOI_LOADOUT_CHAKRA_VAR);
    DeleteLocalInt(oPC, PRC_MOI_LOADOUT_REBUILD_TOKEN_VAR);
}

int MoiLoadoutInitialize(object oPC)
{
    if (!GetIsPC(oPC) || !MoiLoadoutHasShapingClass(oPC))
        return FALSE;

    json jDraft = MoiLoadoutReadSaved(oPC);
    if (jDraft == JsonNull())
    {
        jDraft = MoiLoadoutCaptureCurrent(oPC);
        if (jDraft == JsonNull())
            jDraft = JsonArray();
    }
    // Old version-1 saves have no receptacle rows.  Add every currently
    // eligible row at zero without changing their saved soulmeld data.
    jDraft = MoiLoadoutEnsureSpecialEntries(oPC, jDraft);
    MoiLoadoutSetDraft(oPC, jDraft);
    SetLocalInt(oPC, PRC_MOI_LOADOUT_ACTIVE_VAR, TRUE);
    SetLocalInt(oPC, PRC_MOI_LOADOUT_STAGE_VAR, PRC_MOI_LOADOUT_STAGE_SHAPE);
    SetLocalInt(oPC, PRC_MOI_LOADOUT_CLASS_VAR, MoiLoadoutFirstClass(oPC));
    SetLocalInt(oPC, PRC_MOI_LOADOUT_CHAKRA_VAR, CHAKRA_CROWN);
    return TRUE;
}

void MoiLoadoutClearDraft(object oPC)
{
    MoiLoadoutSetDraft(
        oPC,
        MoiLoadoutEnsureSpecialEntries(oPC, JsonArray())
    );
    SetLocalInt(oPC, PRC_MOI_LOADOUT_STAGE_VAR, PRC_MOI_LOADOUT_STAGE_SHAPE);
}

string MoiLoadoutSummary(object oPC, json jDraft)
{
    int nBound;
    int i;
    for (i = 0; i < JsonGetLength(jDraft); i++)
    {
        json jEntry = JsonArrayGet(jDraft, i);
        if (!MoiLoadoutIsSoulmeldEntry(jEntry))
            continue;
        if (MoiLoadoutField(jEntry, "b")) nBound++;
        if (MoiLoadoutField(jEntry, "t")) nBound++;
    }
    return IntToString(MoiLoadoutSoulmeldCount(jDraft)) + " shaped  |  "
         + IntToString(MoiLoadoutInvestedTotal(jDraft)) + "/"
         + IntToString(GetTotalEssentia(oPC)) + " essentia  |  "
         + IntToString(nBound) + " bound";
}

string MoiLoadoutDraftSummary(object oPC)
{
    return MoiLoadoutSummary(oPC, MoiLoadoutGetDraft(oPC));
}

void MoiLoadoutSetExpandedLocals(object oPC, json jDraft)
{
    int nSlot = 1;
    int i;
    for (i = 0; i < JsonGetLength(jDraft); i++)
    {
        json jEntry = JsonArrayGet(jDraft, i);
        if (!MoiLoadoutIsSoulmeldEntry(jEntry)
            || !MoiLoadoutField(jEntry, "e"))
            continue;
        SetLocalInt(
            oPC,
            "ExpandedSoulmeld" + IntToString(nSlot),
            MoiLoadoutField(jEntry, "m")
        );
        nSlot++;
    }
}

void MoiLoadoutClearConversationMarkers(object oPC)
{
    DeleteLocalInt(oPC, "FirstMeldDone");
    DeleteLocalInt(oPC, "SecondMeldDone");
    DeleteLocalInt(oPC, "ThirdMeldDone");
    DeleteLocalInt(oPC, "FourthMeldDone");
    DeleteLocalInt(oPC, "nMeld");
    DeleteLocalInt(oPC, "nChakra");
}

void MoiLoadoutBeginInvestmentRound(object oPC, int nMeld)
{
    string sMarker = "EssentiaRound" + IntToString(nMeld);
    SetLocalInt(oPC, sMarker, TRUE);
    DelayCommand(6.0f, DeleteLocalInt(oPC, sMarker));
}

int MoiLoadoutApplyValidated(object oPC, json jDraft)
{
    if (MoiLoadoutValidate(oPC, jDraft) != "")
        return FALSE;

    // The completed-rest handler already removed the old Incarnum state and
    // effects before its delayed PRC feat rebuild.  Install only the validated
    // replacement state here so unrelated rebuilt skin properties survive.

    int nIncarnate;
    int nSoulborn;
    int nTotemist;
    int nSpinemeld;
    int i;
    for (i = 0; i < JsonGetLength(jDraft); i++)
    {
        json jEntry = JsonArrayGet(jDraft, i);
        if (!MoiLoadoutIsSoulmeldEntry(jEntry))
            continue;
        int nClass = MoiLoadoutField(jEntry, "c");
        int nChakra = MoiLoadoutField(jEntry, "k");
        int nMeld = MoiLoadoutField(jEntry, "m");
        int nClassSlot;
        if (nClass == CLASS_TYPE_INCARNATE) nClassSlot = nIncarnate++;
        else if (nClass == CLASS_TYPE_SOULBORN) nClassSlot = nSoulborn++;
        else if (nClass == CLASS_TYPE_TOTEMIST) nClassSlot = nTotemist++;
        else nClassSlot = nSpinemeld++;

        SetLocalInt(
            oPC,
            "ShapedMeld" + IntToString(nClass) + IntToString(nClassSlot),
            nMeld
        );
        SetLocalInt(
            oPC,
            "UsedMeld" + IntToString(nClass) + IntToString(nChakra),
            nMeld
        );
    }

    for (i = 0; i < JsonGetLength(jDraft); i++)
    {
        json jEntry = JsonArrayGet(jDraft, i);
        if (!MoiLoadoutIsSoulmeldEntry(jEntry))
            continue;
        int nMeld = MoiLoadoutField(jEntry, "m");
        int nBind = MoiLoadoutField(jEntry, "b");
        int nTotem = MoiLoadoutField(jEntry, "t");
        if (nBind)
            SetLocalInt(oPC, "BoundMeld" + IntToString(nBind), nMeld);
        if (nTotem)
            SetLocalInt(oPC, "BoundMeld" + IntToString(nTotem), nMeld);
        if (nMeld == MELD_ASTRAL_VAMBRACES
            && nBind
            && DoubleChakraToChakra(nBind) == CHAKRA_ARMS)
            SetLocalInt(
                oPC,
                "AstralVambraces",
                MoiLoadoutField(jEntry, "a")
            );
    }

    MoiLoadoutSetExpandedLocals(oPC, jDraft);
    for (i = 0; i < JsonGetLength(jDraft); i++)
    {
        json jEntry = JsonArrayGet(jDraft, i);
        int nMeld = MoiLoadoutField(jEntry, "m");
        int nInvest = MoiLoadoutField(jEntry, "i");
        if (nInvest > 0)
            SetLocalInt(
                oPC,
                "MeldEssentia" + IntToString(nMeld),
                nInvest
            );
    }

    // Match BindMeldToChakra's equipment restriction without queuing a cast
    // for every bind.  All meld effects are rebuilt once below.
    for (i = CHAKRA_CROWN; i <= CHAKRA_DOUBLE_SOUL; i++)
    {
        if (i == CHAKRA_TOTEM
            || !GetLocalInt(oPC, "BoundMeld" + IntToString(i)))
            continue;
        int nSlot = ChakraToSlot(DoubleChakraToChakra(i));
        if (nSlot >= 0 && !CheckSplitChakra(oPC, nSlot))
            ForceUnequip(oPC, GetItemInSlot(nSlot, oPC), nSlot);
    }

    MoiLoadoutClearConversationMarkers(oPC);
    AssignCommand(oPC, ReshapeMelds(oPC));
    // Several melds expose movement-speed state only after their reshape casts
    // complete.  Queue the shared speed rebuild behind those casts.
    AssignCommand(oPC, ActionDoCommand(ExecuteScript("prc_speed", oPC)));
    // Match InvestEssentia's one-round activation window after the final
    // reshape cast, rather than letting that window expire inside the queue.
    for (i = 0; i < JsonGetLength(jDraft); i++)
    {
        json jEntry = JsonArrayGet(jDraft, i);
        if (MoiLoadoutField(jEntry, "i") > 0)
            AssignCommand(oPC, ActionDoCommand(MoiLoadoutBeginInvestmentRound(
                oPC,
                MoiLoadoutField(jEntry, "m")
            )));
    }
    return TRUE;
}
