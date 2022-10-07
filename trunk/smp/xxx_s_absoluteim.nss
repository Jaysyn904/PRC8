/*:://////////////////////////////////////////////
//:: Spell Name Absolute Immunity
//:: Spell FileName XXX_S_AbsoluteIm
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Abjuration
    Level: Sor/Wiz 9
    Components: V, S
    Casting Time: Free Quickened spell; see text
    Range: Personal
    Duration: 4 rounds
    Saving Throw: None
    Spell Resistance: Yes (Harmless)
    Source: Various (Baptor)

    This spell wraps the caster in a blanket of protective energy, granting him
    DR 60/Epic for the duration of the spell. In addition, as it is cast with a
    casting time of 0, it acts as if quickened, however, another quickened spell
    cannot be cast in the same round.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Series: Guardian Mantle, Greater Guardian Mantle and Absolute Immunity.
    DR: 20/Epic, 40/Epic and 60/Epic respectivly.

    Could change to be 1 round/5 levels, or 1 round/4 levels, and still be
    balancedish.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!SMP_SpellHookCheck(SMP_SPELL_ABSOLUTE_IMMUNITY)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();

    // Duration is 4 rounds.
    float fDuration = RoundsToSeconds(4);

    // Declare effects
    effect eDR = EffectDamageReduction(60, DAMAGE_POWER_PLUS_TWENTY);
    effect eDur = EffectVisualEffect(SMP_VFX_DUR_ABSOLUTE_IMMUNITY);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // Link effects
    effect eLink = EffectLinkEffects(eDR, eDur);
    eLink = EffectLinkEffects(eLink, eCessate);

    // Remove previous effects
    SMP_RemoveSpellEffectsFromTarget(SMP_SPELL_ABSOLUTE_IMMUNITY, oTarget);

    // Signal spell cast at
    SMP_SignalSpellCastAt(oTarget, SMP_SPELL_ABSOLUTE_IMMUNITY, FALSE);

    // Apply effects to the target
    SMP_ApplyDuration(oTarget, eDur, fDuration);

    // Additional: Set to not able to cast quickened spells (or another one of
    // these) this round.
    // NOTE: NOT WORKING YET.
    SetLocalInt(oCaster, "SMP_NO_QUICKENED_SPELLS", TRUE);
    DelayCommand(5.5, DeleteLocalInt(oCaster, "SMP_NO_QUICKENED_SPELLS"));
}
