/*:://////////////////////////////////////////////
//:: Spell Name Spell Resistance
//:: Spell FileName PHS_S_SpellResis
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Abjuration
    Level: Clr 5, Magic 5, Protection 5
    Components: V, S, DF
    Casting Time: 1 standard action
    Range: Touch
    Target: Creature touched
    Duration: 1 min./level
    Saving Throw: Will negates (harmless)
    Spell Resistance: Yes (harmless)

    The creature gains spell resistance equal to 12 + your caster level.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Applys EffectSpellResistanceIncrease to the target. :-)

    No limit, remember, to the SR added.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_SPELL_RESISTANCE)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    int nCasterLevel = PHS_GetCasterLevel();
    // Bonus is 12 + Caster level
    int nBonus = 12 + nCasterLevel;

    // Duration in minutes/level
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel, nMetaMagic);

    // Declare effects
    effect eSR = EffectSpellResistanceIncrease(nBonus);
    effect eVis = EffectVisualEffect(VFX_IMP_MAGIC_PROTECTION);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eDur2 = EffectVisualEffect(VFX_DUR_MAGIC_RESISTANCE);
    effect eLink = EffectLinkEffects(eSR, eDur);
    eLink = EffectLinkEffects(eLink, eDur2);

    // Remove all previous castings of the spell
    PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_SPELL_RESISTANCE, oTarget);

    // Fire cast spell at event for the specified target
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_SPELL_RESISTANCE, FALSE);

    // Apply VFX impact and SR bonus effect
    PHS_ApplyDurationAndVFX(oTarget, eVis, eDur, fDuration);
}
