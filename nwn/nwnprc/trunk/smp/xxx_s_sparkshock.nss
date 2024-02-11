/*:://////////////////////////////////////////////
//:: Spell Name Spark Shock
//:: Spell FileName XXX_S_SparkShock
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Evocation (Electricity)
    Level: Sor/Wiz 2
    Components: V, S, M
    Casting Time: 1 standard action
    Range: Close (8M)
    Effect: Ray
    Target: One object
    Duration: Instantaneous; see text
    Saving Throw: Fortitude Partial
    Spell Resistance: Yes
    Source: Various (Josh_Kablack)

    A ray of crackling sparks projects from your hand. You must succeed at a
    ranged touch attack with the ray to deal damage to a target. The ray deals
    1d8 points of electrical damage +1 point per caster level (maximum +20).
    Additionally, any creature damaged by the ray is stunned for one round
    unless it succeeds at a Fortitude save.

    Material Component: A pinch of iron filings.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Lightning ray to hit, do electical damage, and maybe stun on a fortitude
    save against a creature.

    Simple, really!
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "SMP_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!SMP_SpellHookCheck(SMP_SPELL_SPARK_SHOCK)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = SMP_GetCasterLevel();
    int nMetaMagic = SMP_GetMetaMagicFeat();
    int nSpellSaveDC = SMP_GetSpellSaveDC();
    // Touch attack
    int nTouch = SMP_SpellTouchAttack(SMP_TOUCH_RAY, oTarget, TRUE);
    // 1d8 + Up to +20 more, per caster level.
    int nExtra = SMP_LimitInteger(nCasterLevel, 20);

    // Damage is 1d8 + nExtra
    int nDam = SMP_MaximizeOrEmpower(8, 1, nMetaMagic, nExtra);

    // Get the duration of the stun - 1 round
    float fDuration = SMP_GetDuration(SMP_ROUNDS, 1, nMetaMagic);

    // Delcare effects
    effect eVis = EffectVisualEffect(VFX_IMP_LIGHTNING_M);

    // Declare Stun Effects
    effect eStunVis = EffectVisualEffect(VFX_IMP_STUN);
    effect eStun = EffectStunned();
    effect eDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
    // Link effects
    effect eLink = EffectLinkEffects(eDur, eStun);

    // Signal event
    SMP_SignalSpellCastAt(oTarget, SMP_SPELL_SPARK_SHOCK);

    // Do ray hit/miss
    SMP_ApplyTouchBeam(oTarget, VFX_BEAM_LIGHTNING, nTouch);

    // Touch attack
    if(nTouch)
    {
        // PvP check
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            // Resistance
            if(!SMP_SpellResistanceCheck(oCaster, oTarget))
            {
                // Apply effects
                SMP_ApplyDamageVFXToObject(oTarget, eVis, nDam, DAMAGE_TYPE_ELECTRICAL);

                // Creature needed
                if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
                {
                    // Fortitude save negates
                    if(!SMP_SavingThrow(SAVING_THROW_FORT, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_ELECTRICITY))
                    {
                        // Do the stun for 1 round
                        SMP_ApplyDurationAndVFX(oTarget, eStunVis, eLink, fDuration);
                    }
                }
            }
        }
    }
}
