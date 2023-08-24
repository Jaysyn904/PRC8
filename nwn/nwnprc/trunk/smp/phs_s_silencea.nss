/*:://////////////////////////////////////////////
//:: Spell Name Silence: On Enter
//:: Spell FileName PHS_S_SilenceA
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Applies silence if they don't resist it.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Check AOE creator
    if(!PHS_CheckAOECreator()) return;

    // Declare major variables
    object oCaster = GetAreaOfEffectCreator();
    object oTarget = GetEnteringObject();

    // Declare effects and link
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eVis = EffectVisualEffect(VFX_IMP_SILENCE);
    effect eSilence = EffectSilence();
    effect eImmune = EffectDamageImmunityIncrease(DAMAGE_TYPE_SONIC, 100);

    effect eLink = EffectLinkEffects(eCessate, eSilence);
    eLink = EffectLinkEffects(eLink, eImmune);

    // Check hostility
    // Fire cast spell at event for the target
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_SILENCE, (!GetIsFriend(oTarget)));

    // Apply effects
    PHS_AOE_OnEnterEffectsVFX(eLink, oTarget, eVis, PHS_SPELL_SILENCE);
}
