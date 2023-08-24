/*:://////////////////////////////////////////////
//:: Spell Name Pyrotechnics: Smoke: On Enter
//:: Spell FileName PHS_S_PyrotechA
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Uses Darkness invisibility for the ineffective through the cloud part.

    Defaults to fireworks. No sub-dial.

    The impact is easy - 1d4 + 1 rounds of blindness, SR + Will negates.

    The smoke cloud (1 round/level) applies the Darkness, and Darkness
    invisibility.

    Every HB may apply the -4 penalties to strength and dexterity.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Check AOE status
    if(!PHS_CheckAOECreator()) return;

    // Note: Set plot flag to TRUE
    // * No dispelling
    SetPlotFlag(OBJECT_SELF, TRUE);

    // Declare major variables
    object oTarget = GetEnteringObject();
    object oCaster = GetAreaOfEffectCreator();
    int nSpellSaveDC = PHS_GetAOESpellSaveDC();

    // Declare major effects
    effect eBlind = EffectDarkness();
    effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_DARKNESS);

    // Link effects
    effect eLink = EffectLinkEffects(eInvis, eBlind);

    // Also declare the -4 strength and dexterity
    effect eStrength = EffectAbilityDecrease(ABILITY_STRENGTH, 4);
    effect eDexterity = EffectAbilityDecrease(ABILITY_DEXTERITY, 4);
    effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);

    effect eAbility = EffectLinkEffects(eStrength, eDexterity);
    eAbility = EffectLinkEffects(eAbility, eVis);

    // Fire cast spell at event for the target
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_PYROTECHNICS);

    // Apply effects
    PHS_AOE_OnEnterEffects(eLink, oTarget, PHS_SPELL_PYROTECHNICS);

    // Check if they have the ability decreases applied
    if(!PHS_GetHasEffectFromSpell(EFFECT_TYPE_ABILITY_DECREASE, oTarget, PHS_SPELL_PYROTECHNICS, DURATION_TYPE_PERMANENT))
    {
        // We do an Fortitude save
        if(!PHS_SavingThrow(SAVING_THROW_FORT, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_NONE, oCaster))
        {
            // If failed, we apply permanently
            PHS_ApplyPermanent(oTarget, eAbility);
        }
    }
}
