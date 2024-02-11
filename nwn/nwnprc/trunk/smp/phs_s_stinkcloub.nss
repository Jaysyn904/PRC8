/*:://////////////////////////////////////////////
//:: Spell Name Stinking Cloud: On Exit
//:: Spell FileName PHS_S_StinkClouB
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    If they have the spells effects, we remove them, and might apply them for
    1d4 + 1 additional rounds if we did remove any.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Check if they have it
    object oTarget = GetExitingObject();
    int nMetaMagic = PHS_GetAOEMetaMagic();
    int bHasIt = PHS_GetHasAOEEffects(PHS_SPELL_STINKING_CLOUD, oTarget);

    // Exit - remove effects
    PHS_AOE_OnExitEffects(PHS_SPELL_STINKING_CLOUD);

    // Have we got no more AOE's to move out of?
    // If we just removed the only case of stinking cloud, yes, we just removed
    // it from us, and we had it, so we want 1d4 + 1 extra rounds,.
    if(bHasIt == TRUE && bHasIt != PHS_GetHasAOEEffects(PHS_SPELL_STINKING_CLOUD, oTarget))
    {
        // Put it on for 1d4 + 1 rounds.
        float fDuration = PHS_GetRandomDuration(PHS_ROUNDS, 4, 1, nMetaMagic, 1);

        // Declare Effects
        effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
        effect eDaze = EffectDazed();
        effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

        // Link effects
        effect eLink = EffectLinkEffects(eMind, eDaze);
        eLink = EffectLinkEffects(eLink, eCessate);

        // Apply the daze for the duration (no impact VFX's)
        PHS_ApplyDuration(oTarget, eLink, fDuration);
    }
}
