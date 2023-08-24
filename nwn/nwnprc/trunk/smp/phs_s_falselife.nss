/*:://////////////////////////////////////////////
//:: Spell Name False Life
//:: Spell FileName phs_s_falselife
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Personal range, 1 hour/level or until discharged.

    You harness the power of unlife to grant yourself a limited ability to avoid
    death. While this spell is in effect, you gain temporary hit points equal to
    1d10 +1 per caster level (maximum +10).

    Material Component: A small amount of alcohol or distilled spirits, which
    you use to trace certain sigils on your body during casting. These sigils
    cannot be seen once the alcohol or spirits evaporate.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Applies it as the spell - 1d10 + 1-10 tempoary HP, and previous castings
    are removed.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_FALSE_LIFE)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject(); // Should be OBJECT_SELF only.
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    // Get duration in hour
    float fDuration = PHS_GetDuration(PHS_HOURS, nCasterLevel, nMetaMagic);

    // Bonus is 1d10 + 1-10 tempoary HP.
    int nLevelBonus = PHS_LimitInteger(nCasterLevel, 10);
    // Metamagic the bonus HP, random 1d10 + 1-10.
    int nBonusHP = PHS_MaximizeOrEmpower(10, 1, nMetaMagic, nLevelBonus);

    // Declare effects
    effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eTempHP = EffectTemporaryHitpoints(nBonusHP);
    // Link effects
    effect eLink = EffectLinkEffects(eCessate, eTempHP);

    // Remove previous effects
    PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_FALSE_LIFE, oTarget);

    // Signal spell cast at
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_FALSE_LIFE, FALSE);

    // Apply effects
    PHS_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration);
}
