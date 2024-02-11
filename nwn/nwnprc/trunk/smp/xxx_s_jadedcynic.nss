/*:://////////////////////////////////////////////
//:: Spell Name Jaded Cynicism
//:: Spell FileName XXX_S_JadedCynic
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Abjuration
    Level: Brd 2
    Components: V
    Casting Time: 1 standard action
    Range: Personal
    Target: Caster
    Duration: 1 minute/level
    Saving Throw: None (Harmless)
    Spell Resistance: No (Harmless)
    Source: Various (Josh_Kablack)

    You draw upon your inner reserves of jaded cynicism and unrealesed angst to
    fortify your resolve against a cruel world unready for one so tragically hip
    as yourself. For the duration of this spell you are immune to Fear effects
    and any spell which requires a fear-based save. One additional effect of
    this spell is usually the annoying announcement of "What-EVER!" to any
    question, or anything not understood.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Immunity to fear, I like the spells description too :-)

    It was "What-EVER!" but Jaded Cynicism is cool. I re-added "What-EVER!" into
    the description.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!SMP_SpellHookCheck(SMP_SPELL_JADED_CYNICISM)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();// Should be OBJECT_SELF
    int nMetaMagic = SMP_GetMetaMagicFeat();
    int nCasterLevel = SMP_GetCasterLevel();

    // 1 minute/level
    float fDuration = SMP_GetDuration(SMP_MINUTES, nCasterLevel, nMetaMagic);

    // Delcare effects
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_MIND);
    effect eDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_POSITIVE);
    effect eImmunity = EffectImmunity(IMMUNITY_TYPE_FEAR);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // Link effects
    effect eLink = EffectLinkEffects(eDur, eImmunity);
    eLink = EffectLinkEffects(eLink, eCessate);

    // Remove previous castings
    SMP_RemoveSpellEffectsFromTarget(SMP_SPELL_JADED_CYNICISM, oTarget);

    // Signal spell cast at
    SMP_SignalSpellCastAt(oTarget, SMP_SPELL_JADED_CYNICISM, FALSE);

    // Apply effects
    SMP_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration);
}
