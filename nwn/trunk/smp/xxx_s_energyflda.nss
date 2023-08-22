/*:://////////////////////////////////////////////
//:: Spell Name Energy Field: On Enter
//:: Spell FileName XXX_S_EnergyFldA
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Jasperre:

    On Enter: Apply these effects:
    80% slow down in movement.
    20% melee consealment.
    50% ranged consealment.
    -2 Damage (melee)
    -2 To Hit (melee)

    Damage is handled on heartbeat.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Check AOE status
    if(!SMP_CheckAOECreator()) return;

    // Declare major variables
    object oTarget = GetEnteringObject();
    object oCreator = GetAreaOfEffectCreator();

    //Declare major effects
    effect eSlow = EffectMovementSpeedDecrease(80);
    effect eConseal = EffectConcealment(20, MISS_CHANCE_TYPE_VS_MELEE);
    effect eConseal2 = EffectConcealment(50, MISS_CHANCE_TYPE_VS_RANGED);
    // For fun, reduce the damage by negative type.
    effect eDamReduce = EffectDamageDecrease(2, DAMAGE_TYPE_NEGATIVE);
    effect eHitReduce = EffectAttackIncrease(2);

    // Link
    effect eLink = EffectLinkEffects(eConseal, eConseal2);
    eLink = EffectLinkEffects(eLink, eSlow);
    eLink = EffectLinkEffects(eLink, eDamReduce);
    eLink = EffectLinkEffects(eLink, eHitReduce);

    //Fire cast spell at event for the target
    SMP_SignalSpellCastAt(oTarget, SMP_SPELL_ENERGY_FIELD);

    // Apply effects
    SMP_AOE_OnEnterEffects(eLink, oTarget, SMP_SPELL_ENERGY_FIELD);
}
