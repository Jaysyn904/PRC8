/*:://////////////////////////////////////////////
//:: Spell Name Mind Blank
//:: Spell FileName PHS_S_MindBlank
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Abjuration
    Level: Protection 8, Sor/Wiz 8
    Components: V, S
    Casting Time: 1 standard action
    Range: Close (8M)
    Target: One creature
    Duration: 24 hours
    Saving Throw: Will negates (harmless)
    Spell Resistance: Yes (harmless)

    The subject is protected from all devices and spells that detect, influence,
    or read emotions or thoughts. This spell protects against all mind-affecting
    spells and effects as well as information gathering by divination spells or
    effects. Mind blank even foils limited wish, miracle, and wish spells when
    they are used in such a way as to affect the subject’s mind or to gain
    information about it. In the case of scrying that scans an area the creature
    is in, such as arcane eye, the spell works but the creature simply isn’t
    detected. Scrying attempts that are targeted specifically at the subject do
    not work at all.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Immunity: Mind spells applied.

    Pretty simple, eh?

    OK, Ok, we'll also add in, just in case, any of the other mind-effecting
    effects, as immunities.

    Only protection - it doesn't cure anything.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_MIND_BLANK)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Duration is 24 hours
    float fDuration = PHS_GetDuration(PHS_HOURS, 24, nMetaMagic);

    // Declare effects
    effect eImmuneMind = EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);
    effect eDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_POSITIVE);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // Link effects
    effect eLink = EffectLinkEffects(eImmuneMind, eDur);
    eLink = EffectLinkEffects(eLink, eCessate);

    // Remove previous effects
    PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_MIND_BLANK, oTarget);

    // Signal spell cast at
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_MIND_BLANK, FALSE);

    // Apply effects to the target
    PHS_ApplyDuration(oTarget, eLink, fDuration);
}
