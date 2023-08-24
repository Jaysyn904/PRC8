/*:://////////////////////////////////////////////
//:: Spell Name Barkskin
//:: Spell FileName SMP_S_Barkskin
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Barkskin
    Transmutation
    Level: Drd 2, Rgr 2, Plant 2
    Components: V, S, DF
    Casting Time: 1 standard action
    Range: Touch
    Target: Living creature touched
    Duration: 10 min./level
    Saving Throw: None
    Spell Resistance: Yes (harmless)

    Barkskin toughens a creature’s skin. The effect grants a +2 enhancement
    bonus to the creature’s existing natural armor bonus. This enhancement
    bonus increases by 1 for every three caster levels above 3rd, to a maximum
    of +5 at caster level 12th.

    The enhancement bonus provided by barkskin stacks with the target’s natural
    armor bonus, but not with other enhancement bonuses to natural armor. A
    creature without natural armor has an effective natural armor bonus of +0.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Remember, the second part is the "Creature Stats: Natural Armor" which DOES
    stack with EffectACIncrease(1, AC_NATURAL_BONUS)

    This is done exactly as the spell says.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!SMP_SpellHookCheck()) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = SMP_GetCasterLevel();
    int nMetaMagic = SMP_GetMetaMagicFeat();
    // AC bonus is 2 + 1 for each 3 levels above 3rd. Max 5.
    int nACBonus = SMP_LimitInteger(2 + ((nCasterLevel - 3) / 3), 5);

    // Duration is 10 min/level
    float fDuration = SMP_GetDuration(SMP_MINUTES, nCasterLevel * 10, nMetaMagic);

    // Make sure they are not immune to spells
    if(SMP_TotalSpellImmunity(oTarget)) return;

    // Delcare effects
    effect eACNatural = EffectACIncrease(nACBonus, AC_NATURAL_BONUS);
    effect eDur = EffectVisualEffect(VFX_DUR_PROT_BARKSKIN);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_NATURE);

    // Link effects
    effect eLink = EffectLinkEffects(eACNatural, eDur);
    eLink = EffectLinkEffects(eLink, eCessate);

    // Signal Spell Cast At
    SMP_SignalSpellCastAt(oTarget, SMP_SPELL_BARKSKIN, FALSE);

    // Remove previous effects
    SMP_RemoveSpellEffectsFromTarget(SMP_SPELL_BARKSKIN, oTarget);

    // Apply new effects
    SMP_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration);
}
