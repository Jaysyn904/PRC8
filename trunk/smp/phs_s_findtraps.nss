/*:://////////////////////////////////////////////
//:: Spell Name Find Traps
//:: Spell FileName PHS_S_FindTraps
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Personal, 1 min/level.

    You gain intuitive insight into the workings of traps. You can detect magical
    traps only detectable by a rogue (Normal traps of DC 35 or over are still
    impossible to find however). In addition, you gain an insight bonus equal
    to one-half your caster level (maximum +10) on Search checks made to find
    traps while the spell is in effect.

    Note that find traps grants no ability to disable the traps that you may
    find.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    up to +10 search checks, and spell-like traps we can script can be detected
    by these, even if they are not a rogue.

    We cannot delve into hard-coded "rogues can only detect DC35 traps" though.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check
    if(!PHS_SpellHookCheck(PHS_SPELL_FIND_TRAPS)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject(); // Should be object self.
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();
    // Duration is 1 minute/level
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel, nMetaMagic);

    // Bonus to search...1 to 10.
    int nBonus = PHS_LimitInteger(nCasterLevel / 2, 10);

    // Declare effects
    effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eSearch = EffectSkillIncrease(SKILL_SEARCH, nBonus);
    // Link effects
    effect eLink = EffectLinkEffects(eCessate, eSearch);

    // Make it into a trap-only effect
    eLink = VersusTrapEffect(eLink);

    // Remove previous effects
    PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_FIND_TRAPS, oTarget);

    // Signal spell cast at
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_FIND_TRAPS, FALSE);

    // Apply effects
    PHS_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration);
}
