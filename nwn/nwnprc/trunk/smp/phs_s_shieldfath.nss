/*:://////////////////////////////////////////////
//:: Spell Name Shield Of Faith
//:: Spell FileName PHS_S_ShieldFath
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Abjuration
    Level: Clr 1
    Components: V, S, M
    Casting Time: 1 standard action
    Range: Touch
    Target: Creature touched
    Duration: 1 min./level
    Saving Throw: Will negates (harmless)
    Spell Resistance: Yes (harmless)

    This spell creates a shimmering, magical field around the touched creature
    that averts attacks. The spell grants the subject a +2 deflection bonus to
    AC, with an additional +1 to the bonus for every six levels you have
    (maximum +5 deflection bonus at 18th level).

    Material Component: A small parchment with a bit of holy text written upon it.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Shimmering field - use a new VFX.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_SHIELD_OF_FAITH)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // 1 Minute/level
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel, nMetaMagic);

    // Increase of 2 + 1 per six levels. Max of 5.
    int nAC = PHS_LimitInteger(2 + (nCasterLevel / 6), 5);

    // Delcare effects
    effect eVis = EffectVisualEffect(VFX_IMP_AC_BONUS);
    effect eAC = EffectACIncrease(nAC, AC_DEFLECTION_BONUS);
    effect eDur = EffectVisualEffect(PHS_VFX_DUR_SHIELD_OF_FAITH);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // Link effects
    effect eLink = EffectLinkEffects(eAC, eDur);
    eLink = EffectLinkEffects(eLink, eCessate);

    // Remove previous castings
    PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_SHIELD_OF_FAITH, oTarget);

    // Signal spell cast at
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_SHIELD_OF_FAITH, FALSE);

    // Apply effects
    PHS_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration);
}
