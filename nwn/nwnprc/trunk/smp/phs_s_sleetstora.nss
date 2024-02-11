/*:://////////////////////////////////////////////
//:: Spell Name Sleet Storm: On Enter
//:: Spell FileName PHS_S_SleetStorA
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    I'll use Darkness style Invisibility + Darkness effect.

    No EffectUltravision() will be used in spells.

    The save is static, it was a DC10 Balance check, a DC10 reflex save is
    plenty large - still has a 1 in 20 chance of falling.

    13.33M is large! huge even! and it needs to be a good effect, it must
    really snow hard!
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Check AOE status
    if(!PHS_CheckAOECreator()) return;

    // Declare major variables
    object oTarget = GetEnteringObject();
    object oCreator = GetAreaOfEffectCreator();

    // Declare major effects
    effect eMovement = EffectMovementSpeedDecrease(50);
    effect eBlind = EffectDarkness();
    effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_DARKNESS);

    // Link effects
    effect eLink = EffectLinkEffects(eMovement, eBlind);
    eLink = EffectLinkEffects(eLink, eInvis);

    // Fire cast spell at event for the target
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_SLEET_STORM);

    // Affect everyone.
    PHS_AOE_OnEnterEffects(eLink, oTarget, PHS_SPELL_SLEET_STORM);
}
