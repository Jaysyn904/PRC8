/*:://////////////////////////////////////////////
//:: Spell Name Unerring Accuracy
//:: Spell FileName SMP_S_UnerringAc
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Divination
    Level: Sor/Wiz 8
    Components: V, S, M
    Casting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 1 round/level
    Saving Throw: None (harmless)
    Spell Resistance: No (harmless)
    Source: Various (cthulhu)

    For the duration of this spell, the caster gains a keen insight into all his
    opponents' movements, gaining a +1 insight bonus to attack rolls per caster
    level (max +20).

    Material Component; a scroll with Magic Missile inscribed on it. Casting this
    spell consumes the scroll.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    This is easy to impliment, but harder to test fully.

    Might be balanced, an idea to balance is to change it to 1 per 2 caster
    levels.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!SMP_SpellHookCheck(SMP_SPELL_UNERRING_ACCURACY)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject(); // Should be OBJECT_SELF
    int nCasterLevel = SMP_GetCasterLevel();

    // Limit attack bonus to 20
    int nBonus = SMP_LimitInteger(nCasterLevel, 20);

    // Duration - 1 round/level
    float fDuration = SMP_GetDuration(SMP_ROUNDS, nCasterLevel, FALSE);

    // Delcare effects
    effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    effect eAttack = EffectAttackIncrease(nBonus);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // Link effects
    effect eLink = EffectLinkEffects(eAttack, eCessate);

    // Remove previous castings
    SMP_RemoveSpellEffectsFromTarget(SMP_SPELL_UNERRING_ACCURACY, oTarget);

    // Signal spell cast at
    SMP_SignalSpellCastAt(oTarget, SMP_SPELL_UNERRING_ACCURACY, FALSE);

    // Apply effects
    SMP_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration);
}
