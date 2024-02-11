/*:://////////////////////////////////////////////
//:: Spell Name Longstrider
//:: Spell FileName PHS_S_Longstride
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    +30% speed increase for the caster. 1 hour/level.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Same as spell effect. 10 feet = 3.3M, so add 3.3 meters onto base movement
    speed.

    Hmm, this equates to maybe 30% extra. We'll make it 30% for now.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_LONGSTRIDER)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();  // Should be OBJECT_SELF
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Duration is 1 hour/level
    float fDuration = PHS_GetDuration(PHS_HOURS, nCasterLevel, nMetaMagic);

    // Declare effects
    effect eMoveIncrease = EffectMovementSpeedIncrease(30);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eVis = EffectVisualEffect(VFX_IMP_HASTE);

    // Link effects
    effect eLink = EffectLinkEffects(eMoveIncrease, eCessate);

    // Remove previous effects
    PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_LONGSTRIDER, oTarget);

    // Signal spell cast at event
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_LONGSTRIDER, FALSE);

    // Apply visual effects and speed increase
    PHS_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration);
}
