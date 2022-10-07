/*:://////////////////////////////////////////////
//:: Spell Name Acid Fog: On Enter
//:: Spell FileName SMP_S_AcidFogA
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Jasperre:

    On Enter: Apply these effects:
    80% slow down in movement.
    20% melee consealment.
    100% ranged consealment.
    100% ranged miss chance
    -2 To Hit (Melee)
    -2 To Damage (Melee)

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
    effect eConseal2 = EffectConcealment(100, MISS_CHANCE_TYPE_VS_RANGED);
    effect eMiss = EffectMissChance(100, MISS_CHANCE_TYPE_VS_RANGED);
    effect eHitReduce = EffectAttackDecrease(2);
    effect eDamReduce = EffectDamageDecrease(2, DAMAGE_TYPE_ACID);

    // Link
    effect eLink = EffectLinkEffects(eConseal, eConseal2);
    eLink = EffectLinkEffects(eLink, eSlow);
    eLink = EffectLinkEffects(eLink, eMiss);
    eLink = EffectLinkEffects(eLink, eHitReduce);
    eLink = EffectLinkEffects(eLink, eDamReduce);

    // Fire cast spell at event for the target
    SMP_SignalSpellCastAt(oTarget, SMP_SPELL_ACID_FOG);

    // Apply effects
    SMP_AOE_OnEnterEffects(eLink, oTarget, SMP_SPELL_ACID_FOG);
}
