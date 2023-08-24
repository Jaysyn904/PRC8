/*:://////////////////////////////////////////////
//:: Spell Name Guidance
//:: Spell FileName PHS_S_Guidance
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    creature touched gets +1 on attack rolls, saving throws or skill checks for
    9 seconds.

    "This spell imbues the subject with a touch of divine guidance. The creature
    gets a +1 competence bonus on a single attack roll, saving throw, or skill
    check, for 9 seconds.

    You can either choose attack, saving throw, or skill for the bonus applied.
    NwN cannot affect "1 roll" so the duration is set to 9 seconds (and cannot
    be extended)."
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As I have said, 9 seconds (IE should be about 1 attack, skill check (EG:
    use magical device, taunt) or save (or rounds of saves)).

    All 3 are universal bonuses (to all saves, or all skills). 9 seconds
    worth won't break a game.

    This will definatly be a sub-dial spell, the duration is too small and it
    is definatly not going to be a problem.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_GUIDANCE)) return;

    // Declare major variables
    object oTarget = GetSpellTargetObject();
    int nSpell = GetSpellId();

    // Duration is a static 9 seconds - as true strike.
    float fDuration = 9.0;

    // Bonus effect...what is it?
    effect eBonus;
    // Depends on "subspell" cast
    if(nSpell == PHS_SPELL_GUIDANCE_SKILL)
    {
        eBonus = EffectSkillIncrease(SKILL_ALL_SKILLS, 1);
    }
    else if(nSpell == PHS_SPELL_GUIDANCE_SAVE)
    {
        eBonus = EffectSavingThrowIncrease(SAVING_THROW_ALL, 1);
    }
    // Default to attack
    else //if(nSpell == PHS_SPELL_GUIDANCE_ATTACK)
    {
        eBonus = EffectAttackIncrease(1, ATTACK_BONUS_MISC);
    }

    // Declare other effects
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    // Link
    effect eLink = EffectLinkEffects(eBonus, eCessate);

    // Signal event spell cast at
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_GUIDANCE, FALSE);

    // Remove previous castings (remove subspell)
    PHS_RemoveSpellEffectsFromTarget(nSpell, oTarget);

    // Apply effects
    PHS_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration);
}
