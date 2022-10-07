/*
    sp_spellturning

    Spell Turning
    Abjuration
    Level:  Luck 7, Magic 7, Sor/Wiz 7
    Components:     V, S, M/DF
    Casting Time:   1 standard action
    Range:  Personal
    Target:     You
    Duration:   Until expended or 10 min./level

    Spells and spell-like effects targeted on you are turned back upon the
    original caster. The abjuration turns only spells that have you as a target.
    Effect and area spells are not affected. Spell turning also fails to stop
    touch range spells.

    From seven to ten (1d4+6) spell levels are affected by the turning.
    The exact number is rolled secretly.

    When you are targeted by a spell of higher level than the amount of spell
    turning you have left, that spell is partially turned. The subtract the
    amount of spell turning left from the spell level of the incoming spell,
    then divide the result by the spell level of the incoming spell to see what
    fraction of the effect gets through. For damaging spells, you and the caster
    each take a fraction of the damage. For nondamaging spells, each of you has
    a proportional chance to be affected.

    If you and a spellcasting attacker are both warded by spell turning effects
    in operation, a resonating field is created.

    Roll randomly to determine the result.
    d%  Effect
    01-70   Spell drains away without effect.
    71-80   Spell affects both of you equally at full effect.
    81-97   Both turning effects are rendered nonfunctional for 1d4 minutes.
    98-100  Both of you go through a rift into another plane.
    Arcane Material Component

    A small silver mirror.

    By: Flaming_Sword
    Created: Jul 20, 2006
    Modified: Jul 20, 2006
*/

#include "prc_sp_func"

void DispelMonitor(object oCaster, object oTarget, int nSpellID, int nBeatsRemaining)
{
    // Has the power ended since the last beat, or does the duration run out now
    if((--nBeatsRemaining == 0)                                         ||
       PRCGetDelayedSpellEffectsExpired(nSpellID, oTarget, oCaster) ||
       (!GetLocalInt(oTarget, "PRC_SPELL_TURNING_LEVELS"))
       )
    {
        PRCRemoveEffectsFromSpell(oTarget, nSpellID);
        if(DEBUG) DoDebug("sp_spellturning: Spell expired, clearing");
        DeleteLocalInt(oTarget, "PRC_SPELL_TURNING");
        DeleteLocalInt(oTarget, "PRC_SPELL_TURNING_LEVELS");
    }
    else
       DelayCommand(6.0f, DispelMonitor(oCaster, oTarget, nSpellID, nBeatsRemaining));
}

void main()
{
    object oCaster = OBJECT_SELF;
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    int nSpellID = PRCGetSpellId();
    PRCSetSchool(GetSpellSchool(nSpellID));
    if (!X2PreSpellCastCode()) return;
    object oTarget = PRCGetSpellTargetObject();
    float fDuration = 600.0 * nCasterLevel;
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nTurn = d4() + 6;
    PRCRemoveEffectsFromSpell(oTarget, nSpellID);
    if(nMetaMagic & METAMAGIC_MAXIMIZE) nTurn = 10;
    if(nMetaMagic & METAMAGIC_EMPOWER) nTurn += nTurn / 2;
    if(nMetaMagic & METAMAGIC_EXTEND) fDuration *= 2;
    SetLocalInt(oTarget, "PRC_SPELL_TURNING", TRUE);
    SetLocalInt(oTarget, "PRC_SPELL_TURNING_LEVELS", nTurn);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_SPELLTURNING), oTarget, fDuration, TRUE, -1, nCasterLevel);
    DelayCommand(6.0f, DispelMonitor(oCaster, oTarget, PRCGetSpellId(), FloatToInt(fDuration) / 6));
    PRCSetSchool();
}