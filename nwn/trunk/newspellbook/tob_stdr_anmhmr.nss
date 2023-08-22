/*
   ----------------
   Ancient Mountain Hammer

   tob_stdr_anmhmr
   ----------------

   9/10/07 by Tenjac
*/ /** @file Ancient Mountain Hammer
    Stone Dragon (Strike)
    Level: Crusader 7, Swordsage 7, Warblade 7
    Prerequisite: Three Stone Dragon maneuvers
    Initiation Action: 1 Standard Action
    Range: Melee Attack
    Target: One Creature

    You put the weight of a great mountain behind your attack, pounding through armor and bone.
    
    As part of this maneuver, you make a single melee attack. This attack deals an extra 12d6 points of
    damage and automatically overcomes damage reduction.
*/

#include "tob_inc_move"
#include "tob_movehook"
////#include "prc_alterations"

void main()
{
    if (!PreManeuverCastCode())
    {
    // If code within the PreManeuverCastCode (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    object oInitiator    = OBJECT_SELF;
    object oTarget       = PRCGetSpellTargetObject();
    struct maneuver move = EvaluateManeuver(oInitiator, oTarget);

    if(move.bCanManeuver)
    {
        effect eNone = EffectVisualEffect(PSI_IMP_CONCUSSION_BLAST);
        SetLocalInt(oInitiator, "MoveIgnoreDR", TRUE);
        object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator);
        DelayCommand(0.0, PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, d6(12), GetWeaponDamageType(oWeap), "Ancient Mountain Hammer Hit", "Ancient Mountain Hammer Miss"));
        // Cleanup
        DelayCommand(3.0, DeleteLocalInt(oInitiator, "MoveIgnoreDR"));
    }
}