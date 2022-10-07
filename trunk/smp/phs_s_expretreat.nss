/*:://////////////////////////////////////////////
//:: Spell Name Expeditious Retreat
//:: Spell FileName PHS_S_ExpeRetreat
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Personal, IE you. 1 min/level.
    This spell increases your base land speed by 30 feet. In NwN, this could be
    around 50% increase in movement speed.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    50% movement speed increase.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check
    if(!PHS_SpellHookCheck(PHS_SPELL_EXPEDITIOUS_RETREAT)) return;

    // Declare major varibles
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject(); // Should be OBJECT_SELF
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = PHS_GetMetaMagicFeat();

    // Get duration in minutes
    float fDuration = PHS_GetDuration(PHS_MINUTES, nCasterLevel, nMetaMagic);

    // Declare effects
    effect eVis = EffectVisualEffect(VFX_IMP_HASTE);
    effect eSpeed = EffectMovementSpeedIncrease(50);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // Link effects
    effect eLink = EffectLinkEffects(eSpeed, eCessate);

    // Remove all previous speed increases
    PHS_RemoveSpecificEffect(EFFECT_TYPE_MOVEMENT_SPEED_INCREASE, oTarget);

    // Signal spell cast at
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_EXPEDITIOUS_RETREAT, FALSE);

    // Apply effects
    PHS_ApplyDurationAndVFX(oTarget, eVis, eLink, fDuration);
}
