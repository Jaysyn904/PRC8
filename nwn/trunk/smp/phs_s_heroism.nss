/*:://////////////////////////////////////////////
//:: Spell Name Heroism
//:: Spell FileName PHS_S_Heroism
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    1 creature touched. 10 min/level duration. Creature gets +2 attack, saves
    and skill checks.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As spell description.

    Also removes greater version!
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_HEROISM)) return;

    // Declare major objects
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Duration in 10 minutes/level
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel * 10, nMetaMagic);

    // Declare effects
    effect eVis = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 2);
    effect eAttack = EffectAttackIncrease(2);
    effect eSkill = EffectSkillIncrease(SKILL_ALL_SKILLS, 2);

    // Link effects
    effect eLink = EffectLinkEffects(eCessate, eSave);
    eLink = EffectLinkEffects(eLink, eAttack);
    eLink = EffectLinkEffects(eLink, eSkill);

    // Remove previous castings
    PHS_RemoveMultipleSpellEffectsFromTarget(oTarget, PHS_SPELL_HEROISM, PHS_SPELL_HEROISM_GREATER);

    // Signal spell cast at
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_HEROISM, FALSE);

    // Apply new effects
    PHS_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration);
}
