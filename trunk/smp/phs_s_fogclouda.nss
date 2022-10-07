/*:://////////////////////////////////////////////
//:: Spell Name Fog Cloud - On Enter
//:: Spell FileName PHS_S_FogCloudA
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
    effect eConceal = EffectConcealment(20, MISS_CHANCE_TYPE_VS_MELEE);
    effect eConceal2 = EffectConcealment(50, MISS_CHANCE_TYPE_VS_RANGED);

    // Link
    effect eLink = EffectLinkEffects(eConceal, eConceal2);

    // Fire cast spell at event for the target
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_FOG_CLOUD);

    // Apply effects
    PHS_AOE_OnEnterEffects(eLink, oTarget, PHS_SPELL_FOG_CLOUD);
}
