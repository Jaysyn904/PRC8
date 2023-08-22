/*:://////////////////////////////////////////////
//:: Spell Name Mind Fog: On Exit
//:: Spell FileName PHS_S_MindFogB
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Mind fog, similar to Biowares.

    Ok, On Enter, we save against the spell and if fail, will take -10 on
    will saves.

    On Exit, if they still have the spells effects, will have the permament
    effects removed and have tempoary ones added.

    If, On Enter, they have tempoary (not permament) effects only, of this spell,
    they will make a new save and if failed, put permament effects on and remove
    the tempoary ones.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Declare major variables
    object oTarget = GetExitingObject();
    object oCaster = GetAreaOfEffectCreator();
    int nMetaMagic = PHS_GetAOEMetaMagic();

    // Declare effects
    effect eMind = EffectSavingThrowDecrease(SAVING_THROW_WILL, 10);
    effect eDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eLink = EffectLinkEffects(eMind, eDur);

    // Get duration
    float fDuration = PHS_GetRandomDuration(PHS_MINUTES, 6, 2, nMetaMagic);

    // Check if they have the permament effects
    if(PHS_GetHasSpellEffectDurationType(PHS_SPELL_MIND_FOG, oTarget, DURATION_TYPE_PERMANENT))
    {
        // Apply effects after removing permanent ones.
        PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_MIND_FOG, oTarget);

        // Apply new permament state.
        PHS_ApplyDuration(oTarget, eLink, fDuration);
    }
}
