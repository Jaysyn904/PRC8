#include "sp_moon_inc"
#include "inc_eventhook"

const string COUNTERMOON_CONTROLLER_PREFIX = "CMC_";
const string COUNTERMOON_SERIAL_LOCAL = "PRC_MOON_COUNTERMOON_SERIAL";
const string COUNTERMOON_SEQUENCE_LOCAL = "PRC_MOON_COUNTERMOON_SEQUENCE";
const string COUNTERMOON_PENDING_LOCAL = "PRC_MOON_COUNTERMOON_PENDING";
const float COUNTERMOON_INTERVAL = 0.5f;

int CountermoonStartsWith(string sText, string sPrefix)
{
    return GetStringLeft(sText, GetStringLength(sPrefix)) == sPrefix;
}

int CountermoonIsLycanthrope(object oTarget)
{
    // Keep this stricter check local to Countermoon. Temporary wolf/hybrid
    // state is not proof of lycanthropy and must not authorize forced reversion.
    if(MoonSpellHasWerewolfTemplate(oTarget)
        || GetHasFeat(FEAT_PRESTIGE_LYCANTHROPE, oTarget)
        || GetHasFeat(FEAT_TRUE_LYCANTHROPE, oTarget))
        return TRUE;

    // Preserve recognition of the existing shapechanger-type were-creature
    // NPCs, which may have an appearance/name rather than PC class feats.
    int nAppearance = GetAppearanceType(oTarget);
    return MyPRCGetRacialType(oTarget) == RACIAL_TYPE_SHAPECHANGER
        && (nAppearance == APPEARANCE_TYPE_WEREWOLF
            || nAppearance == APPEARANCE_TYPE_WERECAT
            || nAppearance == APPEARANCE_TYPE_WERERAT
            || GetStringLeft(GetStringLowerCase(GetName(oTarget)), 4) == "were");
}

int CountermoonBeginCast(object oTarget)
{
    // The sequence survives effect cleanup. Account for an active controller
    // from an older build, which has an active serial but no sequence local.
    int nSerial = GetLocalInt(oTarget, COUNTERMOON_SEQUENCE_LOCAL);
    int nActive = GetLocalInt(oTarget, COUNTERMOON_SERIAL_LOCAL);
    if(nSerial < nActive)
        nSerial = nActive;
    nSerial++;
    SetLocalInt(oTarget, COUNTERMOON_SEQUENCE_LOCAL, nSerial);

    // Publish the new owner BEFORE removing the old effect, so either inline
    // or delayed old callbacks cannot clear the replacement's state.
    SetLocalInt(oTarget, COUNTERMOON_SERIAL_LOCAL, nSerial);
    DeleteLocalInt(oTarget, COUNTERMOON_PENDING_LOCAL);
    return nSerial;
}

void CountermoonClearLegacyHeartbeat(object oTarget)
{
    // Builds before this controller used a permanent PRC heartbeat hook.
    // Remove its state without touching any stock PRC werewolf resource.
    DeleteLocalInt(oTarget, "PRC_MOON_COUNTERMOON_LOCK");
    DeleteLocalInt(oTarget, "PRC_MOON_COUNTERMOON_SPELLID");
    RemoveEventScript(oTarget, EVENT_ONHEARTBEAT, "sp_countermoon_h",
        TRUE, FALSE);
}

void CountermoonCastVisual(object oCaster, object oTarget)
{
    if(GetIsObjectValid(oCaster) && GetArea(oCaster) == GetArea(oTarget))
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
            EffectBeam(VFX_BEAM_CHAIN, oCaster, BODY_NODE_HAND),
            oTarget, 1.25f);
    }

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
        EffectVisualEffect(VFX_DUR_GLOW_RED), oTarget, 1.25f);
}

void CountermoonCleanup(object oTarget, int nSerial)
{
    if(GetLocalInt(oTarget, COUNTERMOON_SERIAL_LOCAL) != nSerial)
        return;

    DeleteLocalInt(oTarget, COUNTERMOON_SERIAL_LOCAL);
    DeleteLocalInt(oTarget, COUNTERMOON_PENDING_LOCAL);

    CountermoonClearLegacyHeartbeat(oTarget);
}

void CountermoonForceInitialNaturalForm(object oTarget)
{
    MoonSpellUnshiftWerewolf(oTarget);

    // PRC's PnP hybrid unshift can finish asynchronously. Keep retrying only
    // that cast-time reversion until the stock shift state is actually clear.
    if(MoonSpellHasPersistentShift(oTarget))
        SetLocalInt(oTarget, COUNTERMOON_PENDING_LOCAL, TRUE);
    else
        DeleteLocalInt(oTarget, COUNTERMOON_PENDING_LOCAL);
}

int CountermoonHasPolymorphSelection(object oTarget, int nSelection)
{
    effect eTest = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eTest))
    {
        if(GetEffectType(eTest) == EFFECT_TYPE_POLYMORPH
            && GetEffectInteger(eTest, 0) == nSelection)
            return TRUE;

        eTest = GetNextEffect(oTarget);
    }

    return FALSE;
}

int CountermoonHasWerewolfHybridPolymorph(object oTarget)
{
    effect eTest = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eTest))
    {
        if(GetEffectType(eTest) == EFFECT_TYPE_POLYMORPH)
        {
            int nSelection = GetEffectInteger(eTest, 0);
            if(nSelection == POLYMORPH_TYPE_WEREWOLF_0s
                || nSelection == POLYMORPH_TYPE_WEREWOLF_1s
                || nSelection == POLYMORPH_TYPE_WEREWOLF_2s
                || nSelection == POLYMORPH_TYPE_WEREWOLF_0l
                || nSelection == POLYMORPH_TYPE_WEREWOLF_1l
                || nSelection == POLYMORPH_TYPE_WEREWOLF_2l
                || nSelection == PRC_WW_POLYMORPH_HYBRID)
                return TRUE;
        }

        eTest = GetNextEffect(oTarget);
    }

    return FALSE;
}

int CountermoonHasStockLycanthropeShiftAttempt(object oTarget)
{
    int bWolfAttempt = GetLocalInt(oTarget, "WWWolf")
        && GetHasFeat(FEAT_PRESTIGE_WOLF_FORM, oTarget)
        && CountermoonHasPolymorphSelection(oTarget,
            MoonSpellGetWerewolfAnimalPolymorph(oTarget));

    int bHybridAttempt = GetLocalInt(oTarget, "WWHybrid")
        && GetHasFeat(FEAT_PRESTIGE_WEREWOLF_FORM, oTarget)
        && (MoonSpellHasPersistentShift(oTarget)
            || CountermoonHasWerewolfHybridPolymorph(oTarget));

    // WWWolf is also used by Hound Archon's racial wolf form, so the local
    // alone is not proof of a lycanthropic change. Corroborate both the class
    // feat and exact active polymorph selection so a stale/shared flag plus an
    // unrelated polymorph is left alone. PnP hybrid uses persistent shift state.
    return bWolfAttempt || bHybridAttempt;
}

void CountermoonSuppressShift(object oTarget, effect eController,
    int nSerial)
{
    if(GetLocalInt(oTarget, COUNTERMOON_SERIAL_LOCAL) != nSerial)
        return;

    int bPending = GetLocalInt(oTarget, COUNTERMOON_PENDING_LOCAL);
    int bStockAttempt = CountermoonHasStockLycanthropeShiftAttempt(oTarget);

    // Only the stock PRC lycanthrope flags are watched after the initial
    // reversion. Countermoon does not suppress unrelated wild shape,
    // Shifter forms, or ordinary polymorph spells used later.
    if(!bPending && !bStockAttempt)
        return;

    MoonSpellUnshiftWerewolf(oTarget);

    if(MoonSpellHasPersistentShift(oTarget))
        SetLocalInt(oTarget, COUNTERMOON_PENDING_LOCAL, TRUE);
    else
        DeleteLocalInt(oTarget, COUNTERMOON_PENDING_LOCAL);

    if(bStockAttempt && !bPending)
    {
        CountermoonCastVisual(GetEffectCreator(eController), oTarget);
        FloatingTextStringOnCreature(
            "Countermoon forces you back to your natural form.",
            oTarget, FALSE);
    }
}

void main()
{
    // A target-owned controller provides prompt enforcement and an exact
    // cleanup callback when the spell expires, is dispelled, or is dismissed.
    effect eRun = GetLastRunScriptEffect();
    if(GetIsEffectValid(eRun)
        && CountermoonStartsWith(GetEffectTag(eRun),
            COUNTERMOON_CONTROLLER_PREFIX))
    {
        int nSerial = StringToInt(GetEffectString(eRun, 0));
        int nEvent = GetLastRunScriptEffectScriptType();

        if(nEvent == RUNSCRIPT_EFFECT_SCRIPT_TYPE_ON_REMOVED)
            CountermoonCleanup(OBJECT_SELF, nSerial);
        else if(nEvent == RUNSCRIPT_EFFECT_SCRIPT_TYPE_ON_APPLIED
            || nEvent == RUNSCRIPT_EFFECT_SCRIPT_TYPE_ON_INTERVAL)
            CountermoonSuppressShift(OBJECT_SELF, eRun, nSerial);
        return;
    }

    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    int nSpellID = PRCGetSpellId();
    float fDuration = PRCGetMetaMagicDuration(HoursToSeconds(12));

    PRCSetSchool(SPELL_SCHOOL_ABJURATION);
    if(!X2PreSpellCastCode())
    {
        PRCSetSchool();
        return;
    }

    if(!GetIsObjectValid(oTarget)
        || GetObjectType(oTarget) != OBJECT_TYPE_CREATURE
        || GetIsDead(oTarget)
        || !CountermoonIsLycanthrope(oTarget))
    {
        FloatingTextStringOnCreature(
            "Countermoon affects only living lycanthropes.",
            oCaster, FALSE);
        PRCSetSchool();
        return;
    }

    MoonSpellSignal(oCaster, oTarget, nSpellID, TRUE);

    if(!PRCDoResistSpell(oCaster, oTarget,
        nCasterLevel + SPGetPenetr()))
    {
        int nDC = PRCGetSaveDC(oTarget, oCaster, nSpellID);
        if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC,
            SAVING_THROW_TYPE_SPELL, oCaster))
        {
            int nSerial = CountermoonBeginCast(oTarget);
            CountermoonClearLegacyHeartbeat(oTarget);
            MoonSpellRemoveSpellEffects(nSpellID, oTarget);
            CountermoonForceInitialNaturalForm(oTarget);

            string sControllerTag = COUNTERMOON_CONTROLLER_PREFIX
                + ObjectToString(oTarget) + "_" + IntToString(nSerial);
            effect eController = EffectRunScript("sp_countermoon",
                "sp_countermoon", "sp_countermoon",
                COUNTERMOON_INTERVAL, IntToString(nSerial));
            eController = SetEffectSpellId(eController, nSpellID);
            eController = SetEffectCasterLevel(eController, nCasterLevel);
            eController = SetEffectCreator(eController, oCaster);
            eController = TagEffect(eController, sControllerTag);
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eController,
                oTarget, fDuration, TRUE, nSpellID, nCasterLevel, oCaster);

            CountermoonCastVisual(oCaster, oTarget);
        }
    }

    PRCSetSchool();
}
