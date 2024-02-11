//::///////////////////////////////////////////////


#include "PHS_INC_SPELLS"

void main()
{
    // Apply some paralsis to the target
    object oTarget = GetSpellTargetObject();

    // Declare Effects
    effect eParalyze = EffectParalyze();
    effect eDur1 = EffectVisualEffect(VFX_DUR_PARALYZED);
    effect eDur2 = EffectVisualEffect(VFX_DUR_PARALYZE_HOLD);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    // Link effects
    effect eLink = EffectLinkEffects(eParalyze, eDur1);
    eLink = EffectLinkEffects(eLink, eDur2);
    eLink = EffectLinkEffects(eLink, eCessate);

    SpeakString("PARALSIS: 120 seconds :" + GetName(oTarget));

    // Apply VFX Impact and daze effect
    PHS_ApplyDuration(oTarget, eLink, 120.0);

}
