/*:://////////////////////////////////////////////
//:: Spell Name Mind Fog: On Enter
//:: Spell FileName PHS_S_MindFogA
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
    // Check AOE status
    if(!PHS_CheckAOECreator()) return;

    // Declare major variables
    object oTarget = GetEnteringObject();
    object oCaster = GetAreaOfEffectCreator();
    int nSpellSaveDC = PHS_GetAOESpellSaveDC();

    // Declare effects
    effect eMind = EffectSavingThrowDecrease(SAVING_THROW_WILL, 10);
    effect eDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eLink = EffectLinkEffects(eMind, eDur);

    // Make eLink supernatural
    eLink = SupernaturalEffect(eLink);

    // Check reaction type
    if(GetIsReactionTypeFriendly(oTarget, oCaster)) return;

    // On Enter: so we check if they are already permamently under the effects..
    if(PHS_GetHasSpellEffectDurationType(PHS_SPELL_MIND_FOG, oTarget, DURATION_TYPE_PERMANENT))
    {
        // They have permament - all ok, stop script.
        return;
    }
    // else, check if got tempoary
    else if(PHS_GetHasSpellEffectDurationType(PHS_SPELL_MIND_FOG, oTarget, DURATION_TYPE_TEMPORARY))
    {
        // Fire cast spell at event for the target
        PHS_SignalSpellCastAt(oTarget, PHS_SPELL_MIND_FOG);

        // We do a new save, if failed, will remove the tempoary and
        // induce a permament state.
        if(!PHS_ImmunityCheck(oTarget, IMMUNITY_TYPE_MIND_SPELLS, 0.0, oCaster))
        {
            // Spell resistance
            if(!PHS_SpellResistanceCheck(oCaster, oTarget))
            {
                // Will save
                if(!PHS_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_MIND_SPELLS, oCaster))
                {
                    // Apply effects after removing temp ones.
                    PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_MIND_FOG, oTarget);

                    // Apply new permament state.
                    PHS_ApplyPermanent(oTarget, eLink);
                }
            }
        }
    }
    else
    {
        // Fire cast spell at event for the target
        PHS_SignalSpellCastAt(oTarget, PHS_SPELL_MIND_FOG);

        // Else, doesn't have it at all!
        // We save VS mind spells against the -10 permament saves.
        if(!PHS_ImmunityCheck(oTarget, IMMUNITY_TYPE_MIND_SPELLS, 0.0, oCaster))
        {
            // Spell resistance
            if(!PHS_SpellResistanceCheck(oCaster, oTarget))
            {
                // Will save
                if(!PHS_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_MIND_SPELLS, oCaster))
                {
                    // Apply effects
                    PHS_ApplyPermanent(oTarget, eLink);
                }
            }
        }
    }
}
