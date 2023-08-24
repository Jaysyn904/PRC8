/*:://////////////////////////////////////////////
//:: Spell Name Eagle’s Splendor
//:: Spell FileName PHS_S_EaglesSpl
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation
    Level: Brd 2, Clr 2, Pal 2, Sor/Wiz 2
    Components: V, S, M/DF
    Casting Time: 1 standard action
    Range: Touch
    Target: Creature touched
    Duration: 1 min./level
    Saving Throw: Will negates (harmless)
    Spell Resistance: Yes

    The transmuted creature becomes more poised, articulate, and personally
    forceful. The spell grants a +4 enhancement bonus to Charisma, adding the
    usual benefits to Charisma-based skill checks and other uses of the
    Charisma modifier. Sorcerers and bards (and other spellcasters who rely
    on Charisma) affected by this spell do not gain any additional bonus
    spells for the increased Charisma, but the save DCs for spells they cast
    while under this spell’s effect do increase.

    Arcane Material Component: A few feathers or a pinch of droppings from an
    eagle.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    +4 to stat, doesn't stack with mass version.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_EAGLES_SPLENDOR)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    // Ability to use
    int nAbility = ABILITY_CHARISMA;

    // Duration - 1 minute/level
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel, nMetaMagic);

    // Make sure they are not immune to spells
    if(PHS_TotalSpellImmunity(oTarget)) return;

    // Check if oTarget has better effects already
    if(PHS_GetHasAbilityBonusOfPower(oTarget, nAbility, 4) == 2) return;

    // Delcare Effects
    effect eAbility = EffectAbilityIncrease(nAbility, 4);
    effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eAbility, eCessate);

    // Signal the spell cast at event
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_EAGLES_SPLENDOR, FALSE);

    // Remove these abilities effects
    PHS_RemoveAnyAbilityBonuses(oTarget, nAbility);

    // Apply effects and VFX to target
    PHS_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration);
}
