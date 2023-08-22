/*:://////////////////////////////////////////////
//:: Spell Name Bear’s Endurance
//:: Spell FileName PHS_S_BearsEnd
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation
    Level: Clr 2, Drd 2, Rgr 2, Sor/Wiz 2
    Components: V, S, DF
    Casting Time: 1 standard action
    Range: Touch
    Target: Creature touched
    Duration: 1 min./level
    Saving Throw:Will negates (harmless)
    Spell Resistance: Yes

    The affected creature gains greater vitality and stamina. The spell grants
    the subject a +4 enhancement bonus to Constitution, which adds the usual
    benefits to hit points, Fortitude saves, Constitution checks, and so forth.

    Hit points gained by a temporary increase in Constitution score are not
    temporary hit points. They go away when the subject’s Constitution drops
    back to normal. They are not lost first as temporary hit points are.
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
    if(!PHS_SpellHookCheck()) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    // Ability to use
    int nAbility = ABILITY_CONSTITUTION;

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
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_BEARS_ENDURANCE, FALSE);

    // Remove these abilities effects
    PHS_RemoveAnyAbilityBonuses(oTarget, nAbility);

    // Apply effects and VFX to target
    PHS_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration);
}
