//////////////////////////////////////////////////
//  Rabid Bear Strike
//  tob_tgcw_rdber.nss
//  Tenjac  10/19/07
//////////////////////////////////////////////////
/** @file Rabid Bear Strike
Tiger Claw (Strike)
Level: Swordsage 6, warblade 6
Prerequisite: Two Tiger Claw maneuvers
Initiation Action: 1 standard action
Range: Melee attack
Target: One creature

With a ferocious roar, you leap upon your enemy like a wild beast, slamming your 
weapon into her with a madman's fury.

You focus your primal fury into a single attack, laying an opponent low with a mighty
blow that splinters bones and shatters steel. As part of this maneuver, you make a
single melee attack. You gain a +4 bonus on this attack roll and deal an extra 10d6
points of damage. After completing this maneuver, you take a -4 penalty to AC until
the start of your next turn.
*/

#include "tob_inc_move"
#include "tob_movehook" 
#include "prc_inc_combmove" 

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
                object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator);
                effect eNone;
                int nBonus = TOBSituationalAttackBonuses(oInitiator, DISCIPLINE_TIGER_CLAW);
                DelayCommand(0.0, PerformAttack(oTarget, oInitiator, eNone, 0.0, 4 + nBonus, d6(10), GetWeaponDamageType(oWeap), "Rabid Bear Strike Hit", "Rabid Bear Strike Miss"));
                DelayCommand(0.1, TigerBlooded(oInitiator, oTarget));
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectACDecrease(4), oTarget, RoundsToSeconds(1));
        }
}