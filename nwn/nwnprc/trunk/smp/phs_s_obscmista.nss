/*:://////////////////////////////////////////////
//:: Spell Name Obscuring Mist - On Enter
//:: Spell FileName PHS_S_ObscMistA
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    On enter applies the consealments.

    Note: This is almost natural - the fog is just FOG, and so is visual, NOT
    something that directly affects a creature (as it were). This means NOTHING
    will stop the effects.
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

    //Declare major effects
    effect eConseal = EffectConcealment(20, MISS_CHANCE_TYPE_VS_MELEE);
    effect eConseal2 = EffectConcealment(50, MISS_CHANCE_TYPE_VS_RANGED);

    // Link
    effect eLink = EffectLinkEffects(eConseal, eConseal2);

    // Fire cast spell at event for the target
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_OBSCURING_MIST);

    // Apply effects
    PHS_AOE_OnEnterEffects(eLink, oTarget, PHS_SPELL_OBSCURING_MIST);
}
