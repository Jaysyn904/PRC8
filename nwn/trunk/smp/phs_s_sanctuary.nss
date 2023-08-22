/*:://////////////////////////////////////////////
//:: Spell Name Sanctuary
//:: Spell FileName PHS_S_Sanctuary
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Range: Touch
    Target: Creature touched
    Duration: 1 round/level
    Saving Throw: Will negates
    Spell Resistance: No

    All creatures who percieve the touched creature must attempt a Will save. If
    the save succeeds, the opponent can see the target normally and is unaffected
    by that casting of the spell. If the save fails, the opponent cannot see the
    creature as if they were under the effect of invisibility. This spell does
    not prevent the warded creature from being attacked or affected by area or
    effect spells. The subject cannot attack without breaking the spell but may
    use nonattack spells or otherwise act.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As above - uses the default Bioware Sancuary, so its not exactly to D&D at all.

    Sancuary, as far as I am aware, is a better invisiblity - as it is used
    as a basis for the Bioware Etherealness.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check
    if(!PHS_SpellHookCheck(PHS_SPELL_SANCTUARY)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Get duration in rounds
    float fDuration = PHS_GetDuration(PHS_ROUNDS, nCasterLevel, nMetaMagic);

    // Declare effects
    effect eSanctuary = EffectSanctuary(nSpellSaveDC);
    effect eDur = EffectVisualEffect(VFX_DUR_SANCTUARY);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // Link effects
    effect eLink = EffectLinkEffects(eSanctuary, eDur);
    eLink = EffectLinkEffects(eLink, eCessate);

    // Signal spell cast at event
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_SANCTUARY, FALSE);

    // Apply duration effects
    PHS_ApplyDuration(oTarget, eLink, fDuration);
}
