/*:://////////////////////////////////////////////
//:: Spell Name Smooth Talk
//:: Spell FileName XXX_S_SmoothTalk
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Divination
    Level: Brd 1, Sor/Wiz 1
    Components: V, S
    Casting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 1 min/level
    Saving Throw: None
    Spell Resistance: Yes (harmless)
    Source: Various (VolkorTheRed)

    You become a talented speaker after casting this spell. While the spell is
    in effect, you gain a +10 on all Persuade checks.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    +10 to persuade checks, for one minute/level.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!SMP_SpellHookCheck(SMP_SPELL_SMOOTH_TALK)) return;

    // Declare major variables
    object oTarget = GetSpellTargetObject(); // Should be object self.
    int nCasterLevel = SMP_GetCasterLevel();
    int nMetaMagic = SMP_GetMetaMagicFeat();

    // Duration in turns, 1 minute/level
    float fDuration = SMP_GetDuration(SMP_MINUTES, nCasterLevel, nMetaMagic);

    // Declare effects
    effect eSkill = EffectSkillIncrease(SKILL_PERSUADE, 10);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    // Link
    effect eLink = EffectLinkEffects(eSkill, eCessate);

    // Signal event spell cast at
    SMP_SignalSpellCastAt(oTarget, SMP_SPELL_SMOOTH_TALK, FALSE);

    // Remove previous castings
    SMP_RemoveSpellEffectsFromTarget(SMP_SPELL_SMOOTH_TALK, oTarget);

    // Apply effects
    SMP_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration);
}
