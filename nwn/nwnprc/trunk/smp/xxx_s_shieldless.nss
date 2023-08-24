/*:://////////////////////////////////////////////
//:: Spell Name Shield, Lesser
//:: Spell FileName XXX_S_ShieldLess
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Abjuration [Force]
    Level: Sor/Wiz 0
    Components: V, S
    Casting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 3 rounds + 1 round/level (D)
    Saving Throw: Will negates (harmless)
    Spell Resistance: Yes (harmless)
    Source: Various (Capn Charlie)

    Lesser Shield creates an invisible, small shield-sized mobile disk of force
    that hovers in front of you. The disk provides a +2 shield bonus to AC. The
    shield has no armor check penalty or arcane spell failure chance, and cannot
    stop magic missiles.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Invisible shield, only +2 to AC, a low duration, personal only, and
    no protection against magic missile.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!SMP_SpellHookCheck(SMP_SPELL_SHIELD_LESSER)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = SMP_GetMetaMagicFeat();
    int nCasterLevel = SMP_GetCasterLevel();

    // 3 + 1 Round/level
    float fDuration = SMP_GetDuration(SMP_ROUNDS, nCasterLevel, nMetaMagic);

    // Delcare effects
    effect eVis = EffectVisualEffect(VFX_IMP_AC_BONUS);
    effect eAC = EffectACIncrease(2, AC_SHIELD_ENCHANTMENT_BONUS);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // Link effects
    effect eLink = EffectLinkEffects(eAC, eCessate);

    // Remove previous castings
    SMP_RemoveSpellEffectsFromTarget(SMP_SPELL_SHIELD_LESSER, oTarget);

    // Signal spell cast at
    SMP_SignalSpellCastAt(oTarget, SMP_SPELL_SHIELD_LESSER, FALSE);

    // Apply effects
    SMP_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration);
}
