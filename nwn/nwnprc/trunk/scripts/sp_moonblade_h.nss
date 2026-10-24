#include "sp_moon_inc"
#include "x2_inc_spellhook"

const string MOONBLADE_HIT_PREFIX = "MBH_";
const string MOONBLADE_HOOK_SCRIPT = "sp_moonblade_h";
const string MOONBLADE_SCRAMBLE_ACTIVE = "PRC_MOONBLADE_SCRAMBLE_ACTIVE";
const string MOONBLADE_SCRAMBLE_BASE = "PRC_MOONBLADE_SCRAMBLE_BASE";
const string MOONBLADE_SCRAMBLE_SERIAL = "PRC_MOONBLADE_SCRAMBLE_SERIAL";
const string MOONBLADE_PREVIOUS_HOOK = "PRC_MOONBLADE_PREVIOUS_HOOK";

int MoonbladeHitStartsWith(string sText, string sPrefix)
{
    return GetStringLeft(sText, GetStringLength(sPrefix)) == sPrefix;
}

void MoonbladeClearScramble(object oTarget, int nSerial)
{
    if(!GetIsObjectValid(oTarget)
        || GetLocalInt(oTarget, MOONBLADE_SCRAMBLE_SERIAL) != nSerial)
        return;

    if(GetLocalString(oTarget, "PRC_OVERRIDE_SPELLSCRIPT")
        == MOONBLADE_HOOK_SCRIPT)
        SetLocalString(oTarget, "PRC_OVERRIDE_SPELLSCRIPT",
            GetLocalString(oTarget, MOONBLADE_PREVIOUS_HOOK));

    DeleteLocalInt(oTarget, MOONBLADE_SCRAMBLE_ACTIVE);
    DeleteLocalInt(oTarget, MOONBLADE_SCRAMBLE_BASE);
    DeleteLocalInt(oTarget, MOONBLADE_SCRAMBLE_SERIAL);
    DeleteLocalString(oTarget, MOONBLADE_PREVIOUS_HOOK);
}

void MoonbladeApplyScramble(object oTarget, int nDamage)
{
    int nCheckBase = 10 + nDamage;
    if(nCheckBase > GetLocalInt(oTarget, MOONBLADE_SCRAMBLE_BASE))
        SetLocalInt(oTarget, MOONBLADE_SCRAMBLE_BASE, nCheckBase);

    if(!GetLocalInt(oTarget, MOONBLADE_SCRAMBLE_ACTIVE))
    {
        string sPrevious = GetLocalString(oTarget,
            "PRC_OVERRIDE_SPELLSCRIPT");
        if(sPrevious == MOONBLADE_HOOK_SCRIPT)
            sPrevious = "";

        SetLocalString(oTarget, MOONBLADE_PREVIOUS_HOOK, sPrevious);
        SetLocalInt(oTarget, MOONBLADE_SCRAMBLE_ACTIVE, TRUE);
        SetLocalString(oTarget, "PRC_OVERRIDE_SPELLSCRIPT",
            MOONBLADE_HOOK_SCRIPT);
    }

    int nSerial = GetLocalInt(oTarget, MOONBLADE_SCRAMBLE_SERIAL) + 1;
    SetLocalInt(oTarget, MOONBLADE_SCRAMBLE_SERIAL, nSerial);
    DelayCommand(RoundsToSeconds(1), MoonbladeClearScramble(oTarget, nSerial));
}

void MoonbladeApplyHitDamage(object oCaster, object oTarget, int nDamage,
    int nSpellID, int nCasterLevel)
{
    if(!GetIsObjectValid(oCaster) || !GetIsObjectValid(oTarget)
        || GetIsDead(oTarget) || nDamage < 1)
        return;

    // Use native positive-energy damage so the engine applies the hit reliably
    // while preserving Moon Blade's increased damage against undead.
    effect eDamage = EffectDamage(nDamage, DAMAGE_TYPE_POSITIVE,
        DAMAGE_POWER_ENERGY);
    eDamage = SetEffectCreator(eDamage, oCaster);
    eDamage = SetEffectSpellId(eDamage, nSpellID);

    int nHitPointsBefore = GetCurrentHitPoints(oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_IMP_DIVINE_STRIKE_HOLY), oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);

    int nDamageDealt = nHitPointsBefore - GetCurrentHitPoints(oTarget);
    if(nDamageDealt < 0)
        nDamageDealt = 0;
    MoonbladeApplyScramble(oTarget, nDamageDealt);
}

void MoonbladeRunPreviousSpellHook(object oCaster)
{
    string sPrevious = GetLocalString(oCaster, MOONBLADE_PREVIOUS_HOOK);
    if(sPrevious == "" || sPrevious == MOONBLADE_HOOK_SCRIPT)
        return;

    ExecuteScript(sPrevious, oCaster);
    if(PRCGetUserSpecificSpellScriptFinished())
        PRCSetUserSpecificSpellScriptFinished();
}

void MoonbladeConcentrationHook()
{
    object oCaster = OBJECT_SELF;
    int nSpellLevel = PRCGetSpellLevel(oCaster, PRCGetSpellId());
    if(nSpellLevel < 0)
        nSpellLevel = 0;

    int nDC = GetLocalInt(oCaster, MOONBLADE_SCRAMBLE_BASE) + nSpellLevel;
    if(nDC > nSpellLevel
        && !GetIsSkillSuccessful(oCaster, SKILL_CONCENTRATION, nDC))
    {
        FloatingTextStringOnCreature("Moon Blade scrambles the spell (Concentration DC "
            + IntToString(nDC) + ").", oCaster, FALSE);
        PRCSetUserSpecificSpellScriptFinished();
        return;
    }

    MoonbladeRunPreviousSpellHook(oCaster);
}

int MoonbladeSpellResistanceState(object oBlade, object oCaster,
    object oTarget, int nCasterLevel)
{
    string sKey = "MBL_SR_" + ObjectToString(oTarget);
    int nState = GetLocalInt(oBlade, sKey);
    if(nState)
        return nState;

    nState = PRCDoResistSpell(oCaster, oTarget,
        nCasterLevel + SPGetPenetr(oCaster)) ? -1 : 1;
    SetLocalInt(oBlade, sKey, nState);
    return nState;
}

void MoonbladeApplyTouchHit(effect eRun)
{
    object oTarget = OBJECT_SELF;
    object oCaster = GetEffectCreator(eRun);

    // PerformAttackRound marks a critical immediately before applying this
    // effect. Consume the marker now so a later rapid attack cannot inherit it.
    int bCritical = GetLocalInt(oTarget, "PRCCombat_CriticalHit");
    if(bCritical)
        DeleteLocalInt(oTarget, "PRCCombat_CriticalHit");

    if(!GetIsObjectValid(oCaster)
        || GetObjectType(oTarget) != OBJECT_TYPE_CREATURE
        || GetIsDead(oTarget))
        return;

    object oBlade = GetLocalObject(oCaster,
        "PRC_MOONBLADE_ACTIVE_BLADE");
    string sBladeTag = GetEffectString(eRun, 0);
    if(!GetIsObjectValid(oBlade)
        || GetTag(oBlade) != sBladeTag
        || GetItemPossessor(oBlade) != oCaster
        || GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCaster) != oBlade
        || GetLocalObject(oBlade, "PRC_MOONBLADE_CASTER") != oCaster)
        return;

    // Never apply a touch hit after the target has left melee reach between
    // scheduled attacks in the full-attack round.
    if(!MoonbladeIsInMeleeRange(oCaster, oTarget))
        return;

    int nCasterLevel = GetLocalInt(oBlade, "PRC_MOONBLADE_CL");
    int nMetaMagic = GetLocalInt(oBlade, "PRC_MOONBLADE_METAMAGIC");
    int nSpellID = GetLocalInt(oBlade, "PRC_MOONBLADE_SPELLID");
    if(nCasterLevel < 1)
        nCasterLevel = GetHitDice(oCaster);
    if(nSpellID < 1)
        return;

    PRCSetSchool(SPELL_SCHOOL_EVOCATION);
    PRCSignalSpellEvent(oTarget, TRUE, nSpellID, oCaster);

    // Spell resistance is rolled once per creature for this casting, then the
    // result is reused for every later attack from the same blade.
    int nSRState = MoonbladeSpellResistanceState(oBlade, oCaster, oTarget,
        nCasterLevel);
    PRCSetSchool();
    if(nSRState < 0)
        return;

    int nUndead = MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD;
    int nDice = nUndead ? 2 : 1;
    int nBonus = nUndead ? nCasterLevel : nCasterLevel / 2;
    int nBonusCap = nUndead ? 20 : 10;
    if(nBonus > nBonusCap)
        nBonus = nBonusCap;

    int nDamage = PRCMaximizeOrEmpower(8, nDice, nMetaMagic, nBonus);
    if(nDamage < 1)
        return;
    if(bCritical)
        nDamage *= 2;

    // PRCEffectDamage handles its legacy local flag. Cover every other form
    // recognized by PRC without rolling the miss chance twice.
    if(GetIsIncorporeal(oTarget)
        && !GetLocalInt(oTarget, "Incorporeal")
        && d2() == 1)
    {
        if(GetIsPC(oTarget))
            FloatingTextStringOnCreature(
                "Spell missed due to Incorporeality", oTarget, FALSE);
        return;
    }

    // This callback runs after the scripted touch attack has resolved, so its
    // damage can be applied directly and is not lost to an engine attack hook.
    MoonbladeApplyHitDamage(oCaster, oTarget, nDamage, nSpellID,
        nCasterLevel);
}

void main()
{
    effect eRun = GetLastRunScriptEffect();
    if(GetIsEffectValid(eRun)
        && GetLastRunScriptEffectScriptType()
            == RUNSCRIPT_EFFECT_SCRIPT_TYPE_ON_APPLIED
        && MoonbladeHitStartsWith(GetEffectTag(eRun),
            MOONBLADE_HIT_PREFIX))
    {
        MoonbladeApplyTouchHit(eRun);
        return;
    }

    // When installed as the target's temporary pre-spell hook, this branch
    // performs the exact Concentration check using the attempted spell's level.
    if(GetObjectType(OBJECT_SELF) == OBJECT_TYPE_CREATURE
        && GetLocalInt(OBJECT_SELF, MOONBLADE_SCRAMBLE_ACTIVE))
        MoonbladeConcentrationHook();
}
