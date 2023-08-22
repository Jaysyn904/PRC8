/*:://////////////////////////////////////////////
//:: Spell Name Solid Fog: On Enter
//:: Spell FileName PHS_S_SolidFogA
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Acid Fog uses this as a template. It applies, on enter (and removes on exit)
    these effects:

    80% slow down in movement.
    20% melee consealment.
    100% ranged consealment.
    100% ranged miss chance
    -2 To Hit (Melee)
    -2 To Damage (Melee)
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
    effect eSlow = EffectMovementSpeedDecrease(80);
    effect eConseal = EffectConcealment(20, MISS_CHANCE_TYPE_VS_MELEE);
    effect eConseal2 = EffectConcealment(100, MISS_CHANCE_TYPE_VS_RANGED);
    effect eMiss = EffectMissChance(100, MISS_CHANCE_TYPE_VS_RANGED);
    effect eHitReduce = EffectAttackDecrease(2);
    effect eDamReduce = EffectDamageDecrease(2);

    // Link
    effect eLink = EffectLinkEffects(eConseal, eConseal2);
    eLink = EffectLinkEffects(eLink, eSlow);
    eLink = EffectLinkEffects(eLink, eMiss);
    eLink = EffectLinkEffects(eLink, eHitReduce);
    eLink = EffectLinkEffects(eLink, eDamReduce);

    //Fire cast spell at event for the target
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_SOLID_FOG);

    // Apply effects
    PHS_AOE_OnEnterEffects(eLink, oTarget, PHS_SPELL_SOLID_FOG);
}
