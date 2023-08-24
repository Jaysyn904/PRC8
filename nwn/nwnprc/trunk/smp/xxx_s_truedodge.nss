/*:://////////////////////////////////////////////
//:: Spell Name True Dodge
//:: Spell FileName XXX_S_TrueDodge
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Divination
    Level: Sor/Wiz 1
    Components: V, F
    Casting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 6 seconds
    Saving Throw: None
    Spell Resistance: Yes (harmless)
    Source: Various (Israfel666)

    You gain temporary, intuitive insight into the immediate future during the
    next round. You gain a +20 dodge bonus to AC against the next 6 second's
    attack roll made against you.

    Focus: A small wooden replica of a bend archery target.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As it says. Similar to True Strike, and of course is easily converted.

    Still, credit is due, its a nice spell for level 1 (so, cast it, get a
    round of free AC for casting a better spell or something).
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!SMP_SpellHookCheck(SMP_SPELL_TRUE_DODGE)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject(); // Should be OBJECT_SELF

    // 1 round.
    float fDuration = RoundsToSeconds(1);

    // Delcare effects
    effect eVis = EffectVisualEffect(VFX_IMP_AC_BONUS);
    effect eAC = EffectACIncrease(20, AC_DODGE_BONUS);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // Link effects
    effect eLink = EffectLinkEffects(eAC, eCessate);

    // Remove previous castings
    SMP_RemoveSpellEffectsFromTarget(SMP_SPELL_TRUE_DODGE, oTarget);

    // Signal spell cast at
    SMP_SignalSpellCastAt(oTarget, SMP_SPELL_TRUE_DODGE, FALSE);

    // Apply effects
    SMP_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration);
}
