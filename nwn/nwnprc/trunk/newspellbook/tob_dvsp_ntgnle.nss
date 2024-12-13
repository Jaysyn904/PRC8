/*
   ----------------------------
   Reth Dekala Entangling Blade

   tob_dvsp_rthdkln
   ----------------

   2024-12-05 07:55:55 by Jaysyn
*/ /** @file

    Reth Dekala Entangling Blade

    Devoted Spirit (Strike)
    Level: Crusader 4
    Prerequisite: One Devoted Spirit Maneuver
    Initiation Action: 1 Standard Action
    Range: Melee Attack
    Target: One Creature
    Duration: 1 round.

    You hack into your foe's legs, forcing his movement to slow and his resolution to falter.
    
    You make a single attack against an enemy. If this attack hits, you deal 2d6 extra damage, and your foe takes a 20 ft penalty to his movement speed.
*/

#include "tob_inc_move"
#include "tob_movehook"

// Function to handle attack and effects
void TOBAttack(object oTarget, object oInitiator)
{
    effect eNone;
    PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, 0, 0, "Reth Dekala Hit", "Reth Dekala Miss");
    
    if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
    {
        // Apply 2d6 extra damage
        int nBonusDamage = d6(2);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nBonusDamage, DAMAGE_TYPE_SLASHING), oTarget);

        // Apply movement speed penalty and visual effect
        effect eLink = EffectLinkEffects(EffectMovementSpeedDecrease(20), EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE_RED));
               eLink = ExtraordinaryEffect(eLink);
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 6.0); // 6.0 seconds == 1 round
    }
}

// Main function
void main()
{
    if (!PreManeuverCastCode())
    {
        // If code within the PreManeuverCastCode (e.g., UMD) reports FALSE, do not run this maneuver
        return;
    }

    // End of Spell Cast Hook
    object oInitiator    = OBJECT_SELF;
    object oTarget       = PRCGetSpellTargetObject();
    struct maneuver move = EvaluateManeuver(oInitiator, oTarget);

    if (move.bCanManeuver)
    {
        DelayCommand(0.0, TOBAttack(oTarget, oInitiator));
    }
}