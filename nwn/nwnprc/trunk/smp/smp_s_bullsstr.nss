/*:://////////////////////////////////////////////
//:: Spell Name Bull’s Strength
//:: Spell FileName SMP_S_BullsStr
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation
    Level: Clr 2, Drd 2, Pal 2, Sor/Wiz 2, Strength 2
    Components: V, S, M/DF
    Casting Time: 1 standard action
    Range: Touch
    Target: Creature touched
    Duration: 1 min./level
    Saving Throw:Will negates (harmless)
    Spell Resistance: Yes (harmless)

    The subject becomes stronger. The spell grants a +4 enhancement bonus to
    Strength, adding the usual benefits to melee attack rolls, melee damage
    rolls, and other uses of the Strength modifier.

    Arcane Material Component: A few hairs, or a pinch of dung, from a bull.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    +4 to stat, doesn't stack with mass version.
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
    // Ability to use
    int nAbility = ABILITY_STRENGTH;

    // Duration - 1 minute/level
    float fDuration = SMP_GetDuration(SMP_MINUTES, nCasterLevel, nMetaMagic);

    // Make sure they are not immune to spells
    if(SMP_TotalSpellImmunity(oTarget)) return;

    // Check if oTarget has better effects already
    if(SMP_GetHasAbilityBonusOfPower(oTarget, nAbility, 4) == 2) return;

    // Delcare Effects
    effect eAbility = EffectAbilityIncrease(nAbility, 4);
    effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eAbility, eCessate);

    // Signal the spell cast at event
    SMP_SignalSpellCastAt(oTarget, SMP_SPELL_BULLS_STRENGTH, FALSE);

    // Remove these abilities effects
    SMP_RemoveAnyAbilityBonuses(oTarget, nAbility);

    // Apply effects and VFX to target
    SMP_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration);
}
