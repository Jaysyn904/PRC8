/*:://////////////////////////////////////////////
//:: Spell Name Glibness
//:: Spell FileName PHS_S_Glibness
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    10 Min/level. Target: you. +30 bluff checks.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    The second effect would be things like "zone of thruth", with special
    checks done then.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_GLIBNESS)) return;

    // Declare major variables
    object oTarget = GetSpellTargetObject(); // Should be object self.
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Duration in turns (10 turns/level)
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel * 10, nMetaMagic);

    // Declare effects
    effect eSkill = EffectSkillIncrease(SKILL_BLUFF, 30);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    // Link
    effect eLink = EffectLinkEffects(eSkill, eCessate);

    // Signal event spell cast at
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_GLIBNESS, FALSE);

    // Remove previous castings
    PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_GLIBNESS, oTarget);

    // Apply effects
    PHS_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration);
}
