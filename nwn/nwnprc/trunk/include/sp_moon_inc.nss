#include "prc_inc_spells"
#include "prc_add_spell_dc"
#include "prc_class_const"
#include "prc_feat_const"
#include "inc_persist_loca"
#include "prc_inc_template"
#include "prc_inc_wwolf"

int MoonSpellHasWerewolfTemplate(object oTarget)
{
    return PRCWWHasTemplate(oTarget);
}

int MoonSpellHasWerewolfTemplateFormState(object oTarget)
{
    if(!PRCWWHasTemplate(oTarget))
        return FALSE;

    return GetLocalInt(oTarget, "WWWolf")
        || GetLocalInt(oTarget, "WWHybrid")
        || PRCWWGetActiveForm(oTarget) != PRC_WW_FORM_NONE
        || PRCWWHasTemplateFormEffect(oTarget);
}

int MoonbladeIsInMeleeRange(object oCaster, object oTarget)
{
    if(!GetIsObjectValid(oCaster) || !GetIsObjectValid(oTarget))
        return FALSE;

    int nCasterSize = PRCGetCreatureSize(oCaster) - CREATURE_SIZE_MEDIUM;
    int nTargetSize = PRCGetCreatureSize(oTarget) - CREATURE_SIZE_MEDIUM;
    if(nCasterSize < 0)
        nCasterSize = 0;
    if(nTargetSize < 0)
        nTargetSize = 0;

    // Use the PRC combat system's normal ten-foot melee envelope, including
    // its large-creature adjustment, but not its extra five-foot tolerance.
    float fReach = 3.05f + IntToFloat(nCasterSize + nTargetSize);
    return GetDistanceBetween(oCaster, oTarget) <= fReach;
}

int MoonSpellHasPolymorph(object oTarget)
{
    effect eTest = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eTest))
    {
        if(GetEffectType(eTest) == EFFECT_TYPE_POLYMORPH)
            return TRUE;

        eTest = GetNextEffect(oTarget);
    }

    return FALSE;
}

int MoonSpellHasPersistentShift(object oTarget)
{
    return GetLocalInt(oTarget, "shifting")
        || (GetIsPC(oTarget) && GetPersistantLocalInt(oTarget, "nPCShifted"));
}

int MoonSpellIsLivingCreature(object oTarget)
{
    int nRace = MyPRCGetRacialType(oTarget);
    return PRCGetIsAliveCreature(oTarget)
        && nRace != RACIAL_TYPE_UNDEAD
        && nRace != RACIAL_TYPE_CONSTRUCT;
}

int MoonSpellIsShapechanger(object oTarget)
{
    return MyPRCGetRacialType(oTarget) == RACIAL_TYPE_SHAPECHANGER
        || MoonSpellHasPolymorph(oTarget)
        || MoonSpellHasPersistentShift(oTarget);
}

int MoonSpellIsLycanthrope(object oTarget)
{
    int nAppearance = GetAppearanceType(oTarget);
    int bWereAppearance = nAppearance == APPEARANCE_TYPE_WEREWOLF
        || nAppearance == APPEARANCE_TYPE_WERECAT
        || nAppearance == APPEARANCE_TYPE_WERERAT;
    int bNamedWere = GetStringLeft(GetStringLowerCase(GetName(oTarget)), 4) == "were";

    return GetHasFeat(FEAT_PRESTIGE_LYCANTHROPE, oTarget)
        || GetHasFeat(FEAT_TRUE_LYCANTHROPE, oTarget)
        || MoonSpellHasWerewolfTemplate(oTarget)
        || GetLocalInt(oTarget, "WWWolf")
        || GetLocalInt(oTarget, "WWHybrid")
        || ((bWereAppearance || bNamedWere)
            && MyPRCGetRacialType(oTarget) == RACIAL_TYPE_SHAPECHANGER);
}

int MoonSpellIsWerewolfShifted(object oTarget)
{
    return GetLocalInt(oTarget, "WWWolf")
        || GetLocalInt(oTarget, "WWHybrid")
        || MoonSpellHasWerewolfTemplateFormState(oTarget)
        || MoonSpellHasPersistentShift(oTarget)
        || (MoonSpellIsLycanthrope(oTarget) && MoonSpellHasPolymorph(oTarget));
}

int MoonSpellGetWerewolfAnimalPolymorph(object oTarget)
{
    if(MoonSpellHasWerewolfTemplate(oTarget))
        return PRC_WW_POLYMORPH_WOLF;

    int nPoly = POLYMORPH_TYPE_WOLF_0;

    if(GetHasFeat(FEAT_PRESTIGE_WOLFCLASS_1, oTarget))
        nPoly = POLYMORPH_TYPE_WOLF_1;
    if(GetHasFeat(FEAT_PRESTIGE_WOLFCLASS_2, oTarget))
        nPoly = POLYMORPH_TYPE_WOLF_2;
    if(GetHasFeat(FEAT_PRESTIGE_WEREWOLFCLASS_2, oTarget))
        nPoly = POLYMORPH_TYPE_WOLF_0s;
    if(GetHasFeat(FEAT_PRESTIGE_WOLFCLASS_1, oTarget) && GetHasFeat(FEAT_PRESTIGE_WEREWOLFCLASS_2, oTarget))
        nPoly = POLYMORPH_TYPE_WOLF_1s;
    if(GetHasFeat(FEAT_PRESTIGE_WOLFCLASS_2, oTarget) && GetHasFeat(FEAT_PRESTIGE_WEREWOLFCLASS_2, oTarget))
        nPoly = POLYMORPH_TYPE_WOLF_2s;
    if(GetHasFeat(FEAT_PRESTIGE_WEREWOLFCLASS_3, oTarget))
        nPoly = POLYMORPH_TYPE_WOLF_0l;
    if(GetHasFeat(FEAT_PRESTIGE_WOLFCLASS_1, oTarget) && GetHasFeat(FEAT_PRESTIGE_WEREWOLFCLASS_3, oTarget))
        nPoly = POLYMORPH_TYPE_WOLF_1l;
    if(GetHasFeat(FEAT_PRESTIGE_WOLFCLASS_2, oTarget) && GetHasFeat(FEAT_PRESTIGE_WEREWOLFCLASS_3, oTarget))
        nPoly = POLYMORPH_TYPE_WOLF_2l;

    return nPoly;
}

void MoonSpellUnshiftWerewolf(object oTarget)
{
    if(!GetIsObjectValid(oTarget))
        return;

    // The template has persistent form state in addition to the engine
    // polymorph. Clear both through its authoritative return path so its
    // heartbeat cannot reconstruct a form removed by a Moon spell.
    if(MoonSpellHasWerewolfTemplate(oTarget))
        PRCWWRevertTemplateForm(oTarget);

    // Return a PnP-shifted target with the stock PRC true-form script first.
    if(GetIsPC(oTarget) && GetPersistantLocalInt(oTarget, "nPCShifted"))
        ExecuteScript("pnp_shft_true", oTarget);

    // Engine-polymorph werewolf forms need independent cleanup. This avoids
    // the aggregate WW cleanup's summoned-wolf/Wolf Empathy side effects.
    int bRemoved = TRUE;
    while(bRemoved)
    {
        bRemoved = FALSE;
        effect eTest = GetFirstEffect(oTarget);
        while(GetIsEffectValid(eTest))
        {
            if(GetEffectType(eTest) == EFFECT_TYPE_POLYMORPH)
            {
                RemoveEffect(oTarget, eTest);
                bRemoved = TRUE;
                break;
            }

            eTest = GetNextEffect(oTarget);
        }
    }

    DeleteLocalInt(oTarget, "WWWolf");
    DeleteLocalInt(oTarget, "WWHybrid");
}

void MoonSpellForceWerewolfAnimal(object oTarget)
{
    if(!MoonSpellHasWerewolfTemplate(oTarget))
    {
        ExecuteScript("prc_wwformwolf", oTarget);
        return;
    }

    // Moonbeam is an external, one-round compulsion. Bypass the afflicted
    // template's voluntary Control Shape roll without creating the full-moon
    // until-dawn episode, and suppress the voluntary alignment commitment.
    PRCWWLoadPersistentState(oTarget);
    int bWasInvoluntary = GetLocalInt(oTarget, "PRC_WW_Involuntary");
    int bHadControlBypass = GetLocalInt(oTarget, "PRC_WW_ControlBypass");
    SetLocalInt(oTarget, "PRC_WW_Involuntary", TRUE);
    SetLocalInt(oTarget, "PRC_WW_ControlBypass", TRUE);
    ExecuteScript("prc_wwformwolf", oTarget);

    if(bWasInvoluntary)
        SetLocalInt(oTarget, "PRC_WW_Involuntary", TRUE);
    else
        DeleteLocalInt(oTarget, "PRC_WW_Involuntary");

    if(bHadControlBypass)
        SetLocalInt(oTarget, "PRC_WW_ControlBypass", TRUE);
    else
        DeleteLocalInt(oTarget, "PRC_WW_ControlBypass");
}

void MoonSpellStripPolymorph(object oTarget)
{
    if(MoonSpellIsWerewolfShifted(oTarget))
    {
        MoonSpellUnshiftWerewolf(oTarget);
        return;
    }

    int bRemoved = TRUE;
    while(bRemoved)
    {
        bRemoved = FALSE;
        effect eTest = GetFirstEffect(oTarget);
        while(GetIsEffectValid(eTest))
        {
            if(GetEffectType(eTest) == EFFECT_TYPE_POLYMORPH)
            {
                RemoveEffect(oTarget, eTest);
                bRemoved = TRUE;
                break;
            }

            eTest = GetNextEffect(oTarget);
        }
    }
}

void MoonSpellRemoveSpellEffects(int nSpellID, object oTarget)
{
    int bRemoved = TRUE;
    while(bRemoved)
    {
        bRemoved = FALSE;
        effect eTest = GetFirstEffect(oTarget);
        while(GetIsEffectValid(eTest))
        {
            if(GetEffectSpellId(eTest) == nSpellID)
            {
                RemoveEffect(oTarget, eTest);
                bRemoved = TRUE;
                break;
            }

            eTest = GetNextEffect(oTarget);
        }
    }
}

void MoonSpellDeleteLocalInt(object oTarget, string sLocal)
{
    if(GetIsObjectValid(oTarget))
        DeleteLocalInt(oTarget, sLocal);
}

void MoonSpellSignal(object oCaster, object oTarget, int nSpellID, int bHostile)
{
    SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpellID, bHostile));
}
