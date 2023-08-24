/*:://////////////////////////////////////////////
//:: Spell Name Stinking Cloud: On Enter
//:: Spell FileName PHS_S_StinkClouA
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Fortitude save to be dazed (for duration of the cloud).
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
    object oCaster = GetAreaOfEffectCreator();
    int nSpellSaveDC = PHS_GetAOESpellSaveDC();

    // Declare Effects
    effect eVis = EffectVisualEffect(VFX_IMP_DAZED_S);
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eDaze = EffectDazed();
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    // Link effects
    effect eLink = EffectLinkEffects(eMind, eDaze);
    eLink = EffectLinkEffects(eLink, eCessate);

    // Fire cast spell at event for the target
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_STINKING_CLOUD);

    // PvP check
    if(!GetIsReactionTypeFriendly(oTarget, oCaster) &&
    // Make sure they are not immune to spells
       !PHS_TotalSpellImmunity(oTarget))
    {
        // Fortitude save
        if(!PHS_SavingThrow(SAVING_THROW_FORT, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_NONE, oCaster))
        {
            // Apply effects
            PHS_AOE_OnEnterEffectsVFX(eLink, oTarget, eVis, PHS_SPELL_STINKING_CLOUD);
        }
    }
}
