/*:://////////////////////////////////////////////
//:: Spell Name Heroism, Greater
//:: Spell FileName PHS_S_HeroismGrt
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    +4 morale bonus to attack rolls, saves, skill checks. Immunity to fear
    effects, and temp. hit points equal to caster level (max 20). 1 min/level
    duration. 1 creature touched.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As spell description.

    Also removes lesser version!
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_HEROISM_GREATER)) return;

    // Declare major objects
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Up to +20 Temp HP
    int nHP = PHS_LimitInteger(nCasterLevel, 20);

    // Duration in 10 turns
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel * 10, nMetaMagic);

    // Declare effects
    effect eVis = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 4);
    effect eAttack = EffectAttackIncrease(4);
    effect eSkill = EffectSkillIncrease(SKILL_ALL_SKILLS, 4);
    effect eFear = EffectImmunity(IMMUNITY_TYPE_FEAR);
    effect eHP = EffectTemporaryHitpoints(nHP);

    // Link effects
    effect eLink = EffectLinkEffects(eCessate, eSave);
    eLink = EffectLinkEffects(eLink, eAttack);
    eLink = EffectLinkEffects(eLink, eSkill);
    eLink = EffectLinkEffects(eLink, eFear);
    eLink = EffectLinkEffects(eLink, eHP);

    // Remove previous castings
    PHS_RemoveMultipleSpellEffectsFromTarget(oTarget, PHS_SPELL_HEROISM_GREATER, PHS_SPELL_HEROISM);

    // Signal spell cast at
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_HEROISM_GREATER, FALSE);

    // Apply new effects
    PHS_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration);
}
