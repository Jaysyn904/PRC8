/*:://////////////////////////////////////////////
//:: Spell Name Adventurer's Luck
//:: Spell FileName XXX_S_AdventLuck
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Transmutation
    Also known as: Drawmij's Adventurer's Luck
    Level: Sor/Wiz 2
    Components: V, S, M
    Casting Time: 1 round
    Range: Touch
    Target: Creature touched
    Duration: 10 minutes
    Saving Throw: Will negates (harmless)
    Spell Resistance: Yes (Harmless)
    Source: Various (Owain_Abjurer)

    This spell bestows upon the touched creature incredible luck. For the
    duration of the spell, the recipient of this magic gains a +1 luck bonus per
    4 caster levels (maximum of +5 bonus) on saving throws and skill checks.

    Material Components: Ruby dust to be sprinkled over the target's head (worth
    50 gold pieces).
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Will provide the bonuses, as usual, for 10 minutes (it was 30) which might
    change to 1 minute/level, but probably not.

    Removed "bonus to ability checks" as there is no way of adding that (dammit!)
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!SMP_SpellHookCheck(SMP_SPELL_ADVENTURERS_LUCK)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = SMP_GetCasterLevel();
    int nMetaMagic = SMP_GetMetaMagicFeat();

    // Duration is 10 minutes
    float fDuration = SMP_GetDuration(SMP_MINUTES, 10, nMetaMagic);

    // Get bonus to apply
    int nBonus = SMP_LimitInteger(nCasterLevel/4, 5, 1);

    // Declare effects
    effect eVis = EffectVisualEffect(SMP_VFX_IMP_ADVENTURERS_LUCK);
    effect eSkill = EffectSkillIncrease(SKILL_ALL_SKILLS, nBonus);
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, nBonus);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // Link effects
    effect eLink = EffectLinkEffects(eSkill, eSave);
    eLink = EffectLinkEffects(eLink, eCessate);

    // Remove previous effects
    SMP_RemoveSpellEffectsFromTarget(SMP_SPELL_ADVENTURERS_LUCK, oTarget);

    // Signal spell cast at
    SMP_SignalSpellCastAt(oTarget, SMP_SPELL_ADVENTURERS_LUCK, FALSE);

    // Apply effects to the target
    SMP_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration);
}
